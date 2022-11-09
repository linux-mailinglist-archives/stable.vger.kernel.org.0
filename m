Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8527622B9F
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiKIMew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiKIMeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:34:50 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5726D1835E
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 04:34:49 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l6so16625020pjj.0
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 04:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=54ZyT6fc56mcawLFXuHDQpGJgTiE24QOQne6rNPY7lA=;
        b=mEhzF9GvZfDYIp4nIk7aLX1AccVsUGSH00US22OvPPZ1bJh77mk1gcrlTnfI7+nZfW
         A9PbPEY5/UM8Bh7Gx1wurMdHnNfYsV12imdcEzcXLe24prrtIEGGR3z4slqrcB7QHbgl
         /QM7ocXdKi/u9o8rRfTKDd8wA7P3D9NT02LWK1fGTQs0IUNczuYiwNZ9fhHH1FgstRXA
         nPhW0D9wWaeCKqDFl9r2DigPRbsM6zhTGzRcR5kSdo1UcMLF/+esiRHKbpQ7E/TrPdS5
         1IfYF2R3ZZgoqOaRvcm1aTYT1fs0/3etvYKSXV207Z6RnoECQi0mW8DXpQGZh+rFry+X
         5sFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=54ZyT6fc56mcawLFXuHDQpGJgTiE24QOQne6rNPY7lA=;
        b=OIiHJRm3m1WkUQ2wHLmtVOo6kT4R6PTfJJ3lu92HiI50w4MoTZYklm7zSjNKqFTSW3
         Zajz0EEeba2iAjl5Rhi+6VKwXGbF7dNOBLKesRBQjcgpRy3t77DgIYiAFrxXJvpfqT8Z
         AOZtTt4pJvIEixggH9i3NF/Qz+xnNU1ac+MX8T5zumDQm6bsawjMGL3hsfG7h0kZNXMi
         Mko6pkzaopL094V1zUwxGwYw+6vZCAE5NCwek92c2upS5uFcNZITq3SPwVwIKSgqta7n
         DCFLeut2KfhXJUTpXMCyfJVIsgeunj8xCCfK5xM849a6iil7Xw22fnI5oi0Pr412dPTq
         vQ9Q==
X-Gm-Message-State: ACrzQf2csj6gG/nHmus6bw5+MwoE2EJbq3hRmNj+z0WIYJ/t8Gle+19X
        2/Cu3NZExSnTUIf7VwDg2uHPn7mTnjqp1YqmLTJaNA==
X-Google-Smtp-Source: AMsMyM7cR85cjCD286dwa+O7SgLYBEsLqTdFVs60mbDlpD2TLOplgOCpHPxyr+PqlxpKYDt5sXgSVTxjTW/b0fIdwLk=
X-Received: by 2002:a17:90b:4d07:b0:1ef:521c:f051 with SMTP id
 mw7-20020a17090b4d0700b001ef521cf051mr80726174pjb.164.1667997288842; Wed, 09
 Nov 2022 04:34:48 -0800 (PST)
MIME-Version: 1.0
References: <1667893503-20583-1-git-send-email-haibo.chen@nxp.com>
In-Reply-To: <1667893503-20583-1-git-send-email-haibo.chen@nxp.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 9 Nov 2022 13:34:12 +0100
Message-ID: <CAPDyKFrmGb272TEyyAUaW7gy+YDa8L2958eF+Fy+5VVfzh04hw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: use the correct host caps for MMC_CAP_8_BIT_DATA
To:     haibo.chen@nxp.com
Cc:     adrian.hunter@intel.com, linux-mmc@vger.kernel.org,
        linux-imx@nxp.com, stable@vger.kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Nov 2022 at 09:06, <haibo.chen@nxp.com> wrote:
>
> From: Haibo Chen <haibo.chen@nxp.com>
>
> MMC_CAP_8_BIT_DATA belongs to struct mmc_host, not struct sdhci_host.
> So correct it here.
>
> Fixes: 1ed5c3b22fc7 ("mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus")
> Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
> Cc: stable@vger.kernel.org

Applied for fixes, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index a54f1806dd57..004c6352d954 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -1679,14 +1679,14 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
>         if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
>                 host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
>
> -       if (host->caps & MMC_CAP_8_BIT_DATA &&
> +       if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
>             imx_data->socdata->flags & ESDHC_FLAG_HS400)
>                 host->mmc->caps2 |= MMC_CAP2_HS400;
>
>         if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
>                 host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
>
> -       if (host->caps & MMC_CAP_8_BIT_DATA &&
> +       if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
>             imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
>                 host->mmc->caps2 |= MMC_CAP2_HS400_ES;
>                 host->mmc_host_ops.hs400_enhanced_strobe =
> --
> 2.34.1
>
