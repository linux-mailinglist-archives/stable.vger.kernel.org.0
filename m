Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8086BFBF1
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCRRkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCRRkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:33 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B5A222E5
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:29 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g6-20020a05600c4ec600b003ed8826253aso1621109wmq.0
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wZ/Puoclnevh/x9T2MYrlO/lJcAkMpBbXHKu8D3KWZc=;
        b=eS88+pAh5R2aZqNSRC2Rb0oNBnhBco1tOqya9V68NBbDzr/cSC6PZLIrG7vMxo6Anb
         /lPIm5uemItwciVnRlFAEFHE8V9B0ZfrQJXoIHHo92gGPta/Md05VDYTzq5ZfeR0Cgjx
         omvfv17pA+Uzy4lx4mVylT7VR8pVfm6myr0gOgdsIUAib8sm38xYkVtvpoylHCxVFLDB
         A00JlGSzijqoC8gt0nKv9hD3ezsT+hAO8bMz6mtv+YvW62itjb1jPjMM16MmDxDzZEOc
         fRZz/x5VFt4pAVS7IelD0mwMHIptkjOekRQm/Er98KHzdFbmxFtJP7Jie1fJsvDJ5cSY
         xZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wZ/Puoclnevh/x9T2MYrlO/lJcAkMpBbXHKu8D3KWZc=;
        b=21ztlJr67WeIkpycyVdBbiBU1OSXiFBDXRiWks59u+RxsBtYg8GAVROOrGqgpIT8pJ
         kVsigOVGC8bq550UW5rxWJhVtXEyogTsq/Jh5CU+2QGR6k9K6kFX/Duvx7Y8RsMY7WU8
         BRR1C/HM/L5glLLlnr5rnl9ngEiFwbf/QceF1YgmO/ZozV0YKuQB+qMCFzIcX0oZs5yO
         4vOFV42yAGmo/ue+akswzmUuVM1eXW6fFvF4U6AtCeabaxMKvngxDluFvuQ4mocCJySk
         n25F1322eYh/51p8NN5k97Driqvyx4gD0AgBrfll4mHKAmqVUgtVR1P9MxwdT7B6/+3i
         dAdA==
X-Gm-Message-State: AO0yUKXdgZwGIpi26ZeaN8ngYfD8eCgZ3V16bSqzhgQJflXWt3BKfK1E
        s3UKCAWj9h4eTSPiKX+DicZvmQ7en4gMaCQ/5X0=
X-Google-Smtp-Source: AK7set/mCl4MNjuc6rgWloyzoa3Ki5E1JfiUks3gQRMiXZuHECVKC4x1pHsRn2OAja60ORuwLamDdw==
X-Received: by 2002:a7b:cb98:0:b0:3ed:8360:e54 with SMTP id m24-20020a7bcb98000000b003ed83600e54mr5584106wmi.8.1679161228006;
        Sat, 18 Mar 2023 10:40:28 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:27 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH v2 00/10] Backport uclamp vs margin fixes into 5.10.y
Date:   Sat, 18 Mar 2023 17:39:33 +0000
Message-Id: <20230318173943.3188213-1-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changes in v2:
	* Fix compilation error against patch 7 due to misiplace #endif to
	  protect against CONFIG_SMP which doesn't contain the newly added
	  field to struct rq.

Commit 2ff401441711 ("sched/uclamp: Fix relationship between uclamp and
migration margin") was cherry-picked into 5.10 kernels but missed the rest of
the series.

This ports the remainder of the fixes.

Based on 5.10.172.

NOTE:

a2e90611b9f4 ("sched/fair: Remove capacity inversion detection") is not
necessary to backport because it has a dependency on e5ed0550c04c ("sched/fair:
unlink misfit task from cpu overutilized") which is nice to have but not
strictly required. It improves the search for best CPU under adverse thermal
pressure to try harder. And the new search effectively replaces the capacity
inversion detection, so it is removed afterwards.

Build tested on (cross compile when necessary; x86_64 otherwise):

	1. default ubuntu config which has uclamp + smp
	2. default ubuntu config without uclamp + smp
	3. default ubunto config without smp (which automatically disables
	   uclamp)
	4. reported riscv-allnoconfig, mips-randconfig, x86_64-randocnfigs

Tested on 5.10 Android GKI kernel and android device (with slight modifications
due to other conflicts on there).

Qais Yousef (10):
  sched/uclamp: Make task_fits_capacity() use util_fits_cpu()
  sched/uclamp: Fix fits_capacity() check in feec()
  sched/uclamp: Make select_idle_capacity() use util_fits_cpu()
  sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()
  sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
  sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early
    exit condition
  sched/fair: Detect capacity inversion
  sched/fair: Consider capacity inversion in util_fits_cpu()
  sched/uclamp: Fix a uninitialized variable warnings
  sched/fair: Fixes for capacity inversion detection

 kernel/sched/core.c  |  10 +--
 kernel/sched/fair.c  | 183 ++++++++++++++++++++++++++++++++++---------
 kernel/sched/sched.h |  70 ++++++++++++++++-
 3 files changed, 217 insertions(+), 46 deletions(-)

-- 
2.25.1

