Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5F5153F07
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBFHA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:00:59 -0500
Received: from mail-db8eur05on2138.outbound.protection.outlook.com ([40.107.20.138]:26132
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727803AbgBFHA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 02:00:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DK36Prbnb9570VtIKFbiA91L/FTzfNiL8TEsDmfKHoK9Zq3ScG1n+uD2G709uafJl4NpSTpgd30gmcTCOz9XJJuAIomtHIXjA/GL1+0VXiLAK0eE68poy4y7WvoEW5E1S/msbtzmY998hj6Vytg18OoAJ8l69RRIkjyo5f7ROVWyjEjl7fGXtCrONrqCGXCNnf34ahDAlorJ9kT+4h+v97aqK02Qicvdyr0vc8dukoYjKYwa05AfBwxgEu/2XOM45pHMwft+LA9QU+Hx4C+LhriSFHnC2QPXwK0Sz/f/Qgp6wauz7Z4esIzZq2qHb7iVsaBrpFOLrk/eAoTgfWQlwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5hrxsUGS0Q/D5JQiZsn8L7EU63mXlIEV6E7E8H8ZQw=;
 b=Bs891m/WWQhITXqTKa0jTCXPLlhPVg+rpVENnqK7tdv0kWbJfPzMYVsUtuy4P1+Vt5xZfAlmt+GJB6igf3VZHuJY5ZEqL+9krN+zx5H0Uk5nR1mOJhGoBo7ytYICNqVTLP2QkYe3xa5oBeexwvYoqN253E+I8HlkYQwYi0jOCAdkGRJLeECsNLbbOK3JVlUIWU2r8RbFIaJUXfoD1awtcSeilzQE7kAvX/+HKPyY5fQ5t42mBEZlX/S8vAd1Mg2I7qQ22gC0F8eoMnwnC6AZAwaZLX3RXNXUg7jOb0lI2oY3qj7Brr5u8e+qCOJs1zTe/AsGOWluq9xatD4PRncLwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector2-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5hrxsUGS0Q/D5JQiZsn8L7EU63mXlIEV6E7E8H8ZQw=;
 b=KeUSRx4wTbw4yB/tVHM0BpkDS8FHoEFOlUUPCZ1GFJ7YA/8iD9jprOSwEBpyE9sqQMDqx1fH8Fkoba9bSyFp/QAMLOCbqQFtl418Bx3RbzTmA11zGI9f9W4balgdk/hRa9XgvKTqyuWiTG/DfVZRFXmpkxL6l9cAPvYCRHs99QU=
Received: from AM0P193MB0481.EURP193.PROD.OUTLOOK.COM (10.186.191.85) by
 AM0P193MB0308.EURP193.PROD.OUTLOOK.COM (52.134.95.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Thu, 6 Feb 2020 07:00:52 +0000
Received: from AM0P193MB0481.EURP193.PROD.OUTLOOK.COM
 ([fe80::dc77:cc73:f061:36d2]) by AM0P193MB0481.EURP193.PROD.OUTLOOK.COM
 ([fe80::dc77:cc73:f061:36d2%6]) with mapi id 15.20.2707.020; Thu, 6 Feb 2020
 07:00:52 +0000
From:   "Enderborg, Peter" <Peter.Enderborg@sony.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Jiri Kosina <jikos@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
Thread-Topic: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
Thread-Index: AQHV3DUoC8Fr93XAjUCngD3KfY+V/agNvc6A
Date:   Thu, 6 Feb 2020 07:00:52 +0000
Message-ID: <e80973cc-812a-df52-c54a-8edf500c0c75@sony.com>
References: <Pine.LNX.4.44L0.2002051000050.1517-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.2002051000050.1517-100000@iolanthe.rowland.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Enderborg@sony.com; 
x-originating-ip: [37.139.156.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 00fb9ffc-1df4-45ac-fb7f-08d7aad24dff
x-ms-traffictypediagnostic: AM0P193MB0308:
x-microsoft-antispam-prvs: <AM0P193MB0308075896AADFAF858F5E1D861D0@AM0P193MB0308.EURP193.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(199004)(189003)(86362001)(2616005)(2906002)(478600001)(186003)(316002)(4326008)(53546011)(6486002)(26005)(6506007)(31696002)(36756003)(6512007)(71200400001)(66446008)(64756008)(66556008)(5660300002)(66476007)(66946007)(76116006)(91956017)(31686004)(8936002)(54906003)(110136005)(81156014)(81166006)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0P193MB0308;H:AM0P193MB0481.EURP193.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: sony.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3oC6jr9sqAMIwCQlZn5t7DFLmVr5+CpMWKp6ODvCN8FJ11CPLZhxQrTvMNpANeJ4E/BkP9PoZABqQlNiVz3GvVxLCZK61dWWLB93tb2+I9tmB1tq5/CRyP/fsz+UHgDCzUrwbiQbNGoA9nJLAVuACDe+lORRQcyt4RQ0ya4FS/NH7mK7uTbH6ibzg8Yuiel98X+YEaJgAs9a93yIhEEGoq4Y44wRtWqfNANUdWaIXk9F/bewCuUlh9rQPwQYFSQ26KJnSgQ64OESfmvngoQNJoUHVYx4j0If5Y1ngJDxOd2yPUQhHrHQKkfzWjP0vZ4efLUPcO0k7FApLo3fbdkmqzP4YvdB7txXeCcbDGna5u7vB7WLS151KpY0D5B/DiG/js7djNf+zv603iQbH1pqFPyc51rP4UTQBNB2DQpMI2ndeGX4A20KXxS+85HhM/eb
x-ms-exchange-antispam-messagedata: oJ6cSyCfCmjxRMRD0NbTvT2TmDNA5aEndsP41Iiz3jrz87867+Z62TFH1QjJbcC8vkG+drcPcdq3mZqmdvyamqTPBn3rlEMkrMG6Kn14I8VMih1K5/0mPa3RlXCqH/x4SWAE7C48wEZld5TW19feLQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B5AECBC4530E84EAA51029B16CFEFD4@EURP193.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00fb9ffc-1df4-45ac-fb7f-08d7aad24dff
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 07:00:52.3873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hWt3OmEX5PdsTieCAv2TOQLl6uEjW/lVE/1nXgXCb7gkKs6WS5GzSWulw59/j/cqVqDZqC3L22UsbOBoW2H6PN1xeCrxcbRofuV7pgiwiWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P193MB0308
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMi81LzIwIDQ6MDAgUE0sIEFsYW4gU3Rlcm4gd3JvdGU6DQo+IE9uIFdlZCwgNSBGZWIgMjAy
MCwgSmlyaSBLb3NpbmEgd3JvdGU6DQo+DQo+PiBPbiBXZWQsIDUgRmViIDIwMjAsIEVuZGVyYm9y
ZywgUGV0ZXIgd3JvdGU6DQo+Pg0KPj4+Pj4gVGhpcyBwYXRjaCBicmVha3MgRWxnYXRvIFN0cmVh
bURlY2suDQo+Pj4+IERvZXMgdGhhdCBtZWFuIHRoZSBkZXZpY2UgaXMgYnJva2VuIHdpdGggYSB0
b28tbGFyZ2Ugb2YgYSByZXBvcnQ/DQo+Pj4gWWVzLg0KPj4gSW4gd2hpY2ggd2F5IGRvZXMgdGhl
IGJyZWFrYWdlIHBvcCB1cD8gQXJlIHlvdSBnZXR0aW5nICJyZXBvcnQgdG9vIGxvbmciIA0KPj4g
ZXJyb3JzIGluIGRtZXNnLCBvciB0aGUgZGV2aWNlIGp1c3QgZG9lc24ndCBlbnVtZXJhdGUgYXQg
YWxsPw0KPj4NCj4+IENvdWxkIHlvdSBwbGVhc2UgcG9zdCAvc3lzL2tlcm5lbC9kZWJ1Zy9oaWQv
PGRldmljZT4vcmRlc2MgY29udGVudHMsIGFuZCANCj4+IGlmIHRoZSBkZXZpY2UgaXMgYXQgbGVh
c3Qgc2VtaS1hbGl2ZSwgYWxzbyBjb250ZW50cyBvZiANCj4+IC9zeXMva2VybmVsL2RlYnVnL2hp
ZC88ZGV2aWNlPi9ldmVudHMgZnJvbSB0aGUgdGltZSBpdCBtaXNiZWhhdmVzPw0KPiBBbHNvLCBw
bGVhc2UgcG9zdCB0aGUgb3V0cHV0IGZyb20gImxzdXNiIC12IiBmb3IgdGhlIFN0cmVhbURlY2su
DQoNCkJ1cyAwMDIgRGV2aWNlIDAwODogSUQgMGZkOTowMDYwIEVsZ2F0byBTeXN0ZW1zIEdtYkgg
U3RyZWFtIERlY2sNCkRldmljZSBEZXNjcmlwdG9yOg0KwqAgYkxlbmd0aMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAxOA0KwqAgYkRlc2NyaXB0b3JUeXBlwqDCoMKgwqDCoMKgwqDCoCAx
DQrCoCBiY2RVU0LCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDIuMDANCsKgIGJEZXZpY2VD
bGFzc8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMA0KwqAgYkRldmljZVN1YkNsYXNzwqDCoMKgwqDC
oMKgwqDCoCAwDQrCoCBiRGV2aWNlUHJvdG9jb2zCoMKgwqDCoMKgwqDCoMKgIDANCsKgIGJNYXhQ
YWNrZXRTaXplMMKgwqDCoMKgwqDCoMKgIDY0DQrCoCBpZFZlbmRvcsKgwqDCoMKgwqDCoMKgwqDC
oMKgIDB4MGZkOSBFbGdhdG8gU3lzdGVtcyBHbWJIDQrCoCBpZFByb2R1Y3TCoMKgwqDCoMKgwqDC
oMKgwqAgMHgwMDYwDQrCoCBiY2REZXZpY2XCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDEuMDANCsKg
IGlNYW51ZmFjdHVyZXLCoMKgwqDCoMKgwqDCoMKgwqDCoCAxDQrCoCBpUHJvZHVjdMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAyDQrCoCBpU2VyaWFswqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgMw0KwqAgYk51bUNvbmZpZ3VyYXRpb25zwqDCoMKgwqDCoCAxDQrCoCBDb25m
aWd1cmF0aW9uIERlc2NyaXB0b3I6DQrCoMKgwqAgYkxlbmd0aMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIDkNCsKgwqDCoCBiRGVzY3JpcHRvclR5cGXCoMKgwqDCoMKgwqDCoMKgIDIN
CsKgwqDCoCB3VG90YWxMZW5ndGjCoMKgwqDCoMKgwqAgMHgwMDI5DQrCoMKgwqAgYk51bUludGVy
ZmFjZXPCoMKgwqDCoMKgwqDCoMKgwqAgMQ0KwqDCoMKgIGJDb25maWd1cmF0aW9uVmFsdWXCoMKg
wqDCoCAxDQrCoMKgwqAgaUNvbmZpZ3VyYXRpb27CoMKgwqDCoMKgwqDCoMKgwqAgMA0KwqDCoMKg
IGJtQXR0cmlidXRlc8KgwqDCoMKgwqDCoMKgwqAgMHhlMA0KwqDCoMKgwqDCoCBTZWxmIFBvd2Vy
ZWQNCsKgwqDCoMKgwqAgUmVtb3RlIFdha2V1cA0KwqDCoMKgIE1heFBvd2VywqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgNDAwbUENCsKgwqDCoCBJbnRlcmZhY2UgRGVzY3JpcHRvcjoNCsKgwqDC
oMKgwqAgYkxlbmd0aMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDkNCsKgwqDCoMKg
wqAgYkRlc2NyaXB0b3JUeXBlwqDCoMKgwqDCoMKgwqDCoCA0DQrCoMKgwqDCoMKgIGJJbnRlcmZh
Y2VOdW1iZXLCoMKgwqDCoMKgwqDCoCAwDQrCoMKgwqDCoMKgIGJBbHRlcm5hdGVTZXR0aW5nwqDC
oMKgwqDCoMKgIDANCsKgwqDCoMKgwqAgYk51bUVuZHBvaW50c8KgwqDCoMKgwqDCoMKgwqDCoMKg
IDINCsKgwqDCoMKgwqAgYkludGVyZmFjZUNsYXNzwqDCoMKgwqDCoMKgwqDCoCAzIEh1bWFuIElu
dGVyZmFjZSBEZXZpY2UNCsKgwqDCoMKgwqAgYkludGVyZmFjZVN1YkNsYXNzwqDCoMKgwqDCoCAw
DQrCoMKgwqDCoMKgIGJJbnRlcmZhY2VQcm90b2NvbMKgwqDCoMKgwqAgMA0KwqDCoMKgwqDCoCBp
SW50ZXJmYWNlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMA0KwqDCoMKgwqDCoMKgwqAgSElE
IERldmljZSBEZXNjcmlwdG9yOg0KwqDCoMKgwqDCoMKgwqDCoMKgIGJMZW5ndGjCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA5DQrCoMKgwqDCoMKgwqDCoMKgwqAgYkRlc2NyaXB0b3JU
eXBlwqDCoMKgwqDCoMKgwqAgMzMNCsKgwqDCoMKgwqDCoMKgwqDCoCBiY2RISUTCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIDEuMTENCsKgwqDCoMKgwqDCoMKgwqDCoCBiQ291bnRyeUNvZGXC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIDAgTm90IHN1cHBvcnRlZA0KwqDCoMKgwqDCoMKgwqDCoMKg
IGJOdW1EZXNjcmlwdG9yc8KgwqDCoMKgwqDCoMKgwqAgMQ0KwqDCoMKgwqDCoMKgwqDCoMKgIGJE
ZXNjcmlwdG9yVHlwZcKgwqDCoMKgwqDCoMKgIDM0IFJlcG9ydA0KwqDCoMKgwqDCoMKgwqDCoMKg
IHdEZXNjcmlwdG9yTGVuZ3RowqDCoMKgwqAgMjQ4DQrCoMKgwqDCoMKgwqDCoMKgIFJlcG9ydCBE
ZXNjcmlwdG9yczoNCsKgwqDCoMKgwqDCoMKgwqDCoMKgICoqIFVOQVZBSUxBQkxFICoqDQrCoMKg
wqDCoMKgIEVuZHBvaW50IERlc2NyaXB0b3I6DQrCoMKgwqDCoMKgwqDCoCBiTGVuZ3RowqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgNw0KwqDCoMKgwqDCoMKgwqAgYkRlc2NyaXB0b3JU
eXBlwqDCoMKgwqDCoMKgwqDCoCA1DQrCoMKgwqDCoMKgwqDCoCBiRW5kcG9pbnRBZGRyZXNzwqDC
oMKgwqAgMHg4McKgIEVQIDEgSU4NCsKgwqDCoMKgwqDCoMKgIGJtQXR0cmlidXRlc8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgMw0KwqDCoMKgwqDCoMKgwqDCoMKgIFRyYW5zZmVyIFR5cGXCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIEludGVycnVwdA0KwqDCoMKgwqDCoMKgwqDCoMKgIFN5bmNoIFR5cGXC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5vbmUNCsKgwqDCoMKgwqDCoMKgwqDCoCBVc2Fn
ZSBUeXBlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBEYXRhDQrCoMKgwqDCoMKgwqDCoCB3
TWF4UGFja2V0U2l6ZcKgwqDCoMKgIDB4MDIwMMKgIDF4IDUxMiBieXRlcw0KwqDCoMKgwqDCoMKg
wqAgYkludGVydmFswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxDQrCoMKgwqDCoMKgIEVu
ZHBvaW50IERlc2NyaXB0b3I6DQrCoMKgwqDCoMKgwqDCoCBiTGVuZ3RowqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgNw0KwqDCoMKgwqDCoMKgwqAgYkRlc2NyaXB0b3JUeXBlwqDCoMKg
wqDCoMKgwqDCoCA1DQrCoMKgwqDCoMKgwqDCoCBiRW5kcG9pbnRBZGRyZXNzwqDCoMKgwqAgMHgw
MsKgIEVQIDIgT1VUDQrCoMKgwqDCoMKgwqDCoCBibUF0dHJpYnV0ZXPCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIDMNCsKgwqDCoMKgwqDCoMKgwqDCoCBUcmFuc2ZlciBUeXBlwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBJbnRlcnJ1cHQNCsKgwqDCoMKgwqDCoMKgwqDCoCBTeW5jaCBUeXBlwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBOb25lDQrCoMKgwqDCoMKgwqDCoMKgwqAgVXNhZ2UgVHlwZcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgRGF0YQ0KwqDCoMKgwqDCoMKgwqAgd01heFBhY2tl
dFNpemXCoMKgwqDCoCAweDAyMDDCoCAxeCA1MTIgYnl0ZXMNCsKgwqDCoMKgwqDCoMKgIGJJbnRl
cnZhbMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMQ0KDQoNCj4gQWxhbiBTdGVybg0KPg0K
