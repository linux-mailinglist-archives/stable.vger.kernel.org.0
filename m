Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0BB342BB2
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhCTLMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhCTLMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D23D61A40;
        Sat, 20 Mar 2021 10:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616237832;
        bh=3FOCqsLXP7+1KVCA86kmY+oaELLkWkU2fxbEuFLQ0sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T/rSoy6GgOIbvIukcPwijvdFkYkGgRpIpQoCCgYINlVT63i0w/r5mEqpv2cPAT5d5
         Yv8E5b5Vuy0kSzAijIF1j7Geax+p87UowTKVLZjVFvBCYcsGYbsr04GNNw9SHdNXGz
         sPJdDJTgKTMudtMVljUOP9IAPmzh6PUU0SBPVtHQ=
Date:   Sat, 20 Mar 2021 11:57:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nicolas Boichat <drinkcat@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Axtens <dja@axtens.net>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [for-stable-4.19 PATCH v2 0/2] Backport patches to fix
 KASAN+LKDTM with recent clang on ARM64
Message-ID: <YFXVBXuXRkug2Esi@kroah.com>
References: <20210320041626.885806-1-drinkcat@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320041626.885806-1-drinkcat@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 20, 2021 at 12:16:24PM +0800, Nicolas Boichat wrote:
> Backport 2 patches that are required to make KASAN+LKDTM work
> with recent clang (patch 2/2 has a complete description).
> Tested on our chromeos-4.19 branch.
> Also compile tested on x86-64 and arm64 with gcc this time
> around.
> 
> Patch 1/2 adds a guard around noinstr that matches upstream,
> to prevent a build issue, and has some minor context conflicts.
> Patch 2/2 is a clean backport.
> 
> These patches have been merged to 5.4 stable already. We might
> need to backport to older stable branches, but this is what I
> could test for now.

Ok, trying this again, let's see what breaks :)

thanks,

greg k-h
