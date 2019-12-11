Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E7311B8C1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbfLKQ3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:29:17 -0500
Received: from mail.efficios.com ([167.114.142.138]:44278 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbfLKQ3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:29:17 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 7D1126870C0;
        Wed, 11 Dec 2019 11:29:15 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id rlsQb9jQZnGm; Wed, 11 Dec 2019 11:29:15 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 10CBA6870BC;
        Wed, 11 Dec 2019 11:29:15 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 10CBA6870BC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576081755;
        bh=lBvIWIPHZ3YYrU1rCMc/kDLcFqhy36D/EpjRZfMbX8Y=;
        h=From:To:Date:Message-Id;
        b=IoAWPC1NqxrbaZgMiI8+KTp5tL/43ni5An7sh4CqxOYbH6IqgrJ2JRq7g/vZhU8l+
         Rs60fQBUERzgI5in+bebqxq6Ka3bcrQ/qpSBHB9suyT7BI14RSdz884txh0XT5E9Kx
         zzrXVTKroJs3ddaqxlLyAzq+2dIwAnPcXzZKoqqKBndMg2S61u0/jypTP656twhkGA
         EEoCaR+/9m/WaAUg49/7xwmegjoHHYxH6DdE50yE1S4XaekRR8zOVqmeOa0sKPUWIj
         mT9Y6CgU0RYejNf8DV+utFd1RrWe+Bs9hARMCvVTvEN57RJr3FjT4OMGcp25cbP6d9
         82EWMjTXrmwUA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 3Iw4GOMzpDrp; Wed, 11 Dec 2019 11:29:14 -0500 (EST)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id C07F86870B6;
        Wed, 11 Dec 2019 11:29:14 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH for 5.5 1/1] rseq/selftests: Turn off timeout setting
Date:   Wed, 11 Dec 2019 11:28:57 -0500
Message-Id: <20191211162857.11354-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As the rseq selftests can run for a long period of time, disable the
timeout that the general selftests have.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
---
 tools/testing/selftests/rseq/settings | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/rseq/settings

diff --git a/tools/testing/selftests/rseq/settings b/tools/testing/selftests/rseq/settings
new file mode 100644
index 000000000000..e7b9417537fb
--- /dev/null
+++ b/tools/testing/selftests/rseq/settings
@@ -0,0 +1 @@
+timeout=0
-- 
2.17.1

