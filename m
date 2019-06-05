Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A2736179
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfFEQik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:38:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39435 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbfFEQik (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 12:38:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so12695105pgc.6
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 09:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i1C7yYOD90UtWlVRzK+SnrdV63w1HaY5jWWLGX0CQSc=;
        b=m7lM2noOALRa1b2gJ7H/r9U9fRixMqyzzDC+RgHFvZWXhFvMEsnVGZJOP2TJoFMe07
         NpE2Y8ndhX/p9QitTD53rCg5AaURXT2IbFZE1yvg7EHR6tGMjStRydMG8jWat5IHFZc8
         SvXmDiWwkqmSV7fkONoZLaqr+j5/MmKrPz08R7tsUFWi5xNasVm+M3Zk2vKYUZYe4+b/
         uoXAkdLi4WxLGgcScAnBTdOOOUUjeQ/mUIfw1t3GoRn+3y2dOPBSpU+IkoMG7D03gb3d
         mNFMByqeFYPiVjocIdpKCqCMaODdbMkqZlL49xjBXE10nNOqjZl15yVLxwwfrrOZ3Kir
         EqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i1C7yYOD90UtWlVRzK+SnrdV63w1HaY5jWWLGX0CQSc=;
        b=jy0dZxkOEVUWnX4Zm4ipvMnBJGs8jRrnCEoq5fK9JBOxUJUwAdv88cgVR7JEbx4uRr
         qZaevLCX5lc4Naa6e3iImUVFaovhYNaXF+534aQCHLNa5HT9hlCopWu62ODk3wyi/KiU
         mARuzTEnDcPwKOtuydYpwVOb6j/PuSxDpgz4+kEfB/wpll4zpd/v7MEVXsZopOqXCgKi
         vEs8t5Y714L0D9GilsZA0ISG/GxQby3x1np1ywTClkHN9sekw0Lhsx+0m7JZMnA/s+qd
         GkLwQYCHXNdxZynOpbf2xfwDRAKrnUXoR+MeeQHo+fYL4klZXBrqkb+KUL9hmaxbfu00
         WrKQ==
X-Gm-Message-State: APjAAAUpB0rkD8n4XMrYtTv7+YjaB8FTdtuFZNwM9yqLGroVBVF60gFd
        aGZ6Kdf0nk1qE+q312kLZhfxaQ==
X-Google-Smtp-Source: APXvYqxHgRVZpOI4caXC1w29UhHiPlg2xvGt3M8nZDd++z+IFmDmR7C6fef8+KR6OwRtenFYdzWvPw==
X-Received: by 2002:a17:90a:778c:: with SMTP id v12mr43425895pjk.141.1559752719839;
        Wed, 05 Jun 2019 09:38:39 -0700 (PDT)
Received: from ava-linux2.mtv.corp.google.com ([2620:0:1000:1601:6cc0:d41d:b970:fd7])
        by smtp.googlemail.com with ESMTPSA id h19sm2761912pfn.79.2019.06.05.09.38.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 09:38:39 -0700 (PDT)
From:   Todd Kjos <tkjos@android.com>
X-Google-Original-From: Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     ben.hutchings@codethink.co.uk, Alexander.Levin@microsoft.com
Subject: [PATCH 4.19 1/2] Revert "binder: fix handling of misaligned binder object"
Date:   Wed,  5 Jun 2019 09:38:24 -0700
Message-Id: <20190605163825.178537-1-tkjos@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 6bf7d3c5c0c5dad650bfc4345ed553c18b69d59e.

The commit message is for a different patch. Reverting and then adding
the same patch back with the correct commit message.

Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Todd Kjos <tkjos@google.com>
---
 drivers/android/binder_alloc.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index a654ccfd1a222..030c98f35cca7 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -958,13 +958,14 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 
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
@@ -977,9 +978,10 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
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

