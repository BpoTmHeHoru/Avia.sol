import re
from tkinter import W
from web3 import Web3
import json
data = json.load(open('./data.json'))
w3 = Web3(Web3.HTTPProvider("http://192.168.43.111:8545"))

contract = w3.eth.contract(address=data['address'], abi=data['abi'])

print(contract.all_functions())


if w3.isConnected:
    print('Ок')


def unlock(acc, key):
    account = Web3.toChecksumAddress(acc)
    w3.eth.default_account = account
    w3.geth.personal.unlock_account(account, key,  10)

def lock(acc):
    try:
        acc = w3.toChecksumAddress(acc)
        w3.geth.personal.lock_account(acc)
    except Exception as e:
        return str(e)    


def registr(acc, key, Email, fio, DataR, Password):
    try:
        unlock(acc, key)
        res =  contract.functions.Registr( Email, Password, fio, DataR).transact()
        return res
    except Exception as e:
        return str(e)

def auth(acc, Email, Password):
    try:
        w3.eth.default_account = w3.toChecksumAddress(acc)
        res = contract.functions.Auth(Email, Password).call()
        return res
    except Exception as e:
        return str(e)
        

def checkprice(id):
    try:
        w3.eth.default_account = w3.eth.accounts[0]
        price = contract.functions.CheckPrice(id).call()
        return [price, None]
    except Exception as e:
        return [None, str(e)]


def returntikets():
    try: 
        w3.eth.default_account = w3.eth.account[0]
        tickets = contract.functions.ReturnTikets().call()
        return [tickets, None]
    except Exception as e:
        return [None, str(e)]


def gethistorybuy(acc):
    try:
        w3.eth.default_account = w3.toChecksumAddress(acc)
        history = contract.functions.GetHistoryBuy().call()
        return [history, None]
    except Exception as e:
        return [None, str(e)]


#добавление
#def addproduct(acc, key, title, desc, price):
    try:
        w3.eth.default_account = w3.toChecksumAddress(acc)
        unlock(acc, key)
        contract.functions.AddProduct(title, desc, w3.toWei(float(price), "ether")).transact()
        lock(acc)
        return True
    except Exception as e:
        return str(e)#


def Buyproduct(acc, key, product, fullprice):
    try:
        w3.eth.default_account = w3.toChecksumAddress(acc)
        unlock(acc, key)
        contract.functions.BuyProduct(product, fullprice).transact()
        lock(acc)
        return True
    except Exception as e:
        return str(e)
