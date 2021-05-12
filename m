Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BF337BC44
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhELML1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230347AbhELML0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 08:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E7DC613F9;
        Wed, 12 May 2021 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620821418;
        bh=cFSy1UkboJ0ebyxh2J92Pm0TF4PthIIFy0ENTLpMKZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kcGZgEDV7VNzUUIcZZD+3i2vCVM2fMuCRwoJY4Fh9dSiym+wbAk5t5Xj0HjChY68f
         YyoI3a9wjHf9aSK+zGvYhTsPNCCKLRRpTwCEfySdp+nO8+MIz8+Q+wzsqfNPATtKSM
         RpFzfzgMZL6rxt0Zszvof4VPpfbFFAsaXuELwgI0=
Date:   Wed, 12 May 2021 14:10:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jian Cai <jiancai@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: Backport of 1139aeb1c521 for all supported stable branches
Message-ID: <YJvFpqMLM1HWbIyQ@kroah.com>
References: <YJmneuxxFWIrqyWN@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJmneuxxFWIrqyWN@archlinux-ax161>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 02:36:58PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please find attached backports of commit 1139aeb1c521 ("smp: Fix
> smp_call_function_single_async prototype") upstream, which resolves a
> serious looking clang warning seen across several different builds. It
> has been build tested with gcc and clang for x86_64 defconfig and
> allmodconfig.
> 
> Please let me know if there are any problems.

Now queued up, thanks.

greg k-h
