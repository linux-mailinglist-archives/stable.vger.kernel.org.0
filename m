Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54113FD663
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243485AbhIAJUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243516AbhIAJUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 05:20:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8955261057;
        Wed,  1 Sep 2021 09:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630487944;
        bh=SHQ3q0JEokTHa2DFK3HypSExk+E7iew2ShPlX7D6bwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=udp/we3VbyjMCXUYGSzBBTTYKTasmQL2K0PzcbgnllHr1Y3yp83Lej6YM1G9yxoxt
         FK4PC74D4QCLbqWPHvyV01SKzaUmPVdEANpsTs8F4ddT0AlNO7zmL/DdIiEvUD2FL3
         jg4fo8tJc3OxGwxOEvTDos6aQhiTSsNOmAI2L7bs=
Date:   Wed, 1 Sep 2021 11:19:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.10.y 0/2] disable ftrace of sbi functions
Message-ID: <YS9Fhr4tKFLAd5ds@kroah.com>
References: <20210818123406.197638-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818123406.197638-1-dimitri.ledkov@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 01:34:04PM +0100, Dimitri John Ledkov wrote:
> One cannot ftrace functions used to setup ftrace. Doing so leads to a
> racy kernel panic as observed by users on SiFive HiFive Unmatched
> boards with Ubuntu kernels.
> 
> This has been debugged and fixed in v5.12 kernels by ensuring that all
> sbi functions are excluded from ftrace.
> 
> Link: https://forums.sifive.com/t/u-boot-says-unhandled-exception-illegal-instruction/4898/12
> BugLink: https://bugs.launchpad.net/bugs/1934548
> 
> Guo Ren (2):
>   riscv: Fixup wrong ftrace remove cflag
>   riscv: Fixup patch_text panic in ftrace
> 
>  arch/riscv/kernel/Makefile | 5 +++--
>  arch/riscv/mm/Makefile     | 3 ++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> -- 
> 2.30.2
> 

Now queued up, thanks.

greg k-h
