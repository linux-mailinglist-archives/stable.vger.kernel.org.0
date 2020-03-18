Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 834D0189FFE
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 16:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgCRP4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 11:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgCRP4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 11:56:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6EAD20767;
        Wed, 18 Mar 2020 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584546971;
        bh=2YJrWaxIweou8UpRRwG+tLthX98RCG2v9ORnyp1dHxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j40dzN8nUZOQDG+LR3wv8bCiOS77YGxvD+4rmZCHETTLqSlYV0N6nxD++lG4liUEI
         4idRs0f7F4w7NVEp3bneQaW6BYJjYW0TgnVyJtLRIGSLt2cxeWAaJaTlQFr9EvE6lh
         W1waAAzldxNjDrYyQcQ0XFWkBb/Nrb+9rX7NeNto=
Date:   Wed, 18 Mar 2020 11:56:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linus.walleij@linaro.org, bjorn.andersson@linaro.org,
        masneyb@onstation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: qcom: ssbi-gpio: Fix fwspec
 parsing bug" failed to apply to 5.5-stable tree
Message-ID: <20200318155609.GF4189@sasha-vm>
References: <158435846351251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158435846351251@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 12:34:23PM +0100, gregkh@linuxfoundation.org wrote:
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
>From f98371476f36359da2285d1807b43e5b17fd18de Mon Sep 17 00:00:00 2001
>From: Linus Walleij <linus.walleij@linaro.org>
>Date: Fri, 6 Mar 2020 15:34:15 +0100
>Subject: [PATCH] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug
>
>We are parsing SSBI gpios as fourcell fwspecs but they are
>twocell. Probably a simple copy-and-paste bug.
>
>Tested on the APQ8060 DragonBoard and after this ethernet
>and MMC card detection works again.
>
>Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>Cc: stable@vger.kernel.org
>Reviewed-by: Brian Masney <masneyb@onstation.org>
>Fixes: ae436fe81053 ("pinctrl: ssbi-gpio: convert to hierarchical IRQ helpers in gpio core")
>Link: https://lore.kernel.org/r/20200306143416.1476250-1-linus.walleij@linaro.org
>Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I've also grabbed 242587616710 ("gpiolib: Add support for the irqdomain
which doesn't use irq_fwspec as arg") and queued both for 5.5.

-- 
Thanks,
Sasha
