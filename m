Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477C756D413
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 06:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGKEuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 00:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGKEuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 00:50:16 -0400
Received: from mx0b-0039f301.pphosted.com (mx0b-0039f301.pphosted.com [148.163.137.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBCFDEFC;
        Sun, 10 Jul 2022 21:50:14 -0700 (PDT)
Received: from pps.filterd (m0174682.ppops.net [127.0.0.1])
        by mx0b-0039f301.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26AHXGYk020315;
        Sun, 10 Jul 2022 19:19:54 GMT
Received: from eur01-he1-obe.outbound.protection.outlook.com (mail-he1eur01lp2056.outbound.protection.outlook.com [104.47.0.56])
        by mx0b-0039f301.pphosted.com (PPS) with ESMTPS id 3h71kujm83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jul 2022 19:19:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O62gmxvJAV++3UavCd/Jupt+O7UOfvU+3HpGfzgO7ufS4DZNxUuppXmmpqr6fZBpl7H0BGhwukGaW/6wA3hI9Jg36tORJa4BS1UpP0ShLfAbatwrr46Ie2ENnP+pSC32Jc0f+uSZFFmMoCe3jFPuouZizuyvYWshEPpAWizBjXSnmIrlgOJBYqcOvu/ojJFjjDKeK2KPgcCqcON7Jt8OOWqK42hPZ4EcY7OmV2ytwNbxW3PafsgIoVy+yrTe0repYzM2PbkMkSV4qRHomL7/YIlURiTyuzaRfCuwu7tejDaAXtMJjnzgpNKIjCntQs5MTP/dwf5J1U25oS2LRp8VmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZRHvcGm8ElQq6bAO2ejiNRTXZyHpnSAMPmZn0z/G8g=;
 b=iIyfAVfE+a46nMnwvQWJAGGqSwMvHFtkmRRhYUmiLy0/nSLO/qsbaSdVd1xPtfOOY5KxG+uD9SEtL8tlpwFP4/PNmIRQyrx3LE5LM0bRNosnfLYqKjXHbgb8PRZcp66CeHaKwNxcBqNo6kJxQf/tNwNXgNY8+QUDbjAn9j9P2eRWZrJ1GVGrWif0wU2Oz/gngS7EYkTINDHB9GY9WyWwTVVyEbc/Q+6hJb6uk5llYm02i7un5/jQR2rlSl3Ml/6ayMou2btBaHqhe96V4m/Vulry/s5thm+OsNEjLwDpmzQmbcoaiGgdhDeWis2n797743kMYUzzJanLPJss5lNPNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZRHvcGm8ElQq6bAO2ejiNRTXZyHpnSAMPmZn0z/G8g=;
 b=mgyoOWwkVgffpRDOkmRxrIPn8TGa6GLHQE3MOAs7F1L0bisNxNMb7ocHqoYYxv7NAV9HTPx4rTuE9YuUvNGOuqn5twyAo6lHKTUr4kCT2bv5zw0lI4QwEL1WXBHB3bO4KZvCb9tDC5/FaCrwCHrndwkef/l1L37/p8vPkqcQs/JDt238twzl2O2+0Jr/hoRkdt33JhhgWkmHxZA5vbtkOsJqC1lw/tnpF6jLnvM05fIxZHfYG6leYTSGVfMRziZ8+QIdhRYbs0vsjEd0hQcMboEVrDKs34XUVm0/zFcb3tCOc1bIA9MJKG+g+hMnaX79DBT8+GqFeph4+uj/znnhHQ==
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com (2603:10a6:10:ed::15)
 by VI1PR03MB3056.eurprd03.prod.outlook.com (2603:10a6:802:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Sun, 10 Jul
 2022 19:19:50 +0000
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::d87f:d45e:b2c6:c21]) by DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::d87f:d45e:b2c6:c21%6]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 19:19:50 +0000
From:   Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
CC:     Linux kernel regressions <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Xen developer discussion <xen-devel@lists.xenproject.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH master] Ignore failure to unmap INVALID_GRANT_HANDLE
Thread-Topic: [PATCH master] Ignore failure to unmap INVALID_GRANT_HANDLE
Thread-Index: AQHYkulN1X/lWVHlgEmBaIdfsTCb/q13/jiA
Date:   Sun, 10 Jul 2022 19:19:50 +0000
Message-ID: <45234f29-49f9-6089-1c97-7d2c6f29e70f@epam.com>
References: <20220708163750.2005-1-demi@invisiblethingslab.com>
 <20220708163750.2005-8-demi@invisiblethingslab.com>
