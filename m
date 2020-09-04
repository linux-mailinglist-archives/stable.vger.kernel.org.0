Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7D925D76C
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgIDLdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:33:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40835 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730184AbgIDLdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 07:33:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DAC7F5C014F;
        Fri,  4 Sep 2020 07:33:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Sep 2020 07:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=e
        21isrullm938WioMZ4USxRQd5tKjLJW37GgaCG2k8g=; b=IAGYpxrf0bBSJufwa
        u1ryZ+fAhTW1uhXiUEBlU9aDoSvUP6lYbJ+z0RNyAnvq8K3mHEE0zSp/yuMwHOo3
        8bXwKn/tsCkaH7i9tiqN6OWBFwLQD+OeAlQM1TwQdyZ0RSr1BustuRGg75Lc85OF
        CIlpPUCNxMKNKZl12Due987y7rWS2F+uLeCrlXgeKwrro1kQvy7NPr91MBCay+WM
        xwGHODVJobvWrdZF7ygdKnNKcJ7yZiHSvKaH+e3snvhUYEqtPHUqNJJfc6F569HS
        tNAjvIFC0qKqld2dOWxy+kyStWjxgSuzF/sWZf/gAudZ+SW5kRvX2ieLV6pdwm87
        6cGUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=e21isrullm938WioMZ4USxRQd5tKjLJW37GgaCG2k
        8g=; b=oSXxgbAUL+zs44BOZO1PZbIFDomVETWtpOg7GbZNOkhAWgO/vFjxHNAE4
        XhLt4YsFSJ3l6iRUrZzESlz5kXBbEzyOBPGS+fONRXIcZWCCvvcFFyoJP8sL358J
        Bqj3/eeI/FBHh94pGKFojCLk8uPWuY53e/AgT/q8FYBeu1l0FHCzC8fg8UVmMyd8
        W/q9s290QvSkU5fhWubrszmNfVsXvC/Hmnpbd9Rz0LIcnMxRDYv6hVs/z2az92W6
        uQcJcUdr20Czv0BgP/HrmQ+GGObsQVuzdI6kSD64QS4RhXJVzZeeLtqwTRnaR7ac
        QFUDx5/Cf4lMNBSnW+4Q9jqhbobjA==
X-ME-Sender: <xms:BSZSXyBLZ2Yuh99cDtmIZ256ndBvbHwgSS-oLJFUG_FxpuBpmJ2SZA>
    <xme:BSZSX8jY77Ae0qxEsoKNfaMEvyMpGmjwsK4yQFQ_fsOZ4kBSOj6sNmg3oNqdK-gwj
    HJHYKs9vU2RKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegfedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepjedtud
    elkeeufefhiefhvdfgfeetuddtjefgkedvheehgfehieekheetfeehtefgnecuffhomhgr
    ihhnpehsphhinhhitghsrdhnvghtnecukfhppeekfedrkeeirdejgedrieegnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhho
    rghhrdgtohhm
X-ME-Proxy: <xmx:BSZSX1lVoxIoyrvUUKLTeF9nV_a78-6TvTcQmon4XzXwU_Pu3KRJZA>
    <xmx:BSZSXwy5KM-oL01OrxAMklrWNX7OnTIXJYrE01yoIdLYPkDwU8Q1rA>
    <xmx:BSZSX3RW6wUi_plgKq6OkKahP-_lEkiTNbrnH4XYD6RWc0dsHKIv9Q>
    <xmx:CCZSX2G4vYRC82u_y20lVo9GqUC_OniYGRRzdXcxJTvy6ftjqU9fYg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FDCA3060057;
        Fri,  4 Sep 2020 07:33:25 -0400 (EDT)
Date:   Fri, 4 Sep 2020 13:33:47 +0200
From:   Greg KH <greg@kroah.com>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
        eduard@hasenleithner.at, sagi@grimberg.me, hch@lst.de,
        stable@vger.kernel.org,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: [PATCH for-stable nvmet 0/6] nvme: Fix for blk_update_request IO
 error.
Message-ID: <20200904113347.GC2831752@kroah.com>
References: <20200611155339.9429-1-dakshaja@chelsio.com>
 <20200617141541.GA712019@dhcp-10-100-145-180.wdl.wdc.com>
 <20200622112143.GA25601@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200622112143.GA25601@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 04:51:44PM +0530, Dakshaja Uppalapati wrote:
> On Wednesday, June 06/17/20, 2020 at 07:15:41 -0700, Keith Busch wrote:
> > On Thu, Jun 11, 2020 at 09:23:33PM +0530, Dakshaja Uppalapati wrote:
> > > The below error is seen in dmesg, while formatting the disks discovered on host.
> > > 
> > > dmesg:
> > >         [  636.733374] blk_update_request: I/O error, dev nvme4n1, sector 0 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0
> > > 
> > > Patch 6 fixes it and there are 5 other dependent patches that also need to be 
> > > pulled from upstream to stable, 5.4 and 4.19 branches.
> > > 
> > > Patch 1 dependent patch
> > > 
> > > Patch 2 dependent patch
> > > 
> > > Patch 3 dependent patch
> > > 
> > > Patch 4 dependent patch
> > > 
> > > Patch 5 dependent patch
> > > 
> > > Patch 6 fix patch
> > 
> > 1. You need to copy the linux-nvme mainling list for linux nvme kernel patches.
> > 
> > 2. If you're sending someone else's patch, the patch is supposed to have
> > the From: tag so the author is appropriately identified.
> > 
> > 3. Stable patches must referece the upstream commit ID.
> > 
> > As for this particular issue, while stable patches are required to
> > reference an upstream commit, you don't need to bring in dependent
> > patches. You are allowed to write an equivalent fix specific to the
> > stable branch so that stable doesn't need to take a bunch of unrelated
> > changes. For example, it looks like this particular isssue can be fixed
> > with the following simple stable patch:
> >
> 
> Hi keith,
> 
> Thanks for the review.
> 
> I initially tried pushing only the fix + required portion of the dependent 
> patches(https://www.spinics.net/lists/stable/msg387744.html) but as that 
> approach is discouraged in stable tree, I submitted all the patches as it is.
> 
> Here are the ways to fix the issue in stable tree:
> 
> •  push fix + all dependent patches
> •  push fix + custom patch of dependent patches
> •  revert the culprit patch.
> 
> Please let me know how this issue can be resolved in stable tree.

Is this still an issue?

I can't take a series of patches that is not in Linus's tree, like you
sent here, that's a non-starter.

If you want specific commits to be applied, that is one thing, and if
you need a specific patch to be reverted because it breaks things,
please provide that git id.

confused,

greg k-h
