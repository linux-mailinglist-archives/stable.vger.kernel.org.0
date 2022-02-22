Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03DA4C045F
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 23:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbiBVWKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 17:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236006AbiBVWKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 17:10:48 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5E212D237
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 14:10:22 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id i11so38630089eda.9
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 14:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MwFKzwhh8vOvVeS07pTWz4ZTdQ5Z+NLOUhpyVBv4D9Q=;
        b=O/jITcbrb5aoH7sPwYaBWxEd+YJ1x5KXbkQkrtCB64fkBBeXrwXPwYjpNDLLVqLhLE
         6P0xsF4mDd7F1fKigupRlFmDpfR0WeyGmbS0FOt+X0dNG1Hek8yTglcMvfFxiWjE0hib
         JI1CvKC/XX+jb6fFHdB6lGrJYWiPMqlROrssQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MwFKzwhh8vOvVeS07pTWz4ZTdQ5Z+NLOUhpyVBv4D9Q=;
        b=XNYhF8+I6U0t+1MkZVzL7IPzFVAwzjyWgbcH1LnVBoZroJxKdbFk3zzItkvsMZGcV8
         +EOZ8O9sQEBiLTxI5WXw1gmMfYAZsf3vM6daBsPkPEzCXXaT250qHYcGK4X5IMpO5mVq
         Ny0qcEAa6+66s4qANJIEw8M7XK+yQ8dYY9Iml3qIs6yMQ4/7ERQiAugnIR3mddGdxSJN
         XUq22lc3+iI6D7nIlqVRCRUpkvv7jG4bKheCKQ+4XSSWozC6PSYc6ij0UHHOQ1Dl4CjH
         ELvj845T7N07NhbxgBk1m5DFTA7YROaXjKZ0a7BSJ52rP2ZVkWtK1jP82Kk7q2uWiCgm
         1Wow==
X-Gm-Message-State: AOAM533tFBSz7rtoLvHhQTXPdzU/FMjySII77kAF1ElzInDx5XRj+zCe
        mmJLqxhazQ40v9tvgD6R5IcxtH7KVmcSHER0jcc=
X-Google-Smtp-Source: ABdhPJyKpSgl1kLtW4OtEPEQGDJN8KNgVO8m24bHC4hG8fAuWl7DMwL8x9SnLguc4eVMd9ZqFuVQdQ==
X-Received: by 2002:a05:6402:424b:b0:410:92aa:30b1 with SMTP id g11-20020a056402424b00b0041092aa30b1mr28512323edb.297.1645567820345;
        Tue, 22 Feb 2022 14:10:20 -0800 (PST)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id m4sm6780138ejl.45.2022.02.22.14.10.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 14:10:19 -0800 (PST)
Received: by mail-wm1-f54.google.com with SMTP id i19so12485137wmq.5
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 14:10:18 -0800 (PST)
X-Received: by 2002:a05:600c:228e:b0:37c:2eef:7bf with SMTP id
 14-20020a05600c228e00b0037c2eef07bfmr4903688wmf.73.1645567818110; Tue, 22 Feb
 2022 14:10:18 -0800 (PST)
MIME-Version: 1.0
References: <20220217144136.v3.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
In-Reply-To: <20220217144136.v3.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 22 Feb 2022 14:10:04 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XmqG13QuyxpcS9sN2UCtPWDyhD_T1xjkDf8tp-_bSOWw@mail.gmail.com>
Message-ID: <CAD=FV=XmqG13QuyxpcS9sN2UCtPWDyhD_T1xjkDf8tp-_bSOWw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] drm/bridge: analogix_dp: Grab runtime PM reference
 for DP-AUX
To:     Brian Norris <briannorris@chromium.org>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Sean Paul <sean@poorly.run>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        "# 4.0+" <stable@vger.kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Feb 17, 2022 at 2:42 PM Brian Norris <briannorris@chromium.org> wrote:
>
> If the display is not enable()d, then we aren't holding a runtime PM
> reference here. Thus, it's easy to accidentally cause a hang, if user
> space is poking around at /dev/drm_dp_aux0 at the "wrong" time.
>
> Let's get a runtime PM reference, and check that we "see" the panel.
> Don't force any panel power-up, etc., because that can be intrusive, and
> that's not what other drivers do (see
> drivers/gpu/drm/bridge/ti-sn65dsi86.c and
> drivers/gpu/drm/bridge/parade-ps8640.c.)
>
> Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
> Cc: <stable@vger.kernel.org>
> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>
> Changes in v3:
> - Avoid panel power-up; just check for HPD state, and let the rest
>   happen "as-is" (e.g., time out, if the caller hasn't prepared things
>   properly)
>
> Changes in v2:
> - Fix spelling in Subject
> - DRM_DEV_ERROR() -> drm_err()
> - Propagate errors from un-analogix_dp_prepare_panel()
>
>  drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>


-Doug