In-Reply-To: <20220708163750.2005-8-demi@invisiblethingslab.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df3ae64e-eca0-4fa8-3828-08da62a92923
x-ms-traffictypediagnostic: VI1PR03MB3056:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k1M7OkONTM4uebpYw6pW0ctcRzda5PzaU+CcWcxqonNNAYri51FVvfED2WXsjukfwKihz6iXVpLoXaPnDK47KcIiUpyd/IN7wD1uoWm9jKAXihgFeP4SgCjkfkC+b4UgVxzHkpeHsAMXSpIAoS/9z43a+fsOrVFzHNxdmqzPJ7XXkpnOPZmI1HwzL+NouVBAFnM/v6pSXwEL79OjSTDCGOZAO6boegFKbZ+3T29ExMIbrw53pZ0bpLL8Q19PGLh+IWoLROx9v4c4vrl8M/2eeH8zP3A8tAdhq4rStB7vl78uzCkEamVGEE1yZArLZJVrOEeT7dgxbgLk7qSGDYKzMuNPnXHl/X2UHjnQ7urK7YsQPCh+hpZfRSSd95Nq53cMBtn4ooJBgqriInMqBdNvBJ5vLRn5KeWHo4AwoN9rLKCB0hxRxq1/qYK8rQIBM5x0VrYbjA6TMQY8C8SYqMgXDFDMEyi3UOUwvG5Pic080Ic/059A2dOaOxLBi7fJcyVla7k3G4UdhfEIgN2iSBagewgwN6LCxc7xU7nRcP+7mqjpD0927XQSDEJzTCVCl+O0tqqdbLg3kYhbakjVVUMNhF/UPTjsIYv5YDH2IDDIQsTDUrNZIb9yaBqHAPOaMl/BiItiSDf8VhujS55BOodG4TEf1jENCGy2jh1GUpmmxNb7RPCZH3Vp+7vNJw5e3IiOooYgW0GRliOHlReNdwKugQVYxhrpDo5xFxiW9emikSBT1d+SMNqgngNh3k8A7LEch5cO0UhAQNrMXGgNK/Sc2SzpNk/SiQwtVCPwGLAPp6TzNuezCXTSwdYn0xjP5I7ToTOl+A69/32GsGNrVCmXGLGAD3o3fBScrdASDN7CcX0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR03MB6108.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(6916009)(54906003)(8676002)(26005)(66946007)(76116006)(6512007)(71200400001)(64756008)(66476007)(66556008)(66446008)(55236004)(91956017)(31686004)(36756003)(6506007)(53546011)(83380400001)(2906002)(316002)(4326008)(41300700001)(38100700002)(5660300002)(6486002)(31696002)(2616005)(8936002)(38070700005)(478600001)(186003)(86362001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmxwLzIyQUdmUTRHUFZuKzA4aVJUME9Tdzcvc0ZGUSthSWdQUWMyL1B6cHBx?=
 =?utf-8?B?S1dDY0tQZEc3ZmhCMGVpODcxQlBwSG5NajNGelladSt3ZnFZaDJXUWxQbTc3?=
 =?utf-8?B?QVdkNEczWjNzK1B2NGdyK2dKcjRJQTRXRXUzYjJ6R0p3TlR5YlluRUpsQTdW?=
 =?utf-8?B?V25zTUplV0tTbXI0L2dubmY5bjZDWDNNdXZYRVltU0RTM1NCY05UQS9IZFZD?=
 =?utf-8?B?V1dScGJKL3RROHA5SmxVNTEvU1huUktQZlpyU1ZpY0RTV3NRcUFialI5c0N2?=
 =?utf-8?B?SUFQMXlOclN0Ky9ld2hnUlhFQWVpbzBsTUszOHhKTVdscHZFVk5JWnpEV1I1?=
 =?utf-8?B?YUloMGUzeWpCdG0yS0RSUmI5TGNNQmZsWFA3YzZieWxGVDl3ZVQrZmkva3FE?=
 =?utf-8?B?Tyt0Mi8vbTExMG5UVHhoVGlIazQvZkpFV01jaTNWWC84WURaemVJTE5WUlBS?=
 =?utf-8?B?RkN2bkJiR2dyVVdXQ1N4ejdJcmJuTHpQTnZvRHg1dHY1Z0k3dExHWVRaakpC?=
 =?utf-8?B?RUxLTGVwOUdQTEtRdEhSblB5Q013VzF5U05nbzdpWGNBMTMreHUyY3ZFZ3dw?=
 =?utf-8?B?czN5UGw5dk1acUpmRUN2Rll1dzdVekIxZHR6U2lISi9QNVRDVU5DclEzY0xp?=
 =?utf-8?B?b1NGNU44SUM2QkxRd080dW42b3MzZXFjaDN4QVEydFd6QlRFeEtzbFlrQk5Z?=
 =?utf-8?B?QWhnMGNOMUp5dkFwNkltWmtaM01uMmVGUHprcnJKbnRSdW5LaTBCVFBxN2dI?=
 =?utf-8?B?UWdnc0czRUpoRGV6WWFDSzRkN3Bkem9YODRHTk0vYnVKYmZoL0N2b0R6bEFj?=
 =?utf-8?B?S2RlTlN2TXBMUHloRHU4d2J1RklYOHdQRnJjMEhCZENpVnlZR1dqL0owcDdO?=
 =?utf-8?B?b3lBUGFRYmcwcUtsOEU4N3crQ2E3cmFtMU9lUzgyTmIvakI1Q2VRTm9RbVZR?=
 =?utf-8?B?b0xsYXlUQXVuQlZmSEZHYTVmOTJjeUc1K0dqRW5HWFlWMTVFZ3JQcU9uTC81?=
 =?utf-8?B?a0tieGNrOHZvalpGdEZpdm9ocDFHODNWaDRZcWVhTzRObHpRNHRVb1Bwemti?=
 =?utf-8?B?d3pDU0M5RisrZm1OaFBMVU5GdnN3eVY3bkI5MlRKa0NZR2RMYUFqUUd2ZVhS?=
 =?utf-8?B?Q21VQkgwd0FyODRHWjNERlhTWGUwSDVSNURtS29HMlB6eDBoclFvVW1YK3NS?=
 =?utf-8?B?RTU1blZ1WTFHWDMyRU1sb0xiRi9Bc1NaQVlSQW1ubU5oYUs1MjJndXA2N3JM?=
 =?utf-8?B?bGx3cHVtRXVGY0VEWWR5ZWJQTTEvSFErZHRJNVkybzM0ZHhLWWpEcVJteWhO?=
 =?utf-8?B?dWFjcTVXTWQ3VFhCbzhMUnIzSzBXR00xeWlIbDF1UVVuV1ZtbkpIVUdBWWhZ?=
 =?utf-8?B?ZlQ1bGkrZUNTcXNTd1p1Vk1GVEhDL09FSTRmaGVZdXBxSWdyUVljVGhET1Fq?=
 =?utf-8?B?K1pIRU4vYW5BRmI2a0t4aFliNHh1bjFCMThQblNkcWhVT0VYME11SWpvdmJP?=
 =?utf-8?B?MnV6NjRhWGlWdEFVWDJaa2NTcWhEcytsZjVZM0JUaHIwZHZaOVdmNTdjTGRB?=
 =?utf-8?B?THpqamxtd0VOR3NtUmZEQnVaZmVQeWpEMVRUQ29lZWhDbndlSitZR3A0QnBW?=
 =?utf-8?B?QlVBLzRzVHZpSzRlVkhIdzBic1g3QnhYU1F0aW1vd0puOEpTTXkrWXl2Z2VH?=
 =?utf-8?B?U29KVkZQMVNRR094bnphZUZOMmpKYU1aN0NIU1hsUngxWUxjQmN2bThsM2hJ?=
 =?utf-8?B?cGV4VDIwMG9TYm5ST3VENEdJdGtnZ290NE9uWTVuMHVXaGxxZGpQc1ArMkhT?=
 =?utf-8?B?c3lleDdWcU9aYXZjVWd0WXEzYUdQZkpFSm5ZdVp4eE5hR1phQTFwT1BJV3Jl?=
 =?utf-8?B?eFdpcmhsQmY2aFQ5UGVWZkYrZnRWOVBwREZTOFJBVzArTGYyZURrb0lPeVZn?=
 =?utf-8?B?MjVPbnYyU09IdWFoam0vNlJndGFyTUJIMUpxRy9ZdVN5UkszWUJOa2RPbmRs?=
 =?utf-8?B?V2dwMitCR1FpQll0NW9nWGJtWkpMK0plT1RLSXBLRFg5NGRzbEN3NDJUdFFu?=
 =?utf-8?B?bHhaOWpEVjZqd0lYL0FVSkxkV0dVcmk4TURSOFJhdkUwZ2NZL2xBcHViTXFy?=
 =?utf-8?B?RlhuU215QUFzVjZJU3J0ZmZQK2JDaloxM3dDSFJTNE90WkxIRVkvTzFVWDRx?=
 =?utf-8?Q?l4lhrR49EcoY8czvBxda9wI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9312C2F2CEC1544ABC89467FDEFC2068@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR03MB6108.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3ae64e-eca0-4fa8-3828-08da62a92923
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2022 19:19:50.5046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DIXyn2cNOl0vJ8ABxbn0Lb6IkM438nWHYkFTe1DyRXNjhpXF13+SpkcKFU13Do/VjeCke6SH6PYSlehuo6zt4nyLYxYSBitFdSjbC7JAsOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3056
X-Proofpoint-ORIG-GUID: vD8Y23kT6HAateAt--dci38uyPHuKnAk
X-Proofpoint-GUID: vD8Y23kT6HAateAt--dci38uyPHuKnAk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-10_18,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 adultscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 mlxlogscore=856 suspectscore=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207100088
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiAwOC4wNy4yMiAxOTozNywgRGVtaSBNYXJpZSBPYmVub3VyIHdyb3RlOg0KDQpIZWxsbyBE
ZW1pIE1hcmllDQoNCg0KUGxlYXNlIGFkZCBzdWJzeXN0ZW0gdG8gdGhlIGNvbW1pdCBzdWJqZWN0
LCBmb3IgZXhhbXBsZSAieGVuL2dudGRldjoiLg0KDQoNCj4gVGhlIGVycm9yIHBhdGhzIG9mIGdu
dGRldl9tbWFwKCkgY2FuIGNhbGwgdW5tYXBfZ3JhbnRfcGFnZXMoKSBldmVuDQo+IHRob3VnaCBu
b3QgYWxsIG9mIHRoZSBwYWdlcyBoYXZlIGJlZW4gc3VjY2Vzc2Z1bGx5IG1hcHBlZC4gIFRoaXMg
d2lsbA0KPiB0cmlnZ2VyIHRoZSBXQVJOX09OKClzIGluIF9fdW5tYXBfZ3JhbnRfcGFnZXNfZG9u
ZSgpLiAgVGhlIG51bWJlciBvZg0KPiB3YXJuaW5ncyBjYW4gYmUgdmVyeSBsYXJnZTsgSSBoYXZl
IG9ic2VydmVkIHRob3VzYW5kcyBvZiBsaW5lcyBvZg0KPiB3YXJuaW5ncyBpbiB0aGUgc3lzdGVt
ZCBqb3VybmFsLg0KPg0KPiBBdm9pZCB0aGlzIHByb2JsZW0gYnkgb25seSB3YXJuaW5nIG9uIHVu
bWFwcGluZyBmYWlsdXJlIGlmIHRoZSBoYW5kbGUNCj4gYmVpbmcgdW5tYXBwZWQgaXMgbm90IElO
VkFMSURfR1JBTlRfSEFORExFLiAgVGhlIGhhbmRsZSBmaWVsZCBvZiBhbnkNCj4gcGFnZSB0aGF0
IHdhcyBub3Qgc3VjY2Vzc2Z1bGx5IG1hcHBlZCB3aWxsIGJlIElOVkFMSURfR1JBTlRfSEFORExF
LCBzbw0KPiB0aGlzIGNhdGNoZXMgYWxsIGNhc2VzIHdoZXJlIHVubWFwcGluZyBjYW4gbGVnaXRp
bWF0ZWx5IGZhaWwuDQo+DQo+IFN1Z2dlc3RlZC1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBE
ZW1pIE1hcmllIE9iZW5vdXIgPGRlbWlAaW52aXNpYmxldGhpbmdzbGFiLmNvbT4NCj4gRml4ZXM6
IGRiZTk3Y2ZmN2RkOSAoInhlbi9nbnRkZXY6IEF2b2lkIGJsb2NraW5nIGluIHVubWFwX2dyYW50
X3BhZ2VzKCkiKQ0KPiAtLS0NCj4gICBkcml2ZXJzL3hlbi9nbnRkZXYuYyB8IDggKysrKysrLS0N
Cj4gICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPg0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vZ250ZGV2LmMgYi9kcml2ZXJzL3hlbi9nbnRkZXYu
Yw0KPiBpbmRleCA0YjU2YzM5Zjc2NmQ0ZGE2ODU3MGQwOGQ5NjNmNmVmNDBjOGQ5YzM3Li4yMmZj
ZDUwM2Y0YTQ0ODdkMGFlZDE0N2M5NGY0MzI2ODNkYWQ4YzczIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL3hlbi9nbnRkZXYuYw0KPiArKysgYi9kcml2ZXJzL3hlbi9nbnRkZXYuYw0KPiBAQCAtMzk2
LDEzICszOTYsMTcgQEAgc3RhdGljIHZvaWQgX191bm1hcF9ncmFudF9wYWdlc19kb25lKGludCBy
ZXN1bHQsDQo+ICAgCXVuc2lnbmVkIGludCBvZmZzZXQgPSBkYXRhLT51bm1hcF9vcHMgLSBtYXAt
PnVubWFwX29wczsNCj4gICANCj4gICAJZm9yIChpID0gMDsgaSA8IGRhdGEtPmNvdW50OyBpKysp
IHsNCj4gLQkJV0FSTl9PTihtYXAtPnVubWFwX29wc1tvZmZzZXQraV0uc3RhdHVzKTsNCj4gKwkJ
V0FSTl9PTihtYXAtPnVubWFwX29wc1tvZmZzZXQraV0uc3RhdHVzICYmDQo+ICsJCQltYXAtPnVu
bWFwX29wc1tvZmZzZXQraV0uaGFuZGxlICE9DQo+ICsJCQlJTlZBTElEX0dSQU5UX0hBTkRMRSk7
DQoNCg0KTml0OiBXaGlsZSBleHRlbmRpbmcgdGhlIGNoZWNrIEkgd291bGQgY2xhcmlmeSB0aGUg
Zmlyc3QgaGFsZiBvZiBpdDogDQoibWFwLT51bm1hcF9vcHNbb2Zmc2V0K2ldLnN0YXR1cyAhPSBH
TlRTVF9va2F5Ig0KDQoNCj4gICAJCXByX2RlYnVnKCJ1bm1hcCBoYW5kbGU9JWQgc3Q9JWRcbiIs
DQo+ICAgCQkJbWFwLT51bm1hcF9vcHNbb2Zmc2V0K2ldLmhhbmRsZSwNCj4gICAJCQltYXAtPnVu
bWFwX29wc1tvZmZzZXQraV0uc3RhdHVzKTsNCj4gICAJCW1hcC0+dW5tYXBfb3BzW29mZnNldCtp
XS5oYW5kbGUgPSBJTlZBTElEX0dSQU5UX0hBTkRMRTsNCj4gICAJCWlmICh1c2VfcHRlbW9kKSB7
DQo+IC0JCQlXQVJOX09OKG1hcC0+a3VubWFwX29wc1tvZmZzZXQraV0uc3RhdHVzKTsNCj4gKwkJ
CVdBUk5fT04obWFwLT5rdW5tYXBfb3BzW29mZnNldCtpXS5zdGF0dXMgJiYNCj4gKwkJCQltYXAt
Pmt1bm1hcF9vcHNbb2Zmc2V0K2ldLmhhbmRsZSAhPQ0KPiArCQkJCUlOVkFMSURfR1JBTlRfSEFO
RExFKTsNCg0KZGl0dG8NCg0KDQoNCldpdGggdXBkYXRlZCBzdWJqZWN0Og0KDQpSZXZpZXdlZC1i
eTogT2xla3NhbmRyIFR5c2hjaGVua28gPG9sZWtzYW5kcl90eXNoY2hlbmtvQGVwYW0uY29tPg0K
DQoNCj4gICAJCQlwcl9kZWJ1Zygia3VubWFwIGhhbmRsZT0ldSBzdD0lZFxuIiwNCj4gICAJCQkJ
IG1hcC0+a3VubWFwX29wc1tvZmZzZXQraV0uaGFuZGxlLA0KPiAgIAkJCQkgbWFwLT5rdW5tYXBf
b3BzW29mZnNldCtpXS5zdGF0dXMpOw0KDQotLSANClJlZ2FyZHMsDQoNCk9sZWtzYW5kciBUeXNo
Y2hlbmtvDQo=
