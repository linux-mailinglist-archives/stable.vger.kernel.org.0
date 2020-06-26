Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC66E20ACBD
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 09:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgFZHFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 03:05:09 -0400
Received: from mail-vi1eur05on2108.outbound.protection.outlook.com ([40.107.21.108]:29793
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725801AbgFZHFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 03:05:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cD9D/GtGsvNCjXIkJDe/Kq+Bzb8yJjPuBhyhPxH+sKv15YYwQaJoZJX2S80IKWrPUwrQ+TDLPxjyqmRIQHdfeijM9u3uuNi/BxGRVhtf8vnK2yZJNdhrgUALgIfbzWlyMU16+IyMxvWyO4vKSHYq86YvUIIHSWkNWATtlNKae2RIHivXFcJTQG1nFROCqS8/bIFdrkUlqAzTPv/vvX9bv5Ivc2WSG/Gq372whYerbfcuoBwMgYXPojDW3C/AB/48T/HnCd9gnTkxMVgNh45a/LH+veH8qtjTJLDJ8xKPkTBjLO+nPC7kQECFj5muH3/DsT5255lo7sSxsiMhUhN6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKarl1yrTLRhes9cPTwcjgOcXJNTLG6aTZZPjpY7zaw=;
 b=KSztazDD710Nw0A2JdGe2Jv2e36Kl/BqHbTVQ+V/IrT/HESr32aVtLl29xHuT22qyjZQoDDnqVeXJRrTcqVrY5zIZVga0mj4JDYJPtPJZZ2TTUdoU6m9bWT9HDFwVebnyps8DYESZTjSu4cIzQsyhBmzzTRKP6I7Qrb9J23/HNwMbKiL7ufrqL2rYzqCWekdDDSZBdpGghjEJg1tw/SwqHicA2POQbuRLT+bWEaOE4yfp+9ZMXtn73sqNF2x6W0b7ql0zvGZC3J64JyQjX58rSCL2IRD0g8gNlu83u/Psogx4DAKCe4Q1baSzPkP6gTEVpe8ynIFYGgL/zpC+FjBTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKarl1yrTLRhes9cPTwcjgOcXJNTLG6aTZZPjpY7zaw=;
 b=terROTeWdvRsuTIwNDiMgbvERVoyanq1VQ5CyewWtf+i0dqqYK+n3BaBI24blczacLzZ6PQFfLmw8Vnedl7ZO06qWQpYVLj27LALzmGBIL2oOw2XijrRrk67nJxxUXFQjZLXIr+VKfYwm/UvwvA8pZ/9V65DxZxfwEw7iyptJ1Q=
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com (2603:10a6:7:2c::17) by
 HE1PR07MB3228.eurprd07.prod.outlook.com (2603:10a6:7:37::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.12; Fri, 26 Jun 2020 07:05:04 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::acd9:308c:9357:f019]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::acd9:308c:9357:f019%7]) with mapi id 15.20.3153.010; Fri, 26 Jun 2020
 07:05:04 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "sashal@kernel.org" <sashal@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 4.14 038/190] KVM: x86: only do L1TF workaround on
 affected processors
Thread-Topic: [PATCH 4.14 038/190] KVM: x86: only do L1TF workaround on
 affected processors
Thread-Index: AQHWRlgyMF8meA1cz0+O2DfNzq/AdqjnsY0AgAAliwCAAqxxgA==
Date:   Fri, 26 Jun 2020 07:05:04 +0000
Message-ID: <b0b4d0839b2ef0a8df216ea1acb223bb94ce3c6a.camel@nokia.com>
References: <20200619141633.446429600@linuxfoundation.org>
         <20200619141635.473250358@linuxfoundation.org>
         <6610924417787ad9e2332d399b5948ce19fbd6fc.camel@nokia.com>
         <20200624141520.GF1931@sasha-vm>
