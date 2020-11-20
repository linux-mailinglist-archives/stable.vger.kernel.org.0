Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB502BA8DC
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgKTLTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgKTLTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 06:19:54 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5317C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 03:19:54 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id s2so4695391plr.9
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 03:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jzUvy2GP+Do0ZviqSu559sAr0WjErhNCen33kScI3uU=;
        b=yoxSJnMofkioQkAOq770pJb98kN/rmkiWky7sBiH4Kktnl8fsnc4rDsNqQS1ETEkQo
         njmLa0XU5hW8LnmW9hZlhMRALuu+b6vwtze/vDaeIHKf4vD7vTYsVtnJ00WUtAmKRtd0
         Fzl7HEYML+k5jJwPL6IzWc526WjaOIIY+eEbthwIrTgPzvPuq2YWV7r4G2p3PEh/WnLO
         XIdgzM2FD2nAQWDKP2Sm7g8eR5fJBz8seD//r0jQP3D4pYNxQwB7pc/pcPKMtYQ2Ls87
         MoKFN3AQX7O6s4umVawBuLZMiGVtWfglD8dhkOlfM/D6TEqw56HotSodFppG96gFqtPX
         4iKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jzUvy2GP+Do0ZviqSu559sAr0WjErhNCen33kScI3uU=;
        b=BNrernRTP1rtQ1gTjM1jnaS+EwW7eEywi204x3yfzGinbZPFss/opQBD2sMQDv07Va
         jpKTXyAH9mu80ivY9AmQgIaW/b8k/4/qe6MB7DMTEHOb/UhyStv0be3CSrMKNEfMUUO3
         ZhzjAxjyhh9h7KfCP+mkN02eeKMmlLMQy5df9A5z6uOFIqtrgOGaCccdPn2ApLCcndaP
         OTjSgRwYnAidv4YtAly3MpMx6ZdLSwPbAkzyoTOcSWPQI4navIUNCHwK8YIdmpsXpmRR
         3E4Xvs4mcPF3nUHnFL38bLT9Likjy73u2hcK1T/R394etu33jSNAwj5RpZLsMktcSf3h
         yU8Q==
X-Gm-Message-State: AOAM530Qf0l8CP9jYOfxAt1SrTIMaGMZniOKzVxoPcYe5cij9ZQtpTtZ
        TKTdlN+n0WNA27eOgtB4lNR4qw==
X-Google-Smtp-Source: ABdhPJw4xz7zBkSSwoUhsAk5D3z40PXbitBnow5Z1TxuM4r0cUxM+L3uuUFdqwOHtukEdM1iPjVMkQ==
X-Received: by 2002:a17:902:c214:b029:d6:9a2d:216c with SMTP id 20-20020a170902c214b02900d69a2d216cmr13533447pll.65.1605871194276;
        Fri, 20 Nov 2020 03:19:54 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([103.127.239.100])
        by smtp.gmail.com with ESMTPSA id fh22sm3201556pjb.45.2020.11.20.03.19.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Nov 2020 03:19:53 -0800 (PST)
Date:   Fri, 20 Nov 2020 19:19:48 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Andrey Zhizhikin <andrey.z@gmail.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org,
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
Message-ID: <20201120111948.GA7077@leoy-ThinkPad-X240s>
References: <20201120073909.357536-1-carnil@debian.org>
 <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 10:54:22AM +0100, Andrey Zhizhikin wrote:
> On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
> >
> > This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> > (but only from 4.19.y)
> 
> This revert would fail the build of 4.19.y with gcc10, I believe the
> original commit was introduced to address exactly this case. If this
> is intended behavior that 4.19.y is not compiled with newer gcc
> versions - then this revert is OK.

The original commit has a dependency for commit 95c6fe970a01 ("perf
cs-etm: Change tuple from traceID-CPU# to traceID-metadata").  If the
commit 95c6fe970a01 is not backported on v4.19.y, then I think reverting
in this patch is the right way to do.

Thanks,
Leo

> > The original commit introduces a build failure as seen on Debian buster
> > when compiled with gcc (Debian 8.3.0-6) 8.3.0:
> >
> >   $ LC_ALL=C.UTF-8 ARCH=x86 make perf
> >   [...]
> >   Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'
> >     CC       util/cs-etm-decoder/cs-etm-decoder.o
> >     CC       util/intel-pt.o
> >   util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer_packet':
> >   util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undeclared (first use in this function); did you mean 'trace_event'?
> >     inode = intlist__find(traceid_list, trace_chan_id);
> >                           ^~~~~~~~~~~~
> >                           trace_event
> >   util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identifier is reported only once for each function it appears in
> >   make[6]: *** [/build/linux-stable/tools/build/Makefile.build:97: util/cs-etm-decoder/cs-etm-decoder.o] Error 1
> >   make[5]: *** [/build/linux-stable/tools/build/Makefile.build:139: cs-etm-decoder] Error 2
> >   make[5]: *** Waiting for unfinished jobs....
> >   make[4]: *** [/build/linux-stable/tools/build/Makefile.build:139: util] Error 2
> >   make[3]: *** [Makefile.perf:633: libperf-in.o] Error 2
> >   make[2]: *** [Makefile.perf:206: sub-make] Error 2
> >   make[1]: *** [Makefile:70: all] Error 2
> >   make: *** [Makefile:77: perf] Error 2
> >
> > Link: https://lore.kernel.org/stable/20201114083501.GA468764@eldamar.lan/
> > Cc: Leo Yan <leo.yan@linaro.org>
> > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
> > Cc: Tor Jeremiassen <tor@ti.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: <stable@vger.kernel.org> # 4.19.y
> > Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> > ---
> >  tools/perf/util/cs-etm.c | 3 ---
> >  tools/perf/util/cs-etm.h | 3 +++
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> > index ad33b99f5d21..7b5e15cc6b71 100644
> > --- a/tools/perf/util/cs-etm.c
> > +++ b/tools/perf/util/cs-etm.c
> > @@ -87,9 +87,6 @@ struct cs_etm_queue {
> >         struct cs_etm_packet *packet;
> >  };
> >
> > -/* RB tree for quick conversion between traceID and metadata pointers */
> > -static struct intlist *traceid_list;
> > -
> >  static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
> >  static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
> >                                            pid_t tid, u64 time_);
> > diff --git a/tools/perf/util/cs-etm.h b/tools/perf/util/cs-etm.h
> > index c7ef97b198c7..37f8d48179ca 100644
> > --- a/tools/perf/util/cs-etm.h
> > +++ b/tools/perf/util/cs-etm.h
> > @@ -53,6 +53,9 @@ enum {
> >         CS_ETMV4_PRIV_MAX,
> >  };
> >
> > +/* RB tree for quick conversion between traceID and CPUs */
> > +struct intlist *traceid_list;
> > +
> >  #define KiB(x) ((x) * 1024)
> >  #define MiB(x) ((x) * 1024 * 1024)
> >
> > --
> > 2.29.2
> >
> 
> 
> -- 
> Regards,
> Andrey.
