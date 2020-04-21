Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749EC1B2676
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgDUMlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728944AbgDUMlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2337C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z6so3517622wml.2
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Nj0NDRZcwtFUKC+R5D84Cl9+iKFH6tH3lHBrw9Pa8o=;
        b=fpzqa2imHiVlPxbUZGkEUblK2/1dPviWBQb7rk71/gymYNc0m6BJpSb/WiXrMQ+TY5
         RzYqiHsg8ECILHp3dCPQs2nD5e1JIG8w5Vfxla5k19uWnTkQjf1Y++KdgJi6oeq565R2
         rh3kvsnAJGmoUUwgvMjXizSaX76kHOAuFOSn4nu/spSr1o4aTKAlNl7WBnzKw/e/NUf7
         qTKamQAddLlM6q+J/ngwzd/ORcGWZ3K5E+TyhlzqCq6HjLiNaSg3Vv6VYEE9OLgwJJ2e
         PVMwyUXY2OOpnllbdaXOHrrhyspxI1hMVfmiST/o+1Kc3zJxDogfUTsXrDZRtXoDKcHB
         iftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Nj0NDRZcwtFUKC+R5D84Cl9+iKFH6tH3lHBrw9Pa8o=;
        b=KfzlzD2IDEwmPFrYHY/SZzPC8oGcJE9AwQrNVFf/ZMC6RKEASkRGjyFFrItzotXql8
         cFeTtfzixA91H/IyTN/eNmhmiQZEQ/RIptVgDk8ft61EJoSTBGSB36wMZrIecIMgLcKX
         VAWx0X9b95idszfFZpwjpr1OYHduav+otYT3sRqaI+H86KrM01XQQUXJREbV/UREv8cm
         xLc6NpvIRDqpF4ru3uuKEqAvJ7PODswqYDwxLea5KFPkEPy6c4jkklL9VDOjRr+VIxkj
         p3z/J0FXyW2gQrqpxBeks6CumzN70mcfP6oM8JLqPLqAT9nnNBPTSIUfOTX3NlTq7i3+
         RLOw==
X-Gm-Message-State: AGi0PuaVEltUt+oDn+OfHFe3FgMpXB5ai1V7I+QsIzx2VFoOmaVMkcjW
        eh3Mb/wdBlxbb2baYkweyYQZnZy2jJI=
X-Google-Smtp-Source: APiQypKvFaBx+rt1iW01Wwn7hDXksFf0hYLO1Q/ruRVLF6wzQR2JgRk6R+muGSQ+YftdyDroq7D2zw==
X-Received: by 2002:a1c:23d4:: with SMTP id j203mr5030076wmj.49.1587472876476;
        Tue, 21 Apr 2020 05:41:16 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Roman Gushchin <guro@fb.com>, Roman Penyaev <rpenyaev@suse.de>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 24/24] mm/vmalloc.c: move 'area->pages' after if statement
Date:   Tue, 21 Apr 2020 13:40:17 +0100
Message-Id: <20200421124017.272694-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 7ea362427c170061b8822dd41bafaa72b3bcb9ad ]

If !area->pages statement is true where memory allocation fails, area is
freed.

In this case 'area->pages = pages' should not executed.  So move
'area->pages = pages' after if statement.

[akpm@linux-foundation.org: give area->pages the same treatment]
Link: http://lkml.kernel.org/r/20190830035716.GA190684@LGEARND20B15
Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 mm/vmalloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d00961ba0c42d..88091fd704f42 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1682,7 +1682,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
-	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|highmem_mask,
@@ -1690,13 +1689,16 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
-	area->pages = pages;
-	if (!area->pages) {
+
+	if (!pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
 		return NULL;
 	}
 
+	area->pages = pages;
+	area->nr_pages = nr_pages;
+
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
 
-- 
2.25.1

