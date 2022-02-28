Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9620B4C6914
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 11:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbiB1K6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 05:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiB1K6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 05:58:35 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60045.outbound.protection.outlook.com [40.107.6.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D65723C4;
        Mon, 28 Feb 2022 02:55:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0WQ5P4qvBYPIk+WBMAAQYHxOpnnw9wqbbhlIbRl+J7ueVghufzi5a2drwV3rDgI4dBzqMy/eRRvQUHHsxYWrXR9hwF4KraepLZF3X3lsh74oovz1Sq/bjRp0q0iuDWQo2IcswR/MBuAzA9m7f9qzU8VDHs+gcpHIKZiQeMMgQLumQXQ3gyc0kQ0JryJxPCl3JgHmCR8Rjyluxt1+FmLnHx5sIR7Rlt3rzOsydt29VIstQWn9CTx4WLsbwvVFYsyasrbIjTMnLIuY7SKE4+vHlwQ/+bkhOumocCqaPCdX0sS3layoDNJzL+by87b9TmFgTpUkHQb6jcQUd44XUhVwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjhgbJoZU1wbVA904A6o2qwNTIUSmJkrFK6BerzEVhM=;
 b=mDM8n9AykqG48dop71JEIdtiVAyzNiAJ6S1VhLksD9xh2Yc5D9Aurjkb95T7ykvy7mzDDGtegcVF7MgRylmaxYNh0cu5jaL0hGQUMBRcI5kgbH+NHdAVuRRtu6iypXeiGrgKGBhpEJhKcIj4qnR3Q3G13p/PfDe/zDNpu9CPv8XMFv/8hZ7zlKwsy+ZA1rxELcL41JOuDnuropbmw3FMh9WL6G8lxfFTTxika2jMAMMQwvtKx3gU2pU3bBRqQRH/YP2gYQGSu3MK29ii0mBgyuWg9nBDUUKHRAETkZnEypeCHpe2CqD1XWvodInnw64M+gh680imPQmHzayNTj5NJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mjhgbJoZU1wbVA904A6o2qwNTIUSmJkrFK6BerzEVhM=;
 b=fxrV9iJMWAUmY9JRsGtKiG75uvhiRAIOK5xDx3ciCsmOxiIMJJ+2TYJ/XhxNHIpm4m4GpmU3B+6ZkyqW1iKmx6GMwMod62MahOafD+SbX5rwp8BX8d/EOEVBGemmB8dnS9sLj2LGPLTNiXeABiWhabkk5VZoWVEHQVoDI/cdRy0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS1PR04MB9405.eurprd04.prod.outlook.com (2603:10a6:20b:4db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 10:55:08 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::98a7:fbac:5cec:776e]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::98a7:fbac:5cec:776e%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 10:55:08 +0000
Date:   Mon, 28 Feb 2022 12:55:05 +0200
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Andy Gross <agross@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 09/11] clk: imx: scu: Fix kfree() of static memory on
 setting driver_override
Message-ID: <YhyqCTWOK9lO1dNl@abelvesa>
References: <20220227135214.145599-1-krzysztof.kozlowski@canonical.com>
 <20220227135329.145862-3-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227135329.145862-3-krzysztof.kozlowski@canonical.com>
X-ClientProxiedBy: VI1PR07CA0231.eurprd07.prod.outlook.com
 (2603:10a6:802:58::34) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e5983fa-d8e2-474b-5771-08d9faa8c881
