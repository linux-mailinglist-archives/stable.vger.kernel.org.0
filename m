Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8794692FA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 10:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbhLFJzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 04:55:17 -0500
Received: from foss.arm.com ([217.140.110.172]:52498 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239646AbhLFJzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Dec 2021 04:55:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FA5011FB;
        Mon,  6 Dec 2021 01:51:48 -0800 (PST)
Received: from e113632-lin (e113632-lin.cambridge.arm.com [10.1.196.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28B0E3F73D;
        Mon,  6 Dec 2021 01:51:47 -0800 (PST)
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] numa balancing: remove some outdated document
In-Reply-To: <20211206031645.3412350-1-ying.huang@intel.com>
References: <20211206031645.3412350-1-ying.huang@intel.com>
Date:   Mon, 06 Dec 2021 09:51:44 +0000
Message-ID: <87ilw29i33.mognet@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/12/21 11:16, Huang Ying wrote:
> After commit 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to
> debugfs"), some NUMA balancing sysctls enclosed with SCHED_DEBUG has
> been moved to debugfs.  This patch removes the document for the
> sysctls to keep the document consistent with the code.
>

There are still some useful pieces of information in those hunks; what
about moving that to a Documentation/scheduler/sched-debug.rst?

> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
> Fixes: 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to debugfs")
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: stable@vger.kernel.org # since v5.13
