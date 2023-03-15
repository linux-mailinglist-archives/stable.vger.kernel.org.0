Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490E96BB22E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjCOMeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjCOMdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:33:37 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2088.outbound.protection.outlook.com [40.107.12.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904099F208
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QP8gTukg4QXUJh5UY1XUxJeQHmx5+N8BQaL/tXmazpY7vGTPbCQiVwE/E3hv/M8WrpzzZ5huJwltDD86rP2gSc7OE+6FwXJXL+k/+jSJEJ//ZdDZ8kKiM4+5DZJWeyld72BY14RciA+zyagrDEJfc2Vrg/PPERG43ePnaVIPnAkiV0QQaN5/NX0NrbXDJw/qbmAPdGhKULFg4cx1TxoNfRfVgH2NRLqPbk0c71rdO92WCmRk8OqTnOgyPiflOFs83qbhX2YvjJjs3PFZpnq95c1DtKVk1ZFARN6Hq7ahhGGmMtMMB347nHPM9upib4OshapJnbSt1AckNvf2K0xw1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzIhUvGvO7njfS8w/Z2g6nkVd7pNLY37x4WVSPz5oNs=;
 b=fDH/RG+3sRkBKRORwgG8v395dPTOq5lioRWl1H4CxiW2jGuyE2G3rwdd7tFDUoSfw2KdaRGBnUx/nUNKfmZp+KaG5vmCqBGAwSPhvut7JtcyT9P29uAO+uuYnEOS9z46wwrO4irgweh4jXBRJvcQc7gZm59bvE0CZdtRDQ8l7p0tqBbKRz+JEVT67rgZ/8gfMgCeUPcsQiy6hrLlmaamlu+P3re6DmgMeQtzqzjfgHUuQmL1b7LMLlwFxL7fUkEvbwHHN/9HzX8knXZ1x+MIPZrPcsW0HCGARCzqhjBUhUksOdi03xqNvJiRWfxjCTRjgPlNTFtFHJkIUd3bUoLNaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzIhUvGvO7njfS8w/Z2g6nkVd7pNLY37x4WVSPz5oNs=;
 b=bzPy7j5RcnTuSWLn5+ZJSNriM/dqEVU0B15YlKJAO11xRwIY95jJemn4fcgJ4gGlNUviuAl5ADe8V6HHwUCP500Sqa29osCvsZ8jOoolUYDH0VyuZNxw5krQBD77/V8g2lDKclu9pUxY4Muc7fBNE3sTOcdTowEjyc+ZpkSpFqLD6n/D1yGBf2NtkWLJyu01juxY/w7742/rsI7cbFFBW1GSuMkIMqVM6omSXnlvrGNco1XzfyqtGOawYPeeABw1RZ1qN5jdWrvSE5HiywZ4+sx9oK0F2Rb6WVpwMuP1O+r2z3qPBFVuFy7Hup/js5wNN6MpxmFGT9a98oDqsbY7Kw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2915.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:38::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 12:32:27 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3943:154a:eccc:fe3a]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3943:154a:eccc:fe3a%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:32:27 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 107/145] powerpc: Check !irq instead of irq == NO_IRQ
 and remove NO_IRQ
Thread-Topic: [PATCH 5.15 107/145] powerpc: Check !irq instead of irq ==
 NO_IRQ and remove NO_IRQ
Thread-Index: AQHZVznm9YeZ46zjyEG0f2ZOfHgxxa77xfOA
Date:   Wed, 15 Mar 2023 12:32:27 +0000
Message-ID: <9ad39d8b-64e8-466f-b93b-494905cd1bf0@csgroup.eu>
References: <20230315115738.951067403@linuxfoundation.org>
 <20230315115742.506375747@linuxfoundation.org>
