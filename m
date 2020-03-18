Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F0418A319
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 20:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCRTZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 15:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgCRTZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 15:25:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11CBB2072C;
        Wed, 18 Mar 2020 19:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584559530;
        bh=XENnrkdeN4Wvs4rIQvEqfjEpYwOCkfqGo/jVwsnFxAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yfphf26iGEx6xVc/C8nYpxCuUFzad8DL59H6uYavDvQqrDHnwwhYN68xPYL7+KqZV
         uwnQJpWH3wDM+dmVpphD4R4b+/0Mk8HU+dXHp0WZAoa2ceqSqfZdITOgExD7xau0J7
         rCNxKcLjVVoY/Ue/sN+pprPFFTItoiaMsTXBx1hU=
Date:   Wed, 18 Mar 2020 15:25:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ulf.hansson@linaro.org, anders.roxell@linaro.org,
        faiz_abbas@ti.com, pgwipeout@gmail.com, skomatineni@nvidia.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mmc: core: Allow host controllers to
 require R1B for CMD6" failed to apply to 5.5-stable tree
Message-ID: <20200318192528.GH4189@sasha-vm>
References: <158435827821152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158435827821152@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 12:31:18PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 1292e3efb149ee21d8d33d725eeed4e6b1ade963 Mon Sep 17 00:00:00 2001
>From: Ulf Hansson <ulf.hansson@linaro.org>
>Date: Tue, 10 Mar 2020 12:49:43 +0100
>Subject: [PATCH] mmc: core: Allow host controllers to require R1B for CMD6
>
>It has turned out that some host controllers can't use R1B for CMD6 and
>other commands that have R1B associated with them. Therefore invent a new
>host cap, MMC_CAP_NEED_RSP_BUSY to let them specify this.
>
>In __mmc_switch(), let's check the flag and use it to prevent R1B responses
>from being converted into R1. Note that, this also means that the host are
>on its own, when it comes to manage the busy timeout.
>
>Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
>Cc: <stable@vger.kernel.org>
>Tested-by: Anders Roxell <anders.roxell@linaro.org>
>Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
>Tested-by: Faiz Abbas <faiz_abbas@ti.com>
>Tested-By: Peter Geis <pgwipeout@gmail.com>
>Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

I've fixed up and queued this whole mmc series of stable tagged patches
for 4.19-5.5.

-- 
Thanks,
Sasha
