Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4656936E0
	for <lists+stable@lfdr.de>; Sun, 12 Feb 2023 11:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjBLKbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Feb 2023 05:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBLKbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Feb 2023 05:31:49 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A050611EA7;
        Sun, 12 Feb 2023 02:31:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fO//JvaZ2YAygeahyCp2+ySiSYdKGPoEJD/9TtCDJcqXs0c7NknZPqlOj5w6Su4AQbHAtDLU6CEWnfnUmjHayVaztw4qpeRepjJKkrth07HWYLqXCb/Hq7kNePrHfONARZeHN8Aff9wwcJIfvwLDp0QQz+ba6x6n5cDkavzbF7KWIvnPAaMkgMrFQBtdbHqmu5q6DfQIOF9gSefwr9CWke+xub+RJ+giGreVEtY7l74V657AT8NxcMM9G7+twYFwmqlSpHPcYvHeMZXqf90v6V5TvL1vvfPyiZ6NeQ4Ggal/Ml3RKxDE1fvoANn14GaBzZ9MPRAClD9T5CW3Y6lhYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFnJEccjE/SNsVbhP5pIeXkTRVfvMv8tMpdLuOsgKJ8=;
 b=gYxxPZDJWmFstJOzDhS05SNXdP30lPoB4gdmqfICiEtmFel3IwoCpf6cr5oo7o+JAXJk+Dx/6ft2XUDM5hqc7DE8v54D1C06ASTqRRd+wIfSJJIO9TiS6kecGa7UBexhCBIpn7uv1PycGXqoadmwgBvEUiy6GkkjW0SC2dY30+rLCxKGAN38uU7zJ/Ihh493m33HCK/tWjdN/+sZTGscppLSCHpBaAfzE/ZljBMVj5lY0RQYq8SVCUxcmzfZY9PNLriSqQD0XaIaX0p5L9YXGRltG6WnDH0jsE8PCIeKrH6QtkWsVPyPMhKBlNhWZl14Z3Gn78/kA2KoUsfN1IlZsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFnJEccjE/SNsVbhP5pIeXkTRVfvMv8tMpdLuOsgKJ8=;
 b=gkgHmvoNKOKSNqugVpASi6nYlMLSoFd8OpMJOmhDr1NT0yQILbKgOURuKhuRb7wJZpK3KWFaB7Ew0Qd6rHYk0Abcc2bz645Emkm0j+2uOvWrvyDDLyIp7otifbuIJ8/SyTHFNX8ErX9MMozLwj+iCBjEdOUVGIU/LSM1jghelKCFAn31lD18Xzjbufei55tJMvqapcDin7DwgOYT5UghdzhEcKMsjQD/2UixF7cO7R9jxAeyCgCLMl6cZyxrAyXd6VNgkMd2lJChTJQ7GmhfLYXt+kC4AfM2z3HC0iSqccVvrPp9SLjRKhSJvL5ODsjY8OyNVK8YMnHLtx538Q9Lsg==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3330.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:28::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 10:31:40 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097%4]) with mapi id 15.20.6086.023; Sun, 12 Feb 2023
 10:31:40 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Sasha Levin <sashal@kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: Patch "powerpc/bpf: Move common helpers into bpf_jit.h" has been
 added to the 5.10-stable tree
Thread-Topic: Patch "powerpc/bpf: Move common helpers into bpf_jit.h" has been
 added to the 5.10-stable tree
