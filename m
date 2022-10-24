Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E3C60B606
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiJXSqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiJXSqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:46:02 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF84BFF273;
        Mon, 24 Oct 2022 10:27:33 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-13ba86b5ac0so4025846fac.1;
        Mon, 24 Oct 2022 10:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xxzTjIKoWHzpXZkE15ZuSeCbJ7LXx6Uum8mVewcZBOg=;
        b=QAaRuGQ0VAKcMbmNeXi3Y+/OCrDNO4s8VSnES3ODLjDqJ1JAUFaCG3GiIn5a/T2eQm
         N7kqAThx3S2sj1FmZY1Rm3YK1l9g1ES2kCzYXI6zD3ruz/URkeFnqyHJL9pUA/fiLJgM
         fWOAwU9bpjNOgRX6Ziz+0SsSvTpZcbZX25WAbb2dk8Q8megbzYTnQSgUTp1T5Nu6ElJ1
         1NPRMVZEfOCNtT5n8ZT9Hd9rlkDwZWiaR2iE5Tau3ik4rXankzq5eWcU7vuOSUmb2lqV
         hzIiVE2V+BrJnM4Tj4QbywtIOnQk31q+Njl6uxbr86pGLQvZzfoIqw1k0jbwPRWzbPIe
         Mxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xxzTjIKoWHzpXZkE15ZuSeCbJ7LXx6Uum8mVewcZBOg=;
        b=DlEu/pfaf9GnRCRp/FuqBiuNO2qs9EJC+NWDmAk7eg4Sy1KlEtWQ740nTIBxWiqvH5
         i8dPlFuP1sNa7U9xkPJ1wKPlvwHqZZQ9MdR0VNPA+CQ9HUgzqvPPZ9hr8EIKu6FdPT8W
         jd3SJmWBUgbW3BGZcp+OhHzn5yqqCI4ws/XtXmZmi9lOD8cRRLFvim9/K9Sirek49P4Y
         wdHz2ycZnQ7xuf1+Kj9q2DMLWbbkCCukJru6SrUB6NftK+UdGjxhYhN7cX0wL6BXz39+
         KjXUjFyvwgsqhskmY4CEMhjEgPWl2kE6n1IKM/KrnwEtjMhYQzby5DQGwvw4KtT4GQwL
         1JAw==
X-Gm-Message-State: ACrzQf0UEMplLrbfvG+M+hIzkJywNY5KKWnLymPZd6cC3OSGgSEgTwv7
        7UUQ/Gz7zRg9vjFJ0roOydBTHWzsHMeLJT3vS7yIcN2s
X-Google-Smtp-Source: AMsMyM7GsGsatWsLnXjmC7Huhqtn92xonppGcoyhsKjpgrd1gtKinzghr4K/o04hp5qNLGmswJyf0DHSLoZsyG2VbDk=
X-Received: by 2002:a05:6870:a7a4:b0:136:7c39:979e with SMTP id
 x36-20020a056870a7a400b001367c39979emr21199731oao.96.1666631627779; Mon, 24
 Oct 2022 10:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAP+8YyFUoFhh1+CEKrs48JV5CiorSSfe6qg90TyUrDoBtzcPhA@mail.gmail.com>
 <20221024113359.5575-1-samsagax@gmail.com>
In-Reply-To: <20221024113359.5575-1-samsagax@gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 24 Oct 2022 13:13:36 -0400
Message-ID: <CADnq5_NKOn1BuTfrmyJNwwE_Owy-EAf0khXJ-AbT+5QiR6NuvA@mail.gmail.com>
Subject: Re: [PATCH v2] drm/amd/display: Revert logic for plane modifiers
To:     =?UTF-8?Q?Joaqu=C3=ADn_Ignacio_Aramend=C3=ADa?= 
        <samsagax@gmail.com>
Cc:     bas@basnieuwenhuizen.nl, sunpeng.li@amd.com, Xinhui.Pan@amd.com,
        rodrigo.siqueira@amd.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        alexander.deucher@amd.com, stable@vger.kernel.org,
        christian.koenig@amd.com
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

Applied.  Thanks!

Alex

