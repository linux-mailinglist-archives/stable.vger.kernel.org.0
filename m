Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7DE23F80E
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 17:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHHPbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 11:31:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49991 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbgHHPbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 11:31:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 11EF95C00F2;
        Sat,  8 Aug 2020 11:31:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 08 Aug 2020 11:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=SJuJPKY8xIIP9bdvxsqs96EJKif
        Y7yNvQ3n2GrGE2hA=; b=cc/IQlDJ6a0upAlSage8HnhlSmiJu7pFD5V4vyCZC5J
        vmFs0GuG87q7k2RQaiPEanW2H69xIuGq7uwJZrql9VbwHsqAJvals2KpYSrEkNBd
        QYCa7KR8VZpKR/SBvc7pHubpGrpp/uD+EgofQaeZTp/x6ksCrdBCc+PJcp5UU52z
        pdHMsk3UdAa15+DLzRSahyJjnut/jKznD5cus0RhWcUbE9tRDTKQEZ3XogC7CXdJ
        47ePj7vooYiMj9/ung3pgIfL6Asl8XeC6uQNS3/hz/1S1zitCKvcrW+qbXe6DyxL
        zMia7D2iwHPwH3/eu1TasP/c8SuBmw96ZjgAF7jxVpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SJuJPK
        Y8xIIP9bdvxsqs96EJKifY7yNvQ3n2GrGE2hA=; b=Qt2/RK2PjRo4+UOzT9hhoM
        y6O2xWywYf8L0xmsUnpk6XWI/Hy6IkGbcgKXiF7EHh2UQz5PeTARYDYiACx7F72m
        tNvNtMmsyLNNL9QcPwzCXf5lrJSIDqe1RQ1MaA+mGwVysvWz/CfhkOiNwRpXlPZx
        ZGQ/PCjGxZRlgCLYa/FNFABPJ3kTOPfPlRB34erY8jyW6zEPaafdScGVvS5eDVUI
        bJniMaN9W8OhFHYrt6VAGAl2ZuGPH4h2zBd/bRvxbUAkE2lAphNSHf/b4RM/Zef+
        tsA+r/XfRfPrNxFV4icCvmMxfUss6968Q0/BBFTcDLpfEZshVouBDsplDeHFXHow
        ==
X-ME-Sender: <xms:QsUuXzfNP3nf-McGJV0ybKJIPBUktXjgacuqo1A1VmXGErysZX-5gA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeeggdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Q8UuX5PmMxsVsr2tfNR6MZYFqgndrOO_U4AE3ByJETaG2e_RMSGxHw>
    <xmx:Q8UuX8iWJTeNftbmU00isWaUumUQo4SB_eyafRPWTXcIDGmdMBjdgQ>
    <xmx:Q8UuX09PvPUo44PpJ5kKUO0hoaBIEa752-r5wU3lEBbVBx8KqpJAmA>
    <xmx:RMUuXzjuJpH8OlQ80eTHiUTrsDRDbXgzehmBjav4e31hI6v_xknJ6Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A4E80306005F;
        Sat,  8 Aug 2020 11:31:14 -0400 (EDT)
Date:   Sat, 8 Aug 2020 17:31:23 +0200
From:   Greg KH <greg@kroah.com>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
Message-ID: <20200808153123.GC369184@kroah.com>
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 08, 2020 at 08:50:52PM +0800, Huacai Chen wrote:
> Only Loongson64 platform has and needs loongson_regs.h, including it
> unconditionally will cause build errors.
> 
> Fixes: 7f2a83f1c2a941ebfee5 ("KVM: MIPS: Add CPUCFG emulation for Loongson-3")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kvm/vz.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 3932f76..a474578 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -29,7 +29,9 @@
>  #include <linux/kvm_host.h>
>  
>  #include "interrupt.h"
> +#ifdef CONFIG_CPU_LOONGSON64
>  #include "loongson_regs.h"
> +#endif

The fix for this should be in the .h file, no #ifdef should be needed in
a .c file.

thanks,

greg k-h
