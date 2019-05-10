Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2606119661
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 03:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfEJByf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 21:54:35 -0400
Received: from asrmicro.com ([210.13.118.86]:64131 "EHLO mail2012.asrmicro.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbfEJByf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 21:54:35 -0400
Received: from mail2012.asrmicro.com (10.1.24.123) by mail2012.asrmicro.com
 (10.1.24.123) with Microsoft SMTP Server (TLS) id 15.0.847.32; Fri, 10 May
 2019 09:54:13 +0800
Received: from mail2012.asrmicro.com ([fe80::7c1a:96dd:1a6b:c97b]) by
 mail2012.asrmicro.com ([fe80::7c1a:96dd:1a6b:c97b%16]) with mapi id
 15.00.0847.030; Fri, 10 May 2019 09:54:13 +0800
From:   =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= 
        <hongjiefang@asrmicro.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V2] fscrypt: don't set policy for a dead directory
Thread-Topic: [PATCH V2] fscrypt: don't set policy for a dead directory
Thread-Index: AQHVBYBJy3fqnmNKcU2QpNU9A2v1K6ZiqoQAgADuo8A=
Date:   Fri, 10 May 2019 01:54:12 +0000
Message-ID: <24aabc8896dc4b8c94375a11bd95450f@mail2012.asrmicro.com>
References: <1557307654-673-1-git-send-email-hongjiefang@asrmicro.com>
 <20190509193135.GB42815@gmail.com>
