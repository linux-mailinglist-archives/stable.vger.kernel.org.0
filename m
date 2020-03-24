Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3408C190E01
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 13:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgCXMsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 08:48:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52111 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727431AbgCXMsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 08:48:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BADB5C0267;
        Tue, 24 Mar 2020 08:48:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 24 Mar 2020 08:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=B
        Y4Z4RYJ6jwxKjIoKLuPOtlbjqGdI4Q2Qaitx8WW4oA=; b=omRPui0Lu+I1O+4f/
        S/MwwmyKEC6AFan7mQMy6CD/KsweCkKgccaKi36r7OGv8fiIXXTsesXyAbP6XMPK
        A0njuZ7WWWtytmdViqZS3ya/a/7pTy0Z3gxerVhpzpFEJNHXmxBXVgV2k5Tm118I
        +GJBNCq/4ksGof8bWl4yqox4Vn4TpcGnSiT5hbm4LxMgMGTQJxgvYagvkAgNcjI6
        wLNtWWiE56cWWepA0C75XbYszmjJg+La/1bk2q+iCZkJvkOsx9jBBTE1PjIxkYHy
        vXYen2Ku0nSD+Ln7YoUNmPZA8GGSrtJK8PTnZrmFGWiaBPpv5ROckn1NjREkcq2x
        rEm7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=BY4Z4RYJ6jwxKjIoKLuPOtlbjqGdI4Q2Qaitx8WW4
        oA=; b=g95Pz5qHOZZxptMhYmFVq7PYuRoAxTrn2pTVCVvms82NDR4WxF3q84J3y
        RNZXHxs5II7F6pzJ2sJvngCeKt/35O14lC9PRhqnRyHa6fTV9d+JKaUnCdKGuauS
        YkjXUKwYESxL/ZUfIVZMOPazJYvgOsz5BiEpN8vb8wkMs7sKgsiapu/l2PU2nRZM
        X6m9PQr8HcNwjtavjoLZTRBfkjHtbY/u/gyZvN6KhWlOVGobBU21aIKZLvDqzo7K
        wY7WD1zJW0GYWFbpcDEIT5/5YoEb1KRKv7kNqPIHYTN7bwj493N921A/oJLg1Lie
        SRKEHwBGO+FI3kWIkVw27rtTNy3ZQ==
X-ME-Sender: <xms:iAF6XhTu1MMpzxLEqIdB5OWOaHn5O0aV3-GOv1bRI8_YJE-jG5dFhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghdprghmrgiiohhnrgifshdrtghomhenucfkphepkeefrdekiedrkeelrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvg
    hgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:iAF6XrUKsJSzLNCwqEeOQtes1bLPfbTPzkt_0l6a1mLJrPsiQ-n06w>
    <xmx:iAF6XiNAgbiusydgklTb1dppHJyb4uCyA3jmdQ44AFZoaISc3FfvkQ>
    <xmx:iAF6XrrNhWlu3lvEcP4CM4tcmRXP88RfL66eVTK6f4LmE-CxiqUKpA>
    <xmx:iQF6Xs_KEJaY7pyvTwgsokHAIncHO9ozq4QrrJZCnb6TwJKeMdLfCw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 721793065183;
        Tue, 24 Mar 2020 08:48:08 -0400 (EDT)
Date:   Tue, 24 Mar 2020 13:48:07 +0100
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Memory Management <mm-qe@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?=
 Test?report?for?kernel 5.5.12-rc1-8b841eb.cki (stable)
Message-ID: <20200324124807.GA2401396@kroah.com>
References: <cki.936A32626F.M0L95JS69X@redhat.com>
 <20200324062213.GA1961100@kroah.com>
 <970614328.15180583.1585048327050.JavaMail.zimbra@redhat.com>
 <20200324111819.GA2234211@kroah.com>
 <1768018191.15186361.1585050272846.JavaMail.zimbra@redhat.com>
 <20200324114727.GA2333047@kroah.com>
 <290791291.15199861.1585053755727.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <290791291.15199861.1585053755727.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 08:42:35AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "Greg KH" <greg@kroah.com>
