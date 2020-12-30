Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678572E7A50
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgL3P3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgL3P3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 10:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0548207A6;
        Wed, 30 Dec 2020 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609342124;
        bh=U0znmlJoxtSJITSW1JmWizmEYXzvkRK7iiwYvP7Jr+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0F+4yysTtkoMuRj5MxfVvj/Sgl3xEKynjYtYCKdMVZZX9zyvptGXUBjnknQnwMXUE
         UKTS4zBNEyu7SeIAmkh5cQVrAuQK5be3+0+IrZTUY8ndSQjOY/2lJqkvPvBTSEvltq
         IjTjLHBT0AmsqNQwRvW4HgFJAzBbcr3fLH7k251w=
Date:   Wed, 30 Dec 2020 16:30:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, zhuguangqing@xiaomi.com,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH for 5.4 stable] thermal/drivers/cpu_cooling: Update
 cpufreq_state only if state has changed
Message-ID: <X+ydAoxPj/jEz/0P@kroah.com>
References: <1609156118189209@kroah.com>
 <7c80add4a09e3b1f24f4de322d3d4b4bda0db5ba.1609224933.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c80add4a09e3b1f24f4de322d3d4b4bda0db5ba.1609224933.git.viresh.kumar@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 12:26:39PM +0530, Viresh Kumar wrote:
> From: Zhuguangqing <zhuguangqing@xiaomi.com>
> 
> [ Upstream commit 236761f19a4f373354f1dcf399b57753f1f4b871 ]
> 
> If state has not changed successfully and we updated cpufreq_state,
> next time when the new state is equal to cpufreq_state (not changed
> successfully last time), we will return directly and miss a
> freq_qos_update_request() that should have been.
> 
> Fixes: 5130802ddbb1 ("thermal: cpu_cooling: Switch to QoS requests for freq limits")
> Cc: v5.4+ <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Zhuguangqing <zhuguangqing@xiaomi.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Link: https://lore.kernel.org/r/20201106092243.15574-1-zhuguangqing83@gmail.com
> [ Viresh: Redo the patch for 5.4 stable kernel ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/thermal/cpu_cooling.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Now applied, thanks.

greg k-h
