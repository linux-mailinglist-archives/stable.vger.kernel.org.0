Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656222B65DF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgKQN6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:58:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgKQNUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:20:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32EB9241A5;
        Tue, 17 Nov 2020 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619242;
        bh=PcodkDpP7V/CMTki9gtGulfrSYLM8ULRbc0zlvUMfq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0kRbkSEHIz16Pp9GbkxiVwg1oqg+0qxUFU+bdVfYMTbNL129+Nr+CVa0fr9yZgRQ
         Yppc5Z9u3lUCgfjPc8+J/sfGUhCKxq9V6UEeM1orBB4V2Wvan2e+WkqptZhr9b5xII
         S0JAmg8yB5wQH/1DYhBkFcqeTjuRvt5TN8bXbtBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/101] selftests: proc: fix warning: _GNU_SOURCE redefined
Date:   Tue, 17 Nov 2020 14:05:13 +0100
Message-Id: <20201117122115.341648973@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
index fcff7047000da..8edaafc2b92fd 100644
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
index 5ab5f4810e43a..7b9018fad092a 100644
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



