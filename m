Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CE15978F3
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 23:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbiHQVdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 17:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiHQVdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 17:33:49 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766A6474E0
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 14:33:47 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y3so19150637eda.6
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 14:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=94gUzjOftxCMJ+JIYtFblUNLRM88g6BBBVb7IswffX8=;
        b=j3YieT+csCZ4mImqO6w0ux8pucKxvs/DPFIGs6m3BgFPCCPj7OHktLLlz4bHFUDJA0
         pTL5qOouYfsYuOFKo7QLF7qMaEOnJU+0wgI3DBI6bDepzCg6klzsyh8wcQLKmn3NuTs1
         00up9knVQXNsnG1I2M0K6spESqJj2lppIn3Ng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=94gUzjOftxCMJ+JIYtFblUNLRM88g6BBBVb7IswffX8=;
        b=Bmg0D6/1LNmM0BzmIP2vyJOEph+F5dKAd8AKbQIeRNlEg4Ns3lYbY/9H2Vlz/AehRS
         zs0WAwLD6+aQ1CKtdhW5QpuCK60c/NoXpuNzlaHNEGjhwb1dScn2eW1ZDHHkLNrYJmRE
         y3jasru9NOgEGzQ1bblc1Gxhyp3Zt3hkx5gXkR6AZyfa4+4N/iiS2LLf5ZUN2d1jh2bK
         H0nU3kX5Idw3pU2p5ykZI87LWl9NaciwtuVbkGwBi5C7j/A91PO9qHuKXkvbvL8KvjrI
         l7QsjOmLAM0D97dv7QbWd2gT/+iRWbchJofrv+Eu626+9PkG5XuRmRCE9p7KsiAbu9qN
         DksQ==
X-Gm-Message-State: ACgBeo3TTYbhXHhtT+0f569BmwcTqcI68Rqd/iC5eLa0acEW3iGhG6TZ
        QGGdg3k/q3TmjrVYmwob5wW+7N83G7yRneHw
X-Google-Smtp-Source: AA6agR4ejKDo4OommGdxNzJT3FnyxQ91CbWPP6OefUELgN5bprj71zpDHGvLgLz2YWNyiDrrtZ6Xiw==
X-Received: by 2002:a05:6402:530c:b0:43b:c6bf:a496 with SMTP id eo12-20020a056402530c00b0043bc6bfa496mr24944edb.282.1660772025742;
        Wed, 17 Aug 2022 14:33:45 -0700 (PDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id h17-20020a056402095100b0043aba618bf6sm11491688edz.80.2022.08.17.14.33.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 14:33:45 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id p12-20020a7bcc8c000000b003a5360f218fso1656284wma.3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 14:33:45 -0700 (PDT)
X-Received: by 2002:a05:600c:42c3:b0:3a6:431:91bf with SMTP id
 j3-20020a05600c42c300b003a6043191bfmr3065469wme.188.1660772024757; Wed, 17
 Aug 2022 14:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220815180429.240518113@linuxfoundation.org> <20220815180442.585574345@linuxfoundation.org>
In-Reply-To: <20220815180442.585574345@linuxfoundation.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 17 Aug 2022 14:33:32 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UK3Oyb9N9TpDqa55VEukhkjL1+GRO8+yLVxdFMuE=Mrw@mail.gmail.com>
Message-ID: <CAD=FV=UK3Oyb9N9TpDqa55VEukhkjL1+GRO8+yLVxdFMuE=Mrw@mail.gmail.com>
Subject: Re: [PATCH 5.18 0309/1095] drm/panel: Fix build error when
 CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>,
        Gao Chao <gaochao49@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Aug 15, 2022 at 12:09 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Gao Chao <gaochao49@huawei.com>
>
> [ Upstream commit a67664860f7833015a683ea295f7c79ac2901332 ]
>
> If CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m,
> bulding fails:
>
> drivers/gpu/drm/panel/panel-samsung-atna33xc20.o: In function `atana33xc20_probe':
> panel-samsung-atna33xc20.c:(.text+0x744): undefined reference to
>  `drm_panel_dp_aux_backlight'
> make: *** [vmlinux] Error 1
>
> Let CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20 select DRM_DISPLAY_DP_HELPER and
> CONFIG_DRM_DISPLAY_HELPER to fix this error.
>
> Fixes: 32ce3b320343 ("drm/panel: atna33xc20: Introduce the Samsung ATNA33XC20 panel")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Gao Chao <gaochao49@huawei.com>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20220524024551.539-1-gaochao49@huawei.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/panel/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)

While it doesn't hurt to land this patch as-is on 5.18 and older
kernels, it's not quite right. The symbols that this patch 'select'
don't actually exist on 5.18. ;-) Doing a `git grep` of
`DRM_DISPLAY_DP_HELPER` shows no hits except the one introduced in
this patch...

If you want the equivalent fix for v5.18 and older, I believe you'd want:

select DRM_DP_HELPER
select DRM_KMS_HELPER

See commit 3755d35ee1d2 ("drm/panel: Select DRM_DP_HELPER for
DRM_PANEL_EDP") and commit 3c3384050d68 ("drm: Don't make
DRM_PANEL_BRIDGE dependent on DRM_KMS_HELPERS") which added those for
the (very similar) panel-edp.

The first of those is what got changed in v5.19 in commit 1e0f66420b13
("drm/display: Introduce a DRM display-helper module")

So I guess the tl;dr:

* If you leave this patch in 5.18 (and 5.15), nothing bad will happen
but the broken "randconfig" won't be fixed.

* If you revert this patch in 5.18 (and 5.15) also nothing bad will
happen but also the broken "randconfig" won't be fixed.

* If someone cares about the randconfig on 5.15 / 5.18, we need a
backport that adapts what's selected to the old symbol names.
