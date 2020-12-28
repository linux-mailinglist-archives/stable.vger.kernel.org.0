Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100DF2E4124
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408162AbgL1PDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439925AbgL1OMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2D3F207B7;
        Mon, 28 Dec 2020 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164722;
        bh=R42JxnFrbs1I+2TTAWOh7qtqeUJOqTTKC4NDAD4O8Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zC7eGyqvu0bOPB/fVe6JBQYJpnxuwmhIgBATAKnTEjZHH/6iq7DKKyAklPxULoezE
         1Ag+lMQ1Shcqvo5ZiuTncRN7P3rFmBnxLsgLyPlQ3p0vM+ygYXTaaOThH1MLxsQn2q
         lKkzIkANOlrtvPNsdCOWCvK7mTkNVl9OdIdHVvZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        Tycho Andersen <tycho@tycho.pizza>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/717] selftests/seccomp: Update kernel config
Date:   Mon, 28 Dec 2020 13:44:31 +0100
Message-Id: <20201228125034.096155803@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 64c19d8eba795..ad431a5178fbe 100644
--- a/tools/testing/selftests/seccomp/config
+++ b/tools/testing/selftests/seccomp/config
@@ -1,3 +1,4 @@
+CONFIG_PID_NS=y
 CONFIG_SECCOMP=y
 CONFIG_SECCOMP_FILTER=y
 CONFIG_USER_NS=y
-- 
2.27.0



