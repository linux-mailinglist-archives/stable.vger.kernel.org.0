Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DC214515C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgAVJfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729906AbgAVJfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:35:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA0D2467B;
        Wed, 22 Jan 2020 09:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685707;
        bh=p9B0uT2oHpZTVWWgC2Fc08MdyScnRBmnaT96Qf13I7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhLMz8yp4OV5FT+abX1H2Qj9obe0rL8lAhwVNMMzy0AN4ykLEaq6sZmdf+LoWnydQ
         D0H5qOaER753prH64P++6E+tnHrFJ2MhfXIw7UwoyLTdZLMCC7IjWdj5tDpzRTraxS
         DikKiGJ+PwWCf+mOePu2Z2DeOndZG/DsCIl5zh9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 45/97] rseq/selftests: Turn off timeout setting
Date:   Wed, 22 Jan 2020 10:28:49 +0100
Message-Id: <20200122092803.764193669@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit af9cb29c5488381083b0b5ccdfb3cd931063384a ]

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
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.20.1



