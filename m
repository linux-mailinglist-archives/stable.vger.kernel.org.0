Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7844508CD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 16:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhKOPpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 10:45:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236711AbhKOPoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 10:44:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ADE161504;
        Mon, 15 Nov 2021 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636990895;
        bh=Ij/IthWsUGTlIOkY5Tk2OGIyrHdlX8YFdv0VNHwfR8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AEoZgzfmG4b0rCt4pvcuXxWbi1WBvp7MJasBisYbyEuhdhBKMMAY3/AJztvJxpB10
         +Twj8R41BzDcelz5+H+S+goUs3i67HAhTXaiKE93Uro+z15uWnOyhwZETLf2EY2M0k
         8bLiqB9yCIutbmbiuo2/yfKfJn+8qZ6kYwWxfu5I=
Date:   Mon, 15 Nov 2021 16:41:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     stable <stable@vger.kernel.org>, xieyongji@bytedance.com
Subject: Re: FAILED: patch "[PATCH] fuse: truncate pagecache on
 atomic_o_trunc" failed to apply to 4.19-stable tree
Message-ID: <YZJ/rBXkC/THq2xB@kroah.com>
References: <1631532743204250@kroah.com>
 <CAOssrKd1=0vow0PBHf+d_5cLmiNUufM_LAmzJstErbP3HTHviw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKd1=0vow0PBHf+d_5cLmiNUufM_LAmzJstErbP3HTHviw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 03:41:15PM +0100, Miklos Szeredi wrote:
> On Mon, Sep 13, 2021 at 1:32 PM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hi Greg,
> 
> Attaching the backport of commit 76224355db75 ("fuse: truncate
> pagecache on atomic_o_trunc") to v4.19.217.

Now queued up, thanks.

greg k-h
