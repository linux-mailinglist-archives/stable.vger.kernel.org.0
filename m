Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D116273AD
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 01:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiKNAFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Nov 2022 19:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235430AbiKNAFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Nov 2022 19:05:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA5AD128
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 16:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668384293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/uqXcWNCa1p19zapYQ5e7dpPK5NM6V2qbPw5ZdKILA=;
        b=VCcfQZabfHrzrM/jtpQ5dyInD7YpWIN1QynGU1eie023bo7vmFn2x1ms+47pfqv2NaSQYQ
        xo+I77aK4B2+JxE2VFGBOPoM4BZA7PEwISd8wo+NCdyEBpzITv7NJrjX3Yp2wXd8N5oINT
        sR3lYVJsBkzLsCo4H2nFOau5dKCywD0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-465-2j0viuPvPOylW7BiW59tlg-1; Sun, 13 Nov 2022 19:04:51 -0500
X-MC-Unique: 2j0viuPvPOylW7BiW59tlg-1
Received: by mail-qk1-f198.google.com with SMTP id bm2-20020a05620a198200b006fa6eeee4a9so9895992qkb.14
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 16:04:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E/uqXcWNCa1p19zapYQ5e7dpPK5NM6V2qbPw5ZdKILA=;
        b=k8FZgCf+NhEW4AHh2xlwB/8azgaVfQbAD2D+xgQB82jGDHrylwd8XZUZ3z9SmtwB63
         DMDI7AD0zyI3N33hz6JDoJJtsCazwhVAnXTkRXPMOYIEESfT7OfRVixA/ioWQCwTH/Ox
         PuG3PlR4JU4PTCwtfBCipuKYLfniWPOV82BSoyQ0u9UGwxNeA6b9xAbJxy+CLZ0IVAm9
         5Lc4V0mkMAw8+cLm4eaU7nZnL3tiuu15y7NnMPlh8hY4jH5pSI2if1arvlpzmOSy4vIy
         kxbxEYP7wOEk2A0e1iBcFFfGhRUAtCAdPy0MXMdtRo+/4yj10VE788dJtGyE+kDlL/1R
         11pw==
X-Gm-Message-State: ANoB5pn6ELdjx1nFYbyiM9HhyZysjYLWtFMuFdsgb0nKpJKHgMTKBzzs
        FCqXyEm/CzTs3ZPWwujijEST8T9h1jC9pr+NbIF+fcSuI/V6FHDSabH3dO1Zs396WhkVc0oL4lz
        4sGUAaDI5EL1Kgn1L
X-Received: by 2002:a05:622a:1c0f:b0:3a5:47c8:3889 with SMTP id bq15-20020a05622a1c0f00b003a547c83889mr10331809qtb.66.1668384291032;
        Sun, 13 Nov 2022 16:04:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5ZtobJluPZe3x25WvxetiEo/+Q4VROUb9doo/lcY8V74Jq3aR59GmxR6sHKMymg4q34UwP4A==
X-Received: by 2002:a05:622a:1c0f:b0:3a5:47c8:3889 with SMTP id bq15-20020a05622a1c0f00b003a547c83889mr10331790qtb.66.1668384290766;
        Sun, 13 Nov 2022 16:04:50 -0800 (PST)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id cb5-20020a05622a1f8500b0039cc0fbdb61sm4870380qtb.53.2022.11.13.16.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 16:04:50 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when recover pte
Date:   Sun, 13 Nov 2022 19:04:46 -0500
Message-Id: <20221114000447.1681003-2-peterx@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221114000447.1681003-1-peterx@redhat.com>
References: <20221114000447.1681003-1-peterx@redhat.com>
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
symptom is some read page got data mismatch from the snapshot child VMs.

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
write bit set if it's a read migration entry.  For uffd it can cause
write-through.

The relevant code on uffd was introduced in the anon support, which is
commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
2020-04-07).  However anon shouldn't suffer from this problem because anon
should already have the write bit cleared always, so that may not be a
proper Fixes target, while I'm adding the Fixes to be uffd shmem support.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: stable@vger.kernel.org
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Reported-by: Ives van Hoorne <ives@codesandbox.io>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Ives van Hoorne <ives@codesandbox.io>
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

