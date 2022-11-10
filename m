Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5086A624569
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 16:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiKJPSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 10:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiKJPSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 10:18:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A181FCED
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 07:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668093428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ff4uIKDwEIX1/MsTGENOmYM+Xv3Uc0BmHEC53Fnq3vY=;
        b=cOuv3RLAxaFsMmREF/kybouKR8goDi+OUvGXNAJvH/nzfaK8kTTZ74xPedRNWnm5I+teuR
        8+LAzb6wBAjyvEzhos6pyEoryWqiwPmMB5clAH249cQH3LLPtywesuquoS5YXY05SUQL6I
        YHU17qBj15/lDEHRHzxNSnIbfkjeccQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-81-WECmhyZbNCCFyi9rU98_wg-1; Thu, 10 Nov 2022 10:17:07 -0500
X-MC-Unique: WECmhyZbNCCFyi9rU98_wg-1
Received: by mail-qv1-f71.google.com with SMTP id d8-20020a0cfe88000000b004bb65193fdcso1663297qvs.12
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 07:17:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ff4uIKDwEIX1/MsTGENOmYM+Xv3Uc0BmHEC53Fnq3vY=;
        b=2rMKyTu4RDN5aH7ZJLesaqpZuBYukAibiYRoV77Uim1oaX01jzaYSEfeBjWy6frN0O
         IYpr3tuw6EIa6H/dvG5z1L5Oee9poQlkhEbDgmD9X9zn05XCykAjKROl68gtbsNe5Kz/
         L8ZSzxgYtwRW6B8NoQJz6h3l9YJVGaQ8J277aOJhuU+f61/fNr5Ax7XTN8B+vAJaaawl
         CeqBC87XWt+dU5k25QHjGBxijHd23/QtDgJz52xfoeqhgBR5soR3IuLhEF6G9uy2XjUS
         /lW5PgoyGIvoZ1red4xz2x0VwBsoMR+pVtJU32QcDW1Ai3mzqcTTowqMJnO1qywcCBlg
         uWkg==
X-Gm-Message-State: ACrzQf0UmZiMqKDmNCE42Zs0pIAh3rM9tbfoh3Qq6hZfhtLEFk0kpmKn
        0XFjmkqD0tbI2UMaWGrBHSxcplHziCAdeUGRnl2sqDfKx6OINt/7hy9+PkI88DYOWQxGFII00sX
        tBwJ2M4UcrK8reejB
X-Received: by 2002:ac8:688b:0:b0:3a5:4032:84 with SMTP id m11-20020ac8688b000000b003a540320084mr38891961qtq.594.1668093426512;
        Thu, 10 Nov 2022 07:17:06 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6tpasQ30d/7Z7xCvuxHK3YLAF5URmUDDJQLgiiIm9IreU3H5TqEwrf6XMfeWsh8URcfVsH1A==
X-Received: by 2002:ac8:688b:0:b0:3a5:4032:84 with SMTP id m11-20020ac8688b000000b003a540320084mr38891929qtq.594.1668093426204;
        Thu, 10 Nov 2022 07:17:06 -0800 (PST)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id l19-20020a05620a28d300b006ec771d8f89sm13621596qkp.112.2022.11.10.07.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 07:17:05 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Mike Rapoport <rppt@linux.vnet.ibm.com>, peterx@redhat.com,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>, stable@vger.kernel.org
Subject: [PATCH 1/2] mm/migrate: Fix read-only page got writable when recover pte
Date:   Thu, 10 Nov 2022 10:17:01 -0500
Message-Id: <20221110151702.1478763-2-peterx@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221110151702.1478763-1-peterx@redhat.com>
References: <20221110151702.1478763-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ives van Hoorne from codesandbox.io reported an issue regarding possible
data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
sympton is some read page got data mismatch from the snapshot child VMs.

Here I can also reproduce with a Rust reproducer that was provided by Ives
that keeps taking snapshot of a 256MB VM, on a 32G system when I initiate
80 instances I can trigger the issues in ten minutes.

It turns out that we got some pages write-through even if uffd-wp is
applied to the pte.

The problem is, when removing migration entries, we didn't really worry
about write bit as long as we know it's not a write migration entry.  That
may not be true, for some memory types (e.g. writable shmem) mk_pte can
return a pte with write bit set, then to recover the migration entry to its
original state we need to explicit wr-protect the pte or it'll has the
write bit set if it's a read migration entry.

For uffd it can cause write-through.  I didn't verify, but I think it'll be
the same for mprotect()ed pages and after migration we can miss the sigbus
instead.

The relevant code on uffd was introduced in the anon support, which is
commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
2020-04-07).  However anon shouldn't suffer from this problem because anon
should already have the write bit cleared always, so that may not be a
proper Fixes target.  To satisfy the need on the backport, I'm attaching
the Fixes tag to the uffd-wp shmem support.  Since no one had issue with
mprotect, so I assume that's also the kernel version we should start to
backport for stable, and we shouldn't need to worry before that.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: stable@vger.kernel.org
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Reported-by: Ives van Hoorne <ives@codesandbox.io>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/migrate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index dff333593a8a..8b6351c08c78 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -213,8 +213,14 @@ static bool remove_migration_pte(struct folio *folio,
 			pte = pte_mkdirty(pte);
 		if (is_writable_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
-		else if (pte_swp_uffd_wp(*pvmw.pte))
+		else
+			/* NOTE: mk_pte can have write bit set */
+			pte = pte_wrprotect(pte);
+
+		if (pte_swp_uffd_wp(*pvmw.pte)) {
+			WARN_ON_ONCE(pte_write(pte));
 			pte = pte_mkuffd_wp(pte);
+		}
 
 		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
-- 
2.37.3

