Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807305EEE09
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 08:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbiI2Gtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 02:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiI2Gtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 02:49:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DC114D1D
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 23:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664434181; x=1695970181;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vp+fBFK4VElnfaWOG53FLqVzkHbUKl+r7aZe0/vYJXM=;
  b=iAtEVdSeBORmN+2yOfoH1mMWQBUe43aZPgpkbx83A9thJ6iFibOZ0uzA
   gdMbQ+SkRNqkTLYabKi5NghhbfPCuzgbt2M7eLL4Yt9AHcpyM0Zkvagis
   2TtXHeqIkK/FphmQznh+SyO+U/xzmRmqyVgt9XexbI1NOi0oPCZrDAcva
   6YyfTl25Vb6Yprl+06nj4hQR98OQG9BIlcttxxGM7bzMY5E4DN3vn58G2
   kvNq29Y6M1RVnL8CSteTKzKfZD3QYmMNnILp33AVf8VrVZnOhB4B4g9t4
   Ck3kJQbNm+VEIwzQkSDmFwy8MwIToo2Laotzr3ZrRCzfHexwq/ZrUIDiY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="302723480"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="302723480"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 23:49:40 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="711266546"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="711266546"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.37.6])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 23:49:37 -0700
Message-ID: <aa2b3b4e-3c8c-0136-b756-987a3c852e7a@intel.com>
Date:   Thu, 29 Sep 2022 09:49:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: FAILED: patch "[PATCH] perf record: Fix cpu mask bit setting for
 mixed mmaps" failed to apply to 5.19-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, acme@redhat.com,
        atrajeev@linux.vnet.ibm.com, irogers@google.com, jolsa@kernel.org,
        namhyung@kernel.org
Cc:     stable@vger.kernel.org
References: <166395570321772@kroah.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <166395570321772@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please take dependent commit cbd7bfc7fd99 first, then ca76d7d2812b.

On 23/09/22 20:55, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> ca76d7d2812b ("perf record: Fix cpu mask bit setting for mixed mmaps")
> cbd7bfc7fd99 ("tools/perf: Fix out of bound access to cpu mask array")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From ca76d7d2812b46124291f99c9b50aaf63a936f23 Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@intel.com>
> Date: Thu, 15 Sep 2022 15:26:11 +0300
> Subject: [PATCH] perf record: Fix cpu mask bit setting for mixed mmaps
> 
> With mixed per-thread and (system-wide) per-cpu maps, the "any cpu" value
>  -1 must be skipped when setting CPU mask bits.
> 
> Prior to commit cbd7bfc7fd99acdd ("tools/perf: Fix out of bound access
> to cpu mask array") the invalid setting went unnoticed, but since then
> it causes perf record to fail with an error.
> 
> Example:
> 
>  Before:
> 
>    $ perf record -e intel_pt// --per-thread uname
>    Failed to initialize parallel data streaming masks
> 
>  After:
> 
>    $ perf record -e intel_pt// --per-thread uname
>    Linux
>    [ perf record: Woken up 1 times to write data ]
>    [ perf record: Captured and wrote 0.068 MB perf.data ]
> 
> Fixes: ae4f8ae16a078964 ("libperf evlist: Allow mixing per-thread and per-cpu mmaps")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
> Cc: Ian Rogers <irogers@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20220915122612.81738-2-adrian.hunter@intel.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index f87ef43eb820..0f711f88894c 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -3371,6 +3371,8 @@ static int record__mmap_cpu_mask_init(struct mmap_cpu_mask *mask, struct perf_cp
>  		return 0;
>  
>  	perf_cpu_map__for_each_cpu(cpu, idx, cpus) {
> +		if (cpu.cpu == -1)
> +			continue;
>  		/* Return ENODEV is input cpu is greater than max cpu */
>  		if ((unsigned long)cpu.cpu > mask->nbits)
>  			return -ENODEV;
> 

