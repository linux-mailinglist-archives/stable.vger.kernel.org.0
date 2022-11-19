Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8628D630C14
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 06:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiKSFU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 00:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiKSFU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 00:20:27 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34788E097;
        Fri, 18 Nov 2022 21:20:25 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id me22so1084324ejb.8;
        Fri, 18 Nov 2022 21:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7Y4bxw1JD63M5XllY6npHcIrHCuFCtkIt2jLzNAtGRU=;
        b=exLzb3poQrwX0fkXQzG5mAxcKfcogKJp9nov8VgFXIyCExcSGg76o3gfk3lxW4TGq/
         5xNTWZqM33mWjFXrUkLSC6soMu7mSI8TX+/lMiKkDzXvt+BcnmFgvp6+6HUzQTJzMQJl
         R/LpBJNoKtKYYDvKcuSYG4Np++PnyHl7ixI3U3G7Ksm9Ep4dvMeY2WURxEsaA5JQgICU
         MOTfGU8w21ifwZUnzi73y76Wa8x5WHQJIbsFq+NMyaCcAGoptPLXnjLzenS8UDCS2pVA
         KSNMHLP8IRfTL5bgWTaCNPl64ZUuRl+X9vKzXjd1YEc1E/L3UPEJXw5l+O/19kFQhGG9
         Hyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Y4bxw1JD63M5XllY6npHcIrHCuFCtkIt2jLzNAtGRU=;
        b=ExwWaWkV2TtEIXQQDUD+HIF8Cc1LuKUUhw9I6FI4sRTHLaNpytnxbV2QzAvjuwhtwl
         HjGfMPtSEADXQw3wed8FdCJpNJpuKyY9uxrGFHhLnX8EF0gcIelRzsqvFaqHANXiBeIb
         2btdAjpX/0CYEKyNNdCE9jUxKcIYmHrtwWIQioS+obhmrzYpPzla+Q8AlSs4GAuO5Lce
         QyPRg9f2pg4BM6N6TLsOBW42Dfv8ZpJbtn+5APrpJv0/i09RCgf7iv/GqGpdiTyhzGC9
         qtiKcC6LR8ncIo3dqGTx2/tik9C6TzKLrwoifcPaNIptY6lvawNXg8ILFwuarTXcCFIp
         WALg==
X-Gm-Message-State: ANoB5pk66W0VKJ+gVo90CRmmCbk5zsJ/1tFISuKKd+3ktR/i/qaTe9AQ
        0YxwONDg6svprG0RU/U9MUpNstmPyQ70jPiRvOWLsMPWRLK8JMg47QI=
X-Google-Smtp-Source: AA0mqf6QeRRX0IlcllwtANP/CEQ4uvjC6o1p5svY601MJVeWZ30wxil0NldfeqRcJRaIQZIb3Z49UrIGJN0yANUpc7w=
X-Received: by 2002:a17:906:560e:b0:7a2:335e:90e2 with SMTP id
 f14-20020a170906560e00b007a2335e90e2mr8281399ejq.712.1668835224347; Fri, 18
 Nov 2022 21:20:24 -0800 (PST)
MIME-Version: 1.0
References: <20220819200928.401416-1-kherbst@redhat.com>
In-Reply-To: <20220819200928.401416-1-kherbst@redhat.com>
From:   Computer Enthusiastic <computer.enthusiastic@gmail.com>
Date:   Sat, 19 Nov 2022 06:20:10 +0100
Message-ID: <CAHSpYy182u=3g2dH+DRuoUSEBYYr8E571oHeN4y=wB1gCqbGEw@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH] nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf
To:     Karol Herbst <kherbst@redhat.com>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Il giorno ven 19 ago 2022 alle ore 22:09 Karol Herbst
<kherbst@redhat.com> ha scritto:
>
> It is a bit unlcear to us why that's helping, but it does and unbreaks
> suspend/resume on a lot of GPUs without any known drawbacks.
>
> Cc: stable@vger.kernel.org # v5.15+
> Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/156
> Signed-off-by: Karol Herbst <kherbst@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_bo.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index 35bb0bb3fe61..126b3c6e12f9 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -822,6 +822,15 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict,
>                 if (ret == 0) {
>                         ret = nouveau_fence_new(chan, false, &fence);
>                         if (ret == 0) {
> +                               /* TODO: figure out a better solution here
> +                                *
> +                                * wait on the fence here explicitly as going through
> +                                * ttm_bo_move_accel_cleanup somehow doesn't seem to do it.
> +                                *
> +                                * Without this the operation can timeout and we'll fallback to a
> +                                * software copy, which might take several minutes to finish.
> +                                */
> +                               nouveau_fence_wait(fence, false, false);
>                                 ret = ttm_bo_move_accel_cleanup(bo,
>                                                                 &fence->base,
>                                                                 evict, false,
> --
> 2.37.1
>

Could it be possible to make land the aforementioned patch to the
5.10.x kernel version ? It is currently for >= 5.15.x kernel version
only.

Thanks.
