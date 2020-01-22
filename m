Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6CCE14508D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgAVJrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:47:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387661AbgAVJmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D05824690;
        Wed, 22 Jan 2020 09:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686124;
        bh=ukVkUyF05fhN75MBR5+oeu5iKDPLeh+x2ejrY96sZbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rD8jhizHHO8m5WTohmt6GeqLYf95VhdQXYWG1Efn7T8i5v1/5CEVJtjP8QFHQxC6G
         0P8KDwh0FjdQbbzp7IEm2g9RgIt3M8aEGWREA9fIeEEmNvIjvZaMCvywXJJikNEhqS
         gFEZBV7z548pV0Eu1tc0yLHgwY/FLLsPoBwXpfpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bharath Vedartham <linux.bhar@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/103] mm/huge_memory.c: make __thp_get_unmapped_area static
Date:   Wed, 22 Jan 2020 10:29:08 +0100
Message-Id: <20200122092811.542790118@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bharath Vedartham <linux.bhar@gmail.com>

[ Upstream commit b3b07077b01ecbbd98efede778c195567de25b71 ]

__thp_get_unmapped_area is only used in mm/huge_memory.c.  Make it static.
Tested by building and booting the kernel.

Link: http://lkml.kernel.org/r/20190504102353.GA22525@bharath12345-Inspiron-5559
Signed-off-by: Bharath Vedartham <linux.bhar@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5a1771bd5d04..950466876625 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -509,7 +509,7 @@ void prep_transhuge_page(struct page *page)
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
-unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long len,
+static unsigned long __thp_get_unmapped_area(struct file *filp, unsigned long len,
 		loff_t off, unsigned long flags, unsigned long size)
 {
 	unsigned long addr;
-- 
2.20.1



