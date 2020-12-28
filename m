Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246932E6340
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632901AbgL1PkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405908AbgL1Nsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D8FA22B3A;
        Mon, 28 Dec 2020 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163294;
        bh=C0KSPiQKqK/l5eNb8bpz6ae6c2mal6eNP8Qb9JXlzek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1St+6yQ8sA6CX/8F87RgHa8c9snI8zC5IijEce2BrnsHkrcOgP4ba0QytcKgd9Jx
         p75J+P1AxD/kVP/jRAsGEpNOn/bj2TGQFuJeRUwMx26ZqgiIzNG1WybvaCZXoExIU9
         y5t3SCTvj8X4B/eOxFl39LraXZGVNlM9ZIkqNRSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Tycho Andersen <tycho@tycho.pizza>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/453] selftests/seccomp: Update kernel config
Date:   Mon, 28 Dec 2020 13:47:22 +0100
Message-Id: <20201228124947.128948138@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

[ Upstream commit 2c07343abd8932200a45ff7b10950e71081e9e77 ]

seccomp_bpf.c uses unshare(CLONE_NEWPID), which requires CONFIG_PID_NS
to be set.

Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Acked-by: Tycho Andersen <tycho@tycho.pizza>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20201202162643.249276-1-mic@digikod.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/seccomp/config b/tools/testing/selftests/seccomp/config
index db1e11b08c8a4..764af1f853f95 100644
--- a/tools/testing/selftests/seccomp/config
+++ b/tools/testing/selftests/seccomp/config
@@ -1,2 +1,3 @@
+CONFIG_PID_NS=y
 CONFIG_SECCOMP=y
 CONFIG_SECCOMP_FILTER=y
-- 
2.27.0



