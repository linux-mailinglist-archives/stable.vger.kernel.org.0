Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B6033B0D0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 12:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhCOLRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 07:17:16 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51935 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230115AbhCOLRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 07:17:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2D3181940889;
        Mon, 15 Mar 2021 07:17:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 07:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cJZNly
        H/dqmGiaOj6BIaxfSw9HV9cbpIIhuDPD6ZZ1c=; b=OiEYrU/OwOxtX5HuT4yota
        3JWZhcOq36pAkCEcXl37CIA5abRnVZMHQh/1uM4ofBn/jKy1wvOBm77Dhyumpph3
        nsmv7Bf7QKOjXfYoRtLQIWNfJUKUIS9sgQeqL3GMmopfoDCB0iOlRvAowGydXbmn
        7cJlJDMM6ZFzHed13OcZwDbPmP/O5Q9BUXPOLNbjcZbeGh1Aua5uq/yzvqA2uIwK
        mgFuOMyOjeVOrcWvpY7teybRC8jong3916rzBAZzF74Ln4MYMM4/Yb5ikAAPVyfA
        iklLWSBme45qrei1Hq9QyGEEmMFYQQDOGryKyJBlWhkfwCieYaSWJfYWT+nwnWYA
        ==
X-ME-Sender: <xms:NkJPYEXQtL84DYRzOBar1JJn83Sm5tRxH3lilWtww4k95fuZw55BDg>
    <xme:NkJPYInHrDDx1vmV2LrhE0ib-BkKmyxqiO-V-SJB8UOE-O-XQbcncS9_b68H-mt_a
    qxwfKQAHhnFJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvledgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NkJPYIZjgqwUzC0sTkiaJenOrX8xNmAUPOupwNO87FYrggNVXhqMMg>
    <xmx:NkJPYDUwWtGMpNaotqdnrR2S07jVWF7AbphTy58-E1xQN5glMlntEA>
    <xmx:NkJPYOno1c0pza7uuNL3VQ60wrZvsA3NhggBOuAFt2Y3M_XYd2jSww>
    <xmx:OEJPYEnJHqPnT080mGPOpr4eql5zQJ1rVY4zzGYXByKw4LOvtHi2thsgPzw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7968C1080063;
        Mon, 15 Mar 2021 07:17:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/memcg: set memcg when splitting page" failed to apply to 5.10-stable tree
To:     zhouguanghui1@huawei.com, akpm@linux-foundation.org,
        chenweilong@huawei.com, dingtianhong@huawei.com,
        guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        npiggin@gmail.com, rui.xiang@huawei.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, ziy@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 12:17:08 +0100
Message-ID: <1615807028190165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e1baddf8475b06cc56f4bafecf9a32a124343d9f Mon Sep 17 00:00:00 2001
From: Zhou Guanghui <zhouguanghui1@huawei.com>
Date: Fri, 12 Mar 2021 21:08:33 -0800
Subject: [PATCH] mm/memcg: set memcg when splitting page

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

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3cd1c0ce4d06..cfc72873961d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3314,6 +3314,7 @@ void split_page(struct page *page, unsigned int order)
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
+	split_page_memcg(page, 1 << order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 

