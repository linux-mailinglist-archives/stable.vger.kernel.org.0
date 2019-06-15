Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F270470F0
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfFOPct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:32:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58897 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbfFOPct (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:32:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B3CEC21C7A;
        Sat, 15 Jun 2019 11:32:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 11:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=C4Jyev6QKzBTLrFDl1YyxLGJrLf
        IlhnUGlo5/4qqGeg=; b=nAJ+qF3yo+m9+Jl7e85tF8iwSYaoUgdbIAKoaQISlEm
        ijVgEEnlMFR3p/iWSfi2lcjXbphzELY97o+x2DXDForA5BBewRkFu5zu2ImjISVg
        UJtY//JUMZVcw2SRizZuMT5zapGj5+K6GLUzy5cX7BpOnMUB/h2q1Z8eYioTd6UZ
        15ZyT9ebipYsF19UsUupK1KhzfGwpXkbLS2TZWOluOdiVTHsE4sMpda6tBZiXLql
        JGaGv2GNTDF4gjpyoZkzUbwIulZDfO2DLgoYB9izVJTHKWSIKb/85PeSYHTC2suw
        YarBN4l14Ij9REx/SVC07JIpBSlyLc0zty55VMFpWLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C4Jyev
        6QKzBTLrFDl1YyxLGJrLfIlhnUGlo5/4qqGeg=; b=VKCiOD36yQYx2sbeTJtfdV
        HrqxKAt7GvSzwH/gOIKwpylDOnaw/Ijtenf9fyAFgdYnUog0IVJX9xKzVcSsVphX
        ZUnkxBkj8PX4taykgxLrCtE4figbDqvtqZWevVCO/4CuNc1bNvRMc1x4f0qwtbty
        mDl/N9jFRg2R+R4qXcsRnSLU0gEsThXZUDQExN/+fOUFMOu6bBDO0aEsZ9M39C8Q
        wISJ1D1nvIb8cB7PnrHaKO58lweVfw9V4lKPyyCzgP168/pIS6yAmZZwfCq3M/f5
        ppIMRFqoeJxPAVHvzaSnRowNmrgrmfyVU48Tv+oYAjFjIn8LBk9jwpP3kE+VFsJw
        ==
X-ME-Sender: <xms:oA8FXVT8VlgZo_JleH1va3sY30WfdApCy5wLBEJ8JbNv36Uq4A5zRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:oA8FXXJwij4aewstFZwJ2kLmGAcFHyxnyjHnbuYOSuUgJkF_SWOX7A>
    <xmx:oA8FXVGSRyjREjahv_IOef5514viQBGWxSW_T7lISGcMJc6lkEsLlg>
    <xmx:oA8FXRkceax2c2eCDqXmnCB5r9D6Z5h2RkMhcafMSQLFnt7EsZI4Lg>
    <xmx:oA8FXSYlbA3C8YNVJxn6ihvQEQjG2c2wGYi_9XJfYKSjVdx3R6NKnw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00E2E380086;
        Sat, 15 Jun 2019 11:32:47 -0400 (EDT)
Date:   Sat, 15 Jun 2019 17:32:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Jason Gerecke <killertofu@gmail.com>
Cc:     "# v3.17+" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Subject: Re: [PATCH 2/2] HID: wacom: Don't report anything prior to the tool
 entering range
Message-ID: <20190615153246.GC5171@kroah.com>
References: <CANRwn3Ru+7FGtsY=GaDa7pAJkuagdb6nFtvrFq1qhTWJR0rF9A@mail.gmail.com>
 <20190426163531.9782-1-jason.gerecke@wacom.com>
 <CANRwn3RBK41mRJKUPDDptoq_So6_7UxR0toaauZvjT5U=OaHWw@mail.gmail.com>
 <20190611192248.GB19775@kroah.com>
 <CANRwn3SNAQccFQEaw7Qg=hNojbFVkFRHLT3tzq_BtxpUNRiMUw@mail.gmail.com>
 <20190612071042.GA13698@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612071042.GA13698@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 09:10:42AM +0200, Greg KH wrote:
> On Tue, Jun 11, 2019 at 01:45:36PM -0700, Jason Gerecke wrote:
> > On Tue, Jun 11, 2019 at 12:22 PM Greg KH <greg@kroah.com> wrote:
> > >
> > > On Tue, Jun 11, 2019 at 12:02:47PM -0700, Jason Gerecke wrote:
> > > > I haven't been keeping a close eye on this and just noticed that this
> > > > patch set doesn't seem to have been merged into stable. There's also a
> > > > second patch series (beginning with "[PATCH 1/3] HID: wacom: Send
> > > > BTN_TOUCH in response to INTUOSP2_BT eraser contact") that hasn't seen
> > > > any stable activity either.
> > > >
> > > > Any idea what's up?
> > >
> > > I don't see these in my queue at all.
> > >
> > > What is the git commit id of these patches in Linus's tree?
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Ah, looks like the HID tree's "for-5.2/fixes" branch hasn't been
> > pulled yet. That could explain things.
> > 
> > 69dbdfffef20c715df9f381b2cee4e9e0a4efd93 HID: wacom: Sync INTUOSP2_BT
> > touch state after each frame if necessary
> > 6441fc781c344df61402be1fde582c4491fa35fa HID: wacom: Correct button
> > numbering 2nd-gen Intuos Pro over Bluetooth
> > fe7f8d73d1af19b678171170e4e5384deb57833d HID: wacom: Send BTN_TOUCH in
> > response to INTUOSP2_BT eraser contact
> > e92a7be7fe5b2510fa60965eaf25f9e3dc08b8cc HID: wacom: Don't report
> > anything prior to the tool entering range
> > 2cc08800a6b9fcda7c7afbcf2da1a6e8808da725 HID: wacom: Don't set tool
> > type until we're in range
> 
> There is nothing I can do until the patches are in Linus's tree, sorry.

Now applied for the ones that I could, you should have some "FAILED"
emails for the rejects that did not apply to 4.14.y

thanks,

greg k-h
