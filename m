Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C75C2BC5DC
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 14:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbgKVNnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 08:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgKVNnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 08:43:49 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954E7C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 05:43:47 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id s63so1853879pgc.8
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 05:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VMo/8v8YIHV7YCxMTFk+wlmDiZzGS+1fgOlxp3NW+zk=;
        b=INjCAaq6oOv/oBDuqHTLj0/biF5ioqGgLs9OLO0CYfhKajkiiN6LU2cPOypmixoCYu
         PXxUEZlAyPlwdfvOY3PxhfOMk0Q7opZ3GODIYqzT7cFgenAuTr+2rqP3SdT94Sp1YAPE
         9HNhMO2qbPKXJDgF9vuTuWfwHkZbG6IwCEVfXWfHC7OXkRY/WDEwP2BgAXUj44xpUATs
         brVNtivLEiZSzir4bXKv0T4dmz12kJJlyHbEqKCNdxdRl3SMmkVuOwZ3WcKJrr0Qyj8I
         LXCz7+MiLdQ3bNb8sKWwV25xdR6phfF51OItO0uUOIUQzyL2Y78M5yqKoG4oI8AsyHvU
         MLoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VMo/8v8YIHV7YCxMTFk+wlmDiZzGS+1fgOlxp3NW+zk=;
        b=t9N8RyhG+5lbTOpK0zxUsnn1fzy9D3obIH3OzytbzmYv6WWNNVJYDRnCJTVNFK62Lg
         +NuyxUh65/yZwOXRR3lR+gzPFO6fr+4N38S+xXRpZlBqW3U5vRfVbUOaj9pqFE0HfeEJ
         v2nQWybSZyArN0Cq84ze25/0UIwFUmIjbYZWODwBE8IwFtzJ4tHVHulsUWdss69Lts+4
         N4Lg2yRpm1rk3VNz9Jf9hzEYUlrqWKwW2N28l2aZHdrYJKDw8Ow6vXCjeDMKCYY/LIU8
         8Z2fzqIQBAKfH4ZW7mOcuLYMiKKzLxXmYxTnYmIxvXsFuCYhmlAppEg6Ps8D6yeKvpMF
         oE8A==
X-Gm-Message-State: AOAM533bUEd5dhNLiUnecTGc5tTVXVSvCoTgI4xtrwTrsf0rlGkYLtLp
        ZIRn289tMBnp/qftp552Pk7wUg==
X-Google-Smtp-Source: ABdhPJxI5pg/SCpTmhDzOWHOPGG4pg40SBSvv9qqkrmRSXS4xQslIcnQzAfzrxeXVx3NIiUKLy0k6w==
X-Received: by 2002:aa7:969d:0:b029:196:59ad:ab93 with SMTP id f29-20020aa7969d0000b029019659adab93mr21527507pfk.16.1606052626829;
        Sun, 22 Nov 2020 05:43:46 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([103.127.239.100])
        by smtp.gmail.com with ESMTPSA id d25sm1243320pfo.172.2020.11.22.05.43.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Nov 2020 05:43:46 -0800 (PST)
Date:   Sun, 22 Nov 2020 21:43:39 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Andrey Zhizhikin <andrey.z@gmail.com>, stable@vger.kernel.org,
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
Message-ID: <20201122134339.GA6071@leoy-ThinkPad-X240s>
References: <20201120073909.357536-1-carnil@debian.org>
 <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
 <20201120133400.GA405401@eldamar.lan>
 <CAHtQpK7=hpWLM-ztyTS8vzGDfG_46Qx2vc6q0fm1dDDU3W6+UA@mail.gmail.com>
 <20201120155317.GA502412@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120155317.GA502412@eldamar.lan>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Salvatore, Andrey,

On Fri, Nov 20, 2020 at 04:53:17PM +0100, Salvatore Bonaccorso wrote:
> Hi Andrey,
> 
> On Fri, Nov 20, 2020 at 03:29:39PM +0100, Andrey Zhizhikin wrote:
> > Hello Salvatore,
> > 
> > On Fri, Nov 20, 2020 at 2:34 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > >
> > > Hi Andrey,
> > >
> > > On Fri, Nov 20, 2020 at 10:54:22AM +0100, Andrey Zhizhikin wrote:
> > > > On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > > > >
> > > > > This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> > > > > (but only from 4.19.y)
> > > >
> > > > This revert would fail the build of 4.19.y with gcc10, I believe the
> > > > original commit was introduced to address exactly this case. If this
> > > > is intended behavior that 4.19.y is not compiled with newer gcc
> > > > versions - then this revert is OK.
> > >
> > > TTBOMK, this would not regress the build for newer gcc (specifically
> > > gcc10) as 4.19.158 is failing perf tool builds there as well (without
> > > the above commit reverted). Just as an example v4.19.y does not have
> > > cff20b3151cc ("perf tests bp_account: Make global variable static")
> > > which is there in v5.6-rc6 to fix build failures with 10.0.1.
> > >
> > > But it did regress builds with older gcc's as for instance used in
> > > Debian buster (gcc 8.3.0) since 4.19.152.
> > >
> > > Do I possibly miss something? If there is a solution to make it build
> > > with newer GCCs and *not* regress previously working GCC versions then
> > > this is surely the best outcome though.
> > 
> > I guess (and from what I understand in Leo's reply), porting of
> > 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to
> > traceID-metadata") should solve the issue for both older and newer gcc
> > versions.
> > 
> > The breakage is now in
> > [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c] file (which uses
> > traceid_list inside). This is solved with the above commit, which
> > concealed traceid_list internally inside [tools/perf/util/cs-etm.c]
> > file and exposed to [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c]
> > via cs_etm__get_cpu() call.
> > 
> > Can you try out to port that commit to see if that would solve your
> > regression?
> 
> So something like the following will compile as well with the older
> gcc version.
> 
> I realize: I mainline the order of the commits was:
> 
> 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata")
> 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable from header f
> ile")
> 
> But to v4.19.y only 168200b6d6ea was backported, and while that was
> done I now realize the comment was also changed including the change
> fom 95c6fe970a01.
> 
> Thus the proposed backported patch would drop the change in
> tools/perf/util/cs-etm.c to the comment as this was already done.
> Thecnically currently the comment would be wrong, because it reads:
> 
> /* RB tree for quick conversion between traceID and metadata pointers */
> 
> but backport of 95c6fe970a01 is not included.
> 
> Would the right thing to do thus be:
> 
> - Revert b801d568c7d8 "perf cs-etm: Move definition of 'traceid_list' global variable from header file"
> - Backport 95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to traceID-metadata")
> - Backport 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable from header file")
> 
> ?
> 
> Leo ist that what you were proposing?

Though this isn't my proposing, I totally agree with this :)

Just some notes: prior to apply the commit 95c6fe970a01,
tools/perf/util/cs-etm-decoder/cs-etm-decoder.c is the only source
file which uses the variable "traceid_list"; after applied the commit
95c6fe970a01, the code for using the variable "traceid_list" has been
moved out from tools/perf/util/cs-etm-decoder/cs-etm-decoder.c and
moved in tools/perf/util/cs-etm.c.

So the commit 168200b6d6ea moves the definition of "traceid_list" from
the header file to the source file tools/perf/util/cs-etm.c and it
defines the variable as "static".

As you mentioned, backporting 95c6fe970a01 and 168200b6d6ea can fix
both for the older (8.3.0) and new GCC (10.0.1).  And I confirmed this
should not cause logic issue.

Thanks for looking at this issue.

Leo
