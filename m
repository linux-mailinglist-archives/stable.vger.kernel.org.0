Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADC010BD10
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbfK0VAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731630AbfK0VAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:00:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23B512158A;
        Wed, 27 Nov 2019 21:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888453;
        bh=S3hOXPcM+w0k/7va/5THvsyB8gokQ9VS9+1IN4YV+Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcqK2YBPVKzGCjWHDM0kUy3NX8d0gunyniSGoZqyD9FzOlkVUlJkPh3en+/hxCla8
         a17ax2+bebDvHskzd3mzQA+GnNbr8WJ1gi3f1hs80w99XqdzNBFmvJ6WWDrkjac7HL
         k/GI4p1P6l3QWcUMs5yyf/hUu2dmy2FRpmzJfYn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Hao <peng.hao2@zte.com.cn>,
        "Shuah Khan (Samsung OSG)" <shuah@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/306] selftests: fix warning: "_GNU_SOURCE" redefined
Date:   Wed, 27 Nov 2019 21:29:48 +0100
Message-Id: <20191127203125.117312715@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



