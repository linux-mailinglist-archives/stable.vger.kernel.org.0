Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFC031AB7C
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 14:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhBMNAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 08:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:32814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhBMNAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 08:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3792B64E3C;
        Sat, 13 Feb 2021 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613221208;
        bh=Cz2orqtp9R/X6eFbJi3BEio1pVXe1l7tT2SPS1n1dZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VjME+QqSd/NwaLbfecqxtpP/Ivntll97DtXqpuUazrx3IP9gMYTILIZA9aCRVSeFl
         RzlciUcDeetk2TKmCB0cr1aINaZeXiR6+3pGkYpg+664npLhBURfUYb7IFSazymWgt
         Iiv144ekNsDRNIsL8+NNQdcHb2nUJBkvwhHs2m14=
Date:   Sat, 13 Feb 2021 14:00:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Xi Ruoyao <xry111@mengyan1223.wang>
Cc:     stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miroslav Benes <mbenes@suse.cz>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
Message-ID: <YCfNVhB8D73RKnKV@kroah.com>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
 <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
 <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 09:32:03PM +0800, Xi Ruoyao wrote:
> Hi all,
> 
> The latest GNU assembler (binutils-2.36.1) is removing unused section symbols
> like Clang [1].  So linux-5.10.15 can't be built with binutils-2.36.1 now.  It
> has been reported as https://bugzilla.kernel.org/show_bug.cgi?id=211693.
> 
> I can confirm this commit fixes the issue.  It should be cherry-picked into
> stable branches, so the following stable releases will be able to built with
> latest GNU toolchain.
> 
> [1]: https://sourceware.org/pipermail/binutils/2020-December/114671.html
> 
> At last, happy new lunar year guys :).
> 
> On 2020-12-16 13:49 +0000, tip-bot2 for Josh Poimboeuf wrote:
> > The following commit has been merged into the objtool/urgent branch of tip:
> > 
> > Commit-ID:     44f6a7c0755d8dd453c70557e11687bb080a6f21

Now queued up for 5.10.y.

If people want it in older kernels, please provide a working backport.

thanks,

greg k-h
