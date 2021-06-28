Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188053B6201
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhF1Okx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234242AbhF1OhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:37:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C07E461CA5;
        Mon, 28 Jun 2021 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890647;
        bh=L/1j9FrTpoWtOcRqVWUfJQRSZAQ4h/0dQCzvtgV6X9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C58yBZfXsii+7JC9FTHUUobKXTCGs/QreIZPfQn/m9/2cUZnZQtWJWNmlT7Pi1UWx
         36YxRl6GeiQU6zKAW1ArVpqXley3YaBFxx7zKrF1MtMB1QonK/N1qPZ7qcsSGxt4Mb
         bqBhmnR4jEtyUU1CsqHESuWiKPRVg4/wdSL1tLa+VQLP1mEMSqAN273CYGAu9q6gn2
         0S6MCB59nyKhKcJF3LKvZVbf3cOH+Qz4PyarzEAjdr2UT0XXFyldiW46cL7lUsrMnp
         7HM9GRIZyCPDtbQffOsbpaJI/lwYRxoSGydx2Xhh122m9WszXyf65cvbnGj6qhRD6H
         p/yU7Sg8UFkEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 46/71] mm/rmap: remove unneeded semicolon in page_not_mapped()
Date:   Mon, 28 Jun 2021 10:29:39 -0400
Message-Id: <20210628143004.32596-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
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
index 0c7b2a9400d4..ccc8a780e348 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1737,7 +1737,7 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 static int page_not_mapped(struct page *page)
 {
 	return !page_mapped(page);
-};
+}
 
 /**
  * try_to_munlock - try to munlock a page
-- 
2.30.2

