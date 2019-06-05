Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17DD36173
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfFEQiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:38:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36165 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbfFEQiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 12:38:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id d21so9893119plr.3
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 09:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6TisYdWDDxStlkadsZZdG4toawp7BkJl+ZYVvOuB8co=;
        b=Nh80LODwKPQx4engjliWy/Sl4k5NI6dsHEsCgGIYM7auQf9R39O2J/7ZK1766x10w6
         fquVgmte3Pk9UhxuUorhHT/4KjdB8w0+FnK3YlQlfdLJ1M/vlO8VVV+2WK2hFg7g5pkc
         5yH9d2eNq8I30HALVAjFZ6nsweoV0sWqvHZEe/0PO3MwtkZnP3vQHfuI1k5NJv7910ED
         yFI1/GYDpAmtcj6FJGIquqACXwS+3mk8bC4+mTIYyEQ9w2vEMjxKok71l2/hQbv59akV
         4IUqKJzjFb2ZtCs6ukiDdnWeEm2TWPZLjr4DF72bx2veDsZLkNoU5AmHr/jsHwc6lTfV
         yBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6TisYdWDDxStlkadsZZdG4toawp7BkJl+ZYVvOuB8co=;
        b=V+RjmGVCsZmFyAv8rlzPai6umi+B0arA2xoDINBWEjrqA3pJVjmhemUcaVizlQscbc
         e6ZlMMUHvgS+sCuUXTgVUdLtedxI0Cwd/sp5WwyjRw/JLXZv0JYb5VIOEMww/HRJtnNE
         KPOjjeXUd7NUfGnXL6ITu6A65pSDb8/vrxvzybCbHrKjdsoZ4Ozd3DCRPSW1LRQnDDWw
         MXqB3n+Kc0asRfLBLTjwJE2UZm7Uhhv/zWh9pF+BGisp6mwuF3WEqqOjB+3e1JLSqLXP
         q5r7FOZMooBpz7r4eTt5VvVyppdl+6wW/cvJOpquJDKnUguiiAnb8+w9wuZtHNJWLhcY
         siOQ==
X-Gm-Message-State: APjAAAWuOzJ35Dxi4N35XKMWFgHc/5YsGpCK/bvE0vrVQo1A9F6Yfb7T
        XNrZFC1GyFbwdEuFw22h3MtI7g==
X-Google-Smtp-Source: APXvYqwQAlDF3LdF4zmws9qIVO8QH9BlWmC+EtHfosdJofiukpn9rh4gWL1a7azn5ANFXMR2+rEC4w==
X-Received: by 2002:a17:902:9004:: with SMTP id a4mr31841146plp.109.1559752681928;
        Wed, 05 Jun 2019 09:38:01 -0700 (PDT)
Received: from ava-linux2.mtv.corp.google.com ([2620:0:1000:1601:6cc0:d41d:b970:fd7])
        by smtp.googlemail.com with ESMTPSA id 25sm22785908pfp.76.2019.06.05.09.38.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 09:38:01 -0700 (PDT)
From:   Todd Kjos <tkjos@android.com>
X-Google-Original-From: Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     ben.hutchings@codethink.co.uk, Alexander.Levin@microsoft.com
Subject: [PATCH 4.14 1/2] Revert "binder: fix handling of misaligned binder object"
Date:   Wed,  5 Jun 2019 09:37:45 -0700
Message-Id: <20190605163746.178413-1-tkjos@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 33c6b9ca70a8b066a613e2a3d0331ae8f82aa31a.

The commit message is for a different patch. Reverting and then adding
the same patch back with the correct commit message.

Cc: stable <stable@vger.kernel.org> # 4.14
Signed-off-by: Todd Kjos <tkjos@google.com>
---
 drivers/android/binder_alloc.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index e0b0399ff7ec8..b9281f2725a6a 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -945,13 +945,14 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 
 	index = page - alloc->pages;
 	page_addr = (uintptr_t)alloc->buffer + index * PAGE_SIZE;
-
-	mm = alloc->vma_vm_mm;
-	if (!mmget_not_zero(mm))
-		goto err_mmget;
-	if (!down_write_trylock(&mm->mmap_sem))
-		goto err_down_write_mmap_sem_failed;
 	vma = binder_alloc_get_vma(alloc);
+	if (vma) {
+		if (!mmget_not_zero(alloc->vma_vm_mm))
+			goto err_mmget;
+		mm = alloc->vma_vm_mm;
+		if (!down_write_trylock(&mm->mmap_sem))
+			goto err_down_write_mmap_sem_failed;
+	}
 
 	list_lru_isolate(lru, item);
 	spin_unlock(lock);
@@ -964,9 +965,10 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 			       PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
+
+		up_write(&mm->mmap_sem);
+		mmput(mm);
 	}
-	up_write(&mm->mmap_sem);
-	mmput(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
 
-- 
2.22.0.rc1.311.g5d7573a151-goog

