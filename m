Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9CB82AC8
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 07:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfHFFR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 01:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfHFFR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 01:17:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88A982147A;
        Tue,  6 Aug 2019 05:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565068649;
        bh=mIX7WQg12oxFi0EYT0MjTjIjoQDsLIyCeV8XnPtZB5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JE2EwKSk0DmNy5DMoqIM86yzYzj1gpF+ja1+ZC2r5FbLY/r4b4EQLZSBdQr3YPlFE
         H9rNQR9nJeiLgiQ2Xu26ZW5GTjLcLLYcz/5AlkWtJz0QYlMSjxoCsVO+r1XzyF00qe
         2iZrvWVG/YRMZjO26D7MV+3+TfRH0rOpw0anFJIo=
Date:   Tue, 6 Aug 2019 07:17:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Araneda <luaraneda@gmail.com>
Cc:     linux@armlinux.org.uk, michal.simek@xilinx.com,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: zynq: support smp in thumb mode
Message-ID: <20190806051726.GD8525@kroah.com>
References: <20190806030718.29048-1-luaraneda@gmail.com>
 <20190806030718.29048-2-luaraneda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806030718.29048-2-luaraneda@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 11:07:17PM -0400, Luis Araneda wrote:
> Add .arm directive to headsmp.S to ensure that the
> CPU starts in 32-bit ARM mode and the correct code
> size is copied on smp bring-up
> 
> Additionally, start secondary CPUs on secondary_startup_arm
> to automatically switch from ARM to thumb on a thumb kernel
> 
> Suggested-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Luis Araneda <luaraneda@gmail.com>
> ---
>  arch/arm/mach-zynq/headsmp.S | 2 ++
>  arch/arm/mach-zynq/platsmp.c | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
