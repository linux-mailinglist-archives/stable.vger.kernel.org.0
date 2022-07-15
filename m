Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9795763B1
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 16:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiGOOex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 10:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiGOOew (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 10:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AE84E856;
        Fri, 15 Jul 2022 07:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7C80B82BAD;
        Fri, 15 Jul 2022 14:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB88C34115;
        Fri, 15 Jul 2022 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657895689;
        bh=4MOEIMzJJZKG5y3K8KfErDz0LG+zUdFIwugsujkUqrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hyUABuIQTnCV2Z5/QLz81mN3P/GXT8/4NUrULVeEUSIv0kGNURsazFBlN6Km9tHr1
         ZiLAMwAmakQ1Dz5WLbRdvQU4O4+M9DYqYQfkXjfwtJfF1Xh+Noj/v5w4pmvxURERzr
         s0CFxXru6Cy1GAfUE5CFT7AvmQFVQhat5oWxgeMM=
Date:   Fri, 15 Jul 2022 16:34:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5.15 v2 0/4] xfs stable candidates for 5.15.y (part 2)
Message-ID: <YtF6/wQPVYI/8vsf@kroah.com>
References: <20220714222342.4013916-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714222342.4013916-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 03:23:38PM -0700, Leah Rumancik wrote:
> Hello again,
> 
> This is a 5.15.y only set of xfs fixes. They have been tested and Ack'd.
> 
> Changes from v1->v2:
> - Added Acks
> 
> [v1] https://lore.kernel.org/linux-xfs/20220707223828.599185-1-leah.rumancik@gmail.com/
> 
> Darrick J. Wong (2):
>   xfs: only run COW extent recovery when there are no live extents
>   xfs: don't include bnobt blocks when reserving free block pool
> 
> Dave Chinner (2):
>   xfs: run callbacks before waking waiters in
>     xlog_state_shutdown_callbacks
>   xfs: drop async cache flushes from CIL commits.
> 
>  fs/xfs/xfs_bio_io.c      | 35 ------------------------
>  fs/xfs/xfs_fsops.c       |  2 +-
>  fs/xfs/xfs_linux.h       |  2 --
>  fs/xfs/xfs_log.c         | 58 +++++++++++++++++-----------------------
>  fs/xfs/xfs_log_cil.c     | 42 +++++++++--------------------
>  fs/xfs/xfs_log_priv.h    |  3 +--
>  fs/xfs/xfs_log_recover.c | 24 ++++++++++++++++-
>  fs/xfs/xfs_mount.c       | 12 +--------
>  fs/xfs/xfs_mount.h       | 15 +++++++++++
>  fs/xfs/xfs_reflink.c     |  5 +++-
>  fs/xfs/xfs_super.c       |  9 -------
>  11 files changed, 82 insertions(+), 125 deletions(-)
> 
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 

All now queued up, thanks.

greg k-h
