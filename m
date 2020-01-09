Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26918135ED3
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 18:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgAIRAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 12:00:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50517 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731320AbgAIRAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 12:00:44 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 55153214DB;
        Thu,  9 Jan 2020 12:00:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 09 Jan 2020 12:00:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=hcgptnGOQIZIIhyQtpsCyNNyBT2
        /xi/KbtsQbbxl1sM=; b=i6cV77nSAvfaICP1k5kwwfHKme5Q8VKHkYjvdeDpe0o
        nS8qxapgapFts3bc/uQ86OmWjwKa5yulhHZ9+L69WgwC93cot5MryFjhWCrFD/Xd
        ZgdEDf/R700vhY5ZLZvijQMkEIt28TLIYXR0gMpzJdX1ptSGCp52HoytAVcm2qzv
        zwqcqnmpAgUDUGZ/VwGYTZnwWagNnW9Mfs0tpIXLdVyW8JTfjOZNrXditk73sI8t
        wtIO1HJMCTS5JFI7a514Gy4SRgaVuy0u3w6YcfjWGp2R603vzZhQ7vvTuqMiINUh
        xEE9x4n4Mhe6L8Spn+aeOcjaUfShy8+zbCDU9BWdryA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hcgptn
        GOQIZIIhyQtpsCyNNyBT2/xi/KbtsQbbxl1sM=; b=cxjk8PuoU8UAskb2Z2/zjc
        Z0MkVcdGI7jx5d1ehOUaFu9u2RQquQOdE6TdiVrN0AE1yKlzLYfo2TtzXtqoM/ow
        ihn87wsNsspehcHIBZCb35O7iKjku/A4O/9byOccNllNEuCfnI1pzQmpj2oCTdhU
        H4uQnBtuDoly+cM5vIjDmM10DAsrGNrhLMex4dEtFgRoEGlEPKypwZqRAGUX0Pgz
        X1mSN/rw88fT5OIlHPhoesKVspmeTFdn9LhKdaylwwPfMPplXtolI60H7ADb0GXC
        +xlCVTp1QEZf1Je7Hlerd89G/J8fZv1OLgGgJHUm84VkD690Oyyw/h9/STNqIWLg
        ==
X-ME-Sender: <xms:OlwXXtmLU14-7_RSAqAhLzFI2_BAY4A5V82oqQwME8tH6iZCLNgiYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiuddgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepie
    ejrdduiedtrddvudejrddvhedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgv
    shesrghnrghrrgiivghlrdguvgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:OlwXXq0WR0PtvZ_ri4vjXj1z9EuQmBTaPdxMeO12uG29VsZNasvPkQ>
    <xmx:OlwXXn4AgxPb70QLFkm9qv61C2iHasXHiDx1XM8DF7mvqaORJeFaXA>
    <xmx:OlwXXogv4koC5IyRXtFSAPeTTqMdAeVM4M-VQq9egBq_BqgCREpNUQ>
    <xmx:O1wXXnyvNMVU5h6qFXSyJKt46evGJQD7-ISV31neF0E-Y-ST2rlQUA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id B960830602DE;
        Thu,  9 Jan 2020 12:00:42 -0500 (EST)
Date:   Thu, 9 Jan 2020 09:00:41 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] perf c2c: Fix sorting.
Message-ID: <20200109170041.wgvxcci3mkjh4uee@alap3.anarazel.de>
References: <20200109043030.233746-1-andres@anarazel.de>
 <20200109084822.GD52936@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109084822.GD52936@krava>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2020-01-09 09:48:22 +0100, Jiri Olsa wrote:
> On Wed, Jan 08, 2020 at 08:30:30PM -0800, Andres Freund wrote:
> > Commit 722ddfde366f ("perf tools: Fix time sorting") changed -
> > correctly so - hist_entry__sort to return int64. Unfortunately several
> > of the builtin-c2c.c comparison routines only happened to work due the
> > cast caused by the wrong return type.
> > 
> > This causes meaningless ordering of both the cacheline list, and the
> > cacheline details page. E.g a simple
> >   perf c2c record -a sleep 3
> >   perf c2c report
> > will result in cacheline table like
> >   =================================================
> >              Shared Data Cache Line Table
> >   =================================================
> >   #
> >   #        ----------- Cacheline ----------    Total      Tot  ----- LLC Load Hitm -----  ---- Store Reference ----  --- Load Dram ----      LLC    Total  ----- Core Load Hit -----  -- LLC Load Hit --
> >   # Index             Address  Node  PA cnt  records     Hitm    Total      Lcl      Rmt    Total    L1Hit   L1Miss       Lcl       Rmt  Ld Miss    Loads       FB       L1       L2       Llc       Rmt
> >   # .....  ..................  ....  ......  .......  .......  .......  .......  .......  .......  .......  .......  ........  ........  .......  .......  .......  .......  .......  ........  ........
> >   #
> >         0      0x7f0d27ffba00   N/A       0       52    0.12%       13        6        7       12       12        0         0         7       14       40        4       16        0         0         0
> >         1      0x7f0d27ff61c0   N/A       0     6353   14.04%     1475      801      674      779      779        0         0       718     1392     5574     1299     1967        0       115         0
> >         2      0x7f0d26d3ec80   N/A       0       71    0.15%       16        4       12       13       13        0         0        12       24       58        1       20        0         9         0
> >         3      0x7f0d26d3ec00   N/A       0       98    0.22%       23       17        6       19       19        0         0         6       12       79        0       40        0        10         0
> > i.e. with the list not being ordered by Total Hitm.
> > 
> > Fixes: 722ddfde366f ("perf tools: Fix time sorting")
> > Signed-off-by: Andres Freund <andres@anarazel.de>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Michael Petlan <mpetlan@redhat.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: stable@vger.kernel.org # v3.16+
> > ---
> >  tools/perf/builtin-c2c.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
> > index e69f44941aad..f2e9d2b1b913 100644
> > --- a/tools/perf/builtin-c2c.c
> > +++ b/tools/perf/builtin-c2c.c
> > @@ -595,8 +595,8 @@ tot_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
> >  {
> >  	struct c2c_hist_entry *c2c_left;
> >  	struct c2c_hist_entry *c2c_right;
> > -	unsigned int tot_hitm_left;
> > -	unsigned int tot_hitm_right;
> > +	uint64_t tot_hitm_left;
> > +	uint64_t tot_hitm_right;
> 
> that change looks right, but I can't see how that could
> happened because of change in Fixes: tag
> 
> was the return statement of this function:
> 
>         return tot_hitm_left - tot_hitm_right;
> 
> considered to be 'unsigned int' and then converted to int64_t,
> which would treat negative 'unsigned int' as big positive 'int64_t'?

Correct. So e.g. when comparing 1 and 2 tot_hitm, we'd get (int64_t)
UINT_MAX as a result, which is obviously wrong. However, due to
hist_entry__sort() returning int at the time, this was masked, as the
int64_t was cast to int. Thereby again yielding a negative number for
the comparisons of hist_entry__sort()'s result.  After
hist_entry__sort() was fixed however, there never could be negative
return values (but 0's are possible) of hist_entry__sort() for c2c.

I briefly looked for places outside of c2c for similar issues in
hist_entry comparison routines, but didn't find any.

Greetings,

Andres Freund
