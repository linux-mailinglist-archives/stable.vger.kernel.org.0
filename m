Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0973614C3F
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 15:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiKAOGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 10:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiKAOGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 10:06:36 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2084.outbound.protection.outlook.com [40.92.103.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FE91A803;
        Tue,  1 Nov 2022 07:06:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwxNx/lxzjThiV9cr1IhWvdsFpNf6yT0aGbp6rukTAsF4ZqMLveWxRxsL71KtjU3WpPBxek7GYnzHPG/3Aq0G9xHvvYsZx79fg2pkhRMaMFb6OSCWJVJsZupkgQA+9buHPRVh3jTy2in35dBSnFcM12WjzYIFT+RXNVlaVuE5F2eqlhQb3L7SfDgcKqnmnKbGXhejhBKYPoGZOW1bv7CT6sLlz7YVjuBux2rKYq1agfIx4n2J7H+wv535xseNms5dzY8bYDkpFQThxt3JRKBGdB1WZLJ4yaz6YrCU9WUO+DhjFB80iZCdwPwzXXMos3W8+f70q+9fBDlPwRcfhx0RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQ9L+LtixxFQtsHQB6Vn9SqXNr15ekUJtkOSvHOdKRw=;
 b=RJSbTc1dKShU4ukhCDLSqe6PqWwEg9IYIpIzkwPZYUfpFG2kJDzFciacKwxDTAvctX9NK3og4XrDz2uGek5wGpjY3ewNWTCYmDnfBOtrJkq0w0bX7KX2sWE4XGkF/Z88t6Wi1OpgNRA3VnmHknP4DKmncI/l4xNCc36D4esirzKZWE9mhew3bTSFG+JTMV5Y/39kRQBKVOAvonH0tw5+9BQsKWlMsm46kFzu42az9ghDBd4nnn6z/8CT8URw+NRAqZO1ig5VBfbJ7W7O1xCgYH/I0QdmVdA9qbya31Q0dBuXqbKO3XiEaHtsmD3c0W3wYvBX4dCbEub2yzWg8RZ6pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQ9L+LtixxFQtsHQB6Vn9SqXNr15ekUJtkOSvHOdKRw=;
 b=PUD+CYdYAasTlvE2HwiZYsqiNHLOaBEeXz1AJhOrpZ0WOtQMdTEw5pyVpSHbeOLCUKV7SQkC9C0fMDbnv0nIdgMuDEp1uhnk/giZOnkPemhzaQ303eqZiFMiMSEiVeR1udjDfc4Eq8x1/6xOikw1Jn8eU/RYDnogiJBZdIopzJaS5EhqEB52TplSvzPYlffKvDS+EoxmlsytrL/Tng4u1Sqn/R7gvLUtC9IqXJ6Nc/iCz1WGWbK5X/d0h/stxeu8MJSwCRE+0qHw+paFeChYiTiDjpCzdpSytx6bouYiC/Vy25uCvuzpKcEWxRkFqZSxURhhbrqV1Lps6YEXZ+LusA==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 PN0PR01MB6352.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:72::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Tue, 1 Nov 2022 14:06:30 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3dc1:f6bc:49e4:b294]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3dc1:f6bc:49e4:b294%9]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 14:06:29 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "chyishian.jiang@gmail.com" <chyishian.jiang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCH] efi: Add iMac Pro 2017 to uefi skip cert quirk
Thread-Topic: [PATCH] efi: Add iMac Pro 2017 to uefi skip cert quirk
Thread-Index: AQHY6esdl6KnIgWJpkiPJy9/QYH1qa4p/leAgAAkCoA=
Date:   Tue, 1 Nov 2022 14:06:29 +0000
Message-ID: <9D46D92F-1381-4F10-989C-1A12CD2FFDD8@live.com>
References: <8CB9E43B-AB65-4735-BB8D-A8A7A10F9E30@live.com>
 <cee0b0176edc942ecc0ce6f4d585c239f9b7c425.camel@linux.ibm.com>
