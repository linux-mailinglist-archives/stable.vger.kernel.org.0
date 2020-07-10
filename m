Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072EC21BA59
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 18:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGJQIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 12:08:46 -0400
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:6128
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726496AbgGJQIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 12:08:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gV8cCyim/4pYQ7UmN2DNklLqxcFh62f49MHtduQXDZWaRJa3h0zefaHs+5+xDNaaSu/8tIQzcPj4HnrdM6fATfHmCyiMkyGrhTt9azpK6SJyP2HimSuQhl+VkI8hJyuY2WbgIyY8qzVrnJkavgDJ6YCcA5DO68AkWYH95CiQ0nikX9ypQvLfcIN+2WmINKAwb7EL7kKKye01er12VXuufOpt0CQUOtKaezdfX8fh17Mx/iMojcaPS1BXbuEems3qjGjMdzpqORgscpwc395k8JwPTxHWkqH2RvuBLEZq2sj/iTKUPciOnddg87H18OTaVHoqqjRyqaXHJeVAfpkh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDSRmH9HZjcu39oLivkjpKST/TeBzE9/HEyugszqnGY=;
 b=leBoo87fcypJXplgjikQbDmCr+7NgBU9ttxqiXl4r7iFeil8TZUU+3ggD0vn1mQDMYTfg6yfyaFXlrHYIqK3cXNzlYX+sBSbtpdfTuOJLiREYVL4GkOTBhiPG8LwGU8nuk2SU73J5N8XZweLhoYAj8Szo63is5usFcYVAEoSxGgygn2ho65GrNDfBK4y59LSAwzVhNZkP13f8qw5xhW6yQKoSzLzApgKUKwi9nQdGIXjYsBY8SYhdR/R2Ks19cp5B1lpV874fT+9UozASyCEF7ByYOzdmcvp6DGkfKryBu9CLcSVhQIFVjrY5aPBBQMtxVBCCVK3p9f5p/yrhqvhMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDSRmH9HZjcu39oLivkjpKST/TeBzE9/HEyugszqnGY=;
 b=XgL/MZDoQWXuVKu3Y+Vz02kJ3v3s62U5h6lO9EbQk4rkciOKDk1mCR0iN8eJVVZvD4JgklPqfQv9WuwGrysWTJ9t1taSSF4Hb3fIOmZY5ZSxrpm0RZ2KODzliy38d9drE91tswUCdV5JcuxYiu3mqx5Eeovm9H/oTE3cX7Go6Yg=