> > To: "Veronika Kabatova" <vkabatov@redhat.com>
> > Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek" <omosnace@redhat.com>, "Linux Stable maillist"
> > <stable@vger.kernel.org>, "CKI Project" <cki-project@redhat.com>, "Jan Stancek" <jstancek@redhat.com>, "LTP Mailing
> > List" <ltp@lists.linux.it>
> > Sent: Tuesday, March 24, 2020 12:47:27 PM
> > Subject: Re: 💥 PANICKED: Test	report?for?kernel 5.5.12-rc1-8b841eb.cki (stable)
> > 
> > On Tue, Mar 24, 2020 at 07:44:32AM -0400, Veronika Kabatova wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "Greg KH" <greg@kroah.com>
> > > > To: "Veronika Kabatova" <vkabatov@redhat.com>
> > > > Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek"
> > > > <omosnace@redhat.com>, "Linux Stable maillist"
> > > > <stable@vger.kernel.org>, "CKI Project" <cki-project@redhat.com>, "Jan
> > > > Stancek" <jstancek@redhat.com>, "LTP Mailing
> > > > List" <ltp@lists.linux.it>
> > > > Sent: Tuesday, March 24, 2020 12:18:19 PM
> > > > Subject: Re: 💥 PANICKED: Test report	for?kernel 5.5.12-rc1-8b841eb.cki
> > > > (stable)
> > > > 
> > > > On Tue, Mar 24, 2020 at 07:12:07AM -0400, Veronika Kabatova wrote:
> > > > > 
> > > > > 
> > > > > ----- Original Message -----
> > > > > > From: "Greg KH" <greg@kroah.com>
> > > > > > To: "CKI Project" <cki-project@redhat.com>
> > > > > > Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek"
> > > > > > <omosnace@redhat.com>, "Linux Stable maillist"
> > > > > > <stable@vger.kernel.org>, "Jan Stancek" <jstancek@redhat.com>, "LTP
> > > > > > Mailing List" <ltp@lists.linux.it>
> > > > > > Sent: Tuesday, March 24, 2020 7:22:13 AM
> > > > > > Subject: Re: 💥 PANICKED: Test report for	kernel
> > > > > > 5.5.12-rc1-8b841eb.cki
> > > > > > (stable)
> > > > > > 
> > > > > > On Tue, Mar 24, 2020 at 05:42:38AM -0000, CKI Project wrote:
> > > > > > > 
> > > > > > > Hello,
> > > > > > > 
> > > > > > > We ran automated tests on a recent commit from this kernel tree:
> > > > > > > 
> > > > > > >        Kernel repo:
> > > > > > >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > > > >             Commit: 8b841eb697e1 - Linux 5.5.12-rc1
> > > > > > > 
> > > > > > > The results of these automated tests are provided below.
> > > > > > > 
> > > > > > >     Overall result: FAILED (see details below)
> > > > > > >              Merge: OK
> > > > > > >            Compile: OK
> > > > > > >              Tests: PANICKED
> > > > > > > 
> > > > > > > All kernel binaries, config files, and logs are available for
> > > > > > > download
> > > > > > > here:
> > > > > > > 
> > > > > > >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/23/502039
> > > > > > > 
> > > > > > > One or more kernel tests failed:
> > > > > > > 
> > > > > > >     ppc64le:
> > > > > > >      💥 xfstests - ext4
> > > > > > > 
> > > > > > >     aarch64:
> > > > > > >      ❌ LTP
> > > > > > > 
> > > > > > >     x86_64:
> > > > > > >      💥 xfstests - ext4
> > > > > > 
> > > > > > Ok, it's time I start just blacklisting this report again, it's not
> > > > > > being helpful in any way :(
> > > > > > 
> > > > > > Remember, if something starts breaking, I need some way to find out
> > > > > > what
> > > > > > caused it to break...
> > > > > > 
> > > > > 
> > > > > Hi Greg,
> > > > > 
> > > > > do you have any specific suggestions about what to include to help you
> > > > > out?
> > > > > The linked console logs contain call traces for the panics [0]. Is
> > > > > there
> > > > > anything else that would help you with debugging those? We're planning
> > > > > on
> > > > > releasing core dumps, would those be helpful?
> > > > 
> > > > Bisection to find the offending commit would be best.
> > > > 
> > > 
> > > This is going to be really tricky for hard to reproduce bugs but we'll do
> > > some research on it, thanks!
> > 
> > I got about 8 "failed" emails today, it doesn't sound like it is hard to
> > reproduce.
> 
> I meant in general, as we do catch a bunch of such problems. Those usually
> require some input and testing from people who understand the subsystem to
> create a reliable reproducer.
> 
> For this particular failure, do you want to try out the patches I linked
> in the first email or should we waive them for now?

As this must be something new introduced by my current queue, why not
find out what patch in there is causing the problem?

If this is caused by something NOT in my queue, and is also a problem
upstream in Linus's tree, then you need to notify the upstream
developers as there's nothing I can do about it, right?

If this is not upstream, but is a problem in the stable tree, then
please submit the patches that fix the issue as documented in the stable
kernel rules document for how to submit them.

To throw this horrible "something is BROKEN!" type email at me all the
time just makes me want to delete it as I have no context at all.

thanks,

greg k-h
