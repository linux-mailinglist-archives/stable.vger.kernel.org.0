Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5F411A561
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 08:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfLKHtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 02:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbfLKHtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 02:49:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F90920637;
        Wed, 11 Dec 2019 07:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576050591;
        bh=R8xb3t+ArVEuYoNcm/ebZJ5NkWgaEDaTMVvtwQ3VB7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FQPBSYz0tfrWCsMCI3R4kbcFXipoNuDau3/mxRHInAWMzpGNxyXTbAfqaDFI+Y1Il
         aG2mQZQWi6MXwGNxpLu35fM4lPdMB5izeuL9TpntIGBZGj6Ps4ZL2Yk7GTjPRGSIlD
         R3LqUjIpFdyUiCQ+19vMaqm6QzhHOA+mZk8oRTuI=
Date:   Wed, 11 Dec 2019 08:49:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kusanagi Kouichi <slash@ac.auone-net.jp>
Subject: Re: [PATCH AUTOSEL 5.4 328/350] debugfs: Fix !DEBUG_FS
 debugfs_create_automount
Message-ID: <20191211074949.GI398293@kroah.com>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-289-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210210735.9077-289-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 04:07:13PM -0500, Sasha Levin wrote:
> From: Kusanagi Kouichi <slash@ac.auone-net.jp>
> 
> [ Upstream commit 4250b047039d324e0ff65267c8beb5bad5052a86 ]
> 
> If DEBUG_FS=n, compile fails with the following error:
> 
> kernel/trace/trace.c: In function 'tracing_init_dentry':
> kernel/trace/trace.c:8658:9: error: passing argument 3 of 'debugfs_create_automount' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  8658 |         trace_automount, NULL);
>       |         ^~~~~~~~~~~~~~~
>       |         |
>       |         struct vfsmount * (*)(struct dentry *, void *)
> In file included from kernel/trace/trace.c:24:
> ./include/linux/debugfs.h:206:25: note: expected 'struct vfsmount * (*)(void *)' but argument is of type 'struct vfsmount * (*)(struct dentry *, void *)'
>   206 |      struct vfsmount *(*f)(void *),
>       |      ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
> 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
> Link: https://lore.kernel.org/r/20191121102021787.MLMY.25002.ppp.dion.ne.jp@dmta0003.auone-net.jp
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/debugfs.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)


Not needed here either, this is a 5.5-rc1 only issue.

thanks,

greg k-h
