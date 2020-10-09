Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DDE288A47
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732463AbgJIOGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 10:06:05 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:56607 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727737AbgJIOGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 10:06:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 763826A3;
        Fri,  9 Oct 2020 10:06:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 09 Oct 2020 10:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=QA1BxHl/gsKUUyFeFALiOB1m/Z+
        blvmdd5I9GCrB3kU=; b=iv8Vr0ACoqWlXa1w9ikn0KDS1VhK/H/SR66vblm5/fB
        Od8R49fMCkCKlUB4iF2N4W3zceHD4qmsFdbMzEWwkF/azFu9QNSdj5hLDB1sJejh
        rrRNbUHHMK294gPtEqu2OsqBHU3NPRSq7CyHvl14tBNOZP9sm+nJueBRrciEyz+s
        MXyB08LRVaxZjhmcivMVNCQTYOVbFuiia2/EvCwu7cuGPclF6NYn5SUBgGQoqOeg
        PYCuSEAa9xmB05X6BVKB5YNTmonm9dx3WQiaywC1qi6e/3ke6cvqLSH+sxdAmYFB
        08/YRbLea8hmQo228Olm8jJQv0fbL44ed9OTIpP1z/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QA1BxH
        l/gsKUUyFeFALiOB1m/Z+blvmdd5I9GCrB3kU=; b=EELLIb/RhTEJU2Y+v3K3Qi
        R+EoMK1meguKEDLOzi/aKIFyE2srjnNksnvLUhbRFOqiP/uaBN7acoySbIl6Dgt3
        It/s+qGomgDmb/QbEN1muUPDvZl88IF+KsdcJSw6Tb9gr3tBbcO/tu2GZCIQchwU
        6UKLh70FXpVQ2jbyKTwve5+qdr93k1VMVTsL23rCqzpsNjsJ84qPrdxYgqrgcw/A
        Ypbag91B/8/dF/128nzBP+3sk9ueuqKAt0oGENMCqeEHwGNLC4fImpftkjZzg9sI
        rcz3fa0spXLbviQnhwDpsqBLaW359zYwE3B35r/KUidXUu2Tr2SNyHJmGEAWrowQ
        ==
X-ME-Sender: <xms:Sm6AX9HuLQbJ_INlim0Gn9UZwtjRsRXLZ3unFpXMEtxrdc8-f0fdig>
    <xme:Sm6AXyWRwJTGErgYU4l_r9Cw9vJZs-hm_9EwyV5FdzdjAiwH17vY7Aihrc-qSPwIZ
    yHwdXKn6IpGGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedugdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Sm6AX_Ji4TPz--QEiAxTuWIceueKeoXyXczObkxvbQfncER_8NYDvg>
    <xmx:Sm6AXzH51-2ZoPTFDXznIH7W5hT5ATCJhSxLRInfxXngr0enhLpDRg>
    <xmx:Sm6AXzXkRsKCcy1ic79xERgHyQ2ep7PgYi74sBiRIXCY33dKGF1mXg>
    <xmx:S26AX5z_enu8sWs-J0MVT6R0lBhxYrRe1Xr1X48f1TWPqtXB2-sJpA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B90D328005A;
        Fri,  9 Oct 2020 10:06:02 -0400 (EDT)
Date:   Fri, 9 Oct 2020 16:06:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org, wqu@suse.com,
        fdmanana@suse.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH stable-5.4 6/6] btrfs: allow btrfs_truncate_block() to
 fallback to nocow for data space reservation
Message-ID: <20201009140648.GB573779@kroah.com>
References: <cover.1599750901.git.anand.jain@oracle.com>
 <9df7b36688030028271fe5d4265512328534f9b6.1599750901.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9df7b36688030028271fe5d4265512328534f9b6.1599750901.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 08, 2020 at 06:59:54PM +0800, Anand Jain wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> commit 6d4572a9d71d5fc2affee0258d8582d39859188c upstream.
> 
> [BUG]
> When the data space is exhausted, even if the inode has NOCOW attribute,
> we will still refuse to truncate unaligned range due to ENOSPC.
> 
> The following script can reproduce it pretty easily:
>   #!/bin/bash
> 
>   dev=/dev/test/test
>   mnt=/mnt/btrfs
> 
>   umount $dev &> /dev/null
>   umount $mnt &> /dev/null
> 
>   mkfs.btrfs -f $dev -b 1G
>   mount -o nospace_cache $dev $mnt
>   touch $mnt/foobar
>   chattr +C $mnt/foobar
> 
>   xfs_io -f -c "pwrite -b 4k 0 4k" $mnt/foobar > /dev/null
>   xfs_io -f -c "pwrite -b 4k 0 1G" $mnt/padding &> /dev/null
>   sync
> 
>   xfs_io -c "fpunch 0 2k" $mnt/foobar
>   umount $mnt
> 
> Currently this will fail at the fpunch part.
> 
> [CAUSE]
> Because btrfs_truncate_block() always reserves space without checking
> the NOCOW attribute.
> 
> Since the writeback path follows NOCOW bit, we only need to bother the
> space reservation code in btrfs_truncate_block().
> 
> [FIX]
> Make btrfs_truncate_block() follow btrfs_buffered_write() to try to
> reserve data space first, and fall back to NOCOW check only when we
> don't have enough space.
> 
> Such always-try-reserve is an optimization introduced in
> btrfs_buffered_write(), to avoid expensive btrfs_check_can_nocow() call.
> 
> This patch will export check_can_nocow() as btrfs_check_can_nocow(), and
> use it in btrfs_truncate_block() to fix the problem.
> 
> Reported-by: Martin Doucha <martin.doucha@suse.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>  Conflicts:
> 	fs/btrfs/ctree.h
> 	fs/btrfs/file.c
> 	fs/btrfs/inode.c

Why are these Conflicts: lines here?

Anyway, fixed up, and all queued up now, thansk!

greg k-h
