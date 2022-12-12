Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF67A6499A7
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 08:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiLLHkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 02:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiLLHkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 02:40:14 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C5595A6
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 23:40:12 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9C87C5C00B5;
        Mon, 12 Dec 2022 02:40:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 12 Dec 2022 02:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1670830810; x=1670917210; bh=0UWImDyqEu
        kfmnqK12iG95+8KQnKzn9EEOhaJafded8=; b=CTUbDV/c4fvjKaVC20pjWWh3oH
        SB0E7NjjN1jXQT10vDdSP17W6+ezcXj5zswxMBlcWr6GBvpJvmNIe4WHu003Q30o
        WPEDtF86/00QgtE7w+iMMVPhquDUmkdG5A+9oahQ0zTYSqvWp8GMU9ifP0G4cTXr
        eiwSVRH/XIqWwXIkOqLS/EItZPAxWaZWLE7FZHneQo+gNFKJ8Vt/F3wgAkoBGNvs
        xDxQGgmDaE6TKRAoEAOQArpXQgInKgGApciWTGf1ELfBTWuqeLGziDGUCSPi1nFr
        W5wzUlWb1dwpcC+lSc7HB9bPVhr4oYp6I1huz7tOh9+EoruVt+n/6s2xXiSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1670830810; x=1670917210; bh=0UWImDyqEukfmnqK12iG95+8KQnK
        zn9EEOhaJafded8=; b=bEYOKqHIXVvRoj16FDg+vTbcAAt4u4oiFgN7KZXLrWOH
        /cWuSquPJ3b5hqxigaF4OGyI3F9bVC6qARvVuntP8vpf3hCZ+CXLFsCKb6WsGv46
        W887co6TSCS+MBxmDNnkS6ryswRqfuWFs61GMXI4E26kNyBJwzUzUxsZ/hSoASFj
        OT0BZXoBr6S79lOVnEu4SGKz96hOef6ZPlYicw50z3Sucntcpf/+wZy4DBV+VTmW
        W268X2fE3YNuPsCj0HcEEdMYQJnN0bW/63DDW/wi9fyc/GF1ki57RdBK0SRw11Rx
        7vy9pKwxc0yJvFac0PAdbLo8wYeMSGsvjjmW+7dNkA==
X-ME-Sender: <xms:2tqWY4gCQosiMHs5UMR0lviKWsyE78BTQtl18EWChFimMNeLRPWyRw>
    <xme:2tqWYxBgtyZajV84yv6-c48OKFYYfpcbtnPYk4fWsI3IsQ1-66haMIU_ltZ4XBYyW
    yF2WOGP8zcNaw>
X-ME-Received: <xmr:2tqWYwGfgqIft-rC2ifi60oGRfiTMbGMpJhiZP8cGwguPXxXDK1XcFQLUuF_JKImBDZe3t12hHEyTPgz937NC3jOJlg_qAvp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2tqWY5QFSETb7K9WHnlWpja4nt99y0OStwcYzDBW7B66OTuS5D9CxQ>
    <xmx:2tqWY1wcYYBfEiI8CY5EYBVf6ckaNaSD0EdSju8riKd_hy4FrhHdjw>
    <xmx:2tqWY35XilZhCNM4B_62mNuVpXgE2_pIT37td3v-_u7t5RLS4H6V6Q>
    <xmx:2tqWYyjEe-MFVVVTB4f679k2WGUVc1vKffHRZACEJpXWbyA4ps8f5A>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Dec 2022 02:40:09 -0500 (EST)
Date:   Mon, 12 Dec 2022 08:39:59 +0100
From:   Greg KH <greg@kroah.com>
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>
Cc:     stable@vger.kernel.org, benh@amazon.com,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4] mm/hugetlb: fix races when looking up a CONT-PTE/PMD
 size hugetlb page
Message-ID: <Y5baz/idF8HizSgs@kroah.com>
References: <20221212025148.367737-1-samjonas@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212025148.367737-1-samjonas@amazon.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 11, 2022 at 06:51:48PM -0800, Samuel Mendoza-Jonas wrote:
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> [ Upstream commit fac35ba763ed07ba93154c95ffc0c4a55023707f ]
> 
> On some architectures (like ARM64), it can support CONT-PTE/PMD size
> hugetlb, which means it can support not only PMD/PUD size hugetlb (2M and
> 1G), but also CONT-PTE/PMD size(64K and 32M) if a 4K page size specified.
> 
> So when looking up a CONT-PTE size hugetlb page by follow_page(), it will
> use pte_offset_map_lock() to get the pte entry lock for the CONT-PTE size
> hugetlb in follow_page_pte().  However this pte entry lock is incorrect
> for the CONT-PTE size hugetlb, since we should use huge_pte_lock() to get
> the correct lock, which is mm->page_table_lock.
> 
> That means the pte entry of the CONT-PTE size hugetlb under current pte
> lock is unstable in follow_page_pte(), we can continue to migrate or
> poison the pte entry of the CONT-PTE size hugetlb, which can cause some
> potential race issues, even though they are under the 'pte lock'.
> 
> For example, suppose thread A is trying to look up a CONT-PTE size hugetlb
> page by move_pages() syscall under the lock, however antoher thread B can
> migrate the CONT-PTE hugetlb page at the same time, which will cause
> thread A to get an incorrect page, if thread A also wants to do page
> migration, then data inconsistency error occurs.
> 
> Moreover we have the same issue for CONT-PMD size hugetlb in
> follow_huge_pmd().
> 
> To fix above issues, rename the follow_huge_pmd() as follow_huge_pmd_pte()
> to handle PMD and PTE level size hugetlb, which uses huge_pte_lock() to
> get the correct pte entry lock to make the pte entry stable.
> 
> Mike said:
> 
> Support for CONT_PMD/_PTE was added with bb9dd3df8ee9 ("arm64: hugetlb:
> refactor find_num_contig()").  Patch series "Support for contiguous pte
> hugepages", v4.  However, I do not believe these code paths were
> executed until migration support was added with 5480280d3f2d ("arm64/mm:
> enable HugeTLB migration for contiguous bit HugeTLB pages") I would go
> with 5480280d3f2d for the Fixes: targe.
> 
> Link: https://lkml.kernel.org/r/635f43bdd85ac2615a58405da82b4d33c6e5eb05.1662017562.git.baolin.wang@linux.alibaba.com
> Fixes: 5480280d3f2d ("arm64/mm: enable HugeTLB migration for contiguous bit HugeTLB pages")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> [5.4: Fixup contextual diffs before pin_user_pages()]

Thanks, both now queued up.

greg k-h