Received: from DM5PR1001MB2186.namprd10.prod.outlook.com (2603:10b6:4:35::35)
 by DM6PR10MB3146.namprd10.prod.outlook.com (2603:10b6:5:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 16:08:42 +0000
Received: from DM5PR1001MB2186.namprd10.prod.outlook.com
 ([fe80::d086:8298:6d8a:e6ff]) by DM5PR1001MB2186.namprd10.prod.outlook.com
 ([fe80::d086:8298:6d8a:e6ff%6]) with mapi id 15.20.3153.031; Fri, 10 Jul 2020
 16:08:42 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "johan@kernel.org" <johan@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Topic: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Index: AQHWVp10AvhYW+hsHEuT/7Zwfc2fs6kAnkqAgAADKICAACARgIAAOR6AgAAA5YA=
Date:   Fri, 10 Jul 2020 16:08:42 +0000
Message-ID: <615176304b725f2443d1fd35556fe806bce21865.camel@infinera.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
         <20200710103459.GA1203263@kroah.com>
         <428dc1e66dfa5fb604233046013f9fe35c4d9b5e.camel@infinera.com>
         <20200710124103.GU3453@localhost>
         <4bf0e060e72c4f1c7c53da6bbd5aa883028d1bc3.camel@infinera.com>
In-Reply-To: <4bf0e060e72c4f1c7c53da6bbd5aa883028d1bc3.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.37.3 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a53ab57e-e288-4a09-149b-08d824eb8418
x-ms-traffictypediagnostic: DM6PR10MB3146:
x-microsoft-antispam-prvs: <DM6PR10MB314614461FF82A878514A094F4650@DM6PR10MB3146.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: psa1TOB0SIgoyjvLBO45WpkukxJK8Gn9cOyIuoAlpoZBTphcVpAvbCLFrt/ifzQNgtRUDGw2fTtXbdBRsy7zvdOmMpwOo0cQpZmb8v7aNgUcfwVUjinxrAF4mOkP9QUIcKavjst+fBHn7WGleOJ+KW2b62lvZGLaXoH4jObmF2gCy4cdqr/Pi/YWCeZ/gYNBKsj+oe2hnJYidW7HqJ+U6vkmAcnYxvUK3nQS7PZeV2kQi/+BY/jfGUcKMa8xL9mgweS61hBrJVvmvw7JvK/73SUqXkS8xTmrersREMhvu4dODs4CPmpweyYMuMNOB2HL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2186.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(186003)(6916009)(478600001)(2906002)(316002)(54906003)(66476007)(66446008)(91956017)(76116006)(64756008)(66556008)(66946007)(5660300002)(36756003)(6506007)(26005)(6486002)(8936002)(71200400001)(2616005)(8676002)(4326008)(6512007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RVCYY9bfjCwT9BVrKyjos1RnqfRqMG4P+V9dD2jdBCMkf0eWnHT7LL7KXKSe1GEQ5/UT1Z11xrV4ff5BPM+LNSGbItCXGGYrP0A5dl4LPvrm4rwyg0deZDRy2dWQziUGoe7gk/DMRbvVmFqK++0Njnqjg8PMYJR9+CsK7P2+xW6vQV4pbCyvLrlYER0jh/8CRRrx1APdDMlExdNKktxTr8SaTV+5icK+rO3OiyKgC3nSyOlH1dqsQ8nFxfHpI/Dajd7/bD25B5bkPElbBdd4lhC43jLGM7jS/jLBU9EjzuIauzLuYGGGRPHcKzLSm587YYHqTXMPqYeC1MUVEdvKsg1tM+4MwbZtI99dXI1KfRu3prZgpbrrAez1MTmSrZ11i9Wrwm9b3RIHYFkSnNGgMWKH8/QJdt0rcJkzJDWtFJntlOVs2Qmpw4txQWs2pGPsI/7M5x7e0aC1fvbnVJK+pe+I17Nvrv6mDKgOp/aKK/9wlY4QtueP0N/eCs1+JrWJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6937BB4A502C1499AB15795BDEB35FC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2186.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a53ab57e-e288-4a09-149b-08d824eb8418
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 16:08:42.4200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zsilqcM5LjTcBmItF2oxhVe3yAb1R8wp53MHKqA9NsZaZUlZO68NCv26H2mjMDtwnM2xz8niPW0Ib+f+H0h+Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3146
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTEwIGF0IDE4OjA1ICswMjAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3Rl
Og0KPiBPbiBGcmksIDIwMjAtMDctMTAgYXQgMTQ6NDEgKzAyMDAsIEpvaGFuIEhvdm9sZCB3cm90
ZToNCj4gPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRo
ZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3UgcmVjb2duaXplIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2Fm
ZS4NCj4gPiANCj4gPiANCj4gPiBPbiBGcmksIEp1bCAxMCwgMjAyMCBhdCAxMDo0NjoxOUFNICsw
MDAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3RlOg0KPiA+ID4gT24gRnJpLCAyMDIwLTA3LTEwIGF0
IDEyOjM0ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gT24gRnJpLCBK
dWwgMTAsIDIwMjAgYXQgMTE6MzU6MThBTSArMDIwMCwgSm9ha2ltIFRqZXJubHVuZCB3cm90ZToN
Cj4gPiANCj4gPiA+ID4gPiDCoMKgwqDCoMKgwqB0dHlfc2V0X29wZXJhdGlvbnMoYWNtX3R0eV9k
cml2ZXIsICZhY21fb3BzKTsNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAtICAgICByZXR2YWwgPSB0
dHlfcmVnaXN0ZXJfZHJpdmVyKGFjbV90dHlfZHJpdmVyKTsNCj4gPiA+ID4gPiArICAgICByZXR2
YWwgPSB1c2JfcmVnaXN0ZXIoJmFjbV9kcml2ZXIpOw0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoGlm
IChyZXR2YWwpIHsNCj4gPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcHV0X3R0
eV9kcml2ZXIoYWNtX3R0eV9kcml2ZXIpOw0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gcmV0dmFsOw0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoH0NCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiAtICAgICByZXR2YWwgPSB1c2JfcmVnaXN0ZXIoJmFjbV9kcml2ZXIpOw0K
PiA+ID4gPiA+ICsgICAgIHJldHZhbCA9IHR0eV9yZWdpc3Rlcl9kcml2ZXIoYWNtX3R0eV9kcml2
ZXIpOw0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoGlmIChyZXR2YWwpIHsNCj4gPiA+ID4gPiAtICAg
ICAgICAgICAgIHR0eV91bnJlZ2lzdGVyX2RyaXZlcihhY21fdHR5X2RyaXZlcik7DQo+ID4gPiA+
ID4gKyAgICAgICAgICAgICB1c2JfZGVyZWdpc3RlcigmYWNtX2RyaXZlcik7DQo+ID4gPiA+IA0K
PiA+ID4gPiBXaHkgYXJlIHlvdSBzd2l0Y2hpbmcgdGhlc2UgYXJvdW5kPyAgSSB0aGluayBJIGtu
b3csIGJ1dCB5b3UgZG9uJ3QNCj4gPiA+ID4gcmVhbGx5IHNheS4uLg0KPiA+ID4gDQo+ID4gPiBJ
IHdyb3RlOg0KPiA+ID4gwqDCoMKgRm9yIGluaXRpYWwgdGVybWlvcyB0byByZWFjaCBVU0IgY29y
ZSwgVVNCIGRyaXZlciBoYXMgdG8gYmUNCj4gPiA+IMKgwqDCoHJlZ2lzdGVyZWQgYmVmb3JlIFRU
WSBkcml2ZXIuDQo+ID4gPiBGb3VuZCBvdXQgdGhhdCBieSB0cmlhbCBhbmQgZXJyb3IuIElzbid0
IHRoYXQgY2xlYXIgZW5vdWdoPw0KPiA+IA0KPiA+IE5vLCB0aGF0IG1ha2VzIG5vIHNlbnNlIGF0
IGFsbCBzaW5jZSBVU0IgY29yZSBkb2VzIG5vdCBjYXJlIGFib3V0DQo+ID4gaW5pdF90ZXJtaW9z
Lg0KPiANCj4gQnV0IHlvdSBpbnN0YWxsIGFjbV9vcHMgaW50byB0dHk6DQo+IAl0dHlfc2V0X29w
ZXJhdGlvbnMoYWNtX3R0eV9kcml2ZXIsICZhY21fb3BzKTsNCj4gUGVyaGFwcyB0aGVyZSBpcyBh
IGNhbGwgaW50byBhY21fb3BzPw0KPiANCj4gQW55aG93LCBkb2VzIGl0IG5vdCBtYWtlIHNlbnNl
IHRvIGhhdmUgdXNiIGJlZm9yZSB0dHkgYXMgdHR5IHVzZXMgdXNiPw0KDQpGb3Jnb3QgdG8gbWVu
dGlvbiwgSSBjYW4gcmVtb3ZlOg0KLy8JYWNtLT5saW5lLmR3RFRFUmF0ZSA9IGNwdV90b19sZTMy
KDk2MDApOw0KLy8JYWNtLT5saW5lLmJEYXRhQml0cyA9IDg7DQovLwlhY21fc2V0X2xpbmUoYWNt
LCAmYWNtLT5saW5lKTsNCmluICBhY21fcHJvYmUoKSB3aXRob3V0IG5vdGljaW5nIGFueSBjaGFu
Z2UNCg0KIEpvY2tlDQo=
