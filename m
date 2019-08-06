Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1080A82AC6
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 07:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731568AbfHFFRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 01:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfHFFRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 01:17:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D97F2147A;
        Tue,  6 Aug 2019 05:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565068639;
        bh=Gx5uSt/sYnvCcyG+tEybLFzNUAO0M+4D5ABXPzmpRVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I9sf3PA9DTJc+/mPn59TBlyh8/QisNcIYi8MNQmYQU1qXx43Kl9lAs6u9PTr5LYkA
         2YLFnng4ERnv4NggJKt6jslhD5t0247zy4UD8bNn8EzyZNPo6FVDixAJ21o5+d/c5O
         3wIOT2cTf6H9gilQHKt9uQNMWm372CuQIROuB2HA=
Date:   Tue, 6 Aug 2019 07:17:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Araneda <luaraneda@gmail.com>
Cc:     linux@armlinux.org.uk, michal.simek@xilinx.com,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: zynq: Use memcpy_toio instead of memcpy on smp
 bring-up
Message-ID: <20190806051717.GC8525@kroah.com>
References: <20190806030718.29048-1-luaraneda@gmail.com>
 <20190806030718.29048-3-luaraneda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806030718.29048-3-luaraneda@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 11:07:18PM -0400, Luis Araneda wrote:
> This fixes a kernel panic (read overflow) on memcpy when
> FORTIFY_SOURCE is enabled.
> 
> The computed size of memcpy args are:
> - p_size (dst): 4294967295 = (size_t) -1
> - q_size (src): 1
> - size (len): 8
> 
> Additionally, the memory is marked as __iomem, so one of
> the memcpy_* functions should be used for read/write
> 
> Signed-off-by: Luis Araneda <luaraneda@gmail.com>
> ---
>  arch/arm/mach-zynq/platsmp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
