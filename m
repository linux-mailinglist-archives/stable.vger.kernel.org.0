Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE24474533
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhLNOfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:35:31 -0500
Received: from foss.arm.com ([217.140.110.172]:57500 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232645AbhLNOfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 09:35:30 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B0E56D;
        Tue, 14 Dec 2021 06:35:29 -0800 (PST)
Received: from e113632-lin (e113632-lin.cambridge.arm.com [10.1.196.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43ED83F793;
        Tue, 14 Dec 2021 06:35:28 -0800 (PST)
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH -V2] numa balancing: move some document to make it consistent with the code
In-Reply-To: <20211213020422.2580612-1-ying.huang@intel.com>
References: <20211213020422.2580612-1-ying.huang@intel.com>
Date:   Tue, 14 Dec 2021 14:35:22 +0000
Message-ID: <87sfuv8dat.mognet@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/12/21 10:04, Huang Ying wrote:
> After commit 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to
> debugfs"), some NUMA balancing sysctls enclosed with SCHED_DEBUG has
> been moved to debugfs.  This patch move the document for these
> sysctls from
>
>   Documentation/admin-guide/sysctl/kernel.rst
>
> to
>
>   Documentation/scheduler/sched-debug.rst
>
> to make the document consistent with the code.
>
> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
> Fixes: 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to debugfs")
> Acked-by: Mel Gorman <mgorman@techsingularity.net>

Given this is pure documentation, I don't think this warrants a
Fixes:. Regardless:

Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
