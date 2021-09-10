Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AE1406207
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhIJAo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231163AbhIJAUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 235F2611CA;
        Fri, 10 Sep 2021 00:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233149;
        bh=57vFTcOJ+yFREvKnkKYBx44O4OYEhdto7aRuTkiK8wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lb+E9Xo8bhuS+c6/S9jyIgnHZZ6nrQuvyQdu3I/zht9BuqZ4dM8FLNCWz/BVMmRxv
         BJXVvPA5GMHAcs4OCmN5XuTcHmUICz0XECaDVpN9lWKAsuq5LACxJbFfO1e+UjiGdn
         mBm9pXCrH1gk3SxnC4WLrj2NbVo+oYQBALw63xCcE7NBD8advMdsbvlf+qE6MS/EFA
         lEjnrosni3oi2RIxbco5meAGpzIT7HivRLNcxxhX1a6V0jElRwBjUeDe3XDKGqDpkD
         tiB2eTWEB433qy/6S+ik6QnH4+4IHrACZznhaCx5K1v17ejJBSJDdJmGcIhxIeFDEI
         fFlBxW8daNCGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.13 34/88] jbd2: fix clang warning in recovery.c
Date:   Thu,  9 Sep 2021 20:17:26 -0400
Message-Id: <20210910001820.174272-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 390add0cc9f4d7fda89cf3db7651717e82cf0afc ]

Remove unused variable store which was never used.

This fix is also in e2fsprogs commit 99a2294f85f0 ("e2fsck: value
stored to err is never read").

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/recovery.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 4c4209262437..ba979fcf1cd3 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -760,7 +760,6 @@ static int do_one_pass(journal_t *journal,
 				 */
 				jbd_debug(1, "JBD2: Invalid checksum ignored in transaction %u, likely stale data\n",
 					  next_commit_ID);
-				err = 0;
 				brelse(bh);
 				goto done;
 			}
-- 
2.30.2

