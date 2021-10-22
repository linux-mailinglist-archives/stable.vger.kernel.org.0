Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E8C43735F
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 09:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhJVIBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 04:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbhJVIBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 04:01:04 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB31C061764
        for <stable@vger.kernel.org>; Fri, 22 Oct 2021 00:58:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id k7so180453wrd.13
        for <stable@vger.kernel.org>; Fri, 22 Oct 2021 00:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Fc3waf/OV9e1eiLWEqddx3c5PAReQqUJROoyD4tG+yY=;
        b=UiYR6y2wU9EIhRkr7kU+xSl9uayIP3BOBX5cqmbchs0/KHDXtCt9hQDNJlaaQeakqk
         BAlikhGhs3lg8tOmruMCtucsAsnlK0pl4yUPYNh9RO+yZdaUGL3qJCY/B1OeYOWkJDN8
         WC+WG/RK2WijjVrBY9BGaMwKLSVOwf/qvaAFGRWbUfeiacUlCyGnYJxTVTjl4Dcr765L
         5BHmaDQkT4GBAIvQUrB6Si4w+rNuQ4DSDiN7BqZeBoop9YIbhsfzqvtGVxVqrIe7NwxO
         eHuoMkDou5vaYqBQrQGsMV8mCWqnuex5pv2eI7a5tu6KFsacKo82i53FjIYtSSeyV6hD
         ztzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Fc3waf/OV9e1eiLWEqddx3c5PAReQqUJROoyD4tG+yY=;
        b=JHyF9YDljHR6A71vs8LWB5UqHKtmDQpqcWpHE3alczI3uo/UETGOT4g0fC6B/6xgGc
         A7H9IQALYD4k21CnupiF4IzUyafCq9j0o8Lz0PUNpuT8ppJhK/FlADiHSoQZ1muFGvIC
         jMSxoZu3i4B2/vQSaLzeCjROePL/BJ1Kr9xhNPh4CLM5OEfoc/ea2dcvciGSl0bTZshZ
         9m0D3gq7ChM1PsZKtvbYij9t9KEQgU9FFm4h5dJYVDIVIdIFViVlmEa/oT09WlYjEU1T
         b29UGC8JG1pYy4pEd0gAIa3pK+0KoWZWYtqCtsfWp9qz1ApUkZsEw8w39h4iT5plm9bS
         2LxQ==
X-Gm-Message-State: AOAM530JYHHl6twEyh8PL9OJOTCQQq49EVP3Ddyf99YMfAfDl30dQBL8
        0fzJQC76Q0pQKHYPyPzpSdGzO54x8kM=
X-Google-Smtp-Source: ABdhPJyFBYjAIMVlWRAAXYVgFlVTwX8bYHIpiZ7ehdek8806xsov4rObsHGvBnoSCJ5TY78DvicyPg==
X-Received: by 2002:adf:ba87:: with SMTP id p7mr13843439wrg.282.1634889525156;
        Fri, 22 Oct 2021 00:58:45 -0700 (PDT)
Received: from google.com ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id f17sm1995360wmf.44.2021.10.22.00.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 00:58:44 -0700 (PDT)
Date:   Fri, 22 Oct 2021 08:58:42 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Message-ID: <YXJvMscD129bLvGN@google.com>
References: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
 <YWV4bnbn7VXjYWWy@google.com>
 <FC366D8C-0360-49B2-B641-5A3FD50E3398@live.com>
 <YWg/1zcfMN2+vuiJ@smile.fi.intel.com>
 <YXFL05vXfoCV/Go/@google.com>
 <054143A2-888C-42DF-947A-8CEAFF155292@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <054143A2-888C-42DF-947A-8CEAFF155292@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Oct 2021, Aditya Garg wrote:

> 
> From 76d8253d90233b2c2d3fbc82355c603bf0eb9964 Mon Sep 17 00:00:00 2001
> From: Orlando Chamberlain <redecorating@protonmail.com>
> Date: Fri, 1 Oct 2021 13:30:19 +0530
> Subject: [PATCH] Add support for MacBookPro16,2 UART
> Cc: stable@vger.kernel.org

What is this?

These headers should not be part of the patch.

How are you submitting this?
What tools are you using?
Did you read the documents I sent you (see below)?

> Added 8086:38a8 to the intel_lpss_pci driver. It is an Intel Ice Lake PCH-N UART controller present on the MacBookPro16,2.

This line is too long.

> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> ---
>  drivers/mfd/intel-lpss-pci.c | 2 ++
>  1 file changed, 2 insertions(+)

This diff looks better.

> diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
> index c54d19fb1..33d5043fd 100644
> --- a/drivers/mfd/intel-lpss-pci.c
> +++ b/drivers/mfd/intel-lpss-pci.c
> @@ -253,6 +253,8 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
>  	{ PCI_VDEVICE(INTEL, 0x34ea), (kernel_ulong_t)&bxt_i2c_info },
>  	{ PCI_VDEVICE(INTEL, 0x34eb), (kernel_ulong_t)&bxt_i2c_info },
>  	{ PCI_VDEVICE(INTEL, 0x34fb), (kernel_ulong_t)&spt_info },
> +	/* ICL-N*/
> +	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&bxt_uart_info },
>  	/* TGL-H */
>  	{ PCI_VDEVICE(INTEL, 0x43a7), (kernel_ulong_t)&bxt_uart_info },
>  	{ PCI_VDEVICE(INTEL, 0x43a8), (kernel_ulong_t)&bxt_uart_info },
> 
> > On 21-Oct-2021, at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > On Thu, 14 Oct 2021, andriy.shevchenko@linux.intel.com wrote:
> > 
> >> On Thu, Oct 14, 2021 at 04:15:05AM +0000, Aditya Garg wrote:
> >> 
> >> Entire message looks like a mess. Are you sure you are using proper tools
> >> for sending it?
> > 
> > Agreed.
> > 
> > I can't apply this until it's submitted properly.
> > 
> > - Please read Documentation/process/submitting-patches.rst
> > - Please read Documentation/process/coding-style.rst
> > 
> > If you have any questions, please reach out.  We're happy to help.
> > 

This quoted text can't be part of a submitted patch.

Please submit the patch on its own, as a new thread, using the correct
tooling (provided mostly by the Git package (i.e. `git format-patch`
and `git send-email`).

If you're stuck, or there is something you do not understand, please
ask.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
