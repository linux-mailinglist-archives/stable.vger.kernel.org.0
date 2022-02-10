Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46FB4B05C6
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 06:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiBJFuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 00:50:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiBJFuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 00:50:00 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2096.outbound.protection.outlook.com [40.92.103.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FE410CC;
        Wed,  9 Feb 2022 21:49:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhDhGF0cZvAQsugQ+U/be9+B7ykc9AydWQhp9O8EF/gwi9iaOcpWrYiiecXQi2fpTELh9zNjEGO7acAuRJmihRH9a9a/IPvhML53ElrZXEPPd0xdBZY2sff6p1hoX9EfIQrC7rDIGDWnoWwaLAWtuVH3e50AwHywmXlC6mrkLJtdEdCC2yV+tivbmRxamYyo9c4czCX5AVomXLmw9Nz7cvm5PMQiCAlvHkL8uAQPVPVr/I/jdaH4oQSZOCQVWExSylClQzPaNoIeAcTRjJCXioDVIRs/Jdw5V2ITyKc8p7INdKkg9ynxBEVbBuetHukG/Mu0J2vMNfOJ2RlBOdFHNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gJv/KZL3G8uBMc+qxf5xFrjc/bt0cRhhhQxWqz111Q=;
 b=nZVUekKgmoKN5ZwmygOqsTKMy0XQCFWd/QrPDU4jzQ/81sLZZGQDxG5c0K3l8WksLxfe4BrPWuG0rHwwH8N2X7uJlYNERX/VUx/TplbGvJCSwvWgXWLnqu1hcHj4I0daSN8mepf16cXZCR4hE2DivAxWTHusOGfMTPZBLg+rOzzVrCOZ5/OoqM8ZKnu6oyBuN6U/eAFRT+7rzfpL6ZTWlfDzgotfO1gsHU60SnAudoIAXKmeWGPtQUB/cOyqF1xBH/EI/jDBTQGQDcE3LQOETt+fhIW2VZW3nqwBdJLrIeSy6Yz0JdQSM2GaFLlc2ZuAWaU7a5RBl7t0TIDZ1o7PZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gJv/KZL3G8uBMc+qxf5xFrjc/bt0cRhhhQxWqz111Q=;
 b=QTFnbegGtig74sYlWNB6vHNdrWVw1wHEZ34hsGNd9W3ukh8Owj6PFmy3e286qASIxcZD5/K4VI7V9g2sgPNbrV+bKIqD/n6LxXmjDC1vjIsyQwyq0pDnlMDIlPDnkfgEqdQVxBXQ9RFQlwup5ZP11og/vuH+NU7x9DntibztYb0H8KeqgUe8shLdkxG2G1b3LH25mNJv5/Nw1sgrivl9sTXzu16D7p1S0EPCZR+nTvteZvuOJ+LbmEsW4INarWK/2scCXY69YiBQDHwRSuD7Fu9D38j7bB0ZMUZp8BsZtg0I6NiOd76gp02LSi1IbHqg2O8kPPJnFQrs1sudte54gw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MAZPR01MB6188.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:4f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 05:49:50 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 05:49:50 +0000
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
Thread-Index: AQHYHcE4ht34Z1CESEaNjR8+yzmieayLbqGAgAAURwCAAAlIgIAAESOAgACrMQA=
Date:   Thu, 10 Feb 2022 05:49:50 +0000
Message-ID: <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
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
x-tmn:  [AVVt1TY7MbivUqU6cOCQy8ZG7cDzk9RcEw9FfLkWhI0av+dBQRVfd5jk3lapYitL]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5c9a40b-9aef-47ee-c1ef-08d9ec59272f
x-ms-traffictypediagnostic: MAZPR01MB6188:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mZvaVHq2r4OfPlIup445oHc+udzhB6VS55g85fLFTpkui/cobq0kIir9jOVsv8M21oOJ9oK+7IBY5e+1mmAy7Yd+iB8LnEaetiIgiFmpwDktMENLtHW3cs2aTXzxuKlIoH6TxbvSjgqqPH+vEoUJ9j2KMhAnj75PzcGv7SjZFhVLYnBsiYkqhjwpoB5YoQvUGj9LmeD9Pc0KBbbpJTFa7WNKz1QIyyv/sy6YviOiryl5d9q8Y6VatA/rpXfH+mC47iFBPqF8Tm2o/zu7xRYeOADiNpjpz6xmStCXGA/6BoHY6Vo0T4tjEGzHsna92D/UOAgSuEsq7MHAKzytf2KfKQNQU0Waxy4thFTlGzYGxSwV6qBAN/sNMtAci0uzdp/vFGu69SU0TlIpDpY0xpDSuMfJCqXBsSf7GooDP6nh8yFW23o4/81f6/HQ1AtrM3OmX3GAkIVwVo3taRvPHa0XsRX9TPakwXmTdda8Gc2Mi2TCNT82pbCI4EqY62bqzeKkmeH5cWltYHW0LanYnIrt2DF1y/yEUpsWrmH0p054eLwp7sr2YuEZUYEljg8vwuAflbrMZzMs8NdjKm27p3puUA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STdNekdnWkM1Ymg0Z1M4K1ptWGt3SElPclREc1JVaU9rbkdaSitITTV6Y3ly?=
 =?utf-8?B?azh0ZkxZUVlhdEtNTnVLRFFDb2RTdjdPSDB3Ulk0SUtMa0ljb1BjRy84NWo5?=
 =?utf-8?B?WDFKTGV6R2JIN3o3OENtWjFLOWRudC9SSGg4UkFiMm1yMWF5TVF1WEh6VjJs?=
 =?utf-8?B?SzBjUGJBcHR3YnM2QkJCVklXemdMTlluN2Z1NG4zWnB3dWxlMkpySkVKVUlM?=
 =?utf-8?B?Um9uNkJUTFo4TlZNdTFjY1VNK2x0NThqU1JTZk1RWlJZL0JrMDUwc0d0M3RO?=
 =?utf-8?B?QUZMRmI2czJXYWh2aThhaEtsZ1hXUURxODVHK2xXaWtvWG1zdmV3akNkZXRW?=
 =?utf-8?B?ZkNiaGNiYkM0S3lFcS9LVUkvblpDcjlJV1RMdUlOMFJudWFRYm13RjltQWZL?=
 =?utf-8?B?eDlVV2lMeEZSbnRuZUwvaEdUMDdKNWw2eUZWdm1KM21FQ1Q1UDltTDVTTmlw?=
 =?utf-8?B?V3o3RTJQZy83RUkyRnVScGZMdmtOS1NvTkxJdTZURENQTFZkNlRBdlpjbG9E?=
 =?utf-8?B?dXVKbStaYVF4YzJaV09rQ0UveVBtNGpNenNSQ1lCMlJaS20vRWtwb0FBMTVZ?=
 =?utf-8?B?c2xONGEyNFdyZnFzdllZa05FTWFDTmhMU2NYZEFpK2ROeXhQOFY5N3Z6Sm5P?=
 =?utf-8?B?TEU4QXFRWkYxTEJYYUtOdE9xTUFMTWJVUFpTL2hqVjhYWTV2S05kZ05QQjR1?=
 =?utf-8?B?M0hHUHN6ZlM3ZjhWRnIzYkh1c3UvWndsVUdhVEJxL01RR3FhTWFaNXpJOHFp?=
 =?utf-8?B?VEdGTDNXMUpjSXV1bTRyUzJuTzVwZjRsYzFJYXdmVDNrcDdnNWhseE1GVHl3?=
 =?utf-8?B?ejdTbjJ2QjY5UkcwZDRkT0dVZExUZkt5TVBKdjNkY0hOOUJPUWlWWWdTa0cw?=
 =?utf-8?B?YWlGWjJqdWdZUEswRGJTYlc3U3A2aVM4eWd4WUc0RlR4RTlBeFZIV0lTSE9V?=
 =?utf-8?B?RWlaa3BaUEN3anZCcHhpYm1yNGw5VTJUZkozWjd0TlV6OWhOaG1PMHI1czcz?=
 =?utf-8?B?R0luT3pvYThxVXRCRDlGVGpQY2dEUFhtMVlEQWhwS2xOTVM3M0tzUDQ3cTRx?=
 =?utf-8?B?OTdxTkVNY2crQXl2VlRLMDN2amZ1MDlYVUUwSXMzYTFqWk9iWU1zclZrMVhN?=
 =?utf-8?B?eUtRQ2FjY1hoQmtZeUpTdlcwMUZRcC9NUC9tcnhtL3hIbVZJbmN1eTdPUFBD?=
 =?utf-8?B?dTV4Nktid01xbDlyYUk2TVFiK0oySG50TFlTcUM0aU54UTk0dzFVQ0hmdGZ6?=
 =?utf-8?B?RlpuNDFpMytYQnh4cWJBM2VaTyt2elpXZ0dVc3pEOFIvanMyZlZzbXpaUDVs?=
 =?utf-8?B?L0JrMmlBZ3psaFVrVFZNYzZJVE51RzRlWGRqS3hCekxRWkx6TjJrMnBHR2gv?=
 =?utf-8?B?VWNTRlByYlFDWlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B2E4E3AD804984D8D68CE5D5841228F@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c9a40b-9aef-47ee-c1ef-08d9ec59272f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 05:49:50.2852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZPR01MB6188
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCg0KPiBpZSwgY2FuIHlvdSB0cnkgc29tZXRoaW5nIGxpa2UgdGhpcz8NCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2Zpcm13YXJlL2VmaS9ydW50aW1lLXdyYXBwZXJzLmMgYi9kcml2ZXJz
L2Zpcm13YXJlL2VmaS9ydW50aW1lLXdyYXBwZXJzLmMNCj4gaW5kZXggZjNlNTRmNjYxNmYwLi4w
MWNiZDQ4MTFkMWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZmlybXdhcmUvZWZpL3J1bnRpbWUt
d3JhcHBlcnMuYw0KPiArKysgYi9kcml2ZXJzL2Zpcm13YXJlL2VmaS9ydW50aW1lLXdyYXBwZXJz
LmMNCj4gQEAgLTMyLDYgKzMyLDggQEANCj4gI2luY2x1ZGUgPGxpbnV4L3N0cmluZ2lmeS5oPg0K
PiAjaW5jbHVkZSA8bGludXgvd29ya3F1ZXVlLmg+DQo+ICNpbmNsdWRlIDxsaW51eC9jb21wbGV0
aW9uLmg+DQo+ICsjaW5jbHVkZSA8bGludXgvdWNzMl9zdHJpbmcuaD4NCj4gKyNpbmNsdWRlIDxs
aW51eC9zbGFiLmg+DQo+IA0KPiAjaW5jbHVkZSA8YXNtL2VmaS5oPg0KPiANCj4gQEAgLTIwMyw2
ICsyMDUsMjEgQEAgc3RhdGljIHZvaWQgZWZpX2NhbGxfcnRzKHN0cnVjdCB3b3JrX3N0cnVjdCAq
d29yaykNCj4gCQkJCSAgICAgICAoZWZpX3RpbWVfdCAqKWFyZzIpOw0KPiAJCWJyZWFrOw0KPiAJ
Y2FzZSBFRklfR0VUX1ZBUklBQkxFOg0KPiArCQl1bnNpZ25lZCBsb25nIHV0ZjhfbmFtZV9zaXpl
Ow0KPiArCQljaGFyICp1dGY4X25hbWU7DQo+ICsJCWNoYXIgZ3VpZF9zdHJbc2l6ZW9mKGVmaV9n
dWlkX3QpKzFdOw0KPiArDQo+ICsJCXV0ZjhfbmFtZV9zaXplID0gdWNzMl91dGY4c2l6ZSgoZWZp
X2NoYXIxNl90ICopYXJnMSk7DQo+ICsJCXV0ZjhfbmFtZSA9IGttYWxsb2ModXRmOF9uYW1lX3Np
emUrMSwgR0ZQX0tFUk5FTCk7DQo+ICsJCWlmICghdXRmOF9uYW1lKSB7DQo+ICsJCQlwcmludGso
S0VSTl9JTkZPICJmYWlsZWQgdG8gYWxsb2NhdGUgVVRGOCBidWZmZXJcbiIpOw0KPiArCQkJYnJl
YWs7DQo+ICsJCX0NCj4gKw0KPiArCQl1Y3MyX2FzX3V0ZjgodXRmOF9uYW1lLCAoZWZpX2NoYXIx
Nl90ICopYXJnMSwgdXRmOF9uYW1lX3NpemUgKyAxKTsNCj4gKwkJZWZpX2d1aWRfdG9fc3RyKChl
ZmlfZ3VpZF90ICopYXJnMiwgZ3VpZF9zdHIpOw0KPiArDQo+ICsJCXByaW50ayhLRVJOX0lORk8g
IlJlYWRpbmcgRUZJIHZhcmlhYmxlICVzLSVzXG4iLCB1dGY4X25hbWUsIGd1aWRfc3RyKTsNCj4g
CQlzdGF0dXMgPSBlZmlfY2FsbF92aXJ0KGdldF92YXJpYWJsZSwgKGVmaV9jaGFyMTZfdCAqKWFy
ZzEsDQo+IAkJCQkgICAgICAgKGVmaV9ndWlkX3QgKilhcmcyLCAodTMyICopYXJnMywNCj4gCQkJ
CSAgICAgICAodW5zaWduZWQgbG9uZyAqKWFyZzQsICh2b2lkICopYXJnNSk7DQoNCkxvb2tzIGxp
a2UgdGhlcmUgaXMgc29tZSBlcnJvciBpbiB0aGlzIHBhdGNoDQoNCg0KZHJpdmVycy9maXJtd2Fy
ZS9lZmkvcnVudGltZS13cmFwcGVycy5jOjIwODozOiBlcnJvcjogYSBsYWJlbCBjYW4gb25seSBi
ZSBwYXJ0IG9mIGEgc3RhdGVtZW50IGFuZCBhIGRlY2xhcmF0aW9uIGlzIG5vdCBhIHN0YXRlbWVu
dA0KICAyMDggfCAgIHVuc2lnbmVkIGxvbmcgdXRmOF9uYW1lX3NpemU7DQogICAgICB8ICAgXn5+
fn5+fn4NCmRyaXZlcnMvZmlybXdhcmUvZWZpL3J1bnRpbWUtd3JhcHBlcnMuYzoyMDk6MzogZXJy
b3I6IGV4cGVjdGVkIGV4cHJlc3Npb24gYmVmb3JlIOKAmGNoYXLigJkNCiAgMjA5IHwgICBjaGFy
ICp1dGY4X25hbWU7DQogICAgICB8ICAgXn5+fg0KZHJpdmVycy9maXJtd2FyZS9lZmkvcnVudGlt
ZS13cmFwcGVycy5jOjIxMDozOiB3YXJuaW5nOiBJU08gQzkwIGZvcmJpZHMgbWl4ZWQgZGVjbGFy
YXRpb25zIGFuZCBjb2RlIFstV2RlY2xhcmF0aW9uLWFmdGVyLXN0YXRlbWVudF0NCiAgMjEwIHwg
ICBjaGFyIGd1aWRfc3RyW3NpemVvZihlZmlfZ3VpZF90KSsxXTsNCiAgICAgIHwgICBefn5+DQpk
cml2ZXJzL2Zpcm13YXJlL2VmaS9ydW50aW1lLXdyYXBwZXJzLmM6MjEzOjM6IGVycm9yOiDigJh1
dGY4X25hbWXigJkgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pDQogIDIx
MyB8ICAgdXRmOF9uYW1lID0ga21hbGxvYyh1dGY4X25hbWVfc2l6ZSsxLCBHRlBfS0VSTkVMKTsN
CiAgICAgIHwgICBefn5+fn5+fn4NCmRyaXZlcnMvZmlybXdhcmUvZWZpL3J1bnRpbWUtd3JhcHBl
cnMuYzoyMTM6Mzogbm90ZTogZWFjaCB1bmRlY2xhcmVkIGlkZW50aWZpZXIgaXMgcmVwb3J0ZWQg
b25seSBvbmNlIGZvciBlYWNoIGZ1bmN0aW9uIGl0IGFwcGVhcnMgaW4NCm1ha2VbNl06ICoqKiBb
c2NyaXB0cy9NYWtlZmlsZS5idWlsZDoyODc6IGRyaXZlcnMvZmlybXdhcmUvZWZpL3J1bnRpbWUt
d3JhcHBlcnMub10gRXJyb3IgMQ0KbWFrZVs1XTogKioqIFtzY3JpcHRzL01ha2VmaWxlLmJ1aWxk
OjU0OTogZHJpdmVycy9maXJtd2FyZS9lZmldIEVycm9yIDINCm1ha2VbNF06ICoqKiBbc2NyaXB0
cy9NYWtlZmlsZS5idWlsZDo1NDk6IGRyaXZlcnMvZmlybXdhcmVdIEVycm9yIDINCm1ha2VbNF06
ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpvYnMuLi4uDQoNCg==
