Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE686431F0D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhJROMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhJROMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 10:12:51 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3BFC0613A8
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 06:36:22 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so85294otb.1
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 06:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJQ4Hx6igR/GK+gKVlCduHCVPYYZDLUizkAUlSuP4Lk=;
        b=FG2ntu2KHHHpADfFwvbsaEHnbsT7gxuPeZDhodr2kimzX3YNmV+CU22s6YDW7wMwCk
         mOi5Q4LJxZkPEbvSWy9RKsOGM2+BNPfQVHVM5opbRiDBpRCUOMMcPVegb2aBrNbrgdmi
         B+tc8eW/ufhU+JKS+aobKKC1P1f71zBfqnbLANIrxj3mEmSVYENsg6BwFX0zqIqJ6KMX
         +XPbqUQyxRVCQn59FUSaDGhGNjWBTjf91rSCr3YJ84Ah1ewz0uLY9k+M/cNEAU0im7ek
         yhSuN36+YilkU8MRVqOapsg+Yga0YNp+olslZmshHprY/JL668Qigg9uRYr9Y+tygLbt
         ZlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJQ4Hx6igR/GK+gKVlCduHCVPYYZDLUizkAUlSuP4Lk=;
        b=b927qXyuO5urPdKTqCxEP8xr95KOi6T41usv5O0z79UWLPZQRYbB9xP/gO11erknDf
         f1W28XYq8grh8ffJmTAH9LWC0N2rzejR6rPL0Zn9We07O94aLpmIqGgVIweLkpmQzCee
         82Dm+b7/rTd16LhJ/1lqe6wplemcIgjQG98vB5KN119lKchl7zA1auCtZDpUcLXMA5uP
         upi2YyFu6waLcFCpNXZnV9cldNF9gmt/DCN3H0OsIl5i4z7KwEYS7aMWKy74EC/3pyaB
         zU8J+kR3ZqGcb3C4RxUctXquqhN/RBRo8YX0w31EwpXkU9EPuh7IPk//3yLz429HghGg
         7UEA==
X-Gm-Message-State: AOAM5330UAq3rlqZK4HLwvM39Kx8+saI+i9GF5Ycm+5iC3lq7k4spu1C
        SU8TPHjAPdIOixeW1Ib5qmLMTuAfqBg3jfegfSs=
X-Google-Smtp-Source: ABdhPJy5ETyCXd2L1tAxnsUPKzsSn8l88O5wbo8x1aTTt/eKq95Kai6t4ZWLsdntz2Igzr6DxE1e4GxDyiBA8Z9ISH0=
X-Received: by 2002:a05:6830:23ac:: with SMTP id m12mr22401395ots.357.1634564181512;
 Mon, 18 Oct 2021 06:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
In-Reply-To: <1634337100-12682-1-git-send-email-Roman.Li@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 18 Oct 2021 09:36:10 -0400
Message-ID: <CADnq5_PqKjh7dZoAf9B428pYFG-amOFADeYqZR=McB37Avv3FQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Fully switch to dmub for all dcn21 asics
To:     Roman Li <Roman.Li@amd.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        "Siqueira, Rodrigo" <rodrigo.siqueira@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 15, 2021 at 6:33 PM <Roman.Li@amd.com> wrote:
>
> From: Roman Li <Roman.Li@amd.com>
>
> [Why]
> On renoir usb-c port stops functioning on resume after f/w update.
> New dmub firmware caused regression due to conflict with dmcu.
> With new dmub f/w dmcu is superseded and should be disabled.
>
> [How]
> - Disable dmcu for all dcn21.
>
> Check dmesg for dmub f/w version.
> The old firmware (before regression):
> [drm] DMUB hardware initialized: version=0x00000001
> All other versions require that patch for renoir.
>
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
> Cc: stable@vger.kernel.org
> Signed-off-by: Roman Li <Roman.Li@amd.com>

Acked-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index ff54550..e56f73e 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -1356,8 +1356,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>                 switch (adev->ip_versions[DCE_HWIP][0]) {
>                 case IP_VERSION(2, 1, 0):
>                         init_data.flags.gpu_vm_support = true;
> -                       if (ASICREV_IS_GREEN_SARDINE(adev->external_rev_id))
> -                               init_data.flags.disable_dmcu = true;
> +                       init_data.flags.disable_dmcu = true;
>                         break;
>                 case IP_VERSION(1, 0, 0):
>                 case IP_VERSION(1, 0, 1):
> --
> 2.7.4
>
