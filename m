Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6121254766E
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 18:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiFKQZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 12:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiFKQZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 12:25:29 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120084.outbound.protection.outlook.com [40.107.12.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0E064D7;
        Sat, 11 Jun 2022 09:25:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3cso2VM+8TYP6nvli19VtuTevI0MShk8ge/xc6mCtxvAcb5if/YBVJT+v0v9rRTEYCt3Ub89MHcyc4/afooO2bxJ9PUhofUy3R8VrFLsvuyicSnA9K82/GQjzyWlcB8ks8Zwv/g+zlx9DBxWFK05P7R6si3Le9Tc5ccTwbHarucqS6VaKvy0WlWkR/AH8ZveILSFfS8PUW8oDewVQxq86QyniOMq6CFd4Dz2xiqhOMjAuCMwPF0OQPFLLXk6nRTz6LpX9gTBkY2EKk24pxpDcQLuY6EPgPVUPSTaT9uRwaRojUYcC9aMlZyO2a670N2oQaXyBW6a70e3xdQgjM0/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DwS6HnD3ZPdAccuYVBLgC4Z0rdu2LXqtobIPu8VG3M=;
 b=meYy9QL8GNeGpNNrpI75LFnaC5wkU+qC+5J5vOJH9Ry6XlYta8OW6TnY0Au3tvoWEkMojZbplggI8/P1GF0QukHeOUnUN4zSvzllqgdFMohV67TeL2ei5h4iY5a4ESgHT3appecOWCUZZoEgQABeeao8WV45IjhfUfGKDYkIOXIaUtfYXZ9tWATI+dX3yuiN+MICMDpQDxzLLVihTSRa2Wyw9DItf8nKRffXYcYQemFhUlGjUWwwA0LI255A7nveFKw94rCAOfgJFXNbsAzMxrMdpzQrNoAUzSXgwcd3GDdjDDoIAM+WVh8dAbSpJBp9m3Alvk5MnizXzQXzd7LAMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DwS6HnD3ZPdAccuYVBLgC4Z0rdu2LXqtobIPu8VG3M=;
 b=K7YdB0KxhdCil/HAo1aP1jxs78deVqABje5PzLtkzVo235luJO9Q6tm12lVlbMKS8Ya2/4vdUy6XYajVwYjp8N+9MpW0HthsrHZViWJWtoTI8v4uYg/hAU+2OZ/g0uHz45QC2fvGwpnusrD5CGu0iWQwvQrfLQ4tudvBy1HYiVLN0tsHDPNpgN1yK6dBaDuVe0ORWz8PdpnyOZAfC0qPIihhhNHsd2oZ0SB4QJtoPqAKpqL89R0pESuK4OdkZMm+EzKbn6YkYKTieFLDOIUOl09ow9rmQbmVAA8AS+MmqGhBpo92P4q2UPEpfqQrYdwy+Wf/ou3AHiLlVtk4Wm6Ecw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAZP264MB2605.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.11; Sat, 11 Jun
 2022 16:25:26 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 16:25:26 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] powerpc/powernv: wire up rng during setup_arch
Thread-Topic: [PATCH v3 2/3] powerpc/powernv: wire up rng during setup_arch
Thread-Index: AQHYfaVmr3Y8IjiFUEG7v5ZFZg5Nza1KZG2A
Date:   Sat, 11 Jun 2022 16:25:26 +0000
Message-ID: <709016db-7bd2-c2ad-76ed-1dfee1c9c5c4@csgroup.eu>
References: <20220611151015.548325-1-Jason@zx2c4.com>
 <20220611151015.548325-3-Jason@zx2c4.com>
