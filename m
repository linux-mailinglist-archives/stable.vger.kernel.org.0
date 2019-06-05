Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C893617C
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfFEQjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:39:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42694 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbfFEQjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 12:39:41 -0400
Received: by mail-pg1-f195.google.com with SMTP id e6so11429568pgd.9
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 09:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LWknTKZMlyQxXFoCaQD1P8PyU8vSyqyqtaUwgzK2bx0=;
        b=T+C4SvCWlA3IpBDwv60Hmu4w3Iu4lgdVcrIN8tjI5M1+0KkJYtA7gj70AwY0hCVsOF
         vGZIeLgwiQGsWOvl/BLykXYaEzyQOlas5RoWeMejgKoZ30lagGATQ1jwevQxMQ0Bo9gp
         D2WTP5v2s0AdVCh+kALTklS416AsHNbiS7Ke6v6V2aPsgCG4TeXskOUfLxbx2kXi944o
         ZIEUsDJ326RMZpOitrQKBqq+gHUeaPYbIGN48dklOGZgI4FrCGVQEeLSScx5Nh+EmhQb
         jqQT7kDtNIrjerqzvMjcUqDezdcrn0tClFA2pg74Ha1bnqA21plyDjDE3sQ2JS+KamyR
         uywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LWknTKZMlyQxXFoCaQD1P8PyU8vSyqyqtaUwgzK2bx0=;
        b=Hfwi5Ms1ks9w3ajtyiPCsY3HSUVWFFRL1MkrD0dQEpE5uZYEWJ10Cn/F4B1zG/jaxx
         V/qErvriF/Jb8HyJKp6n41G2ImsmpPj0lm69fG7TxGTrU/tdVsdGTSw6SItHw2kgxrNr
         xGLo3Oq5Wdi1sCSfMXAx3gScf2p/p1F6uYzGVW96pwu+sW6H2kqq0xAF9kYzivpW1dW/
         lpb3JF9FDFqmfwlcFuZ5paIpqt2TbwJ86MuwVFMrW/3nBcWWJYaT3vCxzfZoq6YBq6jD
         8tmTg2o7PLoY17GEgyipJteerolQyFZXWZTVd1KYMX6d8czklPS9XsFzDoFgpot5SQCx
         uEMw==
X-Gm-Message-State: APjAAAV3qlXa21Ui538Xh9ac00rPQfRko2vw4Hi4rCtqrvsZqkV5wi+6
        ICI9ojggp4fq9zcaKqHJ5H8YPQ==
X-Google-Smtp-Source: APXvYqxjGRKqsvANTGiJEZIwBuvmKmUC4nu/gCN+Wy2z2x6jiQwuSWz5h/d4l304LMnezG1BoLI6Cg==
X-Received: by 2002:a63:2bd1:: with SMTP id r200mr5786865pgr.202.1559752780580;
        Wed, 05 Jun 2019 09:39:40 -0700 (PDT)
Received: from ava-linux2.mtv.corp.google.com ([2620:0:1000:1601:6cc0:d41d:b970:fd7])
        by smtp.googlemail.com with ESMTPSA id l63sm22493057pfl.181.2019.06.05.09.39.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 09:39:39 -0700 (PDT)
From:   Todd Kjos <tkjos@android.com>
X-Google-Original-From: Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     ben.hutchings@codethink.co.uk, Alexander.Levin@microsoft.com
Subject: [PATCH 5.0 1/2] Revert "binder: fix handling of misaligned binder object"
Date:   Wed,  5 Jun 2019 09:39:29 -0700
Message-Id: <20190605163930.178758-1-tkjos@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit bbb19ca082ce27ce60ca65be016a951806ea947c.

The commit message is for a different patch. Reverting and then adding
the same patch back with the correct commit message.

Cc: stable <stable@vger.kernel.org> # 5.0
Signed-off-by: Todd Kjos <tkjos@google.com>
---
 drivers/android/binder_alloc.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index a6e556bf62dff..022cd80e80cc3 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -959,13 +959,14 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 
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
@@ -978,9 +979,10 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
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

