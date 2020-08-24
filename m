Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4377124F3BF
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHXIPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:15:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56717 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgHXIPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 04:15:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 079945C00E4;
        Mon, 24 Aug 2020 04:15:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 24 Aug 2020 04:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=VgbasxC9etNdXdZf1gk3gWIopfB
        rI8g9ET6r2xupcek=; b=lFAB8n+I3geRY78QymLcA814K14cjjnEKrkAb03P5pk
        GjcrJXww06qrcOLAkQ/XQ1jehSMX/Rbu+BhejXJkMWKzLHoXm5RC+wSLehtl2FJV
        kJd72FG5NSiEWRYLLOB0BVsvwQczAOYTIIPNOu0RlysstpfZvLqZZoIkIHss/ngS
        PA1wjkCAe/vMzLmq68usnA1q6H+9FODq9sG5JAQU186izg65MyoGOsLCbsRG8hn7
        rbDOPx7wntQd8MT+DITvUF9gFss4hDX9zvk7Mll2SpcWUWg0WrMu9J4lP9uu+/dh
        TcYeqSMoARhNOSIh6RTYPW30enO9OfIe1CC5XAILnzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Vgbasx
        C9etNdXdZf1gk3gWIopfBrI8g9ET6r2xupcek=; b=ka7gevwFumIoXk+qWapD2u
        zdEB9TclAMM/pX9AVZsoiufIfAvn95Vw6fj5kr0IvacyAnowoEo2yalkXbnyY7Yg
        nw433LMAA6xIydnmwdP+T8s+hQ2LsAMVEx+TFKANiatc7llLHJwouMkUy8oX9D7j
        MO0UXDujOY6Jarp3Uc+suTmLIG/EaSF7VLnaFDlvPpD8A0N/CL+x3kW3OiouhVbI
        J4/e8AysrdDCsRyM65NnDD7PIuBBFBGSsyuBLymfEUdmVN7fFSyg2CvGLMFeNlTe
        BNith8F0S0ldarT/DNA1tuvsdelZu2SPvOO3aGv8z2uvRdPxDPYPjIyNduDvpwPg
        ==
X-ME-Sender: <xms:M3dDX_HOY_D7zXCX_Avhp5Dt39BW_u33oyTBM-feSnZTyk7BupkmDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddujedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:M3dDX8W-jRJOQ9ARg59qZ3OVg5gXQMRLpmVydaWCO2yrLAL9oQCfxw>
    <xmx:M3dDXxKQu-o2TA_213kIR-dX9scRct5k2ZNGwQHl3z25kEYASLaT1Q>
    <xmx:M3dDX9HvxybBUz6prXqZHctS1KjSVJ1VJKRCB7PZUfezOwOUnUKc3w>
    <xmx:NHdDX2fdj-kqOB3j7NehVrPn6LTS3s5Bu2dgP_I2355Sg1XRLzaZRA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E8117328005A;
        Mon, 24 Aug 2020 04:15:46 -0400 (EDT)
Date:   Mon, 24 Aug 2020 10:16:06 +0200
From:   Greg KH <greg@kroah.com>
To:     Adam Ford <aford173@gmail.com>
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        stable <stable@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
Message-ID: <20200824081606.GA248691@kroah.com>
References: <20200709121232.9827-1-aford173@gmail.com>
 <CAHCN7x+crwfE4pfufad_WEUhiJQXccSZHot+YNDZzZKvqhrmWA@mail.gmail.com>
 <86992356-b902-d7da-ffd7-e8b98f9252fd@ti.com>
 <20200805143328.GD2154236@kroah.com>
 <df411c41-2b75-725e-9f49-4ca6124f3d4e@ti.com>
 <CAHCN7x+Hhx=pNidpBpmsT2_J6Og4ioC9Dq_aYa7vy8j-D8-waw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7x+Hhx=pNidpBpmsT2_J6Og4ioC9Dq_aYa7vy8j-D8-waw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 13, 2020 at 11:41:57AM -0500, Adam Ford wrote:
> On Thu, Aug 6, 2020 at 4:46 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> >
> > Hi Greg,
> >
> > On 05/08/2020 17:33, Greg KH wrote:
> > > On Tue, Aug 04, 2020 at 04:19:54PM +0300, Tomi Valkeinen wrote:
> > >> On 04/08/2020 16:13, Adam Ford wrote:
> > >>>
> > >>>
> > >>> On Thu, Jul 9, 2020 at 7:12 AM Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>> wrote:
> > >>>
> > >>>     There appears to be a timing issue where using a divider of 32 breaks
> > >>>     the DSS for OMAP36xx despite the TRM stating 32 is a valid
> > >>>     number.  Through experimentation, it appears that 31 works.
> > >>>
> > >>>     This same fix was issued for kernels 4.5+.  However, between
> > >>>     kernels 4.4 and 4.5, the directory structure was changed when the
> > >>>     dss directory was moved inside the omapfb directory. That broke the
> > >>>     patch on kernels older than 4.5, because it didn't permit the patch
> > >>>     to apply cleanly for 4.4 and older.
> > >>>
> > >>>     A similar patch was applied to the 3.16 kernel already, but not to 4.4.
> > >>>     Commit 4b911101a5cd ("drm/omap: fix max fclk divider for omap36xx") is
> > >>>     on the 3.16 stable branch with notes from Ben about the path change.
> > >>>
> > >>>     Since this was applied for 3.16 already, this patch is for kernels
> > >>>     3.17 through 4.4 only.
> > >>>
> > >>>     Fixes: f7018c213502 ("video: move fbdev to drivers/video/fbdev")
> > >>>
> > >>>     Cc: <stable@vger.kernel.org <mailto:stable@vger.kernel.org>> #3.17 - 4.4
> > >>>     CC: <tomi.valkeinen@ti.com <mailto:tomi.valkeinen@ti.com>>
> > >>>     Signed-off-by: Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>>
> > >>>
> > >>>
> > >>> Tomi,
> > >>>
> > >>> Can you comment on this?  The 4.4 is still waiting for this fix.  The other branches are fixed.
> > >>
> > >> Looks good to me.
> > >>
> > >> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > >
> > > I don't seem to have the original of this anymore, can someone please
> > > resend it?
> >
> > I have attached the original.
> 
> Greg,
> 
> Do you have what you need?  I see all the other kernels have been had
> the corresponding patches pushed, but 4.4 needed something different
> due to some path / naming changes.

All good, now queued up, thanks!

greg k-h
