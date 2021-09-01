Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDA83FD528
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 10:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbhIAITp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 04:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhIAITo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 04:19:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B2596103A;
        Wed,  1 Sep 2021 08:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630484327;
        bh=cSYA4sYNLTHVUZnVODL1Pu9ZQg2ARtf7ANGW/ypmKPs=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Gxp0cJF10zPWfg0PQG7JlT0fbRQquP6uhOf1Ptz30D9zhBg7coGPpIHZ+sMuve4ie
         A6Qw2jbDP4+SVILStNgxYa7X80sb6LZuHe+vjwrXHQua/bGfDQInIkA7IKtokxaPh+
         b3oMwxRdhb7cBn1NxUNnhXBNhCdIrNE2A2tWZTiA=
Date:   Wed, 1 Sep 2021 10:18:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     dsterba@suse.cz, wqu@suse.com, ce3g8jdj@umail.furryterror.org,
        dsterba@suse.com, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "btrfs: compression: don't try to
 compress if we don't" failed to apply to 5.4-stable tree
Message-ID: <YS83Zf1OaAZUIQ06@kroah.com>
References: <16302200512317@kroah.com>
 <20210830130949.GB3379@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830130949.GB3379@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 03:09:49PM +0200, David Sterba wrote:
> On Sun, Aug 29, 2021 at 08:54:11AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> The code in versions from 5.4 to 4.4 is the same and the merge conflict
> can be resolved from that (eg. from file
> stable.git/releases/./5.4.136/btrfs-compression-don-t-try-to-compress-if-we-don-t-have-enough-pages.patch)

I'm sorry, but I do not understand what you are trying to say here.
What exactly should I do?

confused,

greg k-h
