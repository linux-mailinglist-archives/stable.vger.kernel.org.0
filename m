Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96AE600AB1
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiJQJ24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiJQJ2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:28:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013ED52466;
        Mon, 17 Oct 2022 02:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 451E260FEB;
        Mon, 17 Oct 2022 09:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5923CC433C1;
        Mon, 17 Oct 2022 09:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665998914;
        bh=zZo0gh5Ii2gjuYDrmkOo5UAyH0HI7jqi1nZfj6r1/v8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=taKFR5cODh1JMCoif+l9FyQqqcKOjwpRGtX3Rp2UuVuTVNJOtSPKZwwpCFhLn3WC4
         qUTQFCeRggEPEhrSn9/rk91cb6+1ElK7WWAwjOohXlcU616IwU3QlCqDQNebzd83X6
         9LKSTIEyfhc2TftVvQTV6KmTjlS82f0AcORXOYfI=
Date:   Mon, 17 Oct 2022 11:29:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: Patch "media: v4l2-ctrls: allocate space for arrays" has been
 added to the 6.0-stable tree
Message-ID: <Y00gcTIAqgDxKuZJ@kroah.com>
References: <20221017022412.2384094-1-sashal@kernel.org>
 <fc03d70e-a97e-57a4-eced-08dc38273052@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc03d70e-a97e-57a4-eced-08dc38273052@xs4all.nl>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 08:55:50AM +0200, Hans Verkuil wrote:
> Hi Sasha,
> 
> Please don't add this patch: it is not a fix, it is an internal change preparing for
> a new feature (see commit 0975274557d1). So no need to backport this patch.
> 
> Regards,
> 
> 	Hans
> 
> On 10/17/22 04:24, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     media: v4l2-ctrls: allocate space for arrays
> > 
> > to the 6.0-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      media-v4l2-ctrls-allocate-space-for-arrays.patch
> > and it can be found in the queue-6.0 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > 
> > commit 5cc036de01c402cf40cccf04dcb95af5e18e8313
> > Author: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > Date:   Mon Jul 11 12:21:07 2022 +0200
> > 
> >     media: v4l2-ctrls: allocate space for arrays
> >     
> >     [ Upstream commit 5f2c5c69a61dc5411d436c1a422f8a1ee195a924 ]
> >     
> >     Just like dynamic arrays, also allocate space for regular arrays.
> >     
> >     This is in preparation for allowing to change the array size from
> >     a driver.
> >     
> >     Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >     Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> >     Stable-dep-of: 211f8304fa21 ("media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop")

It was added as a dependency of this commit.

I'll go drop this commit, and this later one too.  Submitting that fix
without this would be great.

Hm, no, that commit does seem to need this one, so I'll go drop this
now.

thanks,

greg k-h
