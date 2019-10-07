Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DC0CE183
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 14:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfJGMXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 08:23:38 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45186 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfJGMXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 08:23:38 -0400
Received: by mail-ot1-f65.google.com with SMTP id 41so10729585oti.12;
        Mon, 07 Oct 2019 05:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sjGjU81BF4BU4Tpv6JoGP9zx2zLgEveBDC6zBeCPJfM=;
        b=QqThq1WOhA1Rc88p949I5S4ZZvPIpOH3j88shzovFwrMGHUiUKQ1FrxkP0d6kgbO4r
         r3EF4bmjKG515snMVnGtVAoJr2YYUBgw40sCMAqbclp7rQ3EeARMN3M4Jv7vHiRUiDUD
         DAVGKJoP0jO3dNtS6xKLcve7AY9Z43PU8lVIP7f/lH+ZTkHu6i9q37Zd81arnCW3ZfsY
         zEbY4hHlLUKuRG4reoJ/Z47qvo+RF2FXD52clzzomnFwBZSt5iR/juZ6tYO1a6jaIu6h
         WH+iNg9tU6JQro5Ls4o3i3gRq+rn4B/29C7KhXJYaZfnfSYhZumcNbYzD6SUltnGNKaj
         NnZQ==
X-Gm-Message-State: APjAAAXkg22Fwf6xoYGWxJlGCiNlPMEIwp7lfaVYMbyXOv/Yfjefbi1d
        bi/KdXBHHAkvOvqlBmXlXZQNoz2NqcAZ5aOm/iWkl1lx
X-Google-Smtp-Source: APXvYqwrsMhuaKmEC6atgG+qyrsZ5tlgmWbokMDoanrskwv+CgFup11sxZv5HMO4kDOESENX7TeRI9bNvctN3Bwmbq8=
X-Received: by 2002:a9d:730d:: with SMTP id e13mr1265787otk.145.1570451017714;
 Mon, 07 Oct 2019 05:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190930145804.30497-1-chris.brandt@renesas.com>
In-Reply-To: <20190930145804.30497-1-chris.brandt@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 7 Oct 2019 14:23:26 +0200
Message-ID: <CAMuHMdWUq8hroJxZb=8aJVCSjUEyDJS_X8NbEUti54jJZYsj=g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rza2: Fix gpio name typos
To:     Chris Brandt <chris.brandt@renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 4:58 PM Chris Brandt <chris.brandt@renesas.com> wrote:
> Fix apparent copy/paste errors that were overlooked in the original driver.
>   "P0_4" -> "PF_4"
>   "P0_3" -> "PG_3"
>
> Fixes: b59d0e782706 ("pinctrl: Add RZ/A2 pin and gpio controller")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Brandt <chris.brandt@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in sh-pfc-for-v5.5.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
