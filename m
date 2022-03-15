Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078BF4D9B61
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348366AbiCOMkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348372AbiCOMko (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:40:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60B030F6C;
        Tue, 15 Mar 2022 05:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FF5BB81630;
        Tue, 15 Mar 2022 12:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270BBC340E8;
        Tue, 15 Mar 2022 12:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647347969;
        bh=Xu4F+fpf6Kj3aX2H8U9N2rdNJGG8OWcAEfEgX1uW+dA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=czJE0DAkoeNQWzjvQgvBeZIOR2dZ1jHu76CDKdg9CZKwO3pJ4+jLH5cFmwNqSXTDt
         5jveE7WsX5hsp+lT324Qqn/OC3rz8Q0nPU2Eb+VFG6i4J0c2QHBrHuG6MW//GZ+g6o
         kK5E1NArUtR8NxT3bFjooY8LAPPQIV0dQ/GXuWqI=
Date:   Tue, 15 Mar 2022 13:39:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com
Subject: Re: [PATCH 5.15 015/110] vhost: fix hung thread due to erroneous
 iotlb entries
Message-ID: <YjCI/Gd6oFiC1J8Z@kroah.com>
References: <20220314112743.029192918@linuxfoundation.org>
 <20220314112743.460512435@linuxfoundation.org>
 <Yi9p8xsrWV+GD9c3@anirudhrb.com>
 <YjBaOClDdNQkxtM8@kroah.com>
 <20220315074834-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315074834-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 07:50:10AM -0400, Michael S. Tsirkin wrote:
> On Tue, Mar 15, 2022 at 10:19:52AM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Mar 14, 2022 at 09:44:43PM +0530, Anirudh Rayabharam wrote:
> > > Mon, Mar 14, 2022 at 12:53:17PM +0100, Greg Kroah-Hartman wrote:
> > > > From: Anirudh Rayabharam <mail@anirudhrb.com>
> > > > 
> > > > [ Upstream commit e2ae38cf3d91837a493cb2093c87700ff3cbe667 ]
> > > 
> > > This breaks batching of IOTLB messages. [1] fixes it but hasn't landed in
> > > Linus' tree yet.
> > > 
> > > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=95932ab2ea07b79cdb33121e2f40ccda9e6a73b5
> > 
> > Why is this tree not in linux-next?  I don't see this commit there, so
> > how can it get to Linus properly?
> > 
> > thanks,
> > 
> > greg k-h
> 
> It is in next normally. I was sure this commit was there too. I'm not sure
> what happened, maybe I forgot to push :(
> 

It's on kernel.org already though.

Anyway, I'll just take it from here directly, thanks.

greg k-h
