Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282CA14179F
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 14:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgARNSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 08:18:39 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51797 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728688AbgARNSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 08:18:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A6B221C08;
        Sat, 18 Jan 2020 08:18:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 18 Jan 2020 08:18:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=DRHAHJguT0zUvuL+HVAIgaDuT2H
        2OklHFj7eOTL2buQ=; b=ZwOTVUgjw+v6z8Bwo66ELXgACYkpuH5IXBOnnR+EXIF
        MhVc9hgm/YTxCyyB6ax/p0J02hl7Pg5tAH+8co+df5iEtLSMLjD0fLdV4UaL2V5G
        GRIjLqJ5SlkjXrTtc0a0VGPAhfpPdr+xZVutRe7irHPnNSIwr5bz1LVK+NwgrtgJ
        bgEKT9bfu4m5TFWAc9KP8rPU0/jXpaypRyoUX/UyKOeINOucyhv73u+nP2kW3zLD
        VJrC2VUA3Fo8ny0jBaO5lwig3P86bQBV/MaPS60GhAE81CERkRsRv09J7XRuseys
        i1Zrsuxp1dxopbv3HrfCMvbXNsq2UzZSjAyXI/ZFL3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DRHAHJ
        guT0zUvuL+HVAIgaDuT2H2OklHFj7eOTL2buQ=; b=Se8pfQufQYd6K+LP1Jmq3v
        DszalQzijDvVM0b4lB06ljsdV2kXyA8NCtj1Ts/vfKKzn4qE7bmNmBy3TXwLCMiU
        45+Lzt+jjJhF9NZjDo1f8EDDvdf7G2A5GP+bwhhyc+dQZ7alSADiEqGlAmEQLcPO
        U8VwB0qhOElvK1++AzmXwPQirijmYCiL4BQg82cAUGITgvB50BR2/Fi4gPtZcba9
        sgeLtP9APAalHE3QwbIPpHzO5f9Zspk1r8QXBHANLz69o3wSO06pRYFiccvMkg3Z
        42BZXp9uz9Dd3UoTuxrKIaSkVlo0h7Isb8PDUpURuujrKsHX8ywBSh1lFqvqG76Q
        ==
X-ME-Sender: <xms:rQUjXlhoLj1-gN48oh7dIKCyLRVZShngX3ZfUDEgiYs1W4BBjHx0LA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeefjedrjedurddugeefrdduje
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:rQUjXuBtNILX2KHo6wEaYS6dMVIkAAlENYv7FAwsNf05GvLDSl9ULg>
    <xmx:rQUjXls9OulPIDmb3T9l-CVnHXOd1SonAsP5oAo7Hr6yEJjS7v8f1w>
    <xmx:rQUjXqIv06_7RDiQL7nDwgiUmAJGb5dBCOfu1JXVawvn2sUye0SFtQ>
    <xmx:rQUjXjXFU5ZqHBT-cohQoAaQOwMRw-27NeDTdPTP3chZMM4x3bcfpg>
Received: from localhost (170.143.71.37.rev.sfr.net [37.71.143.170])
        by mail.messagingengine.com (Postfix) with ESMTPA id 080A430608AD;
        Sat, 18 Jan 2020 08:18:36 -0500 (EST)
Date:   Sat, 18 Jan 2020 14:18:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH AUTOSEL 5.4 002/205] drm/panfrost: Add missing check for
 pfdev->regulator
Message-ID: <20200118131835.GA4734@kroah.com>
References: <20200116164300.6705-1-sashal@kernel.org>
 <20200116164300.6705-2-sashal@kernel.org>
 <20200117161226.GA8472@arm.com>
 <20200117165909.GA1949937@kroah.com>
 <20200118081845.GF19765@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118081845.GF19765@kadam>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 18, 2020 at 11:18:45AM +0300, Dan Carpenter wrote:
> On Fri, Jan 17, 2020 at 05:59:09PM +0100, Greg KH wrote:
> > On Fri, Jan 17, 2020 at 04:12:27PM +0000, Steven Price wrote:
> > > On Thu, Jan 16, 2020 at 04:39:37PM +0000, Sasha Levin wrote:
> > > > From: Steven Price <steven.price@arm.com>
> > > > 
> > > > [ Upstream commit 52282163dfa651849e905886845bcf6850dd83c2 ]
> > > 
> > > This commit is effectively already in 5.4. Confusingly there were two
> > > versions of this upstream:
> > > 
> > > 52282163dfa6 ("drm/panfrost: Add missing check for pfdev->regulator")
> > > c90f30812a79 ("drm/panfrost: Add missing check for pfdev->regulator")
> > > 
> > > It got merged both through a -fixes branch and through the normal merge
> > > window. The two copies caused a bad merge in mainline and this was
> > > effectively reverted in commit 603e398a3db2 ("drm/panfrost: Remove NULL
> > > check for regulator").
> > > 
> > > c90f30812a79 is included in v5.4 so should already be in any v5.4.y
> > > release.
> > 
> > Have I mentioned this month just how much I hate the way the DRM tree
> > handles stable patches like this?  This kind of fallout is a pain for
> > stable maintainers, I dred every time I see a drm patch tagged for
> > stable.
> > 
> > But we've been over this all before :(
> 
> Another example is:
> 
> 29cd13cfd762 ("drm/v3d: Fix memory leak in v3d_submit_cl_ioctl")
> 0d352a3a8a1f ("drm/v3d: don't leak bin job if v3d_job_init fails.")
> 
> Two fixes for a memory leak were merged so now it's a double free.  I
> sent a patch on Jan 10 but no one responded.

Have a link to the patch?  I can't seem to find it :(
