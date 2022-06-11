Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E68254732B
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiFKJ1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 05:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFKJ1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 05:27:54 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90048.outbound.protection.outlook.com [40.107.9.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F7A644CD;
        Sat, 11 Jun 2022 02:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADWayK8CB5umNDKCCjfc1U3Qf6Y46cALnkq42+Yt6Uw9c1zZ8FUFuXN0ks8e6gWpGRy3PXlAvnNUfdw9Ga47IwIcRIM3smL8cO3qHdF4jkAaOiVlrx1kuXpxLA04D9X33auzeWT1bTHsNtMXptPGXOelIbcqF1e6RXTtcJA3h65tJwnlbBGj7pktEWJdfKeEwXdl5j9lo7my8Fc4rZ1Dj+jdNdqf1IFrYlB4nRR1U9bY1uQO3FLlNTaoAMFLdVZpf6PCB5fI5ZJTTR0USZqeIXXUURrwC1J5JvcrPmOqc3SpZyUp2G44nlCZNodycycWhhuRgp/2iWAViwAyUL4j5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOq5Rsi+3QfAQkdOxUO503j52LPwq73HOF++Sh+B7bY=;
 b=LOcFGuONBvCUTTlUgxgXOMN63jlvPRHP1qwSFVGMxywZQweyIo2/WSkUg24KruMuIO8wkvobMjxLNNVfKKWWsiYWDqsW6tbiIi00F6/yRaMdnGpH9FAbCGpgyBCfyx1kkLaJWUB7RxPuzl8CjSzavXkQKIyoeMHD4vXUpskNPv1JK6QTNy1j89f9DVBqwIXnA7jK0KoSV7e7RCQYcs6GDeeB55yK/k1nJmvAkh04SmUMcKUSrovZklzodWBp8l/LzQKR0HmVXKPU2NsxW6g1b3i4zvr2+pZa9MiZSC8MYS1Vh+6ylkDXBHLTV2yi1Pn2twnQbsW5aIxOp6dKOHkC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOq5Rsi+3QfAQkdOxUO503j52LPwq73HOF++Sh+B7bY=;
 b=Rq2E9BRLpcAT33xJc6xmF8RS/d7D2u4R98N3103Dz38uM0rJ98e2ZuImjQ99D1w0Exzxo6gGeMyB0ML7yGXH0Ku7X87ptETeMF2EiYvOoVBLZ8fH99Vq0Ali/G2lXH7Zb/5HcxbVOTNQ2enQOtY4GsQbrwduefxduI7V6qYxYkDjHjknWSQrTZAOJ2kJJcR1+3BBduDQLGGqER6RtBIyyVxowDz/vY9os4bgxB9Ftaur4NK9gscl8IXD4bm2m4bUrFVynb0oJchry5k1j2o3VMIPvHJCdMha1yOz0qVY+txvf5kbGNcBYXGi/rXVSy7wro6etv7HUksFh2EduJjWHw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3786.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:149::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:27:43 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 09:27:43 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/rng: wire up during setup_arch
Thread-Topic: [PATCH] powerpc/rng: wire up during setup_arch
Thread-Index: AQHYfWruAqTviXc9VEaH1Xwgmqs2/K1J7QEAgAAAR4CAAAF4gIAAAWwA
Date:   Sat, 11 Jun 2022 09:27:43 +0000
Message-ID: <c0198572-5aa2-7d65-ade2-766d6733431d@csgroup.eu>
References: <20220611081114.449165-1-Jason@zx2c4.com>
 <956d2faa-4dae-fc75-2c03-387c77806f2b@csgroup.eu>
 <f6e5a9c4-f39d-749f-d124-884f11a8edfb@csgroup.eu>
 <YqRe3wHSuM6dcsCU@zx2c4.com>
In-Reply-To: <YqRe3wHSuM6dcsCU@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2217c936-8704-4c07-57ee-08da4b8ca39c
x-ms-traffictypediagnostic: PR0P264MB3786:EE_
x-microsoft-antispam-prvs: <PR0P264MB3786B01CA716D147B3FEC58CEDA99@PR0P264MB3786.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: McmWUV6QFjxZX9bK9kTew4z2/HKNJgpJGmmN3GqAl4GdYfyYxiG2H3RbxJOzwguyD8F3HiGbucFaG8ChcT01SNuPSyHFKhJI3YLPHWa6CtmmaAhYmwMoqyRjJyjxwMwYIhSZ+K+dBKjrlGYBgUuJWPXXN9UiiaMXcelIrSqAWjYOrL4s7BDSGCJWRodyWAkKDsykn+/pGLEomD3CennePa82jkKqvztVQ5y3mcX7mqIrNSJtl15f0leccGiDBmaAd2D8la1OZc5GeAEwCiX82BCRZx0Ytv2lm1VAj7tlUrIYfSvhNiVkK7r3FBVse3gsHDHaBProb5i7MeB6N0JICODOZFM4JfC5VMO1ubPif+aqfuDZ854DGiC2m8w7f20pDPvkkvn00VagLSdJfD8TKpBlQnKxD2Vg1PFDaLzQyOhGy+c7x7iGGuJa480xjyG9A43E8OtUwi5PQPtJaEroAWn4tj7Rd89fr7Oz4YAZRBbIXD5lN05PALNPZ9CfEJlCRgOjvZmh1Hj6b+yicthMG1TlskkhAGh+SmmTzX2aflRmMy9Tec/PlJ6RojDR6KRL7AiO6PU/+j+UlifytY0lZeY0pG/Boz6c4KCrYC+I6ceNTVUmgiCK7bCtOb44dKEPiIeWZ7bCP8BAaELHUGaKgAIMc2QqjAcsyerwbl5mnwBSSBLbynQPVdNsaF4Rn+4s3aq30pwMlr0CK2Con6JZmdeXX+IyvVzcVpTBvIeJZjkVb80mFBLyHNzwTAdpDp5yc8O6IT8nnDZfsKD49haBmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(71200400001)(4744005)(5660300002)(44832011)(86362001)(6506007)(31696002)(508600001)(186003)(4326008)(2906002)(122000001)(8936002)(6486002)(26005)(6512007)(38100700002)(8676002)(31686004)(316002)(2616005)(36756003)(6916009)(38070700005)(54906003)(91956017)(66476007)(66446008)(66556008)(76116006)(66946007)(64756008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDR3S3c1TGNIeVJlY01iR0V6RVl4NHA4dGJHa3N4d0ZwVnRMYWl2N1FFMlhK?=
 =?utf-8?B?eXFOOHUxM1hFNW1mZm5zT0VJTWJiRDZtMUswaEFmUllWbnRvbEtJekEzZHVN?=
 =?utf-8?B?Zyttb2ZFNEo2RENSNkdqaG51UDREYUYvVVpuSER6NFlHall4d2ZFd3ovYXBu?=
 =?utf-8?B?Y2F6TTJyai84emt4eXJpMU5iRXNvaTh1YlpyODB1c2Vpd25PbGYxVEFNYWsy?=
 =?utf-8?B?b2FnR0t2U0RMckE5YnZhTTU2RWM2cW1qZDdTNXJrY2plZHM0eW5tVlI5REtB?=
 =?utf-8?B?MHFLSzNNamYwaU5QVmlmZHVLMzJyVytDcndDdUdNc1cvckRyN21OL1FTZWNj?=
 =?utf-8?B?U3RZZk5MZG5BQzR2VkUwcmdYOVlFUXdhVjlxTkZCcWUyRUFYNGNkNDVEemZE?=
 =?utf-8?B?S1N2N1VOVWFQQVFsam14eFFUSml5SU1zcEEyR2p0S2NPWkpGUGhjZnZHR09L?=
 =?utf-8?B?ZDFoOW9UdUNHVGVycmU1S0FkQ2ZObTlpUHlzTnUrRGpkQXNicWdaYzg4UzFz?=
 =?utf-8?B?T25ZNVZocjhuRVl4dnlmcGpwZWVydWMvWEpneXJaUi9hR0RNMEZxNFpEK0pR?=
 =?utf-8?B?NHd1QXhGVVBjZDJpRUcrYmZ6R0tMYUFFTDliemErNGdpNEMyaXVPdmdhZi9S?=
 =?utf-8?B?Njl2Yk9pMmR2OWtzV1gxQzFYMnl2NlFxZ0g4ejhGTTRKcUlKZFpxNitNSGhi?=
 =?utf-8?B?SVZRbEh6V2tMMUtyQmt3VWh0Vkg4cHJlUllTVXVLS1IyZzR6VnBoOUJzTCs2?=
 =?utf-8?B?VmJ3WUtmQVJEVFpoQzZlV3ppUmpBcDhJRG5jN1pyVjc2eDU5bk4yZTVpalBY?=
 =?utf-8?B?RGloRE00eTFxUUFyZzByck95MW5RV0dBRG8rYzB2ZVh4MGY1QUlsU0Q2MXNM?=
 =?utf-8?B?UDY2b3BXNVNzL3BoWGltblAyVk9PTDFXalE4MUEzbEhFa2ZPcGRCN1VXY2RE?=
 =?utf-8?B?bXErZzByVXVYaGFrNDMyMWp1dW1HSFBJa1hIazZLOTBFZUNmKzdTQ0c3VExk?=
 =?utf-8?B?NFhRTHdaMGJwUWRPVlFLejNYSEY2L24xeFBUOVZKZXZsVFRIeVdBenVldEll?=
 =?utf-8?B?c2ZjRlgzK1RSYSt3bGUyK2lVQk5OVk5yTm9kWUZjU0NBcWpidnVpWmNmdm9D?=
 =?utf-8?B?d3VEd1A4MmVybVFSQVUrRy9DdHFNMXRXUjRpb0VjZ1JvRnc0N1RScU41ZWdH?=
 =?utf-8?B?QnlvaTFzMnZKT3FMeXJ1RTJMVU1WYmNqUVFKZURNaGErVXRyaG9PUXg1UWNk?=
 =?utf-8?B?K3poTzNRNmY2V1ViTS9rZm9lRG5mTUZEczJiTjRXTFBiUHVCaHRKNFBPSit5?=
 =?utf-8?B?NGVNamQxYnA0OTQxd2s3UmxkNndRNllUTlhEQmFwSk84bFVhZVJrNjh4SWY0?=
 =?utf-8?B?Nm9CZkhEZEhMaFY5RGhPWVNTdVVWRjlFWGxyeWYwenhkb3d4d0VnUmdmRWJF?=
 =?utf-8?B?QkR5cmlFYW5zcTFuVlZ1QStEQlhlOXUvbHduU3Faa1pPRDNaQTJpbHFKZ1p4?=
 =?utf-8?B?VTlSNHExTFFPVmY3S21rVXVrVkhJclRpQVhmbVp0WE84ajI2VGZLdWhHWmdD?=
 =?utf-8?B?Wk0zRUhGRGtLTVYweUluWlZxU1lBSmJYQWR3UTlTRjdwNWdCbWFpWFRmZVA2?=
 =?utf-8?B?Z0RXa2hSQmFBaVVRRFU0dDdHOThtV1RDNGthQzg2c0J6ZUp2UFpOeHJTOFcz?=
 =?utf-8?B?RlJHOWl4ODduaml5N1hBUm9Ld3BqWFozVy95TEtRalA3VmtWSmduc2xHNkQw?=
 =?utf-8?B?Q2pEN1lMbTRwUi9najRjUXFXOVUxaXJSVTNVRlNmWHVjck9lYURCZ3N5U2tq?=
 =?utf-8?B?akVTU2I1UWo2VGJjOElJQlNNR09Ga3BuOXJqbnVJb1hoYkpGVm50ODRiVzNn?=
 =?utf-8?B?bTJLU0NqZ2NNbzRJMXVvdnBqZ2lueDVKTHJPTnhaN2tZL2NOb0lYWlpjSU5l?=
 =?utf-8?B?eTFxZ3VlNHdMNTFqeTJKZFdLVFppRG9PK0JzdFVRR1lTT2pVaCtwMFlTM21Y?=
 =?utf-8?B?RUhCSVhjTGEwTWZiSnJzQlB0YW9ZRHhNSWZmMVMxWEhxdjl2dDNvSTh3UzFI?=
 =?utf-8?B?RUtvL2c4N0hIaktqcGZnL0M3OWFsclNUMzdNRStKRTgvUWRJbVJYRURJTS9O?=
 =?utf-8?B?TGVmOHd0c2hjZ2dSWmVsU3JKcmFVOEFLdU9iajdXYlYwVHhRQTVFWG9QOHNT?=
 =?utf-8?B?VGszdnkydEhUSnlYQ0JqRmFhTmtnM3JJTFZrVlllMEVmTGhhZ3pIZlZueUVI?=
 =?utf-8?B?cDkrOUFSZFZuUFlGSkR6dG9XZGN2dE5Hc3Y2OHpFZmlWUldEajJPc2grOERP?=
 =?utf-8?B?akE4NmpPd0RubzZBcE42eFpab3RXSHZYY3ZHQjlES2JZU0hENkFCZWFsb2xL?=
 =?utf-8?Q?Nar7IfZy+hkZBs0MeNLlCF8gjl6MrW4xkcSGo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA94374534CD0C43B8DBB73F6888B39A@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2217c936-8704-4c07-57ee-08da4b8ca39c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 09:27:43.8471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RyIBoyDduueRoVqc9iWNd4D92i0USbPPG3m35mkXNHNUNyZo6Lme9Okf752DnoI/rf40gAfyb6gt0Qbclv9E2bVLcixHECY4z8OwYIJ2AFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3786
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTE6MjIsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBIaSBDaHJpc3RvcGhlLA0KPiANCj4gT24gU2F0LCBKdW4gMTEsIDIwMjIgYXQgMTE6MTc6
MjNBTSArMDIwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+IEFsc28sIHlvdSBjb3BpZWQg
c3RhYmxlLiBTaG91bGQgeW91IGFkZCBhIEZpeGVzOiB0YWcgc28gdGhhdCB3ZSBrbm93DQo+PiB3
aGF0IGl0IGZpeGVzID8NCj4gDQo+IEkgc3VwcG9zZSB0aGUgZml4ZXMgdGFnIHdvdWxkIGJlIHdo
YXRldmVyIGludHJvZHVjZWQgdGhvc2UgZmlsZXMgaW4gdGhlDQo+IGZpcnN0IHBsYWNlLCBzbyBu
b3QgYWxsIHRvZ2V0aGVyIHVzZWZ1bC4gQnV0IGlmIHlvdSB3YW50IHNvbWV0aGluZywgZmVlbA0K
PiBmcmVlIHRvIGFwcGVuZCB0aGVzZSB3aGVuIGFwcGx5aW5nIHRoZSBjb21taXQ6DQo+IA0KPiBG
aXhlczogYTRkYTBkNTBiMmEwICgicG93ZXJwYzogSW1wbGVtZW50IGFyY2hfZ2V0X3JhbmRvbV9s
b25nL2ludCgpIGZvciBwb3dlcm52IikNCj4gRml4ZXM6IGE0ODkwNDNmNDYyNiAoInBvd2VycGMv
cHNlcmllczogSW1wbGVtZW50IGFyY2hfZ2V0X3JhbmRvbV9sb25nKCkgYmFzZWQgb24gSF9SQU5E
T00iKQ0KPiBGaXhlczogYzI1NzY5ZmRkYWVjICgicG93ZXJwYy9taWNyb3dhdHQ6IEFkZCBzdXBw
b3J0IGZvciBoYXJkd2FyZSByYW5kb20gbnVtYmVyIGdlbmVyYXRvciIpDQo+IA0KDQpXZWxsIGl0
IGhlbHBzIGtub3dpbmcgb24gd2hpY2ggc3RhYmxlIHZlcnNpb24gaXQgYXBwbGllcy4NCg0KTWF5
YmUgaXQgd291bGQgYmUgY2xlYW5lciB0byBzZW5kIHRocmVlIHBhdGNoZXMgPyBBZnRlciBhbGwg
dGhleSBsb29rIA0KbGlrZSAzIGluZGVwZW5kYW50IGNoYW5nZXMgd2l0aCBub3RoaW5nIGluIGNv
bW1vbiBhdCBhbGwuDQoNCkNocmlzdG9waGU=
