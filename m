Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6508A2BB561
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 20:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732377AbgKTT3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 14:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732366AbgKTT3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 14:29:40 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCD4C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 11:29:39 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id 74so15027997lfo.5
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 11:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ENdAioGv2Q8eY87iogzPJTHqRbYcuXrTklYSoVbeVw=;
        b=evS+J+XBR5p/6mcLYAKQLiKRO2uqyRSublTlr95YtwT17h9QD8IvA2RHEV+qDY+gIZ
         JOZBmzb7B7518iz/u245hunU4bVVPYU2EE9wSZDPYdInZHbY8p5p40hn7bZzQDZfm4//
         n5X+f4WcTeSEEoGlIB0zuOXHVvaQg7qDQJgy14VXrPgvui6zzon7LL83fPU//gQp4yG2
         iPA5aGTHX3nCxdpYx09TimLS4F4h3nuVBssI6uKoTXbCiKAOrRVG65uxwfgJfp/uycvK
         EZAVvgYrNMTTZvv1dghGsybJKMZCbQw4Mg3xH43wpknJw2p+Sbzd1kc3aagGuEkrTaLl
         vpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ENdAioGv2Q8eY87iogzPJTHqRbYcuXrTklYSoVbeVw=;
        b=b6wRkyDdplYdmS3BvF4ZwqrWCQ1i7OnUa5oDHVyxWpBjnmvpZyuOcsKNFtSIN1KHk9
         OOOKMK+Sw9p5FAtYPdkTVMLD+CAPCXWqFsnaboHHtqj5xRx8dU+wmhci991N6UD7oSvn
         3NaO0AD3AKqJHxg5/Ws5wHGRo/7oOt99/2wdrepxmA1FiYpo541ZkzDmfHbhxxxF7SqT
         AQ60uDgQVDcc4RQMYIsTotYUHS52HP7q8nPzeVbbCW/tw8UZ9Kh4N5clg1r7cl8K1Tga
         2r5VLlaMlPXLMqGu/kVWw2xWSybLbx/Isgql1BNKH6ZKdWSp0TOIbX3qzk4DDQ61wegR
         63/w==
X-Gm-Message-State: AOAM531idL/E6+sUlxDMsrG3j++Hk90BXlP6BgWk23olhCpEYTHRyit3
        cmYC/mxqULKqvcHlQMFOEAPZjfOMLhvO+erHOuE=
X-Google-Smtp-Source: ABdhPJzyhQ/51Q7dV9avp9L46zcpKh9dqFp/SqpRWdON+VWI4lWIjRseexpDE3IvVri66oqD2dWVFl/3LQRB7sJFgfQ=
X-Received: by 2002:a05:6512:21c:: with SMTP id a28mr8985486lfo.486.1605900578367;
 Fri, 20 Nov 2020 11:29:38 -0800 (PST)
MIME-Version: 1.0
References: <20201120073909.357536-1-carnil@debian.org> <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
 <20201120133400.GA405401@eldamar.lan> <CAHtQpK7=hpWLM-ztyTS8vzGDfG_46Qx2vc6q0fm1dDDU3W6+UA@mail.gmail.com>
 <20201120155317.GA502412@eldamar.lan> <CAHtQpK5Xuui3q6_x2FKQ1DbP-n8zFa_AR-uQFmcCOH2kzMR6fQ@mail.gmail.com>
 <20201120183008.GA518373@eldamar.lan>
In-Reply-To: <20201120183008.GA518373@eldamar.lan>
From:   Andrey Zhizhikin <andrey.z@gmail.com>
Date:   Fri, 20 Nov 2020 20:29:26 +0100
Message-ID: <CAHtQpK5af-MYz6pr6OzFUh4FwV9oG=2UxVPuaA2TBjLEvm6Tsw@mail.gmail.com>
Subject: Re: [PATCH] Revert "perf cs-etm: Move definition of 'traceid_list'
 global variable from header file"
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Salvatore,

