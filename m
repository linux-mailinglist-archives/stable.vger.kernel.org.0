Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB2F44B9C8
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 01:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhKJAwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 19:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhKJAwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 19:52:07 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BBAC061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 16:49:21 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id h12-20020a056830034c00b0055c8458126fso1446328ote.0
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 16:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zuwi8VdgrtneqiZTm5AGRBpIkLfz+Yl+0tOyzAoPJUY=;
        b=AxpcyaLb8qnoVjm6VGIBvrmQPJpBdIrTDymYjlLvgES848fYut9st2UwxNoIzNhART
         HrRUrFj143C9MIKzKTvEf0XMmMNXf7unaYOGoQx5MXOJgRIxfpWl/t+aFA1OAJ292C8x
         oHo/nViAX0gFYIIBOZsN74QFDJmVB9ydapY3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zuwi8VdgrtneqiZTm5AGRBpIkLfz+Yl+0tOyzAoPJUY=;
        b=XSIhNFYXzGzrY4ksGp66nnceOIVrZ8RTY8wRhz4vnDiDKR3c74/e2T9smjdSxspDaQ
         1eFTT8bY+vuTO2ofl9ENgrTETi0ew4Q6LtB8AsteE+7Q3J2Dg1FerJfXK5DOF1FGWpNC
         /Qoob2TJ9Ut+7tUa466ff2/h7PgGgK3SsrpknmI58Tz0mN47tcuIj1R8Q3DcltwmpSZi
         aFCLg/qNBTgphbqsFTZdlPbMepfUyNJAyv35kUP4HBkyNV+ddnvcr8UaezqjF/iAXurv
         pLT79Bj1owNvKPuVM25JpFJwRwwBHR5+ufY5qD+D2CEUcUKzhr0nN0d0GMWWYiqxbG9B
         SQzg==
X-Gm-Message-State: AOAM530GjHNNXFeJyMJcclTMoLV7NzPwzqa+pg+1erhJj94BXhx4cUYI
        SYDsVKSf5qiH/XltMBmW7UTVP3q0zTMosg==
X-Google-Smtp-Source: ABdhPJzNNLMoBcsb20UVzyo90BgLFoFOLKddGhthzPRzSLZ+ap7UxLBN+gyd+GKadJrI2MiXdX9Vsg==
X-Received: by 2002:a9d:650a:: with SMTP id i10mr3179688otl.369.1636505359869;
        Tue, 09 Nov 2021 16:49:19 -0800 (PST)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com. [209.85.210.41])
        by smtp.gmail.com with ESMTPSA id w19sm1906069oih.44.2021.11.09.16.49.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 16:49:18 -0800 (PST)
Received: by mail-ot1-f41.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso1332263otg.9
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 16:49:17 -0800 (PST)
X-Received: by 2002:a9d:4b19:: with SMTP id q25mr4612966otf.186.1636505357500;
 Tue, 09 Nov 2021 16:49:17 -0800 (PST)
MIME-Version: 1.0
References: <20211109221641.1233217-1-sashal@kernel.org> <20211109221641.1233217-17-sashal@kernel.org>
 <CA+ASDXNcC4_MpURRjbeXsyXsQ9Qte_YgoXFCJUKtrSWpZsHn-g@mail.gmail.com> <YYsV/OU47QlolwOx@sashalap>
In-Reply-To: <YYsV/OU47QlolwOx@sashalap>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 9 Nov 2021 16:49:05 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMTAi+jgSDpM3vDoD1Bmimsrqv6iQrZ_=HDtQz6jQufYg@mail.gmail.com>
Message-ID: <CA+ASDXMTAi+jgSDpM3vDoD1Bmimsrqv6iQrZ_=HDtQz6jQufYg@mail.gmail.com>
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

On Tue, Nov 9, 2021 at 4:44 PM Sasha Levin <sashal@kernel.org> wrote:
> I'll drop it if it depends on patches that didn't make it in. Thanks!

Well, it won't harm anything as-is I suppose (maybe some logspam from
probe failure? not sure), but it would be extra bad if you managed to
pick up only _some_ of the dependencies. (There were 2 patches, but I
won't tell you which they were.) If you only got one of them, you'd
turn pretty much any RK3399 system into a brick, at least until they
revert their kernel/DTB upgrade.

Brian
