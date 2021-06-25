Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7EA3B4129
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhFYKMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhFYKMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:12:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D03D761428;
        Fri, 25 Jun 2021 10:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624615831;
        bh=+md3nZ7V/ZsVebLt8CgqdAuGKz7TMOszMUfPjqMwNUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ro7vdmrt1MJMUw8Ba1dWZo+Ris+OOKy3eed+x6QUyp6GMkXXiYFO0dlG7FIMZRxi5
         dOWPCOGhCJvgHhIfWPdGaVn1N5SXS5edhgD8D5znEOH9bwzIzLqqsTQq1aN2wl/R5X
         yn6gY9Q+NF/pQSWsX5iAqeCa3JRHhWE9DZ2ayQV0=
Date:   Fri, 25 Jun 2021 12:10:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH 4.4 to 4.19] Makefile: Move -Wno-unused-but-set-variable
 out of GCC only block
Message-ID: <YNWrlag5xpdpBMM8@kroah.com>
References: <20210623172610.3281050-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623172610.3281050-1-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 10:26:12AM -0700, Nathan Chancellor wrote:
> commit 885480b084696331bea61a4f7eba10652999a9c1 upstream.
> 
> Currently, -Wunused-but-set-variable is only supported by GCC so it is
> disabled unconditionally in a GCC only block (it is enabled with W=1).
> clang currently has its implementation for this warning in review so
> preemptively move this statement out of the GCC only block and wrap it
> with cc-disable-warning so that both compilers function the same.
> 
> Cc: stable@vger.kernel.org
> Link: https://reviews.llvm.org/D100581
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> [nc: Backport, workaround lack of e2079e93f562 in older branches]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
