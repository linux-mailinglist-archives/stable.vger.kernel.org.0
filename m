Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1EE491A18
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345167AbiARC6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51424 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245641AbiARCmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:42:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4064B81136;
        Tue, 18 Jan 2022 02:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3E6C36AEB;
        Tue, 18 Jan 2022 02:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473762;
        bh=NsNmxlzJcp4bHdt1JVI79chzoIVKauwC5RQte6uzHu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7e7dOclAEb5V2RCMsebhnC4GdRINgiPTE/dDAvwVmecQn+nMR2APAdfAtEFXtxyq
         wJ0HxS5zVqWHlXJT7zE/If8UQ0qwl4SukUyap4HTMES27w6Q0HZmBFPWkAN3mOkvKq
         y5+aokr3691bByU5Ff5wLHjFaDx/S+PRu3X5jZNxT+jVInhyKh8cC33e3zccLb2TIr
         im3TcRuovcvuYHlOjGQKSiWh2Be0wAfjODmGnWkaa0l8D/MNUl6hgp8CgndxMm8j7Z
         Hhz9UKy7HvvjJdhf4r6id5mSUpuqZcPpFo4KltZdH1rH+ntHtliG+QSrteMlcMQgSC
         LMY1ePMx/w0AA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mingo@redhat.com, shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 058/116] selftests/ftrace: make kprobe profile testcase description unique
Date:   Mon, 17 Jan 2022 21:39:09 -0500
Message-Id: <20220118024007.1950576-58-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit e5992f373c6eed6d09e5858e9623df1259b3ce30 ]

Commit 32f6e5da83c7 ("selftests/ftrace: Add kprobe profile testcase")
added a new kprobes testcase, but has a description which does not
describe what the test case is doing and is duplicating the description
of another test case.

Therefore change the test case description, so it is unique and then
allows easily to tell which test case actually passed or failed.

Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/profile.tc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/profile.tc b/tools/testing/selftests/ftrace/test.d/kprobe/profile.tc
index 98166fa3eb91c..34fb89b0c61fa 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/profile.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/profile.tc
@@ -1,6 +1,6 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
-# description: Kprobe dynamic event - adding and removing
+# description: Kprobe profile
 # requires: kprobe_events
 
 ! grep -q 'myevent' kprobe_profile
-- 
2.34.1

