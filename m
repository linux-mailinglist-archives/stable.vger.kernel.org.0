Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B09659EED6
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 00:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiHWWNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 18:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiHWWN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 18:13:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9697E8B2F3
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661292703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SqSTkWZMCrwSwsjSNzpe+ypA/kUjJyLN2b7ZHvSho3U=;
        b=ZYq5eHgtkXVWUfqLkxdvxYOhX0pdJUhF3FbQBYU271n4uQpzK4ZxJIT70xogtuZpKVRiWV
        Ffq0mUfZW62EVbPFAPjfBTKNQXs6Z9xD3jjiyNdRMvh4PgqoTaSGw/0uDcYsu+VWef6Qef
        IATxQ0iTnEB2GBF8gTcRaalKHjErFb4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-386-hsZexelYO76K9DtGOIvWHg-1; Tue, 23 Aug 2022 18:11:42 -0400
X-MC-Unique: hsZexelYO76K9DtGOIvWHg-1
Received: by mail-qk1-f197.google.com with SMTP id m19-20020a05620a24d300b006bb85a44e96so13392599qkn.23
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=SqSTkWZMCrwSwsjSNzpe+ypA/kUjJyLN2b7ZHvSho3U=;
        b=56ylIT58LfDidWcilUZJn/zufEQ1qPwLZuhq6B9Rp7iWivJmunB1Zrg7wmgyjkVwEC
         oHu2hBp93E67VenIjYtaJzIPD6d26FA/S+DxofrRrNKXHg22yBa1yXqVYwzcqhNO5m2N
         4mEapMNpoUdeaXNLTAOVVDpCjvms6+/R6U3KBZ5FJ9ehfqL1FUpc8p2+ax2NNJWzSo27
         rCpkNJy0jDfNsW/3kMlap5oro6NS5/zsdCDzo77bnckwAF3UzGy0VEGJtpCKmnilUvD9
         1G8WqXNILgaw5B0xP/qj6wZ8L2KcS8fq87d/6RM1gAbx5wsumT18eiJY6lDdaGtvOkHM
         ggZQ==
X-Gm-Message-State: ACgBeo1gQ6E1ZqAEdjWkQafjmiDO20FEXzkbvinZ2x8M+IQkHtbOXWN1
        X+7CzlDF/1LynRMOPegQmtQHkexgQ81B0uLo3FzH27yaBtJSE/7MlFVXGcqxf/rnis/hNfjcip/
        6wECtkwJkzNtAyHzI
X-Received: by 2002:ac8:58c8:0:b0:344:87c2:c495 with SMTP id u8-20020ac858c8000000b0034487c2c495mr21306104qta.631.1661292701314;
        Tue, 23 Aug 2022 15:11:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4lLdPjmsXBhe8LEZIi5nM1ZsA7umBVsvW+i6mZX+KoZuDvOiaboMlLZWVcvCAfdLMqUwSvCg==
X-Received: by 2002:ac8:58c8:0:b0:344:87c2:c495 with SMTP id u8-20020ac858c8000000b0034487c2c495mr21306082qta.631.1661292700932;
        Tue, 23 Aug 2022 15:11:40 -0700 (PDT)
Received: from localhost.localdomain (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id s11-20020a05620a29cb00b006bbd0ae9c05sm12319185qkp.130.2022.08.23.15.11.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Aug 2022 15:11:40 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, peterx@redhat.com,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
Subject: [PATCH] mm/mprotect: Only reference swap pfn page if type match
Date:   Tue, 23 Aug 2022 18:11:38 -0400
Message-Id: <20220823221138.45602-1-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yu Zhao reported a bug after the commit "mm/swap: Add swp_offset_pfn() to
fetch PFN from swap entry" added a check in swp_offset_pfn() for swap type [1]:

  kernel BUG at include/linux/swapops.h:117!
  CPU: 46 PID: 5245 Comm: EventManager_De Tainted: G S         O L 6.0.0-dbg-DEV #2
  RIP: 0010:pfn_swap_entry_to_page+0x72/0xf0
  Code: c6 48 8b 36 48 83 fe ff 74 53 48 01 d1 48 83 c1 08 48 8b 09 f6
  c1 01 75 7b 66 90 48 89 c1 48 8b 09 f6 c1 01 74 74 5d c3 eb 9e <0f> 0b
  48 ba ff ff ff ff 03 00 00 00 eb ae a9 ff 0f 00 00 75 13 48
  RSP: 0018:ffffa59e73fabb80 EFLAGS: 00010282
  RAX: 00000000ffffffe8 RBX: 0c00000000000000 RCX: ffffcd5440000000
  RDX: 1ffffffffff7a80a RSI: 0000000000000000 RDI: 0c0000000000042b
  RBP: ffffa59e73fabb80 R08: ffff9965ca6e8bb8 R09: 0000000000000000
  R10: ffffffffa5a2f62d R11: 0000030b372e9fff R12: ffff997b79db5738
  R13: 000000000000042b R14: 0c0000000000042b R15: 1ffffffffff7a80a
  FS:  00007f549d1bb700(0000) GS:ffff99d3cf680000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000440d035b3180 CR3: 0000002243176004 CR4: 00000000003706e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   change_pte_range+0x36e/0x880
   change_p4d_range+0x2e8/0x670
   change_protection_range+0x14e/0x2c0
   mprotect_fixup+0x1ee/0x330
   do_mprotect_pkey+0x34c/0x440
   __x64_sys_mprotect+0x1d/0x30

It triggers because pfn_swap_entry_to_page() could be called upon e.g. a
genuine swap entry.

Fix it by only calling it when it's a write migration entry where the page*
is used.

[1] https://lore.kernel.org/lkml/CAOUHufaVC2Za-p8m0aiHw6YkheDcrO-C3wRGixwDS32VTS+k1w@mail.gmail.com/

Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/mprotect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index f2b9b1da9083..4549f5945ebe 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -203,10 +203,11 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
 			pages++;
 		} else if (is_swap_pte(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
-			struct page *page = pfn_swap_entry_to_page(entry);
 			pte_t newpte;
 
 			if (is_writable_migration_entry(entry)) {
+				struct page *page = pfn_swap_entry_to_page(entry);
+
 				/*
 				 * A protection check is difficult so
 				 * just be safe and disable write
-- 
2.32.0

