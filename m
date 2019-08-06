Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06D482AC2
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 07:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbfHFFRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 01:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbfHFFRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 01:17:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBA372147A;
        Tue,  6 Aug 2019 05:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565068631;
        bh=t9g0NyRteN+/Mf2Nk1jPL7u+czYsHH5GImLgIJ3adbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=REKNBgzQpPCbxpbo4T21CE1eMyMHOCzn9jaQ2Xo4KAbz97+ynmh1dszHKM6G+PTsH
         gsCI8GiOfrsTRxk6enfIO3NUGKfkCHDEySlEoUbtaKNBOp106UGClxR5RLzSItd0PD
         TurbFmNWsMsJWXNN2Oi1NVyEoH7ZFspomnKxW3EQ=
Date:   Tue, 6 Aug 2019 07:17:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Araneda <luaraneda@gmail.com>
Cc:     linux@armlinux.org.uk, michal.simek@xilinx.com,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: zynq: smp improvements
Message-ID: <20190806051708.GB8525@kroah.com>
References: <20190806030718.29048-1-luaraneda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806030718.29048-1-luaraneda@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 11:07:16PM -0400, Luis Araneda wrote:
> This series adds support for kernel compiled in Thumb mode
> and fixes a kernel panic on smp bring-up when FORTIFY_SOURCE
> is enabled.
> 
> The series started with the second patch as an RFC, and
> the first patch were suggested on the review to complement
> the fix.
> 
> The changes were run-tested on a Digilent Zybo Z7 board
> 
> Luis Araneda (2):
>   ARM: zynq: support smp in thumb mode
>   ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up
> 
>  arch/arm/mach-zynq/headsmp.S | 2 ++
>  arch/arm/mach-zynq/platsmp.c | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> -- 
> 2.22.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
