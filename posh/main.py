from flask import Flask, render_template, redirect, request, session  
import os
from web import *


app = Flask(__name__)
app.secret_key = os.urandom(69).hex()

#основа
@app.route("/")
def hello_world():
    res = ["login, role"]
    return render_template("index.html", res=res)
def ReturnTikets():
    if ticket == None:
        return ('0')
    return redirect('tickets')



@app.route('/')
def index():
    if session.get('user') == None:
        return redirect('/reg')
    return redirect('/lk')


#регистрация
@app.route('/reg', methods=['POST', 'GET'])
def reg():
    if session.get('user') == None:
        if request.method == "POST":       
            acc = request.form.get('acc')
            key = request.form.get('key')
            fio = request.form.get('fio').split(",")
            Email = request.form.get('Email')
            DataR = request.form.get('DataR')
            Password = request.form.get('Password')
            res = registr(acc, key, fio, Email, DataR, Password) 
            if type(res) == str: 
                return f"error: {res}"
            session['account'] = acc
            return redirect('/auth')
        else:
            return render_template('reg.html')
    else:
        return redirect('/lk')


#авторизация
@app.route('/auth', methods=['POST', 'GET'])
def authg():
        if session.get('user') == None:
            if request.method == "POST":
                acc = request.form.get('acc')
                Email = request.form.get('Email')
                Password = request.form.get('Password')
                res = auth(acc, Email, Password)
                if type(res) == str: 
                        return f"error: {res}"                
                session['user'] = res
                return redirect('/lk')
            else:
                return render_template('auth.html')
        else:
            return redirect('/')

           
#личный кабинет
@app.route('/lk')
def lk():
    if session.get('user') != None:
        return render_template('lk.html', res=session.get('user'))
    return redirect('/')    


@app.route("/ticket")
def ticket():
    if session.get('myticket') == None:
        return render_template("ticket.html", trashs=session.get('myticket'), totalsum=session.get('tickettotalsum'), user=session.get('user'))
    trash = list(session.get('myticket'))
    if trash == []:
        session['myticket'] = None
    sum = 0
    for product in trash:
        sum += product[-2]
    session['tickettotalsum'] = sum
    return render_template("ticket.html", trashs=session.get('myticket'), totalsum=session.get('tickettotalsum'), user=session.get('user'))


@app.route('/bay')
def bayshop():
    if session.get('user') == None:
            if request.method == "POST":
                key = request.form.get('key')
                res = bayshop(key)
                if type(res) == str: 
                        return f"error: {res}"                
                session['user'] = res
                return redirect('/lk')
            else:
                return render_template('bay.html')
    else:
        return redirect('/')




@app.route('/exit')
def exit():
    if session.get('user') != None:
        session.pop('user', None)
    return redirect('/')


#создание авиа рейса
@app.route('/addNewAir')
def aviaReis():
    if session.get('user') != None:
        return render_template('addNewAir', res=session.get('admin'))
    return redirect('/lk')

#@app.route('/lk')
#def AddNewManager():
    if session.get('user') !=None:
        return render_template('AddNewManager', res=session.get('admin'))
    return redirect('/lk')

if __name__ == "__main__":
    app.run(debug=True, port=3414)
