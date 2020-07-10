Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154BC21B353
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGJKqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:46:23 -0400
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:6097
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726369AbgGJKqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 06:46:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IH2eieBQcSnzNgxvqyJJxKD1AF4DJJWJJat4ygCJGvDwTOhv6Lpuc8v7voQfctsSA+8BX85rn9kbIEyPflv8ctQniQyzh7gaweDOX2z05fHOrpJiPGHP/awbO7Ytm8/klvDPMvZbc+A7SGhKmhNGZJ87ydRnCYj9ur41KwmqJqHcBP+K9H6F7MmLzMzDj/ALokK2P71TBjFWrbtGCNIz5TsjpKjX6paTQ25PUcgdfoMl5a8ckFIPu+G70YvLrVu/rTvkNtI3HneLFZED9UHtVnaM4Wl8jBmnSJjyhCswXSevm8MaDIlEvFc89jY+1VTKSSuayKmz8ehN3BVU9joz4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Egh2wGoxcZXY9swUgRfxYULMRGTPBF+02kZyDTQofEY=;
 b=Qdi3KslXRwxKZVFmIv2ToQMpA58oR5/dXrHTce+3CECJlJXg5TMJF35PEq+SI8WGzkBiXbGeGD6rb8g4hrBUR6gPUa6Be0xG3HvalVGXW4QjR0swF6ozXcv4iFU/osB7yzI4zR6HOx+VNGt89drcsnFxX4IS857GpZWHajqAs2yxiJiDm5IwoxZsv9fNxMC4F5JSPJwjy61sobX0jFtOEJJ95NgzYE3ZfomZ1qRsperUrwQPsB8z/07x50/pTvrIJog/VGEPSOTuivayhpilFYh6NwTkhNas76GLWnJAZNXMNHXaZyLuhVxFhWQmeRIMilFKWedR/2Nnt0GIWW1Swg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Egh2wGoxcZXY9swUgRfxYULMRGTPBF+02kZyDTQofEY=;
 b=YqxpU1TH5T/trKcj/LWBtAzQi08zw/7ISLITU6IfFlbmoSZ9dUm5+x8f1qDCvxO+3anES7MalCfwp3L4woVZYCXGNH1SVL9YLoUNhx8NYlQJjmUYSR8O98WmAekm3yIwoXf3PVDN0DdXDcBApOv1KGlLRjP3l0Z3LGkhkqRryjI=
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 (2603:10b6:301:2e::20) by MWHPR10MB1471.namprd10.prod.outlook.com
 (2603:10b6:300:23::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 10:46:19 +0000
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1]) by MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1%5]) with mapi id 15.20.3174.021; Fri, 10 Jul 2020
 10:46:19 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Topic: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Index: AQHWVp10AvhYW+hsHEuT/7Zwfc2fs6kAnkqAgAADKIA=
Date:   Fri, 10 Jul 2020 10:46:19 +0000
Message-ID: <428dc1e66dfa5fb604233046013f9fe35c4d9b5e.camel@infinera.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
         <20200710103459.GA1203263@kroah.com>
