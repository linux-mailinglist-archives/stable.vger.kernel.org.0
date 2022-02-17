Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACA64BAA38
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244584AbiBQTtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:49:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242527AbiBQTtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:49:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF0239141;
        Thu, 17 Feb 2022 11:49:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE3B0B82439;
        Thu, 17 Feb 2022 19:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D0BC340E8;
        Thu, 17 Feb 2022 19:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645127337;
        bh=m21Dh7kSE69Ls09UWrziiUz7JPUx9+0/pH0JQgg655U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XZ5SzZqlYqTKMMPunbagJF/+3GuwNd1zplnHNinqcExtaKUZ03OfRDjnM0HlM8YbA
         Kmqn9JKKyDkY1o1zEyasftG6OnJjxgPBgyxo1nOlxiASWY8dACHeOQdxQublH95oaY
         bfwmuLHIugK+fWnXICJmq5rtX7siesEGVYUYtc+w=
Date:   Thu, 17 Feb 2022 20:48:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     Qu Wenruo <wqu@suse.com>, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH for v5.15 1/2] btrfs: don't hold CPU for too long when
 defragging a file
Message-ID: <Yg6mplO5BeK5kC7w@kroah.com>
References: <cover.1644994950.git.wqu@suse.com>
 <67dd6f0e69c59a8554d7a2977939f94221af00c1.1644994950.git.wqu@suse.com>
 <Yg6bcq2stNcvDLOv@kroah.com>
 <60159313-2228-77e1-3748-97891a8e8f2e@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60159313-2228-77e1-3748-97891a8e8f2e@applied-asynchrony.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 08:41:51PM +0100, Holger Hoffstätte wrote:
> On 2022-02-17 20:01, Greg KH wrote:
> > On Wed, Feb 16, 2022 at 03:09:07PM +0800, Qu Wenruo wrote:
> > > commit 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b upstream.
> > 
> > This commit is already in 5.15.22.
> 
> It most certainly is not

Commit 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b is in 5.15.22.

> since it applies cleanly in 5.15.24.
> The correct upstream commit of this patch is ea0eba69a2a8125229b1b6011644598039bc53aa

Ah, no wonder the confusion.  For obvious reasons, I can not take this
as-is :)

thanks,

greg k-h
