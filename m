Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04A623FD11
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 09:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgHIHCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 03:02:44 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34473 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbgHIHCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Aug 2020 03:02:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D8A3432B;
        Sun,  9 Aug 2020 03:02:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 09 Aug 2020 03:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=C
        ZZOeMqfhadfPcRVRLEsanj8bFOrmOCOkNkjdY/+IQw=; b=iOlq4ZByc7Alv9IH/
        yhYW0x3s7Bg8eWaVfeo/Urd0lYZaiuGV3OLcOyZdiqDhxFcRkbxUmF6gswCweMqC
        7H5+QcvNBooe/L00C7Mpc+hod3aXMEjU5bVXIAoAQ7KeyVOqebp0Oss8vUrF8hWP
        Z7VS6hN4m4XRB8X9pA8J7TGD+PfzkqXXaSy8zf5wywp73Jirq0oVNvukADpIC+ZB
        D8LVCS2cijO6uROZM5huLStFPSkKSOTtWTi2j1BYPW7nI78eWNpCtyJUrU0CSS0U
        4p3jFOIkRHMcPRS3YBn9xw8oZVjzisxD/AMusBHhpQ2QIEgmrUKzOx6ErkC2ioS3
        wErFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=CZZOeMqfhadfPcRVRLEsanj8bFOrmOCOkNkjdY/+I
        Qw=; b=jm9i3TlHGIxgFq4x28OBgYxE4Ndx5ZDsWD9O8paOB4pbvcR+ItUHgXSmy
        K9X1bd0uwQ6dIaPL2p3rxo3fLcos/tBJdBjRz+LRlPCl/cLR9ktCYHrZFTxO4l/H
        wMa/OMN9km4YAneQ/Z4L4nmTt6bWVipVgIVWRKVOXBHPgiy6O9Vfjj9pyUqKXl3m
        dQMie/g293HIK9W2mOEUhtujomGKx1SZES00sLpwEQBa7bkDkqZx3E8roV5legz/
        nICVoXEChozdkh4xJrR7tvG+c6bgWewMYPf9oD0tJY9op5E9bhsmxHGNapGBK03U
        jsUHikABVxrZHZCKBRUkp4NAVptig==
X-ME-Sender: <xms:kJ8vX1wjCiwkkWiKHZsHc5aYJ0R-Ht9w0wkUr1xJ9Rxeih6fpzsEtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeehgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueehke
    ehlefffeeiudetfeekjeffvdeuheejjeffheeludfgteekvdelkeduuddvnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:kJ8vX1TS24QAOAXGvSUmBnHO1gdjX3hfK8wzv6qlWv4_u97GV9w_2A>
    <xmx:kJ8vX_VdYMUy8kyLNmvMi-btXBBKzXfKSzD72Kex5-LmXFMZTWtpIA>
    <xmx:kJ8vX3iLMfdG1CgjYqQL1V7sMnsl3M80JnhCQgGMpTH5TpqzuyDrrQ>
    <xmx:kZ8vX50X93O7uC7azEGm0ugsvxktCsnocNNZ3kxNlS2LL5_uI4DGXw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 639D1306005F;
        Sun,  9 Aug 2020 03:02:40 -0400 (EDT)
Date:   Sun, 9 Aug 2020 09:02:35 +0200
From:   Greg KH <greg@kroah.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
Message-ID: <20200809070235.GA1098081@kroah.com>
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 08, 2020 at 11:35:54PM +0800, Jiaxun Yang wrote:
> 
> 
> 在 2020/8/8 下午11:31, Greg KH 写道:
> > On Sat, Aug 08, 2020 at 08:50:52PM +0800, Huacai Chen wrote:
> > > Only Loongson64 platform has and needs loongson_regs.h, including it
> > > unconditionally will cause build errors.
> > > 
> > > Fixes: 7f2a83f1c2a941ebfee5 ("KVM: MIPS: Add CPUCFG emulation for Loongson-3")
> > > Cc: stable@vger.kernel.org
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > ---
> > >   arch/mips/kvm/vz.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> > > index 3932f76..a474578 100644
> > > --- a/arch/mips/kvm/vz.c
> > > +++ b/arch/mips/kvm/vz.c
> > > @@ -29,7 +29,9 @@
> > >   #include <linux/kvm_host.h>
> > >   #include "interrupt.h"
> > > +#ifdef CONFIG_CPU_LOONGSON64
> > >   #include "loongson_regs.h"
> > > +#endif
> > The fix for this should be in the .h file, no #ifdef should be needed in
> > a .c file.
> 
> The header file can only be reached when CONFIG_CPU_LOONGSON64 is
> selected...
> Otherwise the include path of this file won't be a part of CFLAGS.

That sounds like you should fix up the path of this file in the
#include line as well :)
