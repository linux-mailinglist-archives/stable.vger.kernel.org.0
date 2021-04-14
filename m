Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954B635FB13
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 20:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346972AbhDNSu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 14:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346882AbhDNSuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 14:50:23 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98137C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 11:50:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a4so20869886wrr.2
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 11:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=Vz17gHeZc0m8xWxzK5zb7IJsb5XaL5xb20Nc2aB6Klc=;
        b=AnujvG+Bpi61G9ZH20z9z9DlzRhu5zI+VVQOErNK/DuVzB5oUV4JOUjqI8ANIVzgGQ
         iOl8sN1W+nVICcXBNA0ckWYhRs8ZoleFbqBZ6bp4GYBTOhHZMkWQ819sLg5WVSqN5CQU
         lQ/lLJZaheDIuorVV5UNRxmTVmVJ6ChMP35eQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Vz17gHeZc0m8xWxzK5zb7IJsb5XaL5xb20Nc2aB6Klc=;
        b=Pse8mPnw4pLiM+f609c3kSuWgifEi77YXbl+vGUWo4DwakL+diCwOCXRgtAbtGE0dT
         dKn19rSGtZ0UM123PYZ5oBvygYHw0+c4IOUT1NxWim5/j9/mq97ox/lOYL0ADDB5T3T+
         C+SnEwTb9pnEpsLFuJJOJ7Jiq/9ufEEfmWceMycF7JxEFyOQb0jUFPR45wNa0K9dfiD3
         HtJGrWFpMoFpyspyQjXZa1mzxVnVkZ1Kbg4KezPQAh+TtHMvJL+eKuFBO3g7IktY/fI0
         1hTRp7aaNUNQD4yU6qNN8kfBUUUTskqc0pNYj3e07fE4Nom0PCXKezxs9d84ozqi3my3
         9seQ==
X-Gm-Message-State: AOAM531+xJ/NxsbTteZQp1L1MMags4T3bssASxeeFtWk2KYKwldHiC+A
        3vM+ksAU4FlcA8j6N2RaIXVAF4iyybV2F3ZqereisTN5dij5Sg==
X-Google-Smtp-Source: ABdhPJzorTsq4/2+W7ZeAbGA/S0LmeFGJwS6pU7mPrKCvLXyTRnoYkqtCMLcsgv0RLz/gi54Vhz7idyPA7lgsbHjqlQ=
X-Received: by 2002:adf:e3cf:: with SMTP id k15mr13500949wrm.327.1618426199141;
 Wed, 14 Apr 2021 11:49:59 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Wed, 14 Apr 2021 11:49:48 -0700
Message-ID: <CAAjnzAmF4knjJNWxEAT2oR7WbWjj=9qCvq4XpTHuXzwOjif+qQ@mail.gmail.com>
Subject: 5.10.30: 32 tests pass, 0 failures
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We ran tests on this kernel:

commit 1e798745fa8ef91ffe4fd38d443f9d44b59e3cb3 (HEAD ->
rc/linux-5.10.y, stable_rc/linux-5.10.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed Apr 14 08:42:14 2021 +0200

    Linux 5.10.30

32/32 test passed, 0 failed, 0 errors, 0 warnings.

Specific tests run:
 (01/32) ltp.py:LTP.test_nptl:  PASS (6.61 s)
 (02/32) ltp.py:LTP.test_math:  PASS (1.75 s)
 (03/32) ltp.py:LTP.test_hugetlb:  PASS (0.08 s)
 (04/32) ltp.py:LTP.test_ipc:  PASS (20.08 s)
 (05/32) ltp.py:LTP.test_uevent:  PASS (0.05 s)
 (06/32) ltp.py:LTP.test_containers:  PASS (39.75 s)
 (07/32) ltp.py:LTP.test_filecaps:  PASS (0.11 s)
 (08/32) ltp.py:LTP.test_hyperthreading:  PASS (71.19 s)
 (09/32) kpatch.sh:  PASS (8.59 s)
 (10/32) perf.py:PerfNonPriv.test_perf_help:  PASS (0.08 s)
 (11/32) perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
 (12/32) perf.py:PerfNonPriv.test_perf_list:  PASS (0.39 s)
 (13/32) perf.py:PerfPriv.test_perf_record:  PASS (4.76 s)
 (14/32) perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.32 s)
 (15/32) perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (5.63 s)
 (16/32) perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
 (17/32) perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.53 s)
 (18/32) perf.py:PerfPriv.test_perf_stat:  PASS (3.22 s)
 (19/32) perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
 (20/32) kselftest.py:kselftest.test_sysctl:  PASS (0.22 s)
 (21/32) kselftest.py:kselftest.test_size:  PASS (0.02 s)
 (22/32) kselftest.py:kselftest.test_sync:  PASS (0.46 s)
 (23/32) kselftest.py:kselftest.test_capabilities:  PASS (0.03 s)
 (24/32) kselftest.py:kselftest.test_x86:  PASS (0.25 s)
 (25/32) kselftest.py:kselftest.test_pidfd:  PASS (13.03 s)
 (26/32) kselftest.py:kselftest.test_membarrier:  PASS (0.21 s)
 (27/32) kselftest.py:kselftest.test_sigaltstack:  PASS (0.02 s)
 (28/32) kselftest.py:kselftest.test_tmpfs:  PASS (0.02 s)
 (29/32) kselftest.py:kselftest.test_user:  PASS (0.02 s)
 (30/32) kselftest.py:kselftest.test_sched:  PASS (0.04 s)
 (31/32) kselftest.py:kselftest.test_timens:  PASS (0.09 s)
 (32/32) kselftest.py:kselftest.test_timers:  PASS (554.49 s)
RESULTS    : PASS 32 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
0 | CANCEL 0

Tested-by: Patrick McCormick <pmccormick@digitalocean.com>
