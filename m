Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4224CE501
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiCENgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:36:42 -0500
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E066B1BB70A;
        Sat,  5 Mar 2022 05:35:52 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 5EAA22B001F7;
        Sat,  5 Mar 2022 08:35:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 05 Mar 2022 08:35:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=4dc0VTzxNmvFQlKVw1cNuvHdBVJG8Wjw/K/Pj1
        9FZiU=; b=QLiKZAraGwCIsSdvHeIn74cQgEoxy+oVeQL5ojP+rVXNSGANtMx3vL
        dRC9cCSwBFUXSg23b0s3GcOtii9Lzc6fc6NJl0c3irbzBZK/SJA3wMfshRXxLI0b
        L7DZVl2mRjgkvY8uMOr/brgfNvPPQrVt0gFOjA6vKVVt2aNFBHv6I7i901OBZcyK
        O+eeQCR/RHOt+3m3nj9nX+eV2YMZ8pKh1qcOqLbSruUxbmEm1BTFdrYhNd7PS0z4
        IAik/LFRc4/1jENsdltxqHiT8pbS+jxLcEL4FUtqBpdFCKGyMi2tdOQ3C4aZqiuS
        AEN/QiP+w0bNv78D6vtvvW5mFMC3fiig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4dc0VTzxNmvFQlKVw
        1cNuvHdBVJG8Wjw/K/Pj19FZiU=; b=Eeo+mPic7zpISsdEjrutKJdSy+8z+I7xe
        1wum9JSqY+xK07vjoH94XafQ5eIySSvc10Vv2a6BtF9b5RMh8d8fythB+Rq52FOK
        9GIwyFNz6msnqzoZhirc5wFhZyXv8/IQi3PL/gqCJVtNcgvDHREpBzPIFcxEjZ66
        EufJdRAuuGZN3Dyx7Xop+VgEp30rzIWELOf3KflF4omx7tFkGpnNoJw93kIhunr2
        EqyQSotkxSxEqieku9vhLIXWoLym3+mYm0x8hmxtVojQJHgI1QLEYxOSdJxWwmMg
        WZ/yjv0WHKsdBMfbY0EoNc/T0saf7RQ/sQESWlUy/R3u75g5BzHqw==
X-ME-Sender: <xms:NmcjYuyv9TpPZ3r4tJFyPQ-ROzLw4d-iOi_uNIOQnFwxbzE5x9KMUw>
    <xme:NmcjYqQLMPS2wcvxkiYFiRs7vzMWOAxA24pk0iALVQqEBl1SK06lBHWNpyojg9JrB
    fPYdG-cvcxKiw>
X-ME-Received: <xmr:NmcjYgWleg2ONxL8hFeij-ELJxBJcc2qOkNhnVv0LiGxc4m-kg38dbJFxFU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddutddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:NmcjYkgt-qgvbzZna7KtvfhSPfIuPbGK1f0bcaInnS699ouvxnkLUg>
    <xmx:NmcjYgC81yERSkTUxzhNqPqGA1KHGTikf8_RSuAF4jdUa8utrliA3g>
    <xmx:NmcjYlKoqQymB0wsHXJskIvWkB0wIt5lFZaQkGwE7lR2O0Bokl5aGw>
    <xmx:NmcjYk5OpQfan7G27G653aEswXRQpI_8XxwAaZnxuTlleWcy1B2dL_mbsO8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 5 Mar 2022 08:35:49 -0500 (EST)
Date:   Sat, 5 Mar 2022 14:35:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH stable-5.15.y] btrfs: fix ENOSPC failure when attempting
 direct IO write into NOCOW range
Message-ID: <YiNnK4HMpZSg41Gc@kroah.com>
References: <4d7223dc5a3e02562e48012334f76ed598bc9792.1646313523.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d7223dc5a3e02562e48012334f76ed598bc9792.1646313523.git.anand.jain@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 03, 2022 at 09:30:31PM +0800, Anand Jain wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Commit f0bfa76a11e93d0fe2c896fcb566568c5e8b5d3f upstream.
> 
> When doing a direct IO write against a file range that either has
> preallocated extents in that range or has regular extents and the file
> has the NOCOW attribute set, the write fails with -ENOSPC when all of
> the following conditions are met:
> 
> 1) There are no data blocks groups with enough free space matching
>    the size of the write;
> 
> 2) There's not enough unallocated space for allocating a new data block
>    group;
> 
> 3) The extents in the target file range are not shared, neither through
>    snapshots nor through reflinks.
> 
> This is wrong because a NOCOW write can be done in such case, and in fact
> it's possible to do it using a buffered IO write, since when failing to
> allocate data space, the buffered IO path checks if a NOCOW write is
> possible.
> 
> The failure in direct IO write path comes from the fact that early on,
> at btrfs_dio_iomap_begin(), we try to allocate data space for the write
> and if it that fails we return the error and stop - we never check if we
> can do NOCOW. But later, at btrfs_get_blocks_direct_write(), we check
> if we can do a NOCOW write into the range, or a subset of the range, and
> then release the previously reserved data space.
> 
> Fix this by doing the data reservation only if needed, when we must COW,
> at btrfs_get_blocks_direct_write() instead of doing it at
> btrfs_dio_iomap_begin(). This also simplifies a bit the logic and removes
> the inneficiency of doing unnecessary data reservations.
> 
> The following example test script reproduces the problem:
> 
>   $ cat dio-nocow-enospc.sh
>   #!/bin/bash
> 
>   DEV=/dev/sdj
>   MNT=/mnt/sdj
> 
>   # Use a small fixed size (1G) filesystem so that it's quick to fill
>   # it up.
>   # Make sure the mixed block groups feature is not enabled because we
>   # later want to not have more space available for allocating data
>   # extents but still have enough metadata space free for the file writes.
>   mkfs.btrfs -f -b $((1024 * 1024 * 1024)) -O ^mixed-bg $DEV
>   mount $DEV $MNT
> 
>   # Create our test file with the NOCOW attribute set.
>   touch $MNT/foobar
>   chattr +C $MNT/foobar
> 
>   # Now fill in all unallocated space with data for our test file.
>   # This will allocate a data block group that will be full and leave
>   # no (or a very small amount of) unallocated space in the device, so
>   # that it will not be possible to allocate a new block group later.
>   echo
>   echo "Creating test file with initial data..."
>   xfs_io -c "pwrite -S 0xab -b 1M 0 900M" $MNT/foobar
> 
>   # Now try a direct IO write against file range [0, 10M[.
>   # This should succeed since this is a NOCOW file and an extent for the
>   # range was previously allocated.
>   echo
>   echo "Trying direct IO write over allocated space..."
>   xfs_io -d -c "pwrite -S 0xcd -b 10M 0 10M" $MNT/foobar
> 
>   umount $MNT
> 
> When running the test:
> 
>   $ ./dio-nocow-enospc.sh
>   (...)
> 
>   Creating test file with initial data...
>   wrote 943718400/943718400 bytes at offset 0
>   900 MiB, 900 ops; 0:00:01.43 (625.526 MiB/sec and 625.5265 ops/sec)
> 
>   Trying direct IO write over allocated space...
>   pwrite: No space left on device
> 
> A test case for fstests will follow, testing both this direct IO write
> scenario as well as the buffered IO write scenario to make it less likely
> to get future regressions on the buffered IO case.
> 
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/inode.c | 142 ++++++++++++++++++++++++++---------------------
>  1 file changed, 78 insertions(+), 64 deletions(-)

A normal "cherry pick" worked here, right?

Also this is needed for 5.16.

thanks,

greg k-h
