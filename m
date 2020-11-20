Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF32BA9FA
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 13:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgKTMQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 07:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgKTMQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 07:16:03 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E7DC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:16:02 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id r9so13143938lfn.11
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MVSaOkF3AomvYRttVt5pT5G0ZpChiXWS9V8yrqr9bO4=;
        b=U+Ag/6xGozQSd+HaCLrD0hEWIdBg6mA2vBFEougKY9KNMaThva+1LwdWfiNkZwlHNh
         cfK3oxd7cE54uC+TYTfZwY1jH83PxOO5EOQp6k8ppLJFSRjFU3sgv/3cMhwPbiXBRRs1
         52WimeDmht3hFYSe6blyahsBklPiH5sbjWrnxW8ey+x40VCi805l97LBAy7p9JRg2HIW
         rr1j4Va8cq2vvYHvH0g+SopkAJiW+8NkJGfgbi9VZevMU7YvWgQHgtxiYRk5oxZA6QaP
         G5EtGykkSATFIqgF8OhhDs0P6Juwj7yq1otoVNTYfNHx/BfYLOK60c0pTFCG6z+5WuWy
         747w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MVSaOkF3AomvYRttVt5pT5G0ZpChiXWS9V8yrqr9bO4=;
        b=Tks+YTtUwgn2M+7tj5l3Qe3zk9B3xYzqvDxcqLULn3OFRpi8VlcvixhleP9bkEQXov
         GQ0fvJvyL28UPkryeJRQmxDB2Uv41amIc8Wp2HhY7Qd5faDznVAGFlckh9nCY5/qNemq
         xRAw+w5uRLcS2BXlcc8EwBoyzRU17kMWiCY6t4adC0iBoJZ1s4qNJdMx/53Jmz1D8O0e
         QKtaIwpednlR7oke1ohHeTPBbQNyqnKuinzd5V7EC6yLrwg9Xj7OeUuWsk8B12RGV/pX
         u5qQY6CtPPrgVM1yhUwbecsowdo+byu6xN+8A97HgyyTVApmV4oXvW4kqUZCM4jI+1/V
         C1bQ==
X-Gm-Message-State: AOAM530D+hzbjkDGfg3ejbzzqrD0MsqAwtzN5+41HlVOwzRdGrjA9jvm
        PFUqADYmDoVXaSGmjKPFi4t1RDah6HmpVxN4HR/+nMaz9cHcNg==
X-Google-Smtp-Source: ABdhPJxHhDispxKgVq6UB2k87k0Hbs8a1DiHLZ6sjyEAyXB3TVnLWRnnuT4B/xUmAR/+M6hO/EUXkqfYDjDP7is5plg=
X-Received: by 2002:a05:6512:2151:: with SMTP id s17mr8275696lfr.287.1605874561147;
 Fri, 20 Nov 2020 04:16:01 -0800 (PST)
MIME-Version: 1.0
References: <20201120073909.357536-1-carnil@debian.org> <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
 <20201120111948.GA7077@leoy-ThinkPad-X240s>
In-Reply-To: <20201120111948.GA7077@leoy-ThinkPad-X240s>
From:   Andrey Zhizhikin <andrey.z@gmail.com>
Date:   Fri, 20 Nov 2020 13:15:49 +0100
Message-ID: <CAHtQpK6LsBS4acs_A-3=Wg9sVZqUwFxQPnmC9kLE2erc2zmbag@mail.gmail.com>
Subject: Re: [PATCH] Revert "perf cs-etm: Move definition of 'traceid_list'
 global variable from header file"
