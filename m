Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED97AFB105
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 14:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfKMNET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 08:04:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:30245 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbfKMNET (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 08:04:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 05:04:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,300,1569308400"; 
   d="scan'208";a="207445457"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 13 Nov 2019 05:04:16 -0800
Received: from [10.251.15.212] (kliang2-mobl.ccr.corp.intel.com [10.251.15.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 3DE365802C9;
        Wed, 13 Nov 2019 05:04:15 -0800 (PST)
Subject: Re: [PATCH 4.19 097/125] perf/x86/uncore: Fix event group support
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        linux-drivers-review@eclists.intel.com,
        linux-perf@eclists.intel.com, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20191111181438.945353076@linuxfoundation.org>
 <20191111181452.768177907@linuxfoundation.org> <20191113103531.GB32553@amd>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <296fc0ff-0d27-872b-0374-066019127813@linux.intel.com>
Date:   Wed, 13 Nov 2019 08:04:13 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191113103531.GB32553@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/13/2019 5:35 AM, Pavel Machek wrote:
> Hi!
> 
>>   	return ret;
>>   }
>>   
>> +static void uncore_pmu_enable(struct pmu *pmu)
>> +{
>> +	struct intel_uncore_pmu *uncore_pmu;
>> +	struct intel_uncore_box *box;
>> +
>> +	uncore_pmu = container_of(pmu, struct intel_uncore_pmu, pmu);
>> +	if (!uncore_pmu)
>> +		return;
> 
> AFAICT this test can never trigger.
> 
>> +static void uncore_pmu_disable(struct pmu *pmu)
>> +{
>> +	struct intel_uncore_pmu *uncore_pmu;
>> +	struct intel_uncore_box *box;
>> +
>> +	uncore_pmu = container_of(pmu, struct intel_uncore_pmu, pmu);
>> +	if (!uncore_pmu)
>> +		return;
> 
> And neither can this one.

I will submit a patch to fix it.

Thanks,
Kan
