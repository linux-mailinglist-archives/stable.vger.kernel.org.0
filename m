Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104D764B80C
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 16:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbiLMPHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 10:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiLMPHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 10:07:22 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B428B862
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 07:07:21 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0CCB33200909;
        Tue, 13 Dec 2022 10:07:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 13 Dec 2022 10:07:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1670944036; x=1671030436; bh=4JAhvF3Ldp
        A2dYzPBZMQWX6KTE8u69c0QSa5DnFrKu4=; b=s+W/0IO5E0OhH1HwkT1YDdr33X
        00Q+eRlsqCThn4Gnhh3lIhGHgoGxPRRpo7yrhLE9m4kDa8Kw0PxOFb03d3bsfXJB
        U9imXjecSspiwU5oXW5Vdh58+jKdkdhLOpwQZmDMIDbQJAnxrmpFsYiQKccWy6Ly
        LixUeX1OOLpHU8KwVuLIWZqFxnz1QlY+Hkfsh1un61KFufNDh01hv2JHTLFvRpzU
        j3xLNzWFbKUnEmdHqLKpLX5EO+ZmY9eserL2zFAAHlERkr9ccvaDxjDcSqCR0fOi
        ic80an/8GAsfv1IPr7Ea7OA5e+GIigyBTMdIyiHxtGMnmUb6LN1349HKu3CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1670944036; x=1671030436; bh=4JAhvF3LdpA2dYzPBZMQWX6KTE8u
        69c0QSa5DnFrKu4=; b=nBYWQu9Qo79boPZ0zBZO292iLTzcFXX2Lv1fpeNtqYBQ
        ODO/6wuKr6ByaEugzG+Wy0RNnvLvPbQ6D+XLiNJvnC0aehoPcAzKlzGZe1v5LY9p
        9Xdz6ExvKdzx4bwKN52pPxQbzlbugQiz9+3aNvdLDV2UdTLHjSK3r29y4VyPjdwf
        MLAuS7KOd71OkpzAtxcsQxmFZMLLeM+AirYuck4I7Zon9tz2zcpm8nqrLpDGgh2h
        L6c0V0NSJeUUL7gtxpD/eKqhb1XR/8Q1INBfpQzekbOZhOvPOS5t8WDXdoLm4gWE
        cK4DlSaOQ2NIIY5eW0dVLH07ryPViVC4AkyC7s5Nww==
X-ME-Sender: <xms:I5WYYwu8n9vIQWnmUx9frzwjiKzIlqx_w0y0TsKsEKUo0NghK-1T5A>
    <xme:I5WYY9cODzIfO-OfnPd01Y1yM3rwCbYofSvGXgeikVKEJL6DEaffDwLhqU6CaDco-
    GVgitIqBHu3gg>
X-ME-Received: <xmr:I5WYY7zTUu_YOw6EHjN9i2l7G64pYe809iTHsvmh7UV8lSKYB2jozHkXoPBVFzFR2M4OkTDZucehg5p72B7ldS7aZ7rHxpNG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:I5WYYzN7ss4Du1qR9_qyEmShBA3026NQW4k23JVb4jz4pBxWl9tbQA>
    <xmx:I5WYYw8L9mW3yF7mBdLOIUtLHP05wkk0F3gmJZvFS5k1YlQCT_RkRg>
    <xmx:I5WYY7XLbCzHqCHSLXfUGzBWos2UOmUmyHPXowRktZKFFOM8NaErpA>
    <xmx:JJWYYwMytGJAs-5ikguJit6Xw8MYRL7q7jHcIjxqDbyZuXaJuNfFlg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Dec 2022 10:07:14 -0500 (EST)
Date:   Tue, 13 Dec 2022 16:07:11 +0100
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
Message-ID: <Y5iVH1WwvP5K2UPf@kroah.com>
References: <20221212025148.367737-1-samjonas@amazon.com>
 <Y5baz/idF8HizSgs@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5baz/idF8HizSgs@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 08:39:59AM +0100, Greg KH wrote:
> On Sun, Dec 11, 2022 at 06:51:48PM -0800, Samuel Mendoza-Jonas wrote:
> > From: Baolin Wang <baolin.wang@linux.alibaba.com>
> > 
> > [ Upstream commit fac35ba763ed07ba93154c95ffc0c4a55023707f ]
> > 
> > On some architectures (like ARM64), it can support CONT-PTE/PMD size
> > hugetlb, which means it can support not only PMD/PUD size hugetlb (2M and
> > 1G), but also CONT-PTE/PMD size(64K and 32M) if a 4K page size specified.
> > 
> > So when looking up a CONT-PTE size hugetlb page by follow_page(), it will
> > use pte_offset_map_lock() to get the pte entry lock for the CONT-PTE size
> > hugetlb in follow_page_pte().  However this pte entry lock is incorrect
> > for the CONT-PTE size hugetlb, since we should use huge_pte_lock() to get
> > the correct lock, which is mm->page_table_lock.
> > 
> > That means the pte entry of the CONT-PTE size hugetlb under current pte
> > lock is unstable in follow_page_pte(), we can continue to migrate or
> > poison the pte entry of the CONT-PTE size hugetlb, which can cause some
> > potential race issues, even though they are under the 'pte lock'.
> > 
> > For example, suppose thread A is trying to look up a CONT-PTE size hugetlb
> > page by move_pages() syscall under the lock, however antoher thread B can
> > migrate the CONT-PTE hugetlb page at the same time, which will cause
> > thread A to get an incorrect page, if thread A also wants to do page
> > migration, then data inconsistency error occurs.
> > 
> > Moreover we have the same issue for CONT-PMD size hugetlb in
> > follow_huge_pmd().
> > 
> > To fix above issues, rename the follow_huge_pmd() as follow_huge_pmd_pte()
> > to handle PMD and PTE level size hugetlb, which uses huge_pte_lock() to
> > get the correct pte entry lock to make the pte entry stable.
> > 
> > Mike said:
> > 
> > Support for CONT_PMD/_PTE was added with bb9dd3df8ee9 ("arm64: hugetlb:
> > refactor find_num_contig()").  Patch series "Support for contiguous pte
> > hugepages", v4.  However, I do not believe these code paths were
> > executed until migration support was added with 5480280d3f2d ("arm64/mm:
> > enable HugeTLB migration for contiguous bit HugeTLB pages") I would go
> > with 5480280d3f2d for the Fixes: targe.
> > 
> > Link: https://lkml.kernel.org/r/635f43bdd85ac2615a58405da82b4d33c6e5eb05.1662017562.git.baolin.wang@linux.alibaba.com
> > Fixes: 5480280d3f2d ("arm64/mm: enable HugeTLB migration for contiguous bit HugeTLB pages")
> > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
> > Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Muchun Song <songmuchun@bytedance.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > [5.4: Fixup contextual diffs before pin_user_pages()]
> 
> Thanks, both now queued up.

I'm dropping this one now as it adds a build warning as reported here:
	https://lore.kernel.org/r/CA+G9fYtdgLx0hrtGk7G8Jvt2GhY-FoCTp0KtF8ngGix289G2QQ@mail.gmail.com

Please fix up and resend.

thanks,

greg k-h
