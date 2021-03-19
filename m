Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FE534189B
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCSJlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:41:08 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42049 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhCSJki (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 05:40:38 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 194C1157E;
        Fri, 19 Mar 2021 05:40:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 19 Mar 2021 05:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=pMTyTWA08f8C7i7cW7bjR96YOki
        iI8CbgnFvH3j/Lfs=; b=uNyqZCUuueTdYrpZRwvgX1zmPU6BliXQRs7EFJXDAIB
        e/+ESIcF7j0Lt6Dbi86a+2BzQVKd5YTQgTREtqBhgelVfYFOfdk1YBuKJXt4r5HQ
        uMCN20DUlQgkcaraqsbOolcb1NFeu2mfofVSDA9RHLAdI2OZkwZVz6Zvdl871pgp
        undbiXaw14A3ycr4o2Z5ta+2oipcGBOcogJ/mttQ+AdaIhokV5E7NM1jMsT4r0d/
        lfa0K+HC+VirKfbWu1itlrSHSAGzq0zrS/ARsyGuRu7bhmofGHEZwo2fyo5fHrvv
        bk24rcmVG0bMWKOiWfaCs9fLMhZAUL/5UxkInvGd/cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pMTyTW
        A08f8C7i7cW7bjR96YOkiiI8CbgnFvH3j/Lfs=; b=gHfhg/tmIIPvJxSxHq9Lbn
        ek+lE5GepQpvMTasy5M0ZTcKZpB5KcetKIchn+RZAV5z0Xj0mQcqKT0+F+qwPyLX
        zfvdU9Qd7/0x2vA3szdO/CtuKiMovkU7C9PEVXp75GymtXgl+w1h6H6zeZ3YacsX
        cpiWfUuRL1sx2f67N3YL4Vp9L0g7Nuh2DkZHhyS6zpBEnuryAnv/8Ijw2oU8NwRu
        je/OJjPoPZPlzLkz+ZIRoh7XwkJxmpDK0S0GnuaHVQ4EefgVzm+EbSILgpolDfHG
        HUxQ6aSLDr56kG+FqF1sOirRTC+s/k1/2cJDcz0bynBuFSybXOlQwu24idoiNgEg
        ==
X-ME-Sender: <xms:lXFUYMWo23_Tlht-_LJIQSWnNk7_ssWOkVcYoen0yoYypnbcnI8GwQ>
    <xme:lXFUYAhbOZ5nIDa_OWpH0vngDnZZDd6zP6voCXRv0tM2b4FSNSMOSFKYnROLaCqlr
    EVtuqRqyI3xGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefkedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefguddvhf
    dvueegieeuvdduledtgedvteehtefhkeevkeehgfdtledvhfefvdeigeenucffohhmrghi
    nhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lXFUYNTnuWIm72IIOyYomV4OPXYBj7kAtbkfAB8owMNMMz4ahpuFBg>
    <xmx:lXFUYDEai2Ama-S5kGGHU8N0eCgBIdu92Hp35n3zoAO6ChsaJb5SJQ>
    <xmx:lXFUYFk27cZ66Sdok8iz3MlWKYqJnXaH93aY1rGlb4JK2n-odKmFYg>
    <xmx:lXFUYAwB8JYzGcLbfNrBJQHOdJzjB0T-jt8mRcYWZbky2tq7onxTxQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3CBC108005C;
        Fri, 19 Mar 2021 05:40:36 -0400 (EDT)
Date:   Fri, 19 Mar 2021 10:40:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Colin Xu <colin.xu@intel.com>
Cc:     stable@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        zhenyuw@linux.intel.com
Subject: Re: [PATCH 3/5] drm/i915/gvt: Fix virtual display setup for BXT/APL
Message-ID: <YFRxk6crsi9DaIHB@kroah.com>
References: <cover.1615946755.git.colin.xu@intel.com>
 <280168619124c762cb29add7e68952222a0e4801.1615946755.git.colin.xu@intel.com>
 <YFRxUpzFf/qAyMER@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFRxUpzFf/qAyMER@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 10:39:30AM +0100, Greg KH wrote:
> On Wed, Mar 17, 2021 at 10:55:02AM +0800, Colin Xu wrote:
> > commit a5a8ef937cfa79167f4b2a5602092b8d14fd6b9a upstream
> > 
> > Program display related vregs to proper value at initialization, setup
> > virtual monitor and hotplug.
> > 
> > vGPU virtual display vregs inherit the value from pregs. The virtual DP
> > monitor is always setup on PORT_B for BXT/APL. However the host may
> > connect monitor on other PORT or without any monitor connected. Without
> > properly setup PIPE/DDI/PLL related vregs, guest driver may not setup
> > the virutal display as expected, and the guest desktop may not be
> > created.
> > Since only one virtual display is supported, enable PIPE_A only. And
> > enable transcoder/DDI/PLL based on which port is setup for BXT/APL.
> > 
> > V2:
> > Revise commit message.
> > 
> > V3:
> > set_edid should on PORT_B for BXT.
> > Inject hpd event for BXT.
> > 
> > V4:
> > Temporarily disable vfio edid on BXT/APL until issue fixed.
> > 
> > V5:
> > Rebase to use new HPD define GEN8_DE_PORT_HOTPLUG for BXT.
> > Put vfio edid disabling on BXT/APL to a separate patch.
> > 
> > Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Signed-off-by: Colin Xu <colin.xu@intel.com>
> > Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Link: http://patchwork.freedesktop.org/patch/msgid/20201109073922.757759-1-colin.xu@intel.com
> > (cherry picked from commit a5a8ef937cfa79167f4b2a5602092b8d14fd6b9a)
> > Signed-off-by: Colin Xu <colin.xu@intel.com>
> > Cc: <stable@vger.kernel.org> # 5.4.y
> > ---
> >  drivers/gpu/drm/i915/gvt/display.c | 173 +++++++++++++++++++++++++++++
> >  drivers/gpu/drm/i915/gvt/mmio.c    |   5 +
> >  2 files changed, 178 insertions(+)
> 
> I've taken this backport for 5.10.y as well, because it is missing
> there.

Oops, nope, it breaks the build.

Please also provide a working backport for this as well, we can not have
users moving to a newer kernel version and have a regression for a known
issue.

thanks,

greg k-h
