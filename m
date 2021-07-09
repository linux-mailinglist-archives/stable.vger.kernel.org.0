Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDB03C2447
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhGINWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232105AbhGINV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F220A613B6;
        Fri,  9 Jul 2021 13:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836752;
        bh=kHbbBboG5HV3y4ScKuG/6BoVheTlA4jdGKRY4jJ2r0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0NmztbxJXcFN8PX2y2FSpLWf6Z5AZG0ZYNr4Mz7F9kivW+zQbJUO87U8c4PjV76O
         johdsLh1Fx2BDTTUB+SMQhs9pT5XNrPNb3sbacPz5l2VfLEO9WmmD4p+MtOBFJfv6c
         XrODVNchXDI0WcmMzu6/Rm9Z+zvj2ZP80HZahD3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/25] mm/rmap: remove unneeded semicolon in page_not_mapped()
Date:   Fri,  9 Jul 2021 15:18:34 +0200
Message-Id: <20210709131629.943931913@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 8bd2ddd8febd..e2506b6adb6a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1671,7 +1671,7 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 static int page_not_mapped(struct page *page)
 {
 	return !page_mapped(page);
-};
+}
 
 /**
  * try_to_munlock - try to munlock a page
-- 
2.30.2



