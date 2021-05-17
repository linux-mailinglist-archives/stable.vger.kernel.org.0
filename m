Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DDF38329F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbhEQOuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:11 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:44367 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240372AbhEQOre (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 10:47:34 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id CDFE8D73;
        Mon, 17 May 2021 10:46:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 17 May 2021 10:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=7
        AomO9JXrdrY5Ih8pwTBGgUCrP2fDKFQt8ByFGJboIw=; b=vWcu1QQ13t6CN5L8M
        wzDYniNWTE3YSpKp/0sobqLNyRtK6G0Vwv3sifiYygPkcFB95H5Lke8RGQM4z/6n
        42s25Z9eYYL4WxTy9tRoYjynovpVbgQyS3SeBv1XZD9vaBeLJ/nUR9xPyoczcXMP
        3HKsEZp67uw9Njtg/8GJTS8uQJdsyy5/JacKeQegQdZyKQVec80LHXzIthxOPTE+
        1HXgVZrm0FzDZyCIJOy5L46bl6FESN335Lezzv+sZOyROpDJ2nEkLinagdz11nms
        cFoTgRiCHQ8CTZ32JZFR4gCIwI1ALLI2OT2Hlf5seotMZTfuLjhSB6J0pHg7Embz
        HMSHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=7AomO9JXrdrY5Ih8pwTBGgUCrP2fDKFQt8ByFGJbo
        Iw=; b=drtKUgCoF/wRXn6tLqFNgJbrQxpz+g1kfPTZYuHjpjDS921U8up3wHiIm
        qZkDck3tDB8SjAw1f1qeevo3yOTJ4m8oBJiMRUyKkNSvo/coVKfDdBXo/d+cu7YP
        dwJ8cvyBi2OWPSVkSuMj/R3NidbH+8kSExXazpGA46zVQ0V4lf311tGS0tQ7wJaX
        Sp3Vzk+XDDRNKTUAgPE67lGyVG0ilS3gnGYiX2qXT72zuqKnnaZqDnE9U8hbFzjI
        kmuTG8/p3zRmo+C+AepF4kpMEBn72ThQEo99gdD25g19TGrizu2QBwERxbk68sDt
        slcoRs26/QEZrrKOPfVWvz6kQuR7w==
X-ME-Sender: <xms:t4GiYHZC1I1hxsZsvIqYmk2yVx3axOgct3nyKp2u49mOzASIxdCWBQ>
    <xme:t4GiYGZs1PeenYyroaBvFinz_4kun_WHJlYUDc6iLhyy7fymCxhbsALY4DZFny5C_
    2qRwNiEop0Mzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggugfgjsehtke
    ertddttdejnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeegieejuedvffeuvdfftdetfeeuhfekhefgueffjeevte
    dtlefgueduffffteeftdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:t4GiYJ8jPrgBE8QrMnbOjoq1OGG0hX5JHNwtKcGfDxzv7toJoG9dww>
    <xmx:t4GiYNpw7UO2IPXi2VDoy8ZLoM0GkpeHeHCMZy4CAsNdld95Rf0jRA>
    <xmx:t4GiYCqtuJB-v9G2_t1ERt4OXD7HNQ_vcvI40nShdlVSFwNP6j-QNA>
    <xmx:uIGiYPAqa0Uv_1mWsmC_A-jmdOT0YtqtAJPIXnJ5YcojAcyNLQw7og>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 10:46:15 -0400 (EDT)
Date:   Mon, 17 May 2021 16:12:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        stable <stable@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config
 does
Message-ID: <YKJ5ysGAuI32Jpn6@kroah.com>
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de>
 <YKI/D64ODBUEHO9M@kroah.com>
 <1621251453@msgid.manchmal.in-ulm.de>
 <1621251685@msgid.manchmal.in-ulm.de>
 <CA+res+RHyF22T-sGwCG5zA6EBrk_gWbnZETX_iAgdRdWaPLbfw@mail.gmail.com>
 <1621254246@msgid.manchmal.in-ulm.de>
 <CA+res+QRm3VyJSjMaKLYm=KY5+T5nX+6-QhOgrgBcP+d2Ganag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+res+QRm3VyJSjMaKLYm=KY5+T5nX+6-QhOgrgBcP+d2Ganag@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 02:45:01PM +0200, Jack Wang wrote:
> Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de> 于2021年5月17日周一 下午2:25写道：
> >
> > Jack Wang wrote...
> >
> > > Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de> 于2021年5月17日周一 下午1:52写道：
> > > >
> > > > Christoph Biedl wrote...
> > > >
> > > > > Thanks for taking care, unfortunately no improvement with 5.10.38-rc1 here.
> > > >
> > > > So in case this is related to the .config, I'm attaching it. Hardware is,
> > > > as said before, an old Thinkpad x200, vendor BIOS and no particular modifications.
> > > > After disabling all vga/video/fbcon parameters I see the system suffers
> > > > a kernel panic but unfortunately only the last 25 lines are visible.
> > > > Possibly (typos are mine)
> > > >
> > > >     RIP: 0010:__domain_mapping+0xa7/0x3a0
> > > >
> > > > is a hint into the right direction?
> > > This looks intel_iommu related, can you try boot with
> > > "intel_iommu=off" in kernel parameter?
> >
> > Gotcha. System boots up fine then.
> >
> >     Christoph
> So it's caused by this commit[1], and it should be fixed by latest
> 5.10.38-rc1 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/log/?h=linux-5.10.y
> [1]https://lore.kernel.org/stable/20210515132855.4bn7ve2ozvdhpnj4@nabokov.fritz.box/

Hopefully the "real" 5.10.38-rc1 release that is out now should fix
this.  If not, please let us know.

thanks,

greg k-h
