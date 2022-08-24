Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5A05A00B8
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 19:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239245AbiHXRv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 13:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238320AbiHXRv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 13:51:27 -0400
Received: from mx0a-0039f301.pphosted.com (mx0a-0039f301.pphosted.com [148.163.133.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCCB186FF;
        Wed, 24 Aug 2022 10:51:26 -0700 (PDT)
Received: from pps.filterd (m0174677.ppops.net [127.0.0.1])
        by mx0a-0039f301.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OE4FHY028505;
        Wed, 24 Aug 2022 17:50:47 GMT
Received: from eur02-ve1-obe.outbound.protection.outlook.com (mail-ve1eur02lp2059.outbound.protection.outlook.com [104.47.6.59])
        by mx0a-0039f301.pphosted.com (PPS) with ESMTPS id 3j5jafj76j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 17:50:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFcw82MWSTnzXyi831dlFU//cr7Day3lJTLWqCdInZnJIJ/azHX6xFX3b7pIMLHOKtKzp1qxE8howkK4jTUD5RfsZIiTGvzT+FT7ktgC9BYp59J6TNUFphLvK2mjExZ1+MlEkduEnWughJ5IBbBUGUw6USGHebXO0orU/Sbobed7gibzBDHKNH1hhj6mLY0JsltTkvD9/7LMvuhWHmGyaytET8ISEjutGMESxx9CisemRD96cNGy/GSJcOhG+c+mKFRZCSqOKVdEHxwHWqJ1sovHcPkTkNhulZtF3moXRBojYBSmBIK71qdhylmKvdV03hHjibZN8S9sa3aYEB11vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LM8kc3a0fmuHvGUBGoYLxN9QFvztpogZ8mFPitAQs/U=;
 b=ik3RoHnLl/Rz0US9u4ALdbDQAJQF5Iqg7Sf9SyN+ZLepj0scXpbG/lwzzmPnXFztA3hvqVs8NAleWLghAG0uxqAvKkbcvPb3vcu1MT5RXW2dT8FJTNVJ6INohVp7Kd7wnezzCIr+il+dkKio6Od0OD9tXzl+cC85/qxO0UQPI92Hrj81k9MMp3YH/QvvLV6OQIsimGGP21/56kSEnMMPbwOJSGT2QT2WN6CvaL0IWAJ+VVff97W+6fYz2BNFkU4D1ZJ1gEKKHRdvYFkogT4AvWrBIIrCcG9TY6+JgJzzaUrRdcLywqZctORJyrmjaJaqolCIlxalcWPJDmnBdicZ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LM8kc3a0fmuHvGUBGoYLxN9QFvztpogZ8mFPitAQs/U=;
 b=n1p2mRKJZU+3TDm5vq4rbL1wyLyLB2KOl0HHRwY7gntgFCAvxC15i9BQapf3kh7sKxAEJoV6p5ISmCP9QuGh0jR/muGFQ61UuuHfjqMhUS4bWuPqx+tu7bM7onTh35uMYjzXvkwJFvvUIe4cPLAbux4kqkOCgehRE0cVfYG92HQo1W3vHGrS2XeDNzQviMJjvYoV2uqoZi8Cx4tqk0EajgL+wPnbrvOFJQgdtDc9qeUDHWlTdFmSzGOhDHR/kvVtPv+UmNZhidvTm7DZR2PKBM7ChhL+7fn7cZdr/eL+L3u1X3/TMkOd4+ZNEuFMt5GEH5vKhiE3bqRYA38EV91Xpg==
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com (2603:10a6:10:ed::15)
 by DB6PR0301MB2455.eurprd03.prod.outlook.com (2603:10a6:4:5a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 17:50:43 +0000
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::f575:76e9:4a40:7387]) by DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::f575:76e9:4a40:7387%2]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 17:50:43 +0000
From:   Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
To:     Juergen Gross <jgross@suse.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Stefano Stabellini <sstabellini@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rustam Subkhankulov <subkhankulov@ispras.ru>
Subject: Re: [PATCH] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Thread-Topic: [PATCH] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Thread-Index: AQHYt8WobNhf1hcK4Em8o6Kwco0uKK2+VHwA
Date:   Wed, 24 Aug 2022 17:50:43 +0000
Message-ID: <ea8e2e7d-cfbd-08a5-7ba3-a51e4e3d3294@epam.com>
References: <20220824142634.20966-1-jgross@suse.com>
In-Reply-To: <20220824142634.20966-1-jgross@suse.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b44ef4fa-1c54-4e0a-b6b4-08da85f92aaa
x-ms-traffictypediagnostic: DB6PR0301MB2455:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MrQf2deX1ZlLXediEgndyWk520xjSCyXgE78RudOyTia3FJea7kJy+Qb4asTfwyY3Xq4IMny+el9NdGeCNWvyC7XFrIr0keDSjcq23b50EXhy90Dpa0KO/GpzAH+E1Pb4AbnoFOGeM1UCUzuNN02kOGiGL+NV1DbRt+7gEaMJ00N/r99nyJtRtucOi7k1umE1gWSJY6DWv3GzxRaLlNKBNlI9EA28gtllvjvfJjjvBy9G1ysUkUd5IDtGbBXAzZqjB8yGsQ/+tAfw/xDoAtZBYrXOZ7QfmAFxdYl31ND4zGTBAaHG82NFT01Iy7rT0Zp4+zisyA6dbGfTOdJDNpqwA4eIPjmYG3yhZVhlH1LObog4cHIhCsE+c5NNSDddKiBlC4yoxgGf6S923h3N7Z5oD6d5zihkNav60IQ1b/G1CEQSqtJAtbyCSgnempg6UftGIJ/+FohbTOzL0I5Ri9e6rIw+o2SuvK52T5L9jXrTJB7QfQU3cx7Fio2Bf9oW13sh0k6SxxSfnTMRsQVBu57tEXXC0LwLpRq/xIixoowURGzHAuE2agzvxs88qdt9CfrSJYfUjFfpWN89tG12lJGi5QfQr6+AKuGOlWJAGDmwWWwQ4+58ZZoCN+zXvfbFEEeSO4rc6oV8JBI+Uo/nxlzc+WW+7UJ25ZNkPiFYLNOnm+RzIrD3t+SQBJChyTJtUBvDc5zqYA3+/Tu3VtMZuJgui+JuJkyTPzRcv0Uq3ZLsl+gUSbzzm9uSdE1S0YVEcEkc5y0Ux5xbElbwuYOuBxmnnFfA0RdPK2wofNMUcsN0w0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR03MB6108.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(91956017)(83380400001)(76116006)(4326008)(66946007)(8676002)(66476007)(66556008)(5660300002)(64756008)(66446008)(38070700005)(2616005)(478600001)(41300700001)(2906002)(6486002)(26005)(71200400001)(186003)(38100700002)(55236004)(54906003)(31686004)(6512007)(31696002)(53546011)(122000001)(110136005)(36756003)(8936002)(316002)(86362001)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0cwMlhVaDdlZHljV2pjOG5YdXNGa3dJTVBsQ2Z4c1M5OW1Rd2VsQXVYNmo1?=
 =?utf-8?B?RFNMajdaU0tDUE13WDlUQmN5SkJuM0dCejFVSUlWd2RiVWllaks5YWtSaExD?=
 =?utf-8?B?bTUzcjhhUTJhYVZVWnlKRjNTMXN3aU9STkY5eGVZdnZZT2NjbkZuTmhuTzNE?=
 =?utf-8?B?dzFhYXR2Um5icUdEaDhJcldxY1Y0NTlYbDNDNUxnMThGYXp0Sld5QWNIYjJ1?=
 =?utf-8?B?d1VwczN4VXlVbVhpRVhWcFVHK1NYaG1pZGQ1cGxUb01rR1I4N1c5TjFCUzN0?=
 =?utf-8?B?Z2ozR0hRbk5NSFdwTUVqTWtmYTRpekpyVG5RcDZXWGh1aWxFTzlGakdCQ21W?=
 =?utf-8?B?LzlsNEZ3aURhcmNKRFhtVkxaMWFJRFlWWk9SOEk5dGpEbEpneGtuVGQ5Y1Bq?=
 =?utf-8?B?Mjlqb1B4YUM4cTFCclVockprb3pqM0VrczNaMy9xQy96QkRuczVXSEtPM0xo?=
 =?utf-8?B?M1NYOGJQbUR0MU83QWY4N2xCU3MrMnd2ODZxU0hpcE5XM3JlT3R1OUs4MGtT?=
 =?utf-8?B?VHZ0MHgvcitKT2VwOVZsUmZWS0ZNQ01vdmEydldNZEJ3amhONUhmMjl3V0VZ?=
 =?utf-8?B?RWRCclU3a3p6NURYWlRGYUdNRGpZeEFYWkpyZTNCMnVISFpXT3hxWCtCRHAx?=
 =?utf-8?B?dDNBbytzOWN0TGk2QjdGUzU2ZnUyZ2NMNW9nZytvd2Q3WVFXYUxmSnFsdGkr?=
 =?utf-8?B?WTF3ZjhoL1h1aUZPYSttS3Q2cHpSUVNHa2JyczA0bzRjZ1FMRlVWRjNnQnAz?=
 =?utf-8?B?a3g3MFR0NkU3MTl6YVhmYkFMbXRLQUlWL2FHbEhWU050a1YzTXJXaDdkZ0xB?=
 =?utf-8?B?QVNOSW9IY1BqNlp4UmpmdDg4OGdrV255Mm5FZnJNdlEyR0lzL21tYkxseUJI?=
 =?utf-8?B?WnY5SnFGOFlwbEVJbjMxbWFERkJ2UC91a1Rhdnd5ZXZjNlZsZnp2emRVNDF1?=
 =?utf-8?B?a3hGOGx0NTVUOG9UWTB0T2NSUEdNRS9abTJuUVRpQlRSK1dlN05keXVqWHBK?=
 =?utf-8?B?b2k1NUJBZDlDV2ZZMXNSanhPbDBpRDAzTHZmT0JTbUNWV05lZTVndVQwcDh0?=
 =?utf-8?B?c0JYelYreUdndWlrZTZIL2g2b1BoQ1RRcm1GVGF6OEk1U1BvclVabWRQNFp1?=
 =?utf-8?B?ckRXSE5XYWk4ejF4Si9GVXV4YVovUkJVRVJ3djBTeHIxY2lSRGxqZU0yQVdq?=
 =?utf-8?B?c3ppV3k0UVRrbGJmYS9RZVo5aGlyMy85STl0QlR5by95ZE1DakVQU3V6SjQ5?=
 =?utf-8?B?RHVpN0dUWnV3OStnSXF5bjJnUDlrSVRpT2JPcG9PcXJwVDFvNU9uTWxrTGV3?=
 =?utf-8?B?K1VjNjkrQkJEVi9zYUg3UTQ1VXV6akVDWG5TbkRPNmV2Q2lDNk5JWHVUNUpv?=
 =?utf-8?B?T2lhb28rcm9adEhLa0twNHpjMVJ0YkRtSWJ6M0dwanJUZTJzSUpEUlZ3TGw4?=
 =?utf-8?B?a09ya1BHa2FZTWlzZ2Rxckp2ek4rTVpOdzZ2Z3NSbkYzRy85MGNJSmc0VWM2?=
 =?utf-8?B?WGtrZTd4Z2l4UWNUZ3BDK1RpQmY1aEN1YWQvOXNEaGx2OWZoaG5GaHBLWjNG?=
 =?utf-8?B?MnFYazRKQ0MweDk1Zk4zU1hFL1ZIMGllVC96K2hIQnlPWU5JbmliSUlsS21p?=
 =?utf-8?B?SXhUeVQyVXpKSjZrNERuOTAvQWlZVFN0R0c5UnJ1Rk1rQUt4Qlc5cVpFbCtU?=
 =?utf-8?B?MjVIZDlxTFNFU0djdmozekdTOUxoaU1HMnJ5M1F6MFhYa1BoUUc3YndMSTF6?=
 =?utf-8?B?OHRFN1VVdCtmd2NpTHZrN1k2RWx3a0lhOXNFdFVBbUVmZFpyTE5QMmxCNGsz?=
 =?utf-8?B?eTladlVab0dCZlZVQzFVTmF2ZjlLTGlwbEdNT0FmWkZFKzJQZWoxaEFXTGd2?=
 =?utf-8?B?dW1pcFVMSkI1dnhqM0REK3BmZmlpYmRiRkZoS3JsVzQvSS9oUkxmRVQ2SG5x?=
 =?utf-8?B?U3RJNzZYVUo4WGpEY1c1TUxyMmwvWmlWclpORTBzZDJaNkwvSmpGK1VjSzhT?=
 =?utf-8?B?clBaeDJtQnJUTEJlc3RpUitWbURPeFExQ0djcmZIOTcrblE0OGRNOUxuWGVQ?=
 =?utf-8?B?QjRlZlQweUtSMHpOZ2h6MGhiNUJ5dDh4YXd6S3FpZ29Lb20yallNYXp5TDU0?=
 =?utf-8?B?c3dkRi9XczVkSEhOaTBtWS83ejVyNzFONDBvTkZCM1VlQXZIMDFvZ3ZuZlRs?=
 =?utf-8?Q?qESbD96I5JqNNoPVhZlZc7E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E741A59A6DF1D24489F3BBDF2A9FA77A@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR03MB6108.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44ef4fa-1c54-4e0a-b6b4-08da85f92aaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 17:50:43.5215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kfJgHuXAgXWc+hZNj2fwR5DWNYdVxyRvEaI6Ruh+6rG7k5VttgMyzkQuLcCbXQ8oqjygAX8IKOnSL2a7jMbLk6gWYkl+VKmf69UOFSK9n5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2455
