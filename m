Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC65144EF8
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgAVJdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbgAVJdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:33:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A47AE2071E;
        Wed, 22 Jan 2020 09:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685587;
        bh=p9B0uT2oHpZTVWWgC2Fc08MdyScnRBmnaT96Qf13I7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNYyWsPB8qzVkG+RLGcp1I1TDU6DIl09q8pUePeim2s513xK1cWijTRQ8L/zsY+oG
         P3696jen4Arcy15WkXmm04LeVvnPxkiRNFZ4UTEyTTe6tu3bKNpVJpebIGQwS6FlxD
         /eHTYNZC1MUvj3exMaGZMFWXjZwKbiBNrK2z5RqY=
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
Subject: [PATCH 4.4 37/76] rseq/selftests: Turn off timeout setting
Date:   Wed, 22 Jan 2020 10:28:53 +0100
Message-Id: <20200122092755.961150674@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
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



