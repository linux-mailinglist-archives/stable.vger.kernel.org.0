Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F360B211C03
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 08:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgGBGgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 02:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGBGgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 02:36:01 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D789C08C5DC
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:36:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r12so26628960wrj.13
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 23:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jCQkFD83b8Tutn+WMP/3bAr1jQFc8WLuHymNCikYf+w=;
        b=OGHagwaEDmXjwiuEwkrgka40TvvS/Z8cVsZp26tE0lPRCpofEMfGBhFgEESZr3hlOX
         UUiVHFYiXra6K/ZCeS2lntkPt76vKzvu049r9WeVABmdIS/fbhzrtfK4PQtdEbhsjBMJ
         obPsVaLs95zH9XtpDi3fH2LNuerDKi5ABYdmPJW5dHVyoAi/7iC2QBB5h9Hg0aQ9ojJj
         pMAO/d18ea0vRbTEXZjh57cw6DxOBTpO8gKKzW31VjHTg4Sw0QWkXa44OjSpKKVmwHYh
         dFPt7chiln9jau4aMRlHx3XJ2usXyHqtjv95pQMJE2t9KReAXCHIMOzb1OKRBdI2XVoj
         p7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jCQkFD83b8Tutn+WMP/3bAr1jQFc8WLuHymNCikYf+w=;
        b=DEs9m+pvPCrQrWyIyW7j0aaivqh42WMtR5W22sY/DZSrpkZl6TwE4VHjtpXXtfYhR7
         BsGa3HI3auOSsFWFmvAK6LIj8OkrtJEq1FkivzrvyuDoCtlnt1AuMJjyTGH7aHuHrLe5
         SYE4S/OjyuE0m+7cruAI4nzW664rJPmEz/y7A2UhqoJfwHTAR6rxq50pYYiuhdfs2x9d
         1yj9rmP87ZFozy8ct2AuwnbyCGt7IvBo+Teanwde7JolrDS5daAgxJ+s5wDBooLsxFXC
         LozYL2gJcGggO03OSaE0j7BAFVHc01LcikGGVuRCw/TBNGfh8Dzzk9imGpixGwP4Z2NW
         2DCg==
X-Gm-Message-State: AOAM532eoDicBt56RjQIU75aZk74IgFfKw2ff1xXo+Rqcku4NiDGBuNf
        RphpNg3xiKxcSCL9sGLLIoJmSQ==
X-Google-Smtp-Source: ABdhPJzEfamNDw2ogN1uCJXh+AgmrsJsL6ijdyGCVQFyvPE8L65x+fNyVfR41z6f4AR9rlYIDcRbkA==
X-Received: by 2002:adf:ee0b:: with SMTP id y11mr6743030wrn.360.1593671760000;
        Wed, 01 Jul 2020 23:36:00 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id m9sm9424650wml.45.2020.07.01.23.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 23:35:59 -0700 (PDT)
Date:   Thu, 2 Jul 2020 07:35:57 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Thor Thayer <thor.thayer@linux.intel.com>
Subject: Re: [PATCH 10/10] mfd: altera-sysmgr: Supply descriptions for 'np'
 and 'property' function args
Message-ID: <20200702063557.GL1179328@dell>
References: <20200625064619.2775707-11-lee.jones@linaro.org>
 <20200701193321.D7D0D20853@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200701193321.D7D0D20853@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Jul 2020, Sasha Levin wrote:

> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.
> 
> v5.7.6: Build OK!
> v5.4.49: Build OK!
> v4.19.130: Failed to apply! Possible dependencies:
>     51908d2e9b7c7 ("mfd: stpmic1: Add STPMIC1 driver")
>     f36e789a1f8d0 ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
> 
> v4.14.186: Failed to apply! Possible dependencies:
>     51908d2e9b7c7 ("mfd: stpmic1: Add STPMIC1 driver")
>     f36e789a1f8d0 ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
> 
> v4.9.228: Failed to apply! Possible dependencies:
>     51908d2e9b7c7 ("mfd: stpmic1: Add STPMIC1 driver")
>     937d3a0af521e ("mfd: Add support for Allwinner SoCs ADC")
>     d0f949e220fdf ("mfd: Add STM32 Timers driver")
>     f36e789a1f8d0 ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
> 
> v4.4.228: Failed to apply! Possible dependencies:
>     51908d2e9b7c7 ("mfd: stpmic1: Add STPMIC1 driver")
>     8ce064bfe7c8c ("MAINTAINERS: Add Altera Arria10 System Resource Chip")
>     937d3a0af521e ("mfd: Add support for Allwinner SoCs ADC")
>     9787f5e28b507 ("mfd: altr_a10sr: Add Altera Arria10 DevKit System Resource Chip")
>     b25c6b7d2801f ("mfd: act8945a: Add Active-semi ACT8945A PMIC MFD driver")
>     d0f949e220fdf ("mfd: Add STM32 Timers driver")
>     f36e789a1f8d0 ("mfd: altera-sysmgr: Add SOCFPGA System Manager")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Please drop it.

Greg indicated that these should not be bound for Stable.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
