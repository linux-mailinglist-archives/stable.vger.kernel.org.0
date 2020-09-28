Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3030027B5BE
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 21:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgI1Tyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 15:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgI1Tyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 15:54:44 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E11C0613CE
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 12:54:44 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id q13so1512098vsj.13
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 12:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iNpDShrVH0G/yhVSSFMZRjI6zLZIrWDL5WcnPUrYGzk=;
        b=GyPa84B2gDRjXkfCs6NUDZmJEyPJ4/aOBxxs5SluRxk+xDHeeMdBdYam31QWJvC7U1
         L9JYguE062Ayx4K6/mqBIzcFcUIyZ7fdcr5PTF3vFUzX81ZxHjjButBuMRTYjMcD/JWM
         +0/du/7KsYoDnJ3945FToisyazVuA5fS0RSRo9veeBudFhqKsml63C9W4od0s5qEMqE7
         BnCcSOSIB8yUBs/UAHphk7LO6Ny4AN5wMlktb6d2YvSJf9E2sbYeXJ7jdG2GIR1+JhBq
         0e9+5xbp2gPt3qIQ+sWYpcF3ken54zKdkbq0znlvpiFPA7DbMClVE+7NhFXTrnWpQIRu
         0Ygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iNpDShrVH0G/yhVSSFMZRjI6zLZIrWDL5WcnPUrYGzk=;
        b=NpvGyOZbI2MmZww5ZSubbJr9RV26WiVh1gDlZX3ev/8i5SiUC8TVN9BUJb5eNC3/9L
         WIf+RPW3eXpbKs7YwnSOv/EWfL53hdJTeao7BmhmreaQFgmzKsolOBvacuKhv/RgruLh
         q7Aiir7NFLuuYIZXMdlSiuoa5H9aHnkfZmBLaNh3zLaKt7r3Tvma1lIoyu0JwCbI4ysO
         3yji6bHqpSlM3ezRDASBGd9Fki8PahRZ8O9ijfS71U+cl517M8sx02XLblPhuZLBYCne
         0w4o6zdXqlS1rpkCNtk5boboGEza3EkjW77PcNdFhlJtikHzCHhTueUDZf3jfsYQRcoN
         uUcw==
X-Gm-Message-State: AOAM530N+hr//0SEkAEN5JVFuYqTCWKMcGwhQtD3GfX0HwmFh3ihIuxw
        oOeMsaibYrmRIOv3QR8i9CAJDtiX8Sy9VUX/5zH/HQ==
X-Google-Smtp-Source: ABdhPJyKWBQujyJVRHGrieRaSMsZmWbNB9hyqNqokl7AeUU5BIFXRGbNbptSBgg8A0uaH6NdaRJx7pPfbvsJBwoZZPc=
X-Received: by 2002:a67:bd12:: with SMTP id y18mr893885vsq.45.1601322883397;
 Mon, 28 Sep 2020 12:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200918021220.2066485-1-sashal@kernel.org> <20200918021220.2066485-112-sashal@kernel.org>
In-Reply-To: <20200918021220.2066485-112-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Sep 2020 01:24:32 +0530
Message-ID: <CA+G9fYteKZxdLVtQzXyh36hhaj6W5e17U_emsXwZdjPoeyj+OQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 112/127] perf parse-events: Fix incorrect
 conversion of 'if () free()' to 'zfree()'
To:     Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        clang-built-linux@googlegroups.com, Jiri Olsa <jolsa@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Sep 2020 at 08:00, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> [ Upstream commit 7fcdccd4237724931d9773d1e3039bfe053a6f52 ]
>
> When applying a patch by Ian I incorrectly converted to zfree() an
> expression that involved testing some other struct member, not the one
> being freed, which lead to bugs reproduceable by:
>
>   $ perf stat -e i/bs,tsc,L2/o sleep 1
>   WARNING: multiple event parsing errors
>   Segmentation fault (core dumped)
>   $
>
> Fix it by restoring the test for pos->free_str before freeing
> pos->val.str, but continue using zfree(&pos->val.str) to set that member
> to NULL after freeing it.
>
> Reported-by: Ian Rogers <irogers@google.com>
> Fixes: e8dfb81838b1 ("perf parse-events: Fix memory leaks found on parse_events")
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: clang-built-linux@googlegroups.com
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Leo Yan <leo.yan@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

stable rc 4.14 perf build broken.

> ---
>  tools/perf/util/parse-events.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 2733cdfdf04c6..ba973bdfaa657 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1258,7 +1258,8 @@ static int __parse_events_add_pmu(struct parse_events_state *parse_state,
>
>                 list_for_each_entry_safe(pos, tmp, &config_terms, list) {
>                         list_del_init(&pos->list);
> -                       zfree(&pos->val.str);
> +                       if (pos->free_str)
> +                               zfree(&pos->val.str);
>                         free(pos);
>                 }
>                 return -EINVAL;


util/parse-events.c: In function '__parse_events_add_pmu':
util/parse-events.c:1261:11: error: 'struct perf_evsel_config_term'
has no member named 'free_str'
    if (pos->free_str)
           ^~
In file included from util/evlist.h:14:0,
                 from util/parse-events.c:10:
util/parse-events.c:1262:20: error: 'union <anonymous>' has no member
named 'str'
     zfree(&pos->val.str);
                    ^
util/util.h:27:29: note: in definition of macro 'zfree'
 #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
                             ^~~
util/parse-events.c:1262:20: error: 'union <anonymous>' has no member
named 'str'
     zfree(&pos->val.str);
                    ^
util/util.h:27:36: note: in definition of macro 'zfree'
 #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
                                    ^~~

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

full build link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.14/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/938/consoleText


-- 
Linaro LKFT
https://lkft.linaro.org

> --
> 2.25.1
>
