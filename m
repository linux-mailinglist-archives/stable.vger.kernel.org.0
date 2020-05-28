Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FEC1E544C
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 04:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgE1C6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 22:58:50 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:8257
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725896AbgE1C6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 22:58:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbHZjw92VdDT0oMDU5pyFoo/g6Xs+zWwWLo/wygKOzlVy03om9zHKc521fnfpt6Rqix2FInpjsMeQvt8D2IUR9DJeQ8NzIcQfRmIi5Zw08KjAi1MpAhLUUwQsZCTLf9jaSGhNWPsmRbXtj74RR7EzGHrd+WDLQ8hee5vYTIqZEsax7NzpNSvXP3tNXLVKS+Y85LwG7IcY02kOliZGlVRH4hpqgKZrI5jrHhcuxlZ1hVPb5D20Yv4npL6V5X73E0lep34wSBw3VX/VTb0bzY5qJJ68m1HrqbR6ZQWCEGGf0QwBYHUZOqi3NkiXTslWMeS+ZQQTLoYPpL3kGo3kfPnCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1FtgsWpomJ/DzTxcwD3KBE5STqfzyfpgnk9VVxDOhw=;
 b=fBpXRx4/pzMM4a1Ps+IoZNt7WHRbEVpYVRwMue7/opc7nOO4TWYLcnEXJ4Ltb0/NiWbPb9F1yTil1x9lH1FTYvAYShc5kJCsqcas1QDvnKShYik368amXQdIIWVK8hGVyE8TD9O14Tds4Hk5bnM9nXB3coWRMrxcWaIuz///Qsauc8wA25lg34VZBxxNqsja95dkl+zRZSPU/4UUnfvMn9cho13wTCRtCCC+4Id1Og9rtSo2KU+ynFmwIM92g60A0m8GAX+I5HvDxYRNOYTk5Y4By2NNqFFFpjMErqh161KdudlD5IAkukaEbcysMK8MdddD+vk6t02zlFiasKgyuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1FtgsWpomJ/DzTxcwD3KBE5STqfzyfpgnk9VVxDOhw=;
 b=bm8gBgAV150P8toFQFTfEoe11YeAqBwuR/bRlooRDAHACDvyDbOYtV6+x6iFqOe8Z7C5vU8s4ppvisX+7r2QQNh84czBG6JAo17syWmbXxnZtPwd5u4InTuKWebKwx6zF3NHqOANfh/wFFXpAQEIB4OaPdVWYWAKHXrp4kWtZjk=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB3983.eurprd04.prod.outlook.com (2603:10a6:803:4c::16)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 28 May
 2020 02:58:47 +0000
Received: from VI1PR04MB3983.eurprd04.prod.outlook.com
 ([fe80::250a:ccb1:b015:3b38]) by VI1PR04MB3983.eurprd04.prod.outlook.com
 ([fe80::250a:ccb1:b015:3b38%5]) with mapi id 15.20.3021.030; Thu, 28 May 2020
 02:58:47 +0000
Message-ID: <ce17fb3798b208e63eabee6c1e1197bfce6b77a9.camel@nxp.com>
Subject: Re: [PATCH] drm/imx: imx-ldb: Disable both channels for split mode
 in enc->disable()
From:   Liu Ying <victor.liu@nxp.com>
To:     dri-devel@lists.freedesktop.org
Cc:     p.zabel@pengutronix.de, s.hauer@pengutronix.de,
        kernel@pengutronix.de, linux-imx@nxp.com, stable@vger.kernel.org
