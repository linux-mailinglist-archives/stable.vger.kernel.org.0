Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B95472005
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 05:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhLMEg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 23:36:56 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36189 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231620AbhLMEgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 23:36:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C76035C00C9;
        Sun, 12 Dec 2021 23:36:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 12 Dec 2021 23:36:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
        message-id:subject:from:to:cc:in-reply-to:references
        :content-type:date:mime-version:content-transfer-encoding; s=
        fm3; bh=OUsM0IPuEeSG7R5tkw+JV5egTMzCpaE7Lad6FfawhOE=; b=XOHVEWug
        4N+O5S9J/CpVJ8cZs+sY0dJd9Qxf76Qyr3EW3Zej75V7rxi+YmIR+I4c3gV3M1lB
        LFWNdlnVSMWGljJUmwCWNR7LtXmNWp2Msx75r/IoChl2+vPbNj0HrZ9KQHGwSj8i
        twaBk6L+TVxQJBESwR68V7PQQSPO8biEQ0bI+Ch0Q+1sPfZt6gRGLxo/6isCwjKQ
        cA9Cmyr0/PEBrvUuLCQzta/dxw7rctEJxjmMpStyHnmZR/b0Kd8W5MWCOagFirkp
        r8I7B/Zw5KnMwvtyhZZ0PsrbPdRTNn8WtQzsrHZqNWefvouQOv1Cfwxm/9tcWOBB
        Pi8LWPrwYeD0Yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=OUsM0IPuEeSG7R5tkw+JV5egTMzCpaE7Lad6Ffawh
        OE=; b=Q6KmIDe3C6F51MV3/68eUjZ66YJhSyjI+igBy3eW4FzAzb4piga7S7MU/
        U53DZaxRNyh/34b+uX/F4LyxXSDk9a1fm3u+V2X/14OIs0bBptjE9djL1OKtx1yB
        r+bCEKpzPwkhwQMtFuKMzWVrEkYHDoRTQinyx6nIPWtNwBBjy3U9r52pUYxUbYU9
        ky7JRadxx2FDUbCdtbBAa7nrSmkFP6UhEcT0tJ9TnY6f90vkexiPdMijboqhYHiM
        RnjoApBLxFlsMTTD0dPzuKRGzfG0sgjDiMgLK+F2Y3t8vfVfE+7jsqwNOjo4/Rrc
        kcj6d5tm5Kp5+eHKqOi1pfW2gPp5Q==
X-ME-Sender: <xms:5s22YQ13WkOmgPyYzzGkKEqlDho_PZnwQxRxn-MV_Ia5GpQV2wwU4w>
    <xme:5s22YbF6bEJPJuajKjAALFqZaCVaWazK8B2x2QBzh1VS4825ydeuDd52vCgjQQmN0
    aXlG3vVQ_dd8NOvOg>
X-ME-Received: <xmr:5s22YY6b907Xooim6ZA4HTV5fTRHJTBbmeI8inzQ_akI-NXAgDV8GvLQhJlsyCi2bxh3YvmJdXgK9PqQYZk2P_vdH_6urbXdptVa-5Uof0d330MwO8sl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkeejgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdejmdenucfjughrpefkuffhvfgjfhgtffggfgfgsehtkeertddtreej
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucggtffrrghtthgvrhhnpeetgeekhfevvedtfffhvddvhfevveeludev
    vdegveevkeekkeetvedvvddtlefggeenucffohhmrghinhepphhrvghsvghnthdrrhhone
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgt
    uhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:5s22YZ07-uSSVg6WHvi6NvACqZRryTE0wC4m2b3O_nbYeNxMIqu20A>
    <xmx:5s22YTE0GqcUhfN2kzF4hNksu3g0Ffur4meGm-DYtw6Pf2VtrJ5ehA>
    <xmx:5s22YS_bHs2QhUzVx0hEcKwrapU_X5aUuZvHj7NaPpf6HZIWaqnWNA>
    <xmx:5s22YY65N0wV0hQRB1GEyb3Bdh_DdA8ZFjKnDbWHU5xcyuiTb6crmA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 12 Dec 2021 23:36:51 -0500 (EST)
