Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5715A2D8DE0
	for <lists+stable@lfdr.de>; Sun, 13 Dec 2020 15:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406040AbgLMOMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Dec 2020 09:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395199AbgLMOL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Dec 2020 09:11:57 -0500
Date:   Sun, 13 Dec 2020 09:11:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607868677;
        bh=4iY0ichsoz9AxrcT1VWUCiZr3pTTCjf5adfxu9D6nwg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6siXNdczE7kwUXOYvZQy1uojPOV6wvA01EpOpL9+aoMdtv0OEPkR/+frL6JKC8Xj
         VD2zJjLkR2AT5wGuanmZRdm7lYAoF1+Bgpu6c44a4MfXkvgh2iGtr+NtPh6J1/eT4t
         A0LH4sHaWkd/rWNoKJK/jhDx0aye7sLdqDKQpT0Q96NiWzUOTUm6EBRuSXrkwh/Mye
         nyHTfJvZ04WcakIgxEKgt9JgBnWv2bEtmqEiZvZXECuKJkp3tTxwXBZLRWzwV+lhhy
         tb8TTX8fMWUApN8prtxLIE+Nev3oNqvL4ggn8X3xxWdeSorzv8+Ys+hEbw1cAnTMxl
         XB9tlyalA1U5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 28/39] intel_idle: Fix intel_idle() vs tracing
Message-ID: <20201213141115.GR643756@sasha-vm>
References: <20201203132834.930999-1-sashal@kernel.org>
 <20201203132834.930999-28-sashal@kernel.org>
 <20201203171035.GO2414@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201203171035.GO2414@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 06:10:35PM +0100, Peter Zijlstra wrote:
>On Thu, Dec 03, 2020 at 08:28:22AM -0500, Sasha Levin wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> [ Upstream commit 6e1d2bc675bd57640f5658a4a657ae488db4c204 ]
>>
>> cpuidle->enter() callbacks should not call into tracing because RCU
>> has already been disabled. Instead of doing the broadcast thing
>> itself, simply advertise to the cpuidle core that those states stop
>> the timer.
>>
>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Link: https://lkml.kernel.org/r/20201123143510.GR3021@hirez.programming.kicks-ass.net
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This patch has a known compile issue, fix is pending.

I've also grabbed 4d916140bf28 ("intel_idle: Build fix"). Thanks!

-- 
Thanks,
Sasha
