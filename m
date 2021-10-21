Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F55A43585F
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 03:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJUBoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 21:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJUBoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 21:44:02 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90E2C06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 18:41:47 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u69so11944268oie.3
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 18:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RFZLsyhyggQBAw1ieiqx/iLchu3wd9m2t5ZqNswJbDw=;
        b=CR2ojTcfZCGkDc9qM8OY755pFDFVKGzCfda+m68dI3gOCMZ6aMJ6CWmeT+xv9zNEFy
         B5YxaFbEA5oaGtG+Nq2ynNsIp5mFZ1ZNJjt9U3A7MjFP/kd8YFdQF+yfFpwvJs9WwsxM
         wFM3uJB0XOUAx7XkgvPGwGXwAdLiNdV2ZaSFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RFZLsyhyggQBAw1ieiqx/iLchu3wd9m2t5ZqNswJbDw=;
        b=HjgaWvVSDkWL8OSW26bQ0UIyOWjkZZ3DJQ3jo2/5n/zefHMYBsDGD18wemYVMP7KJE
         20zNglGzv1oMvGrTLc33WK8haiZ9eZMlDy3clO/K4iwQYCIEDxMmdCy3Ed4NDTSOKQPQ
         SwihQ8b4ywUKDKZdatk0Z9uUdYjEuLaiRh7yEvW6OeEk5MLc6EfjTJ0zF0MFcoe6VwzP
         C7e1UjyXeS93+dwIEbPglSoNCwJWfrGM7LouFtSW32XrmiE6xGZySjGf0koErlxmRdtT
         dTp8LCnTu/9s+L7iLDQR+fioA8UaLaZrhZObaWuzRbVZatoLQ4/JFpKeBhwSFlQTnGPa
         o6mA==
X-Gm-Message-State: AOAM531l29u3sNL0JqumQOn09egj79t7Smt+ogW1JyikZa3SZl+sZ4N4
        ImD3OqP8J9yxgA5TgEiLlcs5mREx1+WMYw==
X-Google-Smtp-Source: ABdhPJyzP4f6r/g7m/1JHMdnzYIx4JuCdhbjMKZcyoHBQVo9Qgkh27ZMjjVWTSyClCi537bAo8GItQ==
X-Received: by 2002:a05:6808:495:: with SMTP id z21mr1999426oid.106.1634780506371;
        Wed, 20 Oct 2021 18:41:46 -0700 (PDT)
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id r14sm870944oiw.44.2021.10.20.18.41.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 18:41:44 -0700 (PDT)
Received: by mail-oo1-f54.google.com with SMTP id y145-20020a4a4597000000b002b7d49905acso1837206ooa.0
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 18:41:44 -0700 (PDT)
X-Received: by 2002:a4a:424b:: with SMTP id i11mr2056955ooj.87.1634780503573;
 Wed, 20 Oct 2021 18:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211020161724.1.I67612ea073c3306c71b46a87be894f79707082df@changeid>
 <20211021004015.GD2515@art_vandelay>
In-Reply-To: <20211021004015.GD2515@art_vandelay>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 20 Oct 2021 18:41:31 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOAJqqEqx2ry4aRW4RZ87okosqxYDKRBJef8Sj_H2b1nA@mail.gmail.com>
Message-ID: <CA+ASDXOAJqqEqx2ry4aRW4RZ87okosqxYDKRBJef8Sj_H2b1nA@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: analogix_dp: Make PSR-disable non-blocking
To:     Sean Paul <sean@poorly.run>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        stable <stable@vger.kernel.org>, Zain Wang <wzz@rock-chips.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(Dropping Andrzej, because that address keeps bouncing. Does
MAINTAINERS and/or .mailmap need updating?)

Apologies for the double reply here, but I forgot to mention one last
thing for now:

On Wed, Oct 20, 2021 at 5:40 PM Sean Paul <sean@poorly.run> wrote:
>
> On Wed, Oct 20, 2021 at 04:17:28PM -0700, Brian Norris wrote:
> > Prior to commit 6c836d965bad ("drm/rockchip: Use the helpers for PSR"),
> > "PSR disable" used non-blocking analogix_dp_send_psr_spd(). The refactor
> > accidentally (?) set blocking=true.
>
> IIRC this wasn't accidental.

One other tip that made me think it was accidental was that today, the
|blocking| argument to analogix_dp_send_psr_spd() is always true. If
non-blocking support was intentionally dropped, it seemed like you
should have dropped the non-blocking code too. But that's a weak proof
of your intentions :)

Brian
