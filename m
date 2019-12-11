Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8108F11A547
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 08:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfLKHoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 02:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfLKHoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 02:44:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67AF120637;
        Wed, 11 Dec 2019 07:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576050283;
        bh=ZuAU5be4qPQdbwFzHFL1JYNpx9aOpGRnNoEqu23egts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qWjZGzu0wtMXb4AwOWR4UDh7DsnBjggDVmgGJwkcRsvYvK2h+P2z2y/eg9ttqpY3H
         j0JaW+E/UCj9VmB5doricAVhY7xM9XAR/467JXvfYJuzUSh9ziOk5DNWcYF2Em4ev3
         GJz1XQfzewUkCRRZl6q0KgqcXDfZeuflmX/F2QaI=
Date:   Wed, 11 Dec 2019 08:44:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kusanagi Kouichi <slash@ac.auone-net.jp>
Subject: Re: [PATCH AUTOSEL 4.9 85/91] debugfs: Fix !DEBUG_FS
 debugfs_create_automount
Message-ID: <20191211074441.GC398293@kroah.com>
References: <20191210223035.14270-1-sashal@kernel.org>
 <20191210223035.14270-85-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210223035.14270-85-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 05:30:29PM -0500, Sasha Levin wrote:
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

This patch is only needed for 5.4 and newer kernels.  No need to
backport it anywhere, please drop it from all of these trees.

thanks,

greg k-h
