Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6073B414A
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFYKSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhFYKSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5751A61438;
        Fri, 25 Jun 2021 10:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624616187;
        bh=1pBGwzfSL3AsY3rnyqSAdZDzbIru1Ghaqo1DmWpKjpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8dpOJDOTIh9jQxjgsIIkgC6a+3be8xCsqCVmXACCz9wROgJXieL9RXv1201HaMQL
         It2UELZrthuLLUCgw2w62UybRnOiAGtjR9ngxdL+qP1Uoarp0bzQJ4tZuo2H4ZGIHx
         2IyvX6hcZ2H4ZciW6L0J8UpX1tju7xKdAcE7Fgso=
Date:   Fri, 25 Jun 2021 12:16:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alan Modra <amodra@gmail.com>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH stable-v5.4 v2 0/2] properly cope with -z norelro
Message-ID: <YNWs+X0DMKJIN+LD@kroah.com>
References: <20210625154737.3d64a434@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625154737.3d64a434@xhacker.debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 25, 2021 at 03:47:37PM +0800, Jisheng Zhang wrote:
> Fix below build warning:
> aarch64-linux-gnu-ld: warning: -z norelro ignored
> 
> Since v1
>   - Backport a preparation patch as pointed out by Nick Desaulniers
> 
> Nick Desaulniers (1):
>   arm64: link with -z norelro for LLD or aarch64-elf
> 
> Sami Tolvanen (1):
>   kbuild: add CONFIG_LD_IS_LLD
> 
>  arch/arm64/Makefile | 10 +++++++---
>  init/Kconfig        |  3 +++
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> -- 
> 2.32.0
> 

Took this series instead, thanks.

greg k-h
