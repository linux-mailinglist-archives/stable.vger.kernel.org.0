Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F2F4B3A1B
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 09:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiBMIWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 03:22:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiBMIWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 03:22:46 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2081.outbound.protection.outlook.com [40.92.103.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81FE5E773;
        Sun, 13 Feb 2022 00:22:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+1i1crfX3KxGnPMIYkggdvSVU5pVRJTXJtc83DfHpZdDBQXRL63vQm5e1DtT8f2BokILSjxo1qbDvFOiAiYyWlanA7yV2YuuI1HR8vKI8VGRGcU2r1KB75eJDNndQeGC6dccqzKuju8U8nU7OLQBufdaHnZPwgmHTAR3+5Yk9TV3gySiYMnJHSgQf+cg1IW9mku3MkXYfXPmelDR5fgmB1G8rd5JxDFuGK7kFZ6UcU97bxENlksfg0GHRJGQYxpXoW5+jDHNO1QpMVja494KzQMgpd/VHwP+mBw4zQncI3/c0eToFc4mGnV4D+ZEVlJfCWwJUt7CcelRcjIQLE69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHhzzRU8BekJSsgXLytNspQn0RMsx632b0sdKlHWCVA=;
 b=Y+oJuJilVTlNajdiHYL11q1gEzh8c8rYlnLzkluaZigSWFZXvAFi+HbYQAgWmBTvB1GWP3bLb0r5+lomM3k2YMws8x+HTjKJSkKqlYHlaJWzqs1PDvtRcXFgMvvSuDZU3yIjKCybRz/ujTonZBDdPuYx55O9BZLzQYoHd7uh9X5+W7u91rjF9FB/RItbgzVg9+V8Bv2ZCW2bcfsi4b6MwQGfX3ARMC+9y9JpYKwVrd6ERteOTkRNrKGeoLlp3/UVZsMPJJtcGB1ujXGooitAS2hFnBY4c29VY+sMP7qNoBKFH3+h9gRo3jTPmzLTuZlcQ+3vhet3XxuFh0VM56a+cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHhzzRU8BekJSsgXLytNspQn0RMsx632b0sdKlHWCVA=;
 b=rC2HOBlaxgF92aZyAvxMFlL9qaU8GQFq1ttIg8cwu015vBgrVnHBZHBnnlkr9vI2TKz+sjXUs8NH66ruIMVItFhi4b9+o8PVosqfZf+njeKNb7D3b/G8kZf9u404ocsvwcirQBUog6F6LS7kSvTV9PxPPgdKOnE5KeIPUtCdeHDMJm6NljKArqpYR/FIqoPWBv4wLAOHbEfYzJzFYuG042p7hiyc3CJIolAOqUcU+Xq+FBUgPfHOw6KQrr4O3ejg/KQJzp4KSRbTXtecpoODI1c0JC3hknoIMQMLF6P7/reJgSMsVBwGnhg1jnYQl4zrI+zeFS6t9+2vgd0rtezN/A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MAXPR01MB4031.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:69::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Sun, 13 Feb
 2022 08:22:32 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Sun, 13 Feb 2022
 08:22:32 +0000
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
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLbqGAgAAURwCAAAlIgIAAESOAgACrMQCAAM6NgIAAs3IAgADC6YCAAODbAIAA55oAgADUSoA=
Date:   Sun, 13 Feb 2022 08:22:32 +0000
Message-ID: <C737F740-9039-4730-9F08-9E9E9674B6C8@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <20220209164957.GB12763@srcf.ucam.org>
 <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org> <20220209193705.GA15463@srcf.ucam.org>
 <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
 <20220210180905.GB18445@srcf.ucam.org>
 <99BB011C-71DE-49FA-81CB-BE2AC9613030@live.com>
 <20220211162857.GB10606@srcf.ucam.org>
 <F078BEBE-3DED-4EE3-A2B8-2C5744B5454C@live.com>
 <20220212194240.GA4131@srcf.ucam.org>
In-Reply-To: <20220212194240.GA4131@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [6PrThstV6g+EaiiOe5IVrnB2uigDvoBlzFzittS4ofJ4zZybhl4AhCO8FRvYAW0q]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5be4c9d-15ec-4de1-a269-08d9eec9fb45
x-ms-traffictypediagnostic: MAXPR01MB4031:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vsXWX1sPOYrGo6kbDjk4EdSu7Q61sCPHy1F76BhxIgkFKmcjL9HXNfuCMiKzHBMU81/g8QwoUnh/qLAvfH69piFJT5zwxPLonBDpbjCEJoS4VWz2JsD/c3oUtMth0P1oEqB/4Q2LmlQlD+05egs3Oi66kFBHC5dlZtKTFykrUhWQhLn4tsOOrbbb8CAUaxQr62PCMAUDgVlYZVTWAJBPZ2MxsLRE3EakCqiigTzDNqQ6T9t+KiBrkEjBZWqsUxzJfR2VcfJ4VxuFF5o7ezbczF27MDrY0s1vrRnuwrC7DHzHq9pIwdSkd2zyj8+hy1K0jV9YQEKgTjpWI61GEECKIhmiq1XVH90pckLlTLw2E22NY7QD5gZSFfFQ+uYCYYGrpS5t1mNLo8IpsuGRN75ngFIMjpYe1tSsE74rrSWt00WUwVdpwHvML5HkvFBeyVdXFZAnnMEKEKmoXHX6/JtZ7SRVLs/HETobe0PhL3M9Pn47VxsCd0TapxDEWM2ngoIfJ0m/AFmXtmTVqcKZdzVSLdOxmVJ0xztlKfsZNTVW72VCq0x90nSYgTIheZ+tVNg4mkSGsZ6WoIiz4eMKUgKkuagPGFFDX2U5QthrPEtk30uhpv+jE6mbsKh7L1sz/i1i
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnkrTm1JMmlremRVSitzK0tjQXhOek5yQU1xU1pJQyt5RXBIUUduR3NQQUl0?=
 =?utf-8?B?NHFPdjVnSDd2bDRxTWJ3cS82NHVVRlZTS3NVb1Vrbm5qRGVOdWpyYkZBV0hl?=
 =?utf-8?B?enhtKzhnWTlCMndSMjVMKzB6VXY0c1hSMjNNYnFoWG9PcUQ3VXBLVUN3bkp1?=
 =?utf-8?B?bFhEc2IyYUI2a0NHbkcwWTJUMzRyUXgwb21PVWtUVjFuS0ZjS05oOCszN1M3?=
 =?utf-8?B?c1pNenlzcmtpMmRFS0FGdUxOMnI4SWpzQURhZ2czVnBYZGZpakhGVWJQUkZs?=
 =?utf-8?B?YTNHcWNyUHBzZTZremk0SWdwRm00VEQvaFJHVFVXeGRQaXhOSVZQMC9EaDBC?=
 =?utf-8?B?VmxFRkEwSzlJWi9manR3RlFibG9rSWYxcGhWdk50c0kxd2Nlb1ZOdCt2MjVQ?=
 =?utf-8?B?UXFiSUQyVURSckVnWjNrYVJHUHNCT0Yyc0VuZ2pDS3UvWVhuWTFqc3k0SEZi?=
 =?utf-8?B?MXRncTFoL2lrZ2F0T3ZETTVHZFY4RjIzbUNjL09VY2Qrd0Y0a2Q4Wm9Ic3VR?=
 =?utf-8?B?VnpyNWNiTW9ySGhkZ3NqMEZTc1B5SzFKZUNYTTFCaUdGRnNLZHoxR2M5QkVK?=
 =?utf-8?B?OEZuT2JhbmlWdXY2M1ZSK2ppMjhIQXAvSGZKNXRwRGU5bkMvVjFIQk9HWkZP?=
 =?utf-8?B?U2x0aXcwVDIvSzJsZ2E0azFSR2FCcEJFV3dVbUEvUGtCcDRzNkg3SmdGcFp1?=
 =?utf-8?B?d1NmOEZjOFV1VDJ6QTM2SG0veWQ5QkU0ck1uVHpJWFhrMlVUR3BvL3V1RFFV?=
 =?utf-8?B?aWpzVGNVMFlQdnAycDJpdC9tWlRnUFYyNGx0VERsT1RRaHpjQ3lOZkErNjFr?=
 =?utf-8?B?MDdsbjBZRnJ2M1p6QjZxbEtrbDUzWCtRcW9UYWdxeWpGU1hSWE95T0NSeHJW?=
 =?utf-8?B?eWJkZU03SkNZeDhQa25PNkJoMzZydmU2aEZYc2VmRjlTeHhJMjhHT016djFT?=
 =?utf-8?B?VnExZkpRbm4ya1V1YzVoL0RwMWp4azAxSFNaTVpNaWZkZ0h1bmVZZW4xTDFq?=
 =?utf-8?B?dGxiQWN6WHMyMHQzallCL2E3Nm0rUWYyU2s5eEwySnF3YVJ2RGMvWjFlSVhG?=
 =?utf-8?B?bjI0MFcvV1NSLzdqclI1dExKTldoSVNxUkswRUhBV3BwcnphQjUvU3hocUR1?=
 =?utf-8?B?eG9BQ0dEc0ZtK01UcktmS1oxNVhMeWZsaC9YQUUvM1o3VFRJU3JXWFVQWmkr?=
 =?utf-8?B?dHhYYkJWNHQ0Vk1GQXE4dVVJYUFQMWZPd3JwWWVpa0tsSXFydE5qV1AwOU44?=
 =?utf-8?B?cW5ZUUNaRUZzd3B0b3Fpb2tkOFVJc1ZUU004eTMwSVVTMHh6b1RReU9aRUJN?=
 =?utf-8?B?ejh5L1gvbkZnLzBTT25kMTRDczJ3di9Yb2QxSW9qV1NjYmw4ZFJ3NDV4Y0tm?=
 =?utf-8?B?bjBOYkNIN25scHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05FF4373BEF2F4439D6DA672C66DB7B6@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: f5be4c9d-15ec-4de1-a269-08d9eec9fb45
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 08:22:32.0492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAXPR01MB4031
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gDQo+IE9rLiBXaXRoIENPTkZJR19MT0FEX1VFRklfS0VZUz1uLCBjYW4geW91IHJ1bjoN
Cj4gDQo+IGNhdCAvc3lzL2Zpcm13YXJlL2VmaS9lZml2YXJzL2RiLWQ3MTliMmNiLTNkM2EtNDU5
Ni1hM2JjLWRhZDAwZTY3NjU2Zg0KPiANCj4gYW5kIHNlZSB3aGV0aGVyIGl0IGdlbmVyYXRlcyB0
aGUgc2FtZSBmYWlsdXJlPyBJZiBzbyB0aGVuIG15IChoYW5kd2F2eSkgDQo+IGd1ZXNzIGlzIHRo
YXQgc29tZXRoaW5nJ3MgZ29pbmcgd3Jvbmcgd2l0aCBhIGZpcm13YXJlIGNvZGVwYXRoIGZvciB0
aGUgDQo+IGQ3MTliMmNiLTNkM2EtNDU5Ni1hM2JjLWRhZDAwZTY3NjU2ZiBHVUlELiBTb21lb25l
IGNvdWxkIHBvdGVudGlhbGx5IA0KPiB0aGVuIGZpZ3VyZSBvdXQgd2hldGhlciB0aGUgc2FtZSBo
YXBwZW5zIHVuZGVyIFdpbmRvd3MsIGJ1dCB0aGUgZWFzaWVzdCANCj4gdGhpbmcgaXMgcHJvYmFi
bHkgdG8ganVzdCByZXR1cm4gYSBmYWlsdXJlIG9uIEFwcGxlIGhhcmR3YXJlIHdoZW4gDQo+IHNv
bWVvbmUgdHJpZXMgdG8gYWNjZXNzIGFueXRoaW5nIHdpdGggdGhhdCBHVUlELg0KDQpTdXJwcmlz
aW5nbHkgaXQgZGlkbuKAmXQgY2F1c2UgYSBjcmFzaC4gVGhlIGxvZ3MgYXJlIGF0IGh0dHBzOi8v
Z2lzdC5naXRodWJ1c2VyY29udGVudC5jb20vQWRpdHlhR2FyZzgvOGU4MjBjMjcyNGE2NWZiNGJi
YjVkZWFlMmIzNThkYzgvcmF3LzJhMDAzZWY0M2FlMDZkYmUyYmNjMjJiMzRiYTdjY2JiMDM4OThh
MjEvbG9nMi5sb2cNCg0KSSBhbHNvIHRyaWVkIGNhdCAvc3lzL2Zpcm13YXJlL2VmaS9lZml2YXJz
L01va0lnbm9yZURCLTYwNWRhYjUwLWUwNDYtNDMwMC1hYmI2LTNkZDgxMGRkOGIyMywgYnV0IGl0
IGRvZXNu4oCZdCBleGlzdA0KDQphZGl0eWFATWFjQm9vazp+JCBjYXQgL3N5cy9maXJtd2FyZS9l
ZmkvZWZpdmFycy9Nb2tJZ25vcmVEQi02MDVkYWI1MC1lMDQ2LTQzMDAtYWJiNi0zZGQ4MTBkZDhi
MjMNCmNhdDogL3N5cy9maXJtd2FyZS9lZmkvZWZpdmFycy9Nb2tJZ25vcmVEQi02MDVkYWI1MC1l
MDQ2LTQzMDAtYWJiNi0zZGQ4MTBkZDhiMjM6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCg0K
