Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18576986B1
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBOU6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjBOU6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:58:34 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E543253543;
        Wed, 15 Feb 2023 12:55:53 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id c15so16992544oic.8;
        Wed, 15 Feb 2023 12:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zmbh1f8KIAJa4cfe7gLSSbxP1FhhqTnT01uu/QY3KeI=;
        b=bPW9aaLh1JaW0780UTgBkKiZwSdh4bZKO9tcXjlNHjGyhyih6rrW2OiaGWHn9GGrzo
         g4u2uJkYpOenZCoRHvtM+r1WPAg4N9NoB7sQIp2XXtNPsbBo6L2tyP/gIKtnULWcj0kf
         bxhhlMkvfKJg3kel4LDav48JbtUKK/hR2DAdP9dDCXcjHFgUz9WyPcWUCt0F8RQgZD7a
         FpP0MRSXQ262bYC2J63HxT5FAaeErd6fo3WKRaqw+8bWeLeBoNqfRbHdqL008vBqRbhy
         PnJpD2z6IEZ3fKibiG7042N+GjXjdDa9K3ax4VSAACfC702VSwGtsMma35HmfEIg17u5
         6NWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zmbh1f8KIAJa4cfe7gLSSbxP1FhhqTnT01uu/QY3KeI=;
        b=Wn5EmuWZ47keMyA3AoyWFMwlUFNWycPlbfyXNfhsMlI1AjD+3fG2ocx7cVUrWK1iEh
         FF9Dl9jTCVR8r7oFhbQ4rxIVV+jOSL0txIVv/JqzXUwolmSreeqU5KgSVmvI2ll05cBa
         9qXKv2kKsGn8vLs5jz2BzjZdvPraQwDIavrpQ7noNw/sap/QRalGUTVvwnix/Wt8R3EK
         5XAoJUQg9Z3rbojnZe6ITHQO7/JGmvokv83SCBM3c+RdRmWcKjCkugb/1xzcVbv/pWdz
         GgeNYRioC0QRKvgHGzRBpkZdrydS1MRpnJzJGO/Jdp1WLSnlRFEM0OwsAQGln9S2xmvZ
         HAhw==
X-Gm-Message-State: AO0yUKXYIDeGQsBuxwjmlzLp/KiEw6kze5yww1IyiKEOpULqrjMLSaLm
        T1JXGhIdcTjTEjol4gcwD6FAc2yfC+vqOD8sISE=
X-Google-Smtp-Source: AK7set8ABtTTUiS8oZK3RlDNhc5D2N8SMW1l2Ck93cqJrlRu9e68Rq3rGmBhaheeQUX2zCR4+IThgziKrKlEI8GPdmo=
X-Received: by 2002:a05:6808:1b09:b0:35b:d93f:cbc4 with SMTP id
 bx9-20020a0568081b0900b0035bd93fcbc4mr56498oib.96.1676494518455; Wed, 15 Feb
 2023 12:55:18 -0800 (PST)
MIME-Version: 1.0
References: <20230215204547.2760761-1-sashal@kernel.org> <20230215204547.2760761-24-sashal@kernel.org>
In-Reply-To: <20230215204547.2760761-24-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 15 Feb 2023 15:55:07 -0500
Message-ID: <CADnq5_PEGUSTFAzPOQtJFpsBqWQMaox=E1AxE+-h3_FxSbHNzg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.1 24/24] drm/amd/display: disable S/G display on
 DCN 3.1.2/3
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yifan1.zhang@amd.com, stylon.wang@amd.com, sunpeng.li@amd.com,
        airlied@gmail.com, Xinhui.Pan@amd.com, Rodrigo.Siqueira@amd.com,
        roman.li@amd.com, amd-gfx@lists.freedesktop.org, Jerry.Zuo@amd.com,
        aurabindo.pillai@amd.com, dri-devel@lists.freedesktop.org,
        daniel@ffwll.ch, Alex Deucher <alexander.deucher@amd.com>,
        harry.wentland@amd.com, christian.koenig@amd.com
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

On Wed, Feb 15, 2023 at 3:46 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Alex Deucher <alexander.deucher@amd.com>
>
> [ Upstream commit 077e9659581acab70f2dcc04b5bc799aca3a056b ]
>
> Causes flickering or white screens in some configurations.
> Disable it for now until we can fix the issue.
>
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2352
> Cc: roman.li@amd.com
> Cc: yifan1.zhang@amd.com
> Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This was reverted upstream and should be dropped.

Alex

> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 988b1c947aefc..c026ba532b733 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -1524,8 +1524,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>                         break;
>                 case IP_VERSION(2, 1, 0):
>                 case IP_VERSION(3, 0, 1):
> -               case IP_VERSION(3, 1, 2):
> -               case IP_VERSION(3, 1, 3):
>                 case IP_VERSION(3, 1, 6):
>                         init_data.flags.gpu_vm_support = true;
>                         break;
> --
> 2.39.0
>
