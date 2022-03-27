Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55694E8B0D
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 01:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiC0XdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 19:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiC0XdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 19:33:03 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2123.outbound.protection.outlook.com [40.107.114.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F22E013;
        Sun, 27 Mar 2022 16:31:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPbiHxtEH4/nZxWVBmZa9rNLTOJ+KsX3YzD2daZBx4HozehSlTOC+JSJ+1ruyFWy4JVoIK9Xxrxtuo1opFTQrgnP0NxtNKw4VAjhOef712iOyV043/MFpbLTKHV2xOWwBknWvENpT8ZjPHY5813e6RgqYMqoFdI123cpHDSgYNCpmOyGf12A6miezA96+6ljpgto2FxxS7WncfiEl3X8DPG1r+XUkf4aMPNvikwcxmNnvM3ljk8hhC3KDHHT3vMPeUZF0GSg9B2DEw/eX51yWpgjlGZfTnqECTSbh3McdwUExfHPX0KPbyl/FhwHQuN8s8+TcRCR4JPdqwDcO4CDuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpj45STB8F1p8FOOT3uc0gmO7jmhCdW/r9gjbejm0J0=;
 b=kR/WIUy+8ocULERB3D18nq6mMsKTWce3GRqGc6PA6pCJVck7IQ78Tv8QnV+DwJCQc8VUpLX+9U6+Vt6mzGIom+DBW4QGwTmJJEYj405Mv7gYXXwwzIgcKFWTDxX5zEWrWKKRUgv8DgScR1UKiDgQwMGzZc1cG0iKZIfwlZlLVn1Zzxkedb0lH6y7XiwVVkGrAicqYkQiypjha5ToJypb6O3zLaScCx2PPIO0SWO7cE+hS32Gs2BqNPR/LetcLNm14Bk/i8E1+bOP0evR1bsYFRAnXzlXYOfapoHOkErs5CpGlmCL4paz5LoWGc3I3nooFhcU9b+6FHzObBUoKSS6HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpj45STB8F1p8FOOT3uc0gmO7jmhCdW/r9gjbejm0J0=;
 b=cVgg+pbhDRv2B9PcEHrb0lCUpJ82N3z3HYUurYDHxO/YFXAQe687wDvuYdzceSEj3G1Q6IvKRLtwwStzqsfJH9THhMgARENLFhoTNSHj752k/60LrHo+iRj/Hzu0QxYBtF2xvWJc5ylqBwQAcZJ2/MwPEY/adCuzdf10naFpLvs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com (2603:1096:604:194::10)
 by TYAPR01MB3504.jpnprd01.prod.outlook.com (2603:1096:404:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Sun, 27 Mar
 2022 23:31:19 +0000
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::7c4e:286f:81:97ac]) by OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::7c4e:286f:81:97ac%3]) with mapi id 15.20.5102.022; Sun, 27 Mar 2022
 23:31:19 +0000
