Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1B21B5D26
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 16:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgDWOBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 10:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728117AbgDWOBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 10:01:46 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E09C08E934;
        Thu, 23 Apr 2020 07:01:44 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id 71so4872288qtc.12;
        Thu, 23 Apr 2020 07:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=osr0mTWjxJPKDiqYEcIsdHiMlFzxd4uhLnyuStegdes=;
        b=J0UrBH170vTDsmQj8fB2XIfVzvJYnsGi2GJpsv4h+jS2DQGIU9vpiUWrhAlI+5AC8J
         XwHE+9VzZ2iZTKNODWa84DstekuuAdT2Eg9+IYgnIj6KOHart/XuIBjt072OL3kHsRfg
         wY7OZvAFnu09pJOPa5BVF+IPSygbD51dKa+wm6bhjy6fIfTfg+sh5JoW+UFjwvoZ3tWu
         CSmPOpp3J6dIQ5N2YXbpj6rmO9hdQnBaGg6iHlxeSHMcxy3XQcJ1eBk/TwglvvuBPPMq
         cLjJX4/lwGQj0y9TbQrxhoU+fwwXOPI6u9hi1vdePQPT/OMINpSE93nt92dKeUJIAscR
         5bVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=osr0mTWjxJPKDiqYEcIsdHiMlFzxd4uhLnyuStegdes=;
        b=VmSRy1hfd76exG14o5CXGBSJsZ7dl1arVMNPIJpwWQA9zMz3UYZjpO4/LjARGhDhUL
         jBAN3yA0Ra4OicHBAR2SZQVKvdWtXxQZ3VnLXLpu+EjvIHdGnLc9j6TdDA9r7MqlrGjH
         8ITpL5VkdDgrQQsfeXhXzFbknxFThBWQPHvRvVszznyxyO2c2ii8UjHO6zzkNrf/o62S
         qJEu45jyAeAakRJgthXBQgJ8geiYMZIzrfQIV6+0JhnlblIsvGOSfdl1HWoBEfSrNzkx
         A69Lr0AyGbIFmkKTNeHwSRp4yyloQ2yqZqensajk+6Do6ztRN7DR9WEBAacES1RrdjqQ
         yASQ==
X-Gm-Message-State: AGi0PuahxbmMq5Ny+YOHiioYI4aGdd1shVstfHeaX3W7Wo7QKNjb/88c
        xuWIJ1PA6UgNVOmk8lQNAmnQLXrBTcM=
X-Google-Smtp-Source: APiQypLyHNtxtf0V5ZuckKMJVvCUEvtSakXM1mV9n7Cf3T8eFJrjQIRIw4llktNM7xGGzUZc8pULag==
X-Received: by 2002:ac8:6753:: with SMTP id n19mr4152344qtp.353.1587650503377;
        Thu, 23 Apr 2020 07:01:43 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id g47sm1805051qte.54.2020.04.23.07.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 07:01:42 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C4EAE409A3; Thu, 23 Apr 2020 11:01:39 -0300 (-03)
Date:   Thu, 23 Apr 2020 11:01:39 -0300
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] perf-probe: Do not show the skipped events
Message-ID: <20200423140139.GG19437@kernel.org>
References: <158763965400.30755.14484569071233923742.stgit@devnote2>
 <158763968263.30755.12800484151476026340.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158763968263.30755.12800484151476026340.stgit@devnote2>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Thu, Apr 23, 2020 at 08:01:22PM +0900, Masami Hiramatsu escreveu:
> When a probe point is expanded to several places (like inlined) and
> if some of them are skipped because of blacklisted or __init function,
> those trace_events has no event name. It must be skipped while showing
> results.
> 
> Without this fix, you can see "(null):(null)" on the list,
> ===========

Ok, you broke the patch in two, I think its better to combine both, ok?

- Arnaldo

>   # ./perf probe request_resource
>   reserve_setup is out of .text, skip it.
>   Added new events:
>     (null):(null)        (on request_resource)
>     probe:request_resource (on request_resource)
> 
>   You can now use it in all perf tools, such as:
> 
>   	perf record -e probe:request_resource -aR sleep 1
> 
> ===========
> 
> With this fix, it is ignored.
> ===========
>   # ./perf probe request_resource
>   reserve_setup is out of .text, skip it.
>   Added new events:
>     probe:request_resource (on request_resource)
> 
>   You can now use it in all perf tools, such as:
> 
>   	perf record -e probe:request_resource -aR sleep 1
> 
> ===========
> 
> Fixes: 5a51fcd1f30c ("perf probe: Skip kernel symbols which is out of .text")
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  tools/perf/builtin-probe.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 70548df2abb9..6b1507566770 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -364,6 +364,9 @@ static int perf_add_probe_events(struct perf_probe_event *pevs, int npevs)
>  
>  		for (k = 0; k < pev->ntevs; k++) {
>  			struct probe_trace_event *tev = &pev->tevs[k];
> +			/* Skipped events have no event name */
> +			if (!tev->event)
> +				continue;
>  
>  			/* We use tev's name for showing new events */
>  			show_perf_probe_event(tev->group, tev->event, pev,
> 

-- 

- Arnaldo
