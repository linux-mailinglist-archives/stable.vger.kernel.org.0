Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC4F12E173
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 02:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgABB0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 20:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgABB0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 20:26:06 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455F32085B;
        Thu,  2 Jan 2020 01:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577928365;
        bh=7ogpGNassIxGHrersudIgwoVxCPcUxR4jQrO2WxmM90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aKUlR5hb3KwYHNuo9aLFZt4b645Qj1eEJokRzRFakESK+UK39I/A3KM1CYeCZEXUO
         gwHJ7awXQca5uK/+GGITyEbZpFSv0ts45NMbAFwQGiGXxp+xDXwNDKTLkPcuBehhXR
         Zyc5XNg/HRXMgay95v7FvxEKS3+PJq5cQLY02Ei0=
Date:   Wed, 1 Jan 2020 20:26:00 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     faiz_abbas@ti.com, ulf.hansson@linaro.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci: Update the tuning failed
 messages to pr_debug" failed to apply to 4.9-stable tree
Message-ID: <20200102012600.GG16372@sasha-vm>
References: <1577635521151247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1577635521151247@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 05:05:21PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From 2c92dd20304f505b6ef43d206fff21bda8f1f0ae Mon Sep 17 00:00:00 2001
>From: Faiz Abbas <faiz_abbas@ti.com>
>Date: Fri, 6 Dec 2019 17:13:26 +0530
>Subject: [PATCH] mmc: sdhci: Update the tuning failed messages to pr_debug
> level
>
>Tuning support in DDR50 speed mode was added in SD Specifications Part1
>Physical Layer Specification v3.01. Its not possible to distinguish
>between v3.00 and v3.01 from the SCR and that is why since
>commit 4324f6de6d2e ("mmc: core: enable CMD19 tuning for DDR50 mode")
>tuning failures are ignored in DDR50 speed mode.
>
>Cards compatible with v3.00 don't respond to CMD19 in DDR50 and this
>error gets printed during enumeration and also if retune is triggered at
>any time during operation. Update the printk level to pr_debug so that
>these errors don't lead to false error reports.
>
>Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>Cc: stable@vger.kernel.org # v4.4+
>Link: https://lore.kernel.org/r/20191206114326.15856-1-faiz_abbas@ti.com
>Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

After 4.9 sdhci_execute_tuning() got split up into multiple functions,
and the actual text in the message was changed. I've adjusted the patch
and queued it up for 4.9 and 4.4.

-- 
Thanks,
Sasha
