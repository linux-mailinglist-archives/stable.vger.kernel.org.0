Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE00F7158A
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbfGWJ5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:57:31 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:53741 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726284AbfGWJ5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:57:31 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DF7801C2;
        Tue, 23 Jul 2019 05:57:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 05:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Zbd+0lFfDUojgP4BWfcs/ZQBaie
        1qowPB18eb++FXL4=; b=dL3TL7OqIOmkE39X0npwco1n8brYmI0rucSTaKvyMqB
        uGMuDCr0JExVjZE3WyILp8yZhF7inDnNK8cyZEbsC36dnV+fHc5T9ucoxBtk1+IX
        q+gqOVWeyjbCw0qmwA9AH4GyouHhiBSuxc9AEq+YS3YLP59UpfC5ATrq7/Y7cp51
        qiqbWBC9joj9TmgvF//+w0brL4zqXj4TtgHD9PL4ZsdkecrZuJu+8UhVxasoRUAh
        8t4m5ZipirWXDKWjtGx8QGD39gxBLA6FYVqAwxsyi1t2LvzLdbljQtdfyy7ZJMQL
        /071UlL3yjoCzdXU8BzN5KhKU5KnaCsBRn98IYcjLAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Zbd+0l
        FfDUojgP4BWfcs/ZQBaie1qowPB18eb++FXL4=; b=UaZTSsJvTTm9IuBWkzJvBE
        CFfVJiWlCqKYyv5oBYqTfZxOU8UcYzhcakQMRSha5XTO11/Sg3obUnM1Bn4uQ4eK
        yrOfKhSqLJKGe4YGmxg6hMUN4EzoeOKBYKPlXpe6mnWxl0zVGZzrez2Ttnlmp+PC
        TFtqwQeiHlp3sokL2FfigTiGcL6G4e/NDf/rkdM56S+lp8HRxwEZyD9PZuPMeo9O
        zbx7KiDhAmklRSlbqXmTWtOUS45JShrhVhNBtpc5rLfTRPr7wN7FXA7ZYGqtjMzu
        juZrxySbA2YP2HassjuH7ZenCa5Ib1R26lpU7NtIrbh84GWUSbtn4IHWved8RCiA
        ==
X-ME-Sender: <xms:Cdo2Xb72H8LGLWkabGjE1UqasRPd4aK9tGF-z2GLdtwzUS6nJv1HWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Cdo2XZW6OzlCitdpIW-1KE6fbdOEw5l_0pbKJBMGmK3KbJb9pQCtrw>
    <xmx:Cdo2XYF5Ac2Jud7UFw-vWGBSYAoekQwRBXPxwLG3ZTluJ7PhBkzj8A>
    <xmx:Cdo2XQPJJoF7y-beWiTeJdX7n8eLbvnmThGSoOTRY4WwgRVM9XvoIg>
    <xmx:Cdo2XUqo-6bLX6NrQXc2hDiV9_wQpYEIvuSEpvYNIH--z-trI8lEEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D9646380075;
        Tue, 23 Jul 2019 05:57:28 -0400 (EDT)
Date:   Tue, 23 Jul 2019 11:57:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Trond Myklebust <trondmy@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pnfs: Fix a problem where we gratuitously start doing
 I/O through the MDS
Message-ID: <20190723095725.GB3931@kroah.com>
References: <20190718194039.119185-1-trond.myklebust@hammerspace.com>
 <20190719004529.2E4422173B@mail.kernel.org>
 <219efbee81f7f22bdaf9764011cf831385837f74.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <219efbee81f7f22bdaf9764011cf831385837f74.camel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 08:54:53PM -0400, Trond Myklebust wrote:
> Hi Sasha,
> 
> On Fri, 2019-07-19 at 00:45 +0000, Sasha Levin wrote:
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: d03360aaf5cc pNFS: Ensure we return the error if
> > someone kills a waiting layoutget.
> > 
> > The bot has tested the following trees: v5.2.1, v5.1.18, v4.19.59.
> > 
> > v5.2.1: Build OK!
> > v5.1.18: Build OK!
> > v4.19.59: Failed to apply! Possible dependencies:
> >     400417b05f3e ("pNFS: Fix a typo in pnfs_update_layout")
> > 
> > 
> > NOTE: The patch will not be queued to stable trees until it is
> > upstream.
> > 
> > How should we proceed with this patch?
> > 
> 
> Please apply both patches.
> i.e. Please apply
> 
> 400417b05f3e ("pNFS: Fix a typo in pnfs_update_layout")
> 58bbeab425c6 ("pnfs: Fix a problem where we gratuitously start doing
> I/O through the MDS")

Now done, thanks.

greg k-h
