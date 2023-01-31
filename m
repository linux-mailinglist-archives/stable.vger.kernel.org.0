Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E6C68378A
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 21:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjAaU3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 15:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjAaU3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 15:29:17 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50D9CC38;
        Tue, 31 Jan 2023 12:29:16 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id r205so13881552oib.9;
        Tue, 31 Jan 2023 12:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JyJiFrqlivKEOyPItCa/SIst048Kihh8brktiCySABY=;
        b=nT4rh+4mNbrdzN78oDtmdY0IN+QTuwS3kW/OZkUARoYNmPa0+FGxN0vfl0KGlLU26t
         8xReagXvODlDwloR3rSYisE5btbXbHKkeWRI8ZkTW0W9vHX5kkqgUJjkkavaueCquDzX
         nlPEaJKoCYBSI3q3ugUQGP5jOCvGtTVs52HF02X5R6dLl9OY2HheAF89CrOCuADOR5aM
         a2MVgUShq6E25OfanBZ8GBUvT4MRaW8xB2GgsF/RLxjCMnmmZbj61iKiQjiDOYzHg4uS
         TlPAKAHRwm75Yv/MGOdQ+mjUTflvlGldxld24R6INhB0ugVGNHjO2vJcGJNw1x9AJiQt
         T4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JyJiFrqlivKEOyPItCa/SIst048Kihh8brktiCySABY=;
        b=7dcfSuHdEwlZLX1h6om4EAzJDb+euB1KvLcno34rkRVFChGPJqaC7bZTTFU57FUD7F
         qraEuqW0SJhv6bJZiTQXfObO/jxuEX7ayzBMpQkzkCm2Nhil8AmwwLtpcwWpXlhW6w+4
         q6kZb3lEaot+x2eKtKzc+srMbHVRFM6+PA/Cv4o/p7yo06bOSsX5Kl1Qp7lPz7tpdBWj
         mPziRxB5DgEj/ZHpKFxbcmxQ2wqcGPYI8dsoQzcq65tBbqS634WFOsuG9TUgf+PqpwP5
         5BCamJnIrmioB8ZqYBMfYkH1e+tCqeJwyCKXfv57eqhYwoGY8VVCmwfzxwKPuAjxvQh4
         zneA==
X-Gm-Message-State: AO0yUKWlpZMZON0dx7Omje0VkrjmpJKxagKRx/UHeXRNePcCWuzoTGvP
        YxF1jsgo53pNOMaXi/h9XBH6+Ayuilwcx9mKIxw=
X-Google-Smtp-Source: AK7set8N4CZbnT/X3wmWeb1Es9Kzep/A3FY6oNiN6/fN0DvjQS2PcqSJv0WE9M0vC3XgSxJ0cGKwL719RAMd8+Zk0Ag=
X-Received: by 2002:a05:6808:2394:b0:378:4edd:a89c with SMTP id
 bp20-20020a056808239400b003784edda89cmr6481oib.46.1675196956046; Tue, 31 Jan
 2023 12:29:16 -0800 (PST)
MIME-Version: 1.0
References: <20230131150030.1250104-1-sashal@kernel.org> <20230131150030.1250104-12-sashal@kernel.org>
In-Reply-To: <20230131150030.1250104-12-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 31 Jan 2023 15:29:04 -0500
Message-ID: <CADnq5_M=WvEf6N9my2cjX1=aQdweKfrshyU+Q8Ohuo5=DBtf+w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.15 12/12] amdgpu: fix build on non-DCN platforms.
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stylon.wang@amd.com, sunpeng.li@amd.com, Xinhui.Pan@amd.com,
        Rodrigo.Siqueira@amd.com, roman.li@amd.com,
        amd-gfx@lists.freedesktop.org, Jerry.Zuo@amd.com,
        aurabindo.pillai@amd.com, dri-devel@lists.freedesktop.org,
        alexander.deucher@amd.com, Dave Airlie <airlied@redhat.com>,
        christian.koenig@amd.com
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

On Tue, Jan 31, 2023 at 10:01 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Dave Airlie <airlied@redhat.com>
>
> [ Upstream commit f439a959dcfb6b39d6fd4b85ca1110a1d1de1587 ]
>
> This fixes the build here locally on my 32-bit arm build.
>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch is only applicable to kernel 6.1 and newer.

Alex


> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index ee238a16572e..0f0dd9b0d84a 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -10769,6 +10769,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
>         bool lock_and_validation_needed = false;
>         struct dm_crtc_state *dm_old_crtc_state;
>  #if defined(CONFIG_DRM_AMD_DC_DCN)
> +       struct drm_dp_mst_topology_mgr *mgr;
> +       struct drm_dp_mst_topology_state *mst_state;
>         struct dsc_mst_fairness_vars vars[MAX_PIPES];
>  #endif
>
> --
> 2.39.0
>
