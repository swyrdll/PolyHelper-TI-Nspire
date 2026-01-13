import sympy as sp
import matplotlib.pyplot as plt
import numpy as np
import ui

x=sp.symbols('x')

def factor_quad(a,b,c,out):
    expr=a*x**2+b*x+c
    out.text=f"Quadratic: {expr}\n"
    D=b**2-4*a*c
    out.text+=f"Discriminant D={D}\n"
    if D<0:
        out.text+="No real roots. Factored (complex): "+str(sp.factor(expr))+"\n"
    else:
        r1=(-b+sp.sqrt(D))/(2*a)
        r2=(-b-sp.sqrt(D))/(2*a)
        out.text+=f"Roots: x1={r1}, x2={r2}\n"
        fact=a*(x-r1)*(x-r2)
        out.text+="Factored form: "+str(fact)+"\n"
        g_pol(fact)

def poly_div(num,den,out):
    n=sum([c*x**i for i,c in enumerate(reversed(num))])
    d=sum([c*x**i for i,c in enumerate(reversed(den))])
    out.text=f"Numerator: {n}\nDenominator: {d}\n\n"
    q=0;r=n
    deg_d=sp.degree(d,x)
    step=1
    while sp.degree(r,x)>=deg_d:
        t=(sp.LC(r,x)/sp.LC(d,x))*x**(sp.degree(r,x)-deg_d)
        q+=t
        s=t*d
        out.text+=f"Step {step}: Divide {sp.LC(r,x)}x^{sp.degree(r,x)}/{sp.LC(d,x)}x^{deg_d}={t}\n"
        out.text+=f"Multiply term: {s}\nSubtract: {r}-{s}\n\n"
        r=r-s
        step+=1
    out.text+=f"Quotient: {q}\nRemainder: {r}\n"
    out.text+=f"Result: {n}/{d}={q}+{r}/{d}\n"

def g_pol(f):
    f_l=sp.lambdify(x,f,'numpy')
    r=[rr.evalf() for rr in sp.solve(f,x) if rr.is_real]
    xmin=min(r)-5 if r else -10
    xmax=max(r)+5 if r else 10
    xv=np.linspace(xmin,xmax,400)
    yv=f_l(xv)
    plt.plot(xv,yv)
    for rr in r: plt.axvline(float(rr),color='r',linestyle='--')
    plt.axhline(0,color='k');plt.grid(True);plt.show()

app=ui.App(title="Polynomial Tool",size=(400,600))
ui.Label(app,text="Quadratic a b c:").pos=(20,20)
a_in=ui.TextInput(app,pos=(20,50),size=(50,25))
b_in=ui.TextInput(app,pos=(80,50),size=(50,25))
c_in=ui.TextInput(app,pos=(140,50),size=(50,25))
out1=ui.TextArea(app,pos=(20,90),size=(350,200))
ui.Button(app,text="Factor Quadratic",pos=(20,300),size=(150,40),
          on_click=lambda btn: factor_quad(float(a_in.text),float(b_in.text),float(c_in.text),out1))
ui.Label(app,text="Poly Div Num Den:").pos=(20,350)
num_in=ui.TextInput(app,pos=(20,380),size=(300,25))
den_in=ui.TextInput(app,pos=(20,410),size=(300,25))
out2=ui.TextArea(app,pos=(20,440),size=(350,150))
ui.Button(app,text="Divide Polynomials",pos=(20,590),size=(150,40),
          on_click=lambda btn: poly_div([int(n) for n in num_in.text.split()],[int(d) for d in den_in.text.split()],out2))
app.run()
