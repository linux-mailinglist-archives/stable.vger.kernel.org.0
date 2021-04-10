Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F7735AB13
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 07:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhDJFSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 01:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhDJFSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 01:18:49 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA4FC061762
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 22:18:35 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b9so7533516wrs.1
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 22:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=dN+Fv6zz0evMpfYsldVYwMf5bL2ZNdDL1qFGjogUZeo=;
        b=PK6yJJAnifN4eAW4sYMiBmsFXDW8o9UsAIPFQXbB14Uk8SVUl4FbCAvSgslI57Wk1q
         01yCxW2EjllLxaeV+ZUyxiM4he0bPozQdGLeyIuG3rYBtZBLkOXQnWx7DZUp80auzr9w
         bVk2hFwjvIg2PvQsFgOucwpuclcXjZv+SrH9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dN+Fv6zz0evMpfYsldVYwMf5bL2ZNdDL1qFGjogUZeo=;
        b=pCnlDrH1Xe1qubKCq0bvXb9mz+idqDiVwL7U+YOEGn6kdiiAs0l8MmMej2YVLSmRf+
         gupz9KexSWpf9Q7f7UjmlOlERmcCiJ/GKNVohkd48zaQ9+sFQnX4Y9twboKEHNavFljm
         MSbiMwepJ1aAEu9tryP/qPNxSCHPz6RclzH7IgcJIRHGio9FpKICqUxOnKYioS6tUwVQ
         V1aDJq9rA1nEhfqXLYgzQ918oMLV8gJ1Wjf/Sbhqc7kACZK4u45Q8wqhSzXn7S4X3Yrv
         9M/pR8noEM3U2IFGZZAwllUoEb3faoJMKUqje6D8ImCPquPM8+VoPdgOzkH/oMmbV07b
         RpLQ==
X-Gm-Message-State: AOAM533IFWK7kYGlyPkIKuNPrQQUtADSBT2N8VE/mJftXK3vFc4Ps1xR
        vzxT6CmKZMwLydHGNAaV96ivMagsbyAlGEGetZlC3faX6xX0kA==
X-Google-Smtp-Source: ABdhPJzTB+Nt3siqpX+KloYzFjMAes+sHd2qcf0Ze00rmO6cghGvQ5eiUcA1xnUbaGbu+n7Vi8OjtObXhMYNgxMcJuA=
X-Received: by 2002:adf:f705:: with SMTP id r5mr9704828wrp.327.1618031913922;
 Fri, 09 Apr 2021 22:18:33 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Fri, 9 Apr 2021 22:18:21 -0700
Message-ID: <CAAjnzAk3Ct=Sk06b6Zjf=s6-7xU_ThcH28pw4nhCKfjqPqn92w@mail.gmail.com>
Subject: PASS: stable-rc/linux-5.10.y (v5.10.29-rc1)
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We ran tests on this kernel:

commit 18f507c37f338c5d30f58839060d3af0d8504162 (HEAD ->
rc/linux-5.10.y, stable_rc/linux-5.10.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri Apr 9 11:53:03 2021 +0200

    Linux 5.10.29-rc1

32/32 test passed, 0 failed, 0 errors, 0 warnings.

Specific tests run:

(01/32) ltp.py:LTP.test_nptl:  PASS (6.52 s)
 (02/32) ltp.py:LTP.test_math:  PASS (2.13 s)
 (03/32) ltp.py:LTP.test_hugetlb:  PASS (0.08 s)
 (04/32) ltp.py:LTP.test_ipc:  PASS (20.09 s)
 (05/32) ltp.py:LTP.test_uevent:  PASS (0.05 s)
 (06/32) ltp.py:LTP.test_containers:  PASS (36.76 s)
 (07/32) ltp.py:LTP.test_filecaps:  PASS (0.11 s)
 (08/32) ltp.py:LTP.test_hyperthreading:  PASS (71.19 s)
 (09/32) kpatch.sh:  PASS (11.64 s)
 (10/32) perf.py:PerfNonPriv.test_perf_help:  PASS (0.08 s)
 (11/32) perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
 (12/32) perf.py:PerfNonPriv.test_perf_list:  PASS (0.40 s)
 (13/32) perf.py:PerfPriv.test_perf_record:  PASS (4.74 s)
 (14/32) perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.26 s)
 (15/32) perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (5.15 s)
 (16/32) perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
 (17/32) perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.50 s)
 (18/32) perf.py:PerfPriv.test_perf_stat:  PASS (3.22 s)
 (19/32) perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
 (20/32) kselftest.py:kselftest.test_sysctl:  PASS (0.03 s)
 (21/32) kselftest.py:kselftest.test_size:  PASS (0.02 s)
 (22/32) kselftest.py:kselftest.test_sync:  PASS (0.46 s)
 (23/32) kselftest.py:kselftest.test_capabilities:  PASS (0.03 s)
 (24/32) kselftest.py:kselftest.test_x86:  PASS (0.26 s)
 (25/32) kselftest.py:kselftest.test_pidfd:  PASS (13.06 s)
 (26/32) kselftest.py:kselftest.test_membarrier:  PASS (0.18 s)
 (27/32) kselftest.py:kselftest.test_sigaltstack:  PASS (0.03 s)
 (28/32) kselftest.py:kselftest.test_tmpfs:  PASS (0.02 s)
 (29/32) kselftest.py:kselftest.test_user:  PASS (0.02 s)
 (30/32) kselftest.py:kselftest.test_sched:  PASS (0.03 s)
 (31/32) kselftest.py:kselftest.test_timens:  PASS (0.09 s)
 (32/32) kselftest.py:kselftest.test_timers:  PASS (554.44 s)
RESULTS    : PASS 32 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
0 | CANCEL 0

Tested-by: pmccormick@digitalocean.com
