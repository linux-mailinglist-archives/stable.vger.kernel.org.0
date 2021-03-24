Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94C63483E6
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 22:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbhCXVmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 17:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238602AbhCXVmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 17:42:19 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BC5C06174A
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 14:42:18 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id cx5so138701qvb.10
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 14:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=var+X4oeJAq/dyaBeLKX5IV4VdBFa//T4RsEnNBLVz4=;
        b=fJGUfvS2F1IkkBWqZmx2j0nhKToDlGCXZd1QTon8YAUelzNlz9H65YEX/sFM6OULkY
         JwuS71VUzH8+q7reL9RQiO6XQWMNM2CkvbgsUej9D/ZgoLxTfbCDG+wSaod2uUQ/G/gJ
         emBVWNIIwxf3b+YeD6hyNLpJ1osuhZFXTaUGKbzwucRKhCQbjnXe7pCtMdLtuwSOtz1P
         dYfppfW4sx30CpHhF1WtFnf4e+ifFat8z7e2h5GbiEUlQaWggOxvSGTfnsNC/9Pbs4ZU
         2fagZi0x9QBFy21bG66hjqBoPZ5C+0rXWyV6i87lEsiFvJpoOhLYgJWChLy12LTlVWz5
         zWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=var+X4oeJAq/dyaBeLKX5IV4VdBFa//T4RsEnNBLVz4=;
        b=km8G9x+4sJAmaK8vprPRBuvkBUhq+rhB6Uw5gvdhNx0Fv7d+2u2qAMtn5VYXH/4+1B
         hlgmKXYjwL8nSAXROexfQz7swlN6zLFPk7zR02RdxQ1vhDo5RNM5wR1q0Hs+L1lLgRp/
         z8KRF5PKKCTLimXfGbRR6c71rTOt0Y8bSqNX5Iuny2IBqJKA7FYLFoHEi8JQLv8HGHv7
         NGhPtn15vGuSUPhDYI4bus07MHakXgQ4WH57tLAzypLcwZz3SI2Jy56mjnlzZRx50kCk
         HT6O6koRn+cfE9PZPLl1qZOa/knONzGJ4Kh1XfuMWD+PC2auEsCbySAtk1dhpotKbFaV
         8qjw==
X-Gm-Message-State: AOAM532QxTnmlQAZzixXYCJSF28Ofo/8sC2g1wViQq4S4MfPAhbQSMQw
        beU6bA+trD9jEoIoyDosRs2szw==
X-Google-Smtp-Source: ABdhPJwkT+R9GY7X4LA+c8SCFHEHVBUTD+bvyw6pPotEhxcw8qiYGXXh///n08Bo4NNwDTmS69YHbQ==
X-Received: by 2002:ad4:4bce:: with SMTP id l14mr5045833qvw.30.1616622137857;
        Wed, 24 Mar 2021 14:42:17 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id t188sm2727266qke.91.2021.03.24.14.42.15
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 24 Mar 2021 14:42:17 -0700 (PDT)
Date:   Wed, 24 Mar 2021 14:42:14 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     gregkh@linuxfoundation.org
cc:     zhouguanghui1@huawei.com, akpm@linux-foundation.org,
        chenweilong@huawei.com, dingtianhong@huawei.com,
        guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        npiggin@gmail.com, rui.xiang@huawei.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, ziy@nvidia.com, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm/memcg: set memcg when splitting page"
 failed to apply to 5.10-stable tree
In-Reply-To: <1615807028190165@kroah.com>
Message-ID: <alpine.LSU.2.11.2103241438220.8948@eggly.anvils>
References: <1615807028190165@kroah.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

That's odd, I think what I'm sending here is the same as what you
had originally: maybe it was a build issue - if this one goes before
the other then its build would break, because it assumes the rename.

Hugh

------------------ original commit in Linus's tree ------------------

From e1baddf8475b06cc56f4bafecf9a32a124343d9f Mon Sep 17 00:00:00 2001
From: Zhou Guanghui <zhouguanghui1@huawei.com>
Date: Fri, 12 Mar 2021 21:08:33 -0800
Subject: [PATCH 2/2] mm/memcg: set memcg when splitting page

As described in the split_page() comment, for the non-compound high order
page, the sub-pages must be freed individually.  If the memcg of the first
page is valid, the tail pages cannot be uncharged when be freed.

For example, when alloc_pages_exact is used to allocate 1MB continuous
physical memory, 2MB is charged(kmemcg is enabled and __GFP_ACCOUNT is
set).  When make_alloc_exact free the unused 1MB and free_pages_exact free
the applied 1MB, actually, only 4KB(one page) is uncharged.

Therefore, the memcg of the tail page needs to be set when splitting a
page.

Michel:

There are at least two explicit users of __GFP_ACCOUNT with
alloc_exact_pages added recently.  See 7efe8ef274024 ("KVM: arm64:
Allocate stage-2 pgd pages with GFP_KERNEL_ACCOUNT") and c419621873713
("KVM: s390: Add memcg accounting to KVM allocations"), so this is not
just a theoretical issue.

Link: https://lkml.kernel.org/r/20210304074053.65527-3-zhouguanghui1@huawei.com
Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Tianhong Ding <dingtianhong@huawei.com>
Cc: Weilong Chen <chenweilong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 690f79c781cf..7ffa706e5c30 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3272,6 +3272,7 @@ void split_page(struct page *page, unsigned int order)
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
+	split_page_memcg(page, 1 << order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
-- 
2.31.0.291.g576ba9dcdaf-goog

