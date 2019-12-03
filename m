Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F810FD8B
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfLCMZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:25:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfLCMZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 07:25:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F5C320684;
        Tue,  3 Dec 2019 12:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575375924;
        bh=mqSfcHXhBbJxxombjupI9PkM139O3uHhvAJNFahX9nY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OimR7FXWKXoDmPiUD8BgYZU3uIkZ/o2yAgPb5W5//tZrvJz6JICKRqFCq+5J6VfSu
         nOTce0bzB2ZRfrSffXrgWMdwVGR53pW74wVU/sRi1CeTx2shsVUVyBQE6Z0crJ4br9
         bQVC40dyhZMqVkON0pDV4/uw7XJiRC1ALG5PUDeM=
Date:   Tue, 3 Dec 2019 13:25:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: elf_hwcap: Export userspace ASEs
Message-ID: <20191203122522.GA2131225@kroah.com>
References: <20191030090214.GA628862@kroah.com>
 <20191030132224.15731-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030132224.15731-1-jiaxun.yang@flygoat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 30, 2019 at 09:22:24PM +0800, Jiaxun Yang wrote:
> A Golang developer reported MIPS hwcap isn't reflecting instructions
> that the processor actually supported so programs can't apply optimized
> code at runtime.
> 
> Thus we export the ASEs that can be used in userspace programs.
> 
> Reported-by: Meng Zhuo <mengzhuo1203@gmail.com>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: linux-mips@vger.kernel.org
> Cc: Paul Burton <paul.burton@mips.com>
> Cc: <stable@vger.kernel.org> # 4.14+
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> ---
>  arch/mips/include/uapi/asm/hwcap.h | 11 ++++++++++
>  arch/mips/kernel/cpu-probe.c       | 33 ++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)

This fails to apply to the current 4.14.y tree:

	checking file arch/mips/include/uapi/asm/hwcap.h
	Hunk #1 FAILED at 6.
	1 out of 1 hunk FAILED
	checking file arch/mips/kernel/cpu-probe.c
	Hunk #1 succeeded at 2076 (offset -104 lines).

Can you refresh it and resend?  Also remember to include the git id that
this patch is in Linus's tree, I had to look it up by hand :(

thanks,

greg k-h