In-Reply-To: <20200710103459.GA1203263@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.37.3 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 232102d6-0d8b-4cc1-4487-08d824be7ac0
x-ms-traffictypediagnostic: MWHPR10MB1471:
x-microsoft-antispam-prvs: <MWHPR10MB147114AAF434D639F93D7638F4650@MWHPR10MB1471.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ozrwQ+riW/mA6FWHpVGq5LwLdBxOT/54/toSSm64yc7STF6jbg/+1Rt1C60cPUSLaqxOxfeus56dF1sCavyRtcB4hvYLXTSg4Lr9nmA+qHJ/CFf+qB8xw0atG1KCKNRWzhdY+Z4PiJ+2ab+rYoQhgMm5ebwLuT0XcgTazuE1lynqvKzbBPrp5Xa9GebWG7N/AHSYW8rg2K81S+uz3lnY9an1wtb7W1CiUDVlaznx+MQ+K6CDf02SJvLhJYdXLY65HrtTVjngAJvZeuDrHsJkdaCnAomRWKMMQ1cIFPlN4hbHamIBGcV9G20Gomae8mz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2190.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(8676002)(6916009)(4326008)(6486002)(71200400001)(66446008)(316002)(66556008)(66946007)(64756008)(66476007)(2906002)(54906003)(83380400001)(91956017)(36756003)(76116006)(478600001)(6506007)(186003)(5660300002)(8936002)(26005)(86362001)(6512007)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /p1jWetqW+DtK0sSjiU2k1WGk7vMySTrbXhy8pUbvoCXwcgO0K3e9YFyWS4F0uWm7YiJYbQ7rUoRPxYalLN2a9XO9oO33R9Q4rPiBEJv5sgUGgny3BfcCYrp8+gU1wGhtiONcZVcQ7dUC1o01KOVgZxlNh1H86R/pKw2I2syR0uuZ6pZNfqcisHWjT4DHdD3Fou/JzlSQIf8jzZ/Qfb5qpcrUoq599XN4+P3BSqS6yop2BppNea+kAvGD6uZTHacjZmIUBXD9vQtApD3GQtgO8cVrI+EDHNRdA4Admo72Yw80n3+nChYXWoWCBLSBcv0xIkJlgI1J2t7Ql4CiMEx/IxDB2yXZHRGiQNGwfVJB01LS3PdVpuz9F9qQSod6LR1FEEgCHXH1HePz7VG2irJhw5SCq4h4nur7uuwO/ZiKSmT5bB2eug7MPlxmVgJwXN/0hsdWIvRPLllQjidXJcpEDwhgou2i/UCI2gyiJhPE0KAtlAMlBryYhN8QI5MWV0w
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E640F0A81D1384C9A9AB5DB4C4C1704@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2190.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232102d6-0d8b-4cc1-4487-08d824be7ac0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 10:46:19.3113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R2tFmhxXyxfRBE4M4nPpyylehiKIx0ILvwnNE/O9E0ejXTlEJWALGhJH3K6P1lq/gCF6GLqTG4dv8K9ZD8wRcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1471
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTEwIGF0IDEyOjM0ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiANCj4g
T24gRnJpLCBKdWwgMTAsIDIwMjAgYXQgMTE6MzU6MThBTSArMDIwMCwgSm9ha2ltIFRqZXJubHVu
ZCB3cm90ZToNCj4gPiBCTyB3aWxsIGRpc2FibGUgVVNCIGlucHV0IHVudGlsIHRoZSBkZXZpY2Ug
b3BlbnMuIFRoaXMgd2lsbA0KPiA+IGF2b2lkIGdhcmJhZ2UgY2hhcnMgd2FpdGluZyBmbG9vZCB0
aGUgVFRZLiBUaGlzIG1pbWljcyBhIHJlYWwgVUFSVA0KPiA+IGRldmljZSBiZXR0ZXIuDQo+ID4g
Rm9yIGluaXRpYWwgdGVybWlvcyB0byByZWFjaCBVU0IgY29yZSwgVVNCIGRyaXZlciBoYXMgdG8g
YmUNCj4gPiByZWdpc3RlcmVkIGJlZm9yZSBUVFkgZHJpdmVyLg0KPiANCj4gWW91IGFyZSBkb2lu
ZyB0d28gZGlmZmVyZW50IHRoaW5ncyBoZXJlLCBwbGVhc2UgYnJlYWsgdGhpcyB1cCBpbnRvIDIN
Cj4gcGF0Y2hlcywgd2l0aCBnb29kIGRvY3VtZW50YXRpb24gZm9yIGJvdGggb2YgdGhlbS4NCj4g
DQo+IEFuZCBhbnkgcmVhc29uIHlvdSBkaWRuJ3Qgc2VuZCB0aGlzIHRvIHRoZSBwZW9wbGUgbGlz
dGVkIGluDQo+IHNjcmlwdHMvZ2V0X21haW50YWluZXJzLnBsIHdoZW4gcnVuIG9uIHRoaXMgcGF0
Y2g/DQo+IA0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBUamVybmx1bmQgPGpvYWtp
bS50amVybmx1bmRAaW5maW5lcmEuY29tPg0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
DQo+ID4gLS0tDQo+ID4gDQo+ID4gwqBJIGhvcGUgdGhpcyBjaGFuZ2UgbWFrZXMgc2Vuc2UgdG8g
eW91LCBpZiBzbyBJIGJlbGl2ZQ0KPiA+IMKgdHR5VVNCIGNvdWxkIGRvIHRoZSBzYW1lLg0KPiA+
IA0KPiA+IMKgZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jIHwgOCArKysrLS0tLQ0KPiA+IMKg
MSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPiANCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jIGIvZHJpdmVycy91c2Iv
Y2xhc3MvY2RjLWFjbS5jDQo+ID4gaW5kZXggNzUxZjAwMjg1ZWU2Li41NjgwZjcxMjAwZTUgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jDQo+ID4gKysrIGIvZHJp
dmVycy91c2IvY2xhc3MvY2RjLWFjbS5jDQo+ID4gQEAgLTE5OTksMTkgKzE5OTksMTkgQEAgc3Rh
dGljIGludCBfX2luaXQgYWNtX2luaXQodm9pZCkNCj4gPiDCoMKgwqDCoMKgwqBhY21fdHR5X2Ry
aXZlci0+c3VidHlwZSA9IFNFUklBTF9UWVBFX05PUk1BTCwNCj4gPiDCoMKgwqDCoMKgwqBhY21f
dHR5X2RyaXZlci0+ZmxhZ3MgPSBUVFlfRFJJVkVSX1JFQUxfUkFXIHwgVFRZX0RSSVZFUl9EWU5B
TUlDX0RFVjsNCj4gPiDCoMKgwqDCoMKgwqBhY21fdHR5X2RyaXZlci0+aW5pdF90ZXJtaW9zID0g
dHR5X3N0ZF90ZXJtaW9zOw0KPiA+IC0gICAgIGFjbV90dHlfZHJpdmVyLT5pbml0X3Rlcm1pb3Mu
Y19jZmxhZyA9IEI5NjAwIHwgQ1M4IHwgQ1JFQUQgfA0KPiA+ICsgICAgIGFjbV90dHlfZHJpdmVy
LT5pbml0X3Rlcm1pb3MuY19jZmxhZyA9IEIwIHwgQ1M4IHwgQ1JFQUQgfA0KPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBIVVBDTCB8IENMT0NBTDsNCj4gDQo+IEh1aD8gIEFyZSB5b3Ugc3VyZSB0aGlzIHdvcmtzPw0K
DQpZZXMsIHNvcnQgb2YuIEkgZGlkbid0IHNlZSBwcmVoaXN0b3J5IGNoYXJzIHdoZW4gY2hhbmdl
ZCB0byBCMA0KDQo+IA0KPiA+IMKgwqDCoMKgwqDCoHR0eV9zZXRfb3BlcmF0aW9ucyhhY21fdHR5
X2RyaXZlciwgJmFjbV9vcHMpOw0KPiA+IA0KPiA+IC0gICAgIHJldHZhbCA9IHR0eV9yZWdpc3Rl
cl9kcml2ZXIoYWNtX3R0eV9kcml2ZXIpOw0KPiA+ICsgICAgIHJldHZhbCA9IHVzYl9yZWdpc3Rl
cigmYWNtX2RyaXZlcik7DQo+ID4gwqDCoMKgwqDCoMKgaWYgKHJldHZhbCkgew0KPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwdXRfdHR5X2RyaXZlcihhY21fdHR5X2RyaXZlcik7DQo+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZXR2YWw7DQo+ID4gwqDCoMKg
wqDCoMKgfQ0KPiA+IA0KPiA+IC0gICAgIHJldHZhbCA9IHVzYl9yZWdpc3RlcigmYWNtX2RyaXZl
cik7DQo+ID4gKyAgICAgcmV0dmFsID0gdHR5X3JlZ2lzdGVyX2RyaXZlcihhY21fdHR5X2RyaXZl
cik7DQo+ID4gwqDCoMKgwqDCoMKgaWYgKHJldHZhbCkgew0KPiA+IC0gICAgICAgICAgICAgdHR5
X3VucmVnaXN0ZXJfZHJpdmVyKGFjbV90dHlfZHJpdmVyKTsNCj4gPiArICAgICAgICAgICAgIHVz
Yl9kZXJlZ2lzdGVyKCZhY21fZHJpdmVyKTsNCj4gDQo+IFdoeSBhcmUgeW91IHN3aXRjaGluZyB0
aGVzZSBhcm91bmQ/ICBJIHRoaW5rIEkga25vdywgYnV0IHlvdSBkb24ndA0KPiByZWFsbHkgc2F5
Li4uDQoNCkkgd3JvdGU6DQogICBGb3IgaW5pdGlhbCB0ZXJtaW9zIHRvIHJlYWNoIFVTQiBjb3Jl
LCBVU0IgZHJpdmVyIGhhcyB0byBiZQ0KICAgcmVnaXN0ZXJlZCBiZWZvcmUgVFRZIGRyaXZlci4N
CkZvdW5kIG91dCB0aGF0IGJ5IHRyaWFsIGFuZCBlcnJvci4gSXNuJ3QgdGhhdCBjbGVhciBlbm91
Z2g/DQoNCkkgY291bGQgY2hhbmdlIHRvOg0KICAgIGNkYy1hY206IGFjbV9pbml0OiByZWdpc3Rl
ciBVU0IgYmVmb3JlIFRUWSBkcml2ZXINCiAgICANCiAgICBGb3IgaW5pdGlhbCB0ZXJtaW9zIHRv
IHJlYWNoIFVTQiBjb3JlLCBVU0IgZHJpdmVyIGhhcyB0byBiZQ0KICAgIHJlZ2lzdGVyZWQgYmVm
b3JlIFRUWSBkcml2ZXIuDQoNCmFuZCB0aGVuIGp1c3QgaGF2ZSB0aGF0IGNoYW5nZToNCkBAIC0y
MDAzLDE1ICsyMDAzLDE1IEBAIHN0YXRpYyBpbnQgX19pbml0IGFjbV9pbml0KHZvaWQpDQogCQkJ
CQkJCQlIVVBDTCB8IENMT0NBTDsNCiAJdHR5X3NldF9vcGVyYXRpb25zKGFjbV90dHlfZHJpdmVy
LCAmYWNtX29wcyk7DQogDQotCXJldHZhbCA9IHR0eV9yZWdpc3Rlcl9kcml2ZXIoYWNtX3R0eV9k
cml2ZXIpOw0KKwlyZXR2YWwgPSB1c2JfcmVnaXN0ZXIoJmFjbV9kcml2ZXIpOw0KIAlpZiAocmV0
dmFsKSB7DQogCQlwdXRfdHR5X2RyaXZlcihhY21fdHR5X2RyaXZlcik7DQogCQlyZXR1cm4gcmV0
dmFsOw0KIAl9DQogDQotCXJldHZhbCA9IHVzYl9yZWdpc3RlcigmYWNtX2RyaXZlcik7DQorCXJl
dHZhbCA9IHR0eV9yZWdpc3Rlcl9kcml2ZXIoYWNtX3R0eV9kcml2ZXIpOw0KIAlpZiAocmV0dmFs
KSB7DQotCQl0dHlfdW5yZWdpc3Rlcl9kcml2ZXIoYWNtX3R0eV9kcml2ZXIpOw0KKwkJdXNiX2Rl
cmVnaXN0ZXIoJmFjbV9kcml2ZXIpOw0KIAkJcHV0X3R0eV9kcml2ZXIoYWNtX3R0eV9kcml2ZXIp
Ow0KIAkJcmV0dXJuIHJldHZhbDsNCiAJfQ0KDQoNCg==
