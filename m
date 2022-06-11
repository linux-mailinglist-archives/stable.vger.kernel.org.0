Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9ED5475C7
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 16:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiFKOtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 10:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiFKOtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 10:49:02 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120055.outbound.protection.outlook.com [40.107.12.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022C85584;
        Sat, 11 Jun 2022 07:49:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXQ0qe2pjGThlbR1+7SzTA3e3hCV2l3zx0wLeKwwllOetZPgFC6MAsiYmmkr58VIfWiy3HQJ2v4Px2CFRAvtQCRRbuHkGlcfpbIwJIvXTEJw/U63LZOf9hQ8lIzKE8UCypYorjYdTPNiRZ+MfL/6P1wO7azMTyIvfk6ttD+n9YtK0JySxwYqhi2vw+jKWzSfckBel1rQORIIpNWQWmX7aXbbbukBJIJcCnC7hD3U3im4iXZuDsSPF10pBYNZeayrIPoWeqW2Z4/cm9rTZNgtShABnuK0AoE1XqiIFye25xd9iSU7eXvnXPHlyUeD7h2CUvLiAsXQrpbyos8U5Ad9xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDB3KCld6Ed4kX0k79ej0OO3m1Ydq3KcMN6A7l8qj4Y=;
 b=Mi2TAS6ul/pmGSmFeJqAt5zUGuy83I0Wuwy+Y996ICicGfhTLBMhc4XrQmrXZFnRSeQoei9FaQtegh033USEV3OJzzuOdf6KFl3u+iZ6wHFB8ccuMdpKc9VA/ZD8X25s8GAsNN9/YnJ1oflAAgCEZtfoMaU8K7GIkv3kncGPIPC7voErkR4aBN+CFyhC4houn35+ePc3uQG9+RmA4rLcebhxb/N4T9XQN1tJQanDyqkMoDJhVfa8FrmUou6IKXL+pDdMyFjSWGfNqvsK1il4tPP5NiPOUmQPf2+ybE9AzazRRySBINdlN946hY+Q8qsbbzuJX1GNERkONo1VNQ2qxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDB3KCld6Ed4kX0k79ej0OO3m1Ydq3KcMN6A7l8qj4Y=;
 b=CxCWEtX/AB9PM6hNx2bqNGJNhhxUD+wx9F+AHLAk9mmUdWAUv055oyrKhhDMnUZshCdNxluGSfYDsZtrrIZajGzaStO3x58H5pAeOc05LMUV1OJlyu1TxiqDEcVJ1A2KsUJz9HFflJxFtIXeXVKBgkz3HWYPUgZ2Ma7SBn1zZdo6g6Pr8u4y5y8kdnJg0EomeW650h3+HwV3W6aRueVu48HD5L2xgrHuxZsU9oI+GZEPgN274Cn4pJfkPqIfkj/MRIi9vtHvcAzbVuUmFNOy07N5lYl86y3ZhIj8J2oytN+v6e426nFPhx5JUi5yxjlmMxj042DZJlbt8r/BuZ6DYg==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3905.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Sat, 11 Jun
 2022 14:48:58 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b15e:862f:adf7:5356%6]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 14:48:58 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] powerpc/microwatt: wire up rng during setup_arch
Thread-Topic: [PATCH v2 1/3] powerpc/microwatt: wire up rng during setup_arch
Thread-Index: AQHYfXq8DcYmY+ypHEaglXyg0zBxaq1KR4SAgAAAVACAAAEjAIAAANOA
Date:   Sat, 11 Jun 2022 14:48:58 +0000
Message-ID: <c94deb33-c28e-12c1-e3b1-aebd4249baa3@csgroup.eu>
References: <20220611100447.5066-1-Jason@zx2c4.com>
 <20220611100447.5066-2-Jason@zx2c4.com>
 <6432586f-9eb9-ac71-7934-c48da09a928e@csgroup.eu>
 <CAHmME9rBWcdZtJCQ1WZAPOJtnA6u4w0ub4s4M+UW60gMSNgWrQ@mail.gmail.com>
 <YqSqqq0zC7yDOQib@zx2c4.com>
