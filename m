Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B06419E80
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 20:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbhI0SpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 14:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbhI0SpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 14:45:08 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F45C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 11:43:30 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso25632974otv.12
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 11:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HADnuLjmEAtZ6Adqy4cLTMjazC/sJm6aQiFvmVyyZo4=;
        b=THiCwO7Zruhs5bQqv3BzUlc2PVXfItncfte4Dq3tvyVrPzlN4omD2HJN0zKWLQu7Gq
         2R5/2tJoY80gO09YsafkznMakjhV0PKeqTcfocK6lgX1f5Ak98bouzA6SLA8l+m2Fm87
         jL7k3dh+oKEedYtCK2//ERCD0Et5Oy2spD8tQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HADnuLjmEAtZ6Adqy4cLTMjazC/sJm6aQiFvmVyyZo4=;
        b=Q6EXY36mcsFzTJdrDvEwCDQUql0pg5q4Alj010nJ9FMfYYwF5WLWyKgFwTSAIrGrz/
         ufM9ty/1G5l7W8OQTvJM0Z5g4VBXagxYUMHpNk6PoQoiNdjC9neQcL5Wn6UdmjNXyypn
         zD/OVLbDZf9A1Ez22btS7718QtRkiMFYcH8T3tcS1aWzEJhqy7PBA7jJY84SshQ3vTvz
         TS02ziqCVzoKdpTLSfbJs9kFKGclyEtpBRlric47AbTT9/sZOQTx9K3enkHc/x7GCuTr
         qYGlh6u/J8M7B5eiBt3HXotK7mlPAJ+yFbzno6WA6MQSuF4esH66eAn24QkyxYu49Yu+
         voUQ==
X-Gm-Message-State: AOAM532XmzXVbmTy/XlXISyJnDr+c73nJbjXszPuAxe/gOoaQ4uZc3dl
        HTRdsxCxyvpM/iRFXtmNMHo1x7jmRaP7dQ==
X-Google-Smtp-Source: ABdhPJx9eIjsUNLBka2HG/WxIQ2XwvO+AFtyEzPT++1GdRdLTc42hezhvnz1tSjbTcILYGoDf54EGg==
X-Received: by 2002:a05:6830:4411:: with SMTP id q17mr1288432otv.67.1632768209167;
        Mon, 27 Sep 2021 11:43:29 -0700 (PDT)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com. [209.85.210.41])
        by smtp.gmail.com with ESMTPSA id i24sm1162453oie.42.2021.09.27.11.43.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 11:43:28 -0700 (PDT)
Received: by mail-ot1-f41.google.com with SMTP id d12-20020a05683025cc00b0054d8486c6b8so3679892otu.0
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 11:43:28 -0700 (PDT)
X-Received: by 2002:a05:6830:112:: with SMTP id i18mr1353439otp.186.1632768207428;
 Mon, 27 Sep 2021 11:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210924162321.1.Ic2904d37f30013a7f3d8476203ad3733c186827e@changeid>
 <CAGXv+5Ej=sDXOy1Hg9fQrdxN-OEmxpfUjE8PfxgfBkWu9dvOXQ@mail.gmail.com>
In-Reply-To: <CAGXv+5Ej=sDXOy1Hg9fQrdxN-OEmxpfUjE8PfxgfBkWu9dvOXQ@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 27 Sep 2021 11:43:16 -0700
X-Gmail-Original-Message-ID: <CA+ASDXO4yGRDAH24YygC_utY3xBesLT1VapTibeiCYoH-xoH1Q@mail.gmail.com>
Message-ID: <CA+ASDXO4yGRDAH24YygC_utY3xBesLT1VapTibeiCYoH-xoH1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/rockchip: dsi: hold pm-runtime across bind/unbind
To:     Chen-Yu Tsai <wenst@chromium.org>
Cc:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sandy Huang <hjc@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Thomas Hebb <tommyhebb@gmail.com>,
        aleksandr.o.makarov@gmail.com, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 12:10 AM Chen-Yu Tsai <wenst@chromium.org> wrote:
> On Sat, Sep 25, 2021 at 7:24 AM Brian Norris <briannorris@chromium.org> wrote:
> > We should match the runtime PM to the lifetime of the bind()/unbind()
> > cycle.
>
> I'm not too familiar with MIPI DSI, but it seems that the subsystem expects
> the DSI link to be always available, and in LPM if power saving is required?
> If so then this change matches that expectation, though we might lose some
> power savings compared to the previous non-conforming behavior.

Yeah, I was a little torn on whether we should care about any possible
lost power savings here, because now we stay runtime-enabled even if
the display is not enable()d. But I'm not aware of a good hook for
handling this kind of a sequence, and I'm not convinced there is much
savings by disabling the power domain in that case.

> > Fixes: 59eb7193bef2 ("drm/rockchip: dsi: move all lane config except LCDC mux to bind()")
>
> This hash is from some stable branch. The mainline one is:
>
> 43c2de1002d2 drm/rockchip: dsi: move all lane config except LCDC mux to bind()

Oops, good catch. I've been doing too much debugging/development on
5.10.y stable. Fixed in v2.

> The bind function is missing an error cleanup path. We might end up with
> unbalanced runtime PM references. (And also possibly an enabled pllref clk.)
> This is a pre-existing issue though. The code changes here look correct.

In v2, I've performed cleanup for the runtime PM state in this patch,
and added an additional patch to fix the other existing issues you
noted. Thanks.

Brian
