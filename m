Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B3027DFD
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfEWNXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 09:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEWNXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 09:23:35 -0400
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95C4020862;
        Thu, 23 May 2019 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558617814;
        bh=i6pp3RLEvBeIhKApRemRE1F31C6IrTnEG9M9+DpDJn4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chW2ZjX0prGsWVbRZdCwgBBN+jw6IfEK4cW9UlglzX5ZZ/dqZNjDFZVsBKGZ312WA
         3PggHOz/MiNwqdeehm4F3+DgAnXJGS2dMPnOw/Go1EpTLh7erdRW44acDpPEE5dum1
         pOLLKliv0SHG5DhD1UcgQOc5crWVFnEvNvFeodlI=
Date:   Thu, 23 May 2019 21:22:36 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Peng Fan <peng.fan@nxp.com>
Cc:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
 audio_pll2_out
Message-ID: <20190523132235.GZ9261@dragon>
References: <20190522014832.29485-1-peng.fan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522014832.29485-1-peng.fan@nxp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 01:34:46AM +0000, Peng Fan wrote:
> There is no audio_pll2_clk registered, it should be audio_pll2_out.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: ba5625c3e27 ("clk: imx: Add clock driver support for imx8mm")
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Stephen,

I leave this to you, since it's a fix.

Shawn

> ---
>  drivers/clk/imx/clk-imx8mm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/imx/clk-imx8mm.c b/drivers/clk/imx/clk-imx8mm.c
> index 1ef8438e3d6d..3a889846a05c 100644
> --- a/drivers/clk/imx/clk-imx8mm.c
> +++ b/drivers/clk/imx/clk-imx8mm.c
> @@ -325,7 +325,7 @@ static const char *imx8mm_dsi_dbi_sels[] = {"osc_24m", "sys_pll1_266m", "sys_pll
>  					    "sys_pll2_1000m", "sys_pll3_out", "audio_pll2_out", "video_pll1_out", };
>  
>  static const char *imx8mm_usdhc3_sels[] = {"osc_24m", "sys_pll1_400m", "sys_pll1_800m", "sys_pll2_500m",
> -					   "sys_pll3_out", "sys_pll1_266m", "audio_pll2_clk", "sys_pll1_100m", };
> +					   "sys_pll3_out", "sys_pll1_266m", "audio_pll2_out", "sys_pll1_100m", };
>  
>  static const char *imx8mm_csi1_core_sels[] = {"osc_24m", "sys_pll1_266m", "sys_pll2_250m", "sys_pll1_800m",
>  					      "sys_pll2_1000m", "sys_pll3_out", "audio_pll2_out", "video_pll1_out", };
> @@ -361,11 +361,11 @@ static const char *imx8mm_pdm_sels[] = {"osc_24m", "sys_pll2_100m", "audio_pll1_
>  					"sys_pll2_1000m", "sys_pll3_out", "clk_ext3", "audio_pll2_out", };
>  
>  static const char *imx8mm_vpu_h1_sels[] = {"osc_24m", "vpu_pll_out", "sys_pll1_800m", "sys_pll2_1000m",
> -					   "audio_pll2_clk", "sys_pll2_125m", "sys_pll3_clk", "audio_pll1_out", };
> +					   "audio_pll2_out", "sys_pll2_125m", "sys_pll3_clk", "audio_pll1_out", };
>  
>  static const char *imx8mm_dram_core_sels[] = {"dram_pll_out", "dram_alt_root", };
>  
> -static const char *imx8mm_clko1_sels[] = {"osc_24m", "sys_pll1_800m", "osc_27m", "sys_pll1_200m", "audio_pll2_clk",
> +static const char *imx8mm_clko1_sels[] = {"osc_24m", "sys_pll1_800m", "osc_27m", "sys_pll1_200m", "audio_pll2_out",
>  					 "vpu_pll", "sys_pll1_80m", };
>  
>  static struct clk *clks[IMX8MM_CLK_END];
> -- 
> 2.16.4
> 
