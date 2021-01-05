Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B382EA6DF
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbhAEJFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:05:12 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59259 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbhAEJFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 04:05:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id BFE11666;
        Tue,  5 Jan 2021 04:04:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 05 Jan 2021 04:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TUtgNPoXuUOXJrOKmvGYB7SWZxy
        RvgbHZr1AL8pLDcQ=; b=QUkfYFO0QyjEPrDpLPAEkcaL5ojVa+jsyZOfIV8wRVU
        n799CYY6dGOf0YiWZEL8dgsZiAt/L9LteY8ZAsR232NaC/p1KGF1Q9bfJEQ4Q5u3
        DUsqoxQpdq6+DQZBMQVomxvLUDUGzKcZ1sW3rCNd8HijJIgn8FqC/I/M2ms+opLO
        dJKVmSs8R0EtGeA4dBt5g7neNlaqjS1wXNWOUskXxKIFdmFLeHL3Vt65OahcL2ao
        giGLasN0AqlDRU0t5n5FrkuwXhdJDnyQxYaO3JfapURovMdkj8Xxg5SY/yvHw3JA
        1E4KcPmxkZC/PnPCwKhAg/EZ+AaNRqkZlO1sc7sVLYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TUtgNP
        oXuUOXJrOKmvGYB7SWZxyRvgbHZr1AL8pLDcQ=; b=GYVfhsTff/cHx0SG/Z3Rui
        KQn97aw8kfYEb0LCegAGDZgIuy4I1PTTsc1sXGc48RreKGba2ua9KHRGAN4wz9HH
        YugeF898+PKV19Mn8KAgqSyxiCCLauy+Eea/fBAmJKhtid1VIhViJ6ijWrGUF2+W
        YPDnoIG1LBPln8QFK1D2+CTh6MfXieTlOX2dqc6kRx66H8gmPXFDb+buNihCKEnj
        6ILwcG6mltnQ4bJczGMqkZF1n7MN5nDDmeYimd/UZ3X0UCOJcU1WO407x9bRShV2
        7fdAbSRZfFA9SfiRDiRIEoB+VowU44D5dgVV4c0asF8CYLmYlPzuGuESHM3nCbuw
        ==
X-ME-Sender: <xms:gyv0X-S6jQbYrcGUCxJz51H6Q8rJrjlIDoQ-JTa_qpmdTeAetboGAg>
    <xme:gyv0XzyHZ2oEQebqSKIKEEbQM43AEDksGPiX4Tc_pfjlLz9E9zarcPfGIiq3lLau6
    A6K9ZqIaBLsBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:gyv0X73URPx0fSGfQsHGvldZ-nzGtjBO7g96IPRBbwaI9bnFTbqABw>
    <xmx:gyv0X6DOj4mf0AgB6EZ9JOwMMcuJ4EtZ3G0ZZAlZoXaSr9JuiMOZlA>
    <xmx:gyv0X3h-oj2QrHqcqLmPazTriarzbXnTJSt8ueDl7cR94clwltN1Lg>
    <xmx:hSv0X3e3YO9Xh4gu0bit7oTbL2fe0aKGtn98MVlOIcmvEdohzTfOig>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 037AC1080057;
        Tue,  5 Jan 2021 04:04:02 -0500 (EST)
Date:   Tue, 5 Jan 2021 10:05:28 +0100
From:   Greg KH <greg@kroah.com>
To:     Santosh Sivaraj <santosh@fossix.org>
Cc:     stable@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v3 5/6] mm/mmu_gather: invalidate TLB correctly on batch
 allocation failure and flush
Message-ID: <X/Qr2Om3vW+4XdnI@kroah.com>
References: <20200312132740.225241-1-santosh@fossix.org>
 <20200312132740.225241-6-santosh@fossix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312132740.225241-6-santosh@fossix.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 06:57:39PM +0530, Santosh Sivaraj wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit 0ed1325967ab5f7a4549a2641c6ebe115f76e228 upstream.
> 
> Architectures for which we have hardware walkers of Linux page table
> should flush TLB on mmu gather batch allocation failures and batch flush.
> Some architectures like POWER supports multiple translation modes (hash
> and radix) and in the case of POWER only radix translation mode needs the
> above TLBI.  This is because for hash translation mode kernel wants to
> avoid this extra flush since there are no hardware walkers of linux page
> table.  With radix translation, the hardware also walks linux page table
> and with that, kernel needs to make sure to TLB invalidate page walk cache
> before page table pages are freed.
> 
> More details in commit d86564a2f085 ("mm/tlb, x86/mm: Support invalidating
> TLB caches for RCU_TABLE_FREE")
> 
> The changes to sparc are to make sure we keep the old behavior since we
> are now removing HAVE_RCU_TABLE_NO_INVALIDATE.  The default value for
> tlb_needs_table_invalidate is to always force an invalidate and sparc can
> avoid the table invalidate.  Hence we define tlb_needs_table_invalidate to
> false for sparc architecture.
> 
> Link: http://lkml.kernel.org/r/20200116064531.483522-3-aneesh.kumar@linux.ibm.com
> Fixes: a46cc7a90fd8 ("powerpc/mm/radix: Improve TLB/PWC flushes")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Cc: <stable@vger.kernel.org>  # 4.19
> Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
> [santosh: backported to 4.19 stable]
> ---
>  arch/Kconfig                    |  3 ---
>  arch/powerpc/Kconfig            |  1 -
>  arch/powerpc/include/asm/tlb.h  | 11 +++++++++++
>  arch/sparc/Kconfig              |  1 -
>  arch/sparc/include/asm/tlb_64.h |  9 +++++++++
>  include/asm-generic/tlb.h       | 15 +++++++++++++++
>  mm/memory.c                     | 16 ++++++++--------
>  7 files changed, 43 insertions(+), 13 deletions(-)

As the testing pointed out, this breaks the build on lots of arches:
	https://lore.kernel.org/r/CAEUSe78+F1Q9LFjpf8SQzQa6+Ak4wcPiiNcUVxEcv+KPdrYvBw@mail.gmail.com
	https://lore.kernel.org/r/cff87cd2-8cd5-241e-3a05-a817b1a56b8c@roeck-us.net

so I'm going to drop this whole series and do a -rc2.

If you still want/need this series in 4.19, please make sure it really
works for everyone :)

thanks,

greg k-h
