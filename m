Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF2244B959
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 00:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhKIX2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 18:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhKIX2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 18:28:44 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F21DC061766
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 15:25:58 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso1067494otj.11
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 15:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nL261LfEnE+lH5hQroZYFitjsNXa1tK6YPPcrVYv6c4=;
        b=N1HvdV99468q9bEv5q7ellPorYQd/W8mpCPrWLqn8S4ksJv0XInlTz/z79o91irx8F
         IBinuVJR+3dv3ohTcMOjoLOjds8IlTm/Ay2TbcpMEIQb7TPl2tCqAAaonqYywCgsr4kN
         ZCEWZuQ1MSmhqlppYjbvItwe0X/k2DasKrpK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nL261LfEnE+lH5hQroZYFitjsNXa1tK6YPPcrVYv6c4=;
        b=tCeQg4epiNJXovqWlC/1vVbjMwpi11H4VR08yxFGyDQWIyYblH8KiDyimPmtRooyF5
         mQMUMfaAeASCqJ9DhPwgXAd+nvRt8S6iHAQBEbftyUkI/h5KA7y91/Xj1zy7xKkyIVEK
         Z4+gsiPNYp0FZZNfaPPEgR/Y4+WakRhGlmgVxUNWBMdms4nIEboPjPM749gIqGa+y0i4
         0jd3yyFNVKr13Fon7302fFtEmZCST7RaHyWnhHb7bQm6vhH+5zkr5FBmrkHNkf1h5eqw
         RUd/UIW6jN7Lj8SoaGsLDaKksZoEaqqf5UV8kX+1Ko5moY1eeeBapnHmydYVCBhtKySA
         lUIw==
X-Gm-Message-State: AOAM533P+RA78IRa4sq9VLS1wSrEDNmgwrNWOFHJGnxcMUI1S27lGR2T
        BC5VepTJFJ2QDqX6rQZ8BFCx01TI0ysa0w==
X-Google-Smtp-Source: ABdhPJzZkRVlyb0xDQQjnJDUsfNWW/k3qqt2M1oQYAmiY1NYxq9ee37f1eCWMolQAJEeHmDS4PuEfA==
X-Received: by 2002:a9d:6953:: with SMTP id p19mr9193302oto.138.1636500356733;
        Tue, 09 Nov 2021 15:25:56 -0800 (PST)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com. [209.85.210.45])
        by smtp.gmail.com with ESMTPSA id k12sm2748515ots.77.2021.11.09.15.25.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 15:25:55 -0800 (PST)
Received: by mail-ot1-f45.google.com with SMTP id z2-20020a9d71c2000000b0055c6a7d08b8so1118809otj.5
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 15:25:55 -0800 (PST)
X-Received: by 2002:a9d:734a:: with SMTP id l10mr9337755otk.3.1636500354735;
 Tue, 09 Nov 2021 15:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20211109221641.1233217-1-sashal@kernel.org> <20211109221641.1233217-17-sashal@kernel.org>
In-Reply-To: <20211109221641.1233217-17-sashal@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 9 Nov 2021 15:25:39 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNcC4_MpURRjbeXsyXsQ9Qte_YgoXFCJUKtrSWpZsHn-g@mail.gmail.com>
Message-ID: <CA+ASDXNcC4_MpURRjbeXsyXsQ9Qte_YgoXFCJUKtrSWpZsHn-g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.15 17/82] arm64: dts: rockchip: add Coresight
 debug range for RK3399
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Leo Yan <leo.yan@linaro.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 9, 2021 at 2:17 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Brian Norris <briannorris@chromium.org>
>
> [ Upstream commit 75dccea503b8e176ad044175e891d7bb291b6ba0 ]
>
> Per Documentation/devicetree/bindings/arm/coresight-cpu-debug.txt.
>
> This IP block can be used for sampling the PC of any given CPU, which is
> useful in certain panic scenarios where you can't get the CPU to stop
> cleanly (e.g., hard lockup).

I don't understand why this is being backported to -stable. First of
all, it won't work because it's missing dependencies (specifically,
around the RK3399 clock driver). But even if it did, I don't see how
this is a candidate for -stable.

Methinks the AI has gone too far again.

Brian
