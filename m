Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12A73EB2D1
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbhHMIrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239327AbhHMIrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 04:47:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6049B6103A;
        Fri, 13 Aug 2021 08:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628844442;
        bh=ryPIPaTnUSiLhRud1EwlvVULU5qq7lmszY73i6rh+Ds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IECSMzru1n6mvPE21ujM9Di2Z0fdNLd5X0m1LJ5bS7jlzuZEdn9bkN/X0m+RDDk3H
         paNrlDwbszRKBBr9voFKOPBUZVP3eegJMfAj6qYeWGC7Lt7YgtDt4PJ0nDe7mFXM1h
         x+YhNVSQ+hNJHilIliqaGhrAVn7THWdmxDXjW3Fo=
Date:   Fri, 13 Aug 2021 10:47:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     hdegoede@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] vboxsf: Make vboxsf_dir_create() return
 the handle for the" failed to apply to 5.10-stable tree
Message-ID: <YRYxl/OujJkOnWfa@kroah.com>
References: <1626967913218159@kroah.com>
 <YRQ85QyVc7Sb/Hm/@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRQ85QyVc7Sb/Hm/@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 10:11:01PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, Jul 22, 2021 at 05:31:53PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with cc3ddee97cff ("vboxsf: Honor excl flag
> to the dir-inode create op") which was also in another failed mail.

Now queued up,t hanks.

greg k-h
