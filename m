Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98F06D82A8
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239140AbjDEPw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbjDEPwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:52:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2C76599
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 08:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680709884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dX5bBmfEsfxuoyfhYLC4nRt+vkdDVDFdF9t4fgBK6nc=;
        b=PRPjKAVx90wyO8giVwWrjThIbjjPz/PTx1A+ATSVS9SetOEfoXgBHJEoTb/XuoYZnTCuEj
        +WpFuKwTo178qoyGGidG3Nlc9K4MwhaMhzD3KCX2IRk8nF97olydd9OEVhPBReVw/cXWEd
        oMxLWwy2vlPVt5OkuPlWfvxFsLacEh8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-RBnBo2FqMRCX3G3xvdwTww-1; Wed, 05 Apr 2023 11:51:23 -0400
X-MC-Unique: RBnBo2FqMRCX3G3xvdwTww-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3e1522cf031so12260551cf.1
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 08:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680709882;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dX5bBmfEsfxuoyfhYLC4nRt+vkdDVDFdF9t4fgBK6nc=;
        b=lpM2nYTM4Nqfw3qOiM7w3anO1DAa5K4tXvMpkze759SE5LKsulJTm3amwLFxaK21HT
         kMKgMhXyO+mfKuwqWy3YqNIz218qAlaYRN/HePYnPbY1Ev/wMQT4ONPkd99Ud4qke13q
         1ueRHJvoBsQORhY0JAYqxGzOdNyn0Tq9J7e2zQbH+N7mduv3h2q+wCRTt+IgiZqSPdxT
         beAYjBZUl7JcSxuSk3fJCpvMbI7nTtBrd7Uoz3ASJTznx0BHgBW1xasaXYxvR+FG9JKq
         X62ld7TCTNNJnWET1qvXNyFEh3AWRZ6YfPjzF3HGC4S6raE5XL68OkXT9Fqe2Zdkkoy3
         u0Sw==
X-Gm-Message-State: AAQBX9eQH0sGXzslMdzvHEje2kpm7trc8QmK/BRTfzWIvA8Vb153BqE7
        OU6DFbKzt3cKmoA4BksFCjvNCtTwlRjP0KC5QD6+RdruGb6v1oGG2i4UpqVaKJW22kqaCglovjg
        Ad6b/yliORIIRj5Mp
X-Received: by 2002:a05:622a:1a24:b0:3e6:707e:d3c2 with SMTP id f36-20020a05622a1a2400b003e6707ed3c2mr6579971qtb.0.1680709882538;
        Wed, 05 Apr 2023 08:51:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350aQwlmz/B2rFUoV+ynxi7aLMiwTeZZ+VAdvhVh5mZQhiM9KEBDhUFK1/5/JAnwKKQvIr4jnNQ==
X-Received: by 2002:a05:622a:1a24:b0:3e6:707e:d3c2 with SMTP id f36-20020a05622a1a2400b003e6707ed3c2mr6579938qtb.0.1680709882192;
        Wed, 05 Apr 2023 08:51:22 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id 21-20020a370415000000b0074683c45f6csm4538557qke.1.2023.04.05.08.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:51:21 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Yang Shi <shy828301@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH] mm/khugepaged: Check again on anon uffd-wp during isolation
Date:   Wed,  5 Apr 2023 11:51:20 -0400
Message-Id: <20230405155120.3608140-1-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Khugepaged collapse an anonymous thp in two rounds of scans.  The 2nd round
done in __collapse_huge_page_isolate() after hpage_collapse_scan_pmd(),
during which all the locks will be released temporarily. It means the
pgtable can change during this phase before 2nd round starts.

It's logically possible some ptes got wr-protected during this phase, and
we can errornously collapse a thp without noticing some ptes are
wr-protected by userfault.  e1e267c7928f wanted to avoid it but it only did
that for the 1st phase, not the 2nd phase.

Since __collapse_huge_page_isolate() happens after a round of small page
swapins, we don't need to worry on any !present ptes - if it existed
khugepaged will already bail out.  So we only need to check present ptes
with uffd-wp bit set there.

This is something I found only but never had a reproducer, I thought it was
one caused a bug in Muhammad's recent pagemap new ioctl work, but it turns
out it's not the cause of that but an userspace bug.  However this seems to
still be a real bug even with a very small race window, still worth to have
it fixed and copy stable.

Cc: linux-stable <stable@vger.kernel.org>
Fixes: e1e267c7928f ("khugepaged: skip collapse if uffd-wp detected")
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/khugepaged.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a19aa140fd52..42ac93b4bd87 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -575,6 +575,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
 		}
+		if (pte_uffd_wp(pteval)) {
+			result = SCAN_PTE_UFFD_WP;
+			goto out;
+		}
 		page = vm_normal_page(vma, address, pteval);
 		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
-- 
2.39.1

