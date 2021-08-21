Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCED3F3A66
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 13:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhHUL3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Aug 2021 07:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhHUL3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Aug 2021 07:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4564F61165;
        Sat, 21 Aug 2021 11:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629545347;
        bh=bJg2pdf4UqWjSbz8+l7/DuqJBwKVFvf2hKw22jJOrRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tWVjziVKJ3eYn6Ai7lkpUSxybglwl+FD6CIaM9XrG7zRoY4gG7Lj2e9GtK1F0r3ZH
         +EYMzYxDE2BYiIdv1mcPDaeAx4Y7iEAvVfYben8CzjWv6CbBBECP5KmWan8M03I43v
         lMrE2o/GFhZ80tp2GkvpM1ypyIwdAWBYSK2SICYc=
Date:   Sat, 21 Aug 2021 13:29:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, miklos@szeredi.hu,
        Murphy Zhou <jencce.kernel@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH] ovl: add splice file read write helper
Message-ID: <YSDjf8yeYkkMQty9@kroah.com>
References: <20210820195929.1926705-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820195929.1926705-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 07:59:29PM +0000, Leah Rumancik wrote:
> From: Murphy Zhou <jencce.kernel@gmail.com>
> 
> Now overlayfs falls back to use default file splice read
> and write, which is not compatiple with overlayfs, returning
> EFAULT. xfstests generic/591 can reproduce part of this.
> 
> Tested this patch with xfstests auto group tests.
> 
> [ Needed in 5.4 to fix a deadlock triggered via
>   xfstests overlay/019 -- Leah Rumancik ]
> 
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/file.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
