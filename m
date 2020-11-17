Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D82D2B6229
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731399AbgKQN0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:26:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731394AbgKQN0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17ADC20781;
        Tue, 17 Nov 2020 13:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619559;
        bh=K50d19qP/F886/2Ft2H5yb441enUZkoFfD7ULSsqUn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRZLij8V2bdMI+oDp3KhmbXKS4hsndULLJh2HUIegqmAur9gUqS+OngruYxNDDfqN
         3B7dt1Zpzx8QMYQPhzDVACsXTJxwFSdwU1pJAUwGGcxMV7nlIEENfKMj2OGoK6ggOw
         9y6gWKUL3gOUVOoI13J95wPlvgdMgUEERNZcDvVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/151] selftests: proc: fix warning: _GNU_SOURCE redefined
Date:   Tue, 17 Nov 2020 14:05:10 +0100
Message-Id: <20201117122125.313990255@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

[ Upstream commit f3ae6c6e8a3ea49076d826c64e63ea78fbf9db43 ]

Makefile already contains -D_GNU_SOURCE, so we can remove it from the
*.c files.

Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/proc/proc-loadavg-001.c  | 1 -
 tools/testing/selftests/proc/proc-self-syscall.c | 1 -
 tools/testing/selftests/proc/proc-uptime-002.c   | 1 -
 3 files changed, 3 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-loadavg-001.c b/tools/testing/selftests/proc/proc-loadavg-001.c
index 471e2aa280776..fb4fe9188806e 100644
--- a/tools/testing/selftests/proc/proc-loadavg-001.c
+++ b/tools/testing/selftests/proc/proc-loadavg-001.c
@@ -14,7 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 /* Test that /proc/loadavg correctly reports last pid in pid namespace. */
-#define _GNU_SOURCE
 #include <errno.h>
 #include <sched.h>
 #include <sys/types.h>
diff --git a/tools/testing/selftests/proc/proc-self-syscall.c b/tools/testing/selftests/proc/proc-self-syscall.c
index 9f6d000c02455..8511dcfe67c75 100644
--- a/tools/testing/selftests/proc/proc-self-syscall.c
+++ b/tools/testing/selftests/proc/proc-self-syscall.c
@@ -13,7 +13,6 @@
  * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#define _GNU_SOURCE
 #include <unistd.h>
 #include <sys/syscall.h>
 #include <sys/types.h>
diff --git a/tools/testing/selftests/proc/proc-uptime-002.c b/tools/testing/selftests/proc/proc-uptime-002.c
index 30e2b78490898..e7ceabed7f51f 100644
--- a/tools/testing/selftests/proc/proc-uptime-002.c
+++ b/tools/testing/selftests/proc/proc-uptime-002.c
@@ -15,7 +15,6 @@
  */
 // Test that values in /proc/uptime increment monotonically
 // while shifting across CPUs.
-#define _GNU_SOURCE
 #undef NDEBUG
 #include <assert.h>
 #include <unistd.h>
-- 
2.27.0



