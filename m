Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC21F341A0E
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 11:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCSKbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 06:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhCSKa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 06:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C39BD64F6A;
        Fri, 19 Mar 2021 10:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616149856;
        bh=Z8G9b0YhKmHAC/dsDd8uBtltIE2j/sLVWNIpgG6WJJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xujaYl2UO4yAhjivMeasc/K7AMKAZYukltlPK9eUV2Hk6vPFir8C5ZUKniVfiMWFY
         5s5N24LbdQ/U8UWyJD7Jx77v72RE1V1dtZuM1f7GiBsvXxApyzhPEJ3JVLwsyoCpDi
         Ecf4p8l2BM3aylZmvJyOPMEwpFmHHLKtCysblAPw=
Date:   Fri, 19 Mar 2021 11:30:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nicolas Boichat <drinkcat@chromium.org>
Cc:     stable@vger.kernel.org,
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
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [for-stable-4.19 PATCH 0/2] Backport patches to fix KASAN+LKDTM
 with recent clang on ARM64
Message-ID: <YFR9XavlXEL6Z/7l@kroah.com>
References: <20210318235416.794798-1-drinkcat@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318235416.794798-1-drinkcat@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 07:54:14AM +0800, Nicolas Boichat wrote:
> 
> Backport 2 patches that are required to make KASAN+LKDTM work
> with recent clang (patch 2/2 has a complete description).
> Tested on our chromeos-4.19 branch.
> 
> Patch 1/2 is context conflict only, and 2/2 is a clean backport.
> 
> These patches have been merged to 5.4 stable already. We might
> need to backport to older stable branches, but this is what I
> could test for now.

Both now queued up, thanks.

greg k-h
