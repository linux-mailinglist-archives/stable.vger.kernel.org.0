Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDA94F3A1A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379126AbiDELkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354385AbiDEKOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:00 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265EE6F485
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 02:59:42 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2eb9412f11dso33748797b3.4
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 02:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=RxSuGdw3FYi7+rhYPwCpQEw4J55AyOaNaWMeU1UCr0Y=;
        b=dHJYJLiYWwTTi0bJ6X/vfukOhWbi3ARyy+2EGKSX9tajwNV+VA22A4JWE5HWS+CczI
         mIreLWPseWclpx1S9+i08zOqcj72fK3oDJjvYK7bo0i+YNxQk7QDCQl/SKWrUwUB4t1q
         /j7Q6dPwzbQwIdtV6EiAgiKILIUqye97hWoJgd2wLPMyMXiu4mT8osrJMD5whAyXMphs
         wZ05NNSX5Aj8Uj+XxX7vT7vMh+MlFShodE1Tr1icRo34b3EcChquSWreu79vjcfj/uTC
         8hVx+PiHieXeEmwOhEKGUg+7yu/ipQeqsh0E9h8Om5YAtrBtQHH0p5GDNQgDFWm+9po9
         GvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=RxSuGdw3FYi7+rhYPwCpQEw4J55AyOaNaWMeU1UCr0Y=;
        b=o7+9UuiNY9j6iLCcOFlbw/wKhn7xjuzNpur0s5W1RmmGFtYTG97WopqNnubn4kA8/8
         IpZYP7KXwtShXHqv1i8681tmnJ4kR1cY3ibspA/qfqSAK6bkN4F0CZE4jffNQFah05MD
         6xzoBoF/4fay2khFaKcUjmWwdJazh5i+xpcVwz/vPdQ9y8m7SrIF/MAG1PpDwtAtkw1w
         WRo8v8e0IVTk3h3KVq7VOvr+QJ6hqnEgFR4dYVu3n/pX3wfv9iXJ35RM/oem2ZTLkJ4Q
         DvmbsQb9RhYQ/mZHWdiqMC6/QMb51s43+j/u/Y9MTI8Q4BRTvtbCXGoQX+6BoVD9OLsB
         AZ4w==
X-Gm-Message-State: AOAM531VzqLGI+14s+y6LI1FiTA94Y0EP0NBKFadh4HtP19ktRbmVj6v
        Dwy2s3Diswb0Elo8qvATkCfE0Ai2xhxFJ6GPeMycBw==
X-Google-Smtp-Source: ABdhPJyA+AtPJJHMNITaqj58+wdGIBlGKxzURIftt04aU6YRG0hW1dVQagpAFWy7oeuXKGhddJ6iNHGhvBju8f/5dMI=
X-Received: by 2002:a0d:d6c8:0:b0:2eb:724f:22b9 with SMTP id
 y191-20020a0dd6c8000000b002eb724f22b9mr1827385ywd.120.1649152781212; Tue, 05
 Apr 2022 02:59:41 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Apr 2022 15:29:30 +0530
Message-ID: <CA+G9fYumiL8RtdJusNZtW2Ut7GJgjA7Q0n87PubBL6eMADRBog@mail.gmail.com>
Subject: stable-rc: 4.19: include/linux/blk-mq.h:309:27: error: invalid use of
 undefined type 'struct request'
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linux stable-rc 4.19 branch build breaks on all architecture for
allnoconfig and tinyconfig.

arch/x86/entry/entry_64.S: Assembler messages:
arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic
suffix given and no register operands; using default for `sysret'
In file included from include/linux/blk-cgroup.h:24,
                 from include/linux/backing-dev.h:18,
                 from include/linux/nfs_fs_sb.h:6,
                 from include/linux/nfs_fs.h:39,
                 from init/do_mounts.c:22:
include/linux/blk-mq.h:145:9: error: unknown type name 'softirq_done_fn'
  145 |         softirq_done_fn         *complete;
      |         ^~~~~~~~~~~~~~~
In file included from arch/x86/include/asm/atomic.h:265,
                 from include/linux/atomic.h:7,
                 from include/linux/jump_label.h:185,
                 from arch/x86/include/asm/string_64.h:6,
                 from arch/x86/include/asm/string.h:5,
                 from include/linux/string.h:20,
                 from include/linux/bitmap.h:9,
                 from include/linux/cpumask.h:12,
                 from arch/x86/include/asm/cpumask.h:5,
                 from arch/x86/include/asm/msr.h:11,
                 from arch/x86/include/asm/processor.h:21,
                 from arch/x86/include/asm/cpufeature.h:5,
                 from arch/x86/include/asm/thread_info.h:53,
                 from include/linux/thread_info.h:39,
                 from arch/x86/include/asm/preempt.h:7,
                 from include/linux/preempt.h:81,
                 from include/linux/spinlock.h:51,
                 from include/linux/seqlock.h:36,
                 from include/linux/time.h:6,
                 from include/linux/stat.h:19,
                 from include/linux/module.h:10,
                 from init/do_mounts.c:1:
include/linux/blk-mq.h: In function 'blk_mq_mark_complete':
include/linux/blk-mq.h:309:27: error: invalid use of undefined type
'struct request'
  309 |         return cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
      |                           ^~
include/asm-generic/atomic-instrumented.h:420:16: note: in definition
of macro 'cmpxchg'
  420 |         typeof(ptr) __ai_ptr = (ptr);
         \
      |                ^~~
include/linux/blk-mq.h:309:27: error: invalid use of undefined type
'struct request'
  309 |         return cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
      |                           ^~
include/asm-generic/atomic-instrumented.h:420:33: note: in definition
of macro 'cmpxchg'
  420 |         typeof(ptr) __ai_ptr = (ptr);
         \
      |                                 ^~~
include/asm-generic/atomic-instrumented.h:421:44: error: invalid type
argument of unary '*' (have 'int')
  421 |         kasan_check_write(__ai_ptr, sizeof(*__ai_ptr));
         \
      |                                            ^~~~~~~~~
include/linux/blk-mq.h:309:16: note: in expansion of macro 'cmpxchg'
  309 |         return cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
      |                ^~~~~~~
include/asm-generic/atomic-instrumented.h:421:27: warning: passing
argument 1 of 'kasan_check_write' makes pointer from integer without a
cast [-Wint-conversion]
  421 |         kasan_check_write(__ai_ptr, sizeof(*__ai_ptr));
         \
      |                           ^~~~~~~~
      |                           |
      |                           int
include/linux/blk-mq.h:309:16: note: in expansion of macro 'cmpxchg'
  309 |         return cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
      |                ^~~~~~~

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
