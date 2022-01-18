Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17C54929C5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 16:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiARPjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 10:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345870AbiARPjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 10:39:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF39C06161C;
        Tue, 18 Jan 2022 07:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09D986126B;
        Tue, 18 Jan 2022 15:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB587C00446;
        Tue, 18 Jan 2022 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642520346;
        bh=lDFlTAu1rkC7uevB5Ck9hgyZyVzp8qCoWOBwOfayl58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zoXkiHyDhKskZywLJKADiQf9gh2tpWzvaxPtPsfe477lZe+BR50wrIC0QGc21jR5N
         o9dVTaNt7Xfp74vzLiDKfpqdMzx8IPx3b+3LghaAMfSffT2+moLxAVcmPkexZ2qFhG
         b7F39+G7bX7Ph3Uyran0P5bsQm9BBqASazVScF5E=
Date:   Tue, 18 Jan 2022 16:39:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: backport patches to linux-5.4.y+
Message-ID: <YebfF2vnkVuIBoYW@kroah.com>
References: <CADYN=9LE7-9BHPEJBtL2sXChv2OfRcJTQnG+_Ug3HWAouBwHUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9LE7-9BHPEJBtL2sXChv2OfRcJTQnG+_Ug3HWAouBwHUQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 03:52:41PM +0100, Anders Roxell wrote:
> Hi,
> 
> Can these two patches be backported please?
> 
> 603362b4a583 ("mtd: fixup CFI on ixp4xx") to v5.4+

Now done.

> 28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on
> !LD_IS_LLD") to v5.4+

This was already in 5.10+

> 
> Patch 603362b4a583 ("mtd: fixup CFI on ixp4xx") solves:
> 
> drivers/mtd/maps/ixp4xx.c:57:4: error: CONFIG_MTD_CFI_BE_BYTE_SWAP required
> #  error CONFIG_MTD_CFI_BE_BYTE_SWAP required
>    ^
> 1 error generated.
> 
> Patch 28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on
> !LD_IS_LLD") solves:
> 
> ld.lld: error: arch/arm/common/dmabounce.o:(.rodata.str1.1): offset is
> outside the section
> make[2]: *** [scripts/Makefile.build:262: arch/arm/common/dmabounce.o] Error 1
> make[2]: *** Deleting file 'arch/arm/common/dmabounce.o'
> make[2]: Target '__build' not remade because of errors.

thanks,

greg k-h
