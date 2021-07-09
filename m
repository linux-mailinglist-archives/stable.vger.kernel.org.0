Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F63C3C236E
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 14:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhGIMdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 08:33:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:44519 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231308AbhGIMdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 08:33:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="190071330"
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="190071330"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 05:31:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="492513539"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 09 Jul 2021 05:31:06 -0700
Received: from [10.212.175.145] (kliang2-MOBL.ccr.corp.intel.com [10.212.175.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 432FC580911;
        Fri,  9 Jul 2021 05:31:06 -0700 (PDT)
Subject: Re: [PATCH] perf/x86/intel: Apply early ACK for small core
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        stable@vger.kernel.org
References: <1625774073-153697-1-git-send-email-kan.liang@linux.intel.com>
 <YOgbs6i9Q/EoGDj9@hirez.programming.kicks-ass.net>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <ba2fea7f-0a8c-e80d-6397-87c4901b0eec@linux.intel.com>
Date:   Fri, 9 Jul 2021 08:31:04 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOgbs6i9Q/EoGDj9@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/9/2021 5:49 AM, Peter Zijlstra wrote:
> On Thu, Jul 08, 2021 at 12:54:33PM -0700, kan.liang@linux.intel.com wrote:
>> @@ -2921,7 +2920,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>>   	 * No known reason to not always do late ACK,
>>   	 * but just in case do it opt-in.
>>   	 */
> 
> ^^^ comment is now seriously out of date. Can you please update it?
> 

Sure, I will update it and send a V2 patch.

Thanks,
Kan
