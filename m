Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979126BB21A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjCOMdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjCOMcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:32:35 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2051.outbound.protection.outlook.com [40.107.9.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0478829432
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzc6+ClVg2QJmak+tjfVtcv7kwZirDEt7m13qjTU9wYGqed+TIKX70QwGhHhBXKz8BycbsmdkeQpe8tq7WQj7OcEznzPxwIOPCrJsyNYrM9eyuuF1Fh6ShA9reuluYD3B8SI0XySiMI45adiLfjbqX/yWtpP7YzODWdar+0lY3P/TmJwAi6ajnJmiyxM0lmLajF4u5dxYpD+86ZtvrbftIxnEHRwtPUTafsnlIDdE8uBNv7H749BEyZZcO8Azw1ffBASAfVDw1AZfQLRPYhUGtnLSoMqfSZqIP0Vr/zRYbes1xn8nciD56rT9wSEguccNckWPdFpmPZj8reu1M9Ucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jySsoZaWNapk4IMaAlSeCA9iH/vXHAJRIzQXZydSnbU=;
 b=oHOcMmtdYHOXC6Ro33StKaba0MQcX3qVP3A6Ureodi8e5qMVwn17aRWXHWw2XwfitWorFZ5BdF53mVPtILfL4+DsIVu7qkhhpefyFL7+kTe0kT2iOelyv+seqAQwIi/Wb8xSHqptov2xmFl1LYD6kN9vrzms95rs/pbs89/28jAmPOSvqIy5u4j+ymju1Wqm4r+KkD9LMPF+eLkKo+UEejTVeUlLOsIgUcgjf+PJL0Ef+DUOTiuoKWRpDlhIrtVcDVZaY0YelrDZcwn3ZTk6HwNUy+afu1J3xmV9UcEwyHkwCLdfB8XiHjBE0MA9vhEc0ezbf36UrX/G4irqfnXQrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jySsoZaWNapk4IMaAlSeCA9iH/vXHAJRIzQXZydSnbU=;
 b=SLiacZ3PLwbi3yj7kSaR7qCb7+XvqqYNAlG9oMAlKb9Ml34l2wk9kGhxb+vw5yW41D8fPWZIw3JXH8w0oipqmSA5HatER232sseLr5D/yzc+SFpavlTVPJPKWiz+aOC1byXLGWqDojvl73l8f91u1/HmvSNsYe6NjbIsC3sBHLMtnyD7+Rz/N+/dcNlbs0RnWzQoN7jxIj/Pi02phs6tBeiMvOqwkZ+wO5SY8SaFP3AHqizJXZ2PuNgvsDfwVTdAXRBe2X/8xX/x1stSuWC2NmRpBjZLdjHWxHuNogDdkOVVSW7DCwkqFv6BhKuIVh8NQ5HEjRx3TXPn4uyDbebzEA==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2915.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:38::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 12:31:48 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3943:154a:eccc:fe3a]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3943:154a:eccc:fe3a%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:31:48 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 068/104] powerpc: Check !irq instead of irq == NO_IRQ
 and remove NO_IRQ
Thread-Topic: [PATCH 5.10 068/104] powerpc: Check !irq instead of irq ==
 NO_IRQ and remove NO_IRQ
Thread-Index: AQHZVzjccwoKk1fv40qcR1QujuhRaq77xccA
Date:   Wed, 15 Mar 2023 12:31:48 +0000
Message-ID: <3aae2034-32ab-dbd7-1fec-5d3fe04f32df@csgroup.eu>
References: <20230315115731.942692602@linuxfoundation.org>
 <20230315115734.795215221@linuxfoundation.org>
