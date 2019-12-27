Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2886F12B89B
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfL0R44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727636AbfL0Rly (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29FFC218AC;
        Fri, 27 Dec 2019 17:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468513;
        bh=7rwKNQPuyOvNkbJa8xITK69Gi8xyKc1iP/xJ7pOhLxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNpZHnPvsjr15yMJTvIgUhdmdQzuSxYdZUd11EJnwPdn+3ez2jBy/DA932wjqHBwP
         pn5Iqs79iuu+RsLVdONijMfQDt5fZ7hAR8jtP/hsLVUK7MnclSmIolbXT48AqUGIHt
         DjXDujJThfbuKlel75RnJRc5854agj66S4I6JIP4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 046/187] selftests: safesetid: Fix Makefile to set correct test program
Date:   Fri, 27 Dec 2019 12:38:34 -0500
Message-Id: <20191227174055.4923-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 8ef1ec0ca32c6f8a87f5b4c24b1db26da67c5609 ]

Fix Makefile to set safesetid-test.sh to TEST_PROGS instead
of non existing run_tests.sh.

Without this fix, I got following error.
  ----
  TAP version 13
  1..1
  # selftests: safesetid: run_tests.sh
  # Warning: file run_tests.sh is missing!
  not ok 1 selftests: safesetid: run_tests.sh
  ----

Fixes: c67e8ec03f3f ("LSM: SafeSetID: add selftest")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/safesetid/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/safesetid/Makefile b/tools/testing/selftests/safesetid/Makefile
index cac42cd36a1b..fa02c4d5ec13 100644
--- a/tools/testing/selftests/safesetid/Makefile
+++ b/tools/testing/selftests/safesetid/Makefile
@@ -3,7 +3,7 @@
 CFLAGS = -Wall -O2
 LDLIBS = -lcap
 
-TEST_PROGS := run_tests.sh
+TEST_PROGS := safesetid-test.sh
 TEST_GEN_FILES := safesetid-test
 
 include ../lib.mk
-- 
2.20.1

