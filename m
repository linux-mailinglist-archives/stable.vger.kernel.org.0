Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4082B46AEE4
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376855AbhLGAT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:19:29 -0500
Received: from mga05.intel.com ([192.55.52.43]:59047 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240481AbhLGAT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Dec 2021 19:19:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="323693842"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="323693842"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 16:15:59 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="679202227"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.239.159.50])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 16:15:56 -0800
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] numa balancing: remove some outdated document
References: <20211206031645.3412350-1-ying.huang@intel.com>
        <87ilw29i33.mognet@arm.com>
Date:   Tue, 07 Dec 2021 08:15:54 +0800
In-Reply-To: <87ilw29i33.mognet@arm.com> (Valentin Schneider's message of
        "Mon, 6 Dec 2021 09:51:44 +0000")
Message-ID: <87y24x46dh.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Valentin Schneider <valentin.schneider@arm.com> writes:

> On 06/12/21 11:16, Huang Ying wrote:
>> After commit 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to
>> debugfs"), some NUMA balancing sysctls enclosed with SCHED_DEBUG has
>> been moved to debugfs.  This patch removes the document for the
>> sysctls to keep the document consistent with the code.
>>
>
> There are still some useful pieces of information in those hunks; what
> about moving that to a Documentation/scheduler/sched-debug.rst?

Sound good to me.  Will do that in the next version.

Best Regards,
Huang, Ying

>> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
>> Fixes: 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to debugfs")
>> Cc: Mel Gorman <mgorman@techsingularity.net>
>> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Valentin Schneider <valentin.schneider@arm.com>
>> Cc: stable@vger.kernel.org # since v5.13
