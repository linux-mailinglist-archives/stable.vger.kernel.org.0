Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7A07BD3B
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGaJd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfGaJd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:33:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C651C20449;
        Wed, 31 Jul 2019 09:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564565638;
        bh=ys3QQ7mBgC1hoxTyKdlEiT3Rpn5J7V22GgaEZXLRSPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qy4a8Od4EgTISh7ZOuGC/694zyvY7ISKezYR2vOQf8GTK/EIGPhToVJ+TYjNwKHqM
         irPejz3OUnH29lYu0rpwGz5rnWWfAnmfe0ZR4o6E3oKVlt7BrIoWF4Q5Y3DV+IX/vC
         3mVxPTIm4cm8wyQBSy61stI7+mc05FN090K/EMes=
Date:   Wed, 31 Jul 2019 11:33:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qian Lu <luqia@amazon.com>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com,
        zhangliguang <zhangliguang@linux.alibaba.com>
Subject: Re: [PATCH 4/4] NFS: Remove redundant semicolon
Message-ID: <20190731093355.GD18269@kroah.com>
References: <20190731071327.28701-1-luqia@amazon.com>
 <20190731071327.28701-5-luqia@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731071327.28701-5-luqia@amazon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 12:13:27AM -0700, Qian Lu wrote:
> From: zhangliguang <zhangliguang@linux.alibaba.com>
> 
> commit 42f72cf368c502c435af4e206e26d651cfb7d9ad upstream.
> 
> This removes redundant semicolon for ending code.
> 
> Fixes: c7944ebb9ce9 ("NFSv4: Fix lookup revalidate of regular files")
> Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: <stable@vger.kernel.org> # 4.14.x
> Signed-off-by: Qian Lu <luqia@amazon.com>
> ---
>  fs/nfs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 85a6fdd76e20..9065db7c31eb 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -1635,7 +1635,7 @@ nfs4_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
>  reval_dentry:
>  	if (flags & LOOKUP_RCU)
>  		return -ECHILD;
> -	return nfs_lookup_revalidate_dentry(dir, dentry, inode);;
> +	return nfs_lookup_revalidate_dentry(dir, dentry, inode);

This is not needed in a stable kernel tree :(

