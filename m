Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC67485991
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 20:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243773AbiAETzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 14:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243769AbiAETza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 14:55:30 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACCCC061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 11:55:30 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id u21so501526oie.10
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 11:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JlPJsMW5yVPe7P3RKOvMwPlqeJN1/Nu2FfKIApHsgbo=;
        b=DwPxC3cLLNM8XVTzd55gQ7bhxNML705Ttl/ErwNTDEyJwlW4XJMuoiodES7QQ//mSL
         NqvSpNl3q6yIa44pWFb8gv6RfQh9JDnxYAV18DuYJc10XKzkRm4oMwtHC9HPCapN6hMm
         iqc0/E4iLeL6kOCUEBwGPMA/dnUvUs7BdnY/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JlPJsMW5yVPe7P3RKOvMwPlqeJN1/Nu2FfKIApHsgbo=;
        b=mKq8cjFL40PWf3wQ/kCll9HEjTOQuOnTnqrwqi2F4ttotaXXQIpDEdv8KmGa3YwZjX
         cEfDB6s06QGS/dfsLTGZiU/l/KqGF14J5/YdMUL6QsgFI2yr51+uf9xqWyi3NUt4fSOR
         1IXS2m1hmnToV9zcNm8mZ4uy49VZwWxADQhA6JvrRbnQlJmCbxfHxrBQxAraXR7GMOO5
         qN9uQeItYvzLSGty/g5v6dyVmXh1CKLjwQ0g/RABwpGGvm15w7sJwXL6cDYxvK4to9g+
         zu+oX82sPxjMzjVlI3A9329mRpSFT56l8S1sTvUsAvKrEIAHm6drNXthDmGN46Xf5PKO
         yplA==
X-Gm-Message-State: AOAM530dExc946c9QnZgGT494cqZGdY3FtpRxTsUuzRVNxxx5tpkeEbz
        FpCKuMbnVk538qde7ONPGGJbfcKnEyHS1Q==
X-Google-Smtp-Source: ABdhPJwzquTbuOen7NG7m41RBDOPWE2Kmbi23AXIFDoRE0S7lreMIm2C1J50ltf2xiV/Atl8agLQhQ==
X-Received: by 2002:a05:6808:1454:: with SMTP id x20mr3840998oiv.166.1641412528820;
        Wed, 05 Jan 2022 11:55:28 -0800 (PST)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com. [209.85.167.177])
        by smtp.gmail.com with ESMTPSA id bh12sm10726995oib.25.2022.01.05.11.55.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 11:55:27 -0800 (PST)
Received: by mail-oi1-f177.google.com with SMTP id t23so562391oiw.3
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 11:55:27 -0800 (PST)
X-Received: by 2002:a05:6808:3097:: with SMTP id bl23mr3823157oib.77.1641412527103;
 Wed, 05 Jan 2022 11:55:27 -0800 (PST)
MIME-Version: 1.0
References: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
In-Reply-To: <20211001144212.v2.1.I773a08785666ebb236917b0c8e6c05e3de471e75@changeid>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 5 Jan 2022 11:55:05 -0800
X-Gmail-Original-Message-ID: <CA+ASDXOEv3xigBaEwtYcGM7Q9uNHrwijoWTHoiLg--UT=vA7TA@mail.gmail.com>
Message-ID: <CA+ASDXOEv3xigBaEwtYcGM7Q9uNHrwijoWTHoiLg--UT=vA7TA@mail.gmail.com>
Subject: Re: [PATCH v2] drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX
To:     Neil Armstrong <narmstrong@baylibre.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Sean Paul <sean@poorly.run>, Jonas Karlman <jonas@kwiboo.se>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        stable <stable@vger.kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(updating Andrzej's email)

On Fri, Oct 1, 2021 at 2:50 PM Brian Norris <briannorris@chromium.org> wrote:
> If the display is not enable()d, then we aren't holding a runtime PM
> reference here. Thus, it's easy to accidentally cause a hang, if user
> space is poking around at /dev/drm_dp_aux0 at the "wrong" time.
>
> Let's get the panel and PM state right before trying to talk AUX.
>
> Fixes: 0d97ad03f422 ("drm/bridge: analogix_dp: Remove duplicated code")
> Cc: <stable@vger.kernel.org>
> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>
> Changes in v2:
> - Fix spelling in Subject
> - DRM_DEV_ERROR() -> drm_err()
> - Propagate errors from un-analogix_dp_prepare_panel()
>
>  .../drm/bridge/analogix/analogix_dp_core.c    | 21 ++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)

Ping? Do I need to do anything more here?

Thanks,
Brian
