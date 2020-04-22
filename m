Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309DA1B3A17
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 10:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgDVIa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 04:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgDVIa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 04:30:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CD9E206B9;
        Wed, 22 Apr 2020 08:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587544228;
        bh=hpiBMzNRzZbf9IVQPFpfRT5pC8SY/Z/oyA3qrXR6Wb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SCbrm/o9Xe+IPzcQlho1XmeRMDC5sPMT0LJcfDT9TqvgS+/yBb7PCjRofHFeahh/n
         YcjjNuQsW/N1iDsoH0NHh+p7IUHkOT6ecjW2BVTdRsY+VdOIkxEAEXD929mUAJrAQ9
         raj2lOmkvA/L3vb6FPoWUJLll1gzQpOe5KUzV7bI=
Date:   Wed, 22 Apr 2020 10:30:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, Samuel Neves <sneves@dei.uc.pt>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH  for 4.4 and 4.9] x86/vdso: Fix lsl operand order
Message-ID: <20200422083025.GB3017981@kroah.com>
References: <20200422050428.1110192-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422050428.1110192-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 02:04:28PM +0900, Nobuhiro Iwamatsu wrote:
> From: Samuel Neves <sneves@dei.uc.pt>
> 
> commit e78e5a91456fcecaa2efbb3706572fe043766f4d upstream.
> 
> In the __getcpu function, lsl is using the wrong target and destination
> registers. Luckily, the compiler tends to choose %eax for both variables,
> so it has been working so far.
> 
> Fixes: a582c540ac1b ("x86/vdso: Use RDPID in preference to LSL when available")
> Signed-off-by: Samuel Neves <sneves@dei.uc.pt>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Andy Lutomirski <luto@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://lkml.kernel.org/r/20180901201452.27828-1-sneves@dei.uc.pt
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  arch/x86/include/asm/vgtod.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Good catch, now queued up, thanks.

greg k-h
