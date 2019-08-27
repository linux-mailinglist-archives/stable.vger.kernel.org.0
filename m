Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6A89F273
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 20:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfH0Shq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 14:37:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45053 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728972AbfH0Shq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 14:37:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1B58321FF5;
        Tue, 27 Aug 2019 14:37:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 27 Aug 2019 14:37:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=b
        WPRqRoBAYL9+wuTgmAxfoGq3fttosj1XIJV0k/FbQs=; b=JcN9kQ2G33KetE3pj
        BPVSLbs/orFZuLwNgG2fpa/jTqs1e90MoO0Y5E4Dy8cHaGsnwrGZJ56CaXXacxOu
        A2FKUrkp6J+X8spdIanef9LNj1u7SjeF/9UW1JTugyjehgAfod6ne0upbkZWD4c5
        LxdPelNz0+3HZFm8uvDdcyAniv9OoUliEh161YwG38ohBgNrc2PCZnXKMrHQB20J
        Lb75FhZ2u3ebAitC1G1gmsYLq9KDT83hZHaTwFyIOZzqZiCD3ldttzy5iu/indp5
        VnLhXKEwBCk4xR3js8H6lHfXOxZnZYuHBXGxvB7WL03+EX4VHDFXiKdsxXBbrStD
        eU8iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=bWPRqRoBAYL9+wuTgmAxfoGq3fttosj1XIJV0k/Fb
        Qs=; b=PBwHqdA2aLPLP0P367TQelYa6t60pJxEQdAL/lcbo3DD9FprkEFLmw0o4
        YC0Li8HfymeC0SH/ThU6XSnsz+Jy5h8XEiVDeMt7nNYpMBsrQkDZI5I7lc0r6m0P
        jYW3rqIdJxvr8zeODXoZVZh32tJ3zlx2PMj4QyentZfufjdNuHjHP9F1X1Jn5HmD
        7dveElt6JIv/mAIvcJ98N3/e8PYTAyxBFyBEohB8fkAFvUkOKQEx2uc7tRRyOKm8
        x4X1IozH8574yIMTsTyDJ7lpcgjSLCDZskTKDGiZzLpvwLyref8MiI1EbwFf8TF5
        65kWzaDD/PS41L/ortEhSunWwOkTA==
X-ME-Sender: <xms:eHhlXWyfSHY_8WRSPQZygTI13PJxQ94Om3qY2cPDX4-1MnddtGarug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehkedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:eHhlXW6K5bDNOwqLRvYEak5Pp29BxPlWJyL5hk1hwDgBjU6aLIRi9Q>
    <xmx:eHhlXQdcE0klQ4u7KCeHxTD7DZOXuJ_05V0gGNe4LdeK_Or5prnFyg>
    <xmx:eHhlXWqHPb4yTz9VtcfD-VEUlZbmBUP6s8MyZynGqATsuIL9WyM52g>
    <xmx:eXhlXYwlgIze0w4rhlGv3FefzVuN0W8fC8SSjnWa8aEnz_SOwtKwow>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BB5AD6005F;
        Tue, 27 Aug 2019 14:37:44 -0400 (EDT)
Date:   Tue, 27 Aug 2019 20:37:42 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Major Hayden <major@mhtx.net>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Yi Zhang <yi.zhang@redhat.com>, Xiumei Mu <xmu@redhat.com>,
        Hangbin Liu <haliu@redhat.com>, Ying Xu <yinxu@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.2.11-rc1-9f63171.cki (stable)
Message-ID: <20190827183742.GA2498@kroah.com>
References: <cki.98AD376375.DJWRK5AJEY@redhat.com>
 <291770ce-273a-68aa-a4a2-7655cbea2bcc@mhtx.net>
 <20190827170518.GB21369@kroah.com>
 <20190827182536.GS5281@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190827182536.GS5281@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 02:25:36PM -0400, Sasha Levin wrote:
> On Tue, Aug 27, 2019 at 07:05:18PM +0200, Greg KH wrote:
> > On Tue, Aug 27, 2019 at 09:35:30AM -0500, Major Hayden wrote:
> > > On 8/27/19 7:31 AM, CKI Project wrote:
> > > >   x86_64:
> > > >       Host 2:
> > > >          ❌ Networking socket: fuzz [9]
> > > >          ❌ Networking sctp-auth: sockopts test [10]
> > > 
> > > It looks like there was an oops when these tests ran on 5.2.11-rc1 and the last set of patches in stable-queue:
> > 
> > Can you bisect?
> 
> I think I've fixed it, let's see what happens next run.

Ah, good catch, thanks for that!

greg k-h