Date:   Thu, 28 May 2020 10:58:01 +0800
In-Reply-To: <1589268718-29837-1-git-send-email-victor.liu@nxp.com>
References: <1589268718-29837-1-git-send-email-victor.liu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0136.apcprd04.prod.outlook.com
 (2603:1096:3:16::20) To VI1PR04MB3983.eurprd04.prod.outlook.com
 (2603:10a6:803:4c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from blueberry.ap.freescale.net (119.31.174.66) by SG2PR04CA0136.apcprd04.prod.outlook.com (2603:1096:3:16::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 02:58:44 +0000
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76686a14-64eb-4f38-e433-08d802b30a31
X-MS-TrafficTypeDiagnostic: VI1PR04MB6014:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6014026F1DEEEA64206CE88D988E0@VI1PR04MB6014.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J9Ba3sQxYPhE0+vKCVsr2IJTDmJa3gODeU+Oj+WXjyko/kQY4dPRpJv7H6gYSzm+2eQrcd6AdvCrDEblOYrVd8h6/w+558b1w+sSGdpZo4BfrME2Yyu9YMQBqB0ZH20gbV96CH9wmKCI3Wj660BeMEXfxB09e3c8eTtE3s/RzwfotJVmbcz/HxN+uDd0sMFLRpaFsbAhNxeJpikH/ltYt7JmjtNeEqlerL/c4RmkdVLEa4dQPcfZGhWprBqALiVN/DQp3edTq80VlyqyPZtFhZhVUbQBsd5ndg4Z/TAze+V0DNMuwWULN13c+kGOmU2gSOcjlUKPT7OjGM1tMiGlVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB3983.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(8676002)(83380400001)(26005)(6512007)(66476007)(6666004)(66556008)(16526019)(478600001)(66946007)(316002)(6506007)(5660300002)(36756003)(2616005)(186003)(6916009)(8936002)(956004)(4326008)(52116002)(2906002)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xAUSgNEoEDm9OdajMR8m8JR6+ZaQPeeuAxrjaM0icHivCaPhGDhJbESDERbd/ehPuY9LBuVtA3TNMwln9Fko9JM/Vy6+PsMV1+z0tAQp6pAA/rQhnrEvbC1Vh534JOO9ToxvD0tdh/MOy8xxZGrSlzxgoFx269RHi2nH/+iqY9PHOU52EKFKaFofzKaesGsktfMX0AEv4HOVaM/KVZPbsmwVwYk6YNx2nj/kk3w5pVGZ+hdRF0VBE8VZo2wAPewQDDfnM3ooz/dlY/78dLAr0jRjMwSHJvbPj3THD71OnTjsdp1RAX8o5l2IgWCex/SBpRKRFkUcxSMpx/LGtSDbIO0bf5qxu9fsd+PZPE7m8AmfqCcxhHcurzPYEQWSfI7zh3l41YL3FMjwVk4Kt0MnF5wtYzBONzpA4EFu3VYU6aDCQLlryRGQSi1293nSn6VAfg6Lyqs42Og0ty4FF+TjdlYfPVBgRAm36sY+g89APJ4=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76686a14-64eb-4f38-e433-08d802b30a31
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 02:58:46.9946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QsecbDNMNA+p11tGjLraNPeK1o8u7Gn4+dNN33ScftS1oCaKpdfOTz2VaA/TtULk6UYQyL7W+1quy9AXUsIsiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gentle ping...

On Tue, 2020-05-12 at 15:31 +0800, Liu Ying wrote:
> Both of the two LVDS channels should be disabled for split mode
> in the encoder's ->disable() callback, because they are enabled
> in the encoder's ->enable() callback.
> 
> Fixes: 6556f7f82b9c ("drm: imx: Move imx-drm driver out of staging")
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Liu Ying <victor.liu@nxp.com>
> ---
>  drivers/gpu/drm/imx/imx-ldb.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-
> ldb.c
> index 4da22a9..af4d0d8 100644
> --- a/drivers/gpu/drm/imx/imx-ldb.c
> +++ b/drivers/gpu/drm/imx/imx-ldb.c
> @@ -303,18 +303,19 @@ static void imx_ldb_encoder_disable(struct
> drm_encoder *encoder)
>  {
>  	struct imx_ldb_channel *imx_ldb_ch =
> enc_to_imx_ldb_ch(encoder);
>  	struct imx_ldb *ldb = imx_ldb_ch->ldb;
> +	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
>  	int mux, ret;
>  
>  	drm_panel_disable(imx_ldb_ch->panel);
>  
> -	if (imx_ldb_ch == &ldb->channel[0])
> +	if (imx_ldb_ch == &ldb->channel[0] || dual)
>  		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
> -	else if (imx_ldb_ch == &ldb->channel[1])
> +	if (imx_ldb_ch == &ldb->channel[1] || dual)
>  		ldb->ldb_ctrl &= ~LDB_CH1_MODE_EN_MASK;
>  
>  	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
>  
> -	if (ldb->ldb_ctrl & LDB_SPLIT_MODE_EN) {
> +	if (dual) {
>  		clk_disable_unprepare(ldb->clk[0]);
>  		clk_disable_unprepare(ldb->clk[1]);
>  	}

