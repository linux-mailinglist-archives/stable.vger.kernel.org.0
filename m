Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3457764CF75
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 19:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbiLNSbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 13:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbiLNSbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 13:31:37 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D6B9A
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 10:31:36 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 9B936320092C;
        Wed, 14 Dec 2022 13:31:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Dec 2022 13:31:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1671042692; x=1671129092; bh=wVm9uamnkV
        JXkEy6ZwTOqTXRRiflD4pBUnOU+budYIk=; b=ZM1PrdpMOvpXqLe3SobExmaby9
        PqawKhWQP/GpFvwBZNLPZiZAXZQh+jjXte64SIfS0ENds84eTcC93kPPelGUlu5o
        KZQhicS9d9OwqRRmyUG2+kVjH48Noot3MHlIF80gfZ/9nbeK4pogvr4XzXOu2Kok
        jRL18ekLHrEI1RZj2jXGbqtkShg5Vads3wCDPCS3BtPx6fPvi/FdnmJeBtGG0tgv
        JPdKC08VnVO5wCMr/2ZJvV4NLFgO5eEvX1GRKFwoTYaKoCHVmtXEoh43slab4DRD
        UpBgiTmVp+4hUVxoN2B1yGYcUornjbMJZpNp2/tG1CdMEuRfrLWaeD5Wrvgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671042692; x=1671129092; bh=wVm9uamnkVJXkEy6ZwTOqTXRRifl
        D4pBUnOU+budYIk=; b=acQt3438x5lYFNxBglqH13T6gHKPd1bVdV/gX1ZALC8r
        e4MmKvdANS8YP9C7zGOG6b8bYUPN0D6CdI75dgYzCP2e4bt672FfL/ICynZYt5O2
        cGm2AuooIV/Rz9LSdNVjBiAyCUhRMoParJvtLHeLfz+ZW2htgwLcHHhNAPlrUEL6
        OnbZWa1FHNrSnf11uq6IfDUL4+7bJK8NVfFpQ6x5RNGMFcOcg9oCdgcSSVqqIMc/
        AmlCW3oUrb54roP3kC/yuQCCuzjeJ3o7LShPxEx76tHmSPrlXQeHjz24xfamnvnh
        GzbNmARmvpBa5MLJH3lqj87jS1AemkJ2jQktn4mYNg==
X-ME-Sender: <xms:gxaaY9pvPf8exJJfVjuRHaInAzIjv9q4Lmdcvrw_lnYOKm5XKHI2MQ>
    <xme:gxaaY_qXlFBlAp_FEexWVIPO4fAJqiAGvxdKaipheJmboEd_Qv8wsKLQMflnCELuW
    -An2eeg_QMcdQ>
X-ME-Received: <xmr:gxaaY6Opp61SonzRKZpC4UCNdM-NZQ1llfd_FPVjhUQP5vFozAmg1AOs66AaDie0CCx3P-DJqRmgLoNB8wK_z6ddG2Z_rAp1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeefgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gxaaY44Y85Pc1-91t9QacNlrySPoqVIv0k773oO6E8cWwakP_tcscQ>
    <xmx:gxaaY87MvGkywrn8UU1XBeNHiZOpk69INcnLOzW01I5x6q2r__qvJw>
    <xmx:gxaaYwjkMpiHzES0elJ85LnCDUBRvRohIXxA4VuGoQ8cvVasQzvjGA>
    <xmx:hBaaY4q9Z5sZxNyWFHjh_kpzj8QeX-UgTfml_pL5UD8mddFC01I4EQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Dec 2022 13:31:30 -0500 (EST)
Date:   Wed, 14 Dec 2022 19:31:28 +0100
From:   Greg KH <greg@kroah.com>
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>
Cc:     stable@vger.kernel.org, benh@amazon.com,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 v2] mm/hugetlb: fix races when looking up a
 CONT-PTE/PMD size hugetlb page
Message-ID: <Y5oWgLw6AiwTIq1f@kroah.com>
References: <20221214020609.832545-1-samjonas@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214020609.832545-1-samjonas@amazon.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 06:06:09PM -0800, Samuel Mendoza-Jonas wrote:
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
> Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> ---
> v2: Fix up stray out label that is now unused.

Now queued up, thanks.

greg k-h
