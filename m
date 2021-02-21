Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A4A320BA8
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 17:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhBUQMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 11:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhBUQMg (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 21 Feb 2021 11:12:36 -0500
X-Greylist: delayed 569 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 21 Feb 2021 08:11:55 PST
Received: from saturn.retrosnub.co.uk (saturn.retrosnub.co.uk [IPv6:2a00:1098:86::1:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A05C061574
        for <Stable@vger.kernel.org>; Sun, 21 Feb 2021 08:11:55 -0800 (PST)
Received: from archlinux (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        by saturn.retrosnub.co.uk (Postfix; Retrosnub mail submission) with ESMTPSA id 1EC029E008E;
        Sun, 21 Feb 2021 16:01:41 +0000 (GMT)
Date:   Sun, 21 Feb 2021 16:01:35 +0000
From:   Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
To:     linux-iio@vger.kernel.org
Cc:     Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: Re: [PATCH] iio:adc:stm32-adc: Add HAS_IOMEM dependency
Message-ID: <20210221160135.5437e083@archlinux>
In-Reply-To: <20210124195034.22576-1-jic23@kernel.org>
References: <20210124195034.22576-1-jic23@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 24 Jan 2021 19:50:34 +0000
Jonathan Cameron <jic23@kernel.org> wrote:

> From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> Seems that there are config combinations in which this driver gets enabled
> and hence selects the MFD, but with out HAS_IOMEM getting pulled in
> via some other route.  MFD is entirely contained in an
> if HAS_IOMEM block, leading to the build issue in this bugzilla.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=209889
> 
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Applied to the fixes-togreg branch of iio.git.

Thanks

Jonathan

> ---
>  drivers/iio/adc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index bf7d22fa4be2..6605c263949c 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -923,6 +923,7 @@ config STM32_ADC_CORE
>  	depends on ARCH_STM32 || COMPILE_TEST
>  	depends on OF
>  	depends on REGULATOR
> +	depends on HAS_IOMEM
>  	select IIO_BUFFER
>  	select MFD_STM32_TIMERS
>  	select IIO_STM32_TIMER_TRIGGER

