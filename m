Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F2712540C
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 22:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLRVDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 16:03:05 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34065 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfLRVDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 16:03:05 -0500
Received: by mail-ot1-f67.google.com with SMTP id a15so4161382otf.1;
        Wed, 18 Dec 2019 13:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B022Y0u/lSuMqkjfFGXwIHOe924iIvpp7vfoqhOZjIE=;
        b=bU0xdC05u1Zh2iy/DTWUOzVNRuzDh0Y7pyKiAIYOxLtEJFFldCyNTigvH2M1QSg0YI
         CMIbBcbAnrAGJTGHlOeAlCZkN2MBFBPU+U+BfTfy1+IuP2FvajUjfEMj0xPsFr+Oa5FT
         PXx2rvBW8UY2eTRPMz3tyP1LOF00xf64yJyFqf2Z7SW5FWQ0nIi20F7DBHLP3Tr20IKr
         geoDL6z75vKRFndXocvHsrvrCmRe/3Ksip8eky2U1zT34NkDz6g+3Qi4z26R9qiimwxZ
         FnSdDe3p/tW2VllY1aMSc/X1/in4XiBm4qnkHqDjCD0zCJeqMEZanS2tcCP2K17id5pa
         fucg==
X-Gm-Message-State: APjAAAXTLKrbKwQAwS0zxj/QkXGFzYbwRMkifVVEJw4um3rP9hDEhWwe
        HOed5V0mj0CCsZ6/Mxil9AaGal5HHb6GnlogUVz1h5My
X-Google-Smtp-Source: APXvYqwnQ7jvI9l31qt943pfNsnqKIyElZdfXdIX7/cUcBTyrOWAPfCfDUGR/VD8UiENb5Ue0XNu5H5S3/n3kP8QKzM=
X-Received: by 2002:a9d:2073:: with SMTP id n106mr4764006ota.145.1576702984486;
 Wed, 18 Dec 2019 13:03:04 -0800 (PST)
MIME-Version: 1.0
References: <20191217200721.741054904@linuxfoundation.org>
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 18 Dec 2019 22:02:53 +0100
Message-ID: <CAMuHMdU92QPEi9bYnzG4z_EVimstZ1u_gubuaWxwZVaDca+OGg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/37] 5.4.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Dec 17, 2019 at 9:10 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.4.5 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Yoshiki Komachi <komachi.yoshiki@gmail.com>
>     cls_flower: Fix the behavior using port ranges with hw-offload

Given I bisected a WARNING to this commit, it's probably safer to not
backport it to stable yet.

So far no response to my report
https://lore.kernel.org/lkml/CAMuHMdXKNMgAQHAE4f-0=srAZtDNUPB6Hmdm277XTgukrtiJ4Q@mail.gmail.com/

Given it's networking, it could be an endian issue, manifesting on big
endian systems only.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
