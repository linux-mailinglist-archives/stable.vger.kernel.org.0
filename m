Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7692E29F51E
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 20:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgJ2T1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 15:27:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50841 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726692AbgJ2T1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 15:27:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9539D5C0070;
        Thu, 29 Oct 2020 15:27:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 15:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=AbTQFUKDGdfS5TDNU/XsAllmZFy
        xssNt+OazgWOyrZw=; b=NPEDrda1m/i0J3jYfam97uP6XRr4h17mk4KPonNGEDY
        W7xSzJ17UIWLd8DQXyFmGjfx/Z36KoCfJI0Ux0ZGXaUokmJoQpYTl9Q1ivo75whW
        DBCr6NCdMzV9YCL+yloljOd0sRG2ZMF926K0x2bgqe2IO5XMTsm0Ht3/JO4gwzYB
        /Sonx/scWYkQC3ntM9nkxRv79Duz2Uhd7nG8sKJ7P9+3dIH8qZ/XvPlk1Y7LVDi6
        g66Eq1fpsqQbHL4EkvfCAmN3ZNKrYTfdnRHLEK4Xuay/WI3pD+thT0M1Qtvziwqu
        8EIPZ8gTVX84KlIJQAkDQH6n7lpWb6+rXwwxUITff/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AbTQFU
        KDGdfS5TDNU/XsAllmZFyxssNt+OazgWOyrZw=; b=gT9NCDNH/c8iKZlX5DtvOK
        P0HdPoJqyHaH1Py6XBJycaBz+hDR0WamCzCmfUut//Ad+qKghIVmJ8LMcnnkgUrH
        Dj/yIujZ0DLq7TcClayoHiv3k9A1+2TsINAoPQlPJJipcqAekuYB3AQaO7UPs3bz
        s5aJCng4MgJscPXSbc8G+7v8n/ZcORNie1yPtwFgLM/LXTEzJ73CVph9eCjC0N1d
        bFQ9jPUCooiLKJ+kxjP503vWT9x4PrIv++txr6m+DmtSWzA5IDtk1Tc20MF1aCZB
        UAxDbHz8rDhomAWSm9EWsgSWxZMnj0USzQy7L3txqLu1uoOI5ohkAE94Nb3h4P6A
        ==
X-ME-Sender: <xms:qxebX--VuzieevRhCVeKHxWK7K1vaRto1AvUL7ez6auP3a1Z5BS6kw>
    <xme:qxebX-us3XLy8_MlsWvJppkPFGnEcM4b86PWRcryF-sZYwjAqjiiLmoTkLmckmXHR
    9isnahkYqqy0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:qxebX0Aawju4IG0wOz2bmSx4GdXNiPlP1A-4mEkbgibKBB4qzt1ZOQ>
    <xmx:qxebX2cZHs2XSUB_01W5FHd_Xx3Nypb7dPG9iyCoDrW13XgfDpPeJw>
    <xmx:qxebXzMf21n6cKE0obEq4bFK0V_hiatay-nWOg8Qgh1eibMRTXsqiA>
    <xmx:qxebX4p1fbt4wIytngd_jbLqeHpm0-nIp0KLpeEQ55UnYO7DwlXWWg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA5923280066;
        Thu, 29 Oct 2020 15:27:38 -0400 (EDT)
Date:   Thu, 29 Oct 2020 20:28:27 +0100
From:   Greg KH <greg@kroah.com>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org, Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 4.4-5.9] efivarfs: Replace invalid slashes with
 exclamation marks in dentries.
Message-ID: <20201029192827.GA992564@kroah.com>
References: <20201029175442.564282-1-dann.frazier@canonical.com>
 <20201029191923.GB988039@kroah.com>
 <CALdTtnuh9=JMwZ8LhBQwAFtLSg_kbB=5ctz21KkMwGRCNmwOMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdTtnuh9=JMwZ8LhBQwAFtLSg_kbB=5ctz21KkMwGRCNmwOMg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 01:20:06PM -0600, dann frazier wrote:
> On Thu, Oct 29, 2020 at 1:18 PM Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Oct 29, 2020 at 11:54:42AM -0600, dann frazier wrote:
> > > From: Michael Schaller <misch@google.com>
> > >
> > > commit 336af6a4686d885a067ecea8c3c3dd129ba4fc75 upstream
> > >
> > > Without this patch efivarfs_alloc_dentry creates dentries with slashes in
> > > their name if the respective EFI variable has slashes in its name. This in
> > > turn causes EIO on getdents64, which prevents a complete directory listing
> > > of /sys/firmware/efi/efivars/.
> > >
> > > This patch replaces the invalid shlashes with exclamation marks like
> > > kobject_set_name_vargs does for /sys/firmware/efi/vars/ to have consistently
> > > named dentries under /sys/firmware/efi/vars/ and /sys/firmware/efi/efivars/.
> > >
> > > Signed-off-by: Michael Schaller <misch@google.com>
> > > Link: https://lore.kernel.org/r/20200925074502.150448-1-misch@google.com
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > Any reason you are not signing off on this?
> 
> No, sorry:
> 
> Signed-off-by: dann frazier <dann.frazier@canonical.com>
> 
> Easier if I send a v2?

Nah, I can take that, thanks.

greg k-h
