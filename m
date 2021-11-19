Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946B6456B5D
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 09:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhKSINu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 19 Nov 2021 03:13:50 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:46565 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhKSINu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 03:13:50 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MF418-1muaha3XNw-00FPHu; Fri, 19 Nov 2021 09:10:46 +0100
Received: by mail-wr1-f43.google.com with SMTP id t30so16597344wra.10;
        Fri, 19 Nov 2021 00:10:46 -0800 (PST)
X-Gm-Message-State: AOAM5314nX/tl2dUN2USFftMfWz+744orGKq+CmcOl6s57miuMBkI3ri
        m4m229ob505y8W2dHh768t7XSSRDYkXgMQAQ3IM=
X-Google-Smtp-Source: ABdhPJx6qRGQWFWOaKX7IdWter6gwkfJpsyjLUqtZoPih1adh8HX2MN+hFqq2YVOIF2Y+C8hNKkWfNpPd+TCIcTYha8=
X-Received: by 2002:adf:df89:: with SMTP id z9mr4955733wrl.336.1637309446428;
 Fri, 19 Nov 2021 00:10:46 -0800 (PST)
MIME-Version: 1.0
References: <20211115165428.722074685@linuxfoundation.org> <20211115165456.391822721@linuxfoundation.org>
 <9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org> <fd7132a4-a016-9bf2-bb08-616f5f9d6e85@kernel.org>
In-Reply-To: <fd7132a4-a016-9bf2-bb08-616f5f9d6e85@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 19 Nov 2021 09:10:30 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3kE49BgyWozXH1rsxUr=ZDH1GM6r+nyeCRfe5r40QD_w@mail.gmail.com>
Message-ID: <CAK8P3a3kE49BgyWozXH1rsxUr=ZDH1GM6r+nyeCRfe5r40QD_w@mail.gmail.com>
Subject: Re: [PATCH 5.15 808/917] drm: fb_helper: improve CONFIG_FB dependency
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "Acked-by: Jani Nikula" <jani.nikula@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:ttMnjwJJBKl3Lnjlv/2iiYXIVxb9Jz1XG3ArSohCRTXR/udLr+Z
 0nITH3ozUK7WR1sv9uRuTHm5ecYKXH3DQUxngbOutltw+PrUbRtVKbbVUY7cveH1SfwXux4
 BZY8d8HoHn7buJHcuOGjaEauxHHy+8GDwl5hMYxQk2g/nZFnmuK6WITtsv5P30AyIne44EE
 Z3sBYyqU8+pF/QOV8JlGQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:akZywUKe9m8=:YbJ2JuBxghYrJmeqCmIQp1
 cpQ8r3HkyhUqK+Yq1+L0yAOZzAzi8KthLoJxJGHVUHvRAQqdCQ84URDzmWiK+k6uF7mg2OS4G
 ZEnnqhJLTsaUFvMDvlmrCG4nUuO0lyPDy/W+mILGsTKcXJ1IVnvrNUN0MS5nQmpxH7qof4VfX
 cFzo3NBv8mdZjMczE3rsLlIypkJV2DErlxKGOBC24JLa41+SbLf7v8QOhD0gH2r/3xAFJ7jY6
 U5iUhYyfNEcgI/BPJMn6WF0uRgMtcuQXLOdg43uqaU2DJEJWUbYbmquk7VdYGyARSQ6axiIMu
 MGkFEe+YeptudLvG5g/ecQPljBqkXjaHzSTsJ2jwmmHE1SIxR6TjZx8nFXwaGzKVjosXBipAo
 eDxo8p31NmrVjxCjpmgZP8hK5H5N8sFhy0pOyHq4KOwCGiq7vSiDCF7eopscyU1JkMl2Rl9Tc
 IHtXy5qMbru45aEnPILlY+dXrIhxuDwEoQHKbYdreiW0hhm2sKjDpT8DVyAtwCuCvBw6SQBOW
 5fEhajObv2sYvUYJnfyUXa3e7Fv+x1r1htWf4I+aMYn+ejW7rglrKi4RZTa5Hxx/tfTlQ+pZy
 wmPNuICCsAa0Nc3BCEYZEHTasNIAn8dtd6KtFj/+AdJrhU9bH228KL0WjN3PZOqw3MJZIFVuw
 sWlycGpXGXwTMmD0QTsVIqBPYKS7LSProfyKoZQkEoBXgie4HUUFFFGZ1olw6P3hb+uk=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 8:56 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> On 19. 11. 21, 8:50, Jiri Slaby wrote:
