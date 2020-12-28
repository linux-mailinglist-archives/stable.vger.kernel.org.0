Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB492E3559
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgL1JPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgL1JPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 04:15:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4345120799;
        Mon, 28 Dec 2020 09:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609146865;
        bh=vJlLtk2yau/2x5mxx+vurYWeO+jFVgjpWcDuXxD0m78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=osDpFgKs+nXIX9efOJ3OvYK0tc6Chvk0z1vGwjIFdRusnPSQiRpH7NSeiJ5FcYc7r
         n7K9Ie778FZeN4Ged18KQiPBkP3aCGxxMCN/DMGpQmgZNzoYnjV8GhgKi3E+0OnKbu
         U5PzBsWSZVWQ7i/YdQu60yQ92c77WgFanTsGIuVg=
Date:   Mon, 28 Dec 2020 10:15:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     wqu@suse.com, dsterba@suse.com, fdmanana@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: trim: fix underflow in trim length
 to prevent access" failed to apply to 5.4-stable tree
Message-ID: <X+miRIbgWwiwMUh/@kroah.com>
References: <15978369934613@kroah.com>
 <20201221195316.2ghzag6fblousbu7@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221195316.2ghzag6fblousbu7@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 07:53:16PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Aug 19, 2020 at 01:36:33PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Now queued up, thanks.

greg k-h
