Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2848C3F16E5
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 11:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbhHSKAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 06:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbhHSKAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 06:00:09 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6045FC061756
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 02:59:33 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k8so8186982wrn.3
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 02:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xtunD2GxO/8/vmP/JIhc/Q4AXeVK5pzMLPGPI0WktNo=;
        b=ULGrdUlLjfonZ9gXeFBZL1uRfDlE0SqvpHLPwuyDblWuDL6n7yMagTIZsgstsvo+qS
         r2ts6k9+C4pXp8Sju0Va2gPM+ieguklAU4b9hD9AslIY+NgmsgLibrWbQ1LiZ0Qsk3rH
         F4JEmqWQWSRFqw+Y6qDkS74exs7H14uKfiSDwl74vGXJMZfBp4C9GqgKKDJXSQ/hupfn
         oURWGu3f4FfnLlPSov6wUBSXVnpJHIfk9oWzJA427L1hiGyatYZ/YU553dT38q8yqgAn
         d+ajJsiH6+zxUGDU4WyG1Nhdmg9w9s1BBQAhxibNshdCVsKc6AhrRapWUea8HkBS/5Ng
         uvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xtunD2GxO/8/vmP/JIhc/Q4AXeVK5pzMLPGPI0WktNo=;
        b=Z2MlipwA+W2T6NuU5huZivskl40lKjHRyFU24HA/qoG866YZiT4xYXAyrozp84LzkB
         q/YPctdqhW7iVMbAxbxN84yWENC/onLnSWVFeYjWCD3cg7aruVLUwbmUtmd0bpc87lUB
         CFcfvLQLW8sAR24i9KZYtHkqwfj1takOB94bzMVSN6kI6iPzuZQk/zsr9Rt1RqIwoH1t
         ST5yWgNVNB/fWMqYkXuJG+Qicso0zEn3i8grEssVl2ndaKqqQboveAwo4K6AYAJxx7JS
         tDMGxGKPEUIPonVqkJL9uHqhCRzcNbhYheOi4wNSVZ7VBL7GTommIbjBsX7mG1+koGvi
         ejeQ==
X-Gm-Message-State: AOAM533ob9+YuX9rAnOxf4drt2hiFoBoXIl7bwuHy9vjyF9W39T5KLXZ
        CEoI6JZndAclMTtJoevDaDtOpg==
X-Google-Smtp-Source: ABdhPJyutlGQ6Z6gY20AlGAJAhV+LbVsUxEHKzeIqK38emB1LhIfllep0G5vUV02GJWRWcT0Ec9kgQ==
X-Received: by 2002:a5d:4290:: with SMTP id k16mr2749296wrq.224.1629367172037;
        Thu, 19 Aug 2021 02:59:32 -0700 (PDT)
Received: from google.com ([2.31.167.59])
        by smtp.gmail.com with ESMTPSA id z5sm7338694wmp.26.2021.08.19.02.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 02:59:31 -0700 (PDT)
Date:   Thu, 19 Aug 2021 10:59:29 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Jingoo Han <jingoohan1@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-pwm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] backlight: pwm_bl: Improve bootloader/kernel device
 handover
Message-ID: <YR4rgXdHqLzpYfEY@google.com>
References: <20210722144623.1572816-1-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210722144623.1572816-1-daniel.thompson@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Jul 2021, Daniel Thompson wrote:

> Currently there are (at least) two problems in the way pwm_bl starts
> managing the enable_gpio pin. Both occur when the backlight is initially
> off and the driver finds the pin not already in output mode and, as a
> result, unconditionally switches it to output-mode and asserts the signal.
> 
> Problem 1: This could cause the backlight to flicker since, at this stage
> in driver initialisation, we have no idea what the PWM and regulator are
> doing (an unconfigured PWM could easily "rest" at 100% duty cycle).
> 
> Problem 2: This will cause us not to correctly honour the
> post_pwm_on_delay (which also risks flickers).
> 
> Fix this by moving the code to configure the GPIO output mode until after
> we have examines the handover state. That allows us to initialize
> enable_gpio to off if the backlight is currently off and on if the
> backlight is on.
> 
> Reported-by: Marek Vasut <marex@denx.de>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: stable@vger.kernel.org
> Acked-by: Marek Vasut <marex@denx.de>
> Tested-by: Marek Vasut <marex@denx.de>
> ---
>  drivers/video/backlight/pwm_bl.c | 54 +++++++++++++++++---------------
>  1 file changed, 28 insertions(+), 26 deletions(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