Message-ID: <87zglbug5a.wl-kuninori.morimoto.gx@renesas.com>
From:   Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] soc: soc-core: fix a missing check on list iterator
In-Reply-To: <20220327082018.13585-1-xiam0nd.tong@gmail.com>
References: <20220327082018.13585-1-xiam0nd.tong@gmail.com>
User-Agent: Wanderlust/2.15.9 Emacs/26.3 Mule/6.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 27 Mar 2022 23:31:19 +0000
X-ClientProxiedBy: TY2PR06CA0030.apcprd06.prod.outlook.com
 (2603:1096:404:2e::18) To OS3PR01MB8426.jpnprd01.prod.outlook.com
 (2603:1096:604:194::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14bb61a4-bbdf-4a14-afde-08da1049e577
X-MS-TrafficTypeDiagnostic: TYAPR01MB3504:EE_
X-Microsoft-Antispam-PRVS: <TYAPR01MB35046513F2AC0F70C6DAD4ABD41C9@TYAPR01MB3504.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETn7Uyg6AUnrY0Gns/Boxzhi5P9jQBrgrxkdC8x+WUCEOEqJhfQvsYoTKVyW70VRDHuKNhMTfmuzO635Nj7TyYA3MsKbW2u7q1H4/DqnE9tCijcFDe8I7ePvTlMjBD2Fe7+ZxmWXw1M4vKAhdrWvFeaf7Q25BCB4zo0z6sn2QnbPhx/9rdHpVJUkILjqvIFFRH2tOagrfbnz+yyB6CEj/yD3S87NmCpM9X+DGCABaJp3CdqLmvzjqMYYaUN0NISZxvCawR/j+Vuu1lHSRJFNAU3eBSaJto6aqkIGG4SyDmbeI2NSdMSElWDkvXoLexr7AMNvCuUMN6LT0qNIAY8FruugAy6oS74Lb6yHBM3+t+YwFm7KTIo43VTjA+NM6B/rF7R0h0AhjgMaFjBaLxyEeQ9pk3tj/TkDNOzrsIMXGZLcoZGANvIZ6VD721Itctz+ceK2uUo6JqLt7APJTNVIp8gMnPGa6C7aIWJl/ZQ3dg9l/1qn+qkX8FxpRvrhz83DNWQlPyaNRD5QnDNPrRFxsxTHRSH0n+Nz17OX1qS31UK9xBCiR8WWE/tlkwhZePl0Vrs24gxsXvb7eHuM3PhEEiIX5epmcS2NmEn9MkNkknIXROFhwN+wW/cxbtI6XQhezArh53sshaMf5kf11zNJ3Xj4su9tCrhgYqnhPw81gEuZU8+y1ABqw7kPpgzmsaJK4yGYQmYUJxopKDtWqoEhkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8426.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(52116002)(38100700002)(86362001)(36756003)(508600001)(5660300002)(6512007)(66476007)(66556008)(6486002)(66946007)(8936002)(186003)(316002)(6916009)(83380400001)(4326008)(2616005)(8676002)(2906002)(6506007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qbccVzSKF6m+krmvqA28s4ynlRjPHhFXQcCQfgsgVR2hMPsLFlFp567gJ3F6?=
 =?us-ascii?Q?2kGtTekYu1ovM0wpWSGhZ8q8clJjvp6qmF2HMhqXAfqqrn9pTDhUwxbBYnfT?=
 =?us-ascii?Q?LMrPtg8anYDwt1QBDZ+7yUG3c/B0U8XKGZCjULAtlHlvp1qIZ/ihA6Stpe3z?=
 =?us-ascii?Q?zoaxKvRwp8V+oGeICZPgXmh/wSVVZoa4XXfH0vp+hMh053PPM6tpLw9F+DUT?=
 =?us-ascii?Q?wWc6GyVUmRL/OhUKNwXzdJpdm2vf5iju0X+w/Xe0OScq0JPTO3Nabi9zEd9u?=
 =?us-ascii?Q?pcBQC14jNJ4ufa4kQH158IMiRMoibUxZ04+f/UtF+g7AkV33H3UaqtT8Y/jq?=
 =?us-ascii?Q?HWQRg5vegr5gBdckMFPnz2Ka2bNoKv5xqUDrcLL5/d5jEWTGEIKCUwRQ1sZV?=
 =?us-ascii?Q?IWAALy3xOoXs08FfFg5DywK+HnI7NA07BWuOHWRC7O+Fwem2fyX5MHnQgAwE?=
 =?us-ascii?Q?hQszDXwj9aiiSgx7khDuG0qqy3z3w0RI2NiMxJgy00++MyIlMoTs3dU40nM+?=
 =?us-ascii?Q?ul/YSxOQJSFrE+cx1DSPG+8uNOJTFdeJpnWJdL0tUlRBmBSIWpw4f2DRB6Ek?=
 =?us-ascii?Q?xPqBPuN+bs5ue9xK/Os7IrEWzhPzJu9HJzkLqJQB4CDA25AM2j5pwLVFCB9+?=
 =?us-ascii?Q?YizPtIFF6n31lCs9/iSao1iQQ04mqbY/C/f9IdGNLO2RRfrHd9/Ck9K8WWuf?=
 =?us-ascii?Q?mldP7+Eqj+v/3zWq1kzGwAaeLAQX2i8OUyDvwqS0VSUNlAB5oRQKmkfmLuUp?=
 =?us-ascii?Q?GmOsqWEVRBUss2jRZApQfnimr36O3Q8nNrZH++Tr0U04DWFpxDnipgf8gZUg?=
 =?us-ascii?Q?z5QU0KmbrMcqrQSLeMpxAcMpTPTjcdEPEfH9icA0ubHo/uMkta7L5reMTy9H?=
 =?us-ascii?Q?a/xgOxXapvb3daLMonAQE+hfc8cbeOsN2GVy1KlyMrJQTXzwx0HWpxtubRak?=
 =?us-ascii?Q?MVjpTXAXlx5u9wMpImmZjf220TR8ix/HtgjnaulNF3GwDV8sT7LBa3wnzT4q?=
 =?us-ascii?Q?ERRtQvT5+3yHcz10ze8ThT2qnfGaeeHM1dO1auNUVxb9OfChPZtyWrxGdwA0?=
 =?us-ascii?Q?+6eWeZz6/HkMo2bmjtJ7fzwiOMSj+SpttP+VQK1BKWHIPYAm7yAYCcchl3Df?=
 =?us-ascii?Q?CExUcKdl9Lnl5fB12xSPz+b9RWW5+fCiWz6ZywquWsUaIqYE5ybQr2RAak1G?=
 =?us-ascii?Q?p0DcPtfP5IVdLEbtYWJhzY76A9Zg8CMd8eYxJn6X0tEcN/9WwzPQyH4UKDwk?=
 =?us-ascii?Q?6m/AgdL5JANdWYHzm+tTToCNaE2yzVMTzlLgJRPjyfhZaUQRiC/7+cy25wek?=
 =?us-ascii?Q?mA7tKAYY49DbMU0gKdlO4mXK0RhqiU4RBgwtpWT5FGA4M8VvP3FZL5C2nzJn?=
 =?us-ascii?Q?Rn8I6SndkASjE8HvRP0PT8N5fQ8sQdGinfQV/JtDbUU/++KhhGWt338Kf0He?=
 =?us-ascii?Q?APVhO4LXY1NfmxKxdTTrX1H6vidN8xYrJrcrUUNpCiCZ+jNOkE8DoGb44bUu?=
 =?us-ascii?Q?Zb05iDlwEC0xs7ftvnIA1ffNQjWP9ZDKULpbIQRrncI3G3wGqBBMdnosEsrx?=
 =?us-ascii?Q?q/Ja2vw+q5fvatuCpmLDojlTq4eJ/jq2QVCghci56eHZGgtdd1CLDf+iggl7?=
 =?us-ascii?Q?VuftOudLWdxYMf6KBRwYz4NMtGPx3qiq8uzFJG10WzO/TKcb2/ffWREZFYWZ?=
 =?us-ascii?Q?GkTvePlx9tMjCIdQGqllChCW06qavX2bBoy5tQrO/Qyagmn/y5JTn1Xa6poV?=
 =?us-ascii?Q?4afvEp7HeNw9bjnhj2z2sw6jpIii5F6Ok00eaHbbBJiTbn3OwbzM?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14bb61a4-bbdf-4a14-afde-08da1049e577
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8426.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2022 23:31:19.7328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8twzMWEIyzbmQSfojb2wGSJkHPap7aK/U8CRylzgAhAzjTFtnoEciaq6xB5UXebVTGpQ7mHeTAOIjJBPg7+uknTFroWE6idkcz6H89UWWrXV4vWhkJnRjZqSDNEt49x8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Xiaomeng

Thank you for your patch

> The bug is here:
> 	*dai_name =3D dai->driver->name;
>=20
> For for_each_component_dais, just like list_for_each_entry,
> the list iterator 'dai' will point to a bogus position
> containing HEAD if the list is empty or no element is found.
> This case must be checked before any use of the iterator,
> otherwise it will lead to a invalid memory access.
>=20
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'dai' as a dedicated pointer
> to point to the found element.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 58bf4179000a3 ("ASoC: soc-core: remove dai_drv from snd_soc_compon=
ent")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---

From "code" point of view, indeed current code doesn't care non-find case,
but from "logic" point of view, it should find target DAI here.

If it couldn't find the DAI, it means
"This is the target component, but it doesn't have target DAI",
and it is very strange for me.

If you got such bug, it is CPU or Codec driver side bug, I think.
If this is for security reason, indicating such message somewhere
(for example by /* comment */) is nice idea for me.

Thank you for your help !!

Best regards
---
Kuninori Morimoto