> > On 15. 11. 21, 18:05, Greg Kroah-Hartman wrote:
> >> From: Arnd Bergmann <arnd@arndb.de>
> >>
> >> [ Upstream commit 9d6366e743f37d36ef69347924ead7bcc596076e ]
> >
> > Hi,
> >
> > this breaks build on openSUSE's armv7hl config:
> > $ wget -O .config
> > https://raw.githubusercontent.com/openSUSE/kernel-source/stable/config/armv7hl/default
> >
> > $ make -j168 CROSS_COMPILE=arm-suse-linux-gnueabi- ARCH=arm vmlinux
> > ...
> >    LD      .tmp_vmlinux.btf
> > arm-suse-linux-gnueabi-ld: drivers/gpu/drm/panel/panel-simple.o: in
> > function `panel_simple_probe':
> > drivers/gpu/drm/panel/panel-simple.c:803: undefined reference to
> > `drm_panel_dp_aux_backlight'
> > $ grep -E 'CONFIG_(DRM|FB|DRM_KMS_HELPER|DRM_FBDEV_EMULATION)\>' .config
> > CONFIG_DRM=y
> > CONFIG_DRM_KMS_HELPER=m
> > CONFIG_DRM_FBDEV_EMULATION=y
> > CONFIG_FB=y
> >
> > 5.16-rc1 builds just fine -- investigating why…
>
> CLearly because the code moved to panel-edp.c. So doing:
> -CONFIG_DRM_PANEL_EDP=m
> +CONFIG_DRM_PANEL_EDP=y
> leads to the same error in that file:
> arm-suse-linux-gnueabi-ld: drivers/gpu/drm/panel/panel-edp.o: in
> function `panel_edp_probe':
> drivers/gpu/drm/panel/panel-edp.c:843: undefined reference to
> `drm_panel_dp_aux_backlight'

Ah right, I ran into a similar thing on my randconfig builds, this is
what I have
applied locally but wasn't completely sure about yet, it may need additional
'select DRM_KMS_CMA_HELPER' to cover all instances:

commit 8dd05af5243f3ab968b317ef82b3c0d04079b805
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon Nov 15 16:54:04 2021 +0100

    drm/mipi-dbi: select CONFIG_DRM_KMS_HELPER

    The driver fails to build when the KMS helpers are disabled:

    ld.lld: error: undefined symbol: drm_gem_fb_get_obj
    >>> referenced by drm_mipi_dbi.c
    >>>               gpu/drm/drm_mipi_dbi.o:(mipi_dbi_buf_copy) in
archive drivers/built-in.a
    >>> referenced by drm_mipi_dbi.c
    >>>               gpu/drm/drm_mipi_dbi.o:(mipi_dbi_fb_dirty) in
archive drivers/built-in.a

    ld.lld: error: undefined symbol: drm_gem_fb_begin_cpu_access
    >>> referenced by drm_mipi_dbi.c
    >>>               gpu/drm/drm_mipi_dbi.o:(mipi_dbi_buf_copy) in
archive drivers/built-in.a

    ld.lld: error: undefined symbol: drm_fb_swab
    >>> referenced by drm_mipi_dbi.c
    >>>               gpu/drm/drm_mipi_dbi.o:(mipi_dbi_buf_copy) in
archive drivers/built-in.a

    ld.lld: error: undefined symbol: drm_fb_xrgb8888_to_rgb565
    >>> referenced by drm_mipi_dbi.c
    >>>               gpu/drm/drm_mipi_dbi.o:(mipi_dbi_buf_copy) in
archive drivers/built-in.a

    ld.lld: error: undefined symbol: drm_fb_memcpy
    >>> referenced by drm_mipi_dbi.c
    >>>               gpu/drm/drm_mipi_dbi.o:(mipi_dbi_buf_copy) in
archive drivers/built-in.a

    This is fairly hard to hit in randconfig drivers, but it eventually
    did trigger for me in a configuration where all other DRM drivers
    are loadable modules, but DRM_PANEL_WIDECHIPS_WS2401 was built-in.

    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 0039df26854b..a03c2761c5f9 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -29,6 +29,7 @@ menuconfig DRM

 config DRM_MIPI_DBI
        tristate
+       select DRM_KMS_HELPER
        depends on DRM

 config DRM_MIPI_DSI
diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 431b6e12a81f..17a8d603e7d8 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -8,7 +8,6 @@ config DRM_BRIDGE
 config DRM_PANEL_BRIDGE
        def_bool y
        depends on DRM_BRIDGE
-       depends on DRM_KMS_HELPER
        select DRM_PANEL
        help
          DRM bridge wrapper of DRM panels
diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index cfc8d644cedf..40ec20f3552d 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -140,9 +140,8 @@ config DRM_PANEL_ILITEK_IL9322
 config DRM_PANEL_ILITEK_ILI9341
        tristate "Ilitek ILI9341 240x320 QVGA panels"
        depends on OF && SPI
-       depends on DRM_KMS_HELPER
-       depends on DRM_KMS_CMA_HELPER
        depends on BACKLIGHT_CLASS_DEVICE
+       select DRM_KMS_CMA_HELPER
        select DRM_MIPI_DBI
        help
          Say Y here if you want to enable support for Ilitek IL9341
