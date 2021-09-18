Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D274410654
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhIRMRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 08:17:41 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:48939 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230358AbhIRMRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Sep 2021 08:17:40 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.west.internal (Postfix) with ESMTP id E77372B0120D;
        Sat, 18 Sep 2021 08:16:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 18 Sep 2021 08:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=r4OHZ5J/qMsCG0z1FGhpVZq7FqS
        4WXlZG5DPh3w3xVI=; b=V+BdbPl6MN0ocacq8loL5m7GdfPkUS3vZ7kTczsu6C+
        k6NX59lGvWyIgdNkwtFRaSQTMtGi2bbFVw3AZ9+n/YZkheSEkUL7VBx/Qs7iujiQ
        Uu09Jh1530IwENX/CSPpS9Y8sXBSU9VV0WP4HlNs3UbQJ2EwlMEeVFjRbgmaDAKV
        k9lBWQepAs9zB5LWcoSM5fBe3FUKIjpJq6Ce2TcgOHP+k8jnq6s4ANPpigQSlZq3
        KApKgzm0c6BafNtimkfNCuaYgbBH8mSGsCJU9SE+2VmGeOzXthgt89YwAPCaYAWH
        Wjpcnt1RgPdua5MeGMhGKdXVgGFpUJc+4B+DxTRMV0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=r4OHZ5
        J/qMsCG0z1FGhpVZq7FqS4WXlZG5DPh3w3xVI=; b=Gq8TdLfuLTuBEJe1zctunc
        sRXbpQGUE6XV6Pghp2SLz6t6VVO3kcv0RvlaImmw6hLU1QstcoLxDaigbqCTlnyh
        faMgj0VvZqAU4dRnRYVS3GyX+cptU2EJjx+Hvrl422A+V9nggku8EPiLE/oHtAJ8
        1Lk63UDZrKpbHXFoM7DKbTMrp/HCkzt4eXG/GWfhtH6ezflAD8u4PgFdbDRfmEza
        WrynEFaP3NZSxnn/h5Js41YjPBkROgbGqnre8DjnTMZvf/UzXM11XgXwErEyNyxk
        cHQg4KjM/tRfCTVhJEBznRxDm76agFrvt3bY6bgoQX2pE/B56sOeCdS5/wll1vfg
        ==
X-ME-Sender: <xms:jdhFYeip_D8ZsCvYLIj5cbCBA5KzmIv821zhdw-pVXkEtR7oAj91vw>
    <xme:jdhFYfDjEFmzixP9lRJI145brwRmdOZ44gzIJSy768bDtZb2GK8y6XkX4u-KU1huZ
    r_dES6U3m3GOg>
X-ME-Received: <xmr:jdhFYWEFm1GV1EY5swRs9ADpTED-9srL1aHCi1YHLXc7zgYMKK9K3rfQuc5-QQZ1z7BSilAmgJOGX6BMeaD1ez7wmdF0nDOx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:jdhFYXTcJV7IsPo6k6DGrg_Al8DA7ajCsnnpAfqzZweT34wzRqkHqg>
    <xmx:jdhFYbzZYikeS42Gf5NeYyK8bnN-6a6Dzi_dY0DRAyRBaP3Gq7DJ4g>
    <xmx:jdhFYV457LCvGra0Q2RJp4qU8mpGTmHHw8sauBPByzPRVG8hPuoFMQ>
    <xmx:jthFYU-wCgjbVPQIXlTNOLSLUOiQVQgArAzwZ_pSU0sCghL6IecCO6w1Sp0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Sep 2021 08:16:12 -0400 (EDT)
Date:   Sat, 18 Sep 2021 14:16:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Robert Foss <robert.foss@linaro.org>, a.hajda@samsung.com,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent.pinchart@ideasonboard.com, jonas@kwiboo.se,
        jernej.skrabec@siol.net, airlied@linux.ie,
        Daniel Vetter <daniel@ffwll.ch>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Anibal Limon <anibal.limon@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] drm/bridge: lt9611: Fix handling of 4k panels
Message-ID: <YUXYitidmr7d9z3v@kroah.com>
References: <20201217140933.1133969-1-robert.foss@linaro.org>
 <CAMn1gO4y6yC0fcLYdGfYR4KqPq9Ff0n4DhEczWQh9J6ceobs5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMn1gO4y6yC0fcLYdGfYR4KqPq9Ff0n4DhEczWQh9J6ceobs5A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17, 2021 at 12:47:05PM -0700, Peter Collingbourne wrote:
> On Thu, Dec 17, 2020 at 6:09 AM Robert Foss <robert.foss@linaro.org> wrote:
> >
> > 4k requires two dsi pipes, so don't report MODE_OK when only a
> > single pipe is configured. But rather report MODE_PANEL to
> > signal that requirements of the panel are not being met.
> >
> > Reported-by: Peter Collingbourne <pcc@google.com>
> > Suggested-by: Peter Collingbourne <pcc@google.com>
> > Signed-off-by: Robert Foss <robert.foss@linaro.org>
> > Tested-by: John Stultz <john.stultz@linaro.org>
> > Tested-by: Anibal Limon <anibal.limon@linaro.org>
> > Acked-By: Vinod Koul <vkoul@kernel.org>
> > Tested-by: Peter Collingbourne <pcc@google.com>
> > Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> This landed in commit d1a97648ae028a44536927c87837c45ada7141c9. Since
> this is a bug fix I'd like to request it to be applied to the 5.10
> stable kernel.

Now queued up, thanks.

greg k-h
