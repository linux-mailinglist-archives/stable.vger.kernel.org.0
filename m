Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2975311B857
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbfLKQRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:17:24 -0500
Received: from mail.efficios.com ([167.114.142.138]:43968 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729676AbfLKQRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:17:24 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id B9AFF686C0C;
        Wed, 11 Dec 2019 11:17:22 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id Gh4eo9wCSM6n; Wed, 11 Dec 2019 11:17:22 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 790E6686C00;
        Wed, 11 Dec 2019 11:17:22 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 790E6686C00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576081042;
        bh=sOPHKeVSlUx9J9iaH4EIDuqA+fQ4vt6RiiMi39IkxCc=;
        h=From:To:Date:Message-Id;
        b=t9OteOs+5s4QQ0nVZoQazft1wyou6HNl9vnu5zMSCgeeJFM4l3j8OrTHb13jQ8eD6
         aE1DamoNQG49Dkk4EzaF3ZHiewwXplJAObzh4Xkg1rxWymqSSV0kFZoquUOG6KvWGp
         tpJIpF5jRcaJ9kj7toas5vAVsFESgwASIsowcrHdVeIJgA8aHNuahVJXCTRvPPPMKQ
         EsIGTtq0XB2FTygxDANx4YbZpmMMV8szxnu+vfVJEVZYAje0gMejNCn7FHuzIkuw13
         1Dy2B4bkuJZZsJxj8tIlfkkz01xTcdW8n6jxdeoES8IybJdXUzp/ObYP/dweTGhvlK
         ggr63iWCEm+nA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id UzqRjtd3-YfZ; Wed, 11 Dec 2019 11:17:22 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 2F796686BF2;
        Wed, 11 Dec 2019 11:17:22 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.5 0/3] Restartable Sequences Fixes
Date:   Wed, 11 Dec 2019 11:17:10 -0500
Message-Id: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Here is a repost of a small set of rseq fixes which was initially posted
in September 2019. It now targets kernel 5.5. Those should be backported
to stable kernels >= 4.18.

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