In-Reply-To: <cee0b0176edc942ecc0ce6f4d585c239f9b7c425.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [RF7TXoAYhMByxGM2eb2puNimRey2Lu+h]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|PN0PR01MB6352:EE_
x-ms-office365-filtering-correlation-id: 091f3098-2859-408c-0dcf-08dabc12462f
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G4Aao7jpe1hyExV4KcHIj29veQ/4R0zZFSZrRWIoImkXUHtDSGxZZ5ky4Bss1fP6Ohp8D7ZUQsBF+ykR6NSg/8J4rh5DAiBvQwgKEtg4JDzwDGcV481SSTPe4DCdgNKTcGbYXYixcBXjE8QjbKUgnyVF8+Vt4cvrDrqP1I1ulx/IJhnS8/+sqEQ01VoDyhCozVNPKhjQtNoKd5T3polynUFFXOJdL9E5RWd0XEiOzAar+Dn940ty5s48fj2luF06USdv7Dx1I3HC1OqYDsiH9t0r6gdYHr5PGeck+kQhSvGvSYfXTMx/2RbmJ9VSEjonHV/S6CCSMFQY3JWAau8XyLXe6Pphj4+a80qtnVhd2RL41Sv7bhcQHzGJj1Ry70yifMb4VhBWwvMgZQNJbnHtOBjffeIX3OS7v8h7KEBf/mVtWMiPcxG+YEUjUSLltiosW5rF6paSt2E5OGiV0ZJEt8sp7NQZqoLPrRxS4bQh5KT3ZQzLDjExv47sDS6gfxgNyleyrPjo/ymAne5FIFwsQqlVNeEIdkbwX51ke7FCIHRleJHcoqE/HjqiooRrAeAeI/hdQXuxzAHQwH0X5c5Eyuuy9oIPvS+qgFe3FYaU6bbV5X3sVD+SZ2hVXD0n89hoGAIqdz5EJ8fZy3EVTvACYgnoHyOAst0JCnEQQubw+AcSHoSxeCPOVwqlbLppGquuY9YvvGgmnzmDPMQaDYf9QQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkpqVVFubEtVejhpcDBRSjFOTTljSEJqZFN5dFYxVFM0aVVuem9DcklWWm9P?=
 =?utf-8?B?MzdMODJ6VUcxeEJIam5ZRXdpcjZtQXZKT0FTcTFVc0VFdUZXTDlNem1oSlhO?=
 =?utf-8?B?Wm9FbExGNVNkNmZnUVRhNFRLanFuWlRtdnV4b1JFdk1yc2tqUzFtT1pmM2Rz?=
 =?utf-8?B?Y2gvSkJmWm90aXhFK0VyaGFvSENzQ1h6MmVHSzEzVFVsM05ZbXlzbWVseGpr?=
 =?utf-8?B?LzBoQTM1ckxaN1pTNDRsT0tzaU5vZlpvNGM5dE0zOUtxZzNFYnFQZ0V5elVN?=
 =?utf-8?B?VU5MQXdtUmF2bCtBYkF3OFE3YWtDVzJDTHJhbGhlclhlcmpDMHF0TzJhRHB0?=
 =?utf-8?B?aGZDQ2FFTnVMbk5SalhOVXBveFZZcHo3TEg0OU5sZW5lUFZLSmVUN3dJRDN6?=
 =?utf-8?B?OUVwcXArU0pMUVNraXR6Y1IyTWFaVmx3SjgrZWVZV2xXS2UxQ0Q0ZXlxRkNM?=
 =?utf-8?B?TFdFQmd3MDlBVWlMc2VGcVZkZEJ5MjkzdjBROXhWL2N5NWNVdEhqWHQ1UTQ0?=
 =?utf-8?B?WklKV0VXNXpzR1lWUWFUYnFSY2Jxd00yb1NsMTR4OUxmZWcybGNFaWFlVnBG?=
 =?utf-8?B?aXpLdm5aOG5nR0lNYW1ZV3djdVdmdzBLTDdTODQyUnlZYnYzVzVmdllDaXlE?=
 =?utf-8?B?YnNFRmhadE13WitUN0MvNXFSc3UzUmQwVUlvMzF4UzVkRjdMV29nTzZ0cXRS?=
 =?utf-8?B?cVlTSXI1ZHF4MkRUaFJ5Mmp4ZUxyQXdOcytVMWVFL25ETHR4cHR2OTdYYXpK?=
 =?utf-8?B?MDBtcjBLdVRmcmM0bUR3RC9iaWZWSzVCR0VSQWVadUZ3blNHd0JVdUpibHJI?=
 =?utf-8?B?bkIwcXoyUnVGSjJZb3BvSmVkSVdaT3RxM1Y4NTY0RnhLL3JvaWkvN3VDK2Y0?=
 =?utf-8?B?TWFrYytXL1NYMStHVkMvL05SWEQ2QjB0L1MxZXp4c0piUXoyWGowSHFYYkVQ?=
 =?utf-8?B?M3dPZ3NENkpmN1JTT3k2K29vMDRiZmhML2d3elg3TGg2VkU0OUw2L1oyekI4?=
 =?utf-8?B?MUJIUnBnT3h0Z1JEbzExUGZxemk2clJJaENIR3hnTkp6M05ZME5EOVRaTzc2?=
 =?utf-8?B?S25ZRXFhRUNKMHl0ZXV6SWN0N3R0SG12dkJyWmU5VUtNc2RzMXpjQVgzYmpk?=
 =?utf-8?B?d2lxdFJwUTZHOXJRdmdBeGErYzVEbTZnaGFzQ0F5NUM4cERyckh4a2NQT1gr?=
 =?utf-8?B?QkVreU5UV1lnRzlaemNqUGlYUHNUVEJpV1A0M0tJYUlybWhTb2pRUk9YdEpJ?=
 =?utf-8?B?Qjlob28xSFFWdWt4WUpwZzRqRGFpektLLzdnRnk2T1ZVbjFXOHFVTkxDV1R4?=
 =?utf-8?B?bmxTRndxSzFzeE5YK0F0dmFpTENWMnpxdG9CYTh1NlNDSm1GQ1lXbHQwdHhZ?=
 =?utf-8?B?M2Rtd04rckNWWVd2L2tlOEJCNDFpMk1SVE5sQWNpQzBOQTh3M2FsOThNU1pz?=
 =?utf-8?B?emp0K2ZnZmgzME9YM0t6VHZkbnplb28vYkFwaTlIN3I5RkYzNVlHczBLVFM0?=
 =?utf-8?B?amlKUVlWK2NvWjRQbnVJVEIyN3EvbitENDBjWFhrZW9Lc2VVQzdWT1dGNTcz?=
 =?utf-8?B?amFYVkF6TTRveit5UVp5YkE2dmplSmZsQjRTQzdicDI4SmhYSDBVc2h1eFc5?=
 =?utf-8?B?dWRZL1JoWEpTMTUxamtVOEJNYWlEUVkwNTNYdklRUjE2UEpFdFhvT29Jbmc3?=
 =?utf-8?B?Y0hnYXdjNHNxVHREaUxZNFFFSWliTDdSdjFsVVJYcFplRTNycUo1anJ3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAEAB7C18C8DFC4AAADC2D4B8C245436@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 091f3098-2859-408c-0dcf-08dabc12462f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 14:06:29.8799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN0PR01MB6352
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWltaQ0KDQo+IEkgZm91bmQgdGhpcyBsaXN0IG9mIGNvbXB1dGVycyB3aXRoIHRoZSBBcHBs
ZSBUMiBTZWN1cml0eSBDaGlwIC0gDQo+IGh0dHBzOi8vc3VwcG9ydC5hcHBsZS5jb20vZW4tdXMv
SFQyMDg4NjIsIGJ1dCBub3QgYSBsaXN0IHRoYXQNCj4gY29ycmVsYXRlcyB0aGVtIHRvIHRoZSBz
eXN0ZW0gSUQuICBXaXRoIHRoaXMgdXBkYXRlLCBpcyB0aGlzIHRoZSBlbnRpcmUNCj4gbGlzdD8N
Cg0KQXMgcGVyIHRoZSBsaW5rIHlvdSBzZW50IG1lLCB0aGUgZm9sbG93aW5nIGFyZSB0aGUgc3lz
dGVtIElEcyBvZiB0aGUgVDIgTWFjcyBtZW50aW9uZWQgaW4gdGhlIGxpc3QNCg0KMS4gaU1hYyAo
UmV0aW5hIDVLLCAyNy1pbmNoLCAyMDIwKSAtIGlNYWMyMCwxLCBpTWFjMjAsMg0KMi4gaU1hYyBQ
cm8gLSBpTWFjUHJvMSwxDQozLiBNYWMgUHJvICgyMDE5KSAtIE1hY1BybzcsMQ0KNC4gTWFjIFBy
byAoUmFjaywgMjAxOSkgLSBNYWNQcm83LDENCjUuIE1hYyBtaW5pICgyMDE4KSAtIE1hY21pbmk4
LDENCjYuIE1hY0Jvb2sgQWlyIChSZXRpbmEsIDEzLWluY2gsIDIwMjApIC0gTWFjQm9va0Fpcjks
MQ0KNy4gTWFjQm9vayBBaXIgKFJldGluYSwgMTMtaW5jaCwgMjAxOSkgLSBNYWNCb29rQWlyOCwy
DQo4LiBNYWNCb29rIEFpciAoUmV0aW5hLCAxMy1pbmNoLCAyMDE4KSAtIE1hY0Jvb2tBaXI4LDEN
CjkuIE1hY0Jvb2sgUHJvICgxMy1pbmNoLCAyMDIwLCBUd28gVGh1bmRlcmJvbHQgMyBwb3J0cykg
LSBNYWNCb29rUHJvMTYsMw0KMTAuIE1hY0Jvb2sgUHJvICgxMy1pbmNoLCAyMDIwLCBGb3VyIFRo
dW5kZXJib2x0IDMgcG9ydHMpIC0gTWFjQm9va1BybzE2LDINCjExLiBNYWNCb29rIFBybyAoMTYt
aW5jaCwgMjAxOSkgLSBNYWNCb29rUHJvMTYsMSwgTWFjQm9va1BybzE2LDQNCjEyLiBNYWNCb29r
IFBybyAoMTMtaW5jaCwgMjAxOSwgVHdvIFRodW5kZXJib2x0IDMgcG9ydHMpIC0gTWFjQm9va1By
bzE1LDQNCjEzLiBNYWNCb29rIFBybyAoMTUtaW5jaCwgMjAxOSkgLSBNYWNCb29rUHJvMTUsMSwg
TWFjQm9va1BybzE1LDMNCjE0LiBNYWNCb29rIFBybyAoMTMtaW5jaCwgMjAxOSwgRm91ciBUaHVu
ZGVyYm9sdCAzIHBvcnRzKSAtIE1hY0Jvb2tQcm8xNSwyDQoxNS4gTWFjQm9vayBQcm8gKDE1LWlu
Y2gsIDIwMTgpIC0gTWFjQm9va1BybzE1LDENCjE2LiBNYWNCb29rIFBybyAoMTMtaW5jaCwgMjAx
OCwgRm91ciBUaHVuZGVyYm9sdCAzIHBvcnRzKSAtIE1hY0Jvb2tQcm8xNSwyDQoNClRoZSBzeXN0
ZW0gSURzIG9mIHRoZSBNYWNzIGNhbiBiZSBzZWVuIGZyb20gb2ZmaWNpYWwgQXBwbGXigJlzIGRv
Y3VtZW50YXRpb24gZm9ybSB0aGUgbGlua3MgYmVsb3cgOi0NCg0KaHR0cHM6Ly9zdXBwb3J0LmFw
cGxlLmNvbS9lbi1pbi9IVDIwMTYzNCAtIEZvciBpTWFjDQpodHRwczovL3N1cHBvcnQuYXBwbGUu
Y29tL2VuLWluL0hUMjAyODg4IC0gRm9yIE1hYyBQcm8NCmh0dHBzOi8vc3VwcG9ydC5hcHBsZS5j
b20vZW4taW4vSFQyMDE4OTQgLSBGb3IgTWFjIG1pbmkNCmh0dHBzOi8vc3VwcG9ydC5hcHBsZS5j
b20vZW4taW4vSFQyMDE4NjIgLSBGb3IgTWFjQm9vayBBaXINCmh0dHBzOi8vc3VwcG9ydC5hcHBs
ZS5jb20vZW4taW4vSFQyMDEzMDAgLSBGb3IgTWFjQm9vayBQcm8NCg0KQWZ0ZXIgY3Jvc3MtY2hl
Y2tpbmcgb25seSBpTWFjUHJvMSwxIHNlZW1zIHRvIGJlIG1pc3NpbmcuDQoNClRoYW5rcw0KQWRp
dHlh
