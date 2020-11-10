Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029582AD2EF
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 10:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKJJ5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 04:57:31 -0500
Received: from mail.kingsoft.com ([114.255.44.146]:22048 "EHLO
        mail.kingsoft.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726462AbgKJJ5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 04:57:31 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2020 04:57:29 EST
X-AuditID: 0a580157-b0dff70000003991-22-5faa5d2e22ef
Received: from mail.kingsoft.com (localhost [10.88.1.32])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mail.kingsoft.com (SMG-1-NODE-87) with SMTP id A4.70.14737.E2D5AAF5; Tue, 10 Nov 2020 17:28:14 +0800 (HKT)
Received: from KSBJMAIL2.kingsoft.cn (10.88.1.32) by KSBJMAIL2.kingsoft.cn
 (10.88.1.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 10 Nov
 2020 17:42:21 +0800
Received: from KSBJMAIL2.kingsoft.cn ([fe80::bcc5:49cb:ddf0:357e]) by
 KSBJMAIL2.kingsoft.cn ([fe80::bcc5:49cb:ddf0:357e%3]) with mapi id
 15.01.1979.006; Tue, 10 Nov 2020 17:42:21 +0800
From:   =?utf-8?B?eWFvYWlsaSBb5LmI54ix5YipXQ==?= <yaoaili@kingsoft.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "yaoaili126@163.com" <yaoaili126@163.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] ACPI, APEI, Fix error return value in
 apei_map_generic_address()
Thread-Topic: [PATCH] ACPI, APEI, Fix error return value in
 apei_map_generic_address()
Thread-Index: AQHWtzumP5kA9JmkCU6kcGF5h349nKnAkJIAgACIYtA=
Date:   Tue, 10 Nov 2020 09:42:21 +0000
Message-ID: <3fcd32bf58204b26915474fab652e6bb@kingsoft.com>
References: <20201110082942.456745-1-yaoaili126@163.com>
 <X6pbGq24Gta7Go0t@kroah.com>
In-Reply-To: <X6pbGq24Gta7Go0t@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.253.254]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsXCFcGooKsXuyre4PdGA4vmxevZLBZsfMRo
        serrW0YHZo/FK6aweuyfu4bd4/MmuQDmKC6blNSczLLUIn27BK6M23eushW8EKz4P2chawPj
        GsEuRg4OCQETiclvvLsYOTmEBKYzSaxfl9vFyAVkP2eUWDz5IxuEs4dR4v+9M2wgVWwCrhJ/
        t35gBLFFBEIlbn17zwpiMwuYSkz79JAFxBYWCJd40/CJDaImQuLCrGPMIMtEBKwkHm5XBgmz
        CKhKnJ52C6yEV8Ba4u7UCewQR4RLHFl9HyzOKaApsWH5SyYQm1FAVmLao/tMEKvEJeZOmwW2
        VkJAQGLJnvPMELaoxMvH/6DiShKL5/xmAlnLDDRn/S59iFZFiSndD9kh1gpKnJz5hGUCo9gs
        JFNnIXTMQtIxC0nHAkaWVYwsxbnphpsYIZESvoNxXtNHvUOMTByMhxglOJiVRHid/q2IF+JN
        SaysSi3Kjy8qzUktPsQozcGiJM77b9K0eCGB9MSS1OzU1ILUIpgsEwenVAOT0jar7UlZJ2JK
        aw//Wi5re/FnAc8ii8A7zkunK7YpKSffT5CNtJX1bN0mf9bMoWDW37D7UdV/opbGOpx6/OtC
        U/4VU5vibx9kZzDsCA+9YfTdYukJs9TN1n3LmGqyDpTHFZnzdDyOu3x6tqL2pBtRTCUW6cG3
        7wqZvFzQFrRp8Z1WxbwNu++/EXv70GfVt4W2D3cYH7q+9ka/n8w2FjvjRZXKJsctZ699zmpl
        8OHMsc3X5k6drckQZHLiSMPlqNpIvtm9ry3WnlDIPb721p7o9+VmDS9zzs7eY+meeHNu6hG1
        Vu6MFU1/hG7dq5pdOl2Lpair5Jb/BvNpixnD+/K3c8tbdf1pmOiT0Tuv/sJeJZbijERDLeai
        4kQAqm/AlgMDAAA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

