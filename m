Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECAE2E3557
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgL1JOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgL1JOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 04:14:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F077320799;
        Mon, 28 Dec 2020 09:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609146814;
        bh=kE72RJrfjfE/ZQjHfG15EqZpHdV4L8TueeVQkSfq2/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V+yOQBxfBJhH81VU4fnwqrffdXbz4BjzwkeLGoBJIeVh2fAD6K11lD963kTwEydqY
         CqT5oc/xSSJ+zdpzEW17t1Vbbj1oxctLnD6SnHlyTuCSKWRDijwEGfUm4pIecX4Kno
         2IYWV0Z7e+prldrFehLDFtty4Lhmztuh7+nMDiMs=
Date:   Mon, 28 Dec 2020 10:14:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Pavel Machek <pavel@denx.de>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: missing btrfs fixes for 4.14-stable, 4.9-stable and 4.4-stable
Message-ID: <X+miEe8Jv9RhPm7+@kroah.com>
References: <20201221160316.ftczjtpmva6rtw74@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221160316.ftczjtpmva6rtw74@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 04:03:16PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> Few missing btrfs fixes for 4.14-stable, 4.9-stable and 4.4-stable.
> Only one of them was marked for stable but looks like they should be.
> 
> 6f7de19ed3d4 ("btrfs: quota: Set rescan progress to (u64)-1 if we hit
> last leaf")
> 
> 665d4953cde6 ("btrfs: scrub: Don't use inode page cache in
> scrub_handle_errored_block()")
> 
> 9f7fec0ba891 ("Btrfs: fix selftests failure due to uninitialized i_mode
> in test inodes")
> 
> 881a3a11c2b8 ("btrfs: fix return value mixup in btrfs_get_extent")

All now queued up, thanks!

greg k-h
