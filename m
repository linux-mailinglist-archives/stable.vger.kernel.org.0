Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA8167C6AA
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 10:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbjAZJN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 04:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjAZJN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 04:13:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD285AB5B;
        Thu, 26 Jan 2023 01:13:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9DAE61769;
        Thu, 26 Jan 2023 09:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D8DC433EF;
        Thu, 26 Jan 2023 09:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674724406;
        bh=K75+4I/AEzlBnGR65u1uXoshesabW5aquBFF3e097hE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cgEFonWHQd0j+9vg/6yFSo1TQCFTWPOHgcDUrmOpeSJ1XJmbfX3pORkXx50Lhib3y
         rnkx3Q6LeDa6Fq7FVBoKP/GAXsAIUoiCyHx7S753ilEzevsOyUYnah4oq0CU55S1kJ
         QdwjoGMQQPIz8zAeZcWUF3vo3blc+Zx2i1erAMDY=
Date:   Thu, 26 Jan 2023 10:13:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 4.14/4.19/5.4/5.10/5.15 1/1] fs: reiserfs: remove useless
 new_opts in reiserfs_remount
Message-ID: <Y9JEM9toMBcEfDak@kroah.com>
References: <20230126085846.466209-1-pchelkin@ispras.ru>
 <20230126085846.466209-2-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126085846.466209-2-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 11:58:46AM +0300, Fedor Pchelkin wrote:
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> commit 81dedaf10c20959bdf5624f9783f408df26ba7a4 upstream.
> 
> Since the commit c3d98ea08291 ("VFS: Don't use save/replace_mount_options
> if not using generic_show_options") eliminates replace_mount_options
> in reiserfs_remount, but does not handle the allocated new_opts,
> it will cause memory leak in the reiserfs_remount.
> 
> Because new_opts is useless in reiserfs_mount, so we fix this bug by
> removing the useless new_opts in reiserfs_remount.
> 
> Fixes: c3d98ea08291 ("VFS: Don't use save/replace_mount_options if not using generic_show_options")
> Link: https://lore.kernel.org/r/20211027143445.4156459-1-mudongliangabcd@gmail.com
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  fs/reiserfs/super.c | 6 ------
>  1 file changed, 6 deletions(-)

Now queued up, thanks.

greg k-h
