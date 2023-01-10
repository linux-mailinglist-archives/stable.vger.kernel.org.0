Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01E8663A47
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 08:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbjAJH6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 02:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237943AbjAJH6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 02:58:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA53047328;
        Mon,  9 Jan 2023 23:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53822614F5;
        Tue, 10 Jan 2023 07:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D74DC433EF;
        Tue, 10 Jan 2023 07:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673337423;
        bh=gEi6UJ83NG/htzBCo+3AqYJP1rqsBo/aKQfK3lFeq58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JCS9iJ+ATIzZKFLXziSWS6p9GFSh39vQJyy8qlo2EhARVZXjO5PLDkCccUo58Ud0A
         qXeJSVDVqqUX0wpvrA09giQzchEBYvici+zVdFMBP2GKllP3OYaKgQwvYYwhxWclYp
         ryANG/FTUulOvygBlrZBzvr2ueXhimILHO8BzuaM=
Date:   Tue, 10 Jan 2023 08:57:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: please rebase the patch queue-6.1(btrfs: fix an error handling
 path in btrfs_defrag_leaves)
Message-ID: <Y70aTKUaBOLah8EQ@kroah.com>
References: <20230110123813.7DCC.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110123813.7DCC.409509F4@e16-tech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 12:38:14PM +0800, Wang Yugui wrote:
> Hi, Sasha Levin
> 
> please rebase the patch queue-6.1(btrfs: fix an error handling path in btrfs_defrag_leaves)
> just like queue-6.0, and then drop its 8 depency patches.
> 
> the 2 of 8 depency patches are file rename, so it will make later depency patch become
> difficult?
> #btrfs-move-btrfs_get_block_group-helper-out-of-disk-.patch
> #btrfs-move-flush-related-definitions-to-space-info.h.patch
> #btrfs-move-btrfs_print_data_csum_error-into-inode.c.patch
> #btrfs-move-fs-wide-helpers-out-of-ctree.h.patch
> #btrfs-move-assert-helpers-out-of-ctree.h.patch
> #btrfs-move-the-printk-helpers-out-of-ctree.h.patch
> #**btrfs-rename-struct-funcs.c-to-accessors.c.patch
> #**btrfs-rename-tree-defrag.c-to-defrag.c.patch
> 
> and the patch(btrfs: fix an error handling path in btrfs_defrag_leaves) is small,
> so a rebase will be a good choice.

I do not understand, sorry, we can not rebase anything, that's not how
our patch queue works.

So what exactly do you want to see changed?  What patches dropped?  And
what added?

thanks,

greg k-h
