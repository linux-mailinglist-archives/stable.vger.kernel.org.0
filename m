Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C370D676D87
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjAVOPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjAVOPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:15:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C42E1F5F8
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1994CCE0EB3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EF8C433EF;
        Sun, 22 Jan 2023 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674396890;
        bh=cATNT2CveJBpedlCJrWtRaV+hTrV5pxK/j/b11KO34g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IQrzeB+h6aURE/Vnt5g1RNRF+wes8gzU0mI+TloS9Sfwn2HKjty6EPVqrcLywKZjd
         aazkojqLd1QO61JcpWQos9YZ2kUGQod7b4dxydaR1TWBaQMTDquZfRM2ExGCVY+253
         xtyNlzajVm1VfsRz+DkQRT473l5VnYkfEmRHvVyg=
Date:   Sun, 22 Jan 2023 15:14:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Whitney <enwlinux@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 499/521] ext4: fix delayed allocation bug in
 ext4_clu_mapped for bigalloc + inline
Message-ID: <Y81E17kMowYd3naC@kroah.com>
References: <20230116154847.246743274@linuxfoundation.org>
 <20230116154909.507815847@linuxfoundation.org>
 <Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 12:40:11PM -0500, Eric Whitney wrote:
> Hi:
> 
> I recommend not backporting this patch or the other three patches apparently
> intended to support it to 4.19 stable.  All these patches are related to
> ext4's bigalloc feature, which was experimental as of 4.19 (expressly noted by
> contemporary versions of e2fsprogs) and also suffered from a number of bugs.
> A significant number of additional patches that were applied to 5.X kernels
> over time would have to be backported to 4.19 for the patch below to function
> correctly. It's really not worth doing that given bigalloc's experimental
> status as of 4.19 and the very rare combination of the bigalloc and inline
> features.

All now reverted, thanks!

greg k-h
