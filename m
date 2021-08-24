Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC293F6538
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbhHXRKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239673AbhHXRJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 13:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629824911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAkVl4muzdQPrWqv3jT8cULrRk2pHmerwmwahfAa5XM=;
        b=SKqNtwivmQooimGkGAg+6TIjo8AXjKodqkKcJuYZj6x44vgMInhE7HWu3F+o6+ux1zQj9/
        NhwmTZa6epWYG5/gBImLTzGHSOP0hZdGyq6kVrtpTMH/M4v/msqfMcjzaoMPfv4VgrwH57
        AvGQlwhVbLn8onJsSZboyYi+3PtTbfA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-L6tnwmUCP_mle8WXAOw3YA-1; Tue, 24 Aug 2021 13:08:30 -0400
X-MC-Unique: L6tnwmUCP_mle8WXAOw3YA-1
Received: by mail-qk1-f199.google.com with SMTP id d202-20020a3768d3000000b003d30722c98fso14719537qkc.10
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 10:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=dAkVl4muzdQPrWqv3jT8cULrRk2pHmerwmwahfAa5XM=;
        b=lqs7L46YXL5RQElNtjDxeBHrOintsQHANlmBqaZbqRsJhzUhBEZSGFsxIDTAxjBsdY
         Rsnz/4qBKz4MLrwoGjE/MXEBd7HjG7RRJBFmriEgwkZT3N7hQUiOoxR7bKNSxda7P++H
         h2McRljCol/rBppFcnoBJQ0Xp78eRex3/YbxS6/aoerhVc9gqs47mSn6WSZ8CD64m8t1
         d+O9JKgaYrMDeiFiLfYx7fY48rGejV3HQUg3/xhV0DvjszqWmy9Z5cs8x9f89LHzJT8s
         h5WeImvA9Km9zWBaKWDsxyReH0gTa708l/i2AxMvBYsRCGgSNvm457ukFyJHx5D83Mfx
         sTsA==
X-Gm-Message-State: AOAM533oiwIksJqCbU2YkNiNdOyeA4bysOczK9VfIZH2tm7/PVqPTBa0
        SFFeIYpIsvzMuY6LHUihWMK53/3yosI29+/xRpQb31fmEiqhuj/voGLL/3EsV0rDN8/Mr/cRXJp
        6jtjwLT0Uzj2aOUa8
X-Received: by 2002:a05:620a:4ed:: with SMTP id b13mr27114974qkh.26.1629824910284;
        Tue, 24 Aug 2021 10:08:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8V/5mLfM4VrGrXcWlxoFrrEreLpKoBkx2IpdnRG8q7Idvub+fuLWIIz3F/ZFCXaE8qPhBlg==
X-Received: by 2002:a05:620a:4ed:: with SMTP id b13mr27114963qkh.26.1629824910148;
        Tue, 24 Aug 2021 10:08:30 -0700 (PDT)
Received: from [192.168.8.104] (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id l4sm11354108qkd.77.2021.08.24.10.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 10:08:29 -0700 (PDT)
Message-ID: <6607dde4207eb7ad1666b131c86f60a57a2a193c.camel@redhat.com>
Subject: Re: [PATCH AUTOSEL 5.13 20/26] drm/nouveau: recognise GA107
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org
Date:   Tue, 24 Aug 2021 13:08:28 -0400
In-Reply-To: <20210824005356.630888-20-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
         <20210824005356.630888-20-sashal@kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is more hardware enablement, I'm not sure this should be going into
stable either. Ben?

On Mon, 2021-08-23 at 20:53 -0400, Sasha Levin wrote:
> From: Ben Skeggs <bskeggs@redhat.com>
> 
> [ Upstream commit fa25f28ef2cef19bc9ffeb827b8ecbf48af7f892 ]
> 
> Still no GA106 as I don't have HW to verif.
> 
> Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> Reviewed-by: Lyude Paul <lyude@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  .../gpu/drm/nouveau/nvkm/engine/device/base.c | 21 +++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> index b930f539feec..93ddf63d1114 100644
> --- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> +++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
> @@ -2624,6 +2624,26 @@ nv174_chipset = {
>         .dma      = { 0x00000001, gv100_dma_new },
>  };
>  
> +static const struct nvkm_device_chip
> +nv177_chipset = {
> +       .name = "GA107",
> +       .bar      = { 0x00000001, tu102_bar_new },
> +       .bios     = { 0x00000001, nvkm_bios_new },
> +       .devinit  = { 0x00000001, ga100_devinit_new },
> +       .fb       = { 0x00000001, ga102_fb_new },
> +       .gpio     = { 0x00000001, ga102_gpio_new },
> +       .i2c      = { 0x00000001, gm200_i2c_new },
> +       .imem     = { 0x00000001, nv50_instmem_new },
> +       .mc       = { 0x00000001, ga100_mc_new },
> +       .mmu      = { 0x00000001, tu102_mmu_new },
> +       .pci      = { 0x00000001, gp100_pci_new },
> +       .privring = { 0x00000001, gm200_privring_new },
> +       .timer    = { 0x00000001, gk20a_timer_new },
> +       .top      = { 0x00000001, ga100_top_new },
> +       .disp     = { 0x00000001, ga102_disp_new },
> +       .dma      = { 0x00000001, gv100_dma_new },
> +};
> +
>  static int
>  nvkm_device_event_ctor(struct nvkm_object *object, void *data, u32 size,
>                        struct nvkm_notify *notify)
> @@ -3049,6 +3069,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
>                 case 0x168: device->chip = &nv168_chipset; break;
>                 case 0x172: device->chip = &nv172_chipset; break;
>                 case 0x174: device->chip = &nv174_chipset; break;
> +               case 0x177: device->chip = &nv177_chipset; break;
>                 default:
>                         if (nvkm_boolopt(device->cfgopt,
> "NvEnableUnsupportedChipsets", false)) {
>                                 switch (device->chipset) {

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