In-Reply-To: <20230315115742.506375747@linuxfoundation.org>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MR1P264MB2915:EE_
x-ms-office365-filtering-correlation-id: b1d1062e-346a-4d08-46da-08db2551568c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EBs223NEtrQCT2G1Tnf2h/9f9AGzUfuvsN6S3Mfz11Vvkg2IRV1YD2KKvXIZfe1P8dOrdiEGVsIKXDkXTrfSsUkwqWZKdHhoZQ70Yzk8rlCHmHyHl0WS1IgwoHuwM71gydkpVdVnMCWkGOvgbiYFr16OYJuBiyhcI6DObhEIjpyrho0qK6CHLUO+0hCRlNJjNzciUqi4mbQoyJRCUXFdVYm37+JMkW5790WR74Y4bUsntvBXN7/tapdkO3K3sjVRfHsCt1QSXHp4qLYf/y7KXc+lVeXAtwt1FllXcZ+Uz1Fmkuu4JXJwucW9u4xKByBSAABhRnuoW6YfEFgOAUzSZq9nk8CRtiEZoqGfm8hYJFNFcHATQj60wmDrwarQR3t4gmMkCg0pHcTF3JX41CuzGTAw5uXiFzw/cgrw4uSqJKYpSLJo45JgQJUB/wx6KNFHcIHekRIEW9T0OYoLSHRi6RzcyFEZRopcvZf7aC+E+cmVXmlrNa3cJaKXatfOLgeAbHFwcn2TcBMmP9FitViDdLQHWA5bHqtYyG3EwKT5jHerj/T9qNu1XPpaVEh/m2ROgyF99DG8DqJTqaQu0HcIH3+sNDUcdzemXJ9XFsuHBdh3gZtQkb3UE6A5oeykYe0f/MKQy/tGBhh241WTAiqhp7bzcogxB2LVcs17oVSa7gLDNmoEszMhCkgB+6Dd2LPXFVpnKVLE12nI3XgSiVX1qA5eOdifJx+jVfXLCRQm+jLx/p9GB0nSdy3da7Ib97XCjUvL+6O4WSWSxgSm7SSfz+SDcdkm1oe21YUQ7/TOYNc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39850400004)(376002)(346002)(366004)(136003)(451199018)(76116006)(66446008)(66556008)(66946007)(8676002)(64756008)(91956017)(66476007)(54906003)(110136005)(2616005)(316002)(122000001)(38100700002)(38070700005)(2906002)(86362001)(31696002)(8936002)(4326008)(66574015)(5660300002)(44832011)(36756003)(83380400001)(41300700001)(71200400001)(6486002)(966005)(31686004)(26005)(186003)(6506007)(6512007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGVnekVEYlZSQmg1Um5QTFRKelV4THJiejBHT1hoV3lQaEdtNTNsckxkVDBC?=
 =?utf-8?B?SnVXQk5CNDdONCtYQXdXdHBXd2haSnBoMWZ2MlZwZWxwTjJMUGV3VC8yMTFl?=
 =?utf-8?B?WU5sYXhRaDd5NXdRUFZ6Nk9mLzYvdWFQTlJCcENvK05ubmpsL3lKaWg4N2RK?=
 =?utf-8?B?K2swYnhHV2lVV0h5RVBCQmJyWmh6ZjNGVFV5anNoVWlIYTFBRnlxY1A2R1Iy?=
 =?utf-8?B?YTFlWjljMDFxRnFya3NNV052bHlkQytRdUladUYwMWRXKy9vZ0hBN29LT2RD?=
 =?utf-8?B?MHU4MnJjbFlUMGNyTGR4SHdsSW9xem90ZlR3NjdhbEIySlFiS3U1NDBseW1t?=
 =?utf-8?B?NXJ3UTd2L3ROcndXS0dHY0lrZkJyNGJEdUdLUmsreTFZemJtZ3VhMDBubTNX?=
 =?utf-8?B?RlhqNVNxQ3FDZDRqY1pOcitsWmZRUnlvWkZCcjdXSDJmM0N6UkMzQW8xRS9C?=
 =?utf-8?B?YkZjQXpNajVqM2g0R1ZuZ3hTbE51N2dkTVdRZ0pPa29vbEIyeGpTQUduVXdr?=
 =?utf-8?B?cmhhaS9hUFdpK043NExYR09OaS9VaEMzcHRJaTVWUGhtT3lJakRLbm1xbmNv?=
 =?utf-8?B?WmZlR0dxeGJpdW9VZUNnUU1GV1RvSHAvd0JWR01lYzd4RUthZ0YwVFoyaXls?=
 =?utf-8?B?SHRiYVpCaW1PbTBWMUV5K00wWTEva0FYdys4LzNFV05hUWpOQ1kxSWxyUkpq?=
 =?utf-8?B?MmZYeld0YkZtSGk1UXl5Um4va0NYZDA2QlV4dWFWdWd2Ui9STUhTMkhOM3Bs?=
 =?utf-8?B?VTVZVGlPQVNDeFdmUTJuSWRSUlNWdi9xZWwvTlVsSkRML1B5dVBMczVHVllN?=
 =?utf-8?B?a01uMlErTDY5TFlmOUlLeUoyeTljZWlhWVh3aFBYM3RtdVJTc3huVldINjFh?=
 =?utf-8?B?elIzWE1KUDFZSmRjcVhBVlNQczd5eVlZbzNiTVN2WjFTZWc0WC9rZnQ2dEtB?=
 =?utf-8?B?M09sRnUvZEtxOWZObzBhOGJROU1zWXlLSmVDbzBSeWZUY0dVdWxITWRqemQr?=
 =?utf-8?B?dzBTUWdDT2NtbkE0SHFqWVRzbzNQTTZQRzc5OGJ0V0pWOHY4QUs2SjFlemFi?=
 =?utf-8?B?cVZySTBDaGM3RVlMdk9lYTVObXpHT1RjeVNZM2NCZG5mREJLeFVSeEZHSmM4?=
 =?utf-8?B?NklBa0IwYnBtY0JYWDQ2STA5Ui8ycXAvVXRYaHRTZ3VRa21GK3YwZDI5NWlV?=
 =?utf-8?B?UjBPTHI0cmtYdjRiV3o2M2JSS0ZLQjEyZVJrZWJuQ3FiUDZncThkc3Qxakdh?=
 =?utf-8?B?alozQmp5WUQwd3o1Z1dMcWV4RUFLVTNrdERYdTN1Y1JxenE4TkhONVZzWXNX?=
 =?utf-8?B?WmhhM2FFV21jcmdwVytEbjFzMzF3NkFMQWZqS1d6WHpnN0hPcnh5cXlZWHNn?=
 =?utf-8?B?MzQrL3Q4aDFYT2k4RkJMSjBEdncrOGU4eWZKMVBjbmROMjhTZlFJUS9oWU0x?=
 =?utf-8?B?V28vQ1gvVEdCLzFiSm1LYXIyV3NFVHIyUEpGOUpZSHlLMlNMUlhyT0hOemZH?=
 =?utf-8?B?UGllMDYxZUovNHg3TW1iSFdBZEliODkvNTF2YzhMQjBEQTl2a0ZYM3pBMzVz?=
 =?utf-8?B?MXFGb2VWYnBiTWZ1SmVpVmU0dmdwbkx6SjEwbEVzUU1JTVNaazB1clBZZHFM?=
 =?utf-8?B?UmwySDlobU51T0RFdHIvMzd5SXVuRWZnYUt3YjZIYkw1Y2NGUC9tUkxyL2tv?=
 =?utf-8?B?b0RzQ21YYktxM2hzN2laYWdQaU82YUJnV0xYdzdqSEFkOGk0ZGhrc21HdFlq?=
 =?utf-8?B?RmR5R09oYUtSMzFTaWZZZ0RzdUpWb3hpWm8yU3EvZ0dRWVlleHNua1Y1bGFl?=
 =?utf-8?B?NG03S1dHejNzYzNOVmIxeFd1Z09SWFlxVHNzRS9JSjk5K1gvb3lCYjlMeTBI?=
 =?utf-8?B?QzhvMTkzQnVyY3B3ZmNueTNqVEdOem1zSWtrWCtjMXNaR2RRZmpSNktabFZT?=
 =?utf-8?B?TU8wdW1TN0QydGQydHdyZmx0MnZDWnU5RklPelZlbDZ3Ym95YUZrUzhBek9w?=
 =?utf-8?B?YUY1ZGdmRHBSVmhQSVpwY2g3THFMb2RtSlJsaCtYemY5NXNzQnVRdEdJODFi?=
 =?utf-8?B?c0pFOUVKejNjZ05VZ3RMSUN3TW11Smpvbzc1TTFDZU9pQ0dxWmFyN3pzQkI3?=
 =?utf-8?B?RjVCVEtUa2VNT3pid2NuNGNHSTlCdXRFelhGUkhRdytRb3NMTzl6L0xnS2VZ?=
 =?utf-8?B?cnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2C2ACFE8EC6824081E345B781A1DF82@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d1062e-346a-4d08-46da-08db2551568c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 12:32:27.7516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PdJqhyPOQyLz18EJDgU2+Qx8JEAqbExxJy/vFBfX8G5S1KX86DQ75QvdlDPm+4TuTMYhtYE/eOTOYWZG4Ax9Ax2f9J/rZNZY7FGZyC4tkpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2915
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDE1LzAzLzIwMjMgw6AgMTM6MTIsIEdyZWcgS3JvYWgtSGFydG1hbiBhIMOpY3JpdMKg
Og0KPiBGcm9tOiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+
DQo+IA0KPiBbIFVwc3RyZWFtIGNvbW1pdCBiYWI1Mzc4MDVhMTBiZGJmNTViMzEzMjRiYTRhOTU5
OWUwNjUxZTVlIF0NCj4gDQo+IE5PX0lSUSBpcyBhIHJlbGljIGZyb20gdGhlIG9sZCBkYXlzLiBJ
dCBpcyBub3QgdXNlZCBhbnltb3JlIGluIGNvcmUNCj4gZnVuY3Rpb25zLiBCeSB0aGUgd2F5LCBm
dW5jdGlvbiBpcnFfb2ZfcGFyc2VfYW5kX21hcCgpIHJldHVybnMgdmFsdWUgMA0KPiBvbiBlcnJv
ci4NCj4gDQo+IEluIHNvbWUgZHJpdmVycywgTk9fSVJRIGlzIGVycm9uZW91c2x5IHVzZWQgdG8g
Y2hlY2sgdGhlIHJldHVybiBvZg0KPiBpcnFfb2ZfcGFyc2VfYW5kX21hcCgpLg0KPiANCj4gSXQg
aXMgbm90IGEgcmVhbCBidWcgdG9kYXkgYmVjYXVzZSB0aGUgb25seSBhcmNoaXRlY3R1cmVzIHVz
aW5nIHRoZQ0KPiBkcml2ZXJzIGJlaW5nIGZpeGVkIGJ5IHRoaXMgcGF0Y2ggZGVmaW5lIE5PX0lS
USBhcyAwLCBidXQgdGhlcmUgYXJlDQo+IGFyY2hpdGVjdHVyZXMgd2hpY2ggZGVmaW5lIE5PX0lS
USBhcyAtMS4gSWYgb25lIGRheSB0aG9zZQ0KPiBhcmNoaXRlY3R1cmVzIHN0YXJ0IHVzaW5nIHRo
ZSBub24gZml4ZWQgZHJpdmVycywgdGhlcmUgd2lsbCBiZSBhDQo+IHByb2JsZW0uDQo+IA0KPiBM
b25nIHRpbWUgYWdvIExpbnVzIGFkdm9jYXRlZCBmb3Igbm90IHVzaW5nIE5PX0lSUSwgc2VlDQo+
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9QaW5lLkxOWC40LjY0LjA1MTEyMTExNTAwNDAu
MTM5NTlAZzUub3NkbC5vcmcNCj4gDQo+IEhlIHJlLWl0ZXJhdGVkIHRoZSBzYW1lIHZpZXcgcmVj
ZW50bHkgaW4NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL0NBSGstPXdnMlBrYjlrYmZi
c3RiQjkxQUpBMlNGNmN5U2JzZ0hHLWlRTXE1NmozVlRjQUBtYWlsLmdtYWlsLmNvbQ0KPiANCj4g
U28gdGVzdCAhaXJxIGluc3RlYWQgb2YgdGVzaW5nIGlycSA9PSBOT19JUlEuDQo+IA0KPiBBbGwg
b3RoZXIgdXNhZ2Ugb2YgTk9fSVJRIGZvciBwb3dlcnBjIHdlcmUgcmVtb3ZlZCBpbiBwcmV2aW91
cyBjeWNsZXMgc28NCj4gdGhlIHRpbWUgaGFzIGNvbWUgdG8gcmVtb3ZlIE5PX0lSUSBjb21wbGV0
ZWx5IGZvciBwb3dlcnBjLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoZSBMZXJveSA8
Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1Pg0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIEVs
bGVybWFuIDxtcGVAZWxsZXJtYW4uaWQuYXU+DQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL3IvNGI4ZDRmOTYxNDBhZjAxZGVjM2EzMzMwOTI0ZGRhOGIyNDUxYzMxNi4xNjc0NDc2Nzk4
LmdpdC5jaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXUNCj4gU2lnbmVkLW9mZi1ieTogU2FzaGEg
TGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KDQpTYW1lLCB5b3UgY2FuJ3QgcmVtb3ZlIE5PX0lS
USBtYWNybyB3aXRob3V0IGZpcnN0IGFsbCBwcmVwYXJhdGlvbiANCnBhdGNoZXMgbWVyZ2VkIGR1
cmluZyB0aGUgNi4yIGN5Y2xlLg0KDQpDaHJpc3RvcGhlDQoNCg0KDQo+IC0tLQ0KPiAgIGFyY2gv
cG93ZXJwYy9pbmNsdWRlL2FzbS9pcnEuaCAgICB8IDMgLS0tDQo+ICAgYXJjaC9wb3dlcnBjL3Bs
YXRmb3Jtcy80NHgvZnNwMi5jIHwgMiArLQ0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2lu
Y2x1ZGUvYXNtL2lycS5oIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2lycS5oDQo+IGluZGV4
IDJiMzI3ODUzNGJjMTQuLjg1ODM5M2Y3ZmQ3ZDcgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcG93ZXJw
Yy9pbmNsdWRlL2FzbS9pcnEuaA0KPiArKysgYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vaXJx
LmgNCj4gQEAgLTE2LDkgKzE2LDYgQEANCj4gICANCj4gICBleHRlcm4gYXRvbWljX3QgcHBjX25f
bG9zdF9pbnRlcnJ1cHRzOw0KPiAgIA0KPiAtLyogVGhpcyBudW1iZXIgaXMgdXNlZCB3aGVuIG5v
IGludGVycnVwdCBoYXMgYmVlbiBhc3NpZ25lZCAqLw0KPiAtI2RlZmluZSBOT19JUlEJCQkoMCkN
Cj4gLQ0KPiAgIC8qIFRvdGFsIG51bWJlciBvZiB2aXJxIGluIHRoZSBwbGF0Zm9ybSAqLw0KPiAg
ICNkZWZpbmUgTlJfSVJRUwkJQ09ORklHX05SX0lSUVMNCj4gICANCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvcG93ZXJwYy9wbGF0Zm9ybXMvNDR4L2ZzcDIuYyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMv
NDR4L2ZzcDIuYw0KPiBpbmRleCA4MjMzOTdjODAyZGVmLi5mOGJiZTA1ZDllZjI5IDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zLzQ0eC9mc3AyLmMNCj4gKysrIGIvYXJjaC9w
b3dlcnBjL3BsYXRmb3Jtcy80NHgvZnNwMi5jDQo+IEBAIC0yMDUsNyArMjA1LDcgQEAgc3RhdGlj
IHZvaWQgbm9kZV9pcnFfcmVxdWVzdChjb25zdCBjaGFyICpjb21wYXQsIGlycV9oYW5kbGVyX3Qg
ZXJyaXJxX2hhbmRsZXIpDQo+ICAgDQo+ICAgCWZvcl9lYWNoX2NvbXBhdGlibGVfbm9kZShucCwg
TlVMTCwgY29tcGF0KSB7DQo+ICAgCQlpcnEgPSBpcnFfb2ZfcGFyc2VfYW5kX21hcChucCwgMCk7
DQo+IC0JCWlmIChpcnEgPT0gTk9fSVJRKSB7DQo+ICsJCWlmICghaXJxKSB7DQo+ICAgCQkJcHJf
ZXJyKCJkZXZpY2UgdHJlZSBub2RlICVwT0ZuIGlzIG1pc3NpbmcgYSBpbnRlcnJ1cHQiLA0KPiAg
IAkJCSAgICAgIG5wKTsNCj4gICAJCQlvZl9ub2RlX3B1dChucCk7DQo=
