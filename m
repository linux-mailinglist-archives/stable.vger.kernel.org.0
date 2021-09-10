Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE416406152
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhIJAmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231754AbhIJASU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F7C611C4;
        Fri, 10 Sep 2021 00:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233014;
        bh=57vFTcOJ+yFREvKnkKYBx44O4OYEhdto7aRuTkiK8wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxasgW6oI59/yloZgM/aD1OlSJE9DfAa+xLWY5YGWONq7UCT7DvFBVaJFOPAFe2CN
         tNndzXn8e0lX51DxaClPFZ+15tGbp8lKIK0YVfxa85/QKp1ARN0Toca2aj/o2kiQVm
         +KClQHaP7SidLOeMXd5W1TtFAC1vcTQlSZE2CWACijSUXrkn1akEtHNPgpVihlg4Uz
         nRKFZq3Skrl4oCpnliXD121FeGU6PWWPmkQKebYKQFhKJjPU7UCKWG5HUUH9wF6rVg
         kI736CuvPHOt5U7AguslKWqjM8QTtvdPJFWGp7BNkhNCMcU7D85I/bt43o3fYZmZnu
         WQ5F+yW0SmBEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.14 40/99] jbd2: fix clang warning in recovery.c
Date:   Thu,  9 Sep 2021 20:14:59 -0400
Message-Id: <20210910001558.173296-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
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

