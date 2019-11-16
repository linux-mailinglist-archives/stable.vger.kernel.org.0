Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42FEFFF2C8
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfKPPnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfKPPnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:43 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D86720729;
        Sat, 16 Nov 2019 15:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919022;
        bh=S3hOXPcM+w0k/7va/5THvsyB8gokQ9VS9+1IN4YV+Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnMe1cMnvrWVIZatEDP+2TRffjD6G7UtdNN93bFc4YzyJQoOOOmvmr0hTmgu5iuor
         i0bGkn84BcyWp4NKABrKCI88vSJooecDyotQ0XFensS7b11/3Sk0o7dPCoEv7ZD0+I
         x6Zbx1bMaODo8pkYHoia68byGS7qr3JOjoOBXGHo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Hao <peng.hao2@zte.com.cn>, Shuah Khan <shuah@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 120/237] selftests: fix warning: "_GNU_SOURCE" redefined
Date:   Sat, 16 Nov 2019 10:39:15 -0500
Message-Id: <20191116154113.7417-120-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Hao <peng.hao2@zte.com.cn>

[ Upstream commit 0387662d1b6c5ad2950d8e94d5e380af3f15c05c ]

Makefile contains -D_GNU_SOURCE. remove define "_GNU_SOURCE"
in c files.

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
Signed-off-by: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/proc/fd-001-lookup.c  | 2 +-
 tools/testing/selftests/proc/fd-003-kthread.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/proc/fd-001-lookup.c b/tools/testing/selftests/proc/fd-001-lookup.c
index a2010dfb21104..60d7948e7124f 100644
--- a/tools/testing/selftests/proc/fd-001-lookup.c
+++ b/tools/testing/selftests/proc/fd-001-lookup.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 // Test /proc/*/fd lookup.
-#define _GNU_SOURCE
+
 #undef NDEBUG
 #include <assert.h>
 #include <dirent.h>
diff --git a/tools/testing/selftests/proc/fd-003-kthread.c b/tools/testing/selftests/proc/fd-003-kthread.c
index 1d659d55368c2..dc591f97b63d4 100644
--- a/tools/testing/selftests/proc/fd-003-kthread.c
+++ b/tools/testing/selftests/proc/fd-003-kthread.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 // Test that /proc/$KERNEL_THREAD/fd/ is empty.
-#define _GNU_SOURCE
+
 #undef NDEBUG
 #include <sys/syscall.h>
 #include <assert.h>
-- 
2.20.1

