Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955B742A3B5
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 13:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhJLMAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 08:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbhJLMAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 08:00:44 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BD4C061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 04:58:42 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r7so66245921wrc.10
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 04:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5aF13KUeOm2pIzPATvRG0B/rCqwCtM2yOqiLIhyhJ7A=;
        b=vM7WHiMo1ORkhyrgGGUitHYJ2DzlJdh0GvlWeJugpyv4d5P/mfKPkCVUAZgBoAfeav
         0lx1n2C5xwchPmYB/ZKW2TGESP9ptouYqUnF6YmwsPrOg54JKHCIsBN/5XgjbV+HYkdo
         3blaYRakTB8C8CjG/vOqowYtc7MwMvotN6+9tKXt1CdREdS61qyJahSzUoIGSKALNdy8
         RVM8bbBmsaeXUv4w7ry/MWHSZho+pMvMIN2H6DpZuAUyr+/rjy7gysEDfyxGSYx2NcY5
         yTG4vfUpmoz7l6VndRQVW8xnuxZnPPzIqShAMGWEDS/Q1KZ5ksiib4K51/nPuhxwba0c
         5f3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5aF13KUeOm2pIzPATvRG0B/rCqwCtM2yOqiLIhyhJ7A=;
        b=wIXA2u0bB6SbZlYn+mSC2WkWiNYWqJGhyUoplUDX0d2bxa6iBYGGNcRXauKfYj0u6/
         TnhA5g0Ekx3IOQCI09+BaOOSZeBXLNLNsbbE/58lQMpTPAbPRbIl51vVDbrcHx6C464S
         m9NOI0fu3nZF1jY0umNzfnsZYRuYS2jGljz9eMqDejQhKJCX0MUsyUwecdBev9Ju7+G/
         gwLsk/x7oP5gLxE0eQk8cDf6pZnwi2kmdBRMXIrNJKpM8LV4gZ8vZGFJDHftCqiJuQBW
         HYXRbMqkqFh3FWdAz1XFuV54Ox+3895CpZD6Emr0bGdGM70ydx83zNxSoLbtZpLF1jw1
         vGfA==
X-Gm-Message-State: AOAM533eXtcBnqxnBBJoqABDbqHFYrAVOPUzywkInGUe8dAO3+C6tN0q
        gSELSlotZc4qvaGq4dHzg4LTBw==
X-Google-Smtp-Source: ABdhPJwkFGylsLFLaLuMldSxBX7XHA10bOR8rOTbvgyuwYDD4Wo85IvacM12prPV8eApc0hHu7qSLA==
X-Received: by 2002:a05:600c:4108:: with SMTP id j8mr5103043wmi.15.1634039921038;
        Tue, 12 Oct 2021 04:58:41 -0700 (PDT)
Received: from google.com ([95.148.6.175])
        by smtp.gmail.com with ESMTPSA id v3sm10618100wrg.23.2021.10.12.04.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 04:58:40 -0700 (PDT)
Date:   Tue, 12 Oct 2021 12:58:38 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Message-ID: <YWV4bnbn7VXjYWWy@google.com>
References: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 05 Oct 2021, Aditya Garg wrote:

> Added 8086:38a8 to the intel_lpss_pci driver. It is an Intel Ice Lake
> PCH-N UART controler present on the MacBookPro16,2.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Orlando Chamberlain <redecorating@protonmail.com>

Who is the author of this patch?

Why hasn't the submitter signed it off?

> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> v3->v4: reviewed-by line
>  
> drivers/mfd/intel-lpss-pci.c
>  | 2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff

This is not a format I recognise.

Did you use `git send-email` to submit this?

>  --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
> index c54d19fb184c..a872b4485eac 100644
> --- a/drivers/mfd/intel-lpss-pci.c
> +++ b/drivers/mfd/intel-lpss-pci.c
> 
> @@ -253,6 +253,8 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
> 
>  	{ PCI_VDEVICE(INTEL, 0x34ea), (kernel_ulong_t)&bxt_i2c_info },
>  	{ PCI_VDEVICE(INTEL, 0x34eb), (kernel_ulong_t)&bxt_i2c_info },
>  	{ PCI_VDEVICE(INTEL, 0x34fb), (kernel_ulong_t)&spt_info },
> 
> +	/* ICL-N */
> +	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&bxt_uart_info },
> 
>  	/* TGL-H */
>  	{ PCI_VDEVICE(INTEL, 0x43a7), (kernel_ulong_t)&bxt_uart_info },
>  	{ PCI_VDEVICE(INTEL, 0x43a8), (kernel_ulong_t)&bxt_uart_info },

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