In-Reply-To: <20200624141520.GF1931@sasha-vm>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [131.228.2.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd8d9f01-68f2-4f33-05d0-08d8199f4083
x-ms-traffictypediagnostic: HE1PR07MB3228:
x-microsoft-antispam-prvs: <HE1PR07MB32285F747A3F2F658E7496E3B4930@HE1PR07MB3228.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lI1nMQWxEpXsIW8UkuwxyYzd2ZFVTXzFZGxkFy3rQqvpVw6DIbBUGiOQEbyGoQwepcycu0gzJ0KA2HbdXTdkO2XyyR95WJ2DA29VT61a87lmoXDQHebxoEz6d9VeyLfvw97fBfr6E9op89gi/cBrufkelQjB9PCbVPD2yguHhEVY6Bh2p7hSV9AXPJ7TjoX8+Z2zcDk06SfVQMYzTRTmpLagFRJU/hi+jBtz2d4KfG9ektI7bxf+qK6KsflZh+PUiwHa2Zz45VYbWAPUHyr11AHqxMKQ3kENNSQ1O26OZdWOIGopuzHZgTgNl3uua0ypTP3vmkOuEK/DLfT6UVqKsQC6mz3qR/C7hS4L3gS7u1qh+fFvBavRIWPJA2a6WZuj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(6512007)(2906002)(478600001)(4326008)(54906003)(316002)(6916009)(45080400002)(6506007)(186003)(36756003)(26005)(86362001)(83380400001)(64756008)(66446008)(8676002)(6486002)(8936002)(66476007)(66556008)(71200400001)(5660300002)(76116006)(66946007)(2616005)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: M6qAoo9x3fQSelmhJ1Pi6wd13os6uSvlW/Dvvbn7rlUu/0KljAZLmN3JVGPdeFAsJyfoUMtX2U7EBXZUkFE9fANL99ofGuSQ2nRFXyr3z2BPikNaX1h620AtBinD4pk/yf2vQNT8pk4jcK1257Yhy35lyR/zbv9AcSyEyBJYPxpzK7ddzc7A7OqFzWPTBZi/glWr92hIKb2YfXrCjhQxcbklryaY0VmMwFaz0Zd1piPcpY3rw/1912Z7PJWmp1Y9XrAyNNMSe36SRvl4zzMw6T62bz4W6nTxN2Au8VEtpvxq34eTLq7yEGGvXRPCYU91msnr5RQAJpRlzLKjDuh8jGGn6kGbB+hyx2cJi6HMs/gvMu6aeHl1ZYqEVbzaTbSIHEw45nsUoEWodELQkgYSjab4dd/elX10TzxHswPxN+zxRMmnkVI/08zRH9RJILJvVTAB/+jP7JUZb7gYptazPeuFyEcD/A+1ZKgb8EXoFDg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF479C082F690C419663012D6C6661E9@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8d9f01-68f2-4f33-05d0-08d8199f4083
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 07:05:04.3749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /zVfJoGW/ZBx1EeKDB/ltYyzJkeIJwqcMBKQJT/TcBmYrMWYc1dgXX/1v1v9Ee6WawGPr35j0kLpeQhabL10fbPH9lk1WnR6i5Fm051VhxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR07MB3228
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTI0IGF0IDEwOjE1IC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
T24gV2VkLCBKdW4gMjQsIDIwMjAgYXQgMTI6MDA6NTlQTSArMDAwMCwgUmFudGFsYSwgVG9tbWkg
VC4gKE5va2lhIC0NCj4gRkkvRXNwb28pIHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAyMC0wNi0xOSBh
dCAxNjozMSArMDIwMCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA+ID4gRnJvbTogUGFv
bG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gPiA+IA0KPiA+ID4gWyBVcHN0cmVh
bSBjb21taXQgZDQzZTI2NzVlOTZmYzZhZTFhNjMzYjZhNjlkMjk2Mzk0NDQ4Y2MzMiBdDQo+ID4g
PiANCj4gPiA+IEtWTSBzdG9yZXMgdGhlIGdmbiBpbiBNTUlPIFNQVEVzIGFzIGEgY2FjaGluZyBv
cHRpbWl6YXRpb24uDQo+ID4gDQo+ID4gQW55IGlkZWFzIHdoYXQncyBtaXNzaW5nIGluIDQuMTQg
Pw0KPiANCj4gSSB0aGluayB0aGF0IHRoaXMgd2FzIGJlY2F1c2Ugd2UncmUgbWlzc2luZyA2MTI5
ZWQ4NzdkNDAgKCJLVk06IHg4Ni9tbXU6DQo+IFNldCBtbWlvX3ZhbHVlIHRvICcwJyBpZiByZXNl
cnZlZCAjUEYgY2FuJ3QgYmUgZ2VuZXJhdGVkIikuIEkndmUgcXVldWVkDQo+IGl0IHVwIChhbG9u
ZyB3aXRoIGEgZmV3IG90aGVyIHJlbGF0ZWQgY29tbWl0cykgYW5kIGEgbmV3IC1yYyBjeWNsZQ0K
PiBzaG91bGQgYmUgdW5kZXJ3YXkgZm9yIHRob3NlLg0KDQpTb3JyeSwgSSBzdGlsbCBzZWUgaXQg
d2l0aCA0LjE0LjE4NjoNCg0KWyAgICAyLjM1NTE0MF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBd
LS0tLS0tLS0tLS0tDQpbICAgIDIuMzU1ODcyXSBXQVJOSU5HOiBDUFU6IDAgUElEOiA4NDkgYXQg
YXJjaC94ODYva3ZtL21tdS5jOjI4NA0Ka3ZtX21tdV9zZXRfbW1pb19zcHRlX21hc2srMHg0ZS8w
eDYwIFtrdm1dDQpbICAgIDIuMzU3NzIzXSBNb2R1bGVzIGxpbmtlZCBpbjoga3ZtX2ludGVsKCsp
IGt2bSBpcnFieXBhc3MgYmZxDQpzY2hfZnFfY29kZWwgcGNiYyBhZXNuaV9pbnRlbCBhZXNfeDg2
XzY0IGNyeXB0b19zaW1kIGNyeXB0ZCBnbHVlX2hlbHBlcg0KYXRhX3BpaXggZG1fbWlycm9yIGRt
X3JlZ2lvbl9oYXNoIGRtX2xvZyBkbV9tb2QgZGF4IGF1dG9mczQNClsgICAgMi4zNTk2MzldIENQ
VTogMCBQSUQ6IDg0OSBDb21tOiBzeXN0ZW1kLXVkZXZkIE5vdCB0YWludGVkIDQuMTQuMTg2ICMy
DQpbICAgIDIuMzYwMzA5XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlgg
KyBQSUlYLCAxOTk2KSwgQklPUw0KMS4xMy4wLTIuZmMzMiAwNC8wMS8yMDE0DQpbICAgIDIuMzYx
MTc3XSB0YXNrOiBmZmZmOGEzZDE5NDI5ZGMwIHRhc2suc3RhY2s6IGZmZmZiMjU1ODQ2MGMwMDAN
ClsgICAgMi4zNjE3NzVdIFJJUDogMDAxMDprdm1fbW11X3NldF9tbWlvX3NwdGVfbWFzaysweDRl
LzB4NjAgW2t2bV0NClsgICAgMi4zNjIzOTBdIFJTUDogMDAxODpmZmZmYjI1NTg0NjBmYzU4IEVG
TEFHUzogMDAwMTAyMDYNClsgICAgMi4zNjI5MDFdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6
IGZmZmZmZmZmYzAxNzkwMDAgUkNYOg0KMDAwMDAwMDBmZmZmZmY0NQ0KWyAgICAyLjM2MzYxN10g
UkRYOiAwMDAwMDAwMDAwMDAwMDI4IFJTSTogMDAwODAwMDAwMDAwMDAwMSBSREk6DQowMDA4MDAw
MDAwMDAwMDAxDQpbICAgIDIuMzY0MzI5XSBSQlA6IGZmZmZmZmZmYzAwYzU5NTEgUjA4OiAwMDAw
MDAwMGZmZmZmZmZmIFIwOToNCjAwMDAzZmZmZmZmZmZmZmYNClsgICAgMi4zNjUwMjFdIFIxMDog
ZmZmZmIyNTU4NDE1OTJiOCBSMTE6IDAwMDAwMDAwZmZmZmZmZmUgUjEyOg0KMDAwMDAwMDAwMDAw
NWJjMA0KWyAgICAyLjM2NTcxN10gUjEzOiBmZmZmZmZmZmMwMTdhNzgwIFIxNDogZmZmZmIyNTU4
NDYwZmVhMCBSMTU6DQowMDAwMDAwMDAwMDAwMDAxDQpbICAgIDIuMzY2NDM3XSBGUzogIDAwMDA3
ZmM2ZmNhYjZjNDAoMDAwMCkgR1M6ZmZmZjhhM2QxZWEwMDAwMCgwMDAwKQ0Ka25sR1M6MDAwMDAw
MDAwMDAwMDAwMA0KWyAgICAyLjM2NzI3MF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENS
MDogMDAwMDAwMDA4MDA1MDAzMw0KWyAgICAyLjM2NzgyNF0gQ1IyOiAwMDAwNTY0ZGU3NzVmODQw
IENSMzogMDAwMDAwMDgxOGVmYzAwMSBDUjQ6DQowMDAwMDAwMDAwMTYwNmYwDQpbICAgIDIuMzY4
NTM1XSBDYWxsIFRyYWNlOg0KWyAgICAyLjM2ODgwOV0gIGt2bV9tbXVfbW9kdWxlX2luaXQrMHgx
NWYvMHgyNDAgW2t2bV0NClsgICAgMi4zNjkzMjNdICBrdm1fYXJjaF9pbml0KzB4NWUvMHgxMDAg
W2t2bV0NClsgICAgMi4zNjk3NTBdICBrdm1faW5pdCsweDFjLzB4MmIwIFtrdm1dDQpbICAgIDIu
MzcwMTU1XSAgPyBmcmVlX3BjcHBhZ2VzX2J1bGsrMHgyMmQvMHg0YjANClsgICAgMi4zNzA1OTFd
ICA/IGhhcmR3YXJlX3NldHVwKzB4NGFiLzB4NGFiIFtrdm1faW50ZWxdDQpbICAgIDIuMzcxMTEz
XSAgdm14X2luaXQrMHgyMS8weDZhZiBba3ZtX2ludGVsXQ0KWyAgICAyLjM3MTU5Nl0gID8gaGFy
ZHdhcmVfc2V0dXArMHg0YWIvMHg0YWIgW2t2bV9pbnRlbF0NClsgICAgMi4zNzIxMThdICBkb19v
bmVfaW5pdGNhbGwrMHgzZS8weGY0DQpbICAgIDIuMzcyNTAxXSAgPyBrbWVtX2NhY2hlX2FsbG9j
X3RyYWNlKzB4ZWYvMHgxOTANClsgICAgMi4zNzI5NjRdICBkb19pbml0X21vZHVsZSsweDVjLzB4
MWYwDQpbICAgIDIuMzczMzgzXSAgbG9hZF9tb2R1bGUrMHgxZjMxLzB4MjYyMA0KWyAgICAyLjM3
Mzc2NV0gID8gU1lTQ19maW5pdF9tb2R1bGUrMHg5NS8weGIwDQpbICAgIDIuMzc0MjA1XSAgU1lT
Q19maW5pdF9tb2R1bGUrMHg5NS8weGIwDQpbICAgIDIuMzc0NjAxXSAgZG9fc3lzY2FsbF82NCsw
eDc0LzB4MTkwDQpbICAgIDIuMzc0OTc0XSAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1l
KzB4NDEvMHhhNg0KWyAgICAyLjM3NTUwMF0gUklQOiAwMDMzOjB4N2ZjNmZkMzgwMWJkDQpbICAg
IDIuMzc1ODUzXSBSU1A6IDAwMmI6MDAwMDdmZmQ3NjgxODdmOCBFRkxBR1M6IDAwMDAwMjQ2IE9S
SUdfUkFYOg0KMDAwMDAwMDAwMDAwMDEzOQ0KWyAgICAyLjM3NjU5M10gUkFYOiBmZmZmZmZmZmZm
ZmZmZmRhIFJCWDogMDAwMDU2NDUzOWQ5YWI1MCBSQ1g6DQowMDAwN2ZjNmZkMzgwMWJkDQpbICAg
IDIuMzc3MzA1XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwN2ZjNmZjZmM3ODRkIFJE
SToNCjAwMDAwMDAwMDAwMDAwMGUNClsgICAgMi4zNzc5ODFdIFJCUDogMDAwMDAwMDAwMDAyMDAw
MCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5Og0KMDAwMDAwMDAwMDAwMDAwNw0KWyAgICAyLjM3
ODY5M10gUjEwOiAwMDAwMDAwMDAwMDAwMDBlIFIxMTogMDAwMDAwMDAwMDAwMDI0NiBSMTI6DQow
MDAwN2ZjNmZjZmM3ODRkDQpbICAgIDIuMzc5NDAxXSBSMTM6IDAwMDAwMDAwMDAwMDAwMDAgUjE0
OiAwMDAwNTY0NTM5ZDdhNTMwIFIxNToNCjAwMDA1NjQ1MzlkOWFiNTANClsgICAgMi4zODAxMDRd
IENvZGU6IDU5IDI1IDA2IDAwIDc1IDI1IDQ4IGI4IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDQwIDQ4
IDA5DQpjNiA0OCAwOSBjNyA0OCA4OSAzNSA2OCAyNSAwNiAwMCA0OCA4OSAzZCA2OSAyNSAwNiAw
MCBjMyAwZiAwYiAwZiAwYiBlYiBkMg0KPDBmPiAwYiBlYiBkNyA2NiA2NiAyZSAwZiAxZiA4NCAw
MCAwMCAwMCAwMCAwMCAwZiAxZiAwMCAwZiAxZiA0NCANClsgICAgMi4zODE5MDVdIC0tLVsgZW5k
IHRyYWNlIDVmNzU3MzM1YzJlYWM2NTcgXS0tLQ0K
