Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CE52A893D
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 22:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbgKEVvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 16:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbgKEVvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 16:51:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2252206CB;
        Thu,  5 Nov 2020 21:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604613099;
        bh=9RQtiC/LynC/lQ8bkCbkPcyVDImgWtOHNtI5dRYEGGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OXGOq15AhU5kKqUe75UgCd+hW2mfmrh0+SF+K0iH18Dy3VClCGHGgWkoJyFU9JgYQ
         FUhnaauAh0rYDjIT6hURxJarBicAqs0XcGIifPjgT4fzd2m3QJBhDM6jHZzPFs+wah
         hpqwkIjdkMLaaU0apF/X7CrOUqXp2RgnujILRr1k=
Date:   Thu, 5 Nov 2020 22:52:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jian Cai <jiancai@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dmitry Golovin <dima@golovin.in>, Borislav Petkov <bp@suse.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>, mbenes@suse.cz,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>
Subject: Re: Patches for building kernel 5.4 with LLVM's integrated assembler
Message-ID: <20201105215226.GC2123793@kroah.com>
References: <CA+SOCLJMyUZ8c0e5xkvm+r0pMxBoUxmQRaoasKOS2T28Z10Ziw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+SOCLJMyUZ8c0e5xkvm+r0pMxBoUxmQRaoasKOS2T28Z10Ziw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 02:51:32PM -0800, Jian Cai wrote:
> Dear Stable kernel maintainers,
> 
> Please consider cherry picking the following commits (ordered by commit
> time) ino linux-5.4.y.
> 
> ffedeeb780dc linkage: Introduce new macros for assembler symbols
> 
> 35e61c77ef38 arm64: asm: Add new-style position independent function
> annotations
> 
> 3ac0f4526dfb arm64: lib: Use modern annotations for assembly functions
> 
> ec9d78070de9 arm64: Change .weak to SYM_FUNC_START_WEAK_PI for
> arch/arm64/lib/mem*.S
> 
> The first three are required to apply the last patch. This would unblock
> Chrome OS to build with LLVM's integrated assembler (Please see
> http://crbug.com/1143847 for details).

I've done this, but does this also provide this functionality for x86?

thanks,

greg k-h
