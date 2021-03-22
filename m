Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49172343B75
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCVIQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhCVIPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 04:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 245986192A;
        Mon, 22 Mar 2021 08:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616400944;
        bh=SirvrN58DWFP+GDiA//KzYSrkY4d0+DAvCIrJWxyZbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cPJhCHAJ3tFCDXV5QIFo6T7TOAYZzwESiu8xd2AugdJX4vn4IdE81sDd6CWMohtyH
         1nEkLfu3iXGRrQ3hfjAoBhYADv+ENevvyPwCfXZnevDQH/gz3R5zJCsOm0eHaDlzPl
         47AI3XKlCSTyg2KVV2+FjCpLeYZQZsB4FPzVK2e8=
Date:   Mon, 22 Mar 2021 09:15:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.10 267/290] powerpc: Fix missing declaration of
 [en/dis]able_kernel_vsx()
Message-ID: <YFhSLhW5Hy2MeVVx@kroah.com>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135551.044220754@linuxfoundation.org>
 <CAMuHMdUqDX8NSGNsw4R=-pEk+nNRsBPBhXD91bq4qy-v1ybcJQ@mail.gmail.com>
 <fed84796-e3b4-47fc-7f5f-57d53565aa73@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fed84796-e3b4-47fc-7f5f-57d53565aa73@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 07:16:25AM +0100, Christophe Leroy wrote:
> 
> 
> Le 15/03/2021 à 15:15, Geert Uytterhoeven a écrit :
> > On Mon, Mar 15, 2021 at 3:04 PM <gregkh@linuxfoundation.org> wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > From: Christophe Leroy <christophe.leroy@csgroup.eu>
> > > 
> > > commit bd73758803c2eedc037c2268b65a19542a832594 upstream.
> > > 
> > > Add stub instances of enable_kernel_vsx() and disable_kernel_vsx()
> > > when CONFIG_VSX is not set, to avoid following build failure.
> > 
> > Please note that this is not sufficient, and will just turn the build error
> > in another, different build error.
> 
> Not exactly, the fix is sufficient in most case, it is only with ancient
> versions of gcc (eg 4.9) or with CONFIG_CC_OPTIMISE_FOR_SIZE that we now get
> a build bug. Building with gcc 10 now works.
> 
> > Waiting for the subsequent fix to enter v5.12-rc4...
> > https://lore.kernel.org/lkml/2c123f94-ceae-80c0-90e2-21909795eb76@csgroup.eu/
> 
> This has now landed in mainline as commit
> eed5fae00593ab9d261a0c1ffc1bdb786a87a55a see https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/powerpc/include/asm/cpu_has_feature.h?h=v5.12-rc4&id=eed5fae00593ab9d261a0c1ffc1bdb786a87a55a

Now queued up, thanks.

greg k-h
