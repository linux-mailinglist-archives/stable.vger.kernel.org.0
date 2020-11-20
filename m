Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D102BA69D
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 10:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgKTJyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 04:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgKTJyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 04:54:36 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B3AC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 01:54:35 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id l11so12650270lfg.0
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 01:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nnr8xWshzVfRjqu1lVD3lA2hqfRThose+MzndLukA5Y=;
        b=S55LSSXQa9tBayuVd5ZHIYziszlgzXhSSzxIoDEaeIkQLf40s8sfWltKwotACbyZN/
         XMlUJWGtbCYaNCKADg4DLa4kxwHK4nAAeR2rX7HD4+bTdTOq+VaYymknfa2R4pQyz810
         Be6p2pT6+YE8TmZ1zCOqx7ucBJMbEUpIU2UAXUnMZskn4PpRT5y4OJuKXPqQO8xqjB98
         BPDpDaMfMolFrEmcoQXgj74oAQnTNHk5y8nqgxZvqM/ur9MsIvVwjQzTAvBhV+/mes1T
         /j0fIt5N/F6C1mQESm21fXeA8dgVui5UUOFUBipEcqWXPFUOTcC0FZ/XgyPav/Af8PxR
         XyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nnr8xWshzVfRjqu1lVD3lA2hqfRThose+MzndLukA5Y=;
        b=DYodmu3qrkbp/oft+e+8XIDi4dLUMirFcyLp1awNfQPO2PgEJd3UZsOllOEvYWmQpB
         tFV7Vh0K7hhOvMGKQ9G2Y037F43QSIuD+xmYmVA4ZN+0yy1D6q8POIz8aHzcjYXm+HRo
         6mAH05OgiZH4PgW899VUHoK0+zdI3hLA1ajoIh9v6bWA9JGaTyzEjAEeP+pFYp0hhC4C
         43mjWryNw/Qmgv9FiTlEDg/DisZlOZiZQPFMEzYEa2237FE4br93IHjti+uY5ho51sr3
         3RG8FWHXQO3XtH8Gf8coy9p82eecly1YQevLvnnLK3V8OmcVcU9lHxEeaYZGD3A9vJyj
         HYUg==
X-Gm-Message-State: AOAM532Q6igtAE19nQn8dFUF+Lb3IMHvT53VPAGtMS/1luZJ0XE3UI14
        39SE1yXzlGv3fY0Au2zzDndMXUnVNCsEw5LjSOU=
X-Google-Smtp-Source: ABdhPJy7aroUKAZ9gMHPtCx1laZutVR0g0rWiiItqvOzcRuSiZn2F1jSZLCAURM899b4LzMWe0iYCwDMyXe8CCuT15I=
X-Received: by 2002:a05:6512:21c:: with SMTP id a28mr7945973lfo.486.1605866074172;
 Fri, 20 Nov 2020 01:54:34 -0800 (PST)
MIME-Version: 1.0
References: <20201120073909.357536-1-carnil@debian.org>
In-Reply-To: <20201120073909.357536-1-carnil@debian.org>
From:   Andrey Zhizhikin <andrey.z@gmail.com>
Date:   Fri, 20 Nov 2020 10:54:22 +0100
Message-ID: <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
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

On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
>
> This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> (but only from 4.19.y)

This revert would fail the build of 4.19.y with gcc10, I believe the
original commit was introduced to address exactly this case. If this
is intended behavior that 4.19.y is not compiled with newer gcc
versions - then this revert is OK.

>
> The original commit introduces a build failure as seen on Debian buster
> when compiled with gcc (Debian 8.3.0-6) 8.3.0:
>
>   $ LC_ALL=C.UTF-8 ARCH=x86 make perf
>   [...]
>   Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'
>     CC       util/cs-etm-decoder/cs-etm-decoder.o
>     CC       util/intel-pt.o
>   util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer_packet':
>   util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undeclared (first use in this function); did you mean 'trace_event'?
>     inode = intlist__find(traceid_list, trace_chan_id);
>                           ^~~~~~~~~~~~
>                           trace_event
>   util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identifier is reported only once for each function it appears in
>   make[6]: *** [/build/linux-stable/tools/build/Makefile.build:97: util/cs-etm-decoder/cs-etm-decoder.o] Error 1
>   make[5]: *** [/build/linux-stable/tools/build/Makefile.build:139: cs-etm-decoder] Error 2
>   make[5]: *** Waiting for unfinished jobs....
>   make[4]: *** [/build/linux-stable/tools/build/Makefile.build:139: util] Error 2
>   make[3]: *** [Makefile.perf:633: libperf-in.o] Error 2
>   make[2]: *** [Makefile.perf:206: sub-make] Error 2
>   make[1]: *** [Makefile:70: all] Error 2
>   make: *** [Makefile:77: perf] Error 2
>
> Link: https://lore.kernel.org/stable/20201114083501.GA468764@eldamar.lan/
> Cc: Leo Yan <leo.yan@linaro.org>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
> Cc: Tor Jeremiassen <tor@ti.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # 4.19.y
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> ---
>  tools/perf/util/cs-etm.c | 3 ---
>  tools/perf/util/cs-etm.h | 3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> index ad33b99f5d21..7b5e15cc6b71 100644
> --- a/tools/perf/util/cs-etm.c
> +++ b/tools/perf/util/cs-etm.c
> @@ -87,9 +87,6 @@ struct cs_etm_queue {
>         struct cs_etm_packet *packet;
>  };
>
> -/* RB tree for quick conversion between traceID and metadata pointers */
> -static struct intlist *traceid_list;
> -
>  static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
>  static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
>                                            pid_t tid, u64 time_);
> diff --git a/tools/perf/util/cs-etm.h b/tools/perf/util/cs-etm.h
> index c7ef97b198c7..37f8d48179ca 100644
> --- a/tools/perf/util/cs-etm.h
> +++ b/tools/perf/util/cs-etm.h
> @@ -53,6 +53,9 @@ enum {
>         CS_ETMV4_PRIV_MAX,
>  };
>
> +/* RB tree for quick conversion between traceID and CPUs */
> +struct intlist *traceid_list;
> +
>  #define KiB(x) ((x) * 1024)
>  #define MiB(x) ((x) * 1024 * 1024)
>
> --
> 2.29.2
>


-- 
Regards,
Andrey.
