Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443AB3A28F7
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 12:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFJKGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 06:06:21 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:52605 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhFJKGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 06:06:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 554BD2333;
        Thu, 10 Jun 2021 06:04:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 10 Jun 2021 06:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=9WI5xCILPDtfU2J23fyUihMeujs
        p3+nvIZghW3iHRHc=; b=IZFkCK0xZ/bXtTr+WlMMF8ItwBhwYM/KoXNNu+FfCc9
        AyI3tT+au+cKpKHm6qser7g2DdoSVhjoNlM9T3TcOsNdrofSugaOT0I/AV5PsNzI
        i7n0b5RJBW4NXBqq6Bzzh9wOaMC8HSB1ZB6Jl/lxuztGf9hfTTajjnIQ0Qs74vkG
        egJHDMsQWZpQ6dntUDSV5vbshi3oNzIJ3Wk6Q6m4ggxGpd9uZam9o3MIY7dfqtKH
        HdUlVRFYCTxp5OtTSSDOmPUx2TlzLZ/549hzusz8YWdf/Ni2iX69X32FAMId571I
        dcbLxZ0zW/KBPM+b/HaQsk3JFSTGu83pHgbQWjSSqPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9WI5xC
        ILPDtfU2J23fyUihMeujsp3+nvIZghW3iHRHc=; b=kYI4GDlQ0LwiIMhaUcPMYb
        UFjQhLahV8ujxVLzU3h8/dPDinCC/laG2rs0U8Kcv9o3ED62wgRlm4uxuiyNnwCW
        v//OF7HEXOzDEuI30gh5XULJJ+gvSlVmAbWIID9avgZc/FmYYBlPh8m04kIaxUDO
        WK34wTnZR4zQtDNI0iXeSNe1Il4JKbGuh8i0FtQFI1q6Ng5UsSyEUT+kNqAj/QFT
        3OixEgRp8RwxMHnxuzl1V7j4sEjqk8vOv/riBi1np+86H0c0kwtzRQvoBcV7REfJ
        IHrwFJ+Ag2gCCgtMWCxHpxPCVjURwTL+KOKVwzQt9ofu6JHJlGUptAOxuxcHx5Cw
        ==
X-ME-Sender: <xms:puPBYJ2rGiTcw9mMPSndnojwvdYaaCYxBghmU_yaN9aR_y6ArQYszQ>
    <xme:puPBYAE8PPhPseYkhU_FgqbUfaNYLuKO-9lLrSDD6esFZDuM9kqEJPgx_qNz5ZCgE
    jbXPuh5Eyy2cw>
X-ME-Received: <xmr:puPBYJ7K2vWRG4-AqXQmW7ulfdhwodtDwf2umovs1sCb-gOQtOdvc3D-IyRJ1eO92LHiLV04HQCcAdtZl4tJdAFwVmdF8Qks>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedufedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepueelledtheekleethfeludduvdfhffeuvdffudevgeehke
    egieffveehgeeftefgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:puPBYG2lvVJlbkqWJV-UJ9vbc3V8jdN9r7rm1IXwGYW-8KtQH05ASg>
    <xmx:puPBYMEhH-DERttWqIZe3P0gl_s6dYWjidWIXHsvWf79rsxbsLKdrw>
    <xmx:puPBYH9hZ2K9zTjDDwleNARCz25DoYgVmik1fmW77Z2SN2Z9SpfwEw>
    <xmx:puPBYKXv0Wz-Zjxi2H81HdSOEsEumRk85e_FaBgRlmFW1TJ0RQC50EMzKd4>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Jun 2021 06:04:21 -0400 (EDT)
Date:   Thu, 10 Jun 2021 12:04:18 +0200
From:   Greg KH <greg@kroah.com>
To:     torvic9@mailbox.org
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD <
 13.0.0
Message-ID: <YMHjomyjH/RwrHKQ@kroah.com>
References: <214134496.67043.1623317284090@office.mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <214134496.67043.1623317284090@office.mailbox.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 11:28:04AM +0200, torvic9@mailbox.org wrote:
> Since LLVM commit 3787ee4, the '-stack-alignment' flag has been dropped [1],
> leading to the following error message when building a LTO kernel with
> Clang-13 and LLD-13:
> 
>     ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument 
>     '-stack-alignment=8'.  Try 'ld.lld --help'
>     ld.lld: Did you mean '--stackrealign=8'?
> 
> It also appears that the '-code-model' flag is not necessary anymore starting
> with LLVM-9 [2].
> 
> Drop '-code-model' and make '-stack-alignment' conditional on LLD < 13.0.0.
> 
> This is for linux-stable 5.12.
> Another patch will be submitted for 5.13 shortly (unless there are objections).


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