Message-ID: <984da14c339ae81b45518002081f791153fe69dd.camel@russell.cc>
Subject: Re: [PATCH] powerpc: Add set_memory_{p/np}() and remove
 set_memory_attr()
From:   Russell Currey <ruscur@russell.cc>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <715cc0c2f801ef3b39b91233be44d328a91c30bc.1639123757.git.christophe.leroy@csgroup.eu>
References: <715cc0c2f801ef3b39b91233be44d328a91c30bc.1639123757.git.christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 13 Dec 2021 14:36:47 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.42.2 
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-12-10 at 08:09 +0000, Christophe Leroy wrote:
> set_memory_attr() was implemented by commit 4d1755b6a762
> ("powerpc/mm:
> implement set_memory_attr()") because the set_memory_xx() couldn't
> be used at that time to modify memory "on the fly" as explained it
> the commit.
> 
> But set_memory_attr() uses set_pte_at() which leads to warnings when
> CONFIG_DEBUG_VM is selected, because set_pte_at() is unexpected for
> updating existing page table entries.
> 
> The check could be bypassed by using __set_pte_at() instead,
> as it was the case before commit c988cfd38e48 ("powerpc/32:
> use set_memory_attr()") but since commit 9f7853d7609d ("powerpc/mm:
> Fix set_memory_*() against concurrent accesses") it is now possible
> to use set_memory_xx() functions to update page table entries
> "on the fly" because the update is now atomic.
> 
> For DEBUG_PAGEALLOC we need to clear and set back _PAGE_PRESENT.
> Add set_memory_np() and set_memory_p() for that.
> 
> Replace all uses of set_memory_attr() by the relevant set_memory_xx()
> and remove set_memory_attr().
> 
> Reported-by: Maxime Bizon <mbizon@freebox.fr>
> Fixes: c988cfd38e48 ("powerpc/32: use set_memory_attr()")
> Cc: stable@vger.kernel.org
> Depends-on: 9f7853d7609d ("powerpc/mm: Fix set_memory_*() against
> concurrent accesses")
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Reviewed-by: Russell Currey <ruscur@russell.cc>

One comment below:

> diff --git a/arch/powerpc/include/asm/set_memory.h
> b/arch/powerpc/include/asm/set_memory.h
> index b040094f7920..061f1766a8a4 100644
> --- a/arch/powerpc/include/asm/set_memory.h
> +++ b/arch/powerpc/include/asm/set_memory.h
> @@ -6,6 +6,8 @@
>  #define SET_MEMORY_RW  1
>  #define SET_MEMORY_NX  2
>  #define SET_MEMORY_X   3
> +#define SET_MEMORY_NP  4
> +#define SET_MEMORY_P   5

It might be nice to have a comment somewhere in set_memory.h explaining
that {p/np} = present/not present.  RO/RW/NX/X are commonly used, "p"
as shorthand for "present" is less obvious.  x86's set_memory.h has a
nice comment covering everything as an example.

>  int change_memory_attr(unsigned long addr, int numpages, long
> action);
>  
> @@ -29,6 +31,14 @@ static inline int set_memory_x(unsigned long addr,
> int numpages)
>         return change_memory_attr(addr, numpages, SET_MEMORY_X);
>  }
>  
> -int set_memory_attr(unsigned long addr, int numpages, pgprot_t
> prot);
> +static inline int set_memory_np(unsigned long addr, int numpages)
> +{
> +       return change_memory_attr(addr, numpages, SET_MEMORY_NP);
> +}
> +
> +static inline int set_memory_p(unsigned long addr, int numpages)
> +{
> +       return change_memory_attr(addr, numpages, SET_MEMORY_P);
> +}
>  
>  #endif
