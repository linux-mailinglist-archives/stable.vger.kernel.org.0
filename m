Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA5E3E5718
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239166AbhHJJfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239150AbhHJJft (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 05:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 848456101E;
        Tue, 10 Aug 2021 09:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628588128;
        bh=MBZQmm8w9LdRps7yqd5+IQoZz2Itad64FjD2xHwKubw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v736+CdeBaG5d/3XLg6Jd5/WQXmMVqASJuYLP8BjbA6MQqB6FVZa5s0MJmMp+qGwV
         dvxW1fe9/nX2N3LJFI7wLV4b2O0UHGH/G5AXdR6p0rfIPdYhELxTKxxSxzmDx3wI3/
         e+w05vkArCBkV50Pz8FEOZu2L34sZbXECpA+Sxy0=
Date:   Tue, 10 Aug 2021 11:35:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Ghiti <alex@ghiti.fr>
Cc:     jszhang@kernel.org, kernel@esmil.dk, palmerdabbelt@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] riscv: Get rid of CONFIG_PHYS_RAM_BASE in
 kernel physical" failed to apply to 5.13-stable tree
Message-ID: <YRJIXUxK3vn7h+W3@kroah.com>
References: <1628505733235131@kroah.com>
 <7728bd11-a1b2-b980-fc71-108187660217@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7728bd11-a1b2-b980-fc71-108187660217@ghiti.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 10:26:31AM +0200, Alex Ghiti wrote:
> Hi Greg,
> 
> Le 9/08/2021 à 12:42, gregkh@linuxfoundation.org a écrit :
> > 
> > The patch below does not apply to the 5.13-stable tree.
> 
> I don't know when stable was cc on this patch, this fixes something
> introduced in 5.14-rc1, so this is not normal it can't be applied.
> 
> Sorry for the noise,
> 
> Alex
> 
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> >  From 6d7f91d914bc90a15ebc426440c26081337ceaa1 Mon Sep 17 00:00:00 2001
> > From: Alexandre Ghiti <alex@ghiti.fr>
> > Date: Wed, 21 Jul 2021 09:59:35 +0200
> > Subject: [PATCH] riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical
> >   address conversion
> > 
> > The usage of CONFIG_PHYS_RAM_BASE for all kernel types was a mistake:
> > this value is implementation-specific and this breaks the genericity of
> > the RISC-V kernel.
> > 
> > Fix this by introducing a new variable phys_ram_base that holds this
> > value at runtime and use it in the kernel physical address conversion
> > macro. Since this value is used only for XIP kernels, evaluate it only if
> > CONFIG_XIP_KERNEL is set which in addition optimizes this macro for
> > standard kernels at compile-time.
> > 
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > Tested-by: Emil Renner Berthing <kernel@esmil.dk>
> > Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
> > Fixes: 44c922572952 ("RISC-V: enable XIP")

But this commit id is in 5.13, is that incorrect?

Just verifying,

greg k-h
