Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8639819D6F6
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgDCMv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:51:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50795 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgDCMv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:51:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id t128so7061820wma.0
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=engPFJgdUItSkA2S0QPyRMxkTnv2Jg4Tf1ResN3fSK0=;
        b=qLF3Hdfk1NSsl5EFGR57yk61hLZ9HM+2T9+HK6yoEkvcfwvwuAQXMzeZ288fAF3/jR
         kgC5+p+G2+jdL1IQjZnkcY4dXcVn5tA+sCW6PuEobYkyKicKvg93zRnNPL6RPAAi+Ioj
         JqyBpt46gxLokDaZagEhM2VqwSoyWaQTE2y71bgvxRKujeK01zXbv2yLOgmHo5XSCJIN
         36JPqTRiww+Q2wLTNLM4Yc1VlldDjwgu/Vp69B3ZMYOwFPN24qp52V3bF5vIoH1+muAL
         EZ29drLhrOuWXVlKFsCot1RWazc5GzBfIne5Q8NG8uSqZdUP6IMnkNFlubE9bQ+ZdmoL
         09OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=engPFJgdUItSkA2S0QPyRMxkTnv2Jg4Tf1ResN3fSK0=;
        b=LWcpM1urdRvX8Byb+zZwLwfp0v91uIRHqEg0ulhuT2nh8+hOWJ9yv55GBwcYS3gCX1
         jvYW/8lxoVQUj4LKnRRkNmcmajAcVbDFc2IaGZlSCyyrfV+kE4P4jOIQNHw/svjX0oUC
         1cFMcElYzGcZ04ZmNiJOvaVPRK285F0DXYTGhF2RABHf1P7M5E+rYLm6w5PmVzeB3wYZ
         vzaMtQ91rUczG22U2CHhE1bLCi4urNJLgbZV65X1kaYTypP90PPuUDatzG5xHXTbZAUb
         HG9pc6f3S1FxSA4Fbas+m6W4phFZji498Lv2/jHqWicw0gJIhfH37J9Tti1jtcYq+f7h
         AZvQ==
X-Gm-Message-State: AGi0PuamuJ8cTcRYwlReqTgFxPK8X0dKEb0aHY8wODpJlyP2o1/posex
        A4uwb3zr8JyztLi0tmceYR6pCA==
X-Google-Smtp-Source: APiQypLiLMkuJHDQFitD2HWTlUCEEbncr/2tdNkp0h6dbl9hnWkuAwhoJwuAZPO8vFg0htY2KMNcDg==
X-Received: by 2002:a7b:c083:: with SMTP id r3mr8879221wmh.92.1585918313899;
        Fri, 03 Apr 2020 05:51:53 -0700 (PDT)
Received: from dell ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id 98sm12306738wrk.52.2020.04.03.05.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:51:53 -0700 (PDT)
Date:   Fri, 3 Apr 2020 13:52:46 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4.19 11/13] perf/core: Reattach a misplaced comment
Message-ID: <20200403125246.GE30614@dell>
References: <20200403121859.901838-1-lee.jones@linaro.org>
 <20200403121859.901838-12-lee.jones@linaro.org>
 <20200403122604.GA3928660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200403122604.GA3928660@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 03 Apr 2020, Greg KH wrote:

> On Fri, Apr 03, 2020 at 01:18:57PM +0100, Lee Jones wrote:
> > From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > 
> > [ Upstream commit f25d8ba9e1b204b90fbf55970ea6e68955006068 ]
> > 
> > A comment is in a wrong place in perf_event_create_kernel_counter().
> > Fix that.
> > 
> > Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Vince Weaver <vincent.weaver@maine.edu>
> > Link: https://lkml.kernel.org/r/20191030134731.5437-2-alexander.shishkin@linux.intel.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  kernel/events/core.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 8c70ee23fbe91..16f268475e8e4 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -10954,10 +10954,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
> >  	struct perf_event *event;
> >  	int err;
> >  
> > -	/*
> > -	 * Get the target context (task or percpu):
> > -	 */
> > -
> >  	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
> >  				 overflow_handler, context, -1);
> >  	if (IS_ERR(event)) {
> > @@ -10968,6 +10964,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
> >  	/* Mark owner so we could distinguish it from user events. */
> >  	event->owner = TASK_TOMBSTONE;
> >  
> > +	/*
> > +	 * Get the target context (task or percpu):
> > +	 */
> >  	ctx = find_get_context(event->pmu, task, event);
> >  	if (IS_ERR(ctx)) {
> >  		err = PTR_ERR(ctx);
> 
> Unless this is needed by a follow-on patch, I kind of doubt thsi is
> needed in a stable kernel release :)

I believe you once called this "debugging the comments", or
similar. :)

No problem though - happy to drop it from this and other sets.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
