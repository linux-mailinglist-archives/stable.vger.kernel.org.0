Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C2B3B8281
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhF3M4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:56:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:61814 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234481AbhF3M4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 08:56:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="269474485"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="269474485"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 05:54:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="455246293"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 30 Jun 2021 05:54:08 -0700
Received: from [10.209.45.119] (kliang2-MOBL.ccr.corp.intel.com [10.209.45.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 4E226580279;
        Wed, 30 Jun 2021 05:54:07 -0700 (PDT)
Subject: Re: [PATCH V3 5/6] perf/x86/intel/uncore: Fix invalid unit check
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        yao.jin@linux.intel.com, stable@vger.kernel.org
References: <1624990443-168533-1-git-send-email-kan.liang@linux.intel.com>
 <1624990443-168533-6-git-send-email-kan.liang@linux.intel.com>
 <YNw7CT2sBE0l8aNf@kroah.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <cb0d2d43-102a-994c-f777-e11d61c77bf5@linux.intel.com>
Date:   Wed, 30 Jun 2021 08:54:05 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNw7CT2sBE0l8aNf@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/30/2021 5:36 AM, Greg KH wrote:
> On Tue, Jun 29, 2021 at 11:14:02AM -0700, kan.liang@linux.intel.com wrote:
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> The uncore unit with the type ID 0 and the unit ID 0 is missed.
>>
>> The table3 of the uncore unit maybe 0. The
>> uncore_discovery_invalid_unit() mistakenly treated it as an invalid
>> value.
>>
>> Remove the !unit.table3 check.
>>
>> Fixes: edae1f06c2cd ("perf/x86/intel/uncore: Parse uncore discovery tables")
>> Reviewed-by: Andi Kleen <ak@linux.intel.com>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   arch/x86/events/intel/uncore_discovery.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Why is a bugfix that needs to be backported patch 5 in the series?
> Shouldn't that be totally independant and sent on its own and not part
> of this series at all so that it can be accepted and merged much
> quicker?  It also should not depened on the previous 4 patches, right?
>

Yes, you are right.

I found the bug when I tested this patch set. so I appended it at the 
end of the patch set. I will split the patch and send it separately.

Thanks,
Kan
