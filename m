Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8B6440E8C
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 14:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhJaNLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 09:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJaNLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Oct 2021 09:11:22 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9014C061570;
        Sun, 31 Oct 2021 06:08:50 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i3so1477277lfu.4;
        Sun, 31 Oct 2021 06:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dlo4dVJTP+I4lsktcV21lVUKO/hrVjfcxAb343JLK00=;
        b=SqcBj/48ffxScnNLJyF5rC+wr/MiqmNRlvnZi3O0SJtMhGbF7wPhSQ7ZJgLBiQf3Ys
         pjGj6qxEKmQ4T5aFjDIaqq/O6WoZTU5FAnRtKzd1QatInyDMqdlij7QhH9KxiyBG+iD9
         yoHR1zg6RnqH0RWKsXKiFJ+dSbhEEBbAPpWYERLtqBU8a5E6wir60Uw60ZWJN8lPgTaB
         AhH2eYM5E9RVCpBYhgbDXCB/B1PMb1QMcVTs4cZBHo4iqyFjuZ5T6NtT6POBus8vz9VE
         oo1XrXkoZaC1Xjsxw1czt9+ceDmQvAeayDihpj8GAMFc22DjYp9MCV8ySfUsks/JGsjF
         762Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dlo4dVJTP+I4lsktcV21lVUKO/hrVjfcxAb343JLK00=;
        b=UEtL51s+8tsH10bPFK+do7z3XGRZYI48ggPGz2ntH8wNHs1bmndLaytTV2ggJdnZ1I
         Po4TVoIXAIP26YNRgS0DJl55m6q5154zSulLudS5Oucj0O7pErXdOre4FGPaxzXCYvmD
         rEb2cLB9Sa1LFcdSPD8QZ8MPGXIH8KzaGQoM2E479nZxNnS38dC3XfTDmTcA1cpvYb7r
         76QOA5lIiq7LZ44pm787auErMVnLmTaG2a6W2T7ONEgbP06rujB8vacT1y5X8vkXTSE7
         nsU/LU4UbPrzJSP16GN6MR74ashWlAMQlTezbO+f6eknGkEQwxDfU381MyIrsdyx9Zbm
         eCoQ==
X-Gm-Message-State: AOAM530Lt0+a9WMpmQDYV16Vj7T9zhsXJnF66C0BOMKDJ380Kq9CKEB2
        QFBbi23Kg7NJbrulKoIhD0pIs3ZSjd41M75VgBo=
X-Google-Smtp-Source: ABdhPJwB+y6xKGw0/H9YCa5eSQsGAqhLLQ/iyNOf4SlB355GY6nWs9MXGBlmmdgVguDsTbyQl+aVrS4ZEmsJR1uXsDw=
X-Received: by 2002:a05:6512:acd:: with SMTP id n13mr21753886lfu.60.1635685729317;
 Sun, 31 Oct 2021 06:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211031064046.13533-1-sergio.paracuellos@gmail.com>
In-Reply-To: <20211031064046.13533-1-sergio.paracuellos@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sun, 31 Oct 2021 15:08:13 +0200
Message-ID: <CAHp75Vf3TninFNRdz453sdqrQpu-2sqaiFd-rCqOFeo-kMCniw@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: ralink: include 'ralink_regs.h' in 'pinctrl-mt7620.c'
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 31, 2021 at 8:41 AM Sergio Paracuellos
<sergio.paracuellos@gmail.com> wrote:
>
> mt7620.h, included by pinctrl-mt7620.c, mentions MT762X_SOC_MT7628AN
> declared in ralink_regs.h.
>
> Fixes: 745ec436de72 ("pinctrl: ralink: move MT7620 SoC pinmux config into a new 'pinctrl-mt7620.c' file")
> Cc: stable@vger.kernel.org
> Cc: linus.walleij@linaro.org
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Tag blocks mustn't have blank lines.

...

> +#include <asm/mach-ralink/ralink_regs.h>
>  #include <asm/mach-ralink/mt7620.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>

Actually the rule of thumb is to start from more generic definitions /
inclusions to more particular. Thus, asm/* usually goes after linux/*.
Any Specific reason why here is not the case?

-- 
With Best Regards,
Andy Shevchenko