X-Proofpoint-GUID: kBSriJtv2AQv97Cs2bmXBywe4CnN86_X
X-Proofpoint-ORIG-GUID: kBSriJtv2AQv97Cs2bmXBywe4CnN86_X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_10,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1011
 spamscore=0 priorityscore=1501 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208240065
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiAyNC4wOC4yMiAxNzoyNiwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCg0KSGVsbG8gSnVlcmdl
bg0KDQo+IFRoZSBlcnJvciBleGl0IG9mIHByaXZjbWRfaW9jdGxfZG1fb3AoKSBpcyBjYWxsaW5n
IHVubG9ja19wYWdlcygpDQo+IHBvdGVudGlhbGx5IHdpdGggcGFnZXMgYmVpbmcgTlVMTCwgbGVh
ZGluZyB0byBhIE5VTEwgZGVyZWZlcmVuY2UuDQo+DQo+IEZpeCB0aGF0IGJ5IGNhbGxpbmcgdW5s
b2NrX3BhZ2VzIG9ubHkgaWYgbG9ja19wYWdlcygpIHdhcyBhdCBsZWFzdA0KPiBwYXJ0aWFsbHkg
c3VjY2Vzc2Z1bC4NCj4NCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBGaXhlczog
YWI1MjBiZThjZDVkICgieGVuL3ByaXZjbWQ6IEFkZCBJT0NUTF9QUklWQ01EX0RNX09QIikNCj4g
UmVwb3J0ZWQtYnk6IFJ1c3RhbSBTdWJraGFua3Vsb3YgPHN1YmtoYW5rdWxvdkBpc3ByYXMucnU+
DQo+IFNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCg0KDQpS
ZXZpZXdlZC1ieTogT2xla3NhbmRyIFR5c2hjaGVua28gPG9sZWtzYW5kcl90eXNoY2hlbmtvQGVw
YW0uY29tPg0KDQoNCj4gLS0tDQo+ICAgZHJpdmVycy94ZW4vcHJpdmNtZC5jIHwgNSArKystLQ0K
PiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9wcml2Y21kLmMgYi9kcml2ZXJzL3hlbi9wcml2Y21k
LmMNCj4gaW5kZXggMzM2OTczNDEwOGFmLi5lYzg3OTY4YjQ0NTkgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMveGVuL3ByaXZjbWQuYw0KPiArKysgYi9kcml2ZXJzL3hlbi9wcml2Y21kLmMNCj4gQEAg
LTY3OSw3ICs2NzksNyBAQCBzdGF0aWMgbG9uZyBwcml2Y21kX2lvY3RsX2RtX29wKHN0cnVjdCBm
aWxlICpmaWxlLCB2b2lkIF9fdXNlciAqdWRhdGEpDQo+ICAgCXJjID0gbG9ja19wYWdlcyhrYnVm
cywga2RhdGEubnVtLCBwYWdlcywgbnJfcGFnZXMsICZwaW5uZWQpOw0KPiAgIAlpZiAocmMgPCAw
KSB7DQo+ICAgCQlucl9wYWdlcyA9IHBpbm5lZDsNCj4gLQkJZ290byBvdXQ7DQo+ICsJCWdvdG8g
dW5sb2NrOw0KPiAgIAl9DQo+ICAgDQo+ICAgCWZvciAoaSA9IDA7IGkgPCBrZGF0YS5udW07IGkr
Kykgew0KPiBAQCAtNjkxLDggKzY5MSw5IEBAIHN0YXRpYyBsb25nIHByaXZjbWRfaW9jdGxfZG1f
b3Aoc3RydWN0IGZpbGUgKmZpbGUsIHZvaWQgX191c2VyICp1ZGF0YSkNCj4gICAJcmMgPSBIWVBF
UlZJU09SX2RtX29wKGtkYXRhLmRvbSwga2RhdGEubnVtLCB4YnVmcyk7DQo+ICAgCXhlbl9wcmVl
bXB0aWJsZV9oY2FsbF9lbmQoKTsNCj4gICANCj4gLW91dDoNCj4gKyB1bmxvY2s6DQo+ICAgCXVu
bG9ja19wYWdlcyhwYWdlcywgbnJfcGFnZXMpOw0KPiArIG91dDoNCj4gICAJa2ZyZWUoeGJ1ZnMp
Ow0KPiAgIAlrZnJlZShwYWdlcyk7DQo+ICAgCWtmcmVlKGtidWZzKTsNCg0KLS0gDQpSZWdhcmRz
LA0KDQpPbGVrc2FuZHIgVHlzaGNoZW5rbw0K
