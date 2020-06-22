Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89B9204306
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgFVVzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgFVVy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 17:54:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252AEC061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 14:54:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ga4so5987193ejb.11
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x3yIPSgNJi3lZrfPxbxMrQmBueBikKwWrRM04RzFSiQ=;
        b=EwjU4zcs0DrSUd5BDlLviGmpYQwtw6mL7hPbyc7YmziZEUSxgb/dVVNZhY2/vbH3aj
         8ZHQlDx6ixeZOIde0GG2uOkKcJOYVgQtk1VvXyda5UExFV4LlqxCLAtT4DFQpirvx+oM
         l9ApXHj+Vku6e6H368CzSFL4LPXNnOFlQomvW1bJ80PEhzfyPy4KY1rfbLGLoNagf/h7
         Vr3L5liYiPH0x4ExCZQLHOSMMgKaylLwGurhmUH3FFa3x2TNqOEk44wVx9D3S7Q4P6GG
         PIKUoNno5aKnVAr21jrWOym8hbBYaNSZE839WKRwPG7GsKKR9NlV5wLJEkUUacQTFzVo
         chdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x3yIPSgNJi3lZrfPxbxMrQmBueBikKwWrRM04RzFSiQ=;
        b=Uw+sLw1bUYpHj943siAnfw8QRZFBM/csJIL9zPNh25fe3O2/WXj8FEOSsNF5+Uo7zm
         V5fyz1syPi9+xbsgwiIb8ZGfA3ZdnmahDSrzCazLMVS7wXkp9lM7nFqeOZUKRUXAjv6l
         FZcqvemReekX/fXMLweHpUNgEwNKxu85pKXCM5Cjs13jjaylN4Xg0/K/ACERmRCvhKK0
         je0aafjEB4IbrfMB3DFa0W+/51zELEf6F49yN7uMrgktk927tR8bFzrFPFCyB+g0uD+4
         TKDLNFg383zha3HRA21GGTbB2TO3mI/BIZMfCTzUzgdxQxvjXcxlc1yGiMbx8Xycgj/T
         VZ2A==
X-Gm-Message-State: AOAM531GMrZHVv2lxCQiCVYN6IwV1WoaJLalxIcdjw7qvx/gOmwhtost
        Pao7e8thCEfjxsdcOyt5NcyBZ84YR7+frMU1r2hLjuKl
X-Google-Smtp-Source: ABdhPJztID0yyxUaOy17bGEaVldHTgqjp5YdDr3/DDoK3WHRXB4Wvwbd1WZwPtjGvEE1jnuCCmiBNkJdsRHYCa547Yg=
X-Received: by 2002:a17:906:dbe5:: with SMTP id yd5mr3436180ejb.328.1592862896682;
 Mon, 22 Jun 2020 14:54:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200622125212.03B9220732@mail.kernel.org>
In-Reply-To: <20200622125212.03B9220732@mail.kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 22 Jun 2020 23:54:45 +0200
Message-ID: <CAFBinCC6uK233uKOXYnGis=M8ms=EjH3=yoGLe7c3J_PNMv2LQ@mail.gmail.com>
Subject: Re: Patch "ARM: dts: meson: Switch existing boards with RGMII PHY to
 "rgmii-id"" has been added to the 5.7-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Jun 22, 2020 at 2:52 PM Sasha Levin <sashal@kernel.org> wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>     ARM: dts: meson: Switch existing boards with RGMII PHY to "rgmii-id"
>
> to the 5.7-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      arm-dts-meson-switch-existing-boards-with-rgmii-phy-.patch
> and it can be found in the queue-5.7 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
this patch has another dependency on upstream commit 9308c47640d515
("net: stmmac: dwmac-meson8b: add support for the RX delay
configuration") which itself depends on a few other commits
unless you are also planning to backport more changes (I would have to
make a detailed list and also reserve some time for testing) I suggest
to drop this patch from 5.7, 5.4 and 4.19

some more information below.

[...]
>     Previously we did not know that these boards used an RX delay. We
>     assumed that setting the TX delay on the MAC side It turns out that
>     these boards also require an RX delay of 2ns (verified on Odroid-C1,
>     but the u-boot code uses the same setup on both boards). Ethernet only
>     worked because u-boot added this RX delay on the MAC side.
configuring the RX delay on the MAC side is only supported since 5.8-rc1
prior to that we relied on the bootloader to do "the right thing"

>     The 4ns TX delay was also wrong and the result of using an unsupported
>     RGMII TX clock divider setting. This has been fixed in the driver with
>     commit bd6f48546b9cb7 ("net: stmmac: dwmac-meson8b: Fix the RGMII TX
>     delay on Meson8b/8m2 SoCs").
changing the TX delay could be done in a separate patch, but it still
wouldn't fully fix Ethernet without the RX delay configuration (see
above)


Thank you!
Martin