U29ycnkgZm9yIGNvbmZ1c2luZy4gSSBhbSByZWFsbHkgbmV3IHRvIGtlcm5lbCBjb21tdW5pdHkh
DQpJIHNob3VsZCBqdXN0IGFkZCB0aGUgdGFnICdDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+
JyAsIG5vdCByZWFsbHkgY2MgdG8gc3RhYmxlQHZnZXIua2VybmVsLm9yZw0Kc29ycnkgZm9yIHRo
aXMhDQoNCkJlc3QgUmVnYXJkcyENCg0KQWlsaSBZYW8NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEtIIFttYWlsdG86Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5v
cmddDQo+IFNlbnQ6IFR1ZXNkYXksIE5vdmVtYmVyIDEwLCAyMDIwIDU6MTkgUE0NCj4gVG86IHlh
b2FpbGkxMjZAMTYzLmNvbQ0KPiBDYzogeWFvYWlsaSA8eWFvYWlsaUBraW5nc29mdC5jb20+OyBz
dGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIEFDUEksIEFQRUks
IEZpeCBlcnJvciByZXR1cm4gdmFsdWUgaW4NCj4gYXBlaV9tYXBfZ2VuZXJpY19hZGRyZXNzKCkN
Cj4gDQo+IE9uIFR1ZSwgTm92IDEwLCAyMDIwIGF0IDEyOjI5OjQyQU0gLTA4MDAsIHlhb2FpbGkx
MjZAMTYzLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBBaWxpIFlhbyA8eWFvYWlsaUBraW5nc29mdC5j
b20+DQo+ID4NCj4gPiA+RnJvbSBjb21taXQgNjkxNTU2NGRjNWE4ICgiQUNQSTogT1NMOiBDaGFu
Z2UgdGhlIHR5cGUgb2YNCj4gPiBhY3BpX29zX21hcF9nZW5lcmljX2FkZHJlc3MoKSByZXR1cm4g
dmFsdWUiKSwNCj4gPiBhY3BpX29zX21hcF9nZW5lcmljX2FkZHJlc3MoKSB3aWxsIHJldHVybiBs
b2dpY2FsIGFkZHJlc3Mgb3IgTlVMTCBmb3INCj4gPiBlcnJvciwgYnV0IGZvciBBQ1BJX0FEUl9T
UEFDRV9TWVNURU1fSU8gY2FzZSwgaXQgc2hvdWxkIGJlIGFsc28gcmV0dXJuDQo+ID4gMCwgYXMg
aXQncyBhIG5vcm1hbCBjYXNlLCBidXQgbm93IGl0IHdpbGwgcmV0dXJuIC1FTlhJTy4gc28gY2hl
Y2sgaXQNCj4gPiBvdXQgZm9yIHN1Y2ggY2FzZSB0byBhdm9pZCBlaW5qIG1vZHVsZSBpbml0aWFs
aXphdGlvbiBmYWlsLg0KPiA+DQo+ID4gRml4ZXM6IDY5MTU1NjRkYzVhOCAoIkFDUEk6IE9TTDog
Q2hhbmdlIHRoZSB0eXBlIG9mDQo+ID4gYWNwaV9vc19tYXBfZ2VuZXJpY19hZGRyZXNzKCkgcmV0
dXJuIHZhbHVlIikNCj4gPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+ID4gUmV2aWV3
ZWQtYnk6IEphbWVzIE1vcnNlIDxqYW1lcy5tb3JzZUBhcm0uY29tPg0KPiA+IFRlc3RlZC1ieTog
VG9ueSBMdWNrIDx0b255Lmx1Y2tAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFpbGkg
WWFvIDx5YW9haWxpQGtpbmdzb2Z0LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9hY3BpL2Fw
ZWkvYXBlaS1iYXNlLmMgfCA0ICsrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKQ0KPiANCj4gSSdtIGNvbmZ1c2VkIGFzIHRvIHdoYXQgeW91IGFyZSBhc2tpbmcgdXMgdG8g
ZG8gd2l0aCB0aGlzIHBhdGNoPyAgSGF2ZSB5b3UNCj4gcmVhZDoNCj4gICAgIGh0dHBzOi8vd3d3
Lmtlcm5lbC5vcmcvZG9jL2h0bWwvbGF0ZXN0L3Byb2Nlc3Mvc3RhYmxlLWtlcm5lbC1ydWxlcy5o
dG1sDQo+IGZvciBob3cgdG8gZG8gdGhpcyBwcm9wZXJseT8NCj4gDQo+IHRoYW5rcywNCj4gDQo+
IGdyZWcgay1oDQo=
