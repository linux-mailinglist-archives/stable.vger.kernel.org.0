Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4915C3CD155
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 12:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhGSJRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 05:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbhGSJRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 05:17:04 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75F6C061574;
        Mon, 19 Jul 2021 02:01:27 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id e14so6978815ljo.7;
        Mon, 19 Jul 2021 02:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nIaKqXMa6oT0DO29A1M702A2DzJt7GwY+je+42Ehw2U=;
        b=t22cOT+xVJTGURpEm0vVYzWkOxYXprVgMKeerHF2EZm3Zdy8pdvbgC2uh1eLyddFj8
         Z5TIu6abrPgkvAJhkonXStQDAJTEvdQMi8kfM3KXFHaR8HS9ccMf7czm1OxONjJL42dX
         aC6NuhU80BNiOet6Bvg6m5rB0JrXOmfdgPk8oOMyDzQlhsKDXw1AHd+4VVKpcdd+Wipd
         sAsfigBVWGv0uxefH0aBZdNFTurUREA0/sBdmF++lUw3zax4c9FKB12B1cgozaScg3sm
         RGAs//BIptNvMCI4bUV789Crg4/muCG62kZUvjTiwxToN+yWxD3jOeAve//jwKaJSGen
         xNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nIaKqXMa6oT0DO29A1M702A2DzJt7GwY+je+42Ehw2U=;
        b=COyIZkhI0xbs9XxGIvPXL0Vib2tfuy5TvJKwoEgE1CBp3SFUicfOhsflW+9uQ12Ggo
         R2JBW8GX7tJ88yBWszXXq+ydOJBiK3IylDXTR0yq17pdWZJs0WjglI32hcvGhGakJPMA
         ttyPEy15mWNBqSlFMwp0pO3BtD+gwCF0N9Vw0POoaVwiNGLvsKO2CcMXI6U/AY4oIUTB
         f93cjD+Cb9vEiAh42gdPjQtqDGWiYofBS9Z5aO5ncmqZzcezqGP9NImQm+ENMAgvo85Z
         ipglIW1ZlOzcRB60mrrCnfWM//c6FyoqFFwEnjXeuGckXOMHe4oBUETKKFDoNWpILhEo
         u/NA==
X-Gm-Message-State: AOAM532r8wSTp9RHEjWV+EFHZRVfZYIky7eijlefe56ibXQLB+sa/NJ9
        ElZ2N4uk5HdRSvMefSO5z04iTcdFtmCWbw5n7Ss=
X-Google-Smtp-Source: ABdhPJzC3ZrVaSM/trW2y79AnzNLWj1tMCUTAOqCDil7DtCgZMztht9kYxdQpcPnJV13Xz0w61TFJAkJG8pgoTmmh6o=
X-Received: by 2002:a2e:9e05:: with SMTP id e5mr21916618ljk.141.1626688661931;
 Mon, 19 Jul 2021 02:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182551.731989182@linuxfoundation.org> <20210715182634.577299401@linuxfoundation.org>
In-Reply-To: <20210715182634.577299401@linuxfoundation.org>
From:   Xiaotian Feng <xtfeng@gmail.com>
Date:   Mon, 19 Jul 2021 17:57:30 +0800
Message-ID: <CAJn8CcF+gfXToErpZv=pWmBKF-i--oVWmaM=6AQ8YZCb21X=oA@mail.gmail.com>
Subject: Re: [PATCH 5.12 237/242] drm/ast: Remove reference to struct drm_device.pdev
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        kernel test robot <lkp@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 5:13 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Thomas Zimmermann <tzimmermann@suse.de>
>
> commit 0ecb51824e838372e01330752503ddf9c0430ef7 upstream.
>
> Using struct drm_device.pdev is deprecated. Upcast with to_pci_dev()
> from struct drm_device.dev to get the PCI device structure.
>
> v9:
>         * fix remaining pdev references
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> Fixes: ba4e0339a6a3 ("drm/ast: Fixed CVE for DP501")
> Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
> Cc: kernel test robot <lkp@intel.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: dri-devel@lists.freedesktop.org
> Link: https://patchwork.freedesktop.org/patch/msgid/20210429105101.25667-2-tzimmermann@suse.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/ast/ast_main.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> --- a/drivers/gpu/drm/ast/ast_main.c
> +++ b/drivers/gpu/drm/ast/ast_main.c
> @@ -411,7 +411,6 @@ struct ast_private *ast_device_create(co
>                 return ast;
>         dev = &ast->base;
>
> -       dev->pdev = pdev;
>         pci_set_drvdata(pdev, dev);
>
>         ast->regs = pcim_iomap(pdev, 1, 0);
> @@ -453,8 +452,8 @@ struct ast_private *ast_device_create(co
>
>         /* map reserved buffer */
>         ast->dp501_fw_buf = NULL;
> -       if (dev->vram_mm->vram_size < pci_resource_len(dev->pdev, 0)) {
> -               ast->dp501_fw_buf = pci_iomap_range(dev->pdev, 0, dev->vram_mm->vram_size, 0);
> +       if (dev->vram_mm->vram_size < pci_resource_len(pdev, 0)) {
> +               ast->dp501_fw_buf = pci_iomap_range(pdev, 0, dev->vram_mm->vram_size, 0);
>                 if (!ast->dp501_fw_buf)
>                         drm_info(dev, "failed to map reserved buffer!\n");
>         }
>

Hi Greg,

     This backport is incomplete for 5.10 kernel,  kernel is panicked
on RIP: ast_device_create+0x7d.  When I look into the crash code, I
found

struct ast_private *ast_device_create(struct drm_driver *drv,
                                      struct pci_dev *pdev,
                                      unsigned long flags)
{
.......
        dev->pdev = pdev;  // This is removed
        pci_set_drvdata(pdev, dev);

        ast->regs = pcim_iomap(pdev, 1, 0);
        if (!ast->regs)
                return ERR_PTR(-EIO);

        /*
         * If we don't have IO space at all, use MMIO now and
         * assume the chip has MMIO enabled by default (rev 0x20
         * and higher).
         */
        if (!(pci_resource_flags(dev->pdev, 2) & IORESOURCE_IO)) { //
dev->pdev is in used here.
                drm_info(dev, "platform has no IO space, trying MMIO\n");
                ast->ioregs = ast->regs + AST_IO_MM_OFFSET;
        }

        That's because commit 46fb883c3d0d8a823ef995ddb1f9b0817dea6882
is not backported to 5.10 kernel.

Best Regards
Xiaotian
