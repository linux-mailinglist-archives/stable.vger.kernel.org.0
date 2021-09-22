Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBA24142BE
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 09:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhIVHgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 03:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbhIVHgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 03:36:04 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDACDC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 00:34:33 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u18so3977895wrg.5
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 00:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ia4rl1E960Y9OxPRW1u1XQZaGVgTW+fVkEu7wRUVsc8=;
        b=vbwKhiAhXnkVhBQ5uacbJBGzL52Xsf2Z8xnzYCoFeomOC7XnCXOHEipjbL61Xf+PHP
         EI7Swacths0dsvn7eDcc9OWz+IUIPx9KCqqMNyDTUWlvsW0SZFVCdnubcmJ4mp21uiXG
         1jtv9KUQyZ9CPlG1LwbEhi8OpP/1xT9LO+9GHrzYcLRxHolnYtU9A1jiWVv8vJQuQ+KK
         NenzVRMGKxroeB5rIJmGflm7DfZ6MkRzVk3UFFAv4hjgDFPKSU81uyHmnrcAJqP1A4kp
         S6XFHXIjqguI5fuEQzm97lhi5HJfOujru0e26QLOMaLgVYbp2+7BetGO9a4OD9dWSHTR
         jEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ia4rl1E960Y9OxPRW1u1XQZaGVgTW+fVkEu7wRUVsc8=;
        b=qr3XwC8HiJVlM7r0YCJWYsVEK8zPhKY736sQZ+XIxZ/84r5WFY09106/aBHJP8MufX
         S91sfKpOWT+2hnfxpQtoItKZiu79UAxh4MbJM5FSGBucaW9/X3yiCzDIcCHbUN+Zfnd4
         QOjEAUsxoOWIXKNbAzboAhBC3OLMIRy1RlYbaebiP4eYi+t59euWY9CX9WGKYpCYJO8J
         itLvG/8MjXol6aivZPnND5LmeYPnrCwpdbm+49uy51DR0mMvqXsU3gjpx87V/IYS6dDB
         hgBL6E8EoyMuLrINd28gkL+b1UTiMZwdmPqSrwS5ZN1alz5FVcSHfkvcY4reCPUzho3s
         cFWw==
X-Gm-Message-State: AOAM531R8+m5syrcrqP3xm7CCsSCvns9daKbbLja0y6i1vR5pFJ96De1
        T/rUIoMP3iLqCpO3ubHLSyIPMw==
X-Google-Smtp-Source: ABdhPJzl0zTieAnuV9v47WlPCCV7JCVLsZk2eL7iGtWbkEmCreXcrvH8CbII+7YdcNbz/Dv01II60g==
X-Received: by 2002:adf:f50b:: with SMTP id q11mr17467887wro.306.1632296072458;
        Wed, 22 Sep 2021 00:34:32 -0700 (PDT)
Received: from google.com ([95.148.6.233])
        by smtp.gmail.com with ESMTPSA id q7sm1311198wru.56.2021.09.22.00.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 00:34:32 -0700 (PDT)
Date:   Wed, 22 Sep 2021 08:34:30 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Marek Vasut <marex@denx.de>
Cc:     dri-devel@lists.freedesktop.org,
        Noralf =?iso-8859-1?Q?Tr=F8nnes?= <noralf@tronnes.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        stable@vger.kernel.org,
        Meghana Madhyastha <meghana.madhyastha@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [RESEND][PATCH v2] video: backlight: Drop maximum brightness
 override for brightness zero
Message-ID: <YUrchlbucoa+znSl@google.com>
References: <20210921173506.19675-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210921173506.19675-1-marex@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Sep 2021, Marek Vasut wrote:

> The note in c2adda27d202f ("video: backlight: Add of_find_backlight helper
> in backlight.c") says that gpio-backlight uses brightness as power state.
> This has been fixed since in ec665b756e6f7 ("backlight: gpio-backlight:
> Correct initial power state handling") and other backlight drivers do not
> require this workaround. Drop the workaround.
> 
> This fixes the case where e.g. pwm-backlight can perfectly well be set to
> brightness 0 on boot in DT, which without this patch leads to the display
> brightness to be max instead of off.
> 
> Fixes: c2adda27d202f ("video: backlight: Add of_find_backlight helper in backlight.c")
> Acked-by: Noralf Trønnes <noralf@tronnes.org>
> Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: <stable@vger.kernel.org> # 5.4+
> Cc: <stable@vger.kernel.org> # 4.19.x: ec665b756e6f7: backlight: gpio-backlight: Correct initial power state handling
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Meghana Madhyastha <meghana.madhyastha@gmail.com>
> Cc: Noralf Trønnes <noralf@tronnes.org>
> Cc: Sean Paul <seanpaul@chromium.org>
> Cc: Thierry Reding <treding@nvidia.com>
> ---
> V2: Add AB/RB, CC stable
> ---
>  drivers/video/backlight/backlight.c | 6 ------
>  1 file changed, 6 deletions(-)

Applied with some changes to the sign-off block, thanks.

> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 537fe1b376ad7..fc990e576340b 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -688,12 +688,6 @@ static struct backlight_device *of_find_backlight(struct device *dev)
>  			of_node_put(np);
>  			if (!bd)
>  				return ERR_PTR(-EPROBE_DEFER);
> -			/*
> -			 * Note: gpio_backlight uses brightness as
> -			 * power state during probe
> -			 */
> -			if (!bd->props.brightness)
> -				bd->props.brightness = bd->props.max_brightness;
>  		}
>  	}
>  

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
