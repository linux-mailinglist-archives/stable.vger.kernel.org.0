Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C655145623
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgAVNVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730155AbgAVNVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:21:09 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA63524688;
        Wed, 22 Jan 2020 13:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699268;
        bh=MNpFJ+xxo3lMFNVeamBfXT2zdZpC3ty89O9XeXXGr+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KSmaWWdciL3G3YZ3yvcmNwhTcXGq8u9dezlMSeG5dvCg6CgAqwKlog1BJZBX/u68
         xMBNcSuuj+M6Dc6TBjxpTS4N0x5WiXpusA7KcE9hJoKmPZIhbnBeXOn0lx1/3M5N9H
         MUCX+yZUJqzXupBoEmtuHUDUI8J7FB23mX/e47YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <yang.shi@linux.alibaba.com>,
        Song Liu <songliubraving@fb.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 092/222] mm: khugepaged: add trace status description for SCAN_PAGE_HAS_PRIVATE
Date:   Wed, 22 Jan 2020 10:27:58 +0100
Message-Id: <20200122092840.322914725@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

commit 554913f600b45d73de12ad58c1ac7baa0f22a703 upstream.

Commit 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem)
FS") introduced a new khugepaged scan result: SCAN_PAGE_HAS_PRIVATE, but
the corresponding description for trace events were not added.

Link: http://lkml.kernel.org/r/1574793844-2914-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/huge_memory.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -31,7 +31,8 @@
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
 	EM( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
-	EMe(SCAN_TRUNCATED,		"truncated")			\
+	EM( SCAN_TRUNCATED,		"truncated")			\
+	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 
 #undef EM
 #undef EMe


