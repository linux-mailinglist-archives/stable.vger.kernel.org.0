Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226EE199E49
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 20:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCaSoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 14:44:02 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:39916 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCaSoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 14:44:02 -0400
Received: by mail-ua1-f65.google.com with SMTP id z7so3696521uai.6
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 11:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iDu66r+bFfQv6BzOxzfeQ3KmMr4ATT20JEufu/QQzgY=;
        b=FFYQDTnXtUfJbiaOkhxPP0HStX682l+8oUeau/hKtssU5vruS5BWKqGIfeBv2ugyJ9
         o3nE3ydeoOyYjG4+dNHNifg8sTSVKTadXee7gQKc1gma7Zmb4y+4W26JTMxNS8vQiIse
         1T1UPDb3VKIOvku5vkqAPvUmItYxTcfqw19AUpKRM31Dv/xQj3V9bgIr0JWq3BF0QS/7
         LKc2L2Sr5Fo4KZwcihKQODFvK4fbktem0AMzHxL0EeD3E3afZsELBrzhh/WwpLcZ5VL4
         oNf1DMJGHSvYH5yriXeNwycvr8MjiSC+SJ+8qiI3ZP8lh+NXfXPdSC2L5TaBcbBkpN16
         Ggrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iDu66r+bFfQv6BzOxzfeQ3KmMr4ATT20JEufu/QQzgY=;
        b=SFicS56E+ZfNIDSV+HFFkRgjei0+wokeiCTSDWnfMFPxD0vHuRtnm8ULbCM6B8aT1U
         bi1JP6ff45SuVPEDCY1sz9kavhxONaGF46Eq2mc2kWWLByMMaF8doARNFGYq9lvGkxGv
         bSfmXxfvYs+D9cUH67iBwU9yVJwtSNLBEg1wOplgPLIwlj86dtt6vdd81NYAQTn0H7Aw
         7bTN6spVjnlInUixy3T5+CQMPbs75mCrbVqAZ71Yj7bhsL3iBb6hJSNVtTfXwM3ia01n
         pFWROenQLQcL2rGt32e4ttNBxqgfsjj1TzxH8hbfxHY23NSCuI3UcC+6b+YAaF84jLNA
         HByw==
X-Gm-Message-State: AGi0PuagLnuzxZ2s8NhzeFUfLTdebKFvWs3Y5dkM4D4Y0fETxXelvYYW
        WXQR6+wZ+fsg1h9wJYnSZCzRn09XpSb2iE2KPAypTPDr
X-Google-Smtp-Source: APiQypLfDqi2Q6+gYXMm4hqkY2s19bcLgtHqU44KC9Nv2fGNaEX56mLLADoGMSkl6WDZ3jMdPP/9kmzpfqBzxWH6dsA=
X-Received: by 2002:ab0:6204:: with SMTP id m4mr13326224uao.15.1585680241018;
 Tue, 31 Mar 2020 11:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <158523473532132@kroah.com>
In-Reply-To: <158523473532132@kroah.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 31 Mar 2020 20:43:25 +0200
Message-ID: <CAPDyKFr0Em0-8RX3TnuRTiEEX6qs3Lu+SxFufmv5Mx6_6606=g@mail.gmail.com>
Subject: Re: patch "driver core: platform: Initialize dma_parms for platform
 devices" added to char-misc-testing
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 26 Mar 2020 at 15:58, <gregkh@linuxfoundation.org> wrote:
>
>
> This is a note to let you know that I've just added the patch titled
>
>     driver core: platform: Initialize dma_parms for platform devices
>
> to my char-misc git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
> in the char-misc-testing branch.
>
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>
> The patch will be merged to the char-misc-next branch sometime soon,
> after it passes testing, and the merge window is open.
>
> If you have any questions about this process, please let me know.

Greg, would you mind dropping this one and the other patch for the amba bus?

I just sent out a new version (v2), addressing an issue for the
platform device when used for OF based platforms.

If you prefer to not rebase/drop patches from your branch, I can send
an incremental change on top instead, whatever you prefer.

Kind regards
Uffe

>
>
> From 7c8978c0837d40c302f5e90d24c298d9ca9fc097 Mon Sep 17 00:00:00 2001
> From: Ulf Hansson <ulf.hansson@linaro.org>
> Date: Wed, 25 Mar 2020 12:34:06 +0100
> Subject: driver core: platform: Initialize dma_parms for platform devices
>
> It's currently the platform driver's responsibility to initialize the
> pointer, dma_parms, for its corresponding struct device. The benefit with
> this approach allows us to avoid the initialization and to not waste memory
> for the struct device_dma_parameters, as this can be decided on a case by
> case basis.
>
> However, it has turned out that this approach is not very practical.  Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
>
> For these reasons, let's do the initialization from the common platform bus
> at the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().
>
> Cc: <stable@vger.kernel.org>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Ludovic Barre <ludovic.barre@st.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Link: https://lore.kernel.org/r/20200325113407.26996-2-ulf.hansson@linaro.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/platform.c         | 1 +
>  include/linux/platform_device.h | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index b5ce7b085795..46abbfb52655 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -512,6 +512,7 @@ int platform_device_add(struct platform_device *pdev)
>                 pdev->dev.parent = &platform_bus;
>
>         pdev->dev.bus = &platform_bus_type;
> +       pdev->dev.dma_parms = &pdev->dma_parms;
>
>         switch (pdev->id) {
>         default:
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 041bfa412aa0..81900b3cbe37 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -25,6 +25,7 @@ struct platform_device {
>         bool            id_auto;
>         struct device   dev;
>         u64             platform_dma_mask;
> +       struct device_dma_parameters dma_parms;
>         u32             num_resources;
>         struct resource *resource;
>
> --
> 2.26.0
>
>
