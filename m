Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7B0B46B8
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 07:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfIQFGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 01:06:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47227 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbfIQFGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 01:06:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D50721AD2;
        Tue, 17 Sep 2019 01:06:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 17 Sep 2019 01:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=tVQq8jKjIAP2/lIeyZwi4UGUeP0
        hIbOe9S5/C7ahxG8=; b=Y1OxiLF0JDMPBj0UXEFb387BzIeCvIOMgjHpirHuboh
        zB8hKXNAxeb/rPqkzO3VP5vHNY9xeB5DpuY5QSgIBZmRO613TNmDGsIyerK2uyo0
        ot7QeqlbfZPiUBymFRmJ0Nz/z+BXbWfO2HY775G1CUhCVWDChSAPgvCQEQRwulUZ
        XjP4jR+O3IrcfzV9ykegj97SqkCFEdRaXjS4xMBIZZiUfA4ewxQ457zgCqTNqtN6
        Sr5kRUp0ZCYGYveDiXCF6WnVCm5ZvyFMUOKPcg29DX6SKbK9VKQ/OVweWeyQR1xn
        snTFJm0Cf6Rx84p6jQjgAdN+rc02+jQbgLipjyKjvjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tVQq8j
        KjIAP2/lIeyZwi4UGUeP0hIbOe9S5/C7ahxG8=; b=MK4ulbQ8LxIyBN7hvVKtzJ
        EyzdGpPPLx+DSyjpi55hl6V73P2foo4ewAJAui0sPwZ4VxwPcHgS7+ipCe9ThAKZ
        psywebwPELSbyEHz/oxvowqkqZsPvFae0a2Z3ZXVsfyMTH3jtsgWL6UXs5JnPWaJ
        KOcP3Q1q9V8nzYIGSmFGF0G8OFDhDy799PYNvgSmiGYOt0R9JjugMhu/28wUL6xg
        2cg5Fp/LslPZZ+n+pi/8KHhXNeCixTXi4RCG4Sq4PfTQW6AEiAqweAGmhOtqPtpf
        nnE2coEyXnzeQzA8Vv+M1tYGvJJXbW3H5fTyyIEN5O8w8Nd9hEOmNyTXW8O2cfkw
        ==
X-ME-Sender: <xms:1mmAXcdtE5jG3vghwGY6-1MVEZ-QJs8a0AvSL8MNAG7Oanwrfx5Rfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:1mmAXei1NzVQf4RFOPEbLVxYRGHwc8XhitmG7WGZsWJahuS4YbK8HQ>
    <xmx:1mmAXVLHkZVAllxrSxPURX6-dtAy_M_PJFK6D3y3iazxXVHSOJ0Pxw>
    <xmx:1mmAXck7700r2zKbjz8Fleg4uNALwY3o7EGjPxCjXPzDhWgI2AWshw>
    <xmx:12mAXcMuygsrOai_wVSu4SY5NnH08R8ty-hBCXuyMBaNObtIYWm3dQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E295D60065;
        Tue, 17 Sep 2019 01:06:30 -0400 (EDT)
Date:   Tue, 17 Sep 2019 07:06:28 +0200
From:   Greg KH <greg@kroah.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Greg Kurz <groug@kaod.org>, Sasha Levin <sashal@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/xive: Fix bogus error code returned by OPAL
Message-ID: <20190917050628.GB2056553@kroah.com>
References: <156821713818.1985334.14123187368108582810.stgit@bahia.lan>
 <20190912073049.CF36B20830@mail.kernel.org>
 <20190913131221.3ea88b5a@bahia.lan>
 <87sgovsgvs.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgovsgvs.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 17, 2019 at 02:09:43PM +1000, Michael Ellerman wrote:
> Greg Kurz <groug@kaod.org> writes:
> > On Thu, 12 Sep 2019 07:30:49 +0000
> > Sasha Levin <sashal@kernel.org> wrote:
> >
> >> Hi,
> >> 
> >> [This is an automated email]
> >> 
> >> This commit has been processed because it contains a -stable tag.
> >> The stable tag indicates that it's relevant for the following trees: 4.12+
> >> 
> >> The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143.
> >> 
> >> v5.2.14: Build OK!
> >> v4.19.72: Failed to apply! Possible dependencies:
> >>     75d9fc7fd94e ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
> >
> > This is the only dependency indeed.
> 
> But it's a large and intrusive change, so we don't want to backport it
> just for this.
> 
> >> v4.14.143: Failed to apply! Possible dependencies:
> >>     104daea149c4 ("kconfig: reference environment variables directly and remove 'option env='")
> >>     21c54b774744 ("kconfig: show compiler version text in the top comment")
> >>     315bab4e972d ("kbuild: fix endless syncconfig in case arch Makefile sets CROSS_COMPILE")
> >>     3298b690b21c ("kbuild: Add a cache for generated variables")
> >>     4e56207130ed ("kbuild: Cache a few more calls to the compiler")
> >>     75d9fc7fd94e ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
> >>     8f2133cc0e1f ("powerpc/pseries: hcall_exit tracepoint retval should be signed")
> >>     9a234a2e3843 ("kbuild: create directory for make cache only when necessary")
> >>     d677a4d60193 ("Makefile: support flag -fsanitizer-coverage=trace-cmp")
> >>     e08d6de4e532 ("kbuild: remove kbuild cache")
> >>     e17c400ae194 ("kbuild: shrink .cache.mk when it exceeds 1000 lines")
> >>     e501ce957a78 ("x86: Force asm-goto")
> >>     e9666d10a567 ("jump_label: move 'asm goto' support test to Kconfig")
> >> 
> >
> > That's quite a lot of patches to workaround a hard to hit skiboot bug.
> > As an alternative, the patch can be backported so that it applies the
> > following change:
> >
> > -OPAL_CALL(opal_xive_allocate_irq,              OPAL_XIVE_ALLOCATE_IRQ);
> > +OPAL_CALL(opal_xive_allocate_irq_raw,          OPAL_XIVE_ALLOCATE_IRQ);
> >
> > to "arch/powerpc/platforms/powernv/opal-wrappers.S"
> > instead of "arch/powerpc/platforms/powernv/opal-call.c" .
> >
> > BTW, this could also be done for 4.19.y .
> >
> >> 
> >> NOTE: The patch will not be queued to stable trees until it is upstream.
> >> 
> >> How should we proceed with this patch?
> >> 
> >
> > Michael ?
> 
> We should do a manual backport for v4.14 and v4.19. Greg do you have
> cycles to do that?

Me?  No, sorry.  If you want this fix there, I need someone to send the
backport.

thanks,

greg k-h
