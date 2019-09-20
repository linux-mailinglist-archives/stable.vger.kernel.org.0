Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBEFB8E83
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 12:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393524AbfITKcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 06:32:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51982 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390710AbfITKcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 06:32:36 -0400
Received: from [5.158.153.55] (helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iBGDK-0006zP-7Q; Fri, 20 Sep 2019 12:32:34 +0200
Date:   Fri, 20 Sep 2019 12:32:28 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sasha Levin <sashal@kernel.org>
cc:     linux-tip-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [tip: timers/urgent] timer: Read jiffies once when forwarding
 base clk
In-Reply-To: <20190919182903.87E0A20882@mail.kernel.org>
Message-ID: <alpine.DEB.2.21.1909201228020.1858@nanos.tec.linutronix.de>
References: <156890832199.24167.16270557930790056516.tip-bot2@tip-bot2> <20190919182903.87E0A20882@mail.kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Sep 2019, Sasha Levin wrote:
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 236968383cf5 timers: Optimize collect_expired_timers() for NOHZ.
> 
> The bot has tested the following trees: v5.2.15, v4.19.73, v4.14.144, v4.9.193.
> 
> v5.2.15: Build OK!
> v4.19.73: Build OK!
> v4.14.144: Failed to apply! Possible dependencies:
>     c310ce4dcb9d ("timers: Avoid an unnecessary iteration in __run_timers()")
> 
> v4.9.193: Failed to apply! Possible dependencies:
>     c310ce4dcb9d ("timers: Avoid an unnecessary iteration in __run_timers()")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

The backport should be trivial. If you need help, please let me know.

Thanks,

	tglx
