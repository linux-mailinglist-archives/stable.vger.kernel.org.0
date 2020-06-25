Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F33A209BE8
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 11:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbgFYJ2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 05:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgFYJ2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 05:28:32 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3190C061795
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 02:28:31 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so2094508wrw.1
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 02:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wZ3xkBP5w3XYMTvLh2QI28P63jV7LX3p1gxwcLJzIps=;
        b=C6ixCOK/9LDYiY0Iwdj0/BoXa6w1A+fVDp3C9NTV870s6gG/5+o7RFK86X+TVtVjXO
         q2Fd7XtY4cMBU7LnlK1fi0oh+7mNOpseqKEEx36NJDl9hPhjbJG0IlU8uohfhCtMDDmA
         qI9QC4KmUOG0sd4/G44kphZaMTKwFcfcEdkm0zc+uLUEmRyccAU6b1/6tbokYvVESB5D
         biufTUOLOJGcIHM127C7NlQGB1lzC3AI2IWv+5KLP9NFdARQ+/N3HC0NNULNu+xMmNsU
         tF9Tf7mDvqc8a6Uvm+GRJhJgfjdseGRLI2jYuGgtAk2BrNA0qS29Wnmqa6LG7O5ktqYm
         C87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZ3xkBP5w3XYMTvLh2QI28P63jV7LX3p1gxwcLJzIps=;
        b=eRkCKhVd50MhzxpdsFCEKMEyA97MSzjQWhwYAfm6VN803oiEdO/+ZLuC3Sq9rgc913
         W70v7zMbSMyg116e2JfjfI2e+drCmxeRMpKeFJM0huI6PGd9WkSObDzZCriYZWJNrIWl
         EDCWEn7jBnwWHiZVZDG26y5qdamIfiPeVq7iVjrEmiourr1uVOXd3ZFRLku6ziBxiEKk
         R6KlsEsnGBTQgiI94XaM6kEp6F6MUvsS7O7xjtr04bN+V5UL3YK7vZqnpw4+dKzPcRyg
         WGjflZkHrSHOIe8T1BJ3bvKSThXGcFb+ZuWaLB9HpW7SqYn20kQnr/Sw0WiCQGPYI8ae
         AnNw==
X-Gm-Message-State: AOAM5305wyMz3Qr+zGKBWTJskOo+EewbjqZR4FALrCciqHsIRUP0zFjT
        8bi0bzmyh2l+gCxVd/By01PJFQ==
X-Google-Smtp-Source: ABdhPJx8YLsfpqLIR1nhVjd+aDujzMmrOlHvE8k8+Jx+sWaM87JAC9/9z7769ytqaaAAvW8mDEkHGw==
X-Received: by 2002:adf:c44d:: with SMTP id a13mr14655476wrg.205.1593077310376;
        Thu, 25 Jun 2020 02:28:30 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id g16sm26802137wrh.91.2020.06.25.02.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 02:28:29 -0700 (PDT)
Date:   Thu, 25 Jun 2020 10:28:28 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jingoohan1@gmail.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jamey Hicks <jamey.hicks@hp.com>,
        Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 2/8] backlight: lcd: Add missing kerneldoc entry for
 'struct device parent'
Message-ID: <20200625092828.2cpdofvor6ehhbwh@holly.lan>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
 <20200624145721.2590327-3-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624145721.2590327-3-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 03:57:15PM +0100, Lee Jones wrote:
> This has been missing since the conversion to 'struct device' in 2007.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Jamey Hicks <jamey.hicks@hp.com>
> Cc: Andrew Zabolotny <zap@homelink.ru>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>


> ---
>  drivers/video/backlight/lcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
> index 78b0333586258..db56e465aaff3 100644
> --- a/drivers/video/backlight/lcd.c
> +++ b/drivers/video/backlight/lcd.c
> @@ -179,6 +179,7 @@ ATTRIBUTE_GROUPS(lcd_device);
>   * lcd_device_register - register a new object of lcd_device class.
>   * @name: the name of the new object(must be the same as the name of the
>   *   respective framebuffer device).
> + * @parent: pointer to the parent's struct device .
>   * @devdata: an optional pointer to be stored in the device. The
>   *   methods may retrieve it by using lcd_get_data(ld).
>   * @ops: the lcd operations structure.
> -- 
> 2.25.1
> 
