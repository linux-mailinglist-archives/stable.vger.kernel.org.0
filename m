Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE525E1E2
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 21:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgIDTS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 15:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgIDTSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 15:18:55 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62A5A208CA;
        Fri,  4 Sep 2020 19:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599247134;
        bh=r1W+FDL0N2JbSaXM09U2olvU+2IazujrmTKEKN7XGCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gdHozSgaYHu1p9+x78KMilXM9wfNS77hr7aaE3CE+810s8miAMJfNCLoNIY1I/4ZB
         Zyi/HrESlM7XWCLOJ8fobfFF2HAarYOoDXYvfcroMGxnAKJxUSPtd1QuyLQ/f23pVN
         WEfmxlTOlWK4VZnL2QKjLg3JVFOBZnwkQRK4Q/uk=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 470A640D3D; Fri,  4 Sep 2020 16:18:52 -0300 (-03)
Date:   Fri, 4 Sep 2020 16:18:52 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vijay Thakkar <vijaythakkar@me.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Yunfeng Ye <yeyunfeng@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Martin =?utf-8?B?TGnFoWth?= <mliska@suse.cz>,
        Borislav Petkov <bp@suse.de>, Jon Grimm <jon.grimm@amd.com>,
        Martin Jambor <mjambor@suse.cz>,
        Michael Petlan <mpetlan@redhat.com>,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] perf vendor events amd: Add L2 Prefetch events for
 zen1
Message-ID: <20200904191852.GE3753976@kernel.org>
References: <20200901220944.277505-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200901220944.277505-1-kim.phillips@amd.com>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Tue, Sep 01, 2020 at 05:09:41PM -0500, Kim Phillips escreveu:
> Later revisions of PPRs that post-date the original Family 17h events
> submission patch add these events.
> 
> Specifically, they were not in this 2017 revision of the F17h PPR:
> 
> Processor Programming Reference (PPR) for AMD Family 17h Model 01h, Revision B1 Processors Rev 1.14 - April 15, 2017
> 
> But e.g., are included in this 2019 version of the PPR:
> 
> Processor Programming Reference (PPR) for AMD Family 17h Model 18h, Revision B1 Processors Rev. 3.14 - Sep 26, 2019


Thanks, applied.

- Arnaldo
 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> Fixes: 98c07a8f74f8 ("perf vendor events amd: perf PMU events for AMD Family 17h")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Vijay Thakkar <vijaythakkar@me.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Yunfeng Ye <yeyunfeng@huawei.com>
> Cc: Jin Yao <yao.jin@linux.intel.com>
> Cc: "Martin Liška" <mliska@suse.cz>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Jon Grimm <jon.grimm@amd.com>
> Cc: Martin Jambor <mjambor@suse.cz>
> Cc: Michael Petlan <mpetlan@redhat.com>
> Cc: William Cohen <wcohen@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Ian Rogers <irogers@google.com>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  .../pmu-events/arch/x86/amdzen1/cache.json     | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
> index 404d4c569c01..695ed3ffa3a6 100644
> --- a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
> +++ b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
> @@ -249,6 +249,24 @@
>      "BriefDescription": "Cycles with fill pending from L2. Total cycles spent with one or more fill requests in flight from L2.",
>      "UMask": "0x1"
>    },
> +  {
> +    "EventName": "l2_pf_hit_l2",
> +    "EventCode": "0x70",
> +    "BriefDescription": "L2 prefetch hit in L2.",
> +    "UMask": "0xff"
> +  },
> +  {
> +    "EventName": "l2_pf_miss_l2_hit_l3",
> +    "EventCode": "0x71",
> +    "BriefDescription": "L2 prefetcher hits in L3. Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 cache and hit the L3.",
> +    "UMask": "0xff"
> +  },
> +  {
> +    "EventName": "l2_pf_miss_l2_l3",
> +    "EventCode": "0x72",
> +    "BriefDescription": "L2 prefetcher misses in L3. All L2 prefetches accepted by the L2 pipeline which miss the L2 and the L3 caches.",
> +    "UMask": "0xff"
> +  },
>    {
>      "EventName": "l3_request_g1.caching_l3_cache_accesses",
>      "EventCode": "0x01",
> -- 
> 2.27.0
> 

-- 

- Arnaldo
