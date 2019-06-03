Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5136932A28
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 09:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfFCH6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 03:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfFCH6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 03:58:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4515927D02;
        Mon,  3 Jun 2019 07:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559548698;
        bh=1f+G1a7AXh63QYPQUJX1OSkiCdWNuia8im8hLCbchXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TxgTPjiJT4GQd8YUZhT3MJD4CLiVlkrN+XqCz7EU6EUKyA9t+0SWrlhArvzOQhzA6
         PhpKqhUaWDXLVUNqKlVukX4FTubWTzQWLd0RLzLNQtkDfCCWN1n/nSZpQab4GPd1fx
         Jf3JhydhtFfJyolBfoNzpR4lPQ7P6nBKxHf72Tn0=
Date:   Mon, 3 Jun 2019 09:58:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH 4.19] include/linux/compiler*.h: define asm_volatile_goto
Message-ID: <20190603075816.GC7814@kroah.com>
References: <20190531055633.123516-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531055633.123516-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 10:56:34PM -0700, Nathan Chancellor wrote:
> From: "ndesaulniers@google.com" <ndesaulniers@google.com>
> 
> commit 8bd66d147c88bd441178c7b4c774ae5a185f19b8 upstream.
> 
> asm_volatile_goto should also be defined for other compilers that support
> asm goto.
> 
> Fixes commit 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h
> mutually exclusive").
> 
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
> 
> Hi Greg and Sasha,
> 
> Please pick up this patch for 4.19. It turns out that commit
> 13aceef06adf ("arm64: jump_label.h: use asm_volatile_goto macro instead
> of "asm goto"") was backported without this, which causes a build
> failure on arm64. This wasn't uncovered until now because clang didn't
> support asm goto so this code wasn't being compiled. Thankfully, that
> should change very soon :)

Now applied, thanks.

greg k-h
