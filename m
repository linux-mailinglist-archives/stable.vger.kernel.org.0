Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8965C29E9EE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgJ2LEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgJ2LEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:04:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6175220754;
        Thu, 29 Oct 2020 11:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603969450;
        bh=qibV5zwWbW1Gt4xCaFTElwQoaSFfCZCRU50jD77fASw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pJwoIxIiFO4fDZ9Ipde+VTs3F6pcn5AR20PyGkQisJVurM0irzlLvZT/aBULIwJIc
         NYaV3ekzu70L5wrLvO4vVqFYfXwdvvSc+DfrmCOdA0YdpCjkFxqlhimluXjNOQ50xf
         WItc0uccKKK91302UbAhK2DhAnN8qWn1Ju4Iqd9o=
Date:   Thu, 29 Oct 2020 12:04:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, Jian Cai <jiancai@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dmitry Golovin <dima@golovin.in>, Borislav Petkov <bp@suse.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>, mbenes@suse.cz
Subject: Re: LLVM_IAS=1 x86_64 patches for 5.4 and 4.19
Message-ID: <20201029110459.GE3840801@kroah.com>
References: <CAKwvOdn78WAUiRtyPxW7oEhUz8GN6MkL=Jt+n17jEQXPPZE77g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdn78WAUiRtyPxW7oEhUz8GN6MkL=Jt+n17jEQXPPZE77g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 04:29:17PM -0700, Nick Desaulniers wrote:
> Dear Stable kernel maintainers,
> Please consider cherry picking
> 
> commit e81e07244325 ("objtool: Support Clang non-section symbols in
> ORC generation")
> 
> to linux-5.4.y and linux-4.19.y.  This allows us to use LLVM_IAS=1 for
> x86_64 Android kernel builds without warning.
> 
> Its partner patch (8782e7cab51b6b) was already backported to
> linux-5.4.y as 8c627d4b15de9, and linux-4.19.y as 6e575122cd956.
> 
> https://github.com/ClangBuiltLinux/linux/issues/669
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e81e0724432542af8d8c702c31e9d82f57b1ff31

Now queued up, thanks.

greg k-h
