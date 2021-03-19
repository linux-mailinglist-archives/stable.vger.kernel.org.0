Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463C23418B2
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhCSJp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:45:57 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34873 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229785AbhCSJp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 05:45:27 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D65E5C010F;
        Fri, 19 Mar 2021 05:45:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Fri, 19 Mar 2021 05:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=sf4eKuH1Dm4nnkXWvtyBMir/RJ6
        /FP6niWSIhyuVtYs=; b=Zu+VPnbQKat7HGyyYv8T4OEAJ0XapBTJrbcgiTgaOXn
        Rg3PMur5EZNF4Vpok02O2mD7Rqf0+0gA07DZ0y6UswB1XYlm57MvXiQgNfsRq5GR
        AeLFmK1JD8EwUFgnUs9wdzsYHs5xhrhOhK4mOcB7LReFla8bs2VPqs1+mZbopMlg
        0620kJ0g+/jpBQuybMIq28WwVSZlRQ0k/pTV0e80BDlz17o1V6zGCVVdCYgR5OSJ
        rLWzZaHGd4+p6iOk3cuVx9GWAViZN2RPhx3hJ8ggHT95PbTXobyCPT3Qtsl5TSyj
        WtURE/faOipLJCdCi2pEbRMaeJCDKrCkUZ2lnqKZIWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sf4eKu
        H1Dm4nnkXWvtyBMir/RJ6/FP6niWSIhyuVtYs=; b=N8MLLoSba7kQ7FvaY7z0b3
        tUh11hUptAGL7sUkrxHpAT8zBTSjA+MRXutQmrzELZ4R7SuldkYEAiJpC7Xn6Q1V
        QZ3jPoijgAi0mtElk3NSfOk2U8sxJZ6IfrOlvE44G1a216MW7AVMZjFs2lkKnNYo
        EpC79YeNA8N4jGCVuTVpKwVYZyhNVLh0Bq3lpPTJtJQLv0Bz/4sD/e98LJ9SIBez
        meDVXOLxTqckJVafPyTr9LMLBnsNhSZQMMBY8QQz7F2Q5uTpk0KKl5CzGFIFJqIO
        ELRnU1uGINnLpBNfpVjCrhxnkXvwImyT9t4psptDBiQofiOlmUm0B+mr+nN+WUzA
        ==
X-ME-Sender: <xms:s3JUYLRq8fhgeq43WzV9pcDK2Dwp7_evwjL25Z6C9XblWBh3wf4YNA>
    <xme:s3JUYMunDcOOSnG2r6g9SsANUfXrZg0AjuCScnQdzJZBADD7_BW01rrnF02sJQlmU
    CVrvPh_9N1Cew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefkedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:s3JUYNvI2at8J28xMRMmiD49W1OSLTME0pvWLl2A0Ct9Rg1AJdDk6A>
    <xmx:s3JUYCw0vquiyrwIdZ6n_WCuGq_rLNb1GKr8u77Iq7b9o-78IYP22Q>
    <xmx:s3JUYDjIalIwesFXZh3KhdSdD_37sl6xiawwdIwKydN-Gso-6Jfh0Q>
    <xmx:tHJUYC8SYjM_vql8Aucw7VGdrFpZNGLsHrI9-zrZiYPYjvUvq98cFw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C38E24005B;
        Fri, 19 Mar 2021 05:45:23 -0400 (EDT)
Date:   Fri, 19 Mar 2021 10:45:21 +0100
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, maz@kernel.org, dbrazdil@google.com
Subject: Re: [PATCH v2][for-stable-v5.11] arm64: Unconditionally set virtual
 cpu id registers
Message-ID: <YFRysSLvd8Ekdl5f@kroah.com>
References: <20210316134319.89472-1-vladimir.murzin@arm.com>
 <20210317132614.GB5225@willie-the-truck>
 <YFNOHKX6V4dkwWIp@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFNOHKX6V4dkwWIp@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 08:57:00AM -0400, Sasha Levin wrote:
> On Wed, Mar 17, 2021 at 01:26:15PM +0000, Will Deacon wrote:
> > On Tue, Mar 16, 2021 at 01:43:19PM +0000, Vladimir Murzin wrote:
> > > Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
> > > reorganized el2 setup in such way that virtual cpu id registers set
> > > only in nVHE, yet they used (and need) to be set irrespective VHE
> > > support.
> > > 
> > > Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
> > > Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> > > ---
> > > Changelog
> > > 
> > >   v1 -> v2
> > >      - Drop the reference to 32bit guests from commit message (per Marc)
> > > 
> > > There is no upstream fix since issue went away due to code there has
> > > been reworked in 5.12: nVHE comes first, so virtual cpu id register
> > > are always set.
> > > 
> > > Maintainers, please, Ack.
> > > 
> > >  arch/arm64/include/asm/el2_setup.h | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Acked-by: Will Deacon <will@kernel.org>
> > 
> > It's a bit weird to have a patch in stable that isn't upstream, but I don't
> > see a better option here.
> 
> Yes, I'd agree here - the commits that would need to be backported look
> way too invasive.
> 
> I've queued it up, thanks.

I don't see it, so I've added it as well...

thanks,

greg k-h
