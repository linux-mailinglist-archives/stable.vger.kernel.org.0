Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD823209BD8
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 11:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390851AbgFYJYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 05:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390836AbgFYJYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 05:24:38 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998BCC061573
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 02:24:38 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so5181666wml.3
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 02:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EaOaR3l9HHxJyu97gRJLmzWQVTWMAcMmNEcB1lcmPNM=;
        b=l0NeXiakjdrXrLaBLIadefKz8F7+uyKt5t8RNkWbO405PGH/BZlG7ucw7IkjzZ9wK5
         pOFvA45fVJyNpEcvwKTJ4EG0KhFxxfY3pjjhc9JzCoT3kHSe1jOgmHODowQxUGG2FiKI
         yZKssraojrjtQZI6OtOlcrvQCZo1hNcJlSJyToTanRleQMoy+FooP2BSXH93BwrhKzi0
         +zryj2eO1f08xEkWifRc0qeLiBx2LzTlRzbY8yPbRKajweEMeycjGzvCiACtHFxLbRLK
         EgS2b5n252zk49kR0c4T7PyzpHEdZ1+hFE2Hkk25xROet1O/dW+JLLQjtJsCj4GzbSde
         JvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EaOaR3l9HHxJyu97gRJLmzWQVTWMAcMmNEcB1lcmPNM=;
        b=LeZ9yrzkV6J6BCGM9N5i/vCq2zkWLNy8BYkBW9pPOvSOSCnCJAE46wizmTDQaINoYS
         ZEqyOeWAYGTViGhq05P5VOSufJe4ud40gNF1wB/fxyaSDkSHe6rF80oDRmUdIkkCoJV2
         vy5koZZixytS9p8xtlig7uVWYfGez8mZsoV2HnpVFhjWx5ib39tK8WlPwO8/HtG+ki8s
         9qmq+xA4vxSVKn67uU8w6BviUbZaTjCi1uQKd2DNeIFlL4UD35UcDU2gclUKq5GUJsev
         0hqwgc0ur2d4/8CfsZRiItbmLGCsjHLgT/T4A9ghQ/j6zI8qYWby+EjRluJ1Ls2ZSHkI
         nQhg==
X-Gm-Message-State: AOAM533yYIA+maP6OA6o1P6CRMQTtq+sHcBIWXQSi123aNFZkwW6Cx5A
        fqoaqY8dNZgCep9xf914qS5g3w==
X-Google-Smtp-Source: ABdhPJxraWfUM9OicOYalfWG6fhp1iNyu1akGB9XabtzprNxns7odWMJc425dq+X61YgK7Y4EfXJrw==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr2381038wmb.61.1593077077320;
        Thu, 25 Jun 2020 02:24:37 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id 138sm12311705wma.23.2020.06.25.02.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 02:24:36 -0700 (PDT)
Date:   Thu, 25 Jun 2020 10:24:34 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jingoohan1@gmail.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/8] backlight: lms501kf03: Remove unused const variables
Message-ID: <20200625092434.szrdyt3sxmxmfajg@holly.lan>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
 <20200624145721.2590327-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200624145721.2590327-2-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 03:57:14PM +0100, Lee Jones wrote:
> W=1 kernel build reports:
> 
>  drivers/video/backlight/lms501kf03.c:96:28: warning: ‘seq_sleep_in’ defined but not used [-Wunused-const-variable=]
>  96 | static const unsigned char seq_sleep_in[] = {
>  | ^~~~~~~~~~~~
>  drivers/video/backlight/lms501kf03.c:92:28: warning: ‘seq_up_dn’ defined but not used [-Wunused-const-variable=]
>  92 | static const unsigned char seq_up_dn[] = {
>  | ^~~~~~~~~
> 
> Either 'seq_sleep_in' nor 'seq_up_dn' have been used since the
> driver first landed in 2013.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>


> ---
>  drivers/video/backlight/lms501kf03.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
> index 8ae32e3573c1a..c1bd02bb8b2ee 100644
> --- a/drivers/video/backlight/lms501kf03.c
> +++ b/drivers/video/backlight/lms501kf03.c
> @@ -89,14 +89,6 @@ static const unsigned char seq_rgb_gamma[] = {
>  	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>  };
>  
> -static const unsigned char seq_up_dn[] = {
> -	0x36, 0x10,
> -};
> -
> -static const unsigned char seq_sleep_in[] = {
> -	0x10,
> -};
> -
>  static const unsigned char seq_sleep_out[] = {
>  	0x11,
>  };
> -- 
> 2.25.1
> 
