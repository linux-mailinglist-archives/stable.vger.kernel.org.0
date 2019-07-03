Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0AC5E14B
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 11:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGCJrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 05:47:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35807 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfGCJrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 05:47:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id c27so2026993wrb.2
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 02:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQbS3A8xiMmpNNf6PGola8QmLy/1LRvhN5dwsk9vSMU=;
        b=QiYd9+QzOW/pYTkr8SYV6I8DIASwtVXe+x5Wqr2AeqaT83gaJe7zqCocyRCqfU7rU8
         HL8gpAs0Wg8VxD2DWix7nIhwdD7usU3WnfC8+2SV+Eq8/iF1NK0j8CF+mdOlFq/xDSpk
         T5FzMdh9pLFOnTjE9/W0L+z+lsg9wvH4gH1pRrWrude8Q8LZ3juVlvtGAZeo+814DjPd
         0OfsvUHPjrFb3HvZtep8OVYp7hET1slBcptzPlMxsRbWRXphPWznHKNbz6bGOF/S5O30
         GnjOGRJhMBJcvKNgLeJCyxFmJh4aNdhZL/zixn02TehjX0IdXHi2yVIF5gfWSUZTh6Vo
         HfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQbS3A8xiMmpNNf6PGola8QmLy/1LRvhN5dwsk9vSMU=;
        b=GoLg1HGpMT2y1iko9R7w4pEVQ8DI/aVjYPtmijLZyKSDAS3IZsOzqs3smJV26E5hER
         WmsNoA854MUW/TiiOhsaR9C0R8CxGIXqWbG+hKYyft72wPceWqQ2mNed0AZPUl1K4d/T
         qvuR/tOxs8t8uRU1DCJKtRNiDBmg1uYyyuBK1MljnkJquRt7BD4IxsAxQ94NXAsFDfnX
         mzzF5y8XtSTbcHPXnxzPoehxymcnUUz7CD+8KqdS3IYLyz5r+mW1nRwdQYdKnfxZf7rP
         210KjHeQuqqY7MBeroxR8i8dYoWLdsX5OQ9YxJa01nswfgUYeR4NM1fWU1gonALwWcud
         ptPQ==
X-Gm-Message-State: APjAAAWNgKNIRmf+AciAWXCPyTCB8zJY53rihYYTub7Nlb/FUK7yRYQ8
        JfkZedTzGOEU8PfHsX5bwlnckA==
X-Google-Smtp-Source: APXvYqxSiCauqcgWW3J3sZMFKmyZsw1W3L9ofo4oAfmqgg0AknYF6emACifhDeu+uGeQC+z1c2BqXw==
X-Received: by 2002:adf:ce8f:: with SMTP id r15mr28166092wrn.122.1562147217911;
        Wed, 03 Jul 2019 02:46:57 -0700 (PDT)
Received: from balsini.lon.corp.google.com ([2a00:79e0:d:203:fc05:dec:5003:37b1])
        by smtp.gmail.com with ESMTPSA id 17sm1836529wmx.47.2019.07.03.02.46.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 02:46:57 -0700 (PDT)
From:   Alessio Balsini <balsini@android.com>
To:     gregkh@linuxfoundation.org
Cc:     astrachan@google.com, maennich@google.com, kernel-team@android.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4.4] um: Compile with modern headers
Date:   Wed,  3 Jul 2019 10:46:27 +0100
Message-Id: <20190703094627.50424-1-balsini@android.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 530ba6c7cb3c22435a4d26de47037bb6f86a5329 upstream.

Recent libcs have gotten a bit more strict, so we actually need to
include the right headers and use the right types. This enables UML to
compile again.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Alessio Balsini <balsini@android.com>
---
 arch/um/os-Linux/file.c   | 1 +
 arch/um/os-Linux/signal.c | 2 ++
 arch/x86/um/stub_segv.c   | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index 26e0164895e4..6e6f6d28d54b 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -12,6 +12,7 @@
 #include <sys/mount.h>
 #include <sys/socket.h>
 #include <sys/stat.h>
+#include <sys/sysmacros.h>
 #include <sys/un.h>
 #include <sys/types.h>
 #include <os.h>
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 56648f4f8b41..5da50451d372 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -14,7 +14,9 @@
 #include <as-layout.h>
 #include <kern_util.h>
 #include <os.h>
+#include <sys/ucontext.h>
 #include <sysdep/mcontext.h>
+#include <um_malloc.h>
 
 void (*sig_info[NSIG])(int, struct siginfo *, struct uml_pt_regs *) = {
 	[SIGTRAP]	= relay_signal,
diff --git a/arch/x86/um/stub_segv.c b/arch/x86/um/stub_segv.c
index fd6825537b97..27361cbb7ca9 100644
--- a/arch/x86/um/stub_segv.c
+++ b/arch/x86/um/stub_segv.c
@@ -6,6 +6,7 @@
 #include <sysdep/stub.h>
 #include <sysdep/faultinfo.h>
 #include <sysdep/mcontext.h>
+#include <sys/ucontext.h>
 
 void __attribute__ ((__section__ (".__syscall_stub")))
 stub_segv_handler(int sig, siginfo_t *info, void *p)
-- 
2.22.0.410.gd8fdbe21b5-goog

