Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C09030F5DB
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 16:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbhBDPJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 10:09:19 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55877 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237149AbhBDPHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 10:07:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3196D5C00E8;
        Thu,  4 Feb 2021 10:06:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 04 Feb 2021 10:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=4qUvQk/xSOvs+hhxvKkSTKcH9IV
        RkthrcPSp7ah7TAY=; b=BbddxsHRQxWsd87zCsKVRS0qaqPEfe4FeD8KtpPtIJ5
        rOT626/vfXmy5G3GqLWy4ae9opNqfQ/UG+bizLEUiM2m+4Uq39dfd+mBMxS3ylgy
        /gheSEXN3rab+HYG7bBweOV4s+EVOxWvSNFY+HjnGENgFWmhqv+TS3as3PBLdgu4
        DkT01YI7DXl7KtuAB89eLSQrmAYkfu7h56om6TuyqFGB+NlCcBUrGoJ8yx1xUJkb
        w+XJVzHZJMLhxA+82j4jZH0F/pcytccw8Fy9Tr2yEuLYzUsH9k5UaSwZB9/0xf4Q
        kwKuTcsFB8+ldWweGsVxjvGzMY9gh6umrnjg3g5GJMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4qUvQk
        /xSOvs+hhxvKkSTKcH9IVRkthrcPSp7ah7TAY=; b=tawfqPPoOj4P6MT0J2RMzB
        VU86Ko/K9SHrdVju+pyLVX6oiXMTmUkKPwdZ+abOCKRL4D5nOlFaNxR0rEOBdcND
        qJMdIkoXLsyWhaslq93byGycvCqMDx3eNs9BXrvGD551QRLWFxfzxvcLmB1rcXwC
        1828o9KNnMaZ1zkavHTYbD+a+QlR6M1OFLvLsQqHI/fpPSiMAUMJFzQDvBWEyfjd
        JcsAxNMXLeIvr8RZJOisjVNpZkNAbMTnBy5sJc66VCNSkgBZuBVUyX9AQulHV5Z7
        0pPJUK1qnJXJOz0+u5nEqvaMxbj4WOUGhpMaUCGe7tPQ+euP5hXNA+rEBz67dVQg
        ==
X-ME-Sender: <xms:jA0cYBAtI_9ch0noMzxR6raFQT3GAyDJfOs7ghxcUvbjWhTFwnDCyQ>
    <xme:jA0cYPirLO_9xFwsZD16UIRV5P3dNzvi4q6j-MgjDZT8bQFPGRO_OBYIx7u8If3Um
    etm_I7YD_Nulg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeeggdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jA0cYMlghoiL00olTXXW3grzm8LWt5tL3Vgr8FUBwqJFyzYfwn4HuA>
    <xmx:jA0cYLw3W6ilSUIpDmm6rcNEMXk8M_kyr9xLyjF-RkrNYz4ddEwysg>
    <xmx:jA0cYGRnfUh5uLEsiRtg-wMj116CPmCDvliSc3H8OuJg4Czhc2KaPA>
    <xmx:jQ0cYNNlLeYnV3PNFSPY56Zpr3bpuEbVISgdcIdULkYSi-aTbTa5fg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A6FAF1080059;
        Thu,  4 Feb 2021 10:06:52 -0500 (EST)
Date:   Thu, 4 Feb 2021 16:06:50 +0100
From:   Greg KH <greg@kroah.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] drm: panfrost: Coherency support
Message-ID: <YBwNinvUqw5WVDWk@kroah.com>
References: <cover.1600780574.git.robin.murphy@arm.com>
 <61cc1b7b-9622-f346-7ae4-a2c2b2d75a2a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61cc1b7b-9622-f346-7ae4-a2c2b2d75a2a@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 12:38:09PM +0000, Robin Murphy wrote:
> Hi Greg,
> 
> On 2020-09-22 15:16, Robin Murphy wrote:
> > Hi all,
> > 
> > Here's a quick v2 with the tags so far picked up and some inline
> > commentary about the shareability domains for the pagetable code.
> > 
> > Robin.
> > 
> > 
> > Robin Murphy (3):
> >    iommu/io-pgtable-arm: Support coherency for Mali LPAE
> >    drm/panfrost: Support cache-coherent integrations
> >    arm64: dts: meson: Describe G12b GPU as coherent
> 
> Please would you consider applying these patches to 5.10 stable? The
> mainline commit IDs are now:
> 
> 728da60da7c1 iommu/io-pgtable-arm: Support coherency for Mali LPAE
> 268af50f38b1 drm/panfrost: Support cache-coherent integrations
> 03544505cb10 arm64: dts: meson: Describe G12b GPU as coherent
> 
> and I've checked that they cherry-pick to the current 5.10.y branch
> (5.10.12) cleanly.
> 
> Amlogic-based boards that require this support are quite popular, and
> end-users are now starting to run into the weird behaviour that ensues
> without it, which is all to easy to misattribute to the userspace driver in
> Mesa, e.g. [1],[2]. Fortunately 5.10 also happens to be the first kernel
> version to start probing the particular GPU models on these SoCs anyway, and
> I'm not aware of any other significant systems that are affected, so I don't
> believe we will need to worry about any other stable versions.

That's small enough, now queued up, thanks.

greg k-h
