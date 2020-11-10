Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B352ACD20
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbgKJD7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731980AbgKJD4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:56:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20EC21D93;
        Tue, 10 Nov 2020 03:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980566;
        bh=PcodkDpP7V/CMTki9gtGulfrSYLM8ULRbc0zlvUMfq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeEQxgnzOcQOmDHWtHr3V0VNw8CZanRxlJqUrPxrG26G4TL/BMhF0tanit9J2bcvS
         bLiXSTQ5OhedYyElhV185oWcR8N3YO6XjhDNPv/SuCZB8l8NCEyAnY5e2BBRCPf3Ux
         JTWsePEKtWxkr5PlUf5/Ri1qU0i77eMmCNXcoiAI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tommi Rantala <tommi.t.rantala@nokia.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/21] selftests: proc: fix warning: _GNU_SOURCE redefined
Date:   Mon,  9 Nov 2020 22:55:39 -0500
Message-Id: <20201110035541.424648-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035541.424648-1-sashal@kernel.org>
References: <20201110035541.424648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