In-Reply-To: <YqSqqq0zC7yDOQib@zx2c4.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3430a43-131c-4622-dc81-08da4bb9846d
x-ms-traffictypediagnostic: MR1P264MB3905:EE_
x-microsoft-antispam-prvs: <MR1P264MB39053D4E0017E22F8053B1B0EDA99@MR1P264MB3905.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rtqL44ynQ+TuibPGUGovyA0zgLJn9mqzKjN0d1ovj11zc68almrCIaEN2Cq9cgq4yNVJ2nhJobl+nDL4TIq8NGJhTWAbKu4RTL3ZXOpghb9diMU7JN0uEHtErJ2nfbyCND3XlxsUkCeokE1SnH1QiCID2Fbzjk3N84h/EktncEi2hKxEXcHMqyYpJ8lsYZxxRpeoyP4k1KH6hp0Jc4M47n6fhUo1jNJyGOGFvuDhBxNPVjKDoTR9qUwtrcXiMmWMFkbrOP6m3znl2N/via6xeDR+ngeUzw0mNFjb26aeKGuOh4xIVC+RTR+3p/o7XAS1pOcZ+tR6ojWd8tpOaJWdTbLCvhXZVnPKWK2bVUS/m7KgbjPd8ykSbV876mXIAfZJ0P9+DZA24z2jnRtYtjW8nuYfR1VXKvLXaz7UxCG3uVSfFLxyJLKJhMsGNLXPNkS+hg/WTFCE5vj5qIFVPlwrEWgiwLBDQ1Zhhfo1aL4UFJ3BPCT30euzfrMt20iLEMpxM7MNJgBUtrkzAmDoeyJAPZA4P73BqudXQvdnZHpQxLMb/EuhxW5yFL5DRKBa3ZZy3CZva+gNEuneqgVOGmbCzfKKZnOrutl4jp9XWfvf1sJRbxw90IPLCRQQJALK0gaCMsvydJ2eUbH8UB19ViNRVEoNBo9q6m/h07eXXqtVGhK1vroHJ2k76s+0yE7sp3LNeAue8QDogjOTee7YckJoSget4MslfJwcH4VpuxT79814S/9NjkGAFcCMPSJTsH8XDLvDXZi/NBWlwoW5dFDZ1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(64756008)(8676002)(76116006)(91956017)(31686004)(44832011)(36756003)(66446008)(66476007)(66556008)(8936002)(316002)(5660300002)(66946007)(71200400001)(6486002)(6506007)(6916009)(54906003)(2906002)(4744005)(508600001)(38070700005)(6512007)(26005)(122000001)(38100700002)(186003)(86362001)(2616005)(83380400001)(31696002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkZZWmwvamJveVV3aStQaTgzZW5kKzd5bGVxVllZQjVsQW96OGhZNHdXaDNX?=
 =?utf-8?B?R3o1MEFoOURiQUREdXQwSW53TGpRYkhYZ2xYc2JFeit5UzZraUw5OC93eEVo?=
 =?utf-8?B?RDZrWG5qNC9WTWNpZ3pDN0kwNGplZDBGcFYwd0lFU0t3eXpUOUtWSlFlamdO?=
 =?utf-8?B?ZURLdExBR3BybHdYd2FKOTZ1UlVGNG53bUJ6NzlnR3VrdERobU9mT2xpaU9S?=
 =?utf-8?B?UFZtTGlydGltaENidUFvWHM1K25pTjVtNXZVdWQzVU5sN3Axa04zczFCczkw?=
 =?utf-8?B?NDh6YlNJSjF1MklZYnRRcnN6ZkpqRENHc0I5dXl5YXpTbVRUODJjYjd5eEhv?=
 =?utf-8?B?ZEdMSWs5Wll6Q1poVmpBYVFZeis4WE9SVDlJd1FKcitBK2JKZ0tOUzdvbkNZ?=
 =?utf-8?B?M3pCaUJZakdheUNKbWgxaDhKdWZFWm82UFIzSHprWlByd2xyY1JTV2RqUGNo?=
 =?utf-8?B?dEFjVitrcWxoalkzVE9uSkRUMFhDcUFmQ0liNHhxTUhwbFB1Yk16UWNFSzRD?=
 =?utf-8?B?YituTjBjamlITjRzeGUrQWd5Z2xDcHAwSktvcEJTZm5aM0RBemhzbERraTFZ?=
 =?utf-8?B?bDd3RDNTYS9yNjZSaEdHN1RJOCtKV2hrV1p1T3M4WVpjT0dIb3BUOVhpUUVo?=
 =?utf-8?B?NG9PZERZRnF0YlZqNTJ3U0w2dHRiV0tLd0ZHaGNYdWRiWkc4eW5qRkdSWjZa?=
 =?utf-8?B?a1F0M3FjSGlWZU9QN0RpN3JGemdkaGhvTGIraXJHTmVNYVhaYU1idzdMWFM1?=
 =?utf-8?B?MUZ5YTZWSkxIQ2RPZzd0aEpaQkh0Y2x1SUNYYUJmK2JaMGdhY2J2S0RaSXA0?=
 =?utf-8?B?bG9VOHNTNjVXalB3RWdGNC91MFpCUGpnbWJIRFpWbVVqRlo5Y1JKalhVNld2?=
 =?utf-8?B?QVNHUjBiZU5WM1ZmT2hKYVVhZjJlR3puNFRxTHQ3eTN5bzMwNjYzditUdzRF?=
 =?utf-8?B?MFBTWDVUbFdldFNnWlIvaDBjS0U5L09rWXlQSXN2RGF0QmdkdEhuQkFjenA0?=
 =?utf-8?B?L0NCNTRiQVFTaXVNVU1Oa1lpTW5QRmFpOGJCaHJXZDA1MWl0UTVFL1ZhRVFR?=
 =?utf-8?B?MXg1VG8rRjhSdlJVZUQyK1JFcVNDazZaVWludy9rTk1JK1FVcFpnbnJHV0Za?=
 =?utf-8?B?dSszbEp1N2d5UzBVamJBYTN1amRSUkprT0lnOXhLSlNpd2NwR1o5NWt3cHdt?=
 =?utf-8?B?d01sbW1ZWWJ0d3FjQ0FFbjRBTW5qUDU3UHdkUmRid055QjhuTk1RYmpvZnJT?=
 =?utf-8?B?cjNTQlBRZURqSis5cDRWQi92dldqUVZ4MlpTd2lzMDk1NVBjSkJ3ZGdtRWsy?=
 =?utf-8?B?TGZpclNLWGdTVGJzbXVuVzVpN0JPNzk1RWx1VzUyc2lPdysvRzlIZ3hOcktr?=
 =?utf-8?B?dTFkRjZlRkRHbmpNZllBYUw5Y3hNMlA0NmRPT0hza3RXT3lJMnkvZVFCWHJr?=
 =?utf-8?B?aVZtejkrem1zME54aEdPWU0vTnhZMHpnVGRGcmgxMW5wTFJ4d3JnZ0hiWTNN?=
 =?utf-8?B?UnFuS2JMQ29vTFdRWVJWQ2FHeDROcndnOXFPbGZUNzlmMFZIY2d4dTh4YXZF?=
 =?utf-8?B?Wkxna1ZIbEJ1bWRaWFF3b1ljWlhQT3VvbGxHblJuSlhFbWQ4dFhkUk9zVmFy?=
 =?utf-8?B?WGVTcllXVnpTVFdNU3N3OElpWS9iMUp5QzMydHdaYXYzR1RJd1BTVklHdVBs?=
 =?utf-8?B?VlFxRUdrT09TZ2RRNmYwa3dDQmFTVzhnTEZLckpETDdXV3JsVUVyekNCdWVK?=
 =?utf-8?B?MnppUlpjb2NaZ1lLZGZvK3dVRk1Ua2RFSk1lTEU1UTFNQmNqdTdVNG4yMVNt?=
 =?utf-8?B?TmNUZm9UcElybmFTZCsyVGt1NmxIcmhtVVNIYjdUeCtRMW4zZ3k2b05HaWtM?=
 =?utf-8?B?K1FxdlRNZzNKU1F0amMvSjVJOE4wRjZ6RWRlVXRjVHhTd0NIOE1UNkRYeDBG?=
 =?utf-8?B?cFBVcGttQkZESnQ5L05BcEQrSW50b2xtejFDTkRNTllSWWVUdHRiRzdnV3lP?=
 =?utf-8?B?Q2pJYlpYbTgzWUIwb0NOc1hET1ZoQThvSjZCL0ZiYVBQV1E5OUlVOG16M2Zh?=
 =?utf-8?B?NHd3dmlXcjN2aFZCdTR5Um8wbzFkN3FWZ1FYWjBJV1dGNTRYMUV0dmJMaU9W?=
 =?utf-8?B?Tjlabm4zaEhGM25SNk05NkdoYWg1MlNqTlpLMGV5YVNmZjFHa1lKc1k2VzQv?=
 =?utf-8?B?blRLOVkrWUVlZEZua2gzR2MzT0F2V01veFAxc3pWaTBvWHR5OVRVanZlL0V1?=
 =?utf-8?B?WTE0bUo2dElScjMwcncwak5YYTJQU2xQamcwU1h2NVhqeGZzZ1l5Z1NTc1Bm?=
 =?utf-8?B?NmVUaG9JT2NlS0dCa2tSd0FpMWpYY1pXWVdmTThHL1dIY1UyUnBDUEVJOTR2?=
 =?utf-8?Q?SYEQfqvqBw0yBTB37v+yCKK0KLwGczwdlZBou?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <312E04253BAD0148B8AA7E7227C834A2@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f3430a43-131c-4622-dc81-08da4bb9846d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 14:48:58.8703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o222aty997wXsTce1ggIvgyJPidYDI4KMhKcxe9nUHNzcyNncneYvMPusxK1knphVlgjVUTytLJSQ28CwX7H755OOiQO73rjlDS4aa4XM58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3905
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDExLzA2LzIwMjIgw6AgMTY6NDYsIEphc29uIEEuIERvbmVuZmVsZCBhIMOpY3JpdMKg
Og0KPiBIaSBhZ2FpbiwNCj4gDQo+IE9uIFNhdCwgSnVuIDExLCAyMDIyIGF0IDA0OjQxOjU4UE0g
KzAyMDAsIEphc29uIEEuIERvbmVuZmVsZCB3cm90ZToNCj4+IEhpIENocmlzdG9waGUsDQo+Pg0K
Pj4gT24gU2F0LCBKdW4gMTEsIDIwMjIgYXQgNDo0MCBQTSBDaHJpc3RvcGhlIExlcm95DQo+PiA8
Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1PiB3cm90ZToNCj4+Pj4NCj4+Pj4gK19faW5pdCB2
b2lkIG1pY3Jvd2F0dF9ybmdfaW5pdCh2b2lkKTsNCj4+Pg0KPj4+IFRoaXMgcHJvdG90eXBlIHNo
b3VsZCBiZSBkZWNsYXJlZCBpbiBhIGhlYWRlciBmaWxlLCBmb3IgaW5zdGFuY2UgYXNtL3NldHVw
LmgNCj4+DQo+PiBBbHJpZ2h0Lg0KPiANCj4gQWN0dWFsbHksIG9uIHNlY29uZCB0aG91Z2h0LCBJ
IGRvbid0IHRoaW5rIHRoaXMgcGFydCBpcyB3b3J0aCBkb2luZy4NCj4gVGhlc2UgYXJlIHBlci1w
bGF0Zm9ybSBmdW5jdGlvbnMsIG5vdCBwb3dlcnBjLXdpZGUuDQo+IA0KDQpUaGVuIHlvdSBoYXZl
Og0KDQphcmNoL3Bvd2VycGMvcGxhdGZvcm1zL3Bvd2VybnYvcG93ZXJudi5oDQphcmNoL3Bvd2Vy
cGMvcGxhdGZvcm1zL3BzZXJpZXMvcHNlcmllcy5oDQoNCmFuZCB5b3UgY2FuIGFkZA0KDQphcmNo
L3Bvd2VycGMvcGxhdGZvcm1zL21pY3Jvd2F0dC9taWNyb3dhdHQuaA0K
