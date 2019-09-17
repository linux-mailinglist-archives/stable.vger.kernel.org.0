Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A8DB5554
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 20:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbfIQSaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 14:30:11 -0400
Received: from mail.efficios.com ([167.114.142.138]:37422 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbfIQSaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 14:30:11 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 03E2D1D4DD6;
        Tue, 17 Sep 2019 14:30:10 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id gEQfOulKEOTt; Tue, 17 Sep 2019 14:30:09 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id B240F1D4DCA;
        Tue, 17 Sep 2019 14:30:09 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com B240F1D4DCA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568745009;
        bh=Ebem6mYheuShEfrBBKlZ/Oh2E7NeDB5wZOPBU2goDVU=;
        h=From:To:Date:Message-Id;
        b=s7JYZdokFIHnk4c1dc+/Ud/ANaZ0/3HZh7/L0Sat54Vjc3l3TR0RpRkXwi88QiBC8
         7/tWO8EWQXu7130e33FpfbLy7VCDRFsMqEfVur5CU+YLBzN6Uz0Mh7tJ6zue4V9Ygq
         gJITHkXjrvdtFIAo/Sp5uOb5SWmzXXT6SYkHOk02GF79bOeybVbnZZmIgl6s3ht6+d
         /9VBE0BYNe3gUOwcNk4no/Lcue//Zk2Jy7bKC/H9biJMjiMFRcr0G3mlhI94x5GhuS
         zZR/Jq1J7rjODmFrbRLrESdL5g4fmAgrDYFBATsGk76mSODh4Jq+t++2XmPOlhbiif
         koq8j/bKJ+63w==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id YXYReruiuvkK; Tue, 17 Sep 2019 14:30:09 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 4A1B71D4DBE;
        Tue, 17 Sep 2019 14:30:09 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.4 0/3] Restartable Sequences Fixes
Date:   Tue, 17 Sep 2019 14:29:56 -0400
Message-Id: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Here is a small set of rseq fixes aiming Linux 5.4. Those should be
backported to stable kernels >= 4.18.

Thanks,

Mathieu

Mathieu Desnoyers (3):
  rseq: Fix: Reject unknown flags on rseq unregister
  rseq: Fix: Unregister rseq for clone CLONE_VM
  rseq/selftests: Fix: Namespace gettid() for compatibility with glibc
    2.30

 include/linux/sched.h                     |  4 ++--
 kernel/rseq.c                             |  2 ++
 tools/testing/selftests/rseq/param_test.c | 18 ++++++++++--------
 3 files changed, 14 insertions(+), 10 deletions(-)

-- 
2.17.1

