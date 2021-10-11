Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3481F428CED
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 14:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhJKMWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 08:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236510AbhJKMWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 08:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 911BE60F92;
        Mon, 11 Oct 2021 12:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633954853;
        bh=O1v1u7E8UAP3k+mDu9+5s1TbnAI3BHUhIizApwWiclg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eJE6GhD6qAQ3mfmOtKM2gB+jyxQwO7gHyKKVrOLT+VnyetB6V/zq1A01ygjvOJ5dX
         t6tQEkxCigeVho6AdC0aUBy/kqNjxe7xIXmIoGGKuhfioeno7Ruuw6Tg7aoHeLblzq
         fpvO5lXGdYI+WOOcVtD80QiOoMCU9NBXJuueGJ2M=
Date:   Mon, 11 Oct 2021 14:20:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH backport for v5.4 and before] x86/Kconfig: Correct
 reference to MWINCHIP3D
Message-ID: <YWQsIvmcLzlHhyZv@kroah.com>
References: <20211011120309.16365-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011120309.16365-1-lukas.bulwahn@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 02:03:09PM +0200, Lukas Bulwahn wrote:
> commit 225bac2dc5d192e55f2c50123ee539b1edf8a411 upstream.
> 
> Commit in Fixes intended to exclude the Winchip series and referred to
> CONFIG_WINCHIP3D, but the config symbol is called CONFIG_MWINCHIP3D.
> 
> Hence, scripts/checkkconfigsymbols.py warns:
> 
> WINCHIP3D
> Referencing files: arch/x86/Kconfig
> 
> Correct the reference to the intended config symbol.
> 
> Fixes: 69b8d3fcabdc ("x86/Kconfig: Exclude i586-class CPUs lacking PAE support from the HIGHMEM64G Kconfig group")
> Suggested-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: <stable@vger.kernel.org>
> Link: https://lkml.kernel.org/r/20210803113531.30720-4-lukas.bulwahn@gmail.com
> [manually adjusted the change to the state on the v4.19.y and v5.4.y stable tree]
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  arch/x86/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, now queued up.

greg k-h
