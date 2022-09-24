Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EFE5E8AFE
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 11:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiIXJjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 05:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiIXJjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 05:39:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AD510D0D7;
        Sat, 24 Sep 2022 02:39:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D52E611B3;
        Sat, 24 Sep 2022 09:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4489CC433C1;
        Sat, 24 Sep 2022 09:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664012360;
        bh=FVckNL33mWzQxfvU9HuFJfgm21O9LlvVAMgiOWpwbno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1+NPGzIA6iiXcleX06zToVYuFsieuswp9FD5RZruoc9644E41158W95/DpAUFuwfz
         p1ywuqFUgq3FoOUGWOSwD5OfCufOVe3czWF5rAvFfYkl1ggGar0H/F/tvOP9mjhUiI
         ixEahG1HESqvIrkJ1wxZAR9haenNYolNO1a9wUpg=
Date:   Sat, 24 Sep 2022 11:39:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] re-send two xfs stable patches for 5.10.y (from
 v5.18+)
Message-ID: <Yy7QRi9NgCgOPNzT@kroah.com>
References: <20220922154728.97402-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922154728.97402-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 06:47:26PM +0300, Amir Goldstein wrote:
> Hi Greg,
> 
> These are the two patches that you asked me [1] to defer until they
> are posted to 5.15.y.
> 
> Now that Leah has posted them for 5.15.y [2], please apply them also
> to 5.10.y.
> 
> Note that Leah has an extra patch in her 5.15.y series:
> "xfs: fix xfs_ifree() error handling to not leak perag ref"
> This fix does not apply and is not relevant to 5.10.y.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-xfs/YxCulVd4dESBjCUM@kroah.com/
> [2] https://lore.kernel.org/linux-xfs/20220922151501.2297190-1-leah.rumancik@gmail.com/
> 
> Dave Chinner (2):
>   xfs: reorder iunlink remove operation in xfs_ifree
>   xfs: validate inode fork size against fork format
> 
>  fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
>  fs/xfs/xfs_inode.c            | 22 ++++++++++++----------
>  2 files changed, 38 insertions(+), 19 deletions(-)
> 
> -- 
> 2.25.1
> 

Now queued up, thnaks.

greg k-h
