Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3173A35483D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbhDEVmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhDEVmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:42:05 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8AAC061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:41:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x15so2870572wrq.3
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=c+yEZdHrja9WeXn55U++uoH9P/9JiC78Mtg9Xcteoxo=;
        b=YohkPe2gR6pgZrmMs50o8x98wQsi02fsZTTBLnpLZgnXHVSeXMKgZqbhFMKJincOdb
         30YkWaLE6u3EQprnSSfQF1OPPf2bB1Tpyri+mSlGLYUHFi2Ec/YKxACyrKDwwWcN2Mjx
         +iI1a+qAZHcoTTdwuY1tdIpuS0FBO/66jaSWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=c+yEZdHrja9WeXn55U++uoH9P/9JiC78Mtg9Xcteoxo=;
        b=awfG2GdoWPLvF25fbo4+b6P1YtiAr/7hJrX/dOY2UO3T5ZvlptVbiuNdjk+AHCev1m
         JgSBVXW8iku+6Pj1MrDj3t14ACx7gQGW+Fp7cfOpm9ZNYgfGAsQfdYdAB1Rked77Re4d
         U+QnFdthAFIYBvEApGBwOQxoJYHwVOSrPIuhe+lHTLqZ5DINFakOa4CTLqEtx4N/9Iyq
         Whk9EpwIPWhQ4UAGbUrhwQERvDAZLU8KcTZ2V4wigBRNBxEG/iKwZpJfW2jNM72f2oGF
         7tnYyz4M3zpmG50jKf997G1IVMGvojKcjP3pkVXNKRH9CFexgqLpp5l5HYNBz//9uHW7
         UFkA==
X-Gm-Message-State: AOAM530B/NQEvuwiSozeMIlzrmKtMNVqCw6Z86CeX9x+Y5U4Re6O78F9
        bQ8sa5JdfHAKejXCUayjDzilE1eYMa8+GB6+4eWOOjW50wOQAA==
X-Google-Smtp-Source: ABdhPJxORhp764ELNl+DklitQoRpF3SoHyrr5ZLz1qmxC0mjSH92hDZr2hJnIslraKNK8bZ5K/WRLpLhHf8pupRWVDQ=
X-Received: by 2002:adf:d20b:: with SMTP id j11mr30834239wrh.397.1617658915515;
 Mon, 05 Apr 2021 14:41:55 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Mon, 5 Apr 2021 14:41:43 -0700
Message-ID: <CAAjnzA=HhDQj_jLCcMGggZoAtP397vgbiMV_7POG20uVPYqpNw@mail.gmail.com>
Subject: DO automated testing - Linux 5.10.28-rc1 - 28 pass, 0 errors
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 948d7f2d279feceb51bcdedb5eb8ce0af60045ce (stable_rc/linux-5.10.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Sat Apr 3 13:52:16 2021 +0200

    Linux 5.10.28-rc1

---
 (01/28) ltp.py:LTP.test_nptl:  PASS (6.72 s)
 (02/28) ltp.py:LTP.test_math:  PASS (1.90 s)
 (03/28) ltp.py:LTP.test_hugetlb:  PASS (0.07 s)
 (04/28) ltp.py:LTP.test_ipc:  PASS (20.08 s)
 (05/28) ltp.py:LTP.test_uevent:  PASS (0.05 s)
 (06/28) ltp.py:LTP.test_containers:  PASS (36.90 s)
 (07/28) ltp.py:LTP.test_filecaps:  PASS (0.11 s)
 (08/28) ltp.py:LTP.test_hyperthreading:  PASS (71.17 s)
 (09/28) kpatch.sh:  PASS (12.62 s)
 (10/28) perf.py:PerfNonPriv.test_perf_help:  PASS (0.08 s)
 (11/28) perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
 (12/28) perf.py:PerfNonPriv.test_perf_list:  PASS (0.40 s)
 (13/28) perf.py:PerfPriv.test_perf_record:  PASS (4.78 s)
 (14/28) perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.26 s)
 (15/28) perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (8.75 s)
 (16/28) perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
 (17/28) perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.57 s)
 (18/28) perf.py:PerfPriv.test_perf_stat:  PASS (3.23 s)
 (19/28) perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
 (20/28) kselftest.py:kselftest.test_sysctl:  PASS (0.03 s)
 (21/28) kselftest.py:kselftest.test_size:  PASS (0.02 s)
 (22/28) kselftest.py:kselftest.test_x86:  PASS (0.26 s)
 (23/28) kselftest.py:kselftest.test_sigaltstack:  PASS (0.02 s)
 (24/28) kselftest.py:kselftest.test_tmpfs:  PASS (0.02 s)
 (25/28) kselftest.py:kselftest.test_user:  PASS (0.03 s)
 (26/28) kselftest.py:kselftest.test_timens:  PASS (0.09 s)
 (27/28) kselftest.py:kselftest.test_kvm:  PASS (13.57 s)
 (28/28) kselftest.py:kselftest.test_timers:  PASS (554.55 s)
RESULTS    : PASS 28 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
0 | CANCEL 0
JOB TIME   : 737.14 s
