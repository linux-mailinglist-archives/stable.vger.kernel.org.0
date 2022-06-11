Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACB65473DF
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 12:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiFKKl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 06:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiFKKl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 06:41:57 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120059.outbound.protection.outlook.com [40.107.12.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3B56D95A;
        Sat, 11 Jun 2022 03:41:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCZzIRxghzJVce5jAfgS7KfOsglWLG4/fFd4u8sFEiSk4UnJvyMaq4VHB1LqYAyBscFHzsWWK9Tq+g5YDaHsCvGxJda+I7Qsp8WrcFcbUe3ir/YVakwqliwaQWVtQsx94grcqfTVnZA0FwRTTNeIL9UzacYSb9NzPLpra2/EAfxwT67siDJ8n35wWV0oos1klG9MOq/506Jc98lgCpAKGvT+LBRYZZNr4k0zikItqNqJGTyJb5J1runpL8Y+1cqohZVavm1xEsuZaHiUMBEXxJWiS8qHVvwvP5rWdw6TqU7i+OYiOep3jJAWmpT1JPzmO94J7KMWEOHZemxHAj+lYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbNCR3FfuJYmrRBoC4bnyTPctwwH5c/HJLU8OjovPbE=;
 b=KCloZ9b2uwVvdT4yjQZEoXAcAA/Y+1UxFmbD+PAzUwFIIPkNf8/dfoPeXh2rlFiVA971LxgY2vcWMDdptRuzog9dJzufxb+ZZ89KimpZHNl3dW6rWIGajCjFa7H08jUs+cJA2mCpO+lmYBIED7o9XYU6hFnHiw7/kI6FvUgPRgqDhL29SnVWiaLxe9lkkunu89QoLSn5z7QOG/gYb1DN2VxfJxAFQwEHYxnnnNH6DeFNalnvj9uL5GI5I+QawHEXDKvGiQBHuRqhDJtVypLbjvyJa4VmzEVxj8sjnzygdHpL34x13cEsKV+VQmOJ1oeMdz84CS1Zkn8zLXn4nTz8xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbNCR3FfuJYmrRBoC4bnyTPctwwH5c/HJLU8OjovPbE=;
 b=BFWxbWJm9xNkuXtJnHzCT4zntjKOWaB5ZkqRZLz5SaJrkUFamKlso0v5GutgrhUfrEO2sSKOISDolvApdsHNE3Rphl2wwDnLG25eQmI5bCJrRQ4KMAnjf16ppp98KXzwpSv0E1w5xZVsM5vHaMPltgGmyB4tO1EDu3K01KizISxP7ylu55nm+G8pWYxXjXQqrT8O5RfBvuSbIjGCXuJQpY85k7P1XT5o7Y/ZNSD15wweS8oDZtyJCSFKyrMAOz6O+B2yLb5rBMBv/HjyLy2lNRU8/wDFhFvlRdYN45i0a7lGz3WOJo/Ipt9RlW7ghpreBg43jAt92NVmtoPJeZvh9w==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3683.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Sat, 11 Jun
 2022 10:41:52 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 10:41:52 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/rng: wire up during setup_arch
Thread-Topic: [PATCH] powerpc/rng: wire up during setup_arch
Thread-Index: AQHYfWruAqTviXc9VEaH1Xwgmqs2/K1J7QEAgAAAR4CAAAF4gIAAAWwAgAAIkICAAAwnAA==
Date:   Sat, 11 Jun 2022 10:41:52 +0000
Message-ID: <230d6927-b11a-fbf2-fb1c-fa9df70acfa0@csgroup.eu>
References: <20220611081114.449165-1-Jason@zx2c4.com>
 <956d2faa-4dae-fc75-2c03-387c77806f2b@csgroup.eu>
 <f6e5a9c4-f39d-749f-d124-884f11a8edfb@csgroup.eu>
 <YqRe3wHSuM6dcsCU@zx2c4.com>
 <c0198572-5aa2-7d65-ade2-766d6733431d@csgroup.eu>
 <YqRnPzVxK9HKROYi@zx2c4.com>
In-Reply-To: <YqRnPzVxK9HKROYi@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d15734e1-725c-46a5-b649-08da4b96ff44
x-ms-traffictypediagnostic: MR1P264MB3683:EE_
x-microsoft-antispam-prvs: <MR1P264MB3683AA67E028015CCA5CC527EDA99@MR1P264MB3683.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bAcJU1HgS0OTpwyILQhHzuKh3OIjYiABEVF9a9SXjXugiaX3VW1BAv7XY0UNczcTYn+T04qx4sJFPsyyk1r8rKGtGn93V9dJ4p0m8rqbkOA56iGdN2YOPiLi1dUObMpxLBGR0U0WA4I8qUaFToipx2WifI6444TEE2Vr97+M15GiVq4U9xhZSMgxEDYAqqCjy3/UmMhDmhSOoPjFjeVOSmGaUDEYeWWn/hryHf5nQUGt/T4kY+mWD4IHJeplZsIKs87uC1I5sZtHjzZuIJGYAZI4SaYVCR+ssh1o1ku5NY+0o7yyG44ohQZRtwCse4vIubWxihOOP57wmSlSlcu+vv9Vr11CLtKrRMQIsS5BgCrnK8Iym9tIh518yQ+6QgJl6/T77gMvsAnuXj3LSGZSIbPLbt17N9n3VsapXNDUDW0C1yF88//b9u6f1NwKJ40UhOfvAX6Tj/mpIIRtrt7GBUlX0ULsj4o1pJy0LpVBJ4kMfsfb+0Tsmxnz46fzFnp3NJguqB2hOQVRX/Ov4FkcQfg9W75+QEyLjjZCjPTab05lLslgNwS3aH8Htjnw/DKksMsVGwS7OC8+PtufRy89GU6PWt8MVyngdMaSSPTe4glpTAWREHC41yoYirlBCB13t5zdDvIjJj6KMndRg5mXJAZyEItcoEXmKlUHhNXZ3TY1ZsJ0OWFJNKE3t0/YdBVqJRfPTNPtdWT+V9AVUz2o60CY7u+QGQml2I1mt2luJflUK5HJ1ePzbdNPMw3aCKRl+u5BWIEa8hVvjNFubtxgpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(38100700002)(71200400001)(36756003)(5660300002)(6486002)(31686004)(2906002)(122000001)(508600001)(44832011)(86362001)(8936002)(38070700005)(6512007)(316002)(83380400001)(31696002)(26005)(64756008)(66476007)(66946007)(66556008)(66446008)(76116006)(2616005)(8676002)(4326008)(91956017)(6506007)(6916009)(54906003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUpZcFBROFJlVUREV0J0Tm5tY2xyak50NEFucU8wZG4yaGpkUVNFWTdYYlZv?=
 =?utf-8?B?YldISHJ6ZEU2aTNjcXZ1SlRoS0J5cmxPaTVjNWJoODN4QTR6ZWVRa1dQcEEx?=
 =?utf-8?B?V2lBU3l3MlpvSmtMR1JFTzZtYnhBNElVeUdveVlqRVdLcDRRaDc2cDRPbzFU?=
 =?utf-8?B?RExYVStoMzJ6N0VEUGw4ZG1hOWtzZ29NNEJNL2pUaEJldzRLdHJsT3VBVXJv?=
 =?utf-8?B?eExTMFNJN3U4UXNTZUFOZGdNVHdVR3VJb0taZkVaYUR2VGlNYkJmOHQydmpG?=
 =?utf-8?B?TjkzTHNXbXNPMVliTjhvM3MxRzFsbE5tZVFVenY1V2RPOUtzM0Y2SktNK1Jo?=
 =?utf-8?B?Z3VtR3cwRnBQZDViTVZXZ0NKWHhaaTZjZEJsaVhXQ3ZaZks4dkx4YnhLdG9s?=
 =?utf-8?B?dkVSTEFGeDhUaDRFZDgwa1YvdEx2K1VwTUtzRGtwZTZCbVJuOEFKQ1lRWVVz?=
 =?utf-8?B?SzNHMDRDb1JYRC9hNVVpNXdBWXUwcmRMdGp4K1NzelB5bkZhdDJZVmlIVFVl?=
 =?utf-8?B?ck5vYVZ0Z0RjM0VkTWp0a1l4ZjlaeDVaMG40MHBqdWNUVGQ0ZXNJdXRqYTNV?=
 =?utf-8?B?MjUwSTRsb01XVHZIcUY5YVZkU0hwL0oyVTB6Z3FCWlFMUVBMQTJhbGlpLy92?=
 =?utf-8?B?WlBiMlRJbldHaFZ6QjNpblZ6K1FGZS9xYzYwalF5alczRVluN2xCanJEVTc0?=
 =?utf-8?B?ZWRFV0FmWEZaWW1SNVJXek9wdjUySzJUWUkrbG5wUzFjeXRKK2NyMGJIaFJQ?=
 =?utf-8?B?UUJRV200dm5OY2dJSGtMVXpzcEFpWU5GMGxaWDlTMkVuNXNzNWZjZis5aHhv?=
 =?utf-8?B?UG1nTDNET3NkZ2MxdFJTTmhFb28rSVFRRUJ5MnBFVUNBeWZOYjV6Ry9rK1BU?=
 =?utf-8?B?aEV2L3VhOVhDL1dKYlBmRnhQazFFM1BBYWZlNEZLekdWREdaYTBxQXJEMlBl?=
 =?utf-8?B?cWozaS8zWTNlYmFUemp3dlVtbThVeWtwV0NLNkI5RjdhUDJBdkJzK2lMN3A1?=
 =?utf-8?B?ZGN3OVNtZXJTUEM1alViTFdBQjRBSmJXZTkycUw4MXVyc29mQUI2WXBQVkNB?=
 =?utf-8?B?ZVlGZlBESmdoVXdUNTd5cHpNZytoTW5RYW9Gb0x1M25wSWloZVpBMlU3c1Fn?=
 =?utf-8?B?NytrcmUxVEZaMzNlenNSYy9KVm9GdllRSDZxVUlUamVXNlh3ZnlWQXJOdkoy?=
 =?utf-8?B?MUFHN2ZtTDZFMFowbU1UZUdoem1LTHIveDZCNDFaRlJsVlV1Y1VJdmhvbmJG?=
 =?utf-8?B?Ukl6VTNOWWdzL1puOFY1ZUt3Q1kvejF5VmdwTUtmUThvZi9SWE5ndnVMMjJP?=
 =?utf-8?B?ellibElPZHRGSm80ZC9ib05CdTcyUzJYSUJnR253bTl4OHFFZlNpNmpZQ0FS?=
 =?utf-8?B?M1NSczBBWHc4ZnVQOXRHZjdyaTZZYk8zek4zbWRGT1Iwb1pQaW9rRFU1V2o1?=
 =?utf-8?B?WEZwU2pjSDlTMjMwVnl0bldwYytyV0VIcTA2T1k2WUlaZWk0aWRZRWNNL09M?=
 =?utf-8?B?aXRnTGE0R1RBNmRsc1RBc1o4NnZSM28vVDZGRS92WEN5Z2NKUWdVN3dhNUxa?=
 =?utf-8?B?SXRtajdOL0MybmNBMkt4eG93UE1uRXRJSEJkNHRNN1VweXZlK3RFeWtudlJY?=
 =?utf-8?B?Nm84em91ZWVYQmswMHpFaFBoYklUQnQ3d0h3RWQ0SE5XR2c5Q0dsZ0luNkJs?=
 =?utf-8?B?YW5lWS9ndGZqVU9YZXEzbGFkSXhmbkNnOEZldFFudDJCOEp1ZFpiVCsvM2pD?=
 =?utf-8?B?VkZlMnZVKzBhTytxUFFCbXFrcjBBa3BoSjV2WjhBaGl2WjBRcGFHTzJPbUkw?=
 =?utf-8?B?ZHFMZVFOUm9PaTdxOU9CUFRnMGV1ek5md2xaRFpYdGdJK3cySjg1MUlqV2U5?=
 =?utf-8?B?MHJnUlJ2SUVNWnRveW9aZnRiWFNMV2NUdE1Yc0kya3JVMi9MREZwSDArODJS?=
 =?utf-8?B?YjI2U0x3VVI4bnZpZnl1dGJzU2dGN0JRZFhmVFplVmdmQys3ekxvTU5BTHZ2?=
 =?utf-8?B?bTZ3U2V6a0hZZHozbi9Oekt1N2FHTmxSeHAxb2MyTks4clhDOEp0NENhYlQx?=
 =?utf-8?B?bDRxUnVobHpQbWhoQlRGUVUzcjlQNGhrQ0MxdzdJc2xVbW51VWRreHA5d2hx?=
 =?utf-8?B?TWVNc3N6dHZiQitZbTQydGlOVHVVbnp3UE9qVDhkRnFDS2o1Q29YTGFxNmtM?=
 =?utf-8?B?Q1ZRcWRZc0sySnZzSDVONkxBV3pLdGlrQ3lWZjJqNk50d3VEV1poOHVYMExD?=
 =?utf-8?B?QzY2K2M5YlJ4UUFudVN4THVQM0I2Y1Rna1Y0UGdybG5Ucmx5L2FRSkw1M3Z0?=
 =?utf-8?B?WEgwcVBRYS81MVR2d1ZzZ3FhVUFiSGhDWTZ3TXdzZnNnd3luRUhuSHNqb2gr?=
 =?utf-8?Q?DVH6byEVwriGbpizH5hQPyL60gtS6CIAoGybb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3A7799FA58A414A9C5391CC9DBE1A34@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d15734e1-725c-46a5-b649-08da4b96ff44
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 10:41:52.5905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xx/C8uOFQsC/1fIH292CLHySsBYvO1oYBv1cr4Ayxqk0gl+WvLBMEAkc1szhb4cHg3tZglydQh05hPqle8jfrnpXT1aCr1cvDdUZheGKuvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3683
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTE6NTgsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBIaSBDaHJpc3RvcGhlLA0KPiANCj4gT24gU2F0LCBKdW4gMTEsIDIwMjIgYXQgMDk6Mjc6
NDNBTSArMDAwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+IExlIDExLzA2LzIwMjIgw6Ag
MTE6MjIsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKgOg0KPj4+IEhpIENocmlzdG9waGUs
DQo+Pj4NCj4+PiBPbiBTYXQsIEp1biAxMSwgMjAyMiBhdCAxMToxNzoyM0FNICswMjAwLCBDaHJp
c3RvcGhlIExlcm95IHdyb3RlOg0KPj4+PiBBbHNvLCB5b3UgY29waWVkIHN0YWJsZS4gU2hvdWxk
IHlvdSBhZGQgYSBGaXhlczogdGFnIHNvIHRoYXQgd2Uga25vdw0KPj4+PiB3aGF0IGl0IGZpeGVz
ID8NCj4+Pg0KPj4+IEkgc3VwcG9zZSB0aGUgZml4ZXMgdGFnIHdvdWxkIGJlIHdoYXRldmVyIGlu
dHJvZHVjZWQgdGhvc2UgZmlsZXMgaW4gdGhlDQo+Pj4gZmlyc3QgcGxhY2UsIHNvIG5vdCBhbGwg
dG9nZXRoZXIgdXNlZnVsLiBCdXQgaWYgeW91IHdhbnQgc29tZXRoaW5nLCBmZWVsDQo+Pj4gZnJl
ZSB0byBhcHBlbmQgdGhlc2Ugd2hlbiBhcHBseWluZyB0aGUgY29tbWl0Og0KPj4+DQo+Pj4gRml4
ZXM6IGE0ZGEwZDUwYjJhMCAoInBvd2VycGM6IEltcGxlbWVudCBhcmNoX2dldF9yYW5kb21fbG9u
Zy9pbnQoKSBmb3IgcG93ZXJudiIpDQo+Pj4gRml4ZXM6IGE0ODkwNDNmNDYyNiAoInBvd2VycGMv
cHNlcmllczogSW1wbGVtZW50IGFyY2hfZ2V0X3JhbmRvbV9sb25nKCkgYmFzZWQgb24gSF9SQU5E
T00iKQ0KPj4+IEZpeGVzOiBjMjU3NjlmZGRhZWMgKCJwb3dlcnBjL21pY3Jvd2F0dDogQWRkIHN1
cHBvcnQgZm9yIGhhcmR3YXJlIHJhbmRvbSBudW1iZXIgZ2VuZXJhdG9yIikNCj4+Pg0KPj4NCj4+
IFdlbGwgaXQgaGVscHMga25vd2luZyBvbiB3aGljaCBzdGFibGUgdmVyc2lvbiBpdCBhcHBsaWVz
Lg0KPj4NCj4+IE1heWJlIGl0IHdvdWxkIGJlIGNsZWFuZXIgdG8gc2VuZCB0aHJlZSBwYXRjaGVz
ID8gQWZ0ZXIgYWxsIHRoZXkgbG9vaw0KPiANCj4gU291bmRzIGxpa2UgaXJyaXRhdGluZyBwYXBl
cndvcmsgdG8gbWUuDQoNCkl0IGhlbHBzIHdpdGggYXBwbGljYXRpb24gdG8gc3RhYmxlLg0KDQpU
d28gb2YgdGhlIGFib3ZlIGNvbW1pdHMgYXJlIGluIHYzLjEyLCB0aGUgb3RoZXIgb25lIGFwcGVh
cnMgaW4gdjUuMTMNCg0KU28gaGF2aW5nIHRoZSBtaWNyb3dhdHQgaW4gYSBzZXBhcmF0ZSBwYXRj
aCBzaG91bGQgZWFzZS4NCg0KPiANCj4+IGxpa2UgMyBpbmRlcGVuZGFudCBjaGFuZ2VzIHdpdGgg
bm90aGluZyBpbiBjb21tb24gYXQgYWxsLg0KPiANCj4gIk5vdGhpbmcgaW4gY29tbW9uIj8gSSBk
b24ndCBrbm93IGFib3V0IHRoYXQuDQoNCkkgbWVhbiBubyBjb21tb24gZmlsZSB0aGF0IG5lZWRz
IHRvIGJlIGNoYW5nZWQgZm9yIHRoZSB0aHJlZSBwbGF0Zm9ybXMsIA0Kc28gaXQgbWFrZXMgaXQg
ZWFzeS4NCg0KDQo+IA0KPiBBbnl3YXksIHN1cmUsIEknbGwgZG8gdGhhdCBhbmQgc2VuZCBhIHYy
IHNlcmllcy4NCj4gDQoNCkFzIHRoZXkgYXJlIGluZGVwZW5kYW50IGl0IGRvZXNuJ3QgbmVlZCB0
byBiZSBhIHNlcmllcyBhdCBhbGwuIEJ1dCANCnRoYXQncyBmaW5lIGlmIGl0IGlzIGEgc2VyaWVz
IGFzIHdlbGwuDQoNCkNocmlzdG9waGU=
