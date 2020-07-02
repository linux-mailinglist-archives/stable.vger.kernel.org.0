Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36667211BF9
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 08:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgGBG2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 02:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGBG2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 02:28:51 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252F7C08C5DC
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:28:51 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so23652352wrw.1
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 23:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jCQkFD83b8Tutn+WMP/3bAr1jQFc8WLuHymNCikYf+w=;
        b=mKWkAyXewZEZnOTna5MEn54RJSrzCeMHT4RFOmf6zybQtHEtHBNxM1fg/d3wZYPHhO
         dcXlW/mOLWGEXsNn00XmM1Lmt1NUqFtJVRpDDUVcM3yuLdd7RSN/R1OAmsiaofkK9nzJ
         08rmCXu7dpoV8MA+0OFS9Tv8OpaFPV2Fqh6BkG5B6izCQ9/9a5L/Pk9JoZAO5EJRcM4L
         UfvznEs81QPynMTSWULmJT+kXoSFl8/KECF/FylYPtuvkdW5+vgoX+iyr+4UKVd3X9kZ
         opSFhpuhXcRQGwcfl76FG9MCrpAxkxXH7RrWDmjq51DTi1VUZnVUstdZamJ7mmr+nPmg
         96+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jCQkFD83b8Tutn+WMP/3bAr1jQFc8WLuHymNCikYf+w=;
        b=CaUktLKDFs67swU6H8z1NfnZtTBF5/B1zJRWFZWjk9JuU9cchcca8UXJvVd6M6ywvj
         Cv7s8aZi4MuMh0LPhQUr+LWi/QqH6j5xILmi+6RSDnQvmot7DxwDB528iJSSFT/Cltpo
         CR5Zy0mRX3qK9TOqLXi8xDcPlgf284C7DHbmgqeUSUdw2lf/Ejd3z3zI+CnqV7vZxsSH
         Yco6Pd93HLZJwXNUC5lVO0DMexh7/6f2RwbIviIsirmcxoU7xNITeJmLoVwpW+yIb6ih
         7K0FA1n4AmDV1zhlxHbpUL9KC2EaSLBMXt4CEyeMJQrBKSrDDeklxv8tO3L3Kp3HfS8w
         a5mQ==
X-Gm-Message-State: AOAM533Qj0gh8Rz7YgJ6MpmvZ5+V9Kz8LuRJ8Ien4vOlbRr40StPnJR1
        eFduOypUtiof9WRXy/2/9Af9Ig==
X-Google-Smtp-Source: ABdhPJyNY8z3/hUMig6bxMXp9IPqQqAaIUQPnJl/6+xb3OWV+NBYXC2pezBLPGqZPjnpGpOuT1lSjg==
X-Received: by 2002:a5d:5388:: with SMTP id d8mr29514405wrv.35.1593671328298;
        Wed, 01 Jul 2020 23:28:48 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id w12sm10112507wrm.79.2020.07.01.23.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 23:28:47 -0700 (PDT)
Date:   Thu, 2 Jul 2020 07:28:45 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Thor Thayer <thor.thayer@linux.intel.com>
Subject: Re: [PATCH 04/10] mfd: altera-sysmgr: Fix physical address storing
 hacks
Message-ID: <20200702062845.GK1179328@dell>
References: <20200624150704.2729736-5-lee.jones@linaro.org>
 <20200701193325.097F920853@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200701193325.097F920853@mail.kernel.org>
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
