Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CBD2403CC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 11:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgHJJDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 05:03:02 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:57861 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgHJJDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 05:03:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id C72B6962;
        Mon, 10 Aug 2020 05:03:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 10 Aug 2020 05:03:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=VG6tNsG0RQy55zYOkAinJYjKMdZ
        FHRBkeUHlia4o90M=; b=HDUdAe1hVoXJfEe99XTPijxWUPe7Sc5+uB1fr54TKNA
        sU/OOE9R0rk3/bl4QZK+Qcd2wyXSlwPiPgUpI4l5z0Ab0FtIvxKbz0Of3yawIWxm
        i31StgLWMs0B4hDbjMgwmNjhin8iC1pTHymVTFG812IlXmAflxDCypkRmdH2StJq
        h0SL5uLeUUVfInkhvHzHVIfwsO6x5yBW5IQVPKdhGYirYNKLj2fk8se3Vded5qg7
        yO1/eZMRTRjPMip8LZO/1WRLfhT5txyK75zVUxdrQsyep75CAal75MVEKbs4mCqA
        6oaDn/ve5MK3IN9DRDfeN9Ztqgkd9O1we/D/R2QsMnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VG6tNs
        G0RQy55zYOkAinJYjKMdZFHRBkeUHlia4o90M=; b=VIt7RVIGkeGHcN5Ka5USZR
        ozufruCDfUR88DUnZubD8SaeOpzNgGsRaVkzzrkeECfIFTRZjZ+8aqaHO14Xs4vq
        xkfaCjCTsgggAWBMUyQ+F4qNA+ZfgFkLVcjt2MHtTnIWTNWQz6ZJq2tBDD8n4rrx
        TiolRIMwmNkaqhCWdMw8zJqEzTxLIsvEVxbjYq/SjGzMZCFTx31meKOQCp7O/e+k
        dv8jLyWNWrQ2H+y5wHjtnYkUmgVVf0Wr95qQ9kbryz3SfSV5Piir6H5izm5US5Kb
        Di7ikJZOXvahgi5njY+OCJXBpUiUzDkMfJIAQ/i4SPwKXyIQfEJWdk49e6U/+alw
        ==
X-ME-Sender: <xms:Qw0xX6_5FGk5EsZbJdmlMHWBUj6GCcaDdZTKzsisvx-_0EN1mu_8lA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeekgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Qw0xX6uli82vHuT6rXOnT00jQ06sdFuNokCNgYz_TM4B7ZJOFSbpdw>
    <xmx:Qw0xXwCEUfZ6N9WlR6r7Q-rxnTogrJMqIJJMortSPu2eGOp2g-aQWA>
    <xmx:Qw0xXyegMBLWo8jbAzkjhQ_218Ng3FYMM-zu4BiFv_fAgH2GWNFruw>
    <xmx:RA0xX7AoAEczNCxsY9Wiqb8UmBOAL_F8iValxWJFJxQwKHRo0oF-cA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A1633060067;
        Mon, 10 Aug 2020 05:02:59 -0400 (EDT)
Date:   Mon, 10 Aug 2020 11:03:10 +0200
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
Message-ID: <20200810090310.GA1837172@kroah.com>
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
 <20200809070235.GA1098081@kroah.com>
 <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
 <20200810074417.GA1529187@kroah.com>
 <5522eef8-0da5-7f73-b2f8-2d0c19bb5819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5522eef8-0da5-7f73-b2f8-2d0c19bb5819@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 10:56:48AM +0200, Paolo Bonzini wrote:
> On 10/08/20 09:44, Greg KH wrote:
> >> There is more #ifdef CONFIG_CPU_LOONGSON64 in arch/mips/kvm/vz.c, and
> >> more #include "loongson_regs.h" in arch/mips.  So while I agree with
> >> Greg that this idiom is quite unusual, it seems to be the expected way
> >> to use this header.  I queued the patch.
> > Or you all could fix it up to work properly like all other #include
> > lines in the kernel source tree.  There's no reason mips should be
> > "special" here, right?
> 
> It's not just this #include, there's a couple dozen mach-* directories;
> changing how they work would be up to the MIPS maintainers (CCed), and
> it would certainly not be a patch that can be merged in stable@ kernels.
> 
> arch/mips/kernel/cpu-probe.c has the same
> 
> #ifdef CONFIG_CPU_LOONGSON64
> #include <loongson_regs.h>
> 
> for example, so apparently they're good with this.  So if I don't pick
> up the patch to fix the build it would be in all likelihood merged by
> MIPS maintainers.  The only difference will be how long the build
> remains broken and the fact that they need to worry about KVM despite
> the presence of a specific maintainer.

Ok, fair enough, but in the long-run, this should probably be fixed up
"properly" if this arch is still being maintained.

thanks,

greg k-h
