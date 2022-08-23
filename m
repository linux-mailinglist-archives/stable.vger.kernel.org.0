Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9117859D1F1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiHWHYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiHWHYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:24:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110AA46217;
        Tue, 23 Aug 2022 00:24:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAC45B81BDB;
        Tue, 23 Aug 2022 07:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202E0C433C1;
        Tue, 23 Aug 2022 07:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661239473;
        bh=0/62pQHEo/3MU6vsBln+x9j68/zCJNaC3Zc5ubvqlWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cs3xYc+RxSKGoM2ecw049SIFY10RWSD6E6mJ6HG0gIndjiHERbYnTFX/12/DeqhcJ
         NLku+XEg5d4ClDVq0D1mAor5JOZnSTFAUhw2YuwcI2SNtqfJ1Lq5Tl5dN3eFBTRwue
         rAw3ZIYa2rnu2OoPC598fP7NrrkpGGOQU/gFgZCE=
Date:   Tue, 23 Aug 2022 09:24:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 4.14 0/2] btrfs: raid56: backporst to reduce
 corruption
Message-ID: <YwSAroFvTWLEdrGJ@kroah.com>
References: <cover.1660985049.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1660985049.git.wqu@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 04:49:21PM +0800, Qu Wenruo wrote:
> This is the backport for v4.19.x stable branch.
> 
> The full explananation can be found here:
> https://lore.kernel.org/linux-btrfs/cover.1660891713.git.wqu@suse.com/
> 
> No code change between v4.14.x and v4.19.x, at least nothing git can not
> auto-resolve.
> 
> Testing wise, this is beyond my testing environment.
> Although latest GCC compiles without problem, the result kernel can not
> be properly boot at all, not even any kernel early boot message.
> 
> I'm not sure if this is something related to latest edk2 UEFI or
> something else, I can no longer do proper testing for any older branch,
> including this 4.19 one.
> 
> Thus I can not do any guarantee on these backports, unfortunately
> the backports can only go to v5.x branches for now.
> 
> Unless anyone has better ideas how to build and run older kernels with
> latest edk2 UEFI environment.
> 
> Qu Wenruo (2):
>   btrfs: only write the sectors in the vertical stripe which has data
>     stripes
>   btrfs: raid56: don't trust any cached sector in
>     __raid56_parity_recover()
> 
>  fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 57 insertions(+), 17 deletions(-)
> 
> -- 
> 2.37.1
> 

All backports now queued up, thanks.

greg k-h
