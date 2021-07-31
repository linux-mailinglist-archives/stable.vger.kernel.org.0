Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845233DC2AF
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 04:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhGaCEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 22:04:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12429 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhGaCEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 22:04:14 -0400
Received: from dggeme701-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gc6t90J0Czcjxq;
        Sat, 31 Jul 2021 10:00:33 +0800 (CST)
Received: from dggeme756-chm.china.huawei.com (10.3.19.102) by
 dggeme701-chm.china.huawei.com (10.1.199.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 31 Jul 2021 10:04:03 +0800
Received: from dggeme756-chm.china.huawei.com ([10.6.80.68]) by
 dggeme756-chm.china.huawei.com ([10.6.80.68]) with mapi id 15.01.2176.012;
 Sat, 31 Jul 2021 10:04:03 +0800
From:   "wangliang (C)" <wangliang101@huawei.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     "palmerdabbelt@google.com" <palmerdabbelt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wangle (RTOS FAE)" <wangle6@huawei.com>,
        "Chenxin (RTOS)" <kepler.chenxin@huawei.com>,
        Nixiaoming <nixiaoming@huawei.com>,
        "Wangkefeng (OS Kernel Lab)" <wangkefeng.wang@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHYyXSBsaWI6IFVzZSBQRk5fUEhZUygpIGluIGRldm1l?=
 =?gb2312?B?bV9pc19hbGxvd2VkKCk=?=
Thread-Topic: [PATCH v2] lib: Use PFN_PHYS() in devmem_is_allowed()
Thread-Index: AQHXhRaSauys7qng8E6jm3dZNQrM0qtbZC6AgADu4jA=
Date:   Sat, 31 Jul 2021 02:04:02 +0000
Message-ID: <6ce22e64615846968533b7d920bc431d@huawei.com>
References: <20210730074315.63232-1-wangliang101@huawei.com>
 <YQRUz9Uw9nfiLcgr@bombadil.infradead.org>
In-Reply-To: <YQRUz9Uw9nfiLcgr@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.101.54]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SSdtIGdsYWQgdG8gZ2V0IHRoZSByZXBseS4NCkkgZm91bmQgdGhpcyBwcm9ibGVtIG5vdCBvbmx5
IHdpdGggdGhlIGFybSwgYnV0IGFsc28gd2l0aCB0aGUgeDg2LiBJcyBpdCBnb29kIHRvIGZpeGVk
IGJvdGggaW4gb25seSBvbmUgcGF0Y2g/IEkgZm91bmQgdGhpcyBwcm9ibGVtIGluIGFjdHVhbCB3
b3JrLiBXaGVuIENPTkZJR19TVFJJQ1RfREVWTUVNIGlzIGVuYWJsZWQgb24gdGhlIEFSTSBhbmQg
ZGV2bWVtIGlzIHVzZWQgdG8gbWFwIGEgaGlnaCBhZGRyZXNzIHRoYXQgaXMgbm90IGluIHRoZSBp
b21lbSBhZGRyZXNzIHJhbmdlLCBhbiB1bmV4cGVjdGVkIGVycm9yIGluZGljYXRpbmcgbm8gcGVy
bWlzc2lvbiBpcyByZXR1cm5lZC4gVGhlbiBpIGZpbmQgdGhlIGJ1Zy4NCg0KLS0tLS3Tyrz+1K28
/i0tLS0tDQq3orz+yMs6IEx1aXMgQ2hhbWJlcmxhaW4gW21haWx0bzptY2dyb2ZAaW5mcmFkZWFk
Lm9yZ10gtPqx7SBMdWlzIENoYW1iZXJsYWluDQq3osvNyrG85DogMjAyMcTqN9TCMzHI1SAzOjM3
DQrK1bz+yMs6IHdhbmdsaWFuZyAoQykgPHdhbmdsaWFuZzEwMUBodWF3ZWkuY29tPg0Ks63LzTog
cGFsbWVyZGFiYmVsdEBnb29nbGUuY29tOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsgbGludXhAYXJtbGludXgub3JnLnVrOyBsaW51eC1h
cm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IFdh
bmdsZSAoUlRPUyBGQUUpIDx3YW5nbGU2QGh1YXdlaS5jb20+OyBDaGVueGluIChSVE9TKSA8a2Vw
bGVyLmNoZW54aW5AaHVhd2VpLmNvbT47IE5peGlhb21pbmcgPG5peGlhb21pbmdAaHVhd2VpLmNv
bT47IFdhbmdrZWZlbmcgKE9TIEtlcm5lbCBMYWIpIDx3YW5na2VmZW5nLndhbmdAaHVhd2VpLmNv
bT4NCtb3zOI6IFJlOiBbUEFUQ0ggdjJdIGxpYjogVXNlIFBGTl9QSFlTKCkgaW4gZGV2bWVtX2lz
X2FsbG93ZWQoKQ0KDQpPbiBGcmksIEp1bCAzMCwgMjAyMSBhdCAwMzo0MzoxNVBNICswODAwLCBM
aWFuZyBXYW5nIHdyb3RlOg0KPiBUaGUgcGh5c2ljYWwgYWRkcmVzcyBtYXkgZXhjZWVkIDMyIGJp
dHMgb24gQVJNKHdoZW4gQVJNX0xQQUUgZW5hYmxlZCksIA0KPiB1c2UgUEZOX1BIWVMoKSBpbiBk
ZXZtZW1faXNfYWxsb3dlZCgpLA0KDQpGaXJzdCBvZmYsIGdvb2QgY2F0Y2ghDQoNClRoaXMgc2hv
dWxkIG5vdCBiZSBBUk0gc3BlY2lmaWMsIHRoaXMgc2hvdWxkIGp1c3Qgc2F5Og0KDQpvbiAzMi1i
aXQgc3lzdGVtcyB3aXRoIG1vcmUgdGhhbiAzMiBiaXRzIG9mIHBoeXNjaWFsIGFkZHJlc3MNCg0K
QWxzbywgdG93YXJkcyB0aGVuIGVuZCB0aGVuIGV4cGxhaW4gdGhhdCBpbiBwcmFjdGljZSwgeWVz
LCB0aGlzIGlzIHByb2JhYmx5IGp1c3QgQVJNIHdoaWNoIGlzIGFmZmVjdGVkLiBCeSBleHBsYWlu
aW5nIHRoaXMsIGl0IGVuc3VyZXMgZm9sa3MgYXJlIGF3YXJlIG9mIHRoZSBhZmZlY3RlZCBzeXN0
ZW1zLg0KDQpNYXkgYmUgZ29vZCB0byByZWZlciB0byBjb21taXQgOTQ3ZDA0OTZjZjNlMSAoImdl
bmVyaWM6IG1ha2UgUEZOX1BIWVMgZXhwbGljaXRseSByZXR1cm4gcGh5c19hZGRyX3QiKSB3aGlj
aCBhZGRlZCB0aGUgb3JpZ2luYWwgUEZOX1BIWVMoKSBjYXN0aW5nIHRvIHBoeXNfYWRkcl90IHRv
IHJlc29sdmUgdGhlIHNhbWUgcHJvYmxlbS4NCg0KPiBvciB0aGUgcGh5c2ljYWwgYWRkcmVzcyBt
YXkgb3ZlcmZsb3cgYW5kIGJlIHRydW5jYXRlZC4NCg0KSW5kZWVkLiBIb3cgZGlkIHlvdSBmaW5k
IHRoaXMgaXNzdWU/IENhbiB5b3UgZGVzY3JpYmUgdGhhdCBpbiB0aGUgY29tbWl0IGxvZz8gV2Fz
IGl0IGEgcmVhbCB3b3JsZCBpc3N1ZSBvciBkaWQgeW91IGRvIGp1c3QgY29kZSBpbnNwZWN0aW9u
PyBPciB3YXMgdGhlcmUgYSBib3Qgd2hpY2ggaGVscGVkIHlvdT8NCg0KPiBUaGlzIGJ1ZyB3YXMg
aW5pdGlhbGx5IGludHJvZHVjZWQgZnJvbSB2Mi42LjM3LCBhbmQgdGhlIGZ1bmN0aW9uIHdhcyAN
Cj4gbW92ZWQgdG8gbGliIHdoZW4gdjUuMTEuDQo+IA0KPiBGaXhlczogMDg3YWFmZmNkZjljICgi
QVJNOiBpbXBsZW1lbnQgQ09ORklHX1NUUklDVF9ERVZNRU0gYnkgZGlzYWJsaW5nIA0KPiBhY2Nl
c3MgdG8gUkFNIHZpYSAvZGV2L21lbSIpDQo+IEZpeGVzOiA1Mjc3MDFlZGE1ZjEgKCJsaWI6IEFk
ZCBhIGdlbmVyaWMgdmVyc2lvbiBvZiANCj4gZGV2bWVtX2lzX2FsbG93ZWQoKSIpDQo+IENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnICMgdjIuNi4zNw0KPiBTaWduZWQtb2ZmLWJ5OiBMaWFuZyBX
YW5nIDx3YW5nbGlhbmcxMDFAaHVhd2VpLmNvbT4NCg0KT3RoZXIgdGhhbiB0aGF0Og0KDQpSZXZp
ZXdlZC1ieTogTHVpcyBDaGFtYmVybGFpbiA8bWNncm9mQGtlcm5lbC5vcmc+DQoNCiAgTHVpcw0K
