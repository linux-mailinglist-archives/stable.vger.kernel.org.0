Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A443C2485
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhGINXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhGINXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D72046128A;
        Fri,  9 Jul 2021 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836855;
        bh=QE/lRr22rMb3HnfJkIoiPNu3YAjk4daybX2AR1E6j1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8jiMSxD8SmQl9k2hVGDb3mIDN+nbPiPw7EkaR2h+mh4fX4EPjcXr2+uVw3tK9/Iz
         NwtsFEmlEouVN6PeFN0RNshGXLrfCwigSkRdJ3FWvDwRYD0myBU3pIEbzGYjvvnMd7
         qr3duRKtFAidB31cg/bIXT0WKXuRgtmBQdpWw4uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/34] mm/rmap: remove unneeded semicolon in page_not_mapped()
Date:   Fri,  9 Jul 2021 15:20:18 +0200
Message-Id: <20210709131646.534367776@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
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
index 1bd94ea62f7f..69ce68616cbf 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1729,7 +1729,7 @@ bool try_to_unmap(struct page *page, enum ttu_flags flags)
 static int page_not_mapped(struct page *page)
 {
 	return !page_mapped(page);
-};
+}
 
 /**
  * try_to_munlock - try to munlock a page
-- 
2.30.2



