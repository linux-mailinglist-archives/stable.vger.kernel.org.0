Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FBB188A3
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 13:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEILFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 07:05:14 -0400
Received: from asrmicro.com ([210.13.118.86]:16763 "EHLO mail2012.asrmicro.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfEILFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 07:05:14 -0400
Received: from mail2012.asrmicro.com (10.1.24.123) by mail2012.asrmicro.com
 (10.1.24.123) with Microsoft SMTP Server (TLS) id 15.0.847.32; Thu, 9 May
 2019 19:04:50 +0800
Received: from mail2012.asrmicro.com ([fe80::7c1a:96dd:1a6b:c97b]) by
 mail2012.asrmicro.com ([fe80::7c1a:96dd:1a6b:c97b%16]) with mapi id
 15.00.0847.030; Thu, 9 May 2019 19:04:50 +0800
From:   =?utf-8?B?RmFuZyBIb25namllKOaWuea0quadsCk=?= 
        <hongjiefang@asrmicro.com>
To:     Sasha Levin <sashal@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V2] fscrypt: don't set policy for a dead directory
Thread-Topic: [PATCH V2] fscrypt: don't set policy for a dead directory
Thread-Index: AQHVBYBJy3fqnmNKcU2QpNU9A2v1K6Zg2/aAgAHDQmA=
Date:   Thu, 9 May 2019 11:04:50 +0000
Message-ID: <a38236b96095470aa1da3960b113a5e2@mail2012.asrmicro.com>
References: <1557307654-673-1-git-send-email-hongjiefang@asrmicro.com>
 <20190508155604.1B59820989@mail.kernel.org>
In-Reply-To: <20190508155604.1B59820989@mail.kernel.org>
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

