Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A00F657D9E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiL1PpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiL1PpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:07 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2119.outbound.protection.outlook.com [40.107.6.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3027F1759F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OB7AvkkJwS0ojIdsfjUmfMTGTNWBkjgNGpc5wKKMBp1G9fiNX3ruRDetURLCVp2bFa86lM0onzA60pP0feBdeApPvomIhUP9ZMhK3LwapfGeTN0V1/zHO6HpSIEmb2EibaPS6xGeV/t6LE8O6n2uJP0hidicGyljfqOQ+VVS6fij6uYrpI7nJQNFvQlslhATF030FoOW9RQmbr6TVjjAMeZX66nqPeHcNBvK87vpahudPxCLNdIBY+1Z9lM86f5tYzNF7WOUcQH6980nIaR1dmbklva+ASEx3064VFoKyheDPnUFkzcs4dwk6RR+gOYCfrOYBZcsEgqeEKWyqjXniw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnWhQwOe43NAjQw/rdMnzI4/HVBZ0omYvB1WXybX9xA=;
 b=mWQegHXok8B7BJC7arP2bmz6YhDzXXXx41zvk+sLd7DP7JcOlmgcPK+oltRo/0xWIr2srTvjFrq5L549xTxPyMEMqPDkOabPQw9jfAsg5CZEW0HUlgWWyFFRXTK79EIpHN/Fu/+BRGZOjipJ1dgltEFDh1iVFSW8JRgjXabPhiLOfwBnzE7jdQKpOQl+HhdTz1rMga9BiAKHIyhCTFcIux+IiFWVzu5uFsIgfg/ZV6JQ+Qg7QmuDXkwYbgQE0DzbZBkQv0TW5Lk+hX/qq+FA5aT0QqcVflG4Qk8myxoi+owcXoEolelwTYiRHftGlAY1RvrZmvaRpedzzKJfzsRyBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnWhQwOe43NAjQw/rdMnzI4/HVBZ0omYvB1WXybX9xA=;
 b=dZHXbSE/B4sQFmJlYznyFxjucaXqXzgBIpE+P11iv9UH4pHFwRq/i3q7GqhRnQP+aGfOXjqM47r9DfCZG+9VYpgs3q0iNSZeZ7ngqIS/a45XiQfVCxmztWICRnBiiKTq+q9c4KtSL7GeO/00FaSMYd6OqfYqn6bN8Q3yGshTn2g=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PA4PR03MB7245.eurprd03.prod.outlook.com (2603:10a6:102:bf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Wed, 28 Dec
 2022 15:45:03 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::ab9f:b966:bfb6:b71e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::ab9f:b966:bfb6:b71e%7]) with mapi id 15.20.5944.016; Wed, 28 Dec 2022
 15:45:03 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Rosin <peda@axentia.se>, Marek Vasut <marex@denx.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Marek Vasut <marex@denx.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 456/731] extcon: usbc-tusb320: Update state on probe
 even if no IRQ pending
Thread-Topic: [PATCH 5.15 456/731] extcon: usbc-tusb320: Update state on probe
 even if no IRQ pending
