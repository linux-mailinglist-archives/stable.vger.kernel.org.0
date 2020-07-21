Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBC82281E3
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 16:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgGUOUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 10:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgGUOUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 10:20:11 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE2320702;
        Tue, 21 Jul 2020 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595341210;
        bh=cAP1G3QA2CqDg6tz1CmbfyTfHQOZhCiHvnGoZ28h2OY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=Z48SoPS96EBFIFheNRidOqjfsIr1BTpwe7kdh2S773MenCOI71lbzeKOIW2Q17i7M
         wHsVKc53XKvt2OVS+Lq9MZU9ksQJ7E4nRJsIDt0Tb4HvnkdEcEzQ68yqfsTqR0+ydt
         0yPM9P+ezBxdLAkH+91OWkf2FgVvJfOavUVNZTcg=
Date:   Tue, 21 Jul 2020 14:20:09 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-arm-kernel@lists.infradead.org
Cc:     Stephan Gerhold <stephan@gerhold.net>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/mcde: Fix stability issue
In-Reply-To: <20200718233323.3407670-1-linus.walleij@linaro.org>
References: <20200718233323.3407670-1-linus.walleij@linaro.org>
Message-Id: <20200721142010.6CE2320702@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.9, v5.4.52, v4.19.133, v4.14.188, v4.9.230, v4.4.230.

v5.4.52: Failed to apply! Possible dependencies:
    768859c239922 ("drm/mcde: Provide vblank handling unconditionally")
    d920e8da3d837 ("drm/mcde: Fix frame sync setup for video mode panels")

v4.19.133: Failed to apply! Possible dependencies:
    01648890f336a ("staging: vboxvideo: Embed drm_device into driver structure")
    0424d7ba4574b ("staging: vboxvideo: Init fb_info.fix.smem once from fbdev_create")
    0fdda2ce74e5f ("staging: vboxvideo: Move pin / unpin of fb out of vbox_crtc_set_base_and_mode")
    131abc56e1bac ("drm/vboxvideo: Move the vboxvideo driver out of staging")
    3498ea8b7e3c8 ("staging: vboxvideo: Fold vbox_drm_resume() into vbox_pm_resume()")
    35f3288c453e2 ("staging: vboxvideo: Atomic phase 1: convert cursor to universal plane")
    438340aa20975 ("staging: vboxvideo: Atomic phase 3: Switch last bits over to atomic")
    4f2a8f5898ecd ("drm: Add ASPEED GFX driver")
    5cf5332d529bf ("staging: vboxvideo: Restore page-flip support")
    5fc537bfd0003 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
    685bb884e0a42 ("staging: vboxvideo: Drop duplicate vbox_err.h file")
    79815ee23890c ("staging: vboxvideo: Move setup of modesetting from driver_load to mode_init")
    96bae04347b24 ("staging/vboxvideo: prepare for drmP.h removal from drm_modeset_helper.h")
    a1d2a6339961e ("drm/lima: driver for ARM Mali4xx GPUs")
    a5aca20574693 ("staging: vboxvideo: Fix modeset / page_flip error handling")
    acc962c514007 ("staging: vboxvideo: Change licence headers over to SPDX")
    cb5eaf187d1d9 ("staging: vboxvideo: Expose creation of universal primary plane")
    cc0ec5eb721f1 ("staging: vboxvideo: Atomic phase 1: Use drm_plane_helpers for primary plane")
    cd76c287a52fe ("staging: vboxvideo: Cleanup the comments")
    ce8ec32cbd420 ("staging: vboxvideo: Remove vboxfb_create_object() wrapper")
    cfc1fc63be447 ("staging: vboxvideo: Move bo_[un]resere calls into vbox_bo_[un]pin")
    d46709094deb6 ("staging: vboxvideo: Fold driver_load/unload into probe/remove functions")
    f4d6d90f83147 ("staging: vboxvideo: Add fl_flag argument to vbox_fb_pin() helper")

