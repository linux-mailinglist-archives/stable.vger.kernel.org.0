Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E9D6AB0C3
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 15:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjCEOCS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 5 Mar 2023 09:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjCEOCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 09:02:06 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698AB1ACC2;
        Sun,  5 Mar 2023 06:01:24 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id r5so7945632qtp.4;
        Sun, 05 Mar 2023 06:01:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678024764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJsSTTqCQz4Dyv6nux+HU3PdD1w5ZWvBeGIz/RFZn1A=;
        b=lh8Z+KfGK9XggTwQmHniOFrjMrH9u8iZ1KR0FFPJPIjm5K6I9GO+HZdxJTzZQzqVQh
         DrKbnqj1dD6COjbP0OWRx51R4wJm/XkDQdlb4sWvMV4uDEG58cw2hLIewRes2B+RDWAv
         vhh3IaGPSLirQBa4+8c34PU5OGzJCsCo+mEc8/8op51S8W2D4seG//GjxhQp91PCHPBz
         8cJ8oEyuJ+E3jn/YIkHzQiBmjt1v19i5rdf+jH3cZfBvSblOYmzlzVNpuKSEIgh81rod
         IhAByir2+CjRT3b7RLvn3cCpwuAVUvAcGc27gCdp8SbikDsUvm1bzjmeGbT0MO7ts0Ry
         Jfpw==
X-Gm-Message-State: AO0yUKWVO/F8q0TDBm1pMsBj2CjF0b9REGDqr0aIp4fB33ITAC6X6dzN
        IyykIvobJxr66ArJVvInIhDMMAfjqZIyPA==
X-Google-Smtp-Source: AK7set9r7GnDHrSLerXUCbo2YbjN/ocX/riN4b1qDMxK3FRUQ23uTMJwiC+X92l6xJRN5o/5QcuQ7w==
X-Received: by 2002:a05:622a:341:b0:3b8:6075:5d16 with SMTP id r1-20020a05622a034100b003b860755d16mr12664553qtw.56.1678024764033;
        Sun, 05 Mar 2023 05:59:24 -0800 (PST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id g186-20020a37b6c3000000b007430494ab92sm5537101qkf.67.2023.03.05.05.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 05:59:23 -0800 (PST)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-53916ab0c6bso136164367b3.7;
        Sun, 05 Mar 2023 05:59:23 -0800 (PST)
X-Received: by 2002:a81:b285:0:b0:533:99bb:c296 with SMTP id
 q127-20020a81b285000000b0053399bbc296mr4532587ywh.5.1678024763117; Sun, 05
 Mar 2023 05:59:23 -0800 (PST)
MIME-Version: 1.0
References: <20230305135207.1793266-1-sashal@kernel.org> <20230305135207.1793266-7-sashal@kernel.org>
In-Reply-To: <20230305135207.1793266-7-sashal@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 5 Mar 2023 14:59:11 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXLBVDPPM5ZGGV5O5uMm4R8=ZHvsgDxMxHQP2q4YKvhhA@mail.gmail.com>
Message-ID: <CAMuHMdXLBVDPPM5ZGGV5O5uMm4R8=ZHvsgDxMxHQP2q4YKvhhA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.2 07/16] clk: renesas: rcar-gen3: Disable R-Car
 H3 ES1.*
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        mturquette@baylibre.com, sboyd@kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Sun, Mar 5, 2023 at 2:52 PM Sasha Levin <sashal@kernel.org> wrote:
> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
>
> [ Upstream commit b1dec4e78599a2ce5bf8557056cd6dd72e1096b0 ]
>
> R-Car H3 ES1.* was only available to an internal development group and
> needed a lot of quirks and workarounds. These become a maintenance
> burden now, so our development group decided to remove upstream support
> for this SoC. Public users only have ES2 onwards.
>
> In addition to the ES1 specific removals, a check for it was added
> preventing the machine to boot further. It may otherwise inherit wrong
> clock settings from ES2 which could damage the hardware.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Link: https://lore.kernel.org/r/20230202092332.2504-1-wsa+renesas@sang-engineering.com
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch disables hardware support.  Do we really want to backport
that to stable?
Perhaps backporting to v6.2.y and v6.1.y is still acceptable (the next
Renesas BSP will be based on v6.1.y LTS), but I would not recommend
backporting to older versions.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
