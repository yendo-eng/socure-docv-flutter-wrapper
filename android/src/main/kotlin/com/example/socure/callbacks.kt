package com.example.socure

interface DocVSuccessCallBack {
    fun invoke(data: String)
}

interface DocVErrorCallBack {
    fun invoke(data: String)
}

interface FingerprintSuccessCallBack {
    fun invoke(data: String)
}

interface FingerprintErrorCallBack {
    fun invoke(data: String)
}