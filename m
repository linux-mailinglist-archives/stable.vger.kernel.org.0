Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DE93F8023
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 04:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhHZCBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 22:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbhHZCBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 22:01:47 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672DBC061757
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 19:01:01 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id a20-20020a0568300b9400b0051b8ca82dfcso1502818otv.3
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 19:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xr0W1stXhFhWBL3p+UuCXAhcOcwmdg8NiHE8AWT2uSY=;
        b=HaprRiAWgt2MViijqA65Votrp2cq7mKQL06fu4RYhzwy4Gxue92bajdwNzHWfmUTOj
         xh1ff96j1Z9FJ0T5oGi2FnKus3uBoa61NUuUnOUs144jPlE8JJoMXN/goGP0HXmw4nzZ
         LFvbbOP/Sa/cTr69gdMdD99TfHsGLSQpUz9pGgtIoaFeU/rT5AinfxB6s44vE3RMbhLl
         weM0vLZ626QcBtITQjiGe79oCZs8wbHFM33SNBZ1i2zRElOQS9rZnD2l4fNMsC/g7VC/
         xbsCEOIm0b2oTHSijGAeUPSFms7Wgujab+sIylHcQNCoR9HI6KfJxEtC9hAgk7jquH8e
         NeqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xr0W1stXhFhWBL3p+UuCXAhcOcwmdg8NiHE8AWT2uSY=;
        b=ZKi8Z6vnJt3TbhEcuLvjJbFozBbCMkJJZ/kXIx20n6b34XL4iZqvgWOxUYLJiNHIfw
         1oSILmYZPXYa2Ug3RDkvBSsq8v1GVEOj6tJNCO/7SLAxEmjaFVdjSZ+knnFlY/gGnDhi
         kk5iin+UDqwlUb9aoHTjvoV+uihjSJELwcFfwMAWsrqQ/NbhQccdv4ywaXhIk8Jyw157
         xXV8Eeu088kLzsABm5Kr8gmRQfVKV2qNpAqqPCHuk0tk2bldw+kCGn+7HU60+YV60uXR
         4WClsN7AagT1Z5+xyp6CLmmOTL+T5mdToaQ/kS12nRsPoiNzTlIX1NbzciErrQPId0Z2
         9Low==
X-Gm-Message-State: AOAM530A/6L9t/5BpVRYOOt9tODT2nhVHbtUQGc2FOoCT+TxIVqvHQ+y
        9VzaE/YGPML+0YxUPsQDVB45BdLTpHez/rXPqmYiuO+tX+8=
X-Google-Smtp-Source: ABdhPJw4+DhN0LbPsAOfQArDqaUPwfIKYMO22ai3oGln7rX75UOVMMlONSM4q9tmXUZrvegfN6RPecruzpL42uoIyQA=
X-Received: by 2002:a9d:4c15:: with SMTP id l21mr1097224otf.311.1629943260680;
 Wed, 25 Aug 2021 19:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210826011002.425361-1-aurabindo.pillai@amd.com>
In-Reply-To: <20210826011002.425361-1-aurabindo.pillai@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 25 Aug 2021 22:00:49 -0400
Message-ID: <CADnq5_M+THmHo_-ti=or18cRvBuExdiNcXybVLcVRj2_KfsBuw@mail.gmail.com>
Subject: Re: [PATCH 1/4] drm/amd/display: Update number of DCN3 clock states
To:     Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Kazlauskas, Nicholas" <nicholas.kazlauskas@amd.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 9:10 PM Aurabindo Pillai
<aurabindo.pillai@amd.com> wrote:
>
> [Why & How]
> The DCN3 SoC parameter num_states was calculated but not saved into the
> object.
>
> Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
> Cc: stable@vger.kernel.org

Please add:
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1403
to the series.  With that fixed, series is:
Acked-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
> index 1333f0541f1b..43ac6f42dd80 100644
> --- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
> +++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
> @@ -2467,6 +2467,7 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
>                         dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
>                 }
>
> +               dcn3_0_soc.num_states = num_states;
>                 for (i = 0; i < dcn3_0_soc.num_states; i++) {
>                         dcn3_0_soc.clock_limits[i].state = i;
>                         dcn3_0_soc.clock_limits[i].dcfclk_mhz = dcfclk_mhz[i];
> --
> 2.30.2
>
