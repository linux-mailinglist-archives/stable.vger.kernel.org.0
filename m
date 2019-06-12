Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9DF41D3B
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 09:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404970AbfFLHKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 03:10:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33535 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731214AbfFLHKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 03:10:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 95AD322270;
        Wed, 12 Jun 2019 03:10:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 12 Jun 2019 03:10:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=EZEFr6YCgz8C6D10pHbH+NPew15
        2sAcmOvoaUKwuywg=; b=D2qN5iQGTM69rrFD0zryqFRAIoNkcoF1zSQtRyr9MHj
        YJdloZk7ZmyOZV/u0tL6hUUwzBo6RyUhAFs+IoEaBh74TAFPNdGCbqYiuSnH6vU/
        3+vnm7q93oyve02nuH43besw3h5dCt29IPdXALLV3Jm8lbs7+53LdpD1jfQ3v3IO
        2MxJmepfLk0PR8rGQ/t0518Z4ySFx6D6pxFVaj/ollJ/xrNh9G5YcfgVunwU7FH8
        gvoBV4snqgCXPOdsuywNh66kCVnh2QeAX5ApV7ww1bhgt/8+/rqkRMJ3yhQDV8jt
        t6Qxi6LPk4OM52QDaETUI+pQRBmirYNu+XYEu87OwbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EZEFr6
        YCgz8C6D10pHbH+NPew152sAcmOvoaUKwuywg=; b=aiBevapcYUrf59/9Imu1Ym
        b4nqtvDI4yWUqzmNKuqQ14vZcnxOf+hiXj2tzSDJAn8IRbFSbWxh86BUksDBSWa9
        TQMkztFixcqDdOoolrSukFSVe16CyapxqfHPhOgJ9oDOM1VBKRcjBLyS2F/EMzTx
        yVW6x6eelOqj9W6nANS5Oe40/yFPQzrVTcVk25onhSyM6waCHFae8/6M8VmRmHeP
        DgYWHUEebi6VEA4DeOJlXx29aaKw7jAD0WcpChj875v+7Z65Wjq99L3ArsIroSLg
        WaDS1N9G86dnQRgY6F7vodf0ftq3wrafW0y2w9idRmORsiq6NmTfx06mc+Pfz5pw
        ==
X-ME-Sender: <xms:daUAXfmR1Q8vlRhrKD-GNhZ_4oYkVAL-0c89Hctk2-HXY9hIguSMhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehiedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:daUAXa-un0k9ejQF_GS2p6AUlFpF-DTseSbsbIidBf_mcEp7SSjhBQ>
    <xmx:daUAXVKo22SwpnLwBktkD2kvS6sig0C_r3IMl0mC8SIUy_JB1tXwkA>
    <xmx:daUAXXjVwuSZf7INcV-XgXV4EsNcKN569bAz3vkfeGJvghAcqjWoAQ>
    <xmx:daUAXQea4KNrzpLr10Pey9CxDf7-6BmCIsre8SfF4zDd2HjMsiMmvg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9EA9B380089;
        Wed, 12 Jun 2019 03:10:44 -0400 (EDT)
Date:   Wed, 12 Jun 2019 09:10:42 +0200
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
Message-ID: <20190612071042.GA13698@kroah.com>
References: <CANRwn3Ru+7FGtsY=GaDa7pAJkuagdb6nFtvrFq1qhTWJR0rF9A@mail.gmail.com>
 <20190426163531.9782-1-jason.gerecke@wacom.com>
 <CANRwn3RBK41mRJKUPDDptoq_So6_7UxR0toaauZvjT5U=OaHWw@mail.gmail.com>
 <20190611192248.GB19775@kroah.com>
 <CANRwn3SNAQccFQEaw7Qg=hNojbFVkFRHLT3tzq_BtxpUNRiMUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRwn3SNAQccFQEaw7Qg=hNojbFVkFRHLT3tzq_BtxpUNRiMUw@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 01:45:36PM -0700, Jason Gerecke wrote:
> On Tue, Jun 11, 2019 at 12:22 PM Greg KH <greg@kroah.com> wrote:
> >
> > On Tue, Jun 11, 2019 at 12:02:47PM -0700, Jason Gerecke wrote:
> > > I haven't been keeping a close eye on this and just noticed that this
> > > patch set doesn't seem to have been merged into stable. There's also a
> > > second patch series (beginning with "[PATCH 1/3] HID: wacom: Send
> > > BTN_TOUCH in response to INTUOSP2_BT eraser contact") that hasn't seen
> > > any stable activity either.
> > >
> > > Any idea what's up?
> >
> > I don't see these in my queue at all.
> >
> > What is the git commit id of these patches in Linus's tree?
> >
> > thanks,
> >
> > greg k-h
> 
> Ah, looks like the HID tree's "for-5.2/fixes" branch hasn't been
> pulled yet. That could explain things.
> 
> 69dbdfffef20c715df9f381b2cee4e9e0a4efd93 HID: wacom: Sync INTUOSP2_BT
> touch state after each frame if necessary
> 6441fc781c344df61402be1fde582c4491fa35fa HID: wacom: Correct button
> numbering 2nd-gen Intuos Pro over Bluetooth
> fe7f8d73d1af19b678171170e4e5384deb57833d HID: wacom: Send BTN_TOUCH in
> response to INTUOSP2_BT eraser contact
> e92a7be7fe5b2510fa60965eaf25f9e3dc08b8cc HID: wacom: Don't report
> anything prior to the tool entering range
> 2cc08800a6b9fcda7c7afbcf2da1a6e8808da725 HID: wacom: Don't set tool
> type until we're in range

There is nothing I can do until the patches are in Linus's tree, sorry.

greg k-h
