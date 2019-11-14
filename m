Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232BBFC001
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 07:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfKNGCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 01:02:40 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58933 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbfKNGCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 01:02:40 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1360C21C39;
        Thu, 14 Nov 2019 01:02:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 14 Nov 2019 01:02:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=QwzVKI6tbra34TY6z9msluLBFLL
        DyCMl9KOPaMBmeK8=; b=OLJ+O93w/O7Wp5kWCE+tvkvr2WFCNVT5+nBYEaDSHQ4
        /ox/ufRmWDzcrokhj76Wnxwjid/BeRG1XLBGHslRwElaWBsZ/mn6LjoJAQtkml2c
        SH2sLydouvS5C0HsvbdYeZLkHjTmcFf4a/jt7H2sg9WMZjZEB55gXf/lsyFdJvni
        Uf4OlfVHuxAKcZdyh9IwS7dIi6z9BHbYJt2cOtsnVBT1atWLSDPNMdHg7sPD989N
        82PetVNqe8NNEacSYxXFLN/vFhEb+fQ9udUsolp5pZUACCZjMDgd5yXippMXU3HH
        zLwf2gKj1oadM22rckdgPvgpXGm9oV5WEB6wUfO2uHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QwzVKI
        6tbra34TY6z9msluLBFLLDyCMl9KOPaMBmeK8=; b=OVL3/BdKpNr5udch4gDTyu
        0aIqgJpBFPMfbV++7uwtRL9RyeURuSz8QCv7ZetiHOU8yDDZBfmTm7eHod1rf7cL
        CXZa+6nTnofYMOgw21ZsNhlT1OFu2LnvYNo++GM/16ngkzXTOv+096ffY3izP0Yj
        KSwFKjeeT5X7nFHejSJvjrvBPHgkvZ+Ze2pxiz4bbgRRVKBInQ8/u4FCy2STC4/t
        YfY7xlT3zcCsQQmJ+5rUQA+eVvTuArYu0P1bI7nFSx3XmxOd7F4KceURu3jyDD9k
        AZlIZfSRmJqUxjsSbubtZRDhewU4az1s4tJQ7HGbea48QHexAFBEBWfx3KA+nXWw
        ==
X-ME-Sender: <xms:_u3MXUx5LkVzmiDz2KSWQRGojs1i6UrSeanc2L1teh4qVBvLgyTkVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefvddgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeduvdegrddvudelrdefud
    drleefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_u3MXfWDL7CWnv13zTr92-2piKG7RUXgt6PwEV0DDm8qAdVrIDkynw>
    <xmx:_u3MXeBub9qSdK5Q8FoVCJ9tRsDzh3OGqSAu09wpSaVX_8RmWKlibA>
    <xmx:_u3MXY4pnl_EUh6cB1XDE6FVRtMe3RDC2nOnw2FOkJrd6fJHorw5Xw>
    <xmx:_-3MXQ9nm12lyg17MUMbm1TFor1dsaE8s_DdB7uVi4A8ITf5p6gfDA>
Received: from localhost (unknown [124.219.31.93])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5772A3060062;
        Thu, 14 Nov 2019 01:02:38 -0500 (EST)
Date:   Thu, 14 Nov 2019 14:02:36 +0800
From:   Greg KH <greg@kroah.com>
To:     Andrew Donnellan <ajd@linux.ibm.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        npiggin@gmail.com, mpe@ellerman.id.au,
        Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH stable 4.4] powerpc/boot: Request no dynamic linker for
 boot wrapper
Message-ID: <20191114060236.GD353293@kroah.com>
References: <20191112065941.9548-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112065941.9548-1-ajd@linux.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 05:59:41PM +1100, Andrew Donnellan wrote:
> From: Nicholas Piggin <npiggin@gmail.com>
> 
> Commit ff45000fcb56b5b0f1a14a865d3541746d838a0a upstream.
> 
> The boot wrapper performs its own relocations and does not require
> PT_INTERP segment. However currently we don't tell the linker that.
> 
> Prior to binutils 2.28 that works OK. But since binutils commit
> 1a9ccd70f9a7 ("Fix the linker so that it will not silently generate ELF
> binaries with invalid program headers. Fix readelf to report such
> invalid binaries.") binutils tries to create a program header segment
> due to PT_INTERP, and the link fails because there is no space for it:
> 
>   ld: arch/powerpc/boot/zImage.pseries: Not enough room for program headers, try linking with -N
>   ld: final link failed: Bad value
> 
> So tell the linker not to do that, by passing --no-dynamic-linker.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> [mpe: Drop dependency on ld-version.sh and massage change log]
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> [ajd: backport to v4.4 (resolve conflict with a comment line)]
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> ---
>  arch/powerpc/boot/wrapper | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)

Now queud up, thanks.

greg k-h
