Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E0E211395
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgGATdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726895AbgGATdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:33:22 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7D0D20853;
        Wed,  1 Jul 2020 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593632002;
        bh=N2f6dNa0zm1G+CzQof96J68S69txegg3zJ2gyRzibb8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=pW9U5X9NkBY3GnCJF7xpaaciCydoHDRmVSHsca4O8X3o0duYNQ3vhwRSNtkmqld7P
         41oVv0qheLqGmPfI02FQWLtCV0ENwfcvl2h2nwON39bdTR6wiNTAw4NuzsepSkqzJJ
         k6eMlvmmIdyEBFwtMb2hRayNJY365v5ILvN45zK4=
Date:   Wed, 01 Jul 2020 19:33:21 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 10/10] mfd: altera-sysmgr: Supply descriptions for 'np' and 'property' function args
In-Reply-To: <20200625064619.2775707-11-lee.jones@linaro.org>
References: <20200625064619.2775707-11-lee.jones@linaro.org>
Message-Id: <20200701193321.D7D0D20853@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.

v5.7.6: Build OK!
v5.4.49: Build OK!
v4.19.130: Failed to apply! Possible dependencies:
    51908d2e9b7c7 ("mfd: stpmic1: Add STPMIC1 driver")
    f36e789a1f8d0 ("mfd: altera-sysmgr: Add SOCFPGA System Manager")

v4.14.186: Failed to apply! Possible dependencies:
    51908d2e9b7c7 ("mfd: stpmic1: Add STPMIC1 driver")
    f36e789a1f8d0 ("mfd: altera-sysmgr: Add SOCFPGA System Manager")

v4.9.228: Failed to apply! Possible dependencies:
    51908d2e9b7c7 ("mfd: stpmic1: Add STPMIC1 driver")
    937d3a0af521e ("mfd: Add support for Allwinner SoCs ADC")
    d0f949e220fdf ("mfd: Add STM32 Timers driver")
    f36e789a1f8d0 ("mfd: altera-sysmgr: Add SOCFPGA System Manager")

v4.4.228: Failed to apply! Possible dependencies:
    51908d2e9b7c7 ("mfd: stpmic1: Add STPMIC1 driver")
    8ce064bfe7c8c ("MAINTAINERS: Add Altera Arria10 System Resource Chip")
    937d3a0af521e ("mfd: Add support for Allwinner SoCs ADC")
    9787f5e28b507 ("mfd: altr_a10sr: Add Altera Arria10 DevKit System Resource Chip")
    b25c6b7d2801f ("mfd: act8945a: Add Active-semi ACT8945A PMIC MFD driver")
    d0f949e220fdf ("mfd: Add STM32 Timers driver")
    f36e789a1f8d0 ("mfd: altera-sysmgr: Add SOCFPGA System Manager")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
