Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19044428CE5
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 14:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhJKMUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbhJKMUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 08:20:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907F1C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 05:18:02 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y12so54044032eda.4
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 05:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4tj0z+56I6ion30VuIQlSY/oL2Un/fHR0/HAnxo//bA=;
        b=S9fUkwP1qlRUuGp5fiuMnhx3slenrSwfu8RKIR/orUMwArkd+cVdjVwiUkN3+WVdCe
         MUb/dnGQcOCq6Kme5m6yPS60EpUu70ARc8so4zKKGYw3LrbZi5b2WOpZDatA2PtK+3gY
         SWeBdhtAxIAr7kzoj61/4W4vuUwsoIEDxdndFeccMzXjc3Iy3Am+Ha4Eb8pNie8YM1gJ
         +O6cCWHy1N3ol4PyLyEhcdMP7pvR+VQumuCPqZbc7i4d3TBVKOEKNMAyYOxkSFE5BBwo
         y8JFk9nMewIIBvXZKpqg0orvaJ6QFPBUT/HFCWK9mHLC3mPxMkMV2+IlcmkB+aYbnQsg
         MDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4tj0z+56I6ion30VuIQlSY/oL2Un/fHR0/HAnxo//bA=;
        b=R72qoFOnkk0XCfWyaz/mWrArp6EDzTV0NGGWe/KxDjGvGg7sDb3vfQRmOfoICx9k7J
         u2rr+cMaQEla7J5IXy26xqr4fo/DouR58IswhMajuFu1cz1F8p0XzyofNLkLtigK5Efp
         ksZOoV+3Pu8ES7Ppum3OHNXAKATyuUFoh0dkIS21COOtAQg2qlF3RZfF0wrVrwys9/Oc
         5k7GBhzJpml6snGiNbNIxJEMMQmW0gsGD7Ly2X2Jkp4T9YlpxMFhp8n5ZvRGfh49prEw
         XYJFltAPysV1Yv8Ps1vYld3eTvy3LHrYnAfc1glDHwvdGMafN410DgXK2pIfZG7A3P8g
         le8A==
X-Gm-Message-State: AOAM533qP/u/E2YIvkx0Itj6wZzcXIbcMX/dAjREuUkBOaudZGM5j9o9
        P3FddeqbelJxv71QWeJOSW9S71u7vBakF5eD9nsmKbioSVzyiA==
X-Google-Smtp-Source: ABdhPJxz54+iiVKtwiafoJ9w5NxUv3tc8nsseeiFXExU3VedPmR+TWvnGpO99hh1MxRkUufKKEHLVXJKMtUS0xfxvco=
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr25423310ejy.493.1633954680220;
 Mon, 11 Oct 2021 05:18:00 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 11 Oct 2021 17:47:49 +0530
Message-ID: <CA+G9fYvfWNnBEpgzSQrh8AocmJVcTRtRT3uhJCG__js7aEWwjg@mail.gmail.com>
Subject: pmu-events/jevents.c:1188:9: warning: implicit declaration of
 function 'free_sys_event_tables' [-Wimplicit-function-declaration]
To:     linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Garry <john.garry@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc 5.10 perf build failed due to these warnings  / errors.

metadata:
    git_describe: v5.10.72-85-g431c7c55f183
    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
    git_short_log: 431c7c55f183 (\"Linux 5.10.73-rc1\")
    target_arch: x86_64
    toolchain: gcc-11

pmu-events/jevents.c: In function 'main':
pmu-events/jevents.c:1188:9: warning: implicit declaration of function
'free_sys_event_tables' [-Wimplicit-function-declaration]
 1188 |         free_sys_event_tables();
      |         ^~~~~~~~~~~~~~~~~~~~~
/usr/bin/ld: /home/tuxbuild/.cache/tuxmake/builds/current/pmu-events/jevents-in.o:
in function `main':
(.text+0x469e): undefined reference to `free_sys_event_tables'
/usr/bin/ld: (.text+0x475e): undefined reference to `free_sys_event_tables'
collect2: error: ld returned 1 exit status
make[2]: *** [Makefile.perf:649:
/home/tuxbuild/.cache/tuxmake/builds/current/pmu-events/jevents] Error
1
make[2]: *** Waiting for unfinished jobs....
  LINK     /home/tuxbuild/.cache/tuxmake/builds/current/plugin_cfg80211.so
  GEN      /home/tuxbuild/.cache/tuxmake/builds/current/libtraceevent-dynamic-list
make[1]: *** [Makefile.perf:229: sub-make] Error 2
make: *** [Makefile:70: all] Error 2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link:
-----------
https://builds.tuxbuild.com/1zLv2snHfZN8QV01yA9MB8NhUZt/build.log

build config:
-------------
https://builds.tuxbuild.com/1zLv2snHfZN8QV01yA9MB8NhUZt/config

-- 
Linaro LKFT
https://lkft.linaro.org
