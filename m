Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7B05AE741
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiIFMJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiIFMJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:09:00 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806D04DB47;
        Tue,  6 Sep 2022 05:08:59 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 78D7E5C010E;
        Tue,  6 Sep 2022 08:08:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 06 Sep 2022 08:08:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1662466135; x=1662552535; bh=NYqC7vn1O7
        NJXEHuHuR2CvnvQzulPRc/85g+mG6DDls=; b=CMPCxayjPd4S28jwM4nZZ8jEIl
        ZGHrqWU/nJOvHNqs2g7rbB7eFB5A3SDXvn/vO2XGKbfzQpjCAk+eUH3wctgTq0NP
        iIZENisRlSXC9IXwGDLzARhUGBikQTxGye0eCpHORxNTsNVVyubp3u8LPmgxqd6o
        thOeXzQzp9j0TivfafRSbiACL5fjz8DDZ8PmCBeCO+7vAzDAOugnbYFLREiUE4FI
        n0okOcM/LF+0z8jsVtPW0lk46c0es7J+OyXPvAZ+HrInxl7FT0nG7FFDK+Cz1iAQ
        lSEmgEA4bLg+FFYxYG593EU45oCshOrvScIBfMFV7+F4f+IGqzwVO5hpy2Mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662466135; x=1662552535; bh=NYqC7vn1O7NJXEHuHuR2CvnvQzul
        PRc/85g+mG6DDls=; b=0gp9rPyhbg+NByoYazvwHfOXi/gTfVXMiM5Ilpq4UNjj
        uOGdnFQ1S47QZ0wVBFwPth9VYR6h+1fbV5D/U2pVo1n2FjL084vcmhYa/SJJ020v
        qW6L7s5wZO9OtDjEZaB8kvKm2BoWnTNnuEQkflr1NhsdxHNIoPEvhFcka4VBm1bY
        rvZMPC4ULXbbPOY4u9m2pLux84vOBNt683pxKAPshFhyNpzlq1qpAgJWe+ZiCP2x
        3Rp2siz+jDyrZYSUnnN0tzi8CBsgkPV6iHfKxZH5KzDOKXKCVhKRan+j/p4+KSmp
        2XrjWeppwlgJ/rhPnNvotfWpazFcrHjeCBwLKRr+rw==
X-ME-Sender: <xms:VzgXY1-HnZlFIePfJYS9j4vxurn3bqS4t8Yyja7WUnzZVczp2CwMwA>
    <xme:VzgXY5sZPGWUG-KWJAwsRNOAtaG1WkMm0V0Uh2P6bQfWnCMVfU5jn3e2dhb6snMUf
    2DXpDSE_0YMHA>
X-ME-Received: <xmr:VzgXYzCB3BV_tOxVaPIgZYJkKL5Q38zt_h1cx57lLkI5gQp3r2xCxstsMhIOBduscxGfapWpuKeWvjWRfx2tIv1GS35T8_eL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdelkedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:VzgXY5eNF2gOWRKn8Jk625jSNJ-Dmf01YbfGDGz8C_rxEIDCgzmXEA>
    <xmx:VzgXY6O3tDD8EPB7c11BbNf-fdOhQsk5J3bbOMeF4gjhAqUk0a8xcA>
    <xmx:VzgXY7k-GT85ovvUUSRsv8k57FxlhAsQWP1PjrvHqiyISTAfJ_Chhg>
    <xmx:VzgXY1Fvc1hb8M-FQg8vs-sd7kNRltZqz3ULytN-g5r7-zvuXa_nfg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Sep 2022 08:08:54 -0400 (EDT)
Date:   Tue, 6 Sep 2022 14:08:51 +0200
From:   Greg KH <greg@kroah.com>
To:     yee.lee@mediatek.com
Cc:     linux-kernel@vger.kernel.org, patrick.wang.shcn@gmail.com,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 5.15.y] Revert "mm: kmemleak: take a full lowmem check in
 kmemleak_*_phys()"
Message-ID: <Yxc4U/8zzfkHHv+W@kroah.com>
References: <20220906070309.18809-1-yee.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906070309.18809-1-yee.lee@mediatek.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 03:03:06PM +0800, yee.lee@mediatek.com wrote:
> From: Yee Lee <yee.lee@mediatek.com>
> 
> This reverts commit 23c2d497de21f25898fbea70aeb292ab8acc8c94.
> 
> Commit 23c2d497de21 ("mm: kmemleak: take a full lowmem check in
> kmemleak_*_phys()") brought false leak alarms on some archs like arm64
> that does not init pfn boundary in early booting. The final solution
> lands on linux-6.0: commit 0c24e061196c ("mm: kmemleak: add rbtree and
> store physical address for objects allocated with PA").
> 
> Revert this commit before linux-6.0. The original issue of invalid PA
> can be mitigated by additional check in devicetree.
> 
> The false alarm report is as following: Kmemleak output: (Qemu/arm64)
> unreferenced object 0xffff0000c0170a00 (size 128):
>   comm "swapper/0", pid 1, jiffies 4294892404 (age 126.208s)
>   hex dump (first 32 bytes):
>  62 61 73 65 00 00 00 00 00 00 00 00 00 00 00 00  base............
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<(____ptrval____)>] __kmalloc_track_caller+0x1b0/0x2e4
>     [<(____ptrval____)>] kstrdup_const+0x8c/0xc4
>     [<(____ptrval____)>] kvasprintf_const+0xbc/0xec
>     [<(____ptrval____)>] kobject_set_name_vargs+0x58/0xe4
>     [<(____ptrval____)>] kobject_add+0x84/0x100
>     [<(____ptrval____)>] __of_attach_node_sysfs+0x78/0xec
>     [<(____ptrval____)>] of_core_init+0x68/0x104
>     [<(____ptrval____)>] driver_init+0x28/0x48
>     [<(____ptrval____)>] do_basic_setup+0x14/0x28
>     [<(____ptrval____)>] kernel_init_freeable+0x110/0x178
>     [<(____ptrval____)>] kernel_init+0x20/0x1a0
>     [<(____ptrval____)>] ret_from_fork+0x10/0x20
> 
> This pacth is also applicable to linux-5.17.y/linux-5.18.y/linux-5.19.y
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yee Lee <yee.lee@mediatek.com>
> ---
>  mm/kmemleak.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

What is the git commit id of this change in Linus's tree?

And what about older stable trees with this commit in it?

thanks,

greg k-h
