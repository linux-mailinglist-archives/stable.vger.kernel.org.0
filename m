Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5468491E1B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353428AbiARDq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347209AbiARCk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:40:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBADC08C5C5;
        Mon, 17 Jan 2022 18:36:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C480D61251;
        Tue, 18 Jan 2022 02:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F9BC36AE3;
        Tue, 18 Jan 2022 02:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473394;
        bh=NsNmxlzJcp4bHdt1JVI79chzoIVKauwC5RQte6uzHu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJgwundM7BWDCmGSX5KG1EtGlzClCDRd4gTLhMFMQgy6NJGcUA7XipFsIO6qJczmR
         I37nz5dkCUmgu7skF5mC8i1Ik6ei3WR/fktfSe3sixF2Vm066pTQrBkU0aEN/TaJMV
         ehAkqnZlQ0urSF2yuV9nshemBAJ8PEVnNO/oI9mm9HInNl0v5DI1dKODsxRCuugaLK
         V8cahBJFWvu0SEhdHskQRkX8Ex7dffbJGEas/7QwZPmddjN55/S+6TZVSo7MvI4VgP
         Bq8wcY8Zto38+kbfqWLAm0tzaIEbEWhRq5it3MjvGq2vi6SoldxMwl9xsAz9Kj4KPM
         o+jyQmpc09iZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mingo@redhat.com, shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 100/188] selftests/ftrace: make kprobe profile testcase description unique
Date:   Mon, 17 Jan 2022 21:30:24 -0500
Message-Id: <20220118023152.1948105-100-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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

