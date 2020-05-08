Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9451CA796
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 11:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgEHJyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 05:54:37 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37679 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbgEHJyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 05:54:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 44EE05800E1;
        Fri,  8 May 2020 05:54:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 08 May 2020 05:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=fNKb2E3cngycuSCYlu4bdd4ggu3
        a874dABTj/kMWUm0=; b=fZZ1hS1aaqVwquRtjcmtV1uwMAChocqg77h2wS5q+6S
        CTysKclNK/nv1Ft+POR8eY2bzp6wyx1jkI1pa4yKymYwQ3lSeVCpgKskekxOwW3V
        rYg6ASUEIRO3CZdc+xmfLgwrTD51JKxI5uH23frrKvJlMI5sctciSycR5co756gT
        O6RCa8jTgEK5lxWREhRAQSSQL0uZ5lS1ncnghdP+ak1Fn+mjn4+4WvUL36MB08U4
        AsInFYHnz+r1lMwf9MwqOJE/VSxkw42eaqNgThGWYleWyQBZKEXysu0D+zo4dpk9
        O9jsRiF2Fo6dYxpDxvSJkLnW6Zch17Pg1XQQh417vig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fNKb2E
        3cngycuSCYlu4bdd4ggu3a874dABTj/kMWUm0=; b=IVz5NEuAd8YNG9zOll2WGv
        LVMirSGHhkmKzHsqzIRU4vmwPY06iaA0ZVqkLHvTQQbSKqK+ZuXHLRLcpXm/x7Yc
        Eyu8tN5q0QQpK4I+Pjbfjx6PBYHceqm3zupvXr3RUF6DJaEMnRPRL2OSzF2bWU1e
        ghvZprSJtjEiZwczQ9eDWI5xn9nAfhKvHAj7SvYdg09cONqYpQRzqpKuM/nwUf2R
        UlHaPU7Fx2fp2DtesP6A4dQUUP27/EL7jaoMyJGB5vE8Snss5VdaEkAR4wsn5WzC
        z9PG2hV24VVGvxLatb9PHfAcKTNzbvECGCT1VyNiwIvi0zlU3JMMxB0PcVcet4EQ
        ==
X-ME-Sender: <xms:WSy1XrLHLwYoqFca-9ZQRaTAl21STgn4Ua-jN0OfQsPvzIuY8La8GQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkedvgddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WSy1XgYPNH_dMaQPBpqQmubb9WDDa-pGvtp-LCKIlOkFzIcGGeRd3g>
    <xmx:WSy1XsLN-X5N5GrqOAMoZsCT_Kyv_a9Q4Agj6vWQTu2Jjm-KmZ-A0g>
    <xmx:WSy1Xqn4gbyXrsM5-OrS4bduG-yU1xQirbm2fufqhAs885o1DsygKA>
    <xmx:XCy1Xs5hqa_PXM4aJN_lHF1bMY4ghUjSybFF6_cfF58xrxdxJBsokA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85EC73280066;
        Fri,  8 May 2020 05:54:32 -0400 (EDT)
Date:   Fri, 8 May 2020 11:54:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Yves-Alexis Perez <corsac@debian.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>,
        Adam Jackson <ajax@redhat.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] drm/atomic: Take the atomic toys away from X
Message-ID: <20200508095426.GA3778290@kroah.com>
References: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
 <20190905185318.31363-1-daniel.vetter@ffwll.ch>
 <2a05f4c4362d386d298a06a67f2f528ef603a734.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a05f4c4362d386d298a06a67f2f528ef603a734.camel@debian.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 08, 2020 at 11:06:56AM +0200, Yves-Alexis Perez wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> On Thu, 2019-09-05 at 20:53 +0200, Daniel Vetter wrote:
> > The -modesetting ddx has a totally broken idea of how atomic works:
> > - doesn't disable old connectors, assuming they get auto-disable like
> >   with the legacy setcrtc
> > - assumes ASYNC_FLIP is wired through for the atomic ioctl
> > - not a single call to TEST_ONLY
> > 
> > Iow the implementation is a 1:1 translation of legacy ioctls to
> > atomic, which is a) broken b) pointless.
> > 
> > We already have bugs in both i915 and amdgpu-DC where this prevents us
> > from enabling neat features.
> > 
> > If anyone ever cares about atomic in X we can easily add a new atomic
> > level (req->value == 2) for X to get back the shiny toys.
> > 
> > Since these broken versions of -modesetting have been shipping,
> > there's really no other way to get out of this bind.
> 
> Hi Daniel and Greg (especially). It seems that this patch was never applied to
> stable, maybe it fell through the cracks?

What patch is "this patch"?

> It doesn't apply as-is in 4.19 branch but a small change in the context makes
> it apply. I'm experiencing issues with lightdm and vt-switch in Debian Buster
> (which has a 4.19 kernel) so I'd appreciate if the patch was included in at
> least that release.

What is the git commit id of the patch in Linus's tree?  If you have a
working backport, that makes it much easier than hoping I can fix it
up...

thanks,

greg k-h
