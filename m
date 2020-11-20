Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1BA2BB325
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 19:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbgKTSaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 13:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729827AbgKTSaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 13:30:12 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03B5C0617A7
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 10:30:11 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id o15so11006413wru.6
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 10:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mPy/DPnzyZVR3Eu14UUOGC4ulr/TKIUgB8++zcFhoUo=;
        b=bweU88sR2cEcppOz+Hv+wBWZh2bk2PAJEvw1EnjeRSkaedTEEG92RDJ06DQs19NO8/
         6mxzsQNAwxcykltKQJoHS867uosEJ1FcX/Q21HAejHR9tbfnVY4iV/A1bMnhWVni9DyQ
         b+/glW6R0o2fyZT7Wh/YL+//jiLuNyGUU0FeU2j+68o9/69aC9im3cxBsRJ1GTAXgHw8
         5pBWKeWtpN3TAZeHSyAVPn1kX6/1mgdopN7pfTbtvjFNFhM57D0UzTomB2+w0WsD7pXd
         HiOvRK+oX873EcDljXl4GBCktEbdaiVs03fpTqXrk91iTWS1GPr1ZGCvRmunXTzrs+Fn
         0/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mPy/DPnzyZVR3Eu14UUOGC4ulr/TKIUgB8++zcFhoUo=;
        b=uOqh3JRB5KypcNiLKbRl2E8jF8Xd3ZS3cFIzyie5qakasRH93OaU7AxrCVFiE2iNX0
         tTtoTHyjp2FEVi3z6X+WkjkKelv3Yz32mvBDSxZuwwPfR24IaOJHLnWvlcJNRLmg5WeO
         TfW3Q0YzU31GrighMXKI9bxr0pbLh/ZAmF7BZ0C8J1K9qHVGA/pFjBoaExY4xPyDbhuM
         ccXVKuAcrIxdNzcOzlYcSC581C6Q8hEby98YKx2h/nVuQ9OQ/Q6UkirRa4sXy2T8SROa
         s277fdu0jZ9YYY1Na/sJFVt9Yie3MCa3oNDB+FgV5Upx/D5Pe1Pcj574qTLvQvOLs7Bv
         F/VQ==
X-Gm-Message-State: AOAM530HV7n6EIxy4UgKePa3AHVRkNCXpAz6VG0N9yMDNGsZXDZESPTm
        gFNUnjt9GT3KMZ2tQgg0pxrxnUgoBcFCUw==
X-Google-Smtp-Source: ABdhPJxtYw19EOhh8JbZ6iCu5arYHsY9ah90+IVT1WELOs9dC4N45TDNCjs+kQuBArMQRQN0tkR+Ug==
X-Received: by 2002:a05:6000:347:: with SMTP id e7mr17060337wre.35.1605897010715;
        Fri, 20 Nov 2020 10:30:10 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id n10sm6331537wrx.9.2020.11.20.10.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 10:30:09 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Fri, 20 Nov 2020 19:30:08 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Andrey Zhizhikin <andrey.z@gmail.com>
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
Subject: Re: [PATCH] Revert "perf cs-etm: Move definition of 'traceid_list'
 global variable from header file"
Message-ID: <20201120183008.GA518373@eldamar.lan>
References: <20201120073909.357536-1-carnil@debian.org>
 <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
 <20201120133400.GA405401@eldamar.lan>
 <CAHtQpK7=hpWLM-ztyTS8vzGDfG_46Qx2vc6q0fm1dDDU3W6+UA@mail.gmail.com>
 <20201120155317.GA502412@eldamar.lan>
 <CAHtQpK5Xuui3q6_x2FKQ1DbP-n8zFa_AR-uQFmcCOH2kzMR6fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHtQpK5Xuui3q6_x2FKQ1DbP-n8zFa_AR-uQFmcCOH2kzMR6fQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrey,

On Fri, Nov 20, 2020 at 05:31:59PM +0100, Andrey Zhizhikin wrote:
> Hello Salvatore,
> 
> On Fri, Nov 20, 2020 at 4:53 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> >
> > Hi Andrey,
> >
> > On Fri, Nov 20, 2020 at 03:29:39PM +0100, Andrey Zhizhikin wrote:
> > > Hello Salvatore,
> > >
> > > On Fri, Nov 20, 2020 at 2:34 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > > >
> > > > Hi Andrey,
> > > >
> > > > On Fri, Nov 20, 2020 at 10:54:22AM +0100, Andrey Zhizhikin wrote:
> > > > > On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > > > > >
> > > > > > This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> > > > > > (but only from 4.19.y)
> > > > >
> > > > > This revert would fail the build of 4.19.y with gcc10, I believe the
> > > > > original commit was introduced to address exactly this case. If this
> > > > > is intended behavior that 4.19.y is not compiled with newer gcc
> > > > > versions - then this revert is OK.
> > > >
> > > > TTBOMK, this would not regress the build for newer gcc (specifically
> > > > gcc10) as 4.19.158 is failing perf tool builds there as well (without
> > > > the above commit reverted). Just as an example v4.19.y does not have
> > > > cff20b3151cc ("perf tests bp_account: Make global variable static")
> > > > which is there in v5.6-rc6 to fix build failures with 10.0.1.
> > > >
> > > > But it did regress builds with older gcc's as for instance used in
> > > > Debian buster (gcc 8.3.0) since 4.19.152.
> > > >
> > > > Do I possibly miss something? If there is a solution to make it build
> > > > with newer GCCs and *not* regress previously working GCC versions then
> > > > this is surely the best outcome though.
> > >
> > > I guess (and from what I understand in Leo's reply), porting of
> > > 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to
> > > traceID-metadata") should solve the issue for both older and newer gcc
> > > versions.
> > >
> > > The breakage is now in
> > > [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c] file (which uses
> > > traceid_list inside). This is solved with the above commit, which
> > > concealed traceid_list internally inside [tools/perf/util/cs-etm.c]
> > > file and exposed to [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c]
> > > via cs_etm__get_cpu() call.
> > >
> > > Can you try out to port that commit to see if that would solve your
> > > regression?
> >
> > So something like the following will compile as well with the older
> > gcc version.
> >
> > I realize: I mainline the order of the commits was:
> >
> > 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata")
> > 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable from header f
> > ile")
> >
> > But to v4.19.y only 168200b6d6ea was backported, and while that was
> > done I now realize the comment was also changed including the change
> > fom 95c6fe970a01.
> >
> > Thus the proposed backported patch would drop the change in
> > tools/perf/util/cs-etm.c to the comment as this was already done.
> > Thecnically currently the comment would be wrong, because it reads:
> >
> > /* RB tree for quick conversion between traceID and metadata pointers */
> >
> > but backport of 95c6fe970a01 is not included.
> >
> > Would the right thing to do thus be:
> >
> > - Revert b801d568c7d8 "perf cs-etm: Move definition of 'traceid_list' global variable from header file"
> > - Backport 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata")
> > - Backport 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable from header file")
> 
> Yes, I believe this would be the correct course of action here; this
> should cover the regression you've encountered and should ensure that
> perf builds on both the "old" and "new" gcc versions.

Although perf tools in v4.19.y won't compile with recent GCCs.

Greg did already queued up the first part of it, so the revert. I
think we can pick the later two commits again up after the v4.19.159
release?

Regards,
Salvatore
