Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA0B209C30
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 11:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403943AbgFYJpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 05:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390982AbgFYJpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 05:45:11 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322FEC061795
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 02:45:11 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j18so4892194wmi.3
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 02:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=T96Cw/B2VdIT350ot7UQTHC8Op+bJn2wrxV9Mj1Tufs=;
        b=UgGBQ0407zaBUunWxSaTxaAU9RpsMyNFk0zmjnxT4oUPgOMS0mUttZchCHkE/Duc81
         3Euu/xzSY0D/RHY6H3f+8L7EBv9pJX6LJ1rgu8XHtFP5DLdQy2U6XBszjzYjLcoASf4o
         13aHCVwSn20u5Y3Rjp5ofbVSJfgcaQlozvioeTOq9qtTjkWRatE7Nw+DInt6u9IlcT8D
         WKiewW7DiiF1VAoAWFrcuQ7Gn9Z7Bx8CXeSjsrM0QoK+BF8FVXERG33Pivml1z/BFL3x
         Pu8dqCmf4p41S4/ENV7loy9Ht76Jl+v26ayWmEU+FNaUyCIDZiOvcHBccY3I3p5geuLQ
         ///Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=T96Cw/B2VdIT350ot7UQTHC8Op+bJn2wrxV9Mj1Tufs=;
        b=XFomn0IhGfcvwJ/99dGZS3OlHAbWcUvQ94ioz7/zOfESRQv6Rq6VcrCiYFGXkEc//o
         /+XYrry274nlRaqCrtoFv+Ulq++GX65cvTmmN5YdmCVbidBDtKDIHQYYCUaPCcTdVl7m
         QW1/0a4Qw3hasr0JOStCDvu2UwmDVl3GXoSgyXY8Qftc3hwPz6v6NpIHZlMZQI7Y0m7F
         Sgn1Ey+LUAFWpJrp1ah4IcuwD5V2+tH1L/Rqe5DDn0nySxLLtHspfaeQG7+KX7UN8Uzr
         Hr/ZpOKmojKnaTxNYyE9dhBsJJUnPJNUBtUDrEcdrlX8eqv6Z/P1m31YrDI8ZKMpNZhE
         4L/A==
X-Gm-Message-State: AOAM531t9RCtm9ZYjTfxOh6a90liAJDLcZZ+E8gSOfepHsXuEktZEK7r
        4UjMiWPRLd5HPOu4j/hbzQmmjA==
X-Google-Smtp-Source: ABdhPJyegdI/9Kh//OZ9HHxhDnrbzMU1SVoSIeuFXdBPkQsQeAD5/SR9bTVDu2ieaapjhThMuucNDQ==
X-Received: by 2002:a7b:c186:: with SMTP id y6mr2558934wmi.82.1593078309869;
        Thu, 25 Jun 2020 02:45:09 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id t15sm11708554wmj.14.2020.06.25.02.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 02:45:09 -0700 (PDT)
Date:   Thu, 25 Jun 2020 10:45:07 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jingoohan1@gmail.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Jeong <gshark.jeong@gmail.com>,
        LDD MLP <ldd-mlp@list.ti.com>
Subject: Re: [PATCH 7/8] backlight: lm3630a_bl: Remove invalid checks for
 unsigned int < 0
Message-ID: <20200625094507.5ozmizkynmlwvyoj@holly.lan>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
 <20200624145721.2590327-8-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200624145721.2590327-8-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 03:57:20PM +0100, Lee Jones wrote:
> unsigned ints 'sources' and 'bank' cannot be less than LM3630A_SINK_0 (0)
> and LM3630A_BANK_0 (0) respecitively, so change the logic to only check
> for thier two possible valid values.
> 
> Fixes W=1 warnings:
> 
>  drivers/video/backlight/lm3630a_bl.c: In function ‘lm3630a_parse_led_sources’:
>  drivers/video/backlight/lm3630a_bl.c:394:18: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>  394 | if (sources[i] < LM3630A_SINK_0 || sources[i] > LM3630A_SINK_1)
>  | ^
>  drivers/video/backlight/lm3630a_bl.c: In function ‘lm3630a_parse_bank’:
>  drivers/video/backlight/lm3630a_bl.c:415:11: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>  415 | if (bank < LM3630A_BANK_0 || bank > LM3630A_BANK_1)
>  | ^
> 
> Cc: <stable@vger.kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Daniel Jeong <gshark.jeong@gmail.com>
> Cc: LDD MLP <ldd-mlp@list.ti.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>


> ---
>  drivers/video/backlight/lm3630a_bl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
> index ee320883b7108..e88a2b0e59046 100644
> --- a/drivers/video/backlight/lm3630a_bl.c
> +++ b/drivers/video/backlight/lm3630a_bl.c
> @@ -391,7 +391,7 @@ static int lm3630a_parse_led_sources(struct fwnode_handle *node,
>  		return ret;
>  
>  	for (i = 0; i < num_sources; i++) {
> -		if (sources[i] < LM3630A_SINK_0 || sources[i] > LM3630A_SINK_1)
> +		if (sources[i] != LM3630A_SINK_0 && sources[i] != LM3630A_SINK_1)
>  			return -EINVAL;
>  
>  		ret |= BIT(sources[i]);
> @@ -412,7 +412,7 @@ static int lm3630a_parse_bank(struct lm3630a_platform_data *pdata,
>  	if (ret)
>  		return ret;
>  
> -	if (bank < LM3630A_BANK_0 || bank > LM3630A_BANK_1)
> +	if (bank != LM3630A_BANK_0 && bank != LM3630A_BANK_1)
>  		return -EINVAL;
>  
>  	led_sources = lm3630a_parse_led_sources(node, BIT(bank));
> -- 
> 2.25.1
> 
