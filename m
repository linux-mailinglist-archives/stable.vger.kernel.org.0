Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F344B0B1E
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 11:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbiBJKnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 05:43:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiBJKnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 05:43:52 -0500
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0186.outbound.protection.outlook.com [104.47.100.186])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338B8FEB;
        Thu, 10 Feb 2022 02:43:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCf3k0EczFPQGQOIk2tSXA2wRAjGW4UM3mwPQ7PyZcMWoEn8mtsTm0KhUgd79la2vu61yyJx3L0Bg9MJ+0bqo9EQ7ff5AaAK1AmzUGcIo3ABW/WsQ5jQIqpHZZ7K295bBY+OEZ5XPpdqUhP08ifo2pjSRA5PaRsFoz8o2h5K0qaz0sRqkGFNNLPuOwEAAy+JI5+Xuus6rUV3/RMqnGjzjJPq8hAh7WQiLdepAF4yq1Lkm+fjJ1z4CAWn3jAJ4m9FiAP37jcYafdKpCLpJ6JnbTQx5jyf4RUckSQNNfSVR/NDnKZ2tal2VqtB//T61bQh3lfWTZIPnVwAT9t2GZOhYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HR8hxoWG6eBDQ9MJIiQ3cZ1oOZNudIGuurwTPAjeH0I=;
 b=HJ2YJEv8ntwhuDwk06toGLZMkKpCRrppnDsBxfNy1/O1/xOdwTJKtPXwS/QMXfnMPdijgML4Tj+HymKTBtTQmqJDqromuWsY4MDLoju0qFQk8hNDkg94sPOG1WW/Ct0SouWB1hZjATjnzKniefFBPOS/k7R1Yosale7vJlfnrt4LdferqdbmJ27HP84cVyt/q6iSTkViXI4AAOyXyIhSD0O/aty2IMl/FKPGIDu5JKhJaM8LUfSOMKxa62/dP2ZX7YwppV6rqrKEPMZqJ0kXsV7gYIxd9szBxNMl9gabWv9Az9l9QEfP44dIAoKNpTPj6WAhuS0PiB4/IY0jnwGBRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HR8hxoWG6eBDQ9MJIiQ3cZ1oOZNudIGuurwTPAjeH0I=;
 b=C6KN3/6BijjIbfHS4Q5C8Zm6b2hIgSwQgY3ncslvg4nPHriFAg3U015QNp3UoVjTLu9f+3zn/2mfsnNpkNeRdUNY5lf+dDgyYGK9GEbmfsfK8UHflyhzf0EO3kePzCcb9lyPOW1AbwJjGIN5icvlMnQ2sPD0sBdqBHtXmAzHS4a2Lu/j1ffUCa+Zd+6ZQbfwxnu94hicHmQhgLciK3RrwGT6w8KFzj/QUemjN7Q8sQxUmhjxLzhsFT80QfD8N+HQgwrI1W7CuiBa6t6vQLkWf4F3cBS5AXGd7WJa8XocKk1+Y1wzUvLhcYO4bXK7CobDG6FHXUs657j8DVhO+TIHbQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR01MB3298.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 10:43:44 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 10:43:44 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     David Laight <David.Laight@ACULAB.COM>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jk@ozlabs.org>,
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
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLWtAAgAE/0QA=
Date:   Thu, 10 Feb 2022 10:43:44 +0000
Message-ID: <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
In-Reply-To: <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [EHYs5ayktjdiWoZONP0WJE9JKe1ig2ZFrhy41ShdUdUpH35cTMITbC/u66e8IGyz]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a307a348-c60a-41d1-e26a-08d9ec823627
x-ms-traffictypediagnostic: BM1PR01MB3298:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HN2sar2Y7qWgAe5oFnM/yIKqxl38zoZGhSu7Ey+MVPdDDzovMbMx1kcK2Ewdb7789MmHeSyAMoeSWrtcBwiz2yEn6wv4FvZ8wnVRHXbFGXAGiFWjpGCSmloJnTWcInnCTm165Wud3380br+nhXbvV/UYSc+Zi77rThfF+TBTO4NTpsMLzdLUxMkv9wxeumQohx53Hymp31D87Y3169uZZldRmaUtzIFpBVky6ULRr35/MKfTNCENBlqTmR97pnSbXWyCUbQEX8y10girle+Z+1kJBmm91ki3icdLN6Dk+4KqxTYpBh5BPFpfGqb+aHP4nrrSz7//T7snhypIjaPZ1JlLoj6bfM1vrff4Wbu2ByrBzIUzP4hGkJMvNZrO+XgnB6+yPi2NyJrVhLtqm2yF6e5S1v/IlkmrRzby7OQu/pX7mVdbHu5rl6E5FlbEMsvCy8QoZ/taxLDN9KPf2IpYcyh+VqNpHnq66lydRIFLMYHLHXpMS1/pgqfED6dKv7y0onA2QzsqyeWdU1enRIg+SAdxlGWfhKTTZ1PwuaJaM6om8EjqP6PAZdY449RhRt1CvcarvcDlEkI1X7ixZtpeBQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVN6cVVhN3d1MWRsUllMWER6cTg4UnhIZE44RVZIakRHQThvSVhqdllReHpS?=
 =?utf-8?B?WVhnYldTeHBLWFpwUXIwRTQ0bVppbDNUazdWRWpXVE91QnlsRklQTWtRd2tu?=
 =?utf-8?B?WTNLblRYaENlNzVEL2FIV0lBZW9YTDNNRk5kWXZuRmR2MFlwVTZyM1FZWEds?=
 =?utf-8?B?NVA4dTJHVmNGZHpDK3RFemx2Qk9kbmt2MEhDWVZXR0xSV0dxUWo0ZngvRUxP?=
 =?utf-8?B?azVOZzJqa2tWeXZ1aEpNZzZOc205bWhEdW1MS0pxUXRkYnRFMWh2WnN0QkE2?=
 =?utf-8?B?elE5R1RtUzdkWW9DZ1diMnZRNUk5V21EVGxtWHJ4c2dSNUs1TEF6MXdsdkZ5?=
 =?utf-8?B?Zlp3VGgyWkdvYVl0cm5aLzF5dlNLUHFWNTJDZSsrR0lGSkVBUFpSTDNqVnZE?=
 =?utf-8?B?eGZEWDVRcEx3bTRER1VQUGlhVWMzTG11Nk9pTys0Yk16MjQwMG5pVkJtWDhp?=
 =?utf-8?B?d0NId3VQMWNlQnFRRUtIS01KT1lrMjdzRXJGWnd0T0grNTRPTk91RXIrRDdr?=
 =?utf-8?B?aTZldFRDVCtJUDJRaDh2K29vVWJNdTJTYjdEdkVnTy9wWTUwaVp0R1Y0cWJZ?=
 =?utf-8?B?dStXd3pXS0hXNVBZdGF1KzFjWTlyREtPOEp5ZEV4ZzlrVjMyZVlhdEdoUkJJ?=
 =?utf-8?B?UTBtbnYraDM3aUxNa3NDNVF6aHQrOHRLdXdpeTBEY3RyR2NxdkpCZGpBTHE3?=
 =?utf-8?B?YlF0SzB0RVNhdWNMN0VQaEQ3Q2RaYmtuUTh6VmFFWW9aYU1DNlZzazhoMTFQ?=
 =?utf-8?B?VlpXTmNOM0drcWkyQnAxZWdVMU01UU9QYUpjbllScmNmdm5oQkVRaFhUMjdS?=
 =?utf-8?B?TTVqYXRlaEV6NHdTZ3ExejF4RDdobW5BcCtJSXVva204N3pwMkx3Z3pJZEJF?=
 =?utf-8?B?eld6N3hiSHdweENxSEJQU2dMTFZNZEdVUElZbjIyZEc0dzFCT0tMWHRQajVs?=
 =?utf-8?B?WGkxK1VRdWdUdTlyUC9RK1IvWWlnTUVGeldGbHpXTUhReURmaUJsRmNZTm93?=
 =?utf-8?B?cC9ndkpNdUk2SG1JVjgvOWdWeThHQTdBQ1Z5ZUlOUy81WW85SjNVVlBXWGdz?=
 =?utf-8?B?Q1dUd25tRml4ZWh3OW5wSVB3eExGMktTZjhOSjRYa1BrSWEwS0NSelhzR29U?=
 =?utf-8?B?U2VJbnNGa016SVFMODIzRGJsc3daQlBGdE8xM3ZWWHpKdkt4UTBtRlFNdGpa?=
 =?utf-8?B?QS93dXVlVTRBMEQ1UHdCY0hZWU9LMkpHZVdjRmlTMkZDaEMxQWRyNUdVTGQ4?=
 =?utf-8?B?Mi9mY1AxVW5oOEJTL3QvbmtpU3pLbkphOXNXT0VEb3ZNSW5nQitzYk9kaldw?=
 =?utf-8?B?cTZQWVh3Q3oyM0ltMzJ1M1lXRkhvSkJpajBQNlk4NEVCang3UmQ2RGVORXA1?=
 =?utf-8?B?U1VQa1V4SmxQcUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7463FDAD6DA416498676CCE48BE39EDE@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a307a348-c60a-41d1-e26a-08d9ec823627
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 10:43:44.7341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB3298
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gT24gMDktRmViLTIwMjIsIGF0IDk6MDkgUE0sIERhdmlkIExhaWdodCA8RGF2aWQuTGFp
Z2h0QEFDVUxBQi5DT00+IHdyb3RlOg0KPiANCj4gRnJvbTogQWRpdHlhIEdhcmcNCj4+IFNlbnQ6
IDA5IEZlYnJ1YXJ5IDIwMjIgMTQ6MjgNCj4+IA0KPj4gT24gVDIgTWFjcywgdGhlIHNlY3VyZSBi
b290IGlzIGhhbmRsZWQgYnkgdGhlIFQyIENoaXAuIElmIGVuYWJsZWQsIG9ubHkNCj4+IG1hY09T
IGFuZCBXaW5kb3dzIGFyZSBhbGxvd2VkIHRvIGJvb3Qgb24gdGhlc2UgbWFjaGluZXMuIFRodXMg
d2UgbmVlZCB0bw0KPj4gZGlzYWJsZSBzZWN1cmUgYm9vdCBmb3IgTGludXguIElmIHdlIGJvb3Qg
aW50byBMaW51eCBhZnRlciBkaXNhYmxpbmcNCj4+IHNlY3VyZSBib290LCBpZiBDT05GSUdfTE9B
RF9VRUZJX0tFWVMgaXMgZW5hYmxlZCwgRUZJIFJ1bnRpbWUgc2VydmljZXMNCj4+IGZhaWwgdG8g
c3RhcnQsIHdpdGggdGhlIGZvbGxvd2luZyBsb2dzIGluIGRtZXNnDQo+PiANCj4gLi4NCj4+ICtz
dGF0aWMgY29uc3Qgc3RydWN0IGRtaV9zeXN0ZW1faWQgdWVmaV9hcHBsZV9pZ25vcmVbXSA9IHsN
Cj4+ICsJew0KPj4gKwkJIC5tYXRjaGVzID0gew0KPj4gKwkJCURNSV9NQVRDSChETUlfQk9BUkRf
VkVORE9SLCAiQXBwbGUgSW5jLiIpLA0KPj4gKwkJCURNSV9NQVRDSChETUlfUFJPRFVDVF9OQU1F
LCAiTWFjQm9va1BybzE1LDEiKSwNCj4+ICsJCX0sDQo+IA0KPiBJIHRoaW5rIEknZCB1c2U6DQo+
ICNkZWZpbmUgeHh4KHZlbmRvciwgcHJvZHVjdCkgXA0KPiAJCSAubWF0Y2hlcyA9IHsNCj4gCQkJ
RE1JX01BVENIKERNSV9CT0FSRF9WRU5ET1IsIHZlbmRvciksIFwNCj4gCQkJRE1JX01BVENIKERN
SV9QUk9EVUNUX05BTUUsIHByb2R1Y3QpLCBcDQo+IAkJfQ0KPiBzb21ld2hlcmUgd2l0aCBhIHN1
aXRhYmxlIG5hbWUgKGJpa2VzaGVkIGJsdWUpIHRvIHJlZHVjZQ0KPiB0aGUgY29kZSBzaXplIG9m
IHRoaXMgdGFibGUuDQo+IA0KQWxyaWdodCwgSeKAmWxsIHNlbmQgYSB2MiB3aXRoIHRoaXMgYWRk
cmVzc2VkLg0KPiAJRGF2aWQNCj4gDQo+IC0NCj4gUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRl
LCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQo+
IFJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo+IA0KDQo=
