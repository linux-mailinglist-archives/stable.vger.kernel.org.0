Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF730158B37
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 09:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgBKI0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 03:26:37 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59369 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727578AbgBKI0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 03:26:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8EE26217FC;
        Tue, 11 Feb 2020 03:26:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 11 Feb 2020 03:26:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=aJFuuqSI2HhjxwelhEtc0Ez5YPf
        0KrosR/wT6D9AufM=; b=SNpkHcj8DpzU9/RJO4Dx7NW+qlKd91YZZI1QJXfYz/r
        mjM6R+IwGn5lZEYn3UCPb5Qju528nBi/21tUOY/rEuvzmK8wnSnACdnG29mYio4t
        udEXGLB+eBK6xQn7/HDoPcBvcmfsKnO2ckqZcjmiDLx+m296E1rOHeap+Vi/Ry3n
        NhW4axLlOqzvys1Ul7u7Jq9MYLR2rlc1WTcwDpPJdOIGZzKzhhd1QXn3/0H8p365
        8FvXCm0Wd28Tn3ycvgY9T/vMjdZOhf0yXRjjwi5IUT3Me4n23mMvT+qO3qoIizFL
        LSBnlo+dwPvRen5j179JPXmPAhSs41TvHkXt38svVPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aJFuuq
        SI2HhjxwelhEtc0Ez5YPf0KrosR/wT6D9AufM=; b=Wml2BvHI6FDEY4f5OH7zsZ
        nYzr6x37E8Ztk9Hqxr4Yn2iacvL+KNSKkgrbzvsQkulIZUumb2iL2yLppIwQ2p6b
        bHs4jnVn2qMCF0CY/JyebH2oWKn1w1HyewQ8WGkPtZ28yZxOWw0J3uOOCdBunMhc
        xZwSIvsphbzbGHF048UA1zyi6cbAlmVJ3DHMdFGqGaRPfQue2Nyn8eckBihTpYqp
        eGiAsh+h6QgACz9ELwizRbuEBla1yg4CU6RnmiBcN4xBtfGd1eXfV/Ax5opKnJCJ
        02DchwvpAAWoO+fXDSxIn53Vw/9zCmAcqtZad5bgNPKbmtP0u15jmhsjOnYVxkLA
        ==
X-ME-Sender: <xms:NWVCXtyBNsa7zJ6-4S4NZ5g5IwIr29AdqnvZnAFWIbQ9O_ggJAybag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedriedvgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecukfhppeeltd
    drkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:NWVCXmso8okp7MHQWlJU0Ryben_orT0c0mClRSczluznL_7UQdqHiA>
    <xmx:NWVCXm6lpacM8pWcwl2hSenwQtEBBBTKC0dmupVJxxF7gpgUahwV-A>
    <xmx:NWVCXlRXe6Fq4qqTmT5AcSBgjyOwfoTKYrkdR7Xv-7GWfr_AK_ZmIA>
    <xmx:OWVCXiQq_WypclKpll63jsqtz_c_x-n2-UynCFHnSLxcIZQ766gZyQ>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id C7872328005A;
        Tue, 11 Feb 2020 03:26:28 -0500 (EST)
Date:   Tue, 11 Feb 2020 09:26:27 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Chen-Yu Tsai <wens@csie.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4/4] drm/sun4i: dsi: Remove incorrect use of runtime PM
Message-ID: <20200211082627.nolf6npspw2a2rxs@gilmour.lan>
References: <20200211072858.30784-1-samuel@sholland.org>
 <20200211072858.30784-4-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kwpruo3coc5fkck7"
Content-Disposition: inline
In-Reply-To: <20200211072858.30784-4-samuel@sholland.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kwpruo3coc5fkck7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Feb 11, 2020 at 01:28:58AM -0600, Samuel Holland wrote:
> The driver currently uses runtime PM to perform some of the module
> initialization and cleanup. This has three problems:
>
> 1) There is no Kconfig dependency on CONFIG_PM, so if runtime PM is
>    disabled, the driver will not work at all, since the module will
>    never be initialized.

That's fairly easy to fix.

