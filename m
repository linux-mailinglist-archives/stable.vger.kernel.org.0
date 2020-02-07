Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F3F154FE7
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 02:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgBGBJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 20:09:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgBGBJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 20:09:52 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6297A20658;
        Fri,  7 Feb 2020 01:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581037791;
        bh=XPM/kzxANhudwH+w3QhnGesL/pdfe5ILq8c67EXOmOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uiFFYv1z020LCvPDL3Lx/NB3DDFySaOUSgeqTVrfIl9NQKPzrnEYj5qC1OiW6ZcjC
         sRMSw2ZcSXhDyI0OK6XtADGBkDMIEnROb/qEdL4/xH0O1X+4d/udVHiGrxUUmPwOAv
         IrMCeAIGrS0bu2p/Can9EPx22OyXXmkzMyaXxZrI=
Date:   Thu, 6 Feb 2020 20:09:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mirq-linux@rere.qmqm.pl, adrian.hunter@intel.com,
        ludovic.desroches@microchip.com, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci-of-at91: fix memleak on
 clk_get failure" failed to apply to 5.5-stable tree
Message-ID: <20200207010950.GQ31482@sasha-vm>
References: <1581016127158142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1581016127158142@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 08:08:47PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From a04184ce777b46e92c2b3c93c6dcb2754cb005e1 Mon Sep 17 00:00:00 2001
>From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
>Date: Thu, 2 Jan 2020 11:42:16 +0100
>Subject: [PATCH] mmc: sdhci-of-at91: fix memleak on clk_get failure
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>sdhci_alloc_host() does its work not using managed infrastructure, so
>needs explicit free on error path. Add it where needed.
>
>Cc: <stable@vger.kernel.org>
>Fixes: bb5f8ea4d514 ("mmc: sdhci-of-at91: introduce driver for the Atmel SDMMC")
>Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
>Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
>Acked-by: Adrian Hunter <adrian.hunter@intel.com>
>Link: https://lore.kernel.org/r/b2a44d5be2e06ff075f32477e466598bb0f07b36.1577961679.git.mirq-linux@rere.qmqm.pl
>Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

We're missing 3976656d67c1 ("mmc: sdhci-of-at91: rework clocks
management to support SAM9x60 device") on older kernels. I've fixed it
up and queued for 5.5-4.14. I don't think it applies to older kernels,
but happy to be proven otherwise.

-- 
Thanks,
Sasha
