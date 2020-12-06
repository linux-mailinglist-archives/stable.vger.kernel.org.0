Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FF62D0255
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 10:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgLFJxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 04:53:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55565 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgLFJxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 04:53:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1FEB45C00B3;
        Sun,  6 Dec 2020 04:52:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 06 Dec 2020 04:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=dAgfFfY8JAvA3RSq+C4Cc3akx6O
        jCHkEE0jdqkQ+oxE=; b=Ot4M+6HWDFOcimp3Wt5C1XS0D2gSofLOnSjMz//eFyj
        RaKCJ3ZJ/Si8hH+rldXirxJmylT89O5u2GPRtHvmpJHlFpNQM/P+7MIgdD+JYdgr
        oJRBaMQDchOKOekWLIglGJo1KHlpk3xCedYKHzV3I8L94tV8ku5SuaM6R9eh3YUB
        JzvwHaPUHaEJBy50Q0sQWtjj21WN66avTshdWCe0I7fD0wMgw0TWpnfeX8PnULtR
        3rVlU4/1MlMy8FXhT1ykgQfGlfYMbCYvBn7l6uiGJHlRnblUsm4rmKpdLGu4/j4n
        I8MYZu556WH4a6UFv3m19e4OQKUi/F4hjlBA/wFddXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dAgfFf
        Y8JAvA3RSq+C4Cc3akx6OjCHkEE0jdqkQ+oxE=; b=caQs7cpHRvU6E+sf42JO30
        4rIQWd323iqm6MmXuAMz04KikeqZST5x+NPOi7R5YBJWodCLlP4YDU3mDmSITTsY
        MSkQHN5KMDQSQUHcSXBUNGMOrc5FUCEudQheWJMPqvOZ0xSty0yMoPGU2WNoHVn+
        ywbU9fzpw7+HF1DH73/N4DyYNvkzNlp3UuxVhb9EokL0EnLgkodDr/jZGDflJMQ+
        DdC5cvY+zZkoIx9df3ui1vWS3OyU2lQcZbzqyKzTIieabd0eLKobIDda5yBZh7YU
        nSedm0eUnilNQxsGi6oDK7OmOpe/i9p2eyF4l9rAVI8vVjw8WMmj8j7mCMt6s0sA
        ==
X-ME-Sender: <xms:z6nMX1RrYSj0SjQfobtSf6bx2pWPUvlbc27BJV_lKHZXSrRRjqHYRw>
    <xme:z6nMX-xGTslorP_5-QwAQ8qVS4-4SeihfTUobEIUHBLHbzI0avGQsZ1FiV7YkDbwv
    1256mN7ScrslA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejvddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:z6nMX62S_AqhBaOkihJVevBgwn8mo4ExqtLZoDv_WgpfKg8SYFfvCQ>
    <xmx:z6nMX9BNsRs0F4iN_eTOmus3aHCpjkJbmb1YjDaprmCidyuKrjqM7w>
    <xmx:z6nMX-jFam5p58lnaAQwQuE2_KpmqKYrS76IiVmdc-d_vbTRZQRm_A>
    <xmx:0qnMXyZDljvwtSRwmXA64EfqzAYQ1QVhsOKgnnnRCNR48aXjJjTF7g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DFD7F1080057;
        Sun,  6 Dec 2020 04:52:14 -0500 (EST)
Date:   Sun, 6 Dec 2020 10:53:28 +0100
From:   Greg KH <greg@kroah.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     stable@vger.kernel.org, jgg@nvidia.com, Di Zhu <zhudi21@huawei.com>
Subject: Re: [PATCH 4.14-stable] RDMA/i40iw: Address an mmap handler exploit
 in i40iw
Message-ID: <X8yqGHmYVL28J0UY@kroah.com>
References: <20201202172012.801-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202172012.801-1-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 02, 2020 at 11:20:09AM -0600, Shiraz Saleem wrote:
> From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
> 
> backport of commit 2ed381439e89fa6d1a0839ef45ccd45d99d8e915 upstream.
> 
> i40iw_mmap manipulates the vma->vm_pgoff to differentiate a push page mmap
> vs a doorbell mmap, and uses it to compute the pfn in remap_pfn_range
> without any validation. This is vulnerable to an mmap exploit as described
> in: https://lore.kernel.org/r/20201119093523.7588-1-zhudi21@huawei.com
> 
> The push feature is disabled in the driver currently and therefore no push
> mmaps are issued from user-space. The feature does not work as expected in
> the x722 product.
> 
> Remove the push module parameter and all VMA attribute manipulations for
> this feature in i40iw_mmap. Update i40iw_mmap to only allow DB user
> mmapings at offset = 0. Check vm_pgoff for zero and if the mmaps are bound
> to a single page.
> 
> Fixes: d37498417947 ("i40iw: add files for iwarp interface")
> Link: https://lore.kernel.org/r/20201125005616.1800-2-shiraz.saleem@intel.com
> Reported-by: Di Zhu <zhudi21@huawei.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_main.c  |  5 -----
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 36 ++++++-------------------------
>  2 files changed, 7 insertions(+), 34 deletions(-)

All backports now queued up, thanks.

greg k-h