X-MS-TrafficTypeDiagnostic: AS1PR04MB9405:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB940525A8489F06ADB6ECB0D5F6019@AS1PR04MB9405.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbU9SSRtdxvE6OVoNIOPMfx/uumuCjPMA99GrdY4G2mcL7qcW/PLWDt6qWCI5RDXhzUp4Pf/OcunUuaP8f82JAcaZu3lOo48btj7Cjusa8fpYRi1eHaC9s6q2wjWqKHYPppKMc/IOMO0ZaVjUojc1SkxlIsfqzFAYyabR2wlETC3OA2FKdF8Es4zQiCYQI41YujkzY9+HNuNfzmIjCeI03I9gmegivFnlTR3O6BhPL5vphc41go+ByFRjw5euhSKzrj7nDr/a7/PlCNjZ0ovDeb9CZu/88VAf6ykfO5COa4ovRNluAqGTCrp+MuVveMEiVxPlJnXZo4TLn6RVlp4UBPQziz1aPClbp7lvVQnKHyeB9ZWbtxM5yv9RpCEBvwK6U9hVFgCEwfNfoBF/bx3dCoNTiALbl24r+YYrDcMbf3BOrU2Q6s0FwryHg7xxNArdAa6dOawlZsnTfve5wZbOg/olFqMFYpnZaOYgfVZ8vp2IBu7cN8zVMEM4im8nJZY96ygN6vrzy/GEfKUBD+l3BcNOwPyQnri/QS32tIo6ho4hn79660c436v+SCri2yIHScYdZ90RTBPKN5nf/tJptlcjXO41HxaR/BNhXYvEpujSNOK+jq3nI17ehDcAUfTJ6Tyycubj1HcqN7V1pgbtQdoI1XqbeN1FKiooKlSSr9AA8KlUyg9Fxd9u2f7MzWaAiTP3G908R2exyLTPHr2mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(8676002)(4326008)(66556008)(66476007)(86362001)(83380400001)(54906003)(7406005)(186003)(5660300002)(8936002)(7416002)(2906002)(66946007)(6916009)(316002)(9686003)(52116002)(6512007)(44832011)(53546011)(33716001)(26005)(6486002)(38350700002)(6666004)(508600001)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ouUWPnI+v8HZaLdgLgGbqTouEtQXAU7Yu/I1WwwK2lbVgJ5p7VXALjXmXVHO?=
 =?us-ascii?Q?YWQjVYWDnLGCScbIMWNv32zVpIQ8JtAsQTWGFDFIwt60YLoTCosDeV2cGiZv?=
 =?us-ascii?Q?bY6esMxfOi4qLIWPL4b6ktTT8/uVO5NF8v8gC095ELWPsqvYVAQ4bPqM5FIY?=
 =?us-ascii?Q?WaQduwx02CYtoRM3VxlAo/G1sWBPWVWEjAuUrez0Xl6rVj0XFRELlC0qPwmz?=
 =?us-ascii?Q?q1VUHmD/BPNwP/o3feJEPCLdzO9fuyluCV4r3fRtjDKYCbGNFtxElGE5QwVx?=
 =?us-ascii?Q?vwk2KLJfIINiH24g7CoKZj+nRraqCIkDbj2nooFYa+BLBBQUGvZYUJHo4Vzs?=
 =?us-ascii?Q?1YwGvNBfKkWoRh/8DtLc3Tg2Ke36xyF5iNa4hFdjTMJCADC/Tdejfn8Mq3rO?=
 =?us-ascii?Q?+KmpEIP5ULL6k6TdfWb+rd0GlFQU3HpXJcBfBHx5H1Egp+n0KkQOsUSq+3QI?=
 =?us-ascii?Q?3aH3B/X/N5TXiRIbIIqe0IanKe3Ci3B89Z2onOunNkN76nMoyGt57ULXmzTS?=
 =?us-ascii?Q?OxzgEEbV2hhNp0bcKPfeuyWkGlsD/LhHUoyvrkCVjRnnqDcYRCJU/OOm2lon?=
 =?us-ascii?Q?2sWeOqqN9hJ6IsiG7pSavfPxF7lfrm2lx7ayP8E4m+juhknN5PFEy/TENxOi?=
 =?us-ascii?Q?z+17bNeRbm/UGVlLEEupPPLH7mp5vECXOmQLuYKa8EbBrcvTgDW6Eh30SVE3?=
 =?us-ascii?Q?cnsLxR56M54KBzEz/w0TR7OnB8APZiORnQJatzmQUd8FG1V8y8jXAiOZM55p?=
 =?us-ascii?Q?L0nnqIL2pbjaxM9YyTMa19w8TtypQMqLr2ZL7md10NwJ55TR6x1BFkOBsk5E?=
 =?us-ascii?Q?p/rJPl72Pah32eJLllTA/Y28y4WOI6R2t6G+JBUm3SKnPPtzj17UDr86amwr?=
 =?us-ascii?Q?a3r5OQtJXtXs48ic9zPVZgMX1VtYR3qmJEkG9TP/fIlt/uNieExcF5HFvXvR?=
 =?us-ascii?Q?1Q398ysvn8SWMz//ER7DfpYV3EqCG57NQi/bz5f/jH5Zx4C5dGlEdnVqQoxb?=
 =?us-ascii?Q?kQVZHlM2xr9g6a4jFCZE22QM97oAOWcdomsUvhQ73Ll6Zqto3bdUyj5t+cTX?=
 =?us-ascii?Q?VBVD9Dr+fg9tk66xKojeLPGci6JlUZJlnVDNKmSBOpsbECzH91sEnQprOpF/?=
 =?us-ascii?Q?okEFpql4l33nT3ZMvnUU4NxUV5zrHV5wzoKD35M1z13c+NAF45L8lMFZLio3?=
 =?us-ascii?Q?N6KicfhYMGIzRFajff9yjb8W98tA+UJj0WU5CznIYobtBGVNuE8jkcRc+VYN?=
 =?us-ascii?Q?j003T6ta9XrMsjAi1ERWtOth7C7mcmiGOxKTLgxh9lBD/OprEt4oeskGdPwD?=
 =?us-ascii?Q?QG3d9y+D8Jb/Y4718U/lVwTuFuEF2SSg5Ay71oFAXBJ/tgP8zx0NB7UlQQym?=
 =?us-ascii?Q?4Z1MuPgFJitm+YlDWC8K5fheq/P/p27/VaXvrv/6rRW1QW1VPeQowlKXGf08?=
 =?us-ascii?Q?8t7Gt8zszUgD1kfH1lmMUyjdYosH0Sz6TL0RU6aEvLfODgkBryDH76TAiUMr?=
 =?us-ascii?Q?ZOcDZy43KWieXHgVyQFa4O4MRZKpalLe4dcokVJR1yfD64Q2R2BpqYJeBv3B?=
 =?us-ascii?Q?KMW9T5Dw1+eNv3FkvhVBuqSmIa/ZLMNA70xabfn2fLprViQ1ENAtCg/uGzeW?=
 =?us-ascii?Q?IgGW7szYLkb4+Sijn9Zkrz4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5983fa-d8e2-474b-5771-08d9faa8c881
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 10:55:07.7973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3cPZht+XpagTvOJJjtOs7w9BYjlHq1B3LDVAfA92nCOZIm8/blfoFFoZ9nkHYjUf8lrbYZCVh/yjq9+PkKLVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9405
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-02-27 14:53:27, Krzysztof Kozlowski wrote:
> The driver_override field from platform driver should not be initialized
> from static memory (string literal) because the core later kfree() it,
> for example when driver_override is set via sysfs.
> 
> Use dedicated helper to set driver_override properly.
> 
> Fixes: 77d8f3068c63 ("clk: imx: scu: add two cells binding support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/clk/imx/clk-scu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
> index 083da31dc3ea..4b2268b7d0d0 100644
> --- a/drivers/clk/imx/clk-scu.c
> +++ b/drivers/clk/imx/clk-scu.c
> @@ -683,7 +683,12 @@ struct clk_hw *imx_clk_scu_alloc_dev(const char *name,
>  		return ERR_PTR(ret);
>  	}
>  
> -	pdev->driver_override = "imx-scu-clk";
> +	ret = driver_set_override(&pdev->dev, &pdev->driver_override,
> +				  "imx-scu-clk", strlen("imx-scu-clk"));

See my comment to patch 01/11.

I would like this to look like the following:

	ret = driver_set_override(&pdev->dev, "imx-scu-clk");

> +	if (ret) {
> +		platform_device_put(pdev);
> +		return ERR_PTR(ret);
> +	}
>  
>  	ret = imx_clk_scu_attach_pd(&pdev->dev, rsrc_id);
>  	if (ret)
> -- 
> 2.32.0
>
