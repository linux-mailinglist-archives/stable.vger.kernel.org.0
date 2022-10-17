Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3E0600AE2
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiJQJem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiJQJel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:34:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65B35FEC
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 02:34:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23ED8B81106
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 09:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786E7C433C1;
        Mon, 17 Oct 2022 09:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665999240;
        bh=oqWndmiBhH1Z3vpP/pH+CqfBCNzjNBwWczrGJ8Dry5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wGVjpNMXjigf1w6TtDlgY3AmF3PtkCD6aFPi7k+QkxsZstSz1GyJJk+XNu3q3/d9h
         4fVJOXUDn80VBcbwecYrQ/zyyXTDebekLiUGprzK3FJJQG87km6sLW8KsFUelh56+w
         ZQiWRYwbsEN53csOx2YYYnp3jk3/g8o2Pn8iBeKA=
Date:   Mon, 17 Oct 2022 11:34:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     dsterba@suse.com, nborisov@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: enhance unsupported compat RO
 flags handling" failed to apply to 4.9-stable tree
Message-ID: <Y00ht3ZPNYzKlLss@kroah.com>
References: <1665923107172110@kroah.com>
 <20403694-0d4f-38b3-643b-c09e745f4bd8@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20403694-0d4f-38b3-643b-c09e745f4bd8@suse.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 06:59:00AM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/10/16 20:25, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Thanks for the mail, I'll backport the patch manually.
> 
> Just want to praise the new dependency hints.
> 
> > 
> > Possible dependencies:
> > 
> > 81d5d61454c3 ("btrfs: enhance unsupported compat RO flags handling")
> > dfe8aec4520b ("btrfs: add a btrfs_block_group_root() helper")
> > b6e9f16c5fda ("btrfs: replace open coded while loop with proper construct")
> > 42437a6386ff ("btrfs: introduce mount option rescue=ignorebadroots")
> > 68319c18cb21 ("btrfs: show rescue=usebackuproot in /proc/mounts")
> > ab0b4a3ebf14 ("btrfs: add a helper to print out rescue= options")
> > ceafe3cc3992 ("btrfs: sysfs: export supported rescue= mount options")
> > 334c16d82cfe ("btrfs: push the NODATASUM check into btrfs_lookup_bio_sums")
> > d70bf7484f72 ("btrfs: unify the ro checking for mount options")
> > 7573df5547c0 ("btrfs: sysfs: export supported send stream version")
> > 3ef3959b29c4 ("btrfs: don't show full path of bind mounts in subvol=")
> > 74ef00185eb8 ("btrfs: introduce "rescue=" mount option")
> > e3ba67a108ff ("btrfs: factor out reading of bg from find_frist_block_group")
> > 89d7da9bc592 ("btrfs: get mapping tree directly from fsinfo in find_first_block_group")
> > c730ae0c6bb3 ("btrfs: convert comments to fallthrough annotations")
> > aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
> > 92a7cc425223 ("btrfs: rename BTRFS_ROOT_REF_COWS to BTRFS_ROOT_SHAREABLE")
> > 3be4d8efe3cf ("btrfs: block-group: rename write_one_cache_group()")
> > 97f4728af888 ("btrfs: block-group: refactor how we insert a block group item")
> > 7357623a7f4b ("btrfs: block-group: refactor how we delete one block group item")
> 
> It looks so awesome!!
> 
> I'm wondering how this is implemented? It would definitely help backporting
> not only to stable, but also some vendor backports branches.

Sasha's scripts generate these and put them online and you can do:
	curl --fail --silent https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/plain/v$STABLE_VERSION/$git_id

to query the dependancy tree.

thanks,

greg k-h