DQo+IEZyb206IFNhc2hhIExldmluIFttYWlsdG86c2FzaGFsQGtlcm5lbC5vcmddDQo+IFNlbnQ6
IFdlZG5lc2RheSwgTWF5IDA4LCAyMDE5IDExOjU2IFBNDQo+IFRvOiBTYXNoYSBMZXZpbjsgRmFu
ZyBIb25namllKOaWuea0quadsCk7IHR5dHNvQG1pdC5lZHU7IGphZWdldWtAa2VybmVsLm9yZzsN
Cj4gZWJpZ2dlcnNAa2VybmVsLm9yZw0KPiBDYzogbGludXgtZnNjcnlwdEB2Z2VyLmtlcm5lbC5v
cmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMl0gZnNj
cnlwdDogZG9uJ3Qgc2V0IHBvbGljeSBmb3IgYSBkZWFkIGRpcmVjdG9yeQ0KPiANCj4gSGksDQo+
IA0KPiBbVGhpcyBpcyBhbiBhdXRvbWF0ZWQgZW1haWxdDQo+IA0KPiBUaGlzIGNvbW1pdCBoYXMg
YmVlbiBwcm9jZXNzZWQgYmVjYXVzZSBpdCBjb250YWlucyBhICJGaXhlczoiIHRhZywNCj4gZml4
aW5nIGNvbW1pdDogOWJkODIxMmY5ODFlIGV4dDQgY3J5cHRvOiBhZGQgZW5jcnlwdGlvbiBwb2xp
Y3kgYW5kIHBhc3N3b3JkIHNhbHQNCj4gc3VwcG9ydC4NCj4gDQo+IFRoZSBib3QgaGFzIHRlc3Rl
ZCB0aGUgZm9sbG93aW5nIHRyZWVzOiB2NS4wLjEzLCB2NC4xOS40MCwgdjQuMTQuMTE2LCB2NC45
LjE3MywgdjQuNC4xNzkuDQo+IA0KPiB2NS4wLjEzOiBCdWlsZCBPSyENCj4gdjQuMTkuNDA6IEJ1
aWxkIE9LIQ0KPiB2NC4xNC4xMTY6IEJ1aWxkIE9LIQ0KPiB2NC45LjE3MzogRmFpbGVkIHRvIGFw
cGx5ISBQb3NzaWJsZSBkZXBlbmRlbmNpZXM6DQo+ICAgICBVbmFibGUgdG8gY2FsY3VsYXRlDQo+
IA0KPiB2NC40LjE3OTogRmFpbGVkIHRvIGFwcGx5ISBQb3NzaWJsZSBkZXBlbmRlbmNpZXM6DQo+
ICAgICAwMDJjZWQ0YmU2NDIgKCJmc2NyeXB0bzogb25seSBhbGxvdyBzZXR0aW5nIGVuY3J5cHRp
b24gcG9saWN5IG9uIGRpcmVjdG9yaWVzIikNCj4gICAgIDBiODFkMDc3OTA3MiAoImZzIGNyeXB0
bzogbW92ZSBwZXItZmlsZSBlbmNyeXB0aW9uIGZyb20gZjJmcyB0cmVlIHRvIGZzL2NyeXB0byIp
DQo+ICAgICAwY2FiODBlZTBjOWUgKCJmMmZzOiBmaXggdG8gY29udmVydCBpbmxpbmUgaW5vZGUg
aW4gLT5zZXRhdHRyIikNCj4gICAgIDBmYWMyZDUwMWIwZCAoImYyZnMgY3J5cHRvOiBmaXggc3Bl
bGxpbmcgdHlwbyBpbiBjb21tZW50IikNCj4gICAgIDBmZDc4NWViOTMxZCAoImYyZnM6IHJlbG9j
YXRlIGlzX21lcmdlZF9wYWdlIikNCj4gICAgIDFkYWZhNTFkNDVjNiAoImYyZnMgY3J5cHRvOiBj
aGVjayBmb3IgdG9vLXNob3J0IGVuY3J5cHRlZCBmaWxlIG5hbWVzIikNCj4gICAgIDM2YjM1YTBk
YmU5MCAoImYyZnM6IHN1cHBvcnQgZGF0YSBmbHVzaCBpbiBiYWNrZ3JvdW5kIikNCj4gICAgIDU1
ZDFjZGIyNWE4MSAoImYyZnM6IHJlbG9jYXRlIHRyYWNlcG9pbnQgb2Ygd3JpdGVfY2hlY2twb2lu
dCIpDQo+ICAgICA2YjI1NTM5MThkOGIgKCJyZXBsYWNlIC0+Zm9sbG93X2xpbmsoKSB3aXRoIG5l
dyBtZXRob2QgdGhhdCBjb3VsZCBzdGF5IGluDQo+IFJDVSBtb2RlIikNCj4gICAgIDZiZWNlYjU0
MjdhYSAoImYyZnM6IGludHJvZHVjZSB0aW1lIGFuZCBpbnRlcnZhbCBmYWNpbGl0eSIpDQo+ICAg
ICA4ZGMwZDZhMTFlN2QgKCJmMmZzOiBlYXJseSBjaGVjayBicm9rZW4gc3ltbGluayBsZW5ndGgg
aW4gdGhlIGVuY3J5cHRlZCBjYXNlIikNCj4gICAgIDkyMmVjMzU1Zjg2MyAoImYyZnMgY3J5cHRv
OiBhdm9pZCB1bm5lZWRlZCBtZW1vcnkgYWxsb2NhdGlvbiB3aGVuDQo+IHtlbi9kZX1jcnlwdGlu
ZyBzeW1saW5rIikNCj4gICAgIDllODkyNWI2N2E4MCAoImxvY2tzOiBBbGxvdyBkaXNhYmxpbmcg
bWFuZGF0b3J5IGxvY2tpbmcgYXQgY29tcGlsZSB0aW1lIikNCj4gICAgIGEyNjM2NjlmYTE4ZiAo
ImYyZnMgY3J5cHRvOiBzeW5jIHdpdGggZXh0NCdzIGZuYW1lIHBhZGRpbmciKQ0KPiAgICAgYWUx
MDg2Njg2NDg3ICgiZjJmcyBjcnlwdG86IGhhbmRsZSB1bmV4cGVjdGVkIGxhY2sgb2YgZW5jcnlw
dGlvbiBrZXlzIikNCj4gICAgIGI5ZDc3N2I4NWZmMSAoImYyZnM6IGNoZWNrIGlubGluZV9kYXRh
IGZsYWcgYXQgY29udmVydGluZyB0aW1lIikNCj4gICAgIGNlODU1YTNiZDA5MiAoImYyZnMgY3J5
cHRvOiBmMmZzX3BhZ2VfY3J5cHRvKCkgZG9lc24ndCBuZWVkIGEgZW5jcnlwdGlvbg0KPiBjb250
ZXh0IikNCj4gICAgIGQwMjM5ZTFiZjUyMCAoImYyZnM6IGRldGVjdCBpZGxlIHRpbWUgZGVwZW5k
aW5nIG9uIHVzZXIgYmVoYXZpb3IiKQ0KPiAgICAgZDMyM2QwMDVhYzRhICgiZjJmczogc3VwcG9y
dCBmaWxlIGRlZnJhZ21lbnQiKQ0KPiAgICAgZGZmZDBjZmEwNmQ0ICgiZnNjcnlwdDogdXNlIEVO
T1RESVIgd2hlbiBzZXR0aW5nIGVuY3J5cHRpb24gcG9saWN5IG9uDQo+IG5vbmRpcmVjdG9yeSIp
DQo+ICAgICBlZDMzNjBhYmJjMDQgKCJmMmZzIGNyeXB0bzogbWFrZSBzdXJlIHRoZSBlbmNyeXB0
aW9uIGluZm8gaXMgaW5pdGlhbGl6ZWQgb24NCj4gb3BlbmRpcigyKSIpDQo+IA0KPiANCj4gSG93
IHNob3VsZCB3ZSBwcm9jZWVkIHdpdGggdGhpcyBwYXRjaD8NCg0KVGhlcmUgaXMgbm90IGEgImZz
L2NyeXB0byIgZGlyZWN0b3J5IGZvciBrZXJuZWwgdjQuNC4xNzkuDQpQZXJoYXBzIGl0IGlzIG5v
dCBzdGlsbCBuZWNlc3NhcnkgdG8gdGVzdCBpdCBvbiB0aGlzIHRyZWUuDQoNCj4gDQo+IC0tDQo+
IFRoYW5rcywNCj4gU2FzaGENCg0KDQpCJlINCkhvbmdqaWUNCg==
