Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90B63E5323
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 07:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhHJF5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 01:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhHJF5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 01:57:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F2E660F55;
        Tue, 10 Aug 2021 05:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628575048;
        bh=X79xfSz4SuVY9S2KTYtnaTY3IgoH5MwOklojFs0LVhQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fs2rfBdYc6BE7/qyh3y3cGp6/WEvB5vdLEarlaIamyPGtZzhn+eMDG+FkO42r6Qs8
         4bk4wbLLaJid0g90E4Lt95umEAzHiAVnp9DHk0KoYOIeHgxYgShYc7yK7ND7v1MvA+
         8+5gAtY+ALnKBVp4rONQ9e2ACCDZNgQyXGZLK+hs=
Date:   Tue, 10 Aug 2021 07:57:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrew Delgadillo <adelg@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: clean vdso files
Message-ID: <YRIVRgxhvGJxfXYs@kroah.com>
References: <20210809191414.3572827-1-adelg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809191414.3572827-1-adelg@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 07:14:14PM +0000, Andrew Delgadillo wrote:
> commit a5b8ca97fbf8 ("arm64: do not descend to vdso directories twice")
> changes the cleaning behavior of arm64's vdso files, in that vdso.lds,
> vdso.so, and vdso.so.dbg are not removed upon a 'make clean/mrproper':
> 
> $ make defconfig ARCH=arm64
> $ make ARCH=arm64
> $ make mrproper ARCH=arm64
> $ git clean -nxdf
> Would remove arch/arm64/kernel/vdso/vdso.lds
> Would remove arch/arm64/kernel/vdso/vdso.so
> Would remove arch/arm64/kernel/vdso/vdso.so.dbg
> 
> To remedy this, manually descend into arch/arm64/kernel/vdso upon
> cleaning.
> 
> After this commit:
> $ make defconfig ARCH=arm64
> $ make ARCH=arm64
> $ make mrproper ARCH=arm64
> $ git clean -nxdf
> <empty>
> 
> Signed-off-by: Andrew Delgadillo <adelg@google.com>
> ---
>  arch/arm64/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