Thread-Index: AQHZOjFFkN40MW/cTkyUFBK0pMjzlK7LJgAA
Date:   Sun, 12 Feb 2023 10:31:40 +0000
Message-ID: <c720086f-9b5f-2a44-985b-7225cd2aca63@csgroup.eu>
References: <20230206134520.1652617-1-sashal@kernel.org>
In-Reply-To: <20230206134520.1652617-1-sashal@kernel.org>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MR1P264MB3330:EE_
x-ms-office365-filtering-correlation-id: 35d8d380-b197-4015-2c36-08db0ce453fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PCJGDQz5kiOOZzWz8VEPDlwGbfAZcWaAPVel/xOhdlYBAzcgoyeVXiZ7O3yYIJde+3SwyoN2JcX5N7aL2mMH4OqFYeN8mNlcjGqTb1FC4JTN3usbTb+/9ALGyf8cOwai3kqJJJOXgn557F5df42nARXJPBJSKrITs29NuFIoFifwJN7exwIJGSlYwdmvzxfrt5YLrvoV2NvSmFuvdLmNd6/o/J3um+L7aI/NXvBQAOHu1Db3NHP2ewA832WW/ly+46w6lk1eUFhMg3VlvK+Z/oCQlrMaiBQPJoc9YcO6sBCtNetvlOM8Iv5D67i72VBGhYUXM00fMSlmSpl/zxfcC5PIJlPjkPUn01Fd0d5/vs8SCKDqtY6cI1Gq+fwlNIDzo9BjqhoiOSaUiLCC/7nv+W9tNJDqD1Rhm/WAkqx3VeAfyGJkr32ZhOlDPqFXFteXOp4l2afD3s9PVvOoFvW8qBBk8FXy3PNOy+PtU+m6lCpk9Xxy9JKIzHinASskvJHKwg7fDW0BCrNgnEV4HXAd3QNOIc7gZ8kMTVsE/ACs/YWvjelfJkKluvK3P6SVfMYMJbPYgMfeCsQQ7c9NhJ6k1RvVy2MhRujMHJHT0MddiZs1leozu3g/YPnD4VUPsgwu99fN2P62sDo/oy2XsHflmuWKZrf2N5MTVDywRMvpXje6rC7ITDP4jYdsKrpoQ7ytKCvccok7lX8sY3k12GHzKornILfzgMrLjsCWPnTJ4+lfN7ejbo/gj61WyqJEfl46nO/EjBPdhNN11ejHjCBplCKqErxrO6cBgpBPphYfj+4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39840400004)(366004)(346002)(451199018)(38100700002)(122000001)(71200400001)(2906002)(66574015)(38070700005)(6512007)(186003)(26005)(31696002)(31686004)(6506007)(8676002)(6486002)(86362001)(4326008)(66556008)(66476007)(66446008)(64756008)(66946007)(478600001)(91956017)(76116006)(110136005)(966005)(54906003)(2616005)(316002)(83380400001)(36756003)(7416002)(5660300002)(44832011)(41300700001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1BKc055L005NVVmWTJNbU1wUDV1aXZHcnM5S2ZhNUxLWEpqT0NWTldzZ21F?=
 =?utf-8?B?djV4OXRBS1lPVzBUbmdTcHV3azlVR3MxS1FTMUpzTnhlMytSN2J1TEIzeGIr?=
 =?utf-8?B?bjF1RjMreVpIUnZHcHBzM0p3RVhRdkZ1TWFjSmh5U3laSUVqK2RvTGZhcCtB?=
 =?utf-8?B?TDVjVm5MckxKcUY0Rzdpa1I0WWdKWTJocm84Q1RvS0dWdVF6alJtRXJiamtE?=
 =?utf-8?B?a2xYWnFhc0JaczZzamw0SXVQMk5KcUV3UlpqYzYvcGw0QThpdUtkcXlLMTYr?=
 =?utf-8?B?aGFkaWJBUzBJQ3ZBaUt6cHVjcVBVeHU5SmhteU9YbHJ4ZHg0L3lXM1JJWHhP?=
 =?utf-8?B?Z2hyN3hLQlJRdUFYMG9VRVVnamZNSkRIOXZnQkM1cjZUM0JSV29xM2M4UExO?=
 =?utf-8?B?SmRScUJRekJjZVR5SEQ0N1p5azlRK2pncjE5emxKaXpPVUY4K0ZCbzVDdTk1?=
 =?utf-8?B?cUd3blRUcXMxTEo0M0RqTk1JTWsxLzdFaUZrbnVpWHVjckNNTkszRTVLeENm?=
 =?utf-8?B?K1d6Q3Iwa3dCREg1dWRNY2FEcUswOXJJUk1iV0JLbE8vSTVBZzlZN3pYR1RG?=
 =?utf-8?B?eG8yZlFpOWV3OG12YzJGUWllSWJ6OHJDZ1h2S1lhdzNxdkF6RTdkVFJmN3dU?=
 =?utf-8?B?L1JvWlNvbHhuVDYwVmcxbkZteko2ME5sNHVyT2doVWg1VTZkVUZtSFdlTC9o?=
 =?utf-8?B?NEpiZjI3amRjVElvVzBEU2lObUtPWWRMQ2Nodk43bDhJYkJEY2c4aitXREJB?=
 =?utf-8?B?cFpZVnJpQnJSZzRpc1VRUzlWYkl6eGpkampWUExrNEhhWnR0a3ErSTRSb0M2?=
 =?utf-8?B?OUdMRHkzMkFBSWMvS05WTG56cnVSZ3Q1dC9lS1pSbnFKVCtqUTZjNnpjNVVx?=
 =?utf-8?B?Y2xkbUZlMnk5OEc4eWpGcEhzR1p4OG9zbzUrdXcxSDhiV0FLR0ZDRzdzd21M?=
 =?utf-8?B?QndPcUFPNFlmdGFUYUpLUDhqRFAvL1ZHYzdPVEY3bzZUcVkzd2JBZDF2SnEy?=
 =?utf-8?B?OUNOTWdpd1hGTlhCOUtpaEdDSkMxSDVNenUzZE5wcnBiU0d1OVU4d0tDaW1s?=
 =?utf-8?B?c1R5MnBxMGtCcmtndjQrS0hOc2Y2VjZ2N1IzaGlnOHJnQk5OSEx1a0hBTHBV?=
 =?utf-8?B?elNZU2k1dWcxQ0xTdHo2VFdqdnFIOFNqZ3dkSXZBMHIwRWc1QWM2V29LdGgv?=
 =?utf-8?B?MGFzdTczM0xyY09pelVtQTBRYWlQVSsrcXlpUG53ekxkUEVTb0hua0xmbjFj?=
 =?utf-8?B?T3pyTm9NVVRURjhvYXZUZnR1MTAvRFA2a2xudWZtZ3FZVTZjNHFLNWJvazRT?=
 =?utf-8?B?MzMvZFd3cVYxTkFJTCtXQnd4V1RqZ3ZvUGQ1OXdORE5FNVNoZ3dEeHZvV1Br?=
 =?utf-8?B?VkVqSWNlcWkwajk3eno4SW9QMXFtMEZRcFBML1RCcm9BblZXZXk4c0VLd3lV?=
 =?utf-8?B?UTNKempiY1J0c0lUeXdRYXo4alhuUy9GY041c3h0d3lHd0g1YS9UR3JWK3Bn?=
 =?utf-8?B?alNTRC9lZVk5WGRUU0t5SnNpTktUSDZBQjEvOVBOK1luV01rRXVLL1dIaGpL?=
 =?utf-8?B?aGJXSmJOWEhsNWR6dTRhcU9tSVpaMjA1YzVLclVZQjk2a2VxaHU1WmpRRUhu?=
 =?utf-8?B?TG9sd2Z5REl0WW5qNGxqNytVUjlCczBZT0Fuak90aW11R1B4Yjhmd0Nod2N1?=
 =?utf-8?B?K2ZwU0RPYXBhMndaZFRiRzUrS2k0dEcraGxGZ1lJU3RnK21ua2dNTk1yQ0Iv?=
 =?utf-8?B?T0VsbG11bTR6S240RHlZZjJXUkhJK21ieVpickdLTGJzcUhzakZaWmZSOFlZ?=
 =?utf-8?B?UjZJRzRCSldITnIwUFRtNEVyZlAvdGlOSEppQUZOdXBEN3dGK3l2SWhUN2xk?=
 =?utf-8?B?eHdlU3hoS1JtUzVsY29JK0RONlRFZWkyUWZRVTRTcVdhbHR5TVdjQVhYSG5S?=
 =?utf-8?B?NVhLWWtzcVY4WnZTNW9qZytUMjZOTnBidlVjWGxpSVEvL005YWxERHVmdnNR?=
 =?utf-8?B?bzhiM0pHSTkwYzM4Und2aEVPTjc4Q0JrSWJrWHhQQUg3NWVwRVJzS2lVblp0?=
 =?utf-8?B?eXpQdGxsak5TekZkdnJubnZCRy9MR0dPbkpEdlpMMmNoRWVRb2dzUW91OVBr?=
 =?utf-8?B?ZUNCN2JkeDdpYnZSbDdTeUFtbVR1d2w0ZmY5OFU3d0FFNkxLZEVWSXB2WUlG?=
 =?utf-8?B?bkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CCA93C16F9A4C4FB7639DD59C3D91B6@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d8d380-b197-4015-2c36-08db0ce453fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2023 10:31:40.3922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gid3aKhpCQa3Wamn5145kVihxBjPdCgPnExB2QvBebM9Wur5VZmRwdtnIZd39fV2L0vGg41aHJlhWBljNNOSL7TpezNfXA94VVFXAOP2wsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3330
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDA2LzAyLzIwMjMgw6AgMTQ6NDUsIFNhc2hhIExldmluIGEgw6ljcml0wqA6DQo+IFRo
aXMgaXMgYSBub3RlIHRvIGxldCB5b3Uga25vdyB0aGF0IEkndmUganVzdCBhZGRlZCB0aGUgcGF0
Y2ggdGl0bGVkDQo+IA0KPiAgICAgIHBvd2VycGMvYnBmOiBNb3ZlIGNvbW1vbiBoZWxwZXJzIGlu
dG8gYnBmX2ppdC5oDQo+IA0KPiB0byB0aGUgNS4xMC1zdGFibGUgdHJlZSB3aGljaCBjYW4gYmUg
Zm91bmQgYXQ6DQo+ICAgICAgaHR0cDovL3d3dy5rZXJuZWwub3JnL2dpdC8/cD1saW51eC9rZXJu
ZWwvZ2l0L3N0YWJsZS9zdGFibGUtcXVldWUuZ2l0O2E9c3VtbWFyeQ0KPiANCj4gVGhlIGZpbGVu
YW1lIG9mIHRoZSBwYXRjaCBpczoNCj4gICAgICAgcG93ZXJwYy1icGYtbW92ZS1jb21tb24taGVs
cGVycy1pbnRvLWJwZl9qaXQuaC5wYXRjaA0KPiBhbmQgaXQgY2FuIGJlIGZvdW5kIGluIHRoZSBx
dWV1ZS01LjEwIHN1YmRpcmVjdG9yeS4NCj4gDQo+IElmIHlvdSwgb3IgYW55b25lIGVsc2UsIGZl
ZWxzIGl0IHNob3VsZCBub3QgYmUgYWRkZWQgdG8gdGhlIHN0YWJsZSB0cmVlLA0KPiBwbGVhc2Ug
bGV0IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiBrbm93IGFib3V0IGl0Lg0KPiANCg0KVGhpcyBj
b21taXQgd2FzIHBhcnQgb2YgYSBzZXJpZXMgdGhhdCByZW1vdmVkIGNsYXNzaWNhbCBCUEYgYW5k
IA0KaW1wbGVtZW50ZWQgRUJQRiBvbiBwb3dlcnBjMzIuDQoNCkF0IHRoYXQgdGltZSBQUEM2NCBh
bHJlYWR5IGhhZCBFQlBGLg0KDQpUaGlzIGNvbW1pdCBpcyB0byBtYWtlIHNvbWUgcGFydHMgb2Yg
dGhlIGNvZGUgY29tbW9uIGZvciBQUEMzMiBhbmQgUFBDNjQgDQpiZWNhdXNlIGF0IHRoZSBlbmQg
b2YgdGhlIHNlcmllcyBib3RoIGFyZSBFQlBGLg0KDQpCdXQgSSBkb3VidCB0aGlzIGNvbW1pdCBh
bG9uZSBjYW4gYmUgYXBwbGllZCB3aXRob3V0IGZpcnN0IHJlbW92aW5nIA0KY2xhc3NpY2FsIEJQ
RiAoY29tbWl0IDY5NDRjYWFkNzhmYyAoInBvd2VycGMvYnBmOiBSZW1vdmUgY2xhc3NpY2FsIEJQ
RiANCnN1cHBvcnQgZm9yIFBQQzMyIikpDQoNCkNocmlzdG9waGUNCg0KPiANCj4gDQo+IGNvbW1p
dCA3NmY3NGU2OWVmYjk1ZTRhZGQ4MmU1YjY4N2UwNjJmMmM5ODk3MzlmDQo+IEF1dGhvcjogQ2hy
aXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1Pg0KPiBEYXRlOiAgIE1v
biBNYXIgMjIgMTY6Mzc6NDggMjAyMSArMDAwMA0KPiANCj4gICAgICBwb3dlcnBjL2JwZjogTW92
ZSBjb21tb24gaGVscGVycyBpbnRvIGJwZl9qaXQuaA0KPiAgICAgIA0KPiAgICAgIFsgVXBzdHJl
YW0gY29tbWl0IGYxYjE1ODNkNWZhYTg2Y2IzZGNiN2I3NDA1OTQ4NjhkZWJhZDdjMzAgXQ0KPiAg
ICAgIA0KPiAgICAgIE1vdmUgZnVuY3Rpb25zIGJwZl9mbHVzaF9pY2FjaGUoKSwgYnBmX2lzX3Nl
ZW5fcmVnaXN0ZXIoKSBhbmQNCj4gICAgICBicGZfc2V0X3NlZW5fcmVnaXN0ZXIoKSBpbiBvcmRl
ciB0byByZXVzZSB0aGVtIGluIGZ1dHVyZQ0KPiAgICAgIGJwZl9qaXRfY29tcDMyLmMNCj4gICAg
ICANCj4gICAgICBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxl
cm95QGNzZ3JvdXAuZXU+DQo+ICAgICAgU2lnbmVkLW9mZi1ieTogTWljaGFlbCBFbGxlcm1hbiA8
bXBlQGVsbGVybWFuLmlkLmF1Pg0KPiAgICAgIExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L3IvMjhlOGQ1YTc1ZTY0ODA3ZDdlOWQzOWE0YjUyNjU4NzU1ZTI1OWY4Yy4xNjE2NDMwOTkxLmdp
dC5jaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXUNCj4gICAgICBTdGFibGUtZGVwLW9mOiA3MWY2
NTZhNTAxNzYgKCJicGY6IEZpeCB0byBwcmVzZXJ2ZSByZWcgcGFyZW50L2xpdmUgZmllbGRzIHdo
ZW4gY29weWluZyByYW5nZSBpbmZvIikNCj4gICAgICBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZp
biA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL25l
dC9icGZfaml0LmggYi9hcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXQuaA0KPiBpbmRleCAxYTViNGRh
OGEyMzUuLmNkOWFhYjZlYzJjNSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL25ldC9icGZf
aml0LmgNCj4gKysrIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0LmgNCj4gQEAgLTExNyw2ICsx
MTcsNDEgQEANCj4gICAjZGVmaW5lIENPTkRfTFQJCShDUjBfTFQgfCBDT05EX0NNUF9UUlVFKQ0K
PiAgICNkZWZpbmUgQ09ORF9MRQkJKENSMF9HVCB8IENPTkRfQ01QX0ZBTFNFKQ0KPiAgIA0KPiAr
I2RlZmluZSBTRUVOX0ZVTkMJMHgxMDAwIC8qIG1pZ2h0IGNhbGwgZXh0ZXJuYWwgaGVscGVycyAq
Lw0KPiArI2RlZmluZSBTRUVOX1NUQUNLCTB4MjAwMCAvKiB1c2VzIEJQRiBzdGFjayAqLw0KPiAr
I2RlZmluZSBTRUVOX1RBSUxDQUxMCTB4NDAwMCAvKiB1c2VzIHRhaWwgY2FsbHMgKi8NCj4gKw0K
PiArc3RydWN0IGNvZGVnZW5fY29udGV4dCB7DQo+ICsJLyoNCj4gKwkgKiBUaGlzIGlzIHVzZWQg
dG8gdHJhY2sgcmVnaXN0ZXIgdXNhZ2UgYXMgd2VsbA0KPiArCSAqIGFzIGNhbGxzIHRvIGV4dGVy
bmFsIGhlbHBlcnMuDQo+ICsJICogLSByZWdpc3RlciB1c2FnZSBpcyB0cmFja2VkIHdpdGggY29y
cmVzcG9uZGluZw0KPiArCSAqICAgYml0cyAocjMtcjEwIGFuZCByMjctcjMxKQ0KPiArCSAqIC0g
cmVzdCBvZiB0aGUgYml0cyBjYW4gYmUgdXNlZCB0byB0cmFjayBvdGhlcg0KPiArCSAqICAgdGhp
bmdzIC0tIGZvciBub3csIHdlIHVzZSBiaXRzIDE2IHRvIDIzDQo+ICsJICogICBlbmNvZGVkIGlu
IFNFRU5fKiBtYWNyb3MgYWJvdmUNCj4gKwkgKi8NCj4gKwl1bnNpZ25lZCBpbnQgc2VlbjsNCj4g
Kwl1bnNpZ25lZCBpbnQgaWR4Ow0KPiArCXVuc2lnbmVkIGludCBzdGFja19zaXplOw0KPiArfTsN
Cj4gKw0KPiArc3RhdGljIGlubGluZSB2b2lkIGJwZl9mbHVzaF9pY2FjaGUodm9pZCAqc3RhcnQs
IHZvaWQgKmVuZCkNCj4gK3sNCj4gKwlzbXBfd21iKCk7CS8qIHNtcCB3cml0ZSBiYXJyaWVyICov
DQo+ICsJZmx1c2hfaWNhY2hlX3JhbmdlKCh1bnNpZ25lZCBsb25nKXN0YXJ0LCAodW5zaWduZWQg
bG9uZyllbmQpOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wgYnBmX2lzX3NlZW5f
cmVnaXN0ZXIoc3RydWN0IGNvZGVnZW5fY29udGV4dCAqY3R4LCBpbnQgaSkNCj4gK3sNCj4gKwly
ZXR1cm4gY3R4LT5zZWVuICYgKDEgPDwgKDMxIC0gaSkpOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMg
aW5saW5lIHZvaWQgYnBmX3NldF9zZWVuX3JlZ2lzdGVyKHN0cnVjdCBjb2RlZ2VuX2NvbnRleHQg
KmN0eCwgaW50IGkpDQo+ICt7DQo+ICsJY3R4LT5zZWVuIHw9IDEgPDwgKDMxIC0gaSk7DQo+ICt9
DQo+ICsNCj4gICAjZW5kaWYNCj4gICANCj4gICAjZW5kaWYNCj4gZGlmZiAtLWdpdCBhL2FyY2gv
cG93ZXJwYy9uZXQvYnBmX2ppdDY0LmggYi9hcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXQ2NC5oDQo+
IGluZGV4IDRkMTY0ZTg2NWIzOS4uMjAxYjgzYmZhODY5IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bv
d2VycGMvbmV0L2JwZl9qaXQ2NC5oDQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9uZXQvYnBmX2ppdDY0
LmgNCj4gQEAgLTg2LDI1ICs4Niw2IEBAIHN0YXRpYyBjb25zdCBpbnQgYjJwW10gPSB7DQo+ICAg
CQkJCX0gd2hpbGUoMCkNCj4gICAjZGVmaW5lIFBQQ19CUEZfU1RMVShyLCBiYXNlLCBpKSBkbyB7
IEVNSVQoUFBDX1JBV19TVERVKHIsIGJhc2UsIGkpKTsgfSB3aGlsZSgwKQ0KPiAgIA0KPiAtI2Rl
ZmluZSBTRUVOX0ZVTkMJMHgxMDAwIC8qIG1pZ2h0IGNhbGwgZXh0ZXJuYWwgaGVscGVycyAqLw0K
PiAtI2RlZmluZSBTRUVOX1NUQUNLCTB4MjAwMCAvKiB1c2VzIEJQRiBzdGFjayAqLw0KPiAtI2Rl
ZmluZSBTRUVOX1RBSUxDQUxMCTB4NDAwMCAvKiB1c2VzIHRhaWwgY2FsbHMgKi8NCj4gLQ0KPiAt
c3RydWN0IGNvZGVnZW5fY29udGV4dCB7DQo+IC0JLyoNCj4gLQkgKiBUaGlzIGlzIHVzZWQgdG8g
dHJhY2sgcmVnaXN0ZXIgdXNhZ2UgYXMgd2VsbA0KPiAtCSAqIGFzIGNhbGxzIHRvIGV4dGVybmFs
IGhlbHBlcnMuDQo+IC0JICogLSByZWdpc3RlciB1c2FnZSBpcyB0cmFja2VkIHdpdGggY29ycmVz
cG9uZGluZw0KPiAtCSAqICAgYml0cyAocjMtcjEwIGFuZCByMjctcjMxKQ0KPiAtCSAqIC0gcmVz
dCBvZiB0aGUgYml0cyBjYW4gYmUgdXNlZCB0byB0cmFjayBvdGhlcg0KPiAtCSAqICAgdGhpbmdz
IC0tIGZvciBub3csIHdlIHVzZSBiaXRzIDE2IHRvIDIzDQo+IC0JICogICBlbmNvZGVkIGluIFNF
RU5fKiBtYWNyb3MgYWJvdmUNCj4gLQkgKi8NCj4gLQl1bnNpZ25lZCBpbnQgc2VlbjsNCj4gLQl1
bnNpZ25lZCBpbnQgaWR4Ow0KPiAtCXVuc2lnbmVkIGludCBzdGFja19zaXplOw0KPiAtfTsNCj4g
LQ0KPiAgICNlbmRpZiAvKiAhX19BU1NFTUJMWV9fICovDQo+ICAgDQo+ICAgI2VuZGlmDQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDY0LmMgYi9hcmNoL3Bvd2Vy
cGMvbmV0L2JwZl9qaXRfY29tcDY0LmMNCj4gaW5kZXggN2RhNTlkZGM5MGRkLi5lYmFkMmM3OWNk
NmYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcG93ZXJwYy9uZXQvYnBmX2ppdF9jb21wNjQuYw0KPiAr
KysgYi9hcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDY0LmMNCj4gQEAgLTI0LDIyICsyNCw2
IEBAIHN0YXRpYyB2b2lkIGJwZl9qaXRfZmlsbF9pbGxfaW5zbnModm9pZCAqYXJlYSwgdW5zaWdu
ZWQgaW50IHNpemUpDQo+ICAgCW1lbXNldDMyKGFyZWEsIEJSRUFLUE9JTlRfSU5TVFJVQ1RJT04s
IHNpemUvNCk7DQo+ICAgfQ0KPiAgIA0KPiAtc3RhdGljIGlubGluZSB2b2lkIGJwZl9mbHVzaF9p
Y2FjaGUodm9pZCAqc3RhcnQsIHZvaWQgKmVuZCkNCj4gLXsNCj4gLQlzbXBfd21iKCk7DQo+IC0J
Zmx1c2hfaWNhY2hlX3JhbmdlKCh1bnNpZ25lZCBsb25nKXN0YXJ0LCAodW5zaWduZWQgbG9uZyll
bmQpOw0KPiAtfQ0KPiAtDQo+IC1zdGF0aWMgaW5saW5lIGJvb2wgYnBmX2lzX3NlZW5fcmVnaXN0
ZXIoc3RydWN0IGNvZGVnZW5fY29udGV4dCAqY3R4LCBpbnQgaSkNCj4gLXsNCj4gLQlyZXR1cm4g
Y3R4LT5zZWVuICYgKDEgPDwgKDMxIC0gaSkpOw0KPiAtfQ0KPiAtDQo+IC1zdGF0aWMgaW5saW5l
IHZvaWQgYnBmX3NldF9zZWVuX3JlZ2lzdGVyKHN0cnVjdCBjb2RlZ2VuX2NvbnRleHQgKmN0eCwg
aW50IGkpDQo+IC17DQo+IC0JY3R4LT5zZWVuIHw9IDEgPDwgKDMxIC0gaSk7DQo+IC19DQo+IC0N
Cj4gICBzdGF0aWMgaW5saW5lIGJvb2wgYnBmX2hhc19zdGFja19mcmFtZShzdHJ1Y3QgY29kZWdl
bl9jb250ZXh0ICpjdHgpDQo+ICAgew0KPiAgIAkvKg0K
