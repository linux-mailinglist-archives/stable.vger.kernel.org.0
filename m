Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0672BB5B57
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 07:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfIRFww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 01:52:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53431 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbfIRFww (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 01:52:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C8493222BA;
        Wed, 18 Sep 2019 01:52:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 18 Sep 2019 01:52:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=yApEeM+cx/E4QTe1WjDT5jZr1YH
        cZM80TBsuKqJwhoU=; b=YCFY/y/eLPs0MW5E8Gblp4ZMmbBw7GlX5JgQgnfo6o5
        CFjN8lsSv7c8xpwNoVft/+Iz4a1OdGFW8VLeh+02/JViuvo7gzlDH1tVNpVwtrGa
        DRDdzQ35e1SpnB4FlbAw+DIjOB49TOZCjIABftiUhzOJmvztzTxfghK+iE6cphY1
        mzBbapgIjg/0eakfgYrcAmlgmIdux1/EvQRXLAHA7wEUXfeZtnf9+R6rbWtgNlA1
        6OwMtB9k9gZerpGvocHhd8EE+YhR57dtYnRu1VDqxt2Fo/oxJRjmBJDpVzAiBxLF
        z7aXlc1sYNQB3bgZCUOXY3vBTwTr4Tvch14P2xX2uxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yApEeM
        +cx/E4QTe1WjDT5jZr1YHcZM80TBsuKqJwhoU=; b=1mjtKNTkHWi7g22WLFIbOD
        Mc9vdk7g/h7aDxfqyuFsLIfOnU7aqPRyOVNIlZeSuZIZfKc2UjjPfswoiibIOAVY
        Fb+OYWhO0rJcswhtAMdVEXxxYDYPFDQm9Tc8W7suuhECLfhm/rYAMZvlUXlecKli
        tKICy5v2NbxuFPKWFDzk0r1ix00Ii/H3BkVjfgHGrggdxtOnvoCFoi8s2+RmDn9L
        Vx1WhkZGinXJPE8X/LhiSN+y3qfz9UbW9u21UyP5GZWxeRhlGbRgXZiEaggtXIFz
        iv7gc6pIs79mtssIZD3qy2LszqVSg/eo4witDz+EJDfQ3BIvWjKpoMlWaUoI3w8g
        ==
X-ME-Sender: <xms:MMaBXUgofsVIGyapbzM9S8gfWHi0AC2ZFr2bKl8dm2_usXLeRZaC8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:MMaBXaauZV0g62-XlXG-2OKdFkR3TYIQ0ybywrf6YzDgvmtKm0G2qQ>
    <xmx:MMaBXTb4Pu3W00bvJuaVXnCLkeTfr5uWqWEjm4nSCZ_TwYvp3uqecA>
    <xmx:MMaBXfybWNApS0-krnX1wj71OqYaxzsS3zZ2WcqXXTL2E80fUCi_Vw>
    <xmx:MsaBXZJx264xcrTbgq3IBJfKvD8LA9mmgykxr53TBfKAcFbJOqH4_Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92778D6005A;
        Wed, 18 Sep 2019 01:52:48 -0400 (EDT)
Date:   Wed, 18 Sep 2019 07:52:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH for 5.2.y] mtd: cfi_cmdset_0002: Use chip_good() to retry
 in do_write_oneword()
Message-ID: <20190918055246.GC1830105@kroah.com>
References: <20190917175048.12895-1-ikegami.t@gmail.com>
 <20190917181127.GD1570310@kroah.com>
 <7c0113e0-d455-e3e6-86fc-45429be196fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c0113e0-d455-e3e6-86fc-45429be196fb@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 07:32:39AM +0900, Tokunori Ikegami wrote:
> 
> On 2019/09/18 3:11, Greg KH wrote:
> > On Wed, Sep 18, 2019 at 02:50:48AM +0900, Tokunori Ikegami wrote:
> > > As reported by the OpenWRT team, write requests sometimes fail on some
> > > platforms.
> > > Currently to check the state chip_ready() is used correctly as described by
> > > the flash memory S29GL256P11TFI01 datasheet.
> > > Also chip_good() is used to check if the write is succeeded and it was
> > > implemented by the commit fb4a90bfcd6d8 ("[MTD] CFI-0002 - Improve error
> > > checking").
> > > But actually the write failure is caused on some platforms and also it can
> > > be fixed by using chip_good() to check the state and retry instead.
> > > Also it seems that it is caused after repeated about 1,000 times to retry
> > > the write one word with the reset command.
> > > By using chip_good() to check the state to be done it can be reduced the
> > > retry with reset.
> > > It is depended on the actual flash chip behavior so the root cause is
> > > unknown.
> > > 
> > > Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > > Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
> > > Cc: linux-mtd@lists.infradead.org
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Fabio Bettoni <fbettoni@gmail.com>
> > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> > > Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> > > [vigneshr@ti.com: Fix a checkpatch warning]
> > > Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> > > ---
> > >   drivers/mtd/chips/cfi_cmdset_0002.c | 18 ++++++++++++------
> > >   1 file changed, 12 insertions(+), 6 deletions(-)
> > >   mode change 100644 => 100755 drivers/mtd/chips/cfi_cmdset_0002.c
> > You changed the file to be executable???  That's not ok :(
> 
> Very sorry for this.
> I missed it to fix to not be executable since it was changed to be
> executable on my local environment.
> Anyway I will do fix it.

Please do, we can not take these patches as-is at all.

> > Also, what is the git commit id of this patch in Linus's tree?  I can't
> > seem to find it there.
> 
> Actually it has not been pulled in Linus's tree.
> But it has been merged into
> git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next for
> v5.4-rc1 as the git commit id 37c673ade35c.
> So I thought as that it is okay to send the patches for the stable trees.
> But should I wait to be pulled the patch in Linus's tree at first?

Yes, you have to wait, please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

thanks,

greg k-h
