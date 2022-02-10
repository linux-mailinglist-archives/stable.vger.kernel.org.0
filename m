Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35004B0491
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 05:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiBJEnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 23:43:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiBJEnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 23:43:13 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2043.outbound.protection.outlook.com [40.92.103.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BB21A6;
        Wed,  9 Feb 2022 20:43:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnsamIKwMP9o+gIrJCnYM7oJBdCOM8VQMuXHyulnEtg7bu6E7HjKG3fi/a3AsGaKNvtsQecSzecrDdJ+4Nj1xgWkKcEf37J1OZe0SpIPgzWlaah2yNaqlQabmVB/qEskqm277EtHCTMJ7Iriap2+Dm+3YBBeveGNngxRWy3/w0etYERJBPQbzVvJkHmJMdJUWQtMHSbdkEvNNPgvcKwcjLDZQLnqoYUyxpi4JsTsX/IBp9cH2/gDofWt9wVCwjFnSBsDDJds0vz7RV6+6JnGYUqhZ51dnwPaT0niurz2UshhnIpjq9aMHHmtSdyEhnUV3GGysMh/H8RzSSrShbLAJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Zy9p+vZsJZ784hnvktsmABbGQKZyO/IAxJvmJyoMrk=;
 b=W8Yw89p7J27Ui5/C5Lr7sfQ0ltnanP5I1sD6pA21v/L5BGrR4Ftgqj6yztUKNFmen+ZL7WgHzFCGAwAROGKk2spiTFzbCrxgmzLpaKq133B7xIFeL8Dytl5q1U9v0ejg+ecthHqXOCNXTDqxcwwpmp3LUrJZSpT3zSlEDNAi/OhK9wXBaL5gKY0otw7pPV1m9TWvbYAjS1WJ4EhWvDym0wWFn3a96uaOVUqOY3zqQXCEO3OHucqz1OxLeDCAGbNAYtpV6w6QjMgM6GgV2S7icMegBAYHWwxG0YMOuPotVI7iOHYvv/MqHQJH+91aFtyQ3y0CX0eCwz9uvv91DiWrrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Zy9p+vZsJZ784hnvktsmABbGQKZyO/IAxJvmJyoMrk=;
 b=PTfYrYk4k0TX4WU5qitcj6JdPqhSYCqR0vL+z6vGWjW6xKoFdAlodn+uqcizZ/LFPG6OG5i0q2MmGgfCsHUO6eylox+BS3aFv/GR6VOr8DOB5gI7FsHL1KTGFVscEBqvSKHRqJZ5wPHaBBheLuRmyM7YHkKGsIZT2BikYkSD8biV/7gilXTAUfuGzdFIwmMkPZduVC+dGJP9XCrdzTJA0tKrGA2xTdtCsKnd5SDA1FHM+LQ1u1oTxSHR+tobLFMxFwuWQ3bH+BYPPFFWZEqWKwMc8CJDTl4qTBqVmWSuSq4Z9tj0/nDCs9CO+AYEKgBpL+ay/14Np02At6koWzBzaQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4253.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 04:43:04 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 04:43:04 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Matthew Garrett <mjg59@srcf.ucam.org>
CC:     Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: Re: [PATCH] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLbqGAgAAURwCAAAlIgIAAESOAgACYiIA=
Date:   Thu, 10 Feb 2022 04:43:04 +0000
Message-ID: <4D024AA6-CA95-4C7B-93CE-9A1E7F86BE43@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org> <20220209193705.GA15463@srcf.ucam.org>
In-Reply-To: <20220209193705.GA15463@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [fsO56RVNV9NvXh9wbcFFIuNVFc8QFEw+krqRqaMl1XxK4SSYYciaYjsnPo2Sy980]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a0cca38-d3cc-4bf2-ecac-08d9ec4fd377
x-ms-traffictypediagnostic: PNZPR01MB4253:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LAkz2fp4SJBLl2Fnb474m49RGI8ekE35wS8mGKRdBZ8JDOSW7sEulALZ6lICTU5EV2AwCydb7th3Jw3YohUOxoWufGWRSvsWIUu+mxk2ps7GwTJyYxzNe4lU9m845ai1nki20WKBbcsbqalJGKdG0I1oo0YsM5iPHls2D2jJNM+764T9BZkk3XT8ok1b1XP0N2ABMBDmqZgR9+udMicW8hBsA/vNebvt6RJwp+pjGiLSh3J1OXAmovTRSPYQKvf+XNDpVy0B9lykaP0u+wNc1jrnxYSCLHFycwm+P5vyJOiji0rn8ukPJGWvFzy6YtC2GSD9iPuzJq7Y+95s5jVxeXeKnJTPc6nGw/skJf1QrR7rugPG4NrfleBgjFBMwost0N4ULjc7QOHXkfvGmcUz2QITXN17oQVm0QhO4uDu/slFavvGPCqs/2IFaf8Vp/EN2mW7Iwvm+T9CEyCCLQoRpZnL6P3J7Nwvqu7Tl3xhkJYgbll8iL+IwOSWZxNfjdEJN+KcGZmBuobUmUslcsETiZnxK1sqxIbfeZuUeth7Q25mjOi7mx4E6ndGC8ExGLwpQdAJM4Jg4Wv8Yo3dTw0v/Q==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHNGdGNPU0wvU2srRmp6WFJZSE5iRjNZcFl0M2JWNEsyU2dxVFU2SXJJYzF3?=
 =?utf-8?B?VkR1eVZkdWtEakRNMWkxWEliTGh6TENPNmhuZVJyOWREYVVidmUvZTVuYkdk?=
 =?utf-8?B?VGlvcmMvbGwydlo4aFhLQno4dkNGNk02ZXJpKzZvbzNKTUtGejh2Z2FlbkJh?=
 =?utf-8?B?Zkh1WjdqQU5nS0VNSzA5R1RWbzlodzh4ZG9SLzNjZTlxVnpqUU5jQ1N3WFFF?=
 =?utf-8?B?MURiUzRBUFNWMU5VSE5Ed1BFcS8va2cwbjBFUGNDb016clVPMHoyTTN6Qkoz?=
 =?utf-8?B?VHRmWmVrSjNSUnh6T290ZGFHZ0JuSVRXc0NGTGJmcmpaUnlYSWdHWW1idlZI?=
 =?utf-8?B?WXpBVlYrdUsvVVRHL1kwaW1BRUNPeWhpTUVrNW42YmtpRzc1RmRBRjVOT3Zv?=
 =?utf-8?B?ekJOeGpvZkdPUVlQZU5QMkVNa2xDTWhPazhwei8rckZubWdGVzdUa3NKdXQr?=
 =?utf-8?B?eUl2TEszNVE1eHR5OGhqUkllT0xsK1MvK0k1Y0drVXN6RU9yTXlCa1c3VExv?=
 =?utf-8?B?d01sS3ZPQXVCbHVUM3dQS3VBNm1ZR3BMam42SFI3WDk4RVpFeExFWTk1K3dR?=
 =?utf-8?B?czNRU0ppTHA1Mlk5TDFLQWVqQjN3MGF4Uk5zOUtKeExERXhDVCt3d3h0UFJO?=
 =?utf-8?B?aDdHYUVsZHppYVd6eUdsZnU2YzNzMDg2Ly9LejNueFptbC9Wc2kxTHVwbkJZ?=
 =?utf-8?B?RXlKY0V5Sk4vRmZsWTVhZDBCUGxqTit6SkRDeXR0L2h1VDQ0YjhQUlZKNFU4?=
 =?utf-8?B?VVJkS3IzVDVMS25TSDRtb2VtaERlaVRUQld6OXFNOFgxay83cmFzYmREd0Zk?=
 =?utf-8?B?ZmhWcHo1bkNaaHQ0dGFTUmVLa3V5TkZkZzk2aGEwSG40cFdlb2lJNWdzV0Ni?=
 =?utf-8?B?ZGYxWDdFdkRGOFBBS2g3YXp5M21VNER1UVZQNU9XWERaVWk1VU9XdkNBMVhG?=
 =?utf-8?B?MEdJTVBycVVkejlXQnd4cU9KTXZ3SmxhbmtHQ2xhVXdjUms3bEx5YkpYa3Vn?=
 =?utf-8?B?ZTVsWVVnV29LZjRTWk1xcnV6Z2QwdjQraUd3ODF4MktvQ1FTWnU2Qm5CYUs3?=
 =?utf-8?B?b05MQ3hhbFRSeXZTTTF6OGtDcXN4L05oemdWeTZpRitscWNYNWFlb3FMdFg4?=
 =?utf-8?B?WnZyL0NWZnJURHhOQ1hOOHdDaEp2RUUxeUVTZmJHUlpSTFhTYURXR1lLNTNh?=
 =?utf-8?B?Q1hEQW9vYmZmdXFGTzR1SmdGdkhnblZxVStSaFRjZ29kRFlsTXVqV1YzaGpM?=
 =?utf-8?B?cUZkd2FDS3ovc0NWOGkrZ1JzbnN2YjZjcmtsVlBWNDYxbHd6UW90emhGMWtR?=
 =?utf-8?B?T0hNN2hJSmdWa3AxcXZucGRDeDNZUEZyTm8zWUp5RE84dTJsTWFhaEltQnNt?=
 =?utf-8?B?Rno0NXBseDVscFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B696FE8EA9B4464C8A13E4A53A038675@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0cca38-d3cc-4bf2-ecac-08d9ec4fd377
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 04:43:04.3434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4253
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IGllLCBjYW4geW91IHRyeSBzb21ldGhpbmcgbGlrZSB0aGlzPw0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZmlybXdhcmUvZWZpL3J1bnRpbWUtd3JhcHBlcnMuYyBiL2RyaXZlcnMvZmly
bXdhcmUvZWZpL3J1bnRpbWUtd3JhcHBlcnMuYw0KPiBpbmRleCBmM2U1NGY2NjE2ZjAuLjAxY2Jk
NDgxMWQxZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9maXJtd2FyZS9lZmkvcnVudGltZS13cmFw
cGVycy5jDQo+ICsrKyBiL2RyaXZlcnMvZmlybXdhcmUvZWZpL3J1bnRpbWUtd3JhcHBlcnMuYw0K
PiBAQCAtMzIsNiArMzIsOCBAQA0KPiAjaW5jbHVkZSA8bGludXgvc3RyaW5naWZ5Lmg+DQo+ICNp
bmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4NCj4gI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRpb24u
aD4NCj4gKyNpbmNsdWRlIDxsaW51eC91Y3MyX3N0cmluZy5oPg0KPiArI2luY2x1ZGUgPGxpbnV4
L3NsYWIuaD4NCj4gDQo+ICNpbmNsdWRlIDxhc20vZWZpLmg+DQo+IA0KPiBAQCAtMjAzLDYgKzIw
NSwyMSBAQCBzdGF0aWMgdm9pZCBlZmlfY2FsbF9ydHMoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQ0KPiAJCQkJICAgICAgIChlZmlfdGltZV90ICopYXJnMik7DQo+IAkJYnJlYWs7DQo+IAljYXNl
IEVGSV9HRVRfVkFSSUFCTEU6DQo+ICsJCXVuc2lnbmVkIGxvbmcgdXRmOF9uYW1lX3NpemU7DQo+
ICsJCWNoYXIgKnV0ZjhfbmFtZTsNCj4gKwkJY2hhciBndWlkX3N0cltzaXplb2YoZWZpX2d1aWRf
dCkrMV07DQo+ICsNCj4gKwkJdXRmOF9uYW1lX3NpemUgPSB1Y3MyX3V0ZjhzaXplKChlZmlfY2hh
cjE2X3QgKilhcmcxKTsNCj4gKwkJdXRmOF9uYW1lID0ga21hbGxvYyh1dGY4X25hbWVfc2l6ZSsx
LCBHRlBfS0VSTkVMKTsNCj4gKwkJaWYgKCF1dGY4X25hbWUpIHsNCj4gKwkJCXByaW50ayhLRVJO
X0lORk8gImZhaWxlZCB0byBhbGxvY2F0ZSBVVEY4IGJ1ZmZlclxuIik7DQo+ICsJCQlicmVhazsN
Cj4gKwkJfQ0KPiArDQo+ICsJCXVjczJfYXNfdXRmOCh1dGY4X25hbWUsIChlZmlfY2hhcjE2X3Qg
KilhcmcxLCB1dGY4X25hbWVfc2l6ZSArIDEpOw0KPiArCQllZmlfZ3VpZF90b19zdHIoKGVmaV9n
dWlkX3QgKilhcmcyLCBndWlkX3N0cik7DQo+ICsNCj4gKwkJcHJpbnRrKEtFUk5fSU5GTyAiUmVh
ZGluZyBFRkkgdmFyaWFibGUgJXMtJXNcbiIsIHV0ZjhfbmFtZSwgZ3VpZF9zdHIpOw0KPiAJCXN0
YXR1cyA9IGVmaV9jYWxsX3ZpcnQoZ2V0X3ZhcmlhYmxlLCAoZWZpX2NoYXIxNl90ICopYXJnMSwN
Cj4gCQkJCSAgICAgICAoZWZpX2d1aWRfdCAqKWFyZzIsICh1MzIgKilhcmczLA0KPiAJCQkJICAg
ICAgICh1bnNpZ25lZCBsb25nICopYXJnNCwgKHZvaWQgKilhcmc1KTsNCj4gDQpIaSBNYXR0aGV3
DQoNCkkgaGF2ZW4ndCB0ZXN0ZWQgdGhpcyB5ZXQgKEtlcm5lbCBpcyBjb21waWxpbmcpIGJ1dCBJ
IGhhdmUgZm91bmQgb3V0IHRoYXQgdGhpcyBwYXJ0IG9mIHRoZSBjb2RlIGlzIGNhdXNpbmcgYSBj
cmFzaA0KDQoNCnN0YXRpYyBfX2luaXQgdm9pZCAqZ2V0X2NlcnRfbGlzdChlZmlfY2hhcjE2X3Qg
Km5hbWUsIGVmaV9ndWlkX3QgKmd1aWQsDQoJCQkJICB1bnNpZ25lZCBsb25nICpzaXplLCBlZmlf
c3RhdHVzX3QgKnN0YXR1cykNCnsNCgl1bnNpZ25lZCBsb25nIGxzaXplID0gNDsNCgl1bnNpZ25l
ZCBsb25nIHRtcGRiWzRdOw0KCXZvaWQgKmRiOw0KDQoJKnN0YXR1cyA9IGVmaS5nZXRfdmFyaWFi
bGUobmFtZSwgZ3VpZCwgTlVMTCwgJmxzaXplLCAmdG1wZGIpOw0KCWlmICgqc3RhdHVzID09IEVG
SV9OT1RfRk9VTkQpDQoJCXJldHVybiBOVUxMOw0KDQoJaWYgKCpzdGF0dXMgIT0gRUZJX0JVRkZF
Ul9UT09fU01BTEwpIHsNCgkJcHJfZXJyKCJDb3VsZG4ndCBnZXQgc2l6ZTogMHglbHhcbiIsICpz
dGF0dXMpOw0KCQlyZXR1cm4gTlVMTDsNCgl9DQoNCglkYiA9IGttYWxsb2MobHNpemUsIEdGUF9L
RVJORUwpOw0KCWlmICghZGIpDQoJCXJldHVybiBOVUxMOw0KDQoJKnN0YXR1cyA9IGVmaS5nZXRf
dmFyaWFibGUobmFtZSwgZ3VpZCwgTlVMTCwgJmxzaXplLCBkYik7DQoJaWYgKCpzdGF0dXMgIT0g
RUZJX1NVQ0NFU1MpIHsNCgkJa2ZyZWUoZGIpOw0KCQlwcl9lcnIoIkVycm9yIHJlYWRpbmcgZGIg
dmFyOiAweCVseFxuIiwgKnN0YXR1cyk7DQoJCXJldHVybiBOVUxMOw0KCX0NCg0KCSpzaXplID0g
bHNpemU7DQoJcmV0dXJuIGRiOw0KfQ0KDQpJZiBJIHJlbW92ZSB0aGUgcmV0dXJuIDAgSSBoYWQg
YWRkZWQgZnJvbSBvdGhlciAzIGxlZnQgZnVuY3Rpb25zLCBjcmFzaCBkb2Vzbid0IG9jY3VyLg0K
DQpXaGVuIHRoZSBrZXJuZWwgY29tcGlsZXMgd2l0aCB5b3VyIHBhdGNoLCBJ4oCZbGwgc2VuZCB3
aGF0ZXZlciBJIGdldC4NCg0KUmVnYXJkcw0KQWRpdHlh