In-Reply-To: <20190509193135.GB42815@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.170.195]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IEZyb206IEVyaWMgQmlnZ2VycyBbbWFpbHRvOmViaWdnZXJzQGtlcm5lbC5vcmddDQo+IFNl
bnQ6IEZyaWRheSwgTWF5IDEwLCAyMDE5IDM6MzIgQU0NCj4gVG86IEZhbmcgSG9uZ2ppZSjmlrnm
tKrmnbApDQo+IENjOiB0eXRzb0BtaXQuZWR1OyBqYWVnZXVrQGtlcm5lbC5vcmc7IGxpbnV4LWZz
Y3J5cHRAdmdlci5rZXJuZWwub3JnOw0KPiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggVjJdIGZzY3J5cHQ6IGRvbid0IHNldCBwb2xpY3kgZm9yIGEgZGVhZCBk
aXJlY3RvcnkNCj4gDQo+IE9uIFdlZCwgTWF5IDA4LCAyMDE5IGF0IDA1OjI3OjM0UE0gKzA4MDAs
IGhvbmdqaWVmYW5nIHdyb3RlOg0KPiA+IHRoZSBkaXJlY3RvcnkgbWF5YmUgaGFzIGJlZW4gcmVt
b3ZlZCB3aGVuIGVudGVyIGZzY3J5cHRfaW9jdGxfc2V0X3BvbGljeSgpLg0KPiA+IGl0IHRoaXMg
Y2FzZSwgdGhlIGVtcHR5X2RpcigpIGNoZWNrIHdpbGwgcmV0dXJuIGVycm9yIGZvciBleHQ0IGZp
bGUgc3lzdGVtLg0KPiA+DQo+ID4gZXh0NF9ybWRpcigpIHNldHMgaV9zaXplID0gMCwgdGhlbiBl
eHQ0X2VtcHR5X2RpcigpIHJlcG9ydHMgYW4gZXJyb3INCj4gPiBiZWNhdXNlICdpbm9kZS0+aV9z
aXplIDwgRVhUNF9ESVJfUkVDX0xFTigxKSArIEVYVDRfRElSX1JFQ19MRU4oMiknLg0KPiA+IGlm
IHRoZSBmcyBpcyBtb3VudGVkIHdpdGggZXJyb3JzPXBhbmljLCBpdCB3aWxsIHRyaWdnZXIgYSBw
YW5pYyBpc3N1ZS4NCj4gPg0KPiA+IGFkZCB0aGUgY2hlY2sgSVNfREVBRERJUigpIHRvIGZpeCB0
aGlzIHByb2JsZW0uDQo+ID4NCj4gPiBGaXhlczogOWJkODIxMmY5ODFlICgiZXh0NCBjcnlwdG86
IGFkZCBlbmNyeXB0aW9uIHBvbGljeSBhbmQgcGFzc3dvcmQgc2FsdA0KPiBzdXBwb3J0IikNCj4g
PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjQuMSsNCj4gPiBTaWduZWQtb2ZmLWJ5
OiBob25namllZmFuZyA8aG9uZ2ppZWZhbmdAYXNybWljcm8uY29tPg0KPiANCj4gUmV2aWV3ZWQt
Ynk6IEVyaWMgQmlnZ2VycyA8ZWJpZ2dlcnNAZ29vZ2xlLmNvbT4NCj4gDQo+IEZZSSwgdGhlIHBh
cnQgb2YgdGhlIEF1dGhvciBhbmQgU2lnbmVkLW9mZi1ieSBsaW5lcyBvdXRzaWRlIHRoZSBlbWFp
bCBhZGRyZXNzDQo+IHNob3VsZCBiZSB5b3VyIG5hbWUgcHJvcGVybHkgZm9ybWF0dGVkLCBub3Qg
dGhlIGVtYWlsIGFkZHJlc3MgYWdhaW4uICBJIHNlZSB0aGUNCj4gZm9sbG93aW5nIGluIGFub3Ro
ZXIga2VybmVsIGNvbW1pdCBmcm9tIHlvdTsgaXMgaXQgY29ycmVjdD8NCj4gDQo+IAlIb25namll
IEZhbmcgPGhvbmdqaWVmYW5nQGFzcm1pY3JvLmNvbT4NCj4gDQo+IElmIHNvLCBwbGVhc2Ugc2V0
IHVzZXIubmFtZSBhY2NvcmRpbmdseSBpbiB5b3VyIC5naXRjb25maWcuICBUaGFua3MhDQoNClRo
YW5rcyBmb3IgeW91ciByZW1pbmRlci4NCkkgd2lsbCB1cGRhdGUgdGhlbS4NCg0KPiANCj4gLSBF
cmljDQo+IA0KPiA+IC0tLQ0KPiA+ICBmcy9jcnlwdG8vcG9saWN5LmMgfCAyICsrDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9mcy9j
cnlwdG8vcG9saWN5LmMgYi9mcy9jcnlwdG8vcG9saWN5LmMNCj4gPiBpbmRleCBiZDdlYWY5Li5h
NGVjYTZlIDEwMDY0NA0KPiA+IC0tLSBhL2ZzL2NyeXB0by9wb2xpY3kuYw0KPiA+ICsrKyBiL2Zz
L2NyeXB0by9wb2xpY3kuYw0KPiA+IEBAIC04MSw2ICs4MSw4IEBAIGludCBmc2NyeXB0X2lvY3Rs
X3NldF9wb2xpY3koc3RydWN0IGZpbGUgKmZpbHAsIGNvbnN0IHZvaWQgX191c2VyDQo+ICphcmcp
DQo+ID4gIAlpZiAocmV0ID09IC1FTk9EQVRBKSB7DQo+ID4gIAkJaWYgKCFTX0lTRElSKGlub2Rl
LT5pX21vZGUpKQ0KPiA+ICAJCQlyZXQgPSAtRU5PVERJUjsNCj4gPiArCQllbHNlIGlmIChJU19E
RUFERElSKGlub2RlKSkNCj4gPiArCQkJcmV0ID0gLUVOT0VOVDsNCj4gPiAgCQllbHNlIGlmICgh
aW5vZGUtPmlfc2ItPnNfY29wLT5lbXB0eV9kaXIoaW5vZGUpKQ0KPiA+ICAJCQlyZXQgPSAtRU5P
VEVNUFRZOw0KPiA+ICAJCWVsc2UNCj4gPiAtLQ0KPiA+IDEuOS4xDQo+ID4NCg==