In-Reply-To: <20230315115734.795215221@linuxfoundation.org>
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
x-ms-office365-filtering-correlation-id: 67795d06-fed7-4f1e-3f41-08db25513ef6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 31K5/HKaJf5heml4A/sKVOths1eeJB2YqPtiTcr/CeJxo4CW1U3alg++qi5uJpbZ0pZtgMH7N70IbWpOxv+LbjQxO1RuqfL6kXGoGCH1YxiP5IE3ljMVYC0UoHRtg2YOAtfd1ukYI8b7q7eyLxZdrKoDJuqv8f8wBWEAdqBEb71bmI8YOpYP++aRH2/l9qzKnUguTOG3ny3POsjD8Rl0ycQ7blozz+nnu8qSXMErkvykzTebs67yQaD4nLmwn3U3K6CCj2/Gf18Xc3O0fU8SH8vcp/KQuAoXmW+NjXnamugX8nWuYz0BdzweJtuH93m2wV7dZy+Pcs1cZL5J+Z1DPaEmRG2WvfhKzVBI1+FnsES/bgrF6tU7DQ+BljJ9CwTX5zdj2p10g7FWktBP6SivpjIcnLK+sqsJ4lAP+dndiXf4+G123rNbR8PRq0RJHh0OotUiS0jK7YvI1ZqWCbBNnmE/rxY76/pDcQjiVjTli/rumo4tLgNxBM0DYnvhJm5VVVyNNjH0txgN87EsYkIMkfHDt04Ofqxuuq/Ig0JITQSPO32wCDNuy74RIpMRTyoeo9h4jtpztdptUxao/jMI33DiMkpj20mnXpiCx6cOI9t/EEoqZNEYds/5ChezPV5UTKbJrXlGnAtGoO625Yn3ivKhgdJNLpwXKVcmHb5N1K+mXKi6sekjeBFIxSFx02sp5u9RoW/k+FhVKmEBFEpRMpLNOWwfJwYvnPD5iUH+r9KcZfa4yO+XYmvGNx6W8LwDnHVxt69+edjnUyvu1WQwdk+Vl6Vlg/nRPF3qaKd6tIs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39850400004)(376002)(346002)(366004)(136003)(451199018)(76116006)(66446008)(66556008)(66946007)(8676002)(64756008)(91956017)(66476007)(54906003)(110136005)(2616005)(316002)(122000001)(38100700002)(38070700005)(2906002)(86362001)(31696002)(8936002)(4326008)(66574015)(5660300002)(44832011)(36756003)(83380400001)(41300700001)(71200400001)(6486002)(966005)(31686004)(26005)(186003)(6506007)(6512007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUZaZnZIZkw3VGwweHpkQkFFWmx5OGo3ZDBteGNrTlJwK0tYYWVJcVJuc2Ja?=
 =?utf-8?B?bXhPWXNQMW51RDN1TWxlSmVWNkNqVFpEVTZIbXhidjlxT2hGVERmdHRxanZT?=
 =?utf-8?B?dllOc3FtRnhTY0ZKdDd1YjJUUzRwTEI5Y2g1MGVEWjdndTJ1N3R5bVl1TDNs?=
 =?utf-8?B?aEhOdjlFTDBUUmVmd0haaHBNbjdmMUFXLzVrRndzSHdZempseUc4MEMxdEwz?=
 =?utf-8?B?SHF3SkM4ejQ4QndxdVY5OGlBVm1qNDlXZTl4b0RCQjJCeDd0ZDJqQzhpVC8r?=
 =?utf-8?B?eGdJTmRXMStsaVgyY2h6VjhoczBaNnJ6ei9DVmowVkVNQzN4dGJKSkQ3Qm52?=
 =?utf-8?B?blNnSDBIUGx5T0dmcmhNdnlrMDlLTXczN2hQa1R2MlBFTTJTMndEMGtMQVBO?=
 =?utf-8?B?TXJqRGZyMEVJdEFoZ1VJdlNFeEFyRi95QTkzbXVlOEJycDNBQXZLQXNFdTJT?=
 =?utf-8?B?RVRFc3d0OEpEclNGbDJqa3FjYzY4Y2xLTWpIcVlXdngzWUp6VEUrNHFoU2w5?=
 =?utf-8?B?VlMvSlNlajJRUkcxZDM4MUx4aEZ2bFpsNXdPc1l4d05zSUtzSDFNYWR2eEdF?=
 =?utf-8?B?Ym90YlM0OVlkcHI0czNIdFJWNk1HS0h1eUplcm5rMUQ1ZVNVanlHdzVYV0lJ?=
 =?utf-8?B?czJwQUdFd09LMTd5RTcxeGtqR0p2TElZZUpzSDRSS0svckkvVkMvS1lnOXoz?=
 =?utf-8?B?bHRSNCtYS2NlLzZLcFhnZUZxd3RtbUVpNGlaS1BPbVFsbWFOOGJUOXRNZFV3?=
 =?utf-8?B?SDR4OE1BWGl6QUNBTGRJaDNjTDYvS2lIQS91Z0lNT1FTOU52QzBZQU5Fb1BI?=
 =?utf-8?B?YWhwbDRVb1l4SnNjU2IrZisvc0svVDdnYUpscEl3MGpvOWtLSEROYnAxd3h3?=
 =?utf-8?B?NTRadGREYkZqMU15MGxkejVBVnZ1TUJ3T1VobUxLQ1lBT3lsMXpKTTF0RW04?=
 =?utf-8?B?VkxTckw3cjBpekJvb1RFb0toS2dWR3VwblBIUkJmRUpLUDRxUlVVMTFiWmxw?=
 =?utf-8?B?QS9TbUVwK085K3NCaG1Kc2lLQjFlUEZiMHNaY2JoaWxlbGwzQzdGWU1vNTZr?=
 =?utf-8?B?NlVwWGg1SzEySmhuTnR4NFpiWHBsVkQ0QjFocDRXVVRnM3RWVExpcDQvU3kr?=
 =?utf-8?B?Ym41dTdQOEpaZnBsYk9nUjZvM040M1RmMnVxTmdtQUVaZ1VGbFhYWWY4SEpv?=
 =?utf-8?B?dFY1cHV3UGc2S2FDcGo2TjN2QXhDVnBBbEpmVEJseHpIY1UxNFErZTViVkFC?=
 =?utf-8?B?V29Kc2V4NFpYejdoZjlCcXp0b3dyYnNXWW1kNjRzS2JlVzFUbnFjcjlsdXN5?=
 =?utf-8?B?R2FKWDlzTUI2R0xobHVlc29EM1N2ZkdmalNLejlqUjhmVVd2ZDZIeU1ldExt?=
 =?utf-8?B?TFM2YTRxYTlGTE5rOWd2Z0NBRGp4TExLeUZ2V0VpcURqWVJ4WVV4dFpJQ1kv?=
 =?utf-8?B?QzFOVUs2Z3dvZlREOHV4M0Q1WTZaMEFuUmxEOXVDbDNKaUZpRVBZQUZXUkhT?=
 =?utf-8?B?bmZVcGttQlZ4dDBTcWxHODU4LzBWMFRkOGZ4YVZYZVoremFJQ29YYXJibTU5?=
 =?utf-8?B?enAxWDlSUWlnQkF0TVE0M3BqaGtzd2szRGhRa1dndTY3b2gwbExhTVlJS0NU?=
 =?utf-8?B?cFNYTGJIdDFJV3RMdjFoVHJqQ05jTm1RRURSeWVPSGttTWltK3p0a2NFSzZD?=
 =?utf-8?B?RmRjRVJ6Zyt5N3FVWEJKVjJMb21qeFIvZjZHVkNFejNrb1U0RDA3T1ZUTVNG?=
 =?utf-8?B?VHdqS1JiZTBPdW9zM1kzRG0wRW5TUTZZeEdZMG9Wd29QbGJhUW5oOVBReUlR?=
 =?utf-8?B?VmVaVGtsKzlqSjlaejhVZEd0cDJnbUViL3hMWGhtRXlQN1htdHpobHhqWDFO?=
 =?utf-8?B?SjFKVkRkOWI3RjZsV3cxWFBMQjZ6RWxnNThoMWZkeXhHS2NGZy9oUkJ0K01o?=
 =?utf-8?B?VEdmTVJibXZJQlhuYXBxbHVzUUVkZTU3b0gvY3ptTWdQeWt0bitFS1d1eDBI?=
 =?utf-8?B?RUh3QlVscmlOMUVaVEUwVXM1K0NzMjZBUFZqejczcDFDVU1UdlJWWkR3UDBO?=
 =?utf-8?B?YkY1eDJsUmZsMWM5YVlseHgwT09WUE5GblhKRGljWVRkanFkT0greFBZd21w?=
 =?utf-8?B?WUZlL0p5SUx3NWt5TnZmWFRaNlpFK3oxMHp1WnJiYmNiT0dYVC85NzQwQ2o5?=
 =?utf-8?B?WlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D298B836DDFB5D428654ED7AF10EC286@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 67795d06-fed7-4f1e-3f41-08db25513ef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 12:31:48.1492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 11QAHhk2aiMpTeWN6uQNomGkx51eaDYe1e5zTTfohDGa1LF3PZMJ3Kg8nVWO35dv/FPa4eBUswh+m4XWJKhsFdAKLTywQLGynnIdxloarv8=
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
TGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KDQpZb3UgY2FuJ3QgcmVtb3ZlIE5PX0lSUSBtYWNy
byB3aXRob3V0IGZpcnN0IGFsbCBwcmVwYXJhdGlvbiBwYXRjaGVzIA0KbWVyZ2VkIGR1cmluZyB0
aGUgNi4yIGN5Y2xlLg0KDQpDaHJpc3RvcGhlDQoNCg0KDQo+IC0tLQ0KPiAgIGFyY2gvcG93ZXJw
Yy9pbmNsdWRlL2FzbS9pcnEuaCAgICB8IDMgLS0tDQo+ICAgYXJjaC9wb3dlcnBjL3BsYXRmb3Jt
cy80NHgvZnNwMi5jIHwgMiArLQ0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUv
YXNtL2lycS5oIGIvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2lycS5oDQo+IGluZGV4IDRmOTgz
Y2E0MDMwYTQuLjRkNWU2OGU2ZDNiNmQgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcG93ZXJwYy9pbmNs
dWRlL2FzbS9pcnEuaA0KPiArKysgYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vaXJxLmgNCj4g
QEAgLTE3LDkgKzE3LDYgQEANCj4gICANCj4gICBleHRlcm4gYXRvbWljX3QgcHBjX25fbG9zdF9p
bnRlcnJ1cHRzOw0KPiAgIA0KPiAtLyogVGhpcyBudW1iZXIgaXMgdXNlZCB3aGVuIG5vIGludGVy
cnVwdCBoYXMgYmVlbiBhc3NpZ25lZCAqLw0KPiAtI2RlZmluZSBOT19JUlEJCQkoMCkNCj4gLQ0K
PiAgIC8qIFRvdGFsIG51bWJlciBvZiB2aXJxIGluIHRoZSBwbGF0Zm9ybSAqLw0KPiAgICNkZWZp
bmUgTlJfSVJRUwkJQ09ORklHX05SX0lSUVMNCj4gICANCj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93
ZXJwYy9wbGF0Zm9ybXMvNDR4L2ZzcDIuYyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvNDR4L2Zz
cDIuYw0KPiBpbmRleCA4MjMzOTdjODAyZGVmLi5mOGJiZTA1ZDllZjI5IDEwMDY0NA0KPiAtLS0g
YS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zLzQ0eC9mc3AyLmMNCj4gKysrIGIvYXJjaC9wb3dlcnBj
L3BsYXRmb3Jtcy80NHgvZnNwMi5jDQo+IEBAIC0yMDUsNyArMjA1LDcgQEAgc3RhdGljIHZvaWQg
bm9kZV9pcnFfcmVxdWVzdChjb25zdCBjaGFyICpjb21wYXQsIGlycV9oYW5kbGVyX3QgZXJyaXJx
X2hhbmRsZXIpDQo+ICAgDQo+ICAgCWZvcl9lYWNoX2NvbXBhdGlibGVfbm9kZShucCwgTlVMTCwg
Y29tcGF0KSB7DQo+ICAgCQlpcnEgPSBpcnFfb2ZfcGFyc2VfYW5kX21hcChucCwgMCk7DQo+IC0J
CWlmIChpcnEgPT0gTk9fSVJRKSB7DQo+ICsJCWlmICghaXJxKSB7DQo+ICAgCQkJcHJfZXJyKCJk
ZXZpY2UgdHJlZSBub2RlICVwT0ZuIGlzIG1pc3NpbmcgYSBpbnRlcnJ1cHQiLA0KPiAgIAkJCSAg
ICAgIG5wKTsNCj4gICAJCQlvZl9ub2RlX3B1dChucCk7DQo=