Thread-Index: AQHZGtDh6LSE0S7PmE687nCpZzoVp66DcQ+A
Date:   Wed, 28 Dec 2022 15:45:02 +0000
Message-ID: <20221228154501.tinymudo2j3kzyii@bang-olufsen.dk>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144309.770876879@linuxfoundation.org>
In-Reply-To: <20221228144309.770876879@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|PA4PR03MB7245:EE_
x-ms-office365-filtering-correlation-id: 3c6b88dc-2fb4-4db2-0d73-08dae8ea7c32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kPBz5ibPpWzZI5ZQiGOrcTIOQGW4GxcACl7gjTXQYk+OkOLoLm0HVJ6HUA3ONxernb8rDoRDHJn+pLMwXAI20+julTRDB5JKZrylAUr+OqLwAncIDVd3pgfLCHKHNHKZppvQ+IGHzLrWobHZOsvqg8Lw0851/Pw/gzVA0DgSF43kZ06BstmToIQiznQWeNggFeacpcQ7wCUCQ+rYFOUJSoXOxq64QHWo+5UnVniXzw0ZuoWbqwn7W1YStKDy/dHZYFOpnxZj8c1N180COMAV8QIv6nCrB/PfMODrhvs2AXQNqP/2LovwVvMoUtJqpbqrP1rDJI/szisCycwCtTdwtTku7r/cWccg65YdYsAeh2gCL7NV09jtpE2oTezZ5kBSN0JO+tPdyGyZQG34z7beiOBPnDf44BKF/cjLD+hg5DKxz5H/dzEcwLuKmTVc0wDAiKkA9fNlcrlHrxBjZ8zbENVkLg9HpDtCXwZMKQG/pjolRirnCVv6UKoWg/MxXxof+v30BnOeTT+2PnaqiW4YVebdBNQy+30wou1uZQqEZgCdhDpOEdPWYr7eJo8hd9pqqe6SVNKk5+UoEMkpuzwICivhauPNxdbnSDJWxfWINuJ8rw4y7pFn1bXYoA1UrlW8pHKGJWJ7uxY4Z3HFYYServpe809VtGudm2QMYtPcDIH9GaSWRWwWYp+gY26MiIHjDZAjChNYm9fnWBdXpDspTcZmcH0rqEa3xeWugNlt0zg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39850400004)(346002)(136003)(376002)(451199015)(91956017)(5660300002)(186003)(6512007)(41300700001)(66556008)(8936002)(64756008)(8676002)(76116006)(66946007)(4326008)(26005)(66446008)(66476007)(8976002)(85182001)(36756003)(110136005)(2906002)(54906003)(478600001)(966005)(71200400001)(6486002)(316002)(85202003)(15650500001)(2616005)(6506007)(1076003)(66574015)(86362001)(83380400001)(38070700005)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjdaR0RKclRQazVXSFFFUVJYcngxQ2FVcFdvMUlRaElTeDF4TlV4T1BndWU3?=
 =?utf-8?B?ZktMU2czejdEZ2p3Mm1tQWFjT3ZGMklqV2RiQzZxd0syUGFIMTlKZk1peFVB?=
 =?utf-8?B?SllyMW5ieVJDNDluVzIzU2RtaW9sVi85Y21LUUVvM1JWVGtIT3k3MnJTdWNw?=
 =?utf-8?B?cnNObThReUppTTVnZVBkRXZHeStTMGdNaWhsdGxDL25EWERySWtwb3RnNUZ6?=
 =?utf-8?B?TjRFTUhPU3FueE52Ym4wR1haNWdOQXFMM2M5WG4vbC9JTVJLNzE1Y3N2M2xy?=
 =?utf-8?B?cWJwbm95MmsxNWIxVkJJTXY5Mm9DdVk3V2NlbEhzY05Uak95QzgxQUVtOGNM?=
 =?utf-8?B?eEMrR3dDTVlBRWFmYTg1a1dlRnordTRoQWxPZW5rdENxdTFlbkJib3JVYU0x?=
 =?utf-8?B?Y3F4enNHT0ZRaHFIZ1d4VlNUVy8zakkwMTZ0eHNRVW92RnBnVG11L0UvcVFS?=
 =?utf-8?B?WVpxOXVFdHBVY3V4U2VVYTB1MFdqWkEySy9lVWFsSHRmY21HMnlhZmY3RDlv?=
 =?utf-8?B?UWd6VXVEcTJweHU4ODJvYVpDZ2tGVlBkVm8xS3RlaEJZUTRXUDdQelJHU2pT?=
 =?utf-8?B?bVFuWEE5QUdLcnJ6dmhJb0FTZVNsZW9McVZhN3RKb25wU21OcXE2a29EREE5?=
 =?utf-8?B?aXJudzdBcWQyOTNNUVhwazIvalQzU3B6NFdNSFAwRG01eWxwV2xqdDNxdExJ?=
 =?utf-8?B?OSs5TFpqb0g0YUR4QXordEJsZ3RNd1RZZ045VUlXTC9TblVaWUJHWm9BSEl5?=
 =?utf-8?B?d2hwQmVMaHlqd0hNMFlRVitjREVKRFdWQzBYdzFEM0YyTEM4dWlqK210Z0JW?=
 =?utf-8?B?Zk5pbWdIQVlvWVZ5MUxDbENVUTZOU1ExU0RGSUw4MTNzQVpTVHJCaEhidWxC?=
 =?utf-8?B?dk9za0xBc1JaWjM2VUxkQ2tOc0drUnpiV2Z0Rk1ucFdxbmtUK3hQbjJMeEho?=
 =?utf-8?B?dHpnRG9WL2hLYTJ3bjFINXNOVDJCdE9XQlFjZmo2OVQ5elBBVWRocTJqU0ht?=
 =?utf-8?B?UnUzS3NEQVUvQ2xoOExwQXU0UHBUOHl5WHZDeFRoVVJRV1g5VWJ3bU1MemhL?=
 =?utf-8?B?eHdibklDYlh1MS9BTTlRcUNhMjJFYnByczlYNFRsVGFReUZOK1lFRklpeGlo?=
 =?utf-8?B?MGZhZnVUMU4xaWU3MUVoOHA2eTZsV0s1V3FGQ1hYVHlEMSt4d3NlK2d1K1VS?=
 =?utf-8?B?N01TbzVIdDJTK2l6VmE2MVEvMldUOGhTcm10UVlzeDZBUWVyODJSZUM0MU9X?=
 =?utf-8?B?ekJIRDFWdEN4cnRwWVRXT09lQnRaOFlQb3RNY1dIV2pVYU93NjlvTmNLR2R6?=
 =?utf-8?B?dU1lbU1MV1lKVHZKSE9ycWdnYUJZL0MxS0xSN21qWWVjRDUzUTlweXYvRVdY?=
 =?utf-8?B?N0ZOWVNrd1Jodis5RTZFd1A1NGJkL2lWU0FXcVVzYk5nWGpwL3VkZ2t0a3Qz?=
 =?utf-8?B?anZtV3V1RFZiYksyU29CWE9sTHdLUGFjR0lWb3hNQzBiRmNUN1hYTzNkc0or?=
 =?utf-8?B?Sm41SjcrUDJMZGtDTm03WGdqS2FjVGdUQWJYUVZnaGRJUHJYVVcrNjB6TTJS?=
 =?utf-8?B?T0lqSkU5VWRicDdXdlNxdEV1NERJTDFZWk14d3J2Y2JRT0ZKZkJteWU2L21T?=
 =?utf-8?B?NWtXeXlRWWxMWUMxZzRzc0Mrb0VuY3pOb3ZsUHJDcnBNQ0ZZdTZJZ3Y4azVa?=
 =?utf-8?B?Y0xpMnVONmJITitFQm1VUFhhK2pBV2FZT3l4NVNrLzNNRUdCOVlxM0tUTzFp?=
 =?utf-8?B?cmlxTFhReFp1S0VTK2drMFlVUGVWSHhmYWFtNGs5cVB4eUFVMXRTTUhBZmhF?=
 =?utf-8?B?WFZRZGdVWmNEd2tIS0ovalVqck94N2R6Q3dPQTBzZ2FoRXZJb3J6clN3UlpW?=
 =?utf-8?B?SHA2elhFT2U1TjdzMnB2aTZYbUc0Y0xKODVSQ2JFK0xrdk1HMTM1WEFseHcy?=
 =?utf-8?B?UGFpWm1DZ0RwVVRleWZuU1F2bUtaNk1HdW5URDJ1YVkyMk1iUGxVOWttUEgv?=
 =?utf-8?B?YW5wajJCWUd4YmlQak54Z3RIalpUZm15RU5uK3JJc0hGcmJ2aGJ4LzFWOXA0?=
 =?utf-8?B?L01tcCsyaitsK2VQLzM3VnhRbUc2cDRFanoxbEpEN1Z1aGpubXY1Y0kvOHUr?=
 =?utf-8?B?N2h0eWNWY3Q1THVoZm90NjA0OHpMSEw2dGk5QVNxaHEzdmVhRm1xQ3pCWEhw?=
 =?utf-8?B?aUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <307EB8E4E507EA41AA267F6EF8548F41@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6b88dc-2fb4-4db2-0d73-08dae8ea7c32
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2022 15:45:02.9680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bpk9AvA4xAHSLLowbn91ykP8v8OsPB2nvZ+tsLuikCZhJBBY+LSKPHuY/nJ3wjX5NdDHa5pFhbEp0/UKBH21/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7245
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCBEZWMgMjgsIDIwMjIgYXQgMDM6Mzk6MjNQTSArMDEwMCwgR3JlZyBLcm9haC1IYXJ0
bWFuIHdyb3RlOg0KPiBGcm9tOiBNYXJlayBWYXN1dCA8bWFyZXhAZGVueC5kZT4NCj4gDQo+IFsg
VXBzdHJlYW0gY29tbWl0IDU4MWM4NDhiNjEwZGJmM2ZlMWVkNGQ4NWZkNTNkMDc0M2M2MWZhYmEg
XQ0KPiANCj4gQ3VycmVudGx5IHRoaXMgZHJpdmVyIHRyaWdnZXJzIGV4dGNvbiBhbmQgdHlwZWMg
c3RhdGUgdXBkYXRlIGluIGl0cw0KPiBwcm9iZSBmdW5jdGlvbiwgdG8gcmVhZCBvdXQgY3VycmVu
dCBzdGF0ZSByZXBvcnRlZCBieSB0aGUgY2hpcCBhbmQNCj4gcmVwb3J0IHRoZSBjb3JyZWN0IHN0
YXRlIHRvIHVwcGVyIGxheWVycy4gVGhpcyBzeW5jaHJvbml6YXRpb24gaXMNCj4gcGVyZm9ybWVk
IGNvcnJlY3RseSwgYnV0IG9ubHkgaW4gY2FzZSB0aGUgY2hpcCBpbmRpY2F0ZXMgYSBwZW5kaW5n
DQo+IGludGVycnVwdCBpbiByZWcwOSByZWdpc3Rlci4NCj4gDQo+IFRoaXMgZmFpbHMgdG8gY292
ZXIgdGhlIHNpdHVhdGlvbiB3aGVyZSBhbGwgaW50ZXJydXB0cyByZXBvcnRlZCBieQ0KPiB0aGUg
Y2hpcCB3ZXJlIGFscmVhZHkgaGFuZGxlZCBieSBMaW51eCBiZWZvcmUgcmVib290LCB0aGVuIHRo
ZSBzeXN0ZW0NCj4gcmVib290ZWQsIGFuZCB0aGVuIExpbnV4IHN0YXJ0cyBhZ2Fpbi4gSW4gdGhp
cyBjYXNlLCB0aGUgVFVTQjMyMCBubw0KPiBsb25nZXIgcmVwb3J0cyBhbnkgaW50ZXJydXB0cyBp
biByZWcwOSwgYW5kIHRoZSBzdGF0ZSB1cGRhdGUgZG9lcyBub3QNCj4gcGVyZm9ybSBhbnkgdXBk
YXRlIGFzIGl0IGRlcGVuZHMgb24gdGhhdCBpbnRlcnJ1cHQgaW5kaWNhdGlvbi4NCj4gDQo+IEZp
eCB0aGlzIGJ5IHR1cm5pbmcgdHVzYjMyMF9pcnFfaGFuZGxlcigpIGludG8gYSB0aGluIHdyYXBw
ZXIgYXJvdW5kDQo+IHR1c2IzMjBfc3RhdGVfdXBkYXRlX2hhbmRsZXIoKSwgd2hlcmUgdGhlIGxh
dGVyIG5vdyBjb250YWlucyB0aGUgYnVsaw0KPiBvZiB0aGUgY29kZSBvZiB0dXNiMzIwX2lycV9o
YW5kbGVyKCksIGJ1dCBhZGRzIG5ldyBmdW5jdGlvbiBwYXJhbWV0ZXINCj4gImZvcmNlX3VwZGF0
ZSIuIFRoZSAiZm9yY2VfdXBkYXRlIiBwYXJhbWV0ZXIgY2FuIGJlIHVzZWQgYnkgdGhlIHByb2Jl
DQo+IGZ1bmN0aW9uIHRvIGFzc3VyZSB0aGF0IHRoZSBzdGF0ZSBzeW5jaHJvbml6YXRpb24gaXMg
YWx3YXlzIHBlcmZvcm1lZCwNCj4gaW5kZXBlbmRlbnQgb2YgdGhlIGludGVycnVwdCBpbmRpY2F0
ZWQgaW4gcmVnMDkuIFRoZSBpbnRlcnJ1cHQgaGFuZGxlcg0KPiB0dXNiMzIwX2lycV9oYW5kbGVy
KCkgY2FsbGJhY2sgdXNlcyBmb3JjZV91cGRhdGU9ZmFsc2UgdG8gYXZvaWQgc3RhdGUNCj4gdXBk
YXRlcyBvbiBwb3RlbnRpYWwgc3B1cmlvdXMgaW50ZXJydXB0cyBhbmQgcmV0YWluIGN1cnJlbnQg
YmVoYXZpb3IuDQo+IA0KPiBGaXhlczogMDZiYzRjYTExNWNkZCAoImV4dGNvbjogQWRkIGRyaXZl
ciBmb3IgVEkgVFVTQjMyMCIpDQo+IFNpZ25lZC1vZmYtYnk6IE1hcmVrIFZhc3V0IDxtYXJleEBk
ZW54LmRlPg0KPiBSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2Vu
LmRrPg0KPiBBY2tlZC1ieTogSGVpa2tpIEtyb2dlcnVzIDxoZWlra2kua3JvZ2VydXNAbGludXgu
aW50ZWwuY29tPg0KPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjIxMTIwMTQx
NTA5LjgxMDEyLTEtbWFyZXhAZGVueC5kZQ0KPiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhh
cnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNo
YSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KDQpJcyB0aGUgRml4ZXM6IHRhZyBo
ZXJlIGFjdHVhbGx5IHdyb25nPyBUaGVyZSB3YXMgYSByZWdyZXNzaW9uIHJlcG9ydCBoZXJlOg0K
DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvZmQwZjJkNTYtNDk1ZS02ZmRkLWQxZTgtZmY0
MGI1NTgxMDFlQGF4ZW50aWEuc2UvDQoNCndoaWNoIHRoaXMgcGF0Y2ggZml4ZWQuIEJ1dCBhY2Nv
cmRpbmcgdG8gdGhlIHJlcG9ydCwgaXQgd2FzIGEgcmVncmVzc2lvbg0KaW50cm9kdWNlZCBieSBN
YXJlaydzIHJlY2VudCBhZGRpdGlvbiBvZiB0eXBlYyBzdXBwb3J0LiBTaW5jZSB0aGF0IG5ldw0K
ZnVuY3Rpb25hbGl0eSBpcyBub3Qgbm9ybWFsbHkgd2FudGVkIGluIHN0YWJsZSwgY2FuIHRoZXNl
IHRocmVlIHR1c2IzMjANCnBhdGNoZXMgc2ltcGx5IGJlIGRyb3BwZWQ/DQoNCk1hcmVrLCBQZXRl
ciwgYW55IHRob3VnaHRzPw0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg0KDQo+ICBkcml2ZXJzL2V4
dGNvbi9leHRjb24tdXNiYy10dXNiMzIwLmMgfCAxNyArKysrKysrKysrKystLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9leHRjb24vZXh0Y29uLXVzYmMtdHVzYjMyMC5jIGIvZHJpdmVycy9l
eHRjb24vZXh0Y29uLXVzYmMtdHVzYjMyMC5jDQo+IGluZGV4IGVkYjhjM2Y5OTdjOS4uYjBmNmUx
NmFiMGE5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2V4dGNvbi9leHRjb24tdXNiYy10dXNiMzIw
LmMNCj4gKysrIGIvZHJpdmVycy9leHRjb24vZXh0Y29uLXVzYmMtdHVzYjMyMC5jDQo+IEBAIC0z
MTMsOSArMzEzLDkgQEAgc3RhdGljIHZvaWQgdHVzYjMyMF90eXBlY19pcnFfaGFuZGxlcihzdHJ1
Y3QgdHVzYjMyMF9wcml2ICpwcml2LCB1OCByZWc5KQ0KPiAgCQl0eXBlY19zZXRfcHdyX29wbW9k
ZShwb3J0LCBUWVBFQ19QV1JfTU9ERV9VU0IpOw0KPiAgfQ0KPiAgDQo+IC1zdGF0aWMgaXJxcmV0
dXJuX3QgdHVzYjMyMF9pcnFfaGFuZGxlcihpbnQgaXJxLCB2b2lkICpkZXZfaWQpDQo+ICtzdGF0
aWMgaXJxcmV0dXJuX3QgdHVzYjMyMF9zdGF0ZV91cGRhdGVfaGFuZGxlcihzdHJ1Y3QgdHVzYjMy
MF9wcml2ICpwcml2LA0KPiArCQkJCQkJYm9vbCBmb3JjZV91cGRhdGUpDQo+ICB7DQo+IC0Jc3Ry
dWN0IHR1c2IzMjBfcHJpdiAqcHJpdiA9IGRldl9pZDsNCj4gIAl1bnNpZ25lZCBpbnQgcmVnOw0K
PiAgDQo+ICAJaWYgKHJlZ21hcF9yZWFkKHByaXYtPnJlZ21hcCwgVFVTQjMyMF9SRUc5LCAmcmVn
KSkgew0KPiBAQCAtMzIzLDcgKzMyMyw3IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCB0dXNiMzIwX2ly
cV9oYW5kbGVyKGludCBpcnEsIHZvaWQgKmRldl9pZCkNCj4gIAkJcmV0dXJuIElSUV9OT05FOw0K
PiAgCX0NCj4gIA0KPiAtCWlmICghKHJlZyAmIFRVU0IzMjBfUkVHOV9JTlRFUlJVUFRfU1RBVFVT
KSkNCj4gKwlpZiAoIWZvcmNlX3VwZGF0ZSAmJiAhKHJlZyAmIFRVU0IzMjBfUkVHOV9JTlRFUlJV
UFRfU1RBVFVTKSkNCj4gIAkJcmV0dXJuIElSUV9OT05FOw0KPiAgDQo+ICAJdHVzYjMyMF9leHRj
b25faXJxX2hhbmRsZXIocHJpdiwgcmVnKTsNCj4gQEAgLTMzNCw2ICszMzQsMTMgQEAgc3RhdGlj
IGlycXJldHVybl90IHR1c2IzMjBfaXJxX2hhbmRsZXIoaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0K
PiAgCXJldHVybiBJUlFfSEFORExFRDsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGlycXJldHVybl90
IHR1c2IzMjBfaXJxX2hhbmRsZXIoaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0KPiArew0KPiArCXN0
cnVjdCB0dXNiMzIwX3ByaXYgKnByaXYgPSBkZXZfaWQ7DQo+ICsNCj4gKwlyZXR1cm4gdHVzYjMy
MF9zdGF0ZV91cGRhdGVfaGFuZGxlcihwcml2LCBmYWxzZSk7DQo+ICt9DQo+ICsNCj4gIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgcmVnbWFwX2NvbmZpZyB0dXNiMzIwX3JlZ21hcF9jb25maWcgPSB7DQo+
ICAJLnJlZ19iaXRzID0gOCwNCj4gIAkudmFsX2JpdHMgPSA4LA0KPiBAQCAtNDYwLDcgKzQ2Nyw3
IEBAIHN0YXRpYyBpbnQgdHVzYjMyMF9wcm9iZShzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50LA0K
PiAgCQlyZXR1cm4gcmV0Ow0KPiAgDQo+ICAJLyogdXBkYXRlIGluaXRpYWwgc3RhdGUgKi8NCj4g
LQl0dXNiMzIwX2lycV9oYW5kbGVyKGNsaWVudC0+aXJxLCBwcml2KTsNCj4gKwl0dXNiMzIwX3N0
YXRlX3VwZGF0ZV9oYW5kbGVyKHByaXYsIHRydWUpOw0KPiAgDQo+ICAJLyogUmVzZXQgY2hpcCB0
byBpdHMgZGVmYXVsdCBzdGF0ZSAqLw0KPiAgCXJldCA9IHR1c2IzMjBfcmVzZXQocHJpdik7DQo+
IEBAIC00NzEsNyArNDc4LDcgQEAgc3RhdGljIGludCB0dXNiMzIwX3Byb2JlKHN0cnVjdCBpMmNf
Y2xpZW50ICpjbGllbnQsDQo+ICAJCSAqIFN0YXRlIGFuZCBwb2xhcml0eSBtaWdodCBjaGFuZ2Ug
YWZ0ZXIgYSByZXNldCwgc28gdXBkYXRlDQo+ICAJCSAqIHRoZW0gYWdhaW4gYW5kIG1ha2Ugc3Vy
ZSB0aGUgaW50ZXJydXB0IHN0YXR1cyBiaXQgaXMgY2xlYXJlZC4NCj4gIAkJICovDQo+IC0JCXR1
c2IzMjBfaXJxX2hhbmRsZXIoY2xpZW50LT5pcnEsIHByaXYpOw0KPiArCQl0dXNiMzIwX3N0YXRl
X3VwZGF0ZV9oYW5kbGVyKHByaXYsIHRydWUpOw0KPiAgDQo+ICAJcmV0ID0gZGV2bV9yZXF1ZXN0
X3RocmVhZGVkX2lycShwcml2LT5kZXYsIGNsaWVudC0+aXJxLCBOVUxMLA0KPiAgCQkJCQl0dXNi
MzIwX2lycV9oYW5kbGVyLA0KPiAtLSANCj4gMi4zNS4xDQo+IA0KPiANCj4=
