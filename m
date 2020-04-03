Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08D219D77F
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 15:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390850AbgDCNXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 09:23:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:55776 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbgDCNXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Apr 2020 09:23:47 -0400
IronPort-SDR: IhPiSx1HaRkXXeXNrd4xkJPjLEcfCJOFNU2IXg0WTK3E3lgOB0EvOjDfTyAA3O6J2zRYQBDAvT
 TFAYPBjqsySQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 06:23:46 -0700
IronPort-SDR: WxufuFC2p5Kg4c/tBlfG80uEMGrL/+qle+OGy/zcVc+/ZqvLOEiBklEK1jyKLQFmhH2EbZmirY
 /lcjHPBeosEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,339,1580803200"; 
   d="scan'208";a="295992101"
Received: from um.fi.intel.com (HELO um) ([10.237.72.57])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Apr 2020 06:23:43 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Lee Jones <lee.jones@linaro.org>, Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>,
        alexander.shishkin@linux.intel.com
Subject: Re: [PATCH 4.19 11/13] perf/core: Reattach a misplaced comment
In-Reply-To: <20200403125246.GE30614@dell>
References: <20200403121859.901838-1-lee.jones@linaro.org> <20200403121859.901838-12-lee.jones@linaro.org> <20200403122604.GA3928660@kroah.com> <20200403125246.GE30614@dell>
Date:   Fri, 03 Apr 2020 16:23:42 +0300
Message-ID: <87y2rc66u9.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> On Fri, 03 Apr 2020, Greg KH wrote:
>
>> > +	/*
>> > +	 * Get the target context (task or percpu):
>> > +	 */
>> >  	ctx = find_get_context(event->pmu, task, event);
>> >  	if (IS_ERR(ctx)) {
>> >  		err = PTR_ERR(ctx);
>> 
>> Unless this is needed by a follow-on patch, I kind of doubt thsi is
>> needed in a stable kernel release :)
>
> I believe you once called this "debugging the comments", or
> similar. :)
>
> No problem though - happy to drop it from this and other sets.

It's a precursor to dce5affb94eb54edfff17727a6240a6a5d998666, which I
think is a stable candidate.

Regards,
--
Alex
