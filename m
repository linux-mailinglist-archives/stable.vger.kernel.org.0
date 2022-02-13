Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA64B3A42
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 09:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiBMIgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 03:36:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiBMIgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 03:36:52 -0500
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0166.outbound.protection.outlook.com [104.47.100.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1505E15F;
        Sun, 13 Feb 2022 00:36:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCtB2KuVIczv+VQgLzb0LYjvlZ06e2sO1PnNwM07RMhlol3nBznjB+d194kWI4IVbQkCLniFTsWXp7ndrFzftn/rl7rlha0OqZAhxp20vJ3LsltMeGlnbVXPm3PVutLPdbX+iJ3k/rz0M1nh3DlG0UqF56Bq0UTe/cXkkYfG68e/Ndzk8NzVIYZeZQpUvmilLq9wly2VMt933mYHQEigCG8//BP0TiAJ9VZ4DXGHvButKriozQCoEVkvdXDBFLWCCI0tYyFjVP943oObZ6RB0Moqx9ti3ncqOB6EJdthenfzPj5LftGRnYdq6pBxQIMy9U/L1Cgr+1DIBUOr/OElHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hofoMKxDqk66TdQGEat0pfTaeLDCXiFpceuu9kwAeUQ=;
 b=isJVjZQyMKbIGg1ifresvq7Y5/njKzjESBVjDcE8EV/YnxBjrWZl7zYLEgbzx12/FsrV7gRVXR4r7QmokWHz98Hq1C/9wYjagLb2bJMkuoIi9rfJzL4L3Q9fhFlg6qbAZRysayCsRL5uLgI+7Ykcg7sDNAcZBfI9p3pUimFvTSZoUZola+UkPv56KVlBbiT7V1n+rrmNGoJg2i5dfMURjdGmVqc5a5zrAr6dwn9ALLD9E4r+WvVQdk2D3M/ZbB3rAxWmp8jajNSDIHmnlMQJn2zAnKLf2wf44S7zAUVQKHOosrlSlX8LqzJUMTAboE0JPrGUEFA8GlGgBFPe9ug4cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hofoMKxDqk66TdQGEat0pfTaeLDCXiFpceuu9kwAeUQ=;
 b=KgQQe3P/xxyg5184Qen7regAZEwI/23Wb8nLoHz6uClXWZ/cfAdQLGE8AWXyDcy0TNWYVJeSc3KG/y91cKiM2a7Dx1QtVkDiiR7DjBVjAg2r6csD9g/pN1Pki1Ar/ONJNPFJdJPquX1GwJHEvct7oCfpHCAwGY3Blc6r23yi49EUOJIpnNi25D3xz84zGyYsMkvr9b3JHQAynXFJM3TXTW7Zdq1tByNgK7B7zPWousWAFXprCGK3D/j6fw48xk6jlV2DLzyDe6ka+JlngDtjC2LMVVUz6tSdO4Pd3ruZBiCUz1dWle+zkR1RuO4y0reZIslbuY+u1qDy9DUd3ErpFA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR01MB2993.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:46::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 08:36:38 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Sun, 13 Feb 2022
 08:36:38 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Lukas Wunner <lukas@wunner.de>
CC:     David Laight <David.Laight@ACULAB.COM>,
        Ard Biesheuvel <ardb@kernel.org>,
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
Subject: Re: [PATCH v3] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Topic: [PATCH v3] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHmuXCUX8clA/f0+kyOomS1U+nayRHM0AgAAP+oA=
Date:   Sun, 13 Feb 2022 08:36:37 +0000
Message-ID: <96399AA5-F014-4817-B9E0-B6A988B6268E@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
 <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
 <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
 <7038A8ED-AC52-4966-836B-7B346713AEE9@live.com>
 <20220213073924.GA7648@wunner.de>
In-Reply-To: <20220213073924.GA7648@wunner.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [rd215yZdXrhSoV97/WLyInrsHy12UGqaVGhhnEKj0aaMpPxYdIm89zqHh6UQEygz]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21f3195c-797d-4103-12d6-08d9eecbf391
x-ms-traffictypediagnostic: BM1PR01MB2993:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S0PhH3DFgCCWk5+9uxUiWsrD/S0QFyWKSGVr8L222YQ56GlPEaLC2l0F5pTFpbQiznM/C6AOACqBex3MpSjbsIDtNa8lEVj1VQFEGOenjjpwv1xZgQ5bNnOF4AaD1tIi1xqaIWefAC+hvsJ7teOahtvUKqGpM1cAVgFPRs+WNMiTY9oSPYdZWnOOKem+BFZ5D4o74ZL1jr4U9HkQmJimORqKObb/2CVJUMfKwlkce7e5DA0qBH6GUOoBJocBEI4BrK01SE05jjLX5CMP0/BoYqvpIBY3x0TwipLmRv2iiJL/m63i07zgk6gkGBAZOnYOQfmh1MSMn85Bvvwe6w80zpt2NIfOPqEYdyQTT0AfTcFP5t/ZXZQq0Hsb5+kbR3chBkXuVQzK/buc6/bwKodA9xgad8V55xT2k7Cd2SbfDBhOy5L5d2Syc8CMlERgsgiqdCt6KNOeaJYB9J9VXhi1iP/A1eD53fexbcb3P0VTjIOxqhljFZA2IoqkbyGSGvpY6iIcWCXhbT+PSbDVlVukkJ7kJ1h64ksBjw2tV9XkU/opl2chmvvExHVIM0Z/BXbLaKtEj3uVKZ3TE9uXCQEy0Q==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzNwVGwveDZucVI1aUx4eFVnMkxTTDlTa1l4M1NGN3pGNDVrclBYNFZZVm56?=
 =?utf-8?B?NGZ2cDk1OW5GdlV1UEdKbWRrWEQ4V2JvRi8vVzlnb3pOMTVNbU1iSE8wL3hu?=
 =?utf-8?B?L3RtYWV2T3I3Z1pCOXJxV3VpQzBWU2Q3OXljMks4bE9CR3RBSEx5RWNiQjJZ?=
 =?utf-8?B?WnNXUG11YjNNNnBXcExLTytrZzcxMnFOaG9DdzdSRmRDYTRBK0R1eW1PNG9h?=
 =?utf-8?B?YWt5SHNqTFZSQzd0VWJoWGladEUrdGVHTk9RSW0ydC9TaXlZQVFpellydFZK?=
 =?utf-8?B?Wnd1eTRId1FJM2dnL0ZKWEpFUTVxcDBubmZKd0x1UGM2a1ZtNm41UDRTWEVu?=
 =?utf-8?B?aDFlSGV2bkRrQ2hsSUlXZjJnNnVBRGdHQytBS1YraU0wN29kYmpIMWFJeDZ2?=
 =?utf-8?B?alhabFk3dFVBaVpUc2E3TUttYUZBWEtBQzZDSWRuSU1YTlB1clVnZDlnZGpw?=
 =?utf-8?B?QXhKTjNOQW0yZ3ZvYm9MQVdwZE5VUDNwblhWUUx5SFczbTdHdktvOFYyWURz?=
 =?utf-8?B?NmtyZXVTSWZMWHRqcHZHZlRyWHRxQ2NTMXR0VElLY0hGeHYyZGVvRzBzY3Vh?=
 =?utf-8?B?bnFYL3NqYUp2VHdWZ1RuZWx1NFMvR1hSUC9xZit6Nk4vcFRIQTB5L2VvVDhu?=
 =?utf-8?B?VmhCMzYzVkg0QnMvQ2RhTlZMUVBaRlloUlRqbmVTZ3hhdE1kNHp5TFppT00y?=
 =?utf-8?B?YXFVVWlweU84OWtVTXE1dy81eVF4VVhmRkcxSlB1MStqcVhnVnRIRFFXOW1C?=
 =?utf-8?B?L0k2TTBKdDk4VDVTY3hOdXVoMXRNc2ZKdmIzeEtyQUlBRnZOakpwajRhOWd0?=
 =?utf-8?B?cnFMTVcraWlQWXlXTUZyZWVjdTZPcUZ3K3JjZHZyOFNPSkMwbnR4RmIyeGJa?=
 =?utf-8?B?clBQRUhxY3pDa1VBR2hTcGxVckdyaFFHTFRTSGJSS0NweFdFRDAxQytvaHRv?=
 =?utf-8?B?WElSOUxhUVFCSkE0V1c4K1dOYlROL0gvdCs0SjU2MU1UY3JVaHNSejgzMTA0?=
 =?utf-8?B?bnd2L0UwVFdnWXBsV0g0bVJjYXY5b0g4eitySGhkTDgxZExsU2xlRjROakZV?=
 =?utf-8?B?akViTmdaVHJFMHpvMlc3NVpFTS9TTnpTUlNvZ3dncFQ5ekdOcVlWdGNDTEJK?=
 =?utf-8?B?dktjQ0VBYWtmME10RVNBbW5SeXVEN3d0elhrcGF0dzNUMktVejFSSGRNdm1Y?=
 =?utf-8?B?c0luUHpKcjlKcmlLRXdHUUlXdzdreW56ZTFRZ1hCM21ybkJ5V0RkVlduRW9X?=
 =?utf-8?B?bDlCY2s2NkVkMmxkQ0pwcDhlL29hUW9RMXRxY0pVaEJuN0V5ZkZTWDNNdlNS?=
 =?utf-8?B?MnNWQzNDUXdOMHdjZVBxWkxuRFlQZ1c2U2x6aXdJaUphaUlCcUlHeERCVHRo?=
 =?utf-8?B?NlFKQ0FKMUw3cUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6134F423DF9B2489096816AFFFC88C4@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f3195c-797d-4103-12d6-08d9eecbf391
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 08:36:37.8966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB2993
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IA0KPiBUaGUgVDIgaXMgcmVwcmVzZW50ZWQgYnkgYSBQQ0kgZGV2aWNlIHdpdGggSUQgMTA2
QjoxODAyLiAgSSB0aGluayBpdA0KPiB3b3VsZCBiZSBtb3JlIGVsZWdhbnQgdG8gc2Vuc2UgcHJl
c2VuY2Ugb2YgdGhhdCBkZXZpY2UgaW5zdGVhZCBvZg0KPiBoYXJkY29kaW5nIGEgbG9uZyBkbWkg
bGlzdCwgaS5lLjoNCj4gDQo+IHN0YXRpYyBib29sIGFwcGxlX3QyX3ByZXNlbnQodm9pZCkNCj4g
ew0KPiAJc3RydWN0IHBjaV9kZXYgKnBkZXY7DQo+IA0KPiAJaWYgKCF4ODZfYXBwbGVfbWFjaGlu
ZSkNCj4gCQlyZXR1cm4gZmFsc2U7DQo+IA0KPiAJcGRldiA9IHBjaV9nZXRfZGV2aWNlKFBDSV9W
RU5ET1JfSURfQVBQTEUsIDB4MTgwMiwgTlVMTCk7DQo+IAlpZiAocGRldikgew0KPiAJCXBjaV9w
dXRfZGV2KHBkZXYpOw0KPiAJCXJldHVybiB0cnVlOw0KPiAJfQ0KPiANCj4gCXJldHVybiBmYWxz
ZTsNCj4gfQ0KDQpJ4oCZZCByYXRoZXIgcHJlZmVyIERNSSBjYXVzZSA6LQ0KMS4gVGhlcmUgYXJl
IGNoYW5jZXMgdGhhdCBzb21lIG5vbiBUMiBNYWNzIG1heSByZXF1aXJlIHRoaXMgcXVpcmsgYXMg
d2VsbC4gKEFmdGVyIGFsbCB3ZSBhcmUgdGFsa2luZyBhYm91dCBBcHBsZSkNCjIuIFRoZXJlIGFy
ZSBzbGlnaHQgY2hhbmNlcyB0aGF0IHNvbWUgbm9uIEFwcGxlIE1hY2hpbmVzIG1heSByZXF1aXJl
IHRoaXMgYXMgd2VsbA0KDQpJIGFsc28gYW0gbm90IHVzZWQgdG8gcGNpIGJhc2VkIHF1aXJrcywg
bWFraW5nIGl0IGEgYml0IGRpZmZpY3VsdCBmb3IgbWUgdG8gbWFrZSBhIHBhdGNoIGJhc2VkIG9u
IHRoYXQgOiguDQpUaGUgY29kZSBsZW5ndGggaXMgYW55d2F5cyBzaG9ydCBub3cuDQoNCg==
