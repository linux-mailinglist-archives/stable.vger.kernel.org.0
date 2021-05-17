Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB0D382BB2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbhEQMDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:03:20 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43879 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236859AbhEQMDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:03:19 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 1FF613D2;
        Mon, 17 May 2021 08:02:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 17 May 2021 08:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=bLxPG3CJWwLArGcePs+mN6rzuCq
        6IKcukCRG1uEEn84=; b=LWpW4KwL0h0PMDTIENAY8Ly2FKcnyH7eSS9vpqNPE4a
        vdtdOPxRQ5ChpvqmEuT/XXWb9urM6yXx4ON4HigDPKWoHWizuJAtFTLMjh+cFLXB
        3AnA16I7O0EFfPdM7jSohgI58IAu11oyQMRXu7GfXNeOIDYoIhsd0zsJfWIG9kcj
        Jgggd4sjJKf81vy/dL1nSfraicQe/wDC5kmNfyuOGvSh8gmj+jCw01pPI3H6jtF4
        jcIWeqkbCwY0Ec71+7LeMQwTjWkpURIr4beV5BhdYGsnSoG79Fh+DBP5oOok46Ja
        N5zpkXolR3ksu3KDy5UXW5nTNFaP+i3dYe9Bf+pcDLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bLxPG3
        CJWwLArGcePs+mN6rzuCq6IKcukCRG1uEEn84=; b=cYhisNu2E7ESVb9Lnr3afQ
        5mm+2y21+ARpqUy86zTBdi7MrQwAtON3dCJUXmZ822spHTlb/Clwv1KTqP6eECoM
        HaGenzKa/hPjBSdGK12Lymr2ZPvHopqf1prVrHMUcrn38hOX1vzpL64O5mxi+nub
        /fv6rVcm1F4E+wOtx8OKvqVCkF+wRxok59L4QIbSvUXD/gwDXL4cs9297SdMDHvw
        7yglC+jcXYWP9O91w/1fepJ2b/hhNm2oVOM56ZtGrI6u2B+VEU2dYwkOtSXhiRbI
        vZ8vFv8aIQGWBFQiTwIpOqHgxqLUMeEPuHmp+i1o0dQ7GCIG7ehOVoXVexLY82Fg
        ==
X-ME-Sender: <xms:OFuiYNYbNIO4tErvCSeLkw6idFfHqZap-qsq3jos1ByffVyhU1UVPQ>
    <xme:OFuiYEY6cDPUIeFtg8Eo1yZJ26fFNNYlF2zut63ID6ToJpPIX119J8ZSkbZJENDMk
    R46xfd0Zu7Qsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OFuiYP8LDB8zPklwfZ-F4hJ-ZX44MfHn5gda20foPBy6rGXV1CL8Hw>
    <xmx:OFuiYLqh34DDj_wmt9i9fON5QAGhgoWg0CwnZ1gYPIZj2MV_1YFexA>
    <xmx:OFuiYIq8QGqHQhrtXsA0_GSlTROVGSd0CbidnHFNeF1rK8CxGt-oPg>
    <xmx:OVuiYNCFfGiAqDvbwWlCUcJ5-Gf22tsTHjs1OHQI69Z7RSZA8NFsWw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 08:02:00 -0400 (EDT)
Date:   Mon, 17 May 2021 14:01:58 +0200
From:   Greg KH <greg@kroah.com>
To:     Nicolas Schier <nicolas@fjasle.eu>
Cc:     stable@vger.kernel.org, Finn Behrens <me@kloenk.de>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v2 1/2] tweewide: Fix most Shebang lines
Message-ID: <YKJbNp40eI+rHWZX@kroah.com>
References: <20210511185817.2695437-1-nicolas@fjasle.eu>
 <20210511185817.2695437-2-nicolas@fjasle.eu>
 <YJvC2W9QTpc9JBp1@kroah.com>
 <YJ2GDOt48sjlMFtD@lillesand.fjasle.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ2GDOt48sjlMFtD@lillesand.fjasle.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 10:03:24PM +0200, Nicolas Schier wrote:
> On Wed, May 12, 2021 at 01:58PM +0000, Greg KH wrote:
> > On Tue, May 11, 2021 at 08:58:16PM +0200, Nicolas Schier wrote:
> > > From: Finn Behrens <me@kloenk.de>
> > > 
> > > commit c25ce589dca10d64dde139ae093abc258a32869c upstream.
> > > 
> > > Change every shebang which does not need an argument to use /usr/bin/env.
> > > This is needed as not every distro has everything under /usr/bin,
> > > sometimes not even bash.
> > > 
> > > Signed-off-by: Finn Behrens <me@kloenk.de>
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > > [nicolas@fjasle.eu: ported to v4.9, updated contexts, adapt for old
> > >  scripts]
> > 
> > What about 4.14, 4.19, 5.4, and 5.10?  We can't add patches only to one
> > stable tree and not all of the newer ones as well.
> 
> Hi Greg,
> 
> yes, that makes sense obviously, I did not have that in mind.  If there 
> is a chance for acceptance, I will gladly provide the patches for the 
> newer stable tree as well.

It makes sense to do this here, to enable building these older kernels
on newer systems.

thanks,

greg k-h
