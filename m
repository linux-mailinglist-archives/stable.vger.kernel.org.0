Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46604249C00
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgHSLmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbgHSLmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 07:42:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D07220825;
        Wed, 19 Aug 2020 11:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597837353;
        bh=s4T8voiNo2GgClphAxUuPgKtaLG44D6VwcDgYnlevy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yxYXeuiLXvDRDWQzkNG15MUwZHhI9mHB4sf3Losi2MrVyRedXxQYR71uYI283ay6g
         wt4AEuwQ9X99r64/6cKB6WcFwb7EH7ALwBUcBTEcJXWAKU8360HMM/R4mdXPqO6Qo6
         9rzyyl/ATSTxNPusu8pyxgc4PNP8Mpv63SMUxz0A=
Date:   Wed, 19 Aug 2020 13:42:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please add 881a3a11c2b858f to 4.19.x
Message-ID: <20200819114253.GA710185@kroah.com>
References: <20200819105240.GJ2026@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819105240.GJ2026@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 12:52:40PM +0200, David Sterba wrote:
> Hi,
> 
> please add patch
> 
> 881a3a11c2b8 ("btrfs: fix return value mixup in btrfs_get_extent")
> 
> to 4.19 tree.
> 
> It's a fixup for patch 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to
> avoid NULL pointer dereference"). I don't see it queued yet and the patch
> is tagged for 5.4, this is just a heads up so it's not forgotten.
> 
> All the related patches:
> 
> 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")
> 9f7fec0ba891 ("Btrfs: fix selftests failure due to uninitialized i_mode in test inodes")
> 881a3a11c2b8 ("btrfs: fix return value mixup in btrfs_get_extent")
> 
> >From 5.4 up it's fine.

Ok, now queued up.

There's a bunch of btrfs failed patches to the different stable
branches, as you can see in your inbox now.  Patch series to fix this up
are always greatly appreciated :)

thanks,

greg k-h