To:     Leo Yan <leo.yan@linaro.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 12:19 PM Leo Yan <leo.yan@linaro.org> wrote:
>
> On Fri, Nov 20, 2020 at 10:54:22AM +0100, Andrey Zhizhikin wrote:
> > On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > >
> > > This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> > > (but only from 4.19.y)
> >
> > This revert would fail the build of 4.19.y with gcc10, I believe the
> > original commit was introduced to address exactly this case. If this
> > is intended behavior that 4.19.y is not compiled with newer gcc
> > versions - then this revert is OK.
>
> The original commit has a dependency for commit 95c6fe970a01 ("perf
> cs-etm: Change tuple from traceID-CPU# to traceID-metadata").  If the
> commit 95c6fe970a01 is not backported on v4.19.y, then I think reverting
> in this patch is the right way to do.

Commit 95c6fe970a01 (perf cs-etm: Change tuple from traceID-CPU# to
traceID-metadata) did not change a definition of traceid_list in
tools/perf/util/cs-etm.h header file rather a comment above it.

Definition of traceid_list in tools/perf/util/cs-etm.h header file was
done in commit cd8bfd8c973ea (perf tools: Add processing of coresight
metadata) which appears in all branches starting from linux-4.16.y.

The issue with this definition of traceid_list in header file would
break perf builds with newer gcc versions if this commit would be
reverted, so I believe that than rather reverting - commit
95c6fe970a01 ("perf
cs-etm: Change tuple from traceID-CPU# to traceID-metadata") should be
backported onto 4.19.y instead.

Or am I missing something else here?


>
> Thanks,
> Leo
>
> > > The original commit introduces a build failure as seen on Debian buster
> > > when compiled with gcc (Debian 8.3.0-6) 8.3.0:
> > >
> > >   $ LC_ALL=C.UTF-8 ARCH=x86 make perf
> > >   [...]
> > >   Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'
> > >     CC       util/cs-etm-decoder/cs-etm-decoder.o
> > >     CC       util/intel-pt.o
> > >   util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer_packet':
> > >   util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undeclared (first use in this function); did you mean 'trace_event'?
> > >     inode = intlist__find(traceid_list, trace_chan_id);
> > >                           ^~~~~~~~~~~~
> > >                           trace_event
> > >   util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identifier is reported only once for each function it appears in
> > >   make[6]: *** [/build/linux-stable/tools/build/Makefile.build:97: util/cs-etm-decoder/cs-etm-decoder.o] Error 1
> > >   make[5]: *** [/build/linux-stable/tools/build/Makefile.build:139: cs-etm-decoder] Error 2
> > >   make[5]: *** Waiting for unfinished jobs....
> > >   make[4]: *** [/build/linux-stable/tools/build/Makefile.build:139: util] Error 2
> > >   make[3]: *** [Makefile.perf:633: libperf-in.o] Error 2
> > >   make[2]: *** [Makefile.perf:206: sub-make] Error 2
> > >   make[1]: *** [Makefile:70: all] Error 2
> > >   make: *** [Makefile:77: perf] Error 2
> > >
> > > Link: https://lore.kernel.org/stable/20201114083501.GA468764@eldamar.lan/
> > > Cc: Leo Yan <leo.yan@linaro.org>
> > > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > > Cc: Jiri Olsa <jolsa@redhat.com>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: Namhyung Kim <namhyung@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
> > > Cc: Tor Jeremiassen <tor@ti.com>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Cc: Guenter Roeck <linux@roeck-us.net>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: <stable@vger.kernel.org> # 4.19.y
> > > Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> > > ---
> > >  tools/perf/util/cs-etm.c | 3 ---
> > >  tools/perf/util/cs-etm.h | 3 +++
> > >  2 files changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> > > index ad33b99f5d21..7b5e15cc6b71 100644
> > > --- a/tools/perf/util/cs-etm.c
> > > +++ b/tools/perf/util/cs-etm.c
> > > @@ -87,9 +87,6 @@ struct cs_etm_queue {
> > >         struct cs_etm_packet *packet;
> > >  };
> > >
> > > -/* RB tree for quick conversion between traceID and metadata pointers */
> > > -static struct intlist *traceid_list;
> > > -
> > >  static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
> > >  static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
> > >                                            pid_t tid, u64 time_);
> > > diff --git a/tools/perf/util/cs-etm.h b/tools/perf/util/cs-etm.h
> > > index c7ef97b198c7..37f8d48179ca 100644
> > > --- a/tools/perf/util/cs-etm.h
> > > +++ b/tools/perf/util/cs-etm.h
> > > @@ -53,6 +53,9 @@ enum {
> > >         CS_ETMV4_PRIV_MAX,
> > >  };
> > >
> > > +/* RB tree for quick conversion between traceID and CPUs */
> > > +struct intlist *traceid_list;
> > > +
> > >  #define KiB(x) ((x) * 1024)
> > >  #define MiB(x) ((x) * 1024 * 1024)
> > >
> > > --
> > > 2.29.2
> > >
> >
> >
> > --
> > Regards,
> > Andrey.



--
Regards,
Andrey.
