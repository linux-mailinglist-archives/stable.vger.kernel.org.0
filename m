Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03E62FCEC4
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732235AbhATLDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 06:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388432AbhATK5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 05:57:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F3221744;
        Wed, 20 Jan 2021 10:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611140200;
        bh=OYFRAwd3gT7bEDrOZi95CsYSNSXoqeY8zn/QOuX0+ng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8e1lPmam/lRJr1NeMyGYEIakzHeGw+EeWPTLAV2EY8d/cojh9tGaidx5BdFwEvcw
         WoR/TEypySJskOAtm4U1qx6xqwkce5iUxjOrEfNgvPjA0MI+naftEyNHB0LpsSnEfE
         aS7fSHuLWH6k4RrDGl93MEhITDG8chuPu5jCIi5Q=
Date:   Wed, 20 Jan 2021 11:56:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Florian Weimer <fweimer@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [STABLE BACKPORT 4.19.y and 5.14.y] compiler.h: Raise minimum
 version of GCC to 5.1 for arm64
Message-ID: <YAgMZWAyaDs3CT+o@kroah.com>
References: <20210118135700.17447-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118135700.17447-1-will@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 01:57:00PM +0000, Will Deacon wrote:
> commit dca5244d2f5b94f1809f0c02a549edf41ccd5493 upstream.
> 
> GCC versions >= 4.9 and < 5.1 have been shown to emit memory references
> beyond the stack pointer, resulting in memory corruption if an interrupt
> is taken after the stack pointer has been adjusted but before the
> reference has been executed. This leads to subtle, infrequent data
> corruption such as the EXT4 problems reported by Russell King at the
> link below.
> 
> Life is too short for buggy compilers, so raise the minimum GCC version
> required by arm64 to 5.1.
> 
> Reported-by: Russell King <linux@armlinux.org.uk>
> Suggested-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: <stable@vger.kernel.org> # 4.19.y and 5.4.y only

All now queued up, thanks!

greg k-h
