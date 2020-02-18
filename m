Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD58161FD9
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 05:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgBRElj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 23:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgBRElj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Feb 2020 23:41:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C22C206EF;
        Tue, 18 Feb 2020 04:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582000898;
        bh=JzGyUK5s+Xd3824WcB4qIyixixuxdz4gtglByXpvgfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ux1LoDIlHmaigv9RYOYInpuV5yViqI6aE28AEbyE+WcITWjJUeFl7WtK9BlUCmXJK
         uUZai0Xg2Hm6zCJa1qPGkAg+PyhMWtzRpW+G9E7VCkn5WFlnVKnNjUksVZGGDKa7D2
         +v4LpuOOQIWYJZB0xOR8m4yfIAE1abl+wM+qi3kg=
Date:   Tue, 18 Feb 2020 05:41:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, gkulkarni@marvell.com,
        kamlakantp@marvell.com, prabhakar.pkin@gmail.com
Subject: Re: [RESEND][PATCH] ata: ahci: Add shutdown to freeze hardware
 resources of ahci
Message-ID: <20200218044136.GB2046752@kroah.com>
References: <1581992882-22134-1-git-send-email-pkushwaha@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581992882-22134-1-git-send-email-pkushwaha@marvell.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 06:28:02PM -0800, Prabhakar Kushwaha wrote:
> device_shutdown() called from reboot or power_shutdown expect
> all devices to be shutdown. Same is true for even ahci pci driver.
> As no ahci shutdown function is implemented, the ata subsystem
> always remains alive with DMA & interrupt support. File system
> related calls should not be honored after device_shutdown().
> 
> So defining ahci pci driver shutdown to freeze hardware (mask
> interrupt, stop DMA engine and free DMA resources).
> 
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
> 
> This problem has also been seen on older kernel. So sending to stable@vger.kernel.org 
> Note: It is already applied to git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> with commit id: 10a663a1b151 ("ata: ahci: Add shutdown to freeze hardware resources of ahci")

So what kernel(s) do you wish to have this commit backported to?

thanks,

greg k-h
