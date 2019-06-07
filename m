Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315E73984E
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 00:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbfFGWLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 18:11:03 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40576 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729904AbfFGWLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 18:11:03 -0400
Received: by mail-lf1-f65.google.com with SMTP id a9so2708764lff.7
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 15:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wwd43iQ+uxpnBtPTqymsT6s+8HUa61yC8t5RUF2PcZU=;
        b=cx5trC4enXjixaDKj6Ievop4mO8XN9hgO9aAR04Q7aLPSDJ2c8Q6GPk2HH8EC/ErF0
         7MJ7D8Th748v7WMTnI63ah8gmGDXq0TkGf0uJ1v/q/g/zzZU3mmkwBkVYZE1sB8w1+Mf
         hASuZE/FTdqh3tRERGLesm/E3MnKbdXjC6lgCDZgIVjNnHUuOF3/kjmlNSijoiE1Oi6F
         6BxGVHxQaCMURQYR9jvt9oSgPaAFcvuDitqQjzpTRn9VB4Sg97qRzuS61nw2tl9Mowoj
         1tw9aHeC2Kb374as6WteoD0b9grq85chn9lJWbzEMwWrqkKHorAlIPnTz5cLF2GYFJAD
         X4Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwd43iQ+uxpnBtPTqymsT6s+8HUa61yC8t5RUF2PcZU=;
        b=Pw2hvWRMU1xJg8vnJZ5O/K+BTbNi3jNZTwPKPP0auTivFwe6s3X933kd7BRoAU8suB
         toifaBSexLzUkm6yH+jzhW30MgTjNUin1KRqepJQAVkENXL68DoopyyM/Zn34M8dSQzw
         vGapQfOb7DoM7ekrLiL7QQz2W1HSsA8KGqQkYRbnO1sgdlcRG+ybtfPhPtUQj8WQdnl8
         KtCgdk5UkI7pvFDW556bsnol7UBQNV2YIv8vJC1eCT3Uh/E2TEqu4j6JsLb5cs2K6K2d
         HpYcZ0P8G1JXJm4qyGeEO5VFU5p6UDNUGBLXA9ySl93tAq1pfljSPhpjLt2jrOOuzy2d
         pw0Q==
X-Gm-Message-State: APjAAAWKqOkfZoiaD+5SQyU24Kw4QPbFQLVEiQueZBB6fY59j2mn6AM2
        tjOMRgUOsCWxv62EdmXRCYRyumJeCm0dl/gfytiGJg==
X-Google-Smtp-Source: APXvYqzlzk1opCrnSZLf1NClG2hmLjUWMYvMv5LilcvGaMM1NvQ27Pl0x01y4ezRphDXsdt6wF8raMS/qpaHuG1ixW0=
X-Received: by 2002:a19:7616:: with SMTP id c22mr23929383lff.115.1559945461842;
 Fri, 07 Jun 2019 15:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190604163311.19059-1-paul@crapouillou.net>
In-Reply-To: <20190604163311.19059-1-paul@crapouillou.net>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 8 Jun 2019 00:10:54 +0200
Message-ID: <CACRpkdbKg22OyViYhXS=Vyps=2zQ_dmm23Xr8+dBp+uwwjheuQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS: lb60: Fix pin mappings
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, od@zcrc.me,
        linux-mips@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 4, 2019 at 6:34 PM Paul Cercueil <paul@crapouillou.net> wrote:

> The pin mappings introduced in commit 636f8ba67fb6
> ("MIPS: JZ4740: Qi LB60: Add pinctrl configuration for several drivers")
> are completely wrong. The pinctrl driver name is incorrect, and the
> function and group fields are swapped.
>
> Fixes: 636f8ba67fb6 ("MIPS: JZ4740: Qi LB60: Add pinctrl configuration for several drivers")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Such things happen. Are you planning to phase all the board files over
to use devicetree eventually?

Yours,
Linus Walleij