On Fri, Nov 20, 2020 at 7:30 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
>
> Hi Andrey,
>
> On Fri, Nov 20, 2020 at 05:31:59PM +0100, Andrey Zhizhikin wrote:
> > Hello Salvatore,
> >
> > On Fri, Nov 20, 2020 at 4:53 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > >
> > > Hi Andrey,
> > >
> > > On Fri, Nov 20, 2020 at 03:29:39PM +0100, Andrey Zhizhikin wrote:
> > > > Hello Salvatore,
> > > >
> > > > On Fri, Nov 20, 2020 at 2:34 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > > > >
> > > > > Hi Andrey,
> > > > >
> > > > > On Fri, Nov 20, 2020 at 10:54:22AM +0100, Andrey Zhizhikin wrote:
> > > > > > On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > > > > > >
> > > > > > > This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> > > > > > > (but only from 4.19.y)
> > > > > >
> > > > > > This revert would fail the build of 4.19.y with gcc10, I believe the
> > > > > > original commit was introduced to address exactly this case. If this
> > > > > > is intended behavior that 4.19.y is not compiled with newer gcc
> > > > > > versions - then this revert is OK.
> > > > >
> > > > > TTBOMK, this would not regress the build for newer gcc (specifically
> > > > > gcc10) as 4.19.158 is failing perf tool builds there as well (without
> > > > > the above commit reverted). Just as an example v4.19.y does not have
> > > > > cff20b3151cc ("perf tests bp_account: Make global variable static")
> > > > > which is there in v5.6-rc6 to fix build failures with 10.0.1.
> > > > >
> > > > > But it did regress builds with older gcc's as for instance used in
> > > > > Debian buster (gcc 8.3.0) since 4.19.152.
> > > > >
> > > > > Do I possibly miss something? If there is a solution to make it build
> > > > > with newer GCCs and *not* regress previously working GCC versions then
> > > > > this is surely the best outcome though.
> > > >
> > > > I guess (and from what I understand in Leo's reply), porting of
> > > > 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to
> > > > traceID-metadata") should solve the issue for both older and newer gcc
> > > > versions.
> > > >
> > > > The breakage is now in
> > > > [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c] file (which uses
> > > > traceid_list inside). This is solved with the above commit, which
> > > > concealed traceid_list internally inside [tools/perf/util/cs-etm.c]
> > > > file and exposed to [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c]
> > > > via cs_etm__get_cpu() call.
> > > >
> > > > Can you try out to port that commit to see if that would solve your
> > > > regression?
> > >
> > > So something like the following will compile as well with the older
> > > gcc version.
> > >
> > > I realize: I mainline the order of the commits was:
> > >
> > > 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata")
> > > 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable from header f
> > > ile")
> > >
> > > But to v4.19.y only 168200b6d6ea was backported, and while that was
> > > done I now realize the comment was also changed including the change
> > > fom 95c6fe970a01.
> > >
> > > Thus the proposed backported patch would drop the change in
> > > tools/perf/util/cs-etm.c to the comment as this was already done.
> > > Thecnically currently the comment would be wrong, because it reads:
> > >
> > > /* RB tree for quick conversion between traceID and metadata pointers */
> > >
> > > but backport of 95c6fe970a01 is not included.
> > >
> > > Would the right thing to do thus be:
> > >
> > > - Revert b801d568c7d8 "perf cs-etm: Move definition of 'traceid_list' global variable from header file"
> > > - Backport 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata")
> > > - Backport 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable from header file")
> >
> > Yes, I believe this would be the correct course of action here; this
> > should cover the regression you've encountered and should ensure that
> > perf builds on both the "old" and "new" gcc versions.
>
> Although perf tools in v4.19.y won't compile with recent GCCs.
>
> Greg did already queued up the first part of it, so the revert. I
> think we can pick the later two commits again up after the v4.19.159
> release?

Sounds reasonable to me.

>
> Regards,
> Salvatore



-- 
Regards,
Andrey.
