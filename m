Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C2539F946
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhFHOha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:37:30 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:50319 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232911AbhFHOh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:37:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id AC4C81B4E;
        Tue,  8 Jun 2021 10:35:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Jun 2021 10:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=Z
        BJEHdSWntFaR1di2cSYSVQKl/fJ/upIcuZ2McqMt3g=; b=Vs/gpuN0XDSjEVmTZ
        s+k72E87oIbJdsjp5jXxFvTwf/5nl5azsb8mNBFhMrrAWoZjKiVa+FR0AqU66ENY
        gQSOgkKCuUs5EKhHf8aqCp6cZx4tmz2x6/S352Xsf7ViQ0eQ+027IRA37tVx3U0x
        dXa7SmczRo0jaUA2nb5nD9Da6fRantnSYPAmoovy5eYu+0keS29ASuVdNzH2C3Ne
        g34IkgS8JGol3AS0xZdjQD8avM0ifiCt6bsygULVf6UhPLHm7+UUrHd92oeiYQOy
        b2es+H+UrQ5HDHN0dBBgE2E36PaHSbq6uXptn5rVBQv0usc6s4lXzfIXR/ChGAtG
        5CXyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=ZBJEHdSWntFaR1di2cSYSVQKl/fJ/upIcuZ2McqMt
        3g=; b=R9A8/zV2lR1tYxZVdW09dhtrB2QCcG0OeZz/0WO4MzgfZS5rYW4wvtVFk
        ngOQ/KYVGSWfbNlsIdkPlqax6PIN6tXI5Wywxack9CpYOiEWSr9qvxjCGqSBFsmx
        Q+D/qx0zXD/nHSYHeb+Wim8M7pqrVyjr+EPHMYUUL8p5ecOZvk4DdxD30p85Z6WK
        CINy8KSL5SyrDW4v1jbJP1w2GJZK6f7Vx4TaVUY+PMIV1lH3v8rJ3l4ukO41OTi6
        WGekZpjg9z55WPZwFZls/wb0iN07g1QIQ7DPVepJOGyBWr0dD4x8JaygvbG5UUWW
        /0thip0HFtAFYEHO8onBOJ7ZmniuA==
X-ME-Sender: <xms:NIC_YEX4TTGeJlFBXEuvjN6UL7Pm8a9oGcHYsLH3hbgS3p_A3mEFCg>
    <xme:NIC_YInP0gizG2_pcQo03cRpUOGOje16rXstCIWnSe9Z7Nz2nQr9WkmaMCP3Suqr9
    1hQIrWodnGHuw>
X-ME-Received: <xmr:NIC_YIbL4z83uK_ODFzVnyvsgvQ1Z8GToxnWmGOFbEE0JY9M2YyCBMEV9WZcR-Iwns3Tb-1BG5dj1HKI0EZgNBZzkkessLZ2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeeije
    euvdffuedvffdtteefuefhkeehgfeuffejveettdelgfeuudffffetfedtnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NIC_YDV4Q_V_BW82WnQQk5JD2UFYtspmAyLtP10BjUGgz-MhNgveeQ>
    <xmx:NIC_YOmQ2Q78PP7mIZHTngzP-EdwFFwmBDVC4R29DmxX8NgYvEYSpg>
    <xmx:NIC_YIelhvD32bMx3XWTs-Wv3sH-ixdkSUbNUpioRQQKrif7zEmkOA>
    <xmx:NIC_YMb4bSs_ip0kAqJDK6Q1RsfkaG4_iurF7Nl7ytP_TkoCEZNz1w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 10:35:31 -0400 (EDT)
Date:   Tue, 8 Jun 2021 16:35:30 +0200
From:   Greg KH <greg@kroah.com>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     =?utf-8?Q?Lauren=C8=9Biu_P=C4=83ncescu?= <lpancescu@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Backporting fix for #199981 to 4.19.y?
Message-ID: <YL+AMiD7falsvZOf@kroah.com>
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com>
 <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
 <YLiel5ZEcq+mlshL@kroah.com>
 <addc193a-5b19-f7f3-5f26-cdce643cd436@gmail.com>
 <YLpJyhTNF+MLPHCi@kroah.com>
 <YLzAw27CQpdEshBl@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YLzAw27CQpdEshBl@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 06, 2021 at 02:34:11PM +0200, Salvatore Bonaccorso wrote:
> Hi Laurențiu, Greg,
> 
> On Fri, Jun 04, 2021 at 05:42:02PM +0200, Greg KH wrote:
> > On Fri, Jun 04, 2021 at 04:50:19PM +0200, Laurențiu Păncescu wrote:
> > > Hi Greg,
> > > 
> > > On 6/3/21 11:19 AM, Greg KH wrote:
> > > > That commit does not apply cleanly and I need a backported version.  Can
> > > > you do that and test it to verify it works and then send it to us to be
> > > > applied?
> > > 
> > > I now have a patch against linux-4.19.y, tested on my EeePC just now: the
> > > battery status and discharge rate are shown correctly.
> > > 
> > > I've never submitted a patch before, should I put "commit <short-hash>
> > > upstream." as the first line of my commit message, followed by another line
> > > stating which branch I would like this to be merged to? Should I also
> > > include the original commit message of the backported commit? And then use
> > > git format-patch? I just read through [1] and [2], but they don't say
> > > anything specific about commit messages for backported patches.
> > 
> > Yes, what you describe here should be great.  Look at the stable mailing
> > list archives on lore.kernel.org for other examples of this happening,
> > https://lore.kernel.org/r/20210603162852.1814513-1-zsm@chromium.org is
> > one example.
> 
> Instead of doing a specific backport, maybe it is enough to pick
> a46393c02c76 ("ACPI: probe ECDT before loading AML tables regardless
> of module-level code flag") frst on 4.19.y and then the mentioned fix
> b1c0330823fe ("ACPI: EC: Look for ECDT EC after calling
> acpi_load_tables()").

I do not see a commit a46393c02c76 in Linus's tree :(

Are you sure these ids are correct?

thanks,

greg k-h
