Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2713561337
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 09:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbiF3H1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 03:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiF3H1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 03:27:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB28339166;
        Thu, 30 Jun 2022 00:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72209B827F9;
        Thu, 30 Jun 2022 07:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF944C34115;
        Thu, 30 Jun 2022 07:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656574029;
        bh=bG2aUuwgpA8jRa1ZqwEXGDdpwPb5MCN7pmBdoKQBXD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TdzgZ7vEEvjqmBTyiB2R2v1nOaP3uN4bei1lg4nFXrwZ3n3qcv/uKeoyqC+MnaMcc
         TXsPM/AQexsYOxE2gJK5X3MgMy/qY2vALpvschixpigoYwMU2fWAlBSjjpErqvpF0S
         ggim6qI8u3+EidwlKrxj/p0naYF/EWfR3H6kkHT4=
Date:   Thu, 30 Jun 2022 09:27:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
Message-ID: <Yr1QSpmzHRyH4heo@kroah.com>
References: <20220630054321.3008933-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630054321.3008933-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 08:43:21AM +0300, Amir Goldstein wrote:
> This is an attempt to direct the bots and human that are testing
> LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.
> 
> This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
> have their own LTS xfs maintainer entries.
> 
> Update Darrick's email address from upstream and add Amir as xfs
> maintaier for the 5.10.y tree.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
> 
> Greg,
> 
> We decided to try and fork MAINTAINERS.
> 
> I don't know if this was attempted before and I don't know if you
> think that is a good idea, but the rationale is that at least some
> of the scripts that report bugs on LTS, will be running get_maintainer.pl
> on the LTS branch they are testing.
> 
> The scripts that run get_maintainer.pl on master can be tought to
> do the right thing for LTS reporting.
> This seems easier and more practical then teaching the scripts to
> parse LTS specific entries in upstream MAINTAINERS.
> 
> You have another patch like that coming fro Leah for 5.15.y.
> 
> Thanks,
> Amir.
> 
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7c118b507912..4d10e79030a9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19246,7 +19246,8 @@ F:	arch/x86/xen/*swiotlb*
>  F:	drivers/xen/*swiotlb*
>  
>  XFS FILESYSTEM
> -M:	Darrick J. Wong <darrick.wong@oracle.com>
> +M:	Amir Goldstein <amir73il@gmail.com>
> +M:	Darrick J. Wong <djwong@kernel.org>
>  M:	linux-xfs@vger.kernel.org
>  L:	linux-xfs@vger.kernel.org
>  S:	Supported

I'll apply this, but really, no one will ever notice it.

All new patches, and work, goes on on Linus's tree and you have to
submit matches for it to be considered for older stable kernels as you
know.  So there's not much for old MAINTAINERS entries here.

But hey, I could be wrong let's try it and see what happens :)

thanks,

greg k-h
