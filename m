Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2941A52ED78
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbiETNsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 09:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiETNsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 09:48:52 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2071.outbound.protection.outlook.com [40.107.104.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2294C16A25A
        for <stable@vger.kernel.org>; Fri, 20 May 2022 06:48:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIUi5vDxb4pAmN9VC8SFC66GMhf3iKA3Sh+6jrjqL5Rm7uQIlowSkfIfVqA2TJN+V6F5rjHUrit0Qgcin6soltAExMUkHmQGQHV23NTEhCRGFlz2XvR6BUi96/V6qRxQhRG00XlZBom40ADdXcdUyvkFp/xNCbEiU+rNXDv5Dynzi3uIrGjsgqUj9Nd3QOJjKKlzxh/PQYBwyPU5nbwmJB5BbGT5m2nG/hKj26STQvWv2ZaljTdON11qKOpla7yJw9eS4CQMAQ6OK/JYpiFECK0HUrdbxD9G1mV70DvYbZWY/Zilrx5ui/XZPkb0ZT5MMH6+gwIeJQVxl0UqTxJXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0lBRrezopYTKEdhuLfi7u1WBSiqskbBZ4kKdB37LiU=;
 b=ICpL0btGVSgb2Fx2jiHAtE66keDaYO7R5NKENRNclfTC9lcx2SrOsUBcxvpA3IOhAsTWsjBuK4MEfYDhBEJvWXEdgfAaiL1sOghfpd/huztgBP4//+Uw+FE3NrAR4ofpmIuWKOSsSmQCNcpp9DLL4b84W34Vy122KEJSp/dx062kyyhKCaElmHWcUz/Bv/6t3JEze1a4IMTSlRZbdPGFKFw94WVQqxlHoCw1BCT07smPxMgP2Rohi6Re2RTVumHCK9TD9aonk6cXqOLvQoLhx7xmv8quq94O4yMbDL3yQnuRtvWw9GWvanO4FP4fDuZcUbaSxnAvkVU+DBnwiEMFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0lBRrezopYTKEdhuLfi7u1WBSiqskbBZ4kKdB37LiU=;
 b=ToR/5MZdikb5DU0G/94mL5uYDfmlb8j6TK3/MJAF7N3fIJ32VCjCJx8nz0pTFevTkUR//nNWPohn3oDxAfMhyqY/WYMr39/Xp8S+3IN54ImKNaQKL0WJ1zzuzqsnghb1Edcm64TOtbw1eqJcSXeiEGkRI8UEPpsHqCGsUgbRi3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB8PR04MB5897.eurprd04.prod.outlook.com (2603:10a6:10:ac::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 13:48:45 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::9060:4119:5466:f5d]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::9060:4119:5466:f5d%3]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 13:48:45 +0000
Date:   Fri, 20 May 2022 16:48:43 +0300
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "peng.fan@nxp.com" <peng.fan@nxp.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: Broken Audio on Stable Kernels for i.MX 7 based Boards
Message-ID: <YoecO1jxbh3nVJGF@abelvesa>
References: <536ad55a36d88364299f22782f7c12a6c70c5c11.camel@toradex.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536ad55a36d88364299f22782f7c12a6c70c5c11.camel@toradex.com>
X-ClientProxiedBy: LO4P123CA0476.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::13) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c380ac39-3b17-4b91-3fd0-08da3a677586
X-MS-TrafficTypeDiagnostic: DB8PR04MB5897:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB58979D97822A706E867DC74DF6D39@DB8PR04MB5897.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7yd7e0S6mAnxgTqXeY4E/vUvWJZ6mCX9SzPyXw+yHeBfIB6sUnB2/csY5Mnd9iacy7a9mYvuIdo2OaSK5y8FvGXm1FNo46tPx0hu6wM0h0STsUoekWCPWV7nGhsv71bsmZ81dToKIeaOEOFDTornhohd3IdeSCz65LXjPgYS3VFImVk80adq/3UTEP5yhmTj1XgKc2cpNEufS133MJ9/FJiILO4+FEPayROiQ+YwbS7bWVWTUI6PQAaJCHDaWK5VwhItSnvhvms9+mCdpcX9OTzpboa2Z5q/XEgQC+8GjeuINjQdMTYHo0TQAYO4Y504izMI0EnwrXkPm3Q864o63h4+0xuhpV1DUf1hYSvY8oQFyjwCtjVi2iXjU3PGIMrBEssYxFaw+jMLA37mZEfcNEyEAoDxgyuynwvJizK0zIl0xDiXE6ccbin/OJwwvE9VBaOkP2IpGqRAspXat9gr1ClTv7H9fFmi7hIuX/rKIeCuQWzCeqIuQUjeO44oHbGj35k6rigJU02e51zryRnvf87EJG1nZR3GjVnC8Pn6FnxQ9Uu7WKTr17vzqBqTV5EDjcHmyW8o6Psmt9wM9I8JjoK8FNyog0jFi4uOek591aUhxsoxSWAbqQOK8GsMTOpX/Y4UD0/SRmelKmKG+Z4FaZXU+FAfNm/FBtjdlGFgUKCh//ZlO1NKBmpt9/wI2g+sRJFfV0wBvZ5YcUqRRu0nPBoLO2826SlivJ0lwtYGOHMCAwG075AkQGWan+Ay7aulrN2icVCJNLIf0s75/QcnWvas75PcDn4YjAVG8AuBXmgkh2bzAJQv5UKR7DhaiUiiA0/vaC1jTT/kPhy+1WgEWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(4326008)(86362001)(5660300002)(4744005)(8936002)(6486002)(966005)(8676002)(38100700002)(53546011)(44832011)(26005)(6506007)(6512007)(9686003)(186003)(66556008)(316002)(66946007)(2906002)(52116002)(38350700002)(6916009)(54906003)(66476007)(33716001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?14kcG1UhLB3Bau1dlI71A5ToNXwf7SXAaYunmXssObrH3O1LQhYPpT4bSFFh?=
 =?us-ascii?Q?BcltmBJ0wFH5smO8mSi6DaSVxROVA/uAkh16tVO0WifQrG0xBJ8LpP42MJ/q?=
 =?us-ascii?Q?gICyXiJNjbX/Wuo5SFIMxb9hYrPQFbIzGjDhgHE7tHCp7U0hFSYiBls7IcRV?=
 =?us-ascii?Q?nd3FcCMQ9Uy8ArLuSrnQPutRLNVWgEDiPfz7GMi1Iht4Mz96ZASDSkKyEFxt?=
 =?us-ascii?Q?SWS+FSjuuBhUrHcJLIO9kEnKb77Hr19oLxye5rkZKPpLhvKYIFed1zdF90U+?=
 =?us-ascii?Q?2IDyldbvoIUA213aFEOIrBUKJVK2AHY+ynMPzpzQJ2noMCatXu8hQuIYHseQ?=
 =?us-ascii?Q?/mlhzp7WXw0tXCryPhl1e2Kg1+tjbQgHf82cfnzKHWi3u2ZiSMIz4elsdF+3?=
 =?us-ascii?Q?eX+27Vt2BrrpRm33kHP+zVHXZBeTbyawz7XHbSBsFhzVcFawi6qlHH+x6XXo?=
 =?us-ascii?Q?z2Nc+BaXLn23QvJusK6VxYXb5lzZGlK4NKEZh3yCqp4MT5Z+AfTOpvz+KPw8?=
 =?us-ascii?Q?wY8CIrsb77JKwio4ya/t9n/kBc79wP5NE91opiY/xLe6V4BLIROZyYv4vc7Y?=
 =?us-ascii?Q?fMtgEm0LXXeV7VbVQIdS0jHvdBzYNYzFMPKE/NURRBRaaL3xzqWj9gmJfjk0?=
 =?us-ascii?Q?5gR+yM4C+cBq0CsCtZuUbBcTCfO+aEdug2vHm0iCLXOgXVPesbsOfhHWXWwS?=
 =?us-ascii?Q?I6Nl/ULT7AbNZavX9+37QmNvWPZZ7Ajsr/1ZATFZebzbOSIPKGbLWdis0k2h?=
 =?us-ascii?Q?PuyUCCHwx/jmQWjgaceaQLcvQyi1xWV+/n/YYhPV6qQDYs9zefbObf7s3Q8D?=
 =?us-ascii?Q?zPf59px0qdkxE2Wm2s+3Rcz/bSRBJY0dc5NAW1BWOHX8zxbWmg+vQ6SyoNgE?=
 =?us-ascii?Q?ojALt+2wjc+caU02zk26IujfandKvAta5RlrqcSuPJG9AJIXfK1KmbJJ1m3S?=
 =?us-ascii?Q?4PupmYe277Ib0ZZ7+NFrghgsZ3hoMJQ1KgBqt2wiCgDO0BIaXuZoi2iqarxr?=
 =?us-ascii?Q?p1IBUvacbC4vtFjAgESDI2UG8CQOjH8/p4nQCXEuaxDvsIT+0YaK+yTFFMd0?=
 =?us-ascii?Q?uOGjpLKXCqotkAihyOGpqh4L6OOQLeIBquFGWY5BcnOAKYY+jPIE36QHgwlz?=
 =?us-ascii?Q?4aSXUrnC9vvePfUe2CZyyxZUWwZIfN0OnbLA8cj9F5xzRfrTfdn2XpB+vNj1?=
 =?us-ascii?Q?9qBUIbmHh81Q2nCZauBuHpHjZ9Tjvit3HHTa46eK0yFeEzjnk05sqDE/tpZN?=
 =?us-ascii?Q?/vYivIhJjuSQRBvjCsnW11iYy/FStIZ66UNvdjtRGwpoA5X0jN+kCCX5L2/3?=
 =?us-ascii?Q?hvwfMz9mRgFscA6p++V3lMUCGZlISpsnQkcIh8PFIviWRexcXmUbDDAvw7oy?=
 =?us-ascii?Q?WEbAQ0eaEytGXgSaHjWTAJY91Qe7GumuVAyP2LX9TheIFH2qMnPBxhHAxcur?=
 =?us-ascii?Q?ZPVREoy2NyBUl/9koPHMJUblkx+dN6lY0D3R43C6YpPZAGCu9Iw5Tzx3KVoj?=
 =?us-ascii?Q?EsxMLrsPck7P4xNRtXuFJBSisAgOSiii3V+Sy2U+TCSzDZuKR3Zl5kpAC0ky?=
 =?us-ascii?Q?nlGxpLq95RtWBH5XgEtgp6ETrF0oOFM/LMSgiVg34E+dzB32fz9pQWV1hWbI?=
 =?us-ascii?Q?tN+ya+peSsp+6psr9CsqrTtrGpB/5GAr7uXzVB6iqHoTA7PAXUHW+F6LT6f1?=
 =?us-ascii?Q?fOOYbBhmLAWZlnsnDJe/IsEqgkV4OOhF7+8gpQ55sxcaz5z9HShMnpCTl5ct?=
 =?us-ascii?Q?feO59De9Xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c380ac39-3b17-4b91-3fd0-08da3a677586
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 13:48:45.6621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RU6VF8GBRJhWDPhdO0gYOi6Pg7iSRe+TfBWj9J7f8BPRv/qqCo3BNkuO8M314wgSZUDV6OiOjpeZNNA/0FfB2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5897
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-05-20 13:25:29, Philippe Schenker wrote:
> Hello
>
> I noticed today, that commit eccac77ede394 ("clk: imx7d: Remove
> audio_mclk_root_clk") was backported to stable kernels. This commit by
> itself does break audio functionality on i.MX 7 based boards. [1]
>
> For this to work commit 4cb7df64c73 ("ARM: dts: imx7: Use
> audio_mclk_post_div instead audio_mclk_root_clk") is also needed but is
> lacking a Fixes: tag, hence it is missing in stable kernels. [2]
>
> I noticed this while merging stable-patches into our downstream-
> branches.
>
> @Abel can you confirm my finding?

Hi Philippe,

Yes. Sorry about it. I should've added the Fixes tag
to the first patch (of that series) too. My bad.

Lets hope Greg pick it up.

> @Greg could you pull patch [2] into kernels where [1] got merged?
>
> Thanks,
> Philippe
>
>
> [1]
> https://lore.kernel.org/all/20220127141052.1900174-2-abel.vesa@nxp.com/
> [2]
> https://lore.kernel.org/all/20220127141052.1900174-1-abel.vesa@nxp.com/