In-Reply-To: <20220611151015.548325-3-Jason@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2f4e366-862c-45f8-a0f3-08da4bc6fe59
x-ms-traffictypediagnostic: PAZP264MB2605:EE_
x-microsoft-antispam-prvs: <PAZP264MB2605A9AB0DA69C3D4A211790EDA99@PAZP264MB2605.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CRkAvf73sCEQNs2ZTj8RPM3DJ88az8iDrnPVvufdkvtf6wSDhPGU3IPkXhEROS2+nI69Pp2HTSFvzlrmTacWJ8FnT/oip2My7u8IF9bY/lZ50Tesyo4/F1W+rlrptvoDPlPvenxzu/Mltu/DDGeXTJVlc7ryhJM3BWgv3yVWKExPAQ6r5xW3gCGLWg8pM5IkfZ0srqBlCvcwZp1eMcoXNWiojpmKhR7d3Y8gYodwk9BT0s9/Ckoe4/qqc+G7bCMB8OLPnAQlMEjOqKcYNxn/DBiM3/9pbcWiUypmBfqCVQFGHN5QbxUAhYEVpbDsI6I+Ke5nVtrZoTsjgwkPH7M7nF7MvWKAqVZtRMtinMcfk+Srmm+sk/xg/3242IMei5iIYVhPU769zoR8l8EbmG2H2uivwQoW13TaERK5G5mnsnI3Mj8Y4HcbhK/fNjSUz2+sAiRfzoEP5VJLAvqjIvIBfS89SVxbhJlP/J3WtHKAblN85kt3xWlS1OQqKGH9YSa58cuAv9MUSyRKGpu7uwQnQNOLHeOjLqcBYZ9/OS879Z4E1CXYjPpNSA5KC6VVOE1INRbaWx6LrgdlbzXJibIAidlR+ULQIVyDlepIAAednBVKd5w+SWYvZZbQRyPULYJrtEZIiBWY8MZVqHryTw1KXKJiSMVsT7NTO2o+R/0/pIN4d8nmw9DrOWOZteTrCbOdIVpwAbESRAqESSHiklrTtf9pE9VZ0THdqVBC4BtpGtN1fKLdcTXV2UtWWZOShizDcC32UTXVrI0ELfhxZ9D5tQ8vbptEzNarQV5fPpfEvFY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8676002)(76116006)(66946007)(66476007)(66446008)(64756008)(4326008)(6486002)(6512007)(508600001)(66556008)(5660300002)(8936002)(91956017)(44832011)(71200400001)(26005)(38070700005)(66574015)(2906002)(36756003)(316002)(31686004)(38100700002)(186003)(110136005)(83380400001)(122000001)(86362001)(6506007)(31696002)(2616005)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nk1BK1liS1hlL3daR2ZMcHRZT1V5NDgwOHJCS3U1U0RrZjl5TTBvekR0ZVRq?=
 =?utf-8?B?cFZSWlFZWmxwTG5jemkyQUxMU2VGamg1TmtaYmZPQmVHcENYaUMwMGlOWFBW?=
 =?utf-8?B?QWNnQVRuL0RSUFpTa0J6VVNpOFJCeHRZeFp3RFBSdklyTlFydXFlL3hVUUU5?=
 =?utf-8?B?MnZuRmhGNkxMM2lmSFRocU0vTCtRbGR0TFBiMGtFVDhycm5zakM0T1l0NnJW?=
 =?utf-8?B?dytJQTB2UktzRnFDSWV4SWNPN24va2t1VDJndlE0T1NWb0NjWFFPY1pyM0JY?=
 =?utf-8?B?K0lkOE9KNk9GWUluSzFvQkZ1THFyemNITmp1QnRqZVpkUXE5YkJKYlZsQzdE?=
 =?utf-8?B?ekZrVHNEa29sT0M5ZFd6aHVKMDlUWmcyNTRTT2xMb2V2SnlYaytuNzg3OEo1?=
 =?utf-8?B?Ym9JK3lmcXh0dFl3Ui9vOU14WllVWjFMeThHa0NMNnF4M1JlcTJlZ3lzT2Rr?=
 =?utf-8?B?SzhGZkhub0szc3dURnB0YlFnN0g0K01hclRwbXdGd3I4VzMwVm0wZ1YrTjhI?=
 =?utf-8?B?UVlaMWtGMFQ0eVgzUWJKSjdHNnhVR1dnSEUxaWY1ZndYMlN3MGIzajJ3S1Iy?=
 =?utf-8?B?c2JYelhqTFl3Rm52VFlYa1hsWksxMG04MWM1RXZuTUdiN2svWUxoTHllalFz?=
 =?utf-8?B?N21ZTnBpRGpxRk1wYTFNOVovcGN2Q2tWWDM3ZXR5WkVQM2F4L3ZNYkJNaWpq?=
 =?utf-8?B?VkRkRlFiMVFZTWJBNXNtVDROdmFEWXlQczY5WWdROE40ejF0TGZ4Z2IvYjRa?=
 =?utf-8?B?YVpRRE8xZUpuTXl0Umx0WEFyNHF5Z3VnODRtV3dNRkQ0Q1FVZHlwRXBxbUdr?=
 =?utf-8?B?MU1LbVFBQmRyVDJ5Wmh6akhOcEpDUm51ajhHNllOcnBMVnE1WTQxaG5WMHh1?=
 =?utf-8?B?bjlJWUt4K1dHbDV6L3dVb0QyMm9FMEdEdE5abHUxcXhvU0Z0MTg0aTBLRk1F?=
 =?utf-8?B?bVhvcm9UcGdvYmpDUG9EdHpJUXpoMm1lYk9TT09hSDNXaW8zRzJuZjlsU3hS?=
 =?utf-8?B?VlU1TmpzbDk5bVBMY0VNN0R1dm9wdCtHVjQvaStiWlp4WU1Kd0d2c1IxMUhH?=
 =?utf-8?B?L2dUcDcvZnVhcTdScjVwSTgyK2NCUXp2NnVYMU1odFNpU2xtNkM5alhBZy96?=
 =?utf-8?B?VnVyU2Jqcm1aWldMQnMwNis5eldOU3pVd3MwUnF2K2c5RTRMQWZubE9zMy9q?=
 =?utf-8?B?aGRkU253b1lPTzJQY3FZQ2VhVGpGMFMxaUVjQjhlTzdRelhlZitSV3FaMldF?=
 =?utf-8?B?cEdnWjRZYm5uQ1dSVk0yT1dKUnZYMEUvT05HSFBZZzkyTERpbEQ2MDY4dDd1?=
 =?utf-8?B?T1NnZDB6aVRsdkhoNmQ3V1BocWJmZTgzRzBJZW1XeEQxQVpVdXJtSUN6aXN1?=
 =?utf-8?B?aFFmdFJ5eUE0dTBQZHVUb2RkNDZnZXdBT3g0dFViMjVQMk9YeGlyWlZVTXht?=
 =?utf-8?B?STY4Q1NCSTkwRmZXbVk0MkUvalJBVFRlVENJdFNsclB1OENxQkVxK0tITzdG?=
 =?utf-8?B?aHFKcVVlUnJyZjUweHJmZ0hXakZ1OHVhMXZDQldUTk1aQWRMOUREbWFFUUhh?=
 =?utf-8?B?V3Z5c0xCYTQ2K3plNGxIbTcrbEdKQ3VZODlSaE1PQ2cwdlhzekQ0NVFhK0t4?=
 =?utf-8?B?OG1YZlRLeHlONkxlcWJKbWgybG9Ga0J0enhLRFlFSHhPb0kxOGtRT2J3SXVM?=
 =?utf-8?B?UGdXYUlzK1NTMEJKT1h5TTZvVVZESnI0SUlaaVNEcEsrVzc5NS95TU5LM2Mz?=
 =?utf-8?B?cVJLTFdiVEg4ZTZYdUNPNzZmMTdwVVBEaTRFajNGOUdweHJmYTB6cWZYVVc1?=
 =?utf-8?B?enJuQXJEeUl1dDdqU3lhdVM1bnVxdTVjQlZrL1Rlb3Z3d3NaUTFJTkpnQjht?=
 =?utf-8?B?WDFXUUl4WTNkY3h4ZGJVRVBWQVZaNWZTWS9Galcxd1lKL0RUc3lQZUpsY1BC?=
 =?utf-8?B?bG5ZVVk4enFaV2w2WnRlNSt5L2laWWFUVG5Bem1Zd1FJV2pocmFmOXQvN0dp?=
 =?utf-8?B?Sks2d005cVVROW9oTU1URVM3a1hYdExDN1JzWXloaXFPelNYWk5oSzJJZS9s?=
 =?utf-8?B?bzRpTlJuSU1BelViaEpVR3I0UkFOaTNIWXRKSmsxcFFCZ2lqTWhmYWZCTDRC?=
 =?utf-8?B?OWR4SFpjek5obHdKQ0JuNGZsS29oajVMTGEwMGNaY1hQTXZ1UEc5Q1ZySjRl?=
 =?utf-8?B?SVg5eGNCVldSOWduSDNITzREb0o2UUNxVFp1SThpY1J0RU9qU254d3dIRFhB?=
 =?utf-8?B?TW5IMkZ1RGg0ZjJqRkRFZHV4QXNnTkRnTHJNK05GT2pBbThTWFZNYVU3QW5N?=
 =?utf-8?B?SmxjVWc3MVpocXB3eVdScWh0dldyOFNSakQrOHNrOHpJNE9BYzVjZS9mTndT?=
 =?utf-8?Q?OyeX4Fo+TnemglTZQGeD5O24yV8gVwQJ02YiV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BFE273957594E4FA354A1681686E36F@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f4e366-862c-45f8-a0f3-08da4bc6fe59
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 16:25:26.8772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ooNOEQH0NU0oUKFrK74NoTOeIQzEi3xGjF0tRMiz5DHyHMFAasfJctdFGzORyXLTnCb2AwnoGlSxjuHxSzXU7NO6cnG1tgTSVk1x1ra01o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB2605
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTc6MTAsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBUaGUgcGxhdGZvcm0ncyBSTkcgbXVzdCBiZSBhdmFpbGFibGUgYmVmb3JlIHJhbmRvbV9p
bml0KCkgaW4gb3JkZXIgdG8gYmUNCj4gdXNlZnVsIGZvciBpbml0aWFsIHNlZWRpbmcsIHdoaWNo
IGluIHR1cm4gbWVhbnMgdGhhdCBpdCBuZWVkcyB0byBiZQ0KPiBjYWxsZWQgZnJvbSBzZXR1cF9h
cmNoKCksIHJhdGhlciB0aGFuIGZyb20gYW4gaW5pdCBjYWxsLiBGb3J0dW5hdGVseSwNCj4gZWFj
aCBwbGF0Zm9ybSBhbHJlYWR5IGhhcyBhIHNldHVwX2FyY2ggZnVuY3Rpb24gcG9pbnRlciwgd2hp
Y2ggbWVhbnMNCj4gaXQncyBlYXN5IHRvIHdpcmUgdGhpcyB1cC4gVGhpcyBjb21taXQgYWxzbyBy
ZW1vdmVzIHNvbWUgbm9pc3kgbG9nDQo+IG1lc3NhZ2VzIHRoYXQgZG9uJ3QgYWRkIG11Y2guDQo+
IA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBDYzogTWljaGFlbCBFbGxlcm1hbiA8
bXBlQGVsbGVybWFuLmlkLmF1Pg0KPiBDYzogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5s
ZXJveUBjc2dyb3VwLmV1Pg0KPiBGaXhlczogYTRkYTBkNTBiMmEwICgicG93ZXJwYzogSW1wbGVt
ZW50IGFyY2hfZ2V0X3JhbmRvbV9sb25nL2ludCgpIGZvciBwb3dlcm52IikNCj4gU2lnbmVkLW9m
Zi1ieTogSmFzb24gQS4gRG9uZW5mZWxkIDxKYXNvbkB6eDJjNC5jb20+DQoNClJldmlld2VkLWJ5
OiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+DQoNCj4gLS0t
DQo+ICAgYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52L3Bvd2VybnYuaCB8ICAyICsrDQo+
ICAgYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52L3JuZy5jICAgICB8IDE4ICsrKysrLS0t
LS0tLS0tLS0tLQ0KPiAgIGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9zZXR1cC5jICAg
fCAgMiArKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL3Bvd2VybnYv
cG93ZXJudi5oIGIvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52L3Bvd2VybnYuaA0KPiBp
bmRleCBlMjk3YmY0YWJmY2IuLmZkM2Y1ZTFlYjEwYiAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dl
cnBjL3BsYXRmb3Jtcy9wb3dlcm52L3Bvd2VybnYuaA0KPiArKysgYi9hcmNoL3Bvd2VycGMvcGxh
dGZvcm1zL3Bvd2VybnYvcG93ZXJudi5oDQo+IEBAIC00Miw0ICs0Miw2IEBAIHNzaXplX3QgbWVt
Y29uc19jb3B5KHN0cnVjdCBtZW1jb25zICptYywgY2hhciAqdG8sIGxvZmZfdCBwb3MsIHNpemVf
dCBjb3VudCk7DQo+ICAgdTMyIF9faW5pdCBtZW1jb25zX2dldF9zaXplKHN0cnVjdCBtZW1jb25z
ICptYyk7DQo+ICAgc3RydWN0IG1lbWNvbnMgKl9faW5pdCBtZW1jb25zX2luaXQoc3RydWN0IGRl
dmljZV9ub2RlICpub2RlLCBjb25zdCBjaGFyICptY19wcm9wX25hbWUpOw0KPiAgIA0KPiArdm9p
ZCBwb3dlcm52X3JuZ19pbml0KHZvaWQpOw0KPiArDQo+ICAgI2VuZGlmIC8qIF9QT1dFUk5WX0gg
Ki8NCj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9ybmcuYyBi
L2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9ybmcuYw0KPiBpbmRleCBlM2Q0NGIzNmFl
OTguLmM4NmJmMDk3ZTQwNyAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9w
b3dlcm52L3JuZy5jDQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9ybmcu
Yw0KPiBAQCAtMTcsNiArMTcsNyBAQA0KPiAgICNpbmNsdWRlIDxhc20vcHJvbS5oPg0KPiAgICNp
bmNsdWRlIDxhc20vbWFjaGRlcC5oPg0KPiAgICNpbmNsdWRlIDxhc20vc21wLmg+DQo+ICsjaW5j
bHVkZSAicG93ZXJudi5oIg0KPiAgIA0KPiAgICNkZWZpbmUgREFSTl9FUlIgMHhGRkZGRkZGRkZG
RkZGRkZGdWwNCj4gICANCj4gQEAgLTg0LDI0ICs4NSwyMCBAQCBzdGF0aWMgaW50IHBvd2VybnZf
Z2V0X3JhbmRvbV9kYXJuKHVuc2lnbmVkIGxvbmcgKnYpDQo+ICAgCXJldHVybiAxOw0KPiAgIH0N
Cj4gICANCj4gLXN0YXRpYyBpbnQgX19pbml0IGluaXRpYWxpc2VfZGFybih2b2lkKQ0KPiArc3Rh
dGljIHZvaWQgX19pbml0IGluaXRpYWxpc2VfZGFybih2b2lkKQ0KPiAgIHsNCj4gICAJdW5zaWdu
ZWQgbG9uZyB2YWw7DQo+ICAgCWludCBpOw0KPiAgIA0KPiAgIAlpZiAoIWNwdV9oYXNfZmVhdHVy
ZShDUFVfRlRSX0FSQ0hfMzAwKSkNCj4gLQkJcmV0dXJuIC1FTk9ERVY7DQo+ICsJCXJldHVybjsN
Cj4gICANCj4gICAJZm9yIChpID0gMDsgaSA8IDEwOyBpKyspIHsNCj4gICAJCWlmIChwb3dlcm52
X2dldF9yYW5kb21fZGFybigmdmFsKSkgew0KPiAgIAkJCXBwY19tZC5nZXRfcmFuZG9tX3NlZWQg
PSBwb3dlcm52X2dldF9yYW5kb21fZGFybjsNCj4gLQkJCXJldHVybiAwOw0KPiArCQkJcmV0dXJu
Ow0KPiAgIAkJfQ0KPiAgIAl9DQo+IC0NCj4gLQlwcl93YXJuKCJVbmFibGUgdG8gdXNlIERBUk4g
Zm9yIGdldF9yYW5kb21fc2VlZCgpXG4iKTsNCj4gLQ0KPiAtCXJldHVybiAtRUlPOw0KPiAgIH0N
Cj4gICANCj4gICBpbnQgcG93ZXJudl9nZXRfcmFuZG9tX2xvbmcodW5zaWduZWQgbG9uZyAqdikN
Cj4gQEAgLTE2MywxNCArMTYwLDEyIEBAIHN0YXRpYyBfX2luaXQgaW50IHJuZ19jcmVhdGUoc3Ry
dWN0IGRldmljZV9ub2RlICpkbikNCj4gICANCj4gICAJcm5nX2luaXRfcGVyX2NwdShybmcsIGRu
KTsNCj4gICANCj4gLQlwcl9pbmZvX29uY2UoIlJlZ2lzdGVyaW5nIGFyY2ggcmFuZG9tIGhvb2su
XG4iKTsNCj4gLQ0KPiAgIAlwcGNfbWQuZ2V0X3JhbmRvbV9zZWVkID0gcG93ZXJudl9nZXRfcmFu
ZG9tX2xvbmc7DQo+ICAgDQo+ICAgCXJldHVybiAwOw0KPiAgIH0NCj4gICANCj4gLXN0YXRpYyBf
X2luaXQgaW50IHJuZ19pbml0KHZvaWQpDQo+ICt2b2lkIF9faW5pdCBwb3dlcm52X3JuZ19pbml0
KHZvaWQpDQo+ICAgew0KPiAgIAlzdHJ1Y3QgZGV2aWNlX25vZGUgKmRuOw0KPiAgIAlpbnQgcmM7
DQo+IEBAIC0xODgsNyArMTgzLDQgQEAgc3RhdGljIF9faW5pdCBpbnQgcm5nX2luaXQodm9pZCkN
Cj4gICAJfQ0KPiAgIA0KPiAgIAlpbml0aWFsaXNlX2Rhcm4oKTsNCj4gLQ0KPiAtCXJldHVybiAw
Ow0KPiAgIH0NCj4gLW1hY2hpbmVfc3Vic3lzX2luaXRjYWxsKHBvd2VybnYsIHJuZ19pbml0KTsN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9zZXR1cC5jIGIv
YXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wb3dlcm52L3NldHVwLmMNCj4gaW5kZXggODI0YzNhZDdh
MGZhLi5hNWZjYjY3OTZiMjIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMv
cG93ZXJudi9zZXR1cC5jDQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvcG93ZXJudi9z
ZXR1cC5jDQo+IEBAIC0yMDMsNiArMjAzLDggQEAgc3RhdGljIHZvaWQgX19pbml0IHBudl9zZXR1
cF9hcmNoKHZvaWQpDQo+ICAgCXBudl9jaGVja19ndWFyZGVkX2NvcmVzKCk7DQo+ICAgDQo+ICAg
CS8qIFhYWCBQTUNTICovDQo+ICsNCj4gKwlwb3dlcm52X3JuZ19pbml0KCk7DQo+ICAgfQ0KPiAg
IA0KPiAgIHN0YXRpYyB2b2lkIF9faW5pdCBwbnZfaW5pdCh2b2lkKQ==
