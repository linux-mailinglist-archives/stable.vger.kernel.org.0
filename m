Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403B4249B68
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgHSLMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgHSLMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 07:12:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 659C12075E;
        Wed, 19 Aug 2020 11:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597835562;
        bh=X5UZPKoMMh1XUPPVWuS4o6634BkbNXRBj9Ap+d53ens=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Izu6LjemAjSTNPwPuqfZ2Xx0GMa0v5Sf4gxU6omKqJdoTONZjYCQRWKlayrgyN9yl
         br5a2D96RpKxEOoapr/YA6ApuMuwQsdFiZY7psZ0Zsa+BBl8UAOFvHgCgvHj3cfbql
         PZQs08hzyTYABXhAGQuI74m8K7cHm4/FUXNRTo1w=
Date:   Wed, 19 Aug 2020 13:13:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please add 881a3a11c2b858f to 4.19.x
Message-ID: <20200819111304.GA47563@kroah.com>
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

There's a bunch of btrfs stable-marked patches in my queue right now,
let me dig through them all...