> 2) The driver does not ensure that the device is suspended when
>    sun6i_dsi_probe() fails or when sun6i_dsi_remove() is called. It
>    simply disables runtime PM. From the docs of pm_runtime_disable():
>
>       The device can be either active or suspended after its runtime PM
>       has been disabled.
>
>    And indeed, the device will likely still be active if sun6i_dsi_probe
>    fails. For example, if the panel driver is not yet loaded, we have
>    the following sequence:
>
>    sun6i_dsi_probe()
>       pm_runtime_enable()
>       mipi_dsi_host_register()
>          of_mipi_dsi_device_add(child)
>             ...device_add()...
>                __device_attach()
>                  pm_runtime_get_sync(dev->parent) -> Causes resume
>                  bus_for_each_drv()
>                     __device_attach_driver() -> No match for panel
>                  pm_runtime_put(dev->parent) -> Async idle request
>       component_add()
>          __component_add()
>             try_to_bring_up_masters()
>                try_to_bring_up_master()
>                   sun4i_drv_bind()
>                      component_bind_all()
>                         component_bind()
>                            sun6i_dsi_bind() -> Fails with -EPROBE_DEFER
>       mipi_dsi_host_unregister()
>       pm_runtime_disable()
>          __pm_runtime_disable()
>             __pm_runtime_barrier() -> Idle request is still pending
>                cancel_work_sync()  -> DSI host is *not* suspended!
>
>    Since the device is not suspended, the clock and regulator are never
>    disabled. The imbalance causes a WARN at devres free time.

That's interesting. I guess this is shown when you have the panel as a
module?

There's something pretty weird though. The comment in
__pm_runtime_disable states that it will "wait for all operations in
progress to complete" so at the end of __pm_runtime_disable call, the
DSI host will be suspended and we shouldn't have a WARN at all.

> 3) The driver relies on being suspended when sun6i_dsi_encoder_enable()
>    is called. The resume callback has a comment that says:
>
>       Some part of it can only be done once we get a number of
>       lanes, see sun6i_dsi_inst_init
>
>    And then part of the resume callback only runs if dsi->device is not
>    NULL (that is, if sun6i_dsi_attach() has been called). However, as
>    the above call graph shows, the resume callback is guaranteed to be
>    called before sun6i_dsi_attach(); it is called before child devices
>    get their drivers attached.

Isn't it something that has been changed by your previous patch though?

>    Therefore, part of the controller initialization will only run if the
>    device is suspended between the calls to mipi_dsi_host_register() and
>    component_add() (which ends up calling sun6i_dsi_encoder_enable()).
>    Again, as shown by the above call graph, this is not the case. It
>    appears that the controller happens to work because it is still
>    initialized by the bootloader.

We don't have any bootloader support for MIPI-DSI, so no, that's not it.

>    Because the connector is hardcoded to always be connected, the
>    device's runtime PM reference is not dropped until system suspend,
>    when sun4i_drv_drm_sys_suspend() ends up calling
>    sun6i_dsi_encoder_disable(). However, that is done as a system sleep
>    PM hook, and at that point the system PM core has already taken
>    another runtime PM reference, so sun6i_dsi_runtime_suspend() is
>    not called. Likewise, by the time the PM core releases its reference,
>    sun4i_drv_drm_sys_resume() has already re-enabled the encoder.
>
>    So after system suspend and resume, we have *still never called*
>    sun6i_dsi_inst_init(), and now that the rest of the display pipeline
>    has been reset, the DSI host is unable to communicate with the panel,
>    causing VBLANK timeouts.

Either way, I guess just moving the pm_runtime_enable call to
sun6i_dsi_attach will fix this, right? We don't really need to have
the DSI controller powered up before that time anyway.

> Fix all of these issues by inlining the runtime PM hooks into the
> encoder enable/disable functions, which are guaranteed to run after a
> panel is attached. This allows sun6i_dsi_inst_init() to be called
> unconditionally. Furthermore, this causes the hardware to be turned off
> during system suspend and reinitialized on resume, which was not
> happening before.

That's not something we should do really. We're really lacking any
power management, so we should be having more of runtime_pm, not less.

Maxime

--kwpruo3coc5fkck7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXkJlMwAKCRDj7w1vZxhR
xYOyAP4i7bV29YYxSgA7p6SjdiD9FeE7lQtf60arSA++ez4MuQD/bU6dsgSPYiwK
hMZXytraIuKsW3QZc8GHvc91c2y+dAQ=
=fkj2
-----END PGP SIGNATURE-----

--kwpruo3coc5fkck7--
