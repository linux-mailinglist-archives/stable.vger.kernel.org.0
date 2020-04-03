Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B349919D6AA
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgDCM0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:26:13 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:54311 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727927AbgDCM0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:26:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 502C458016A;
        Fri,  3 Apr 2020 08:26:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 03 Apr 2020 08:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=4X1yBFS5VM7YxjSUJmROxEr0L14
        Qzk9bfmsDO9Klaj8=; b=WQrWsgIYvsTlSp2AEEopRisEXWage0X6F1yz/tM4EYi
        4iogun3QUP8ft5xYDIfYxPqvbErj7JYon4O1pUI6VB5BhqgSAjKYXvcgV+dkIXZK
        wa/e48l6xxtj+sH6n7YLvYKYzRuTzeb2W78pEVQl/6+IsZSwsHtTQWzy4gN01FOB
        XurrWsqJTraQVd+GSV62zASjNcjEWN37nTAWKcprbpGlPI7yew8ZTUUL+p3LjCq5
        xtU6lrqBbRrecenryeHmMh54Hrq4JA04507hZM+HT9woU6d69bZgYvHCSAw47XX/
        BeDky1SjacT36kr2l85Oh1M3k2UAzjO2APfL5dtwXjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4X1yBF
        S5VM7YxjSUJmROxEr0L14Qzk9bfmsDO9Klaj8=; b=lPOznT+Hx+Rarj5yDcGxc/
        AfwkCUjSbfu6B9ORWzy8uKWgVMRRrKini/FGVZCQwhJEGk8l8MVY77XvmJCaXcbh
        xTCsSbtFlTH3sb7sRE9SxkpXfvZ7pv22lOwv9ScQh/6OuKb3a/MSY/d125PLr41y
        LdWvVZm+SjPLCFDLyWlMZPPPzYPqRHhXcdZXXgQU/NFphB8tO7gdHANycsVB69hm
        810nW+UfI0dbxX+oxUnekG3SeGsmb6Aa9wy3M9xfafjc8ctTWrUwQbHP+EjoKr7S
        0k+UtQmEkvIscJabGYwPO0SkdanY8/2NaWl8oJ9NLATPbE3vGDdyF0ap0CLfVxCA
        ==
X-ME-Sender: <xms:YSuHXnsFurbhwMsaFP7MDtlU_O3-XRGHK02RtHByqCm-5Aphye_NUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:YSuHXvocYGiPVjlTuXetS0u9Dh0PU83GJgKbM8uJP7JcTYpyU8VWYA>
    <xmx:YSuHXvLoy_Wkze6WkvqodHSnosKWeUZO2aAcvAggWw1KLDpg9kLGNQ>
    <xmx:YSuHXu4EtpB4vL-iCobzhrIA2cqeUA2eWgTfJV4vK-VMHSGLIsiHyQ>
    <xmx:YyuHXiPx26iX08tU1dRmAJ8O3r-BNj-yDpvtq2GRlABr3gE_WWtVvg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 49C10328005D;
        Fri,  3 Apr 2020 08:26:09 -0400 (EDT)
Date:   Fri, 3 Apr 2020 14:26:04 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
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
Message-ID: <20200403122604.GA3928660@kroah.com>
References: <20200403121859.901838-1-lee.jones@linaro.org>
 <20200403121859.901838-12-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403121859.901838-12-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 03, 2020 at 01:18:57PM +0100, Lee Jones wrote:
> From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> 
> [ Upstream commit f25d8ba9e1b204b90fbf55970ea6e68955006068 ]
> 
> A comment is in a wrong place in perf_event_create_kernel_counter().
> Fix that.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vince Weaver <vincent.weaver@maine.edu>
> Link: https://lkml.kernel.org/r/20191030134731.5437-2-alexander.shishkin@linux.intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  kernel/events/core.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 8c70ee23fbe91..16f268475e8e4 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -10954,10 +10954,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>  	struct perf_event *event;
>  	int err;
>  
> -	/*
> -	 * Get the target context (task or percpu):
> -	 */
> -
>  	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
>  				 overflow_handler, context, -1);
>  	if (IS_ERR(event)) {
> @@ -10968,6 +10964,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>  	/* Mark owner so we could distinguish it from user events. */
>  	event->owner = TASK_TOMBSTONE;
>  
> +	/*
> +	 * Get the target context (task or percpu):
> +	 */
>  	ctx = find_get_context(event->pmu, task, event);
>  	if (IS_ERR(ctx)) {
>  		err = PTR_ERR(ctx);

Unless this is needed by a follow-on patch, I kind of doubt thsi is
needed in a stable kernel release :)

thanks,

greg k-h