On Mon, Oct 24, 2022 at 9:17 AM Joaqu=C3=ADn Ignacio Aramend=C3=ADa
<samsagax@gmail.com> wrote:
>
> This file was split in commit 5d945cbcd4b16a29d6470a80dfb19738f9a4319f
> ("drm/amd/display: Create a file dedicated to planes") and the logic in
> dm_plane_format_mod_supported() function got changed by a switch logic.
> That change broke drm_plane modifiers setting on series 5000 APUs
> (tested on OXP mini AMD 5800U and HP Dev One 5850U PRO)
> leading to Gamescope not working as reported on GitHub[1]
>
> To reproduce the issue, enter a TTY and run:
>
> $ gamescope -- vkcube
>
> With said commit applied it will abort. This one restores the old logic,
> fixing the issue that affects Gamescope.
>
> [1](https://github.com/Plagman/gamescope/issues/624)
>
> Cc: <stable@vger.kernel.org> # 6.0.x
> Signed-off-by: Joaqu=C3=ADn Ignacio Aramend=C3=ADa <samsagax@gmail.com>
> Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> ---
> Removed asic_id and excess newlines. Resend with correct Cc line.
> ---
>  .../amd/display/amdgpu_dm/amdgpu_dm_plane.c   | 50 +++----------------
>  1 file changed, 7 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/dr=
ivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
> index dfd3be49eac8..e6854f7270a6 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
> @@ -1369,7 +1369,7 @@ static bool dm_plane_format_mod_supported(struct dr=
m_plane *plane,
>  {
>         struct amdgpu_device *adev =3D drm_to_adev(plane->dev);
>         const struct drm_format_info *info =3D drm_format_info(format);
> -       struct hw_asic_id asic_id =3D adev->dm.dc->ctx->asic_id;
> +       int i;
>
>         enum dm_micro_swizzle microtile =3D modifier_gfx9_swizzle_mode(mo=
difier) & 3;
>
> @@ -1386,49 +1386,13 @@ static bool dm_plane_format_mod_supported(struct =
drm_plane *plane,
>                 return true;
>         }
>
> -       /* check if swizzle mode is supported by this version of DCN */
> -       switch (asic_id.chip_family) {
> -       case FAMILY_SI:
> -       case FAMILY_CI:
> -       case FAMILY_KV:
> -       case FAMILY_CZ:
> -       case FAMILY_VI:
> -               /* asics before AI does not have modifier support */
> -               return false;
> -       case FAMILY_AI:
> -       case FAMILY_RV:
> -       case FAMILY_NV:
> -       case FAMILY_VGH:
> -       case FAMILY_YELLOW_CARP:
> -       case AMDGPU_FAMILY_GC_10_3_6:
> -       case AMDGPU_FAMILY_GC_10_3_7:
> -               switch (AMD_FMT_MOD_GET(TILE, modifier)) {
> -               case AMD_FMT_MOD_TILE_GFX9_64K_R_X:
> -               case AMD_FMT_MOD_TILE_GFX9_64K_D_X:
> -               case AMD_FMT_MOD_TILE_GFX9_64K_S_X:
> -               case AMD_FMT_MOD_TILE_GFX9_64K_D:
> -                       return true;
> -               default:
> -                       return false;
> -               }
> -               break;
> -       case AMDGPU_FAMILY_GC_11_0_0:
> -       case AMDGPU_FAMILY_GC_11_0_1:
> -               switch (AMD_FMT_MOD_GET(TILE, modifier)) {
> -               case AMD_FMT_MOD_TILE_GFX11_256K_R_X:
> -               case AMD_FMT_MOD_TILE_GFX9_64K_R_X:
> -               case AMD_FMT_MOD_TILE_GFX9_64K_D_X:
> -               case AMD_FMT_MOD_TILE_GFX9_64K_S_X:
> -               case AMD_FMT_MOD_TILE_GFX9_64K_D:
> -                       return true;
> -               default:
> -                       return false;
> -               }
> -               break;
> -       default:
> -               ASSERT(0); /* Unknown asic */
> -               break;
> +       /* Check that the modifier is on the list of the plane's supporte=
d modifiers. */
> +       for (i =3D 0; i < plane->modifier_count; i++) {
> +               if (modifier =3D=3D plane->modifiers[i])
> +                       break;
>         }
> +       if (i =3D=3D plane->modifier_count)
> +               return false;
>
>         /*
>          * For D swizzle the canonical modifier depends on the bpp, so ch=
eck
> --
> 2.38.1
>
