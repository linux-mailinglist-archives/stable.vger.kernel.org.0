Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A032C61C5
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 10:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgK0Jda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 04:33:30 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33983 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgK0Jda (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 04:33:30 -0500
Received: by mail-ot1-f66.google.com with SMTP id h19so4187926otr.1;
        Fri, 27 Nov 2020 01:33:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VG9mvGWzcOlgITQm7N6zcafZvGmScFIc66IwQJRIyJM=;
        b=bP8meu9s/uNvdmFI7HyMB0IT8Xu6nXeUfKeUL6MjR++/E3/TBXfbDdE3yuFhoJ2JKm
         5AXOdkpi0ZkPoIYE+zHlvYJByuIbH3GdsEm0YDXDoRpQhqMIV6e2yBBn8qWqdn3wUp9Q
         IllnxAr1GEIjaiwP+JEHatUUtgIfM9UEfAxOQNOaRqvnH00iumm/B7sunqjBV9857Gi9
         zCK+2LeTpjBX7ipaq5s+qrs6VRu9VYZ3iYUfXmYT7/9Inhqz1leSEt2+f4y73FY3j48Z
         +7MQgsKHRTzfKYlJy6yJONgoaySyNVwLZ/40iojDcfzfndLxcHJRXnNXUnF9xT9S2psS
         pa6Q==
X-Gm-Message-State: AOAM532RuRf4WoFSvs7+ReFXDxBpvfSAgJabIk3aDaoNytzWCQR0B0b9
        diEV+jPMnUpCw4JsB/ohLYztKKqQNktdslkqoZ8=
X-Google-Smtp-Source: ABdhPJxxvkZ4hJcoyR+cYLpV6e2UU4eSk4TGRjsR0W0KIxvVPVdblZPxURGkhWQBtJhStp/Ec5ZLkYitC+cytDoUxSI=
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr5385465oth.250.1606469608748;
 Fri, 27 Nov 2020 01:33:28 -0800 (PST)
MIME-Version: 1.0
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20201126191146.8753-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20201126191146.8753-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 27 Nov 2020 10:33:17 +0100
Message-ID: <CAMuHMdWwtgv3WiOJVaP61BcKjAhBi+2d8-4uUFENhoO_+i6AbQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] memory: renesas-rpc-if: Fix a reference leak in rpcif_probe()
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 8:12 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Release the node reference by calling of_node_put(flash) in the probe.
>
> Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
