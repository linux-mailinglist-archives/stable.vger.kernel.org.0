Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C964C2B64D0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbgKQNuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731479AbgKQNcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19454207BC;
        Tue, 17 Nov 2020 13:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619970;
        bh=xmOMM0Bx3ddU19zmV2NvFftKqS1AYTFdXm+PxQ+vOp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qjKrp1lmJAeS/kDfsFvyU2hs5T2rpA6lMkf0zY5w8RX00B+Hn8HqP7FmWIh1gE8M
         sGTOkb6saGLvp9TYVEttkI2nIH8qUDW7rOY4+IzCwP+oGJBPC3pw0wvD/vHmJ612pc
         r4cqLetnLNk/XsxXjpfJCtaBWFa8yLln0rLCiCsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 066/255] selftests: clone3: use SKIP instead of XFAIL
Date:   Tue, 17 Nov 2020 14:03:26 +0100
Message-Id: <20201117122142.164933965@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

[ Upstream commit afba8b0a2cc532b54eaf4254092f57bba5d7eb65 ]

XFAIL is gone since commit 9847d24af95c ("selftests/harness: Refactor XFAIL
into SKIP"), use SKIP instead.

Fixes: 9847d24af95c ("selftests/harness: Refactor XFAIL into SKIP")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/clone3/clone3_cap_checkpoint_restore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/clone3/clone3_cap_checkpoint_restore.c b/tools/testing/selftests/clone3/clone3_cap_checkpoint_restore.c
index 9562425aa0a90..614091de4c545 100644
--- a/tools/testing/selftests/clone3/clone3_cap_checkpoint_restore.c
+++ b/tools/testing/selftests/clone3/clone3_cap_checkpoint_restore.c
@@ -145,7 +145,7 @@ TEST(clone3_cap_checkpoint_restore)
 	test_clone3_supported();
 
 	EXPECT_EQ(getuid(), 0)
-		XFAIL(return, "Skipping all tests as non-root\n");
+		SKIP(return, "Skipping all tests as non-root");
 
 	memset(&set_tid, 0, sizeof(set_tid));
 
-- 
2.27.0



