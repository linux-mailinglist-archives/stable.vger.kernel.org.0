Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AFD692466
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjBJR04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjBJR0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:26:54 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE151BAE6
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:26:51 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id x8so6409839vso.2
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676050010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RehKrwzxHb0yZ51xrZqY5znickazVA/y+gvM1FSD2Dc=;
        b=LWTEJdiR5kX7u2OjvFwTPLGKKX07+wDA44KwOpiw+SWhQwqr1QUReUp4WtlvtehD42
         SNJN/M5cNl6rpr9TX6yKGDhdVjb+P9b30ZyDEXp7Cv34Dzwyjw9284JECxoc5iu2NkOH
         LrB+SyTo+lYwZN7QuFTuPUHvoyvcBut7EQs3bwY8he4EvdwFvrW9pW+t0UAVJDQOPQie
         93RZr643pX7rLQxSRaZyXmvCBJZ4lX1nVGzbZAogndFqfQgYt6RodV74lfec7ZNtlNpL
         EADvyvJAQUcvh/KXG3yD3SzYOqQlW/TDOgPV63Cu4cz1qoA7aRTheEzh2RGy6jQHCPV8
         uHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676050010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RehKrwzxHb0yZ51xrZqY5znickazVA/y+gvM1FSD2Dc=;
        b=GDtDnpCJzk5XsNqSynwgBT9rEFpxVGzPBy/Mf+JGp1Mwcdp6QItahB+9TKNswhhlg6
         9idI3Q+YobvypBnRC6xMCHR74N9Iy1tE99J7sPYfRe8+OaU7cJxcqn9j6XkDP8ZjSkYf
         4AtNjc49z8l/kVYjoh2H8QFjOVMwB+WXTSsei+0xJ8WWlmYmL2Tf/WT+tL1WNU4Z4wnr
         laJe3bt66xgPY6ziz8HFS1G6G2uNhJUEEp8MdX97wtxMuGbfWa7raSq6ZKcp65bufgAN
         vkQXRfb5LdoCSIjZXuZOjlwHAMUpLdGB5dzHAfUD3OU0Jo3257MwfkdRLpM7Y1n2IdYj
         UBjg==
X-Gm-Message-State: AO0yUKXkdgzELioppxzu9Zxxn1IGsndMNuOQZQYjSKYmylhmvKYKG4F1
        MmpYRHeHSBf6v0kKpQjw1+lOReiOtwdTTOEapmY=
X-Google-Smtp-Source: AK7set9nHpclcgx3OJ0QPt0VsrPTKCnXQCzVKu9UofvBepaI+exPKwYBRMrg9Ie0VdtyQhJV6z+hvO/w+T79X5j1WTI=
X-Received: by 2002:a67:c297:0:b0:3fe:5a64:f8ea with SMTP id
 k23-20020a67c297000000b003fe5a64f8eamr2935530vsj.54.1676050010233; Fri, 10
 Feb 2023 09:26:50 -0800 (PST)
MIME-Version: 1.0
References: <20230207143337.2126678-1-jani.nikula@intel.com>
In-Reply-To: <20230207143337.2126678-1-jani.nikula@intel.com>
From:   jim.cromie@gmail.com
Date:   Fri, 10 Feb 2023 10:26:24 -0700
Message-ID: <CAJfuBxyY94QXwTU2EEHuieQDi8WuMPLkjHJnbUuhcO4PsPC1sw@mail.gmail.com>
Subject: Re: [PATCH] drm: Disable dynamic debug as broken
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 7, 2023 at 10:21 AM Jani Nikula <jani.nikula@intel.com> wrote:
>
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> CONFIG_DRM_USE_DYNAMIC_DEBUG breaks debug prints for (at least modular)
> drm drivers. The debug prints can be reinstated by manually frobbing
> /sys/module/drm/parameters/debug after the fact, but at that point the
> damage is done and all debugs from driver probe are lost. This makes
> drivers totally undebuggable.
>
> There's a more complete fix in progress [1], with further details, but
> we need this fixed in stable kernels. Mark the feature as broken and
> disable it by default, with hopes distros follow suit and disable it as
> well.
>
> [1] https://lore.kernel.org/r/20230125203743.564009-1-jim.cromie@gmail.co=
m
>
> Fixes: 84ec67288c10 ("drm_print: wrap drm_*_dbg in dyndbg descriptor fact=
ory macro")
> Cc: Jim Cromie <jim.cromie@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v6.1+
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  drivers/gpu/drm/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index f42d4c6a19f2..dc0f94f02a82 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -52,7 +52,8 @@ config DRM_DEBUG_MM
>
>  config DRM_USE_DYNAMIC_DEBUG
>         bool "use dynamic debug to implement drm.debug"
> -       default y
> +       default n
> +       depends on BROKEN
>         depends on DRM
>         depends on DYNAMIC_DEBUG || DYNAMIC_DEBUG_CORE
>         depends on JUMP_LABEL
> --
> 2.34.1
>

Acked-by: Jim Cromie <jim.cromie@gmail.com>