v4.14.188: Failed to apply! Possible dependencies:
    01648890f336a ("staging: vboxvideo: Embed drm_device into driver structure")
    0424d7ba4574b ("staging: vboxvideo: Init fb_info.fix.smem once from fbdev_create")
    0fdda2ce74e5f ("staging: vboxvideo: Move pin / unpin of fb out of vbox_crtc_set_base_and_mode")
    131abc56e1bac ("drm/vboxvideo: Move the vboxvideo driver out of staging")
    179c02fe90a41 ("drm/tve200: Add new driver for TVE200")
    1daddbc8dec56 ("staging: vboxvideo: Update driver to use drm_dev_register.")
    1ebafd1561a05 ("staging: vboxvideo: Fix IRQs no longer working")
    2408898e3b6c9 ("staging: vboxvideo: Add page-flip support")
    3498ea8b7e3c8 ("staging: vboxvideo: Fold vbox_drm_resume() into vbox_pm_resume()")
    35f3288c453e2 ("staging: vboxvideo: Atomic phase 1: convert cursor to universal plane")
    438340aa20975 ("staging: vboxvideo: Atomic phase 3: Switch last bits over to atomic")
    4f2a8f5898ecd ("drm: Add ASPEED GFX driver")
    5b8ea816e8e05 ("drm/tinydrm: add driver for ST7735R panels")
    5cf5332d529bf ("staging: vboxvideo: Restore page-flip support")
    5fc537bfd0003 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
    65aac17423284 ("staging: vboxvideo: Change address of scanout buffer on page-flip")
    685bb884e0a42 ("staging: vboxvideo: Drop duplicate vbox_err.h file")
    6d544fd6f4e15 ("drm/doc: Put all driver docs into a separate chapter")
    79815ee23890c ("staging: vboxvideo: Move setup of modesetting from driver_load to mode_init")
    96bae04347b24 ("staging/vboxvideo: prepare for drmP.h removal from drm_modeset_helper.h")
    a1d2a6339961e ("drm/lima: driver for ARM Mali4xx GPUs")
    a5aca20574693 ("staging: vboxvideo: Fix modeset / page_flip error handling")
    acc962c514007 ("staging: vboxvideo: Change licence headers over to SPDX")
    ba67f54d911c3 ("staging: vboxvideo: Pass a new framebuffer to vbox_crtc_do_set_base")
    c575b7eeb89f9 ("drm/xen-front: Add support for Xen PV display frontend")
    cb5eaf187d1d9 ("staging: vboxvideo: Expose creation of universal primary plane")
    cc0ec5eb721f1 ("staging: vboxvideo: Atomic phase 1: Use drm_plane_helpers for primary plane")
    cd76c287a52fe ("staging: vboxvideo: Cleanup the comments")
    ce8ec32cbd420 ("staging: vboxvideo: Remove vboxfb_create_object() wrapper")
    cfc1fc63be447 ("staging: vboxvideo: Move bo_[un]resere calls into vbox_bo_[un]pin")
    d46709094deb6 ("staging: vboxvideo: Fold driver_load/unload into probe/remove functions")
    f4d6d90f83147 ("staging: vboxvideo: Add fl_flag argument to vbox_fb_pin() helper")

v4.9.230: Failed to apply! Possible dependencies:
    0a886f59528aa ("drm: zte: add initial vou drm driver")
    179c02fe90a41 ("drm/tve200: Add new driver for TVE200")
    3650c25ad0a7b ("drm/meson: Add RST to bring together kerneldoc")
    384fe7a4d732c ("drivers: net: xgene-v2: Add DMA descriptor")
    3b3f9a75d9318 ("drivers: net: xgene-v2: Add base driver")
    413dfbbfca549 ("MAINTAINERS: add entry for Aspeed I2C driver")
    45d59d704080c ("drm: Add new driver for MXSFB controller")
    51c5d8447bd71 ("MMC: meson: initial support for GX platforms")
    5fc537bfd0003 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
    60c5d3b72989e ("drm/vc4: Add RST to bring together vc4 kerneldoc.")
    6d544fd6f4e15 ("drm/doc: Put all driver docs into a separate chapter")
    70dbd9b258d5a ("MAINTAINERS: Add entry for APM X-Gene SoC Ethernet (v2) driver")
    7683e9e529258 ("Properly alphabetize MAINTAINERS file")
    81ccd0cab29b6 ("drivers: net: xgene-v2: Add mac configuration")
    b105bcdaaa0ef ("drivers: net: xgene-v2: Add transmit and receive")
    bbbe775ec5b5d ("drm: Add support for Amlogic Meson Graphic Controller")
    bed41005e6174 ("drm/pl111: Initial drm/kms driver for pl111")
    d52ea7e3d4938 ("MAINTAINERS: Add drm-misc")
    fa201ac2c61f5 ("drm: Add DRM support for tiny LCD displays")
    fa6d095eb23a8 ("drm/tegra: Add driver documentation")
    fd33f3eca6bfb ("MAINTAINERS: Add maintainers for the meson clock driver")

v4.4.230: Failed to apply! Possible dependencies:
    0a886f59528aa ("drm: zte: add initial vou drm driver")
    119f5173628aa ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
    22cba31bae9dc ("Documentation/sphinx: add basic working Sphinx configuration and build")
    23e7b2ab9a8ff ("drm/hisilicon: Add hisilicon kirin drm master driver")
    3650c25ad0a7b ("drm/meson: Add RST to bring together kerneldoc")
    45d59d704080c ("drm: Add new driver for MXSFB controller")
    51dacf208988e ("drm: Add support of ARC PGU display controller")
    5fc537bfd0003 ("drm/mcde: Add new driver for ST-Ericsson MCDE")
    6d544fd6f4e15 ("drm/doc: Put all driver docs into a separate chapter")
    8e22d79240d95 ("drm: Add support for ARM's HDLCD controller.")
    a8c21a5451d83 ("drm/etnaviv: add initial etnaviv DRM driver")
    bbbe775ec5b5d ("drm: Add support for Amlogic Meson Graphic Controller")
    bed41005e6174 ("drm/pl111: Initial drm/kms driver for pl111")
    ca00c2b986eaf ("Documentation/gpu: split up the gpu documentation")
    cb597fcea5c28 ("Documentation/gpu: add new gpu.rst converted from DocBook gpu.tmpl")
    d92d9c3a14488 ("drm: hide legacy drivers with CONFIG_DRM_LEGACY")
    fa201ac2c61f5 ("drm: Add DRM support for tiny LCD displays")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
