Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6602CDBFD
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 18:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgLCRLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 12:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731404AbgLCRLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 12:11:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB909C061A53;
        Thu,  3 Dec 2020 09:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5EwfhY8EHxYhuDuIhxchGigK6JazuuA9rGBo9L96HNo=; b=FUW8pMV5owth/c7fRZkh1KU8Ee
        qP5VRx5fXD0r1zXAtM04FmUb2YNgVBzf8FyvMS7qgK1pNjMb/LRWJ3F7d+QYld2dmfZ6pSN9uB3V+
        r2AFtvNXMMV8iZUdX7sYWyW9Be2vsHpqAFRhmt99ZhaFkVqv4dJJtb1WiKqIBQ0wbLzz/lqfvUyq0
        sccbRAnV1/PSsML5nXHzcNBEj8Uwq66lLP2ZPDs2buyo7rj6oU+JkdiO6rsIdvQH4vzRFrXwNTsXP
        2xgyKQUJ7ic89dylvATe77fYC9bKI7tmTLj7yIvMu7dHJz9Y7bnHYCWfBfx+4T0vzPOwMMrSKSJ0m
        twBT9Q0g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kks7o-0000DC-6w; Thu, 03 Dec 2020 17:10:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B2D5A3060AE;
        Thu,  3 Dec 2020 18:10:35 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 53B022C5B7420; Thu,  3 Dec 2020 18:10:35 +0100 (CET)
Date:   Thu, 3 Dec 2020 18:10:35 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 28/39] intel_idle: Fix intel_idle() vs tracing
Message-ID: <20201203171035.GO2414@hirez.programming.kicks-ass.net>
References: <20201203132834.930999-1-sashal@kernel.org>
 <20201203132834.930999-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203132834.930999-28-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 08:28:22AM -0500, Sasha Levin wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> [ Upstream commit 6e1d2bc675bd57640f5658a4a657ae488db4c204 ]
> 
> cpuidle->enter() callbacks should not call into tracing because RCU
> has already been disabled. Instead of doing the broadcast thing
> itself, simply advertise to the cpuidle core that those states stop
> the timer.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Link: https://lkml.kernel.org/r/20201123143510.GR3021@hirez.programming.kicks-ass.net
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch has a known compile issue, fix is pending.
