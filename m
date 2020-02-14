Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3875415DB2E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgBNPju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:39:50 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39577 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729416AbgBNPju (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 10:39:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id A94775BC;
        Fri, 14 Feb 2020 10:39:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 14 Feb 2020 10:39:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Xn6bkCq3IHWbARqSJQRu/yjMZ3m
        Wx6T6bFlYS9wLQ0g=; b=EjQN9ZidI4L2P/uzDEPEfpSrVu58fuXU/cNTz6HGCUq
        zOO3yJkXhVQzr1Te1yUSIWkJ5U/WenrFP5tQSqMFgNgVpB/ADeXlAH2252SL4ftP
        ginDkMxfI+fov4ksbZ1xJ6U2MotLoS6ZlFMdfgWHWskpdoUQb2xuaxqcRwkvHc14
        gDWvzgwawsyZ8DPHRCi6u3tvWQ58SvkSQCGv/8DGfVx86oBytLyPSw5JO2ZeEJ2b
        ICAGghp/y8ipq8AS9NRVpjRtYrqcCwHrg3KdMxk7QMkzXTAVcJ7+RtR4AortJLP3
        n9c6zR8j/ViYr4kH5fig1+k9dSz7HKiEzwefQizHasQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Xn6bkC
        q3IHWbARqSJQRu/yjMZ3mWx6T6bFlYS9wLQ0g=; b=hPFiBqbM1cTH51+JkdrSzL
        4x1MD/COSmhFILC2dxRKhT8SomRNj8VKCHIHeNQ9jWzeT14SzY8Pf2I43ewjVfVf
        mbSg7yvJKdkK1XgeicpQRWQWUsQYDfMEse4ZXMZa7KvF/1gic/iN821bVNTi/vLA
        MtT62N6VYVPcElkBvpf5Gj0RZwAM9bZKpVvRLzwc4/0fAdLqVAJwXS8cDGfIQ9s0
        EBxB018QngOdLEJOGVhjVRc5Db3fFIz7ng0cipl+DmB5WuKMgquxW1J6oz8Kdnld
        3oljHxkYHLd/ON4v6ewJYLJb+gV+7B1lZI5duZb3MqXHvcDaePNnBwion6fI2BXA
        ==
X-ME-Sender: <xms:Q79GXlrwVuJre4U8kqRDtOCMd3GQqOdo50VDur0dbWWaU7Kv7ZSBng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjedtgdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucfkphepledtrd
    ekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:Q79GXr4nErsL___eL0NgPQTNn5Wez-0o-f1vu0Edj6iVWn6vE0knsQ>
    <xmx:Q79GXtOMQh9JBLRulso3Qz6JjPUqZEP8tEtJXy0oHU1Q_7-km5zeZQ>
    <xmx:Q79GXlORXvW7AQAy35c7eFPZF_y7J4zmXhqYJo_EOVCVXEk_IbHtug>
    <xmx:RL9GXia6RsTIyfeJd9GKeGgx-NnxNXsLZ_FlO1JJsAS2mIKXJ9vfKg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A3C2328005A;
        Fri, 14 Feb 2020 10:39:46 -0500 (EST)
Date:   Fri, 14 Feb 2020 16:39:45 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Chen-Yu Tsai <wens@csie.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4/4] drm/sun4i: dsi: Remove incorrect use of runtime PM
Message-ID: <20200214153945.f5z42fovcitvdlcr@gilmour.lan>
References: <20200211072858.30784-1-samuel@sholland.org>
 <20200211072858.30784-4-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rtmrzd3owfcaeil6"
Content-Disposition: inline
In-Reply-To: <20200211072858.30784-4-samuel@sholland.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rtmrzd3owfcaeil6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 11, 2020 at 01:28:58AM -0600, Samuel Holland wrote:
> The driver currently uses runtime PM to perform some of the module
> initialization and cleanup. This has three problems:
>
> 1) There is no Kconfig dependency on CONFIG_PM, so if runtime PM is
>    disabled, the driver will not work at all, since the module will
>    never be initialized.
>
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
>
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
>
>    Therefore, part of the controller initialization will only run if the
>    device is suspended between the calls to mipi_dsi_host_register() and
>    component_add() (which ends up calling sun6i_dsi_encoder_enable()).
>    Again, as shown by the above call graph, this is not the case. It
>    appears that the controller happens to work because it is still
>    initialized by the bootloader.
>
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
>
> Fix all of these issues by inlining the runtime PM hooks into the
> encoder enable/disable functions, which are guaranteed to run after a
> panel is attached. This allows sun6i_dsi_inst_init() to be called
> unconditionally. Furthermore, this causes the hardware to be turned off
> during system suspend and reinitialized on resume, which was not
> happening before.
>
> Fixes: 133add5b5ad4 ("drm/sun4i: Add Allwinner A31 MIPI-DSI controller support")
> Signed-off-by: Samuel Holland <samuel@sholland.org>

Applied all 4 patches.

This one failed to apply for some reason (even though the context
looks similar) so I fixed the conflict by hand, you might want to
double check.

Thanks!
Maxime

--rtmrzd3owfcaeil6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXka/QQAKCRDj7w1vZxhR
xROhAP9xJDyQFSRI0tejwko7eZz6nzw0YOPs5uKx1NWyOEkIhAD/cUcrgex7M7Gq
jRQ9ouveV4eRA7LCI3o94CXtO5B3kwY=
=2318
-----END PGP SIGNATURE-----

--rtmrzd3owfcaeil6--
