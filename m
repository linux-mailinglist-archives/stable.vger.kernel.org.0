Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95C7357B65
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 06:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhDHEck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 00:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhDHEck (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 00:32:40 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CEBC061760
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 21:32:29 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a6so568432wrw.8
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 21:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=dw4i+61NZcuNcUhPgHt6UqSYxkc7dV51hhmNID/NlXE=;
        b=DQqhQk5HCaFv0et3xLhBbufdgvnIOEcaWlKs0w7urEW7bf4VUynNeRc8sL6tAvM0x0
         1bRPtrVBy8zX6wcIeMc1KWcDupuvj7qIwkaia/s1sXptu47dXfejFGXb8CAuzDvWb3/F
         I5OQrwkkIR1/dVDmq9JuY6LtkELBQXLeoiG2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dw4i+61NZcuNcUhPgHt6UqSYxkc7dV51hhmNID/NlXE=;
        b=qvTFNxuaKpal07tVlOy98ftOyrQ7nqJFa+2jJpLIZABcDJoVNaROq+knUBn7DVk4sX
         7Fw0OQsmbT1r2az+i5ODudSk/RZuOdls7iM8B+RsA/lrzjhYk0lZGAA0ImQ+LX1QMnf7
         2WKQv3fsQC00+jFknF5tbdTfGYCjfehicIgvpBDz6r/4V1/WhebnPIk+WBu85sgB3eFi
         WMDXMcOEArr+Szmd88myqk+lWox0H4KPE5wHVWkLQ2RkaHzNGbuTt589vWdbqUZVsHj8
         +YgbrCAE5gTdxGXSMeWMPhjCLqPyhE79AMPhvwLL/ce5winINQAoSyudSxTN5x95R8hY
         vtWg==
X-Gm-Message-State: AOAM533eXCujfBrJC5R8YhCDpPJ3zoQ7pE4tMDxrjnfQERPeUjIVJQ6F
        D9psv6N8LdMdLCNu48n+U3/6DdPK3KS7QQJ6vApEcxWRLo1rbQ==
X-Google-Smtp-Source: ABdhPJwjQhGBkTzGd7pjhVwI0ZgzjSCUYV2HQhOD6xXWuwISYwLYzxNX+a7PYWGXBQes9oDSCkG+tSGB0hClvX7W6rU=
X-Received: by 2002:a5d:420f:: with SMTP id n15mr8374987wrq.186.1617856348288;
 Wed, 07 Apr 2021 21:32:28 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Wed, 7 Apr 2021 21:32:16 -0700
Message-ID: <CAAjnzAm-vUPWRVPx01=JNwVit+7Jq3M8kr+m2PZvGBbjTcoBsg@mail.gmail.com>
Subject: PASS: stable-rc/linux-5.10.y (v5.10.28)
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We ran tests on this kernel:

commit ecdfb9d70fb8c4d7dd9a5fa28c675b4ebe705f85 (HEAD ->
rc/linux-5.10.y, stable_rc/linux-5.10.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed Apr 7 15:00:14 2021 +0200

    Linux 5.10.28
...

28/28 tests passed, 0 failed, 0 errors, 0 warnings.

Specific tests run:

 (01/28) ltp.py:LTP.test_nptl:  PASS (6.03 s)
 (02/28) ltp.py:LTP.test_math:  PASS (1.90 s)
 (03/28) ltp.py:LTP.test_hugetlb:  PASS (0.08 s)
 (04/28) ltp.py:LTP.test_ipc:  PASS (20.09 s)
 (05/28) ltp.py:LTP.test_uevent:  PASS (0.06 s)
 (06/28) ltp.py:LTP.test_containers:  PASS (36.71 s)
 (07/28) ltp.py:LTP.test_filecaps:  PASS (0.10 s)
 (08/28) ltp.py:LTP.test_hyperthreading:  PASS (71.20 s)
 (09/28) kpatch.sh:  PASS (10.59 s)
 (10/28) perf.py:PerfNonPriv.test_perf_help:  PASS (0.08 s)
 (11/28) perf.py:PerfNonPriv.test_perf_version:  PASS (0.06 s)
 (12/28) perf.py:PerfNonPriv.test_perf_list:  PASS (0.41 s)
 (13/28) perf.py:PerfPriv.test_perf_record:  PASS (4.75 s)
 (14/28) perf.py:PerfPriv.test_perf_cmd_kallsyms:  PASS (0.26 s)
 (15/28) perf.py:PerfPriv.test_perf_cmd_annotate:  PASS (5.48 s)
 (16/28) perf.py:PerfPriv.test_perf_cmd_evlist:  PASS (0.07 s)
 (17/28) perf.py:PerfPriv.test_perf_cmd_script:  PASS (0.52 s)
 (18/28) perf.py:PerfPriv.test_perf_stat:  PASS (3.22 s)
 (19/28) perf.py:PerfPriv.test_perf_bench:  PASS (0.07 s)
 (20/28) kselftest.py:kselftest.test_sysctl:  PASS (0.19 s)
 (21/28) kselftest.py:kselftest.test_size:  PASS (0.02 s)
 (22/28) kselftest.py:kselftest.test_x86:  PASS (0.25 s)
 (23/28) kselftest.py:kselftest.test_sigaltstack:  PASS (0.02 s)
 (24/28) kselftest.py:kselftest.test_tmpfs:  PASS (0.02 s)
 (25/28) kselftest.py:kselftest.test_user:  PASS (0.02 s)
 (26/28) kselftest.py:kselftest.test_timens:  PASS (0.08 s)
 (27/28) kselftest.py:kselftest.test_kvm:  PASS (13.64 s)
 (28/28) kselftest.py:kselftest.test_timers:  PASS (555.18 s)
RESULTS    : PASS 28 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT
0 | CANCEL 0
