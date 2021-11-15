Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86D545045A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhKOM1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 07:27:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230436AbhKOM1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 07:27:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7CD96324D;
        Mon, 15 Nov 2021 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636979077;
        bh=l9i0NhzoJVxcOFKQae7XL9EhbQgCfcdhOlemu/kR5H0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gm8CQ423XJhmWaIKP1oD8hrfPua2bqUYaunAW8qPEIUc4Q8MOBGZ/0DSKsNLV8gvK
         z25r1EQG/utfkLxc+DXh5vjxOeNPvftWvT6LYMzey69WJV7uv6yFwKekzs9ocoGXlX
         Eq5QSpmj5uX91RefHQkD742eSSRTIsvebp9No9Tk=
Date:   Mon, 15 Nov 2021 13:24:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     fdinoff@google.com, stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] fuse: fix page stealing" failed to apply
 to 4.4-stable tree
Message-ID: <YZJRgvuscU81Av2x@kroah.com>
References: <16368092531141@kroah.com>
 <CAOssrKdxG4WAm_XMdQv42ht79Y6UJ2RmBb08ZKTaTQSmOu_=mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKdxG4WAm_XMdQv42ht79Y6UJ2RmBb08ZKTaTQSmOu_=mA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 11:52:16AM +0100, Miklos Szeredi wrote:
> On Sat, Nov 13, 2021 at 2:14 PM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> 
> Hi Greg,
> 
> Attaching tested backport of 712a951025c0 ("fuse: fix page stealing")
> to v4.4.292.

Now queued up, thanks!

greg k-h
