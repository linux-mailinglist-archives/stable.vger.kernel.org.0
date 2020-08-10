Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031282402EC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 09:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHJHoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 03:44:07 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:35201 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbgHJHoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 03:44:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 30E2C460;
        Mon, 10 Aug 2020 03:44:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 Aug 2020 03:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=VgR32SpCeAa/dd5+Ow3lY+fqst+
        41Q1P23hGmPCqrbA=; b=lnHaAAwx8MBQe3VbskuJHSUQakMI6BaiEMV2w/3ALWC
        cH0p0T9tSMinPLuC0RGyDPEA5DfIXjnZRO4nWFJlqKSV285Ndw/AT7kO2hSS2Ur2
        SfZlItpzjdZzWABD3G9ztvSNZ8xRNE9BtRJ+2GP3+VMtZUKTNFx3MyrFwZyEMZ4l
        xALt2fh9086yGSF0LKM0HRIdORkDNAIz9OQp2C1xDiWd39nA3dFu8sJRBkLZSlgh
        j70CPuXMfq0pAEr3trc4IM3BKW9yd7DkN2pDxe4DZM6ivovoCTdlfeGePWne+hHY
        9ZcTxCB2tZxoU+u9XylTNAph/1r6nSOPL5UV9Cd9bOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VgR32S
        pCeAa/dd5+Ow3lY+fqst+41Q1P23hGmPCqrbA=; b=S0eIbolACBUHIj5TtC23W5
        BGQMaLHxYIYA9HHTanDTdEWOpF/JgY/p7FncNkMPYDIFADnYTx7+mlJ21/HTdIHj
        EXy7EHVJ2bKd8L3Uf7XG+RLWxibo4054yOCARpybNKWmhJvmR8L2Mb169czMiGx+
        qYzlgHTXtb7C9jpvsP1GtzR64Uuocn1ulT/60G5zAE4tFPrPf4hgh/Ykb4jBUGMW
        vhUioRvddYuMZzDFH/uHJ20Jbv7ZAS5ire9zVJSfa6628d4mh95fyuhZe+wSdIc+
        rvaze4TFC3mAEYUZTSkrMMrTpHKEttZSgSJSV0Pz7nN8kupKsQrZtK42Dvqea3Rg
        ==
X-ME-Sender: <xms:xfowX7CXugBeNQGwwUBG4iUmL3mfxVnlo6ZpONQbGWPDAnZpko7Bow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeejgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:xfowXxjS8LHXZk2jNGFBiV_taG8lRGFSsG-dkZUOQznjmfvI0QkmZQ>
    <xmx:xfowX2lcy5VkSvxZgcsIHVXuwO5iWdYZjbGl9dzmK77kbGEEYzsJVg>
    <xmx:xfowX9waTADAIP4l1HUmQOTRmRFnUuU1kT1uFKg1MDqHQrkVlkRGjg>
    <xmx:xfowX_FIvQs5_oWhy5beD35VwbXlxgFtZWnJ_qav1QB3ch0kwMJ7Lw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3AD03280063;
        Mon, 10 Aug 2020 03:44:04 -0400 (EDT)
Date:   Mon, 10 Aug 2020 09:44:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
Message-ID: <20200810074417.GA1529187@kroah.com>
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
 <20200809070235.GA1098081@kroah.com>
 <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 09, 2020 at 07:23:28PM +0200, Paolo Bonzini wrote:
> On 09/08/20 09:02, Greg KH wrote:
> >>>> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> >>>> index 3932f76..a474578 100644
> >>>> --- a/arch/mips/kvm/vz.c
> >>>> +++ b/arch/mips/kvm/vz.c
> >>>> @@ -29,7 +29,9 @@
> >>>>   #include <linux/kvm_host.h>
> >>>>   #include "interrupt.h"
> >>>> +#ifdef CONFIG_CPU_LOONGSON64
> >>>>   #include "loongson_regs.h"
> >>>> +#endif
> >>> The fix for this should be in the .h file, no #ifdef should be needed in
> >>> a .c file.
> >> The header file can only be reached when CONFIG_CPU_LOONGSON64 is
> >> selected...
> >> Otherwise the include path of this file won't be a part of CFLAGS.
> > That sounds like you should fix up the path of this file in the
> > #include line as well :)
> > 
> 
> There is more #ifdef CONFIG_CPU_LOONGSON64 in arch/mips/kvm/vz.c, and
> more #include "loongson_regs.h" in arch/mips.  So while I agree with
> Greg that this idiom is quite unusual, it seems to be the expected way
> to use this header.  I queued the patch.

Or you all could fix it up to work properly like all other #include
lines in the kernel source tree.  There's no reason mips should be
"special" here, right?

thanks,

greg k-h
