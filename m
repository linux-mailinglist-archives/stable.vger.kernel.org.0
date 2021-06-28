Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701F23B6128
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhF1Ocy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233887AbhF1Oaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 982B161CCD;
        Mon, 28 Jun 2021 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890431;
        bh=LlNld06z9pKZHf8tjucOg26FCgLlgFc/GY5xYOert4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsHFAOuqMPFuBoVPOl6Xd6/4Ev2S0DUkFy8AlTEqX+ndpFOXU1GzcpV55PqFI0Ssi
         jJbYeGKgS5jwmiqR+7LkxsK9ZTqogAgTTA80nyY7rh9ELHPtXKr3LbfwoE1CDP2PMv
         SnOieR+EcoXKXwNElkuu4KI6LgZnBx1956XNOqL3oHowviAwuVV4FZOiFd9uo9s2oW
         CJ6S+mmSKqquwnzAPVHF2T5MgrNUaAPJg7ON3YtpO3i11VECslVxJ3HKKvtHy98jtM
         UaDXc274lRJ18h41x/2941lGE1ekaSDYBzWbVhAbR8aVb8UoC9Y4+kmNDaSLFLtoQo
         3+tZICnQoa9bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 072/101] mm/rmap: remove unneeded semicolon in page_not_mapped()
Date:   Mon, 28 Jun 2021 10:25:38 -0400
Message-Id: <20210628142607.32218-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit e0af87ff7afcde2660be44302836d2d5618185af ]

Remove extra semicolon without any functional change intended.

Link: https://lkml.kernel.org/r/20210127093425.39640-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6657000b18d4..5858639443b4 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1763,7 +1763,7 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 static int page_not_mapped(struct page *page)
 {
 	return !page_mapped(page);
-};
+}
 
 /**
  * try_to_munlock - try to munlock a page
-- 
2.30.2

