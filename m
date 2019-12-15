Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E431411FAA3
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 20:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfLOTAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 14:00:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfLOTAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 14:00:38 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECD0206D8;
        Sun, 15 Dec 2019 19:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576436438;
        bh=MARWSIAM7JBGiZzNVsaND2CO0egvmeZ5zryi/UGVVHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xFszvP/Jys9UtvBynwtSDqYx/KU8C/niygTaQvwZP10Imc/CAV6xRsNfleoRFWiG7
         Gxs+hON1/BHybyUU0DLrBI2Cq0YNDuMu6qJWCsBUuQQnCBc5CceVzmE0YicZx8XhMj
         4gNvqF5ak4oK9h4KUzsh/UWc0Wfow/QgEVsOzn6g=
Date:   Sun, 15 Dec 2019 14:00:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hns@goldelico.com, stable@vger.kernel.org, tony@atomide.com,
        ulf.hansson@linaro.org
Subject: Re: FAILED: patch "[PATCH] omap: pdata-quirks: remove openpandora
 quirks for mmc3 and" failed to apply to 5.4-stable tree
Message-ID: <20191215190036.GQ18043@sasha-vm>
References: <15764167786972@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15764167786972@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 02:32:58PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From 2398c41d64321e62af54424fd399964f3d48cdc2 Mon Sep 17 00:00:00 2001
>From: "H. Nikolaus Schaller" <hns@goldelico.com>
>Date: Thu, 7 Nov 2019 11:30:39 +0100
>Subject: [PATCH] omap: pdata-quirks: remove openpandora quirks for mmc3 and
> wl1251
>
>With a wl1251 child node of mmc3 in the device tree decoded
>in omap_hsmmc.c to handle special wl1251 initialization, we do
>no longer need to instantiate the mmc3 through pdata quirks.
>
>We also can remove the wlan regulator and reset/interrupt definitions
>and do them through device tree.
>
>Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
>Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>Cc: <stable@vger.kernel.org> # v4.7+
>Acked-by: Tony Lindgren <tony@atomide.com>
>Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

I've also grabbed 4e8fad98171b ("omap: pdata-quirks: revert pandora
specific gpiod additions") and queued for all branches.

-- 
Thanks,
Sasha
