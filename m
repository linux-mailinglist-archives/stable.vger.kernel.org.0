Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D239107229
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 13:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKVMaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 07:30:15 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:34239 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVMaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 07:30:15 -0500
Received: from mail-qv1-f51.google.com ([209.85.219.51]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MIMT4-1ibRSr3iZY-00EQmw; Fri, 22 Nov 2019 13:30:14 +0100
Received: by mail-qv1-f51.google.com with SMTP id x14so2798494qvu.0;
        Fri, 22 Nov 2019 04:30:13 -0800 (PST)
X-Gm-Message-State: APjAAAWBQ6Pt7ELUVeg7oYmwXNyKj3nZkIgFcCcVX3O89vcQUr92Obyk
        eo+RSIXn7M2Q0EmeHKUxApF6FTma+3fMIvvbsc8=
X-Google-Smtp-Source: APXvYqwo4cq5vi2UMJ+B8EOtGb2wJBoNA355QcEFDck33B0EH/15Sn93Gc6HoQeA3bY6XQ3M3oRovNXI54EVvUWqnm0=
X-Received: by 2002:a05:6214:2c2:: with SMTP id g2mr12983338qvu.210.1574425812653;
 Fri, 22 Nov 2019 04:30:12 -0800 (PST)
MIME-Version: 1.0
References: <20191111203835.2260382-4-arnd@arndb.de> <20191122070015.D5A702068E@mail.kernel.org>
In-Reply-To: <20191122070015.D5A702068E@mail.kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 22 Nov 2019 13:29:56 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3kAGE1AvKtifkVuBbrqRXn2f078Q_2kxznv_gFzmrSWg@mail.gmail.com>
Message-ID: <CAK8P3a3kAGE1AvKtifkVuBbrqRXn2f078Q_2kxznv_gFzmrSWg@mail.gmail.com>
Subject: Re: [PATCH v4 3/8] media: v4l2-core: compat: ignore native command codes
To:     Sasha Levin <sashal@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:nrgb/6yGw4RXoOcQfuvbxGNdUm6TKYxWJqe8POQt4YiVIXuc+bI
 fhDG5WQ2tntq//8TPfxFoOpHSwd9DrK/kCRDA2juQN3Xh8xmSEcFMaD0zIQEq6/O4c+ctGd
 BkwyJO04mBWrLKHPd+8Jz5CdhYmUH9+Cq4BivCWpMl2DYkchkt1/Ix7LT00I5WY8jjSYNIl
 aDMutOkzvBtynI/OLb31g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Lj4cpsbr/HA=:/mJNazM+K1aP8eczjLsXTX
 g0utTWatesEH2EcIFWvosnwuDsPOR3xk5KyoEoKtshgMxQ34IdCnewB6EZWpetsBuWL5FYsTr
 B1SJMkxGAxc7mXt7/nJhVZyOmba1ltBmndg8WZ7KXV7Sq9WtiUPlsK0oMOIBd+Byhotq+TUEP
 uObQ9pXnIopLMOj7f3PrMTzYFjq07pMR/JiHOR4mKKiGhFKKnv7l9K/zCGbbggadFW5D1zuJS
 Bdg14R0J/b/eDqDgBj6Mx4DnyGIMSRnNWFa5wJ0pnTYy8zLtOLYBy/jJkdJuKNx32jFG/FTxf
 wyKSaabS4zsMXiGM/p60eQYZcYrYLTiLXQGh+osdwpeTikMeh9q2zEjYFJTXgksaMJ0NTa193
 dUV4m5sD6k0OJbz5IKZmXa6mTq1ZZmsRpBS0MY4rOrMl+dvV9BrHhFR2cNAOI7V7+6+yDoF4G
 7N2dCKvtPMSY5KnsVe3TePCmddZC0V5b+jQotZvkeQAyVM01w4QUhyGDOpPUuQVCPzHggbx3e
 wogRVwM2fH9jIXF8m5VTe7XwKOXWLsgCO8KJId+hFhPBOl3vDvij0lzuG5Q/nk78VfAZhFa2H
 ZmxmZ4NIxlojxWqLex00OUYv1vmQ+xRajPfb9BR4nkXd5sU2f/e+QRiQd3HHxrSYN8NB7iopX
 mQmB/GISrt4pTJQ6WguG4ak5dPhs+TaycLhVLepbfvKajE0PBmgup3Ti+H2R7+3vcOkxwMzFW
 lKTcLnBgwVWQQIwkab59cvlAlqfTQqjRYsi+GQ40M2Am1Kpzwoa5zcxR3T3+eE/hNGWAxcjX+
 x/hhpFkT9b88rtTm05aJHiW52WPsE+d/FzDFKOvq46k3+thSbrR/0cB/orPrTVJwzQgzveMX8
 KdrgecevEIA6sAxn1EHQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 8:00 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.3.11, v4.19.84, v4.14.154, v4.9.201, v4.4.201.
>
> v5.3.11: Build OK!
> v4.19.84: Build OK!

Ok, good.

> v4.14.154: Failed to apply! Possible dependencies:
>     6dd0394f5fcd ("media: v4l2-compat-ioctl32: better name userspace pointers")
>     fef6cc6b3618 ("media: v4l2-compat-ioctl32: fix several __user annotations")

The fef6cc6b3618 is probably a candidate for backporting (it fixes smatch
and sparse warnings and should have no other effect), the 6dd0394f5fcd
may be a little too big (but also harmless).

The downside of not backporting the patch is that user space code built
with 64-bit time_t would get incorrect data rather than failing with an
error code on older kernels.

I do not expect to see backports of 64-bit time_t support to kernels older
than 4.19, so this probably won't matter much, but in theory it's still
possible that users can run into it.

> v4.9.201: Failed to apply! Possible dependencies:
>     6dd0394f5fcd ("media: v4l2-compat-ioctl32: better name userspace pointers")
>     a56bc171598c ("[media] v4l: compat: Prevent allocating excessive amounts of memory")
>     ba7ed691dcce ("[media] v4l2-compat-ioctl32: VIDIOC_S_EDID should return all fields on error")
>     fb9ffa6a7f7e ("[media] v4l: Add metadata buffer type and format")
>     fef6cc6b3618 ("media: v4l2-compat-ioctl32: fix several __user annotations")
>
> v4.4.201: Failed to apply! Possible dependencies:
>     0579e6e3a326 ("doc-rst: linux_tv: remove whitespaces")
>     17defc282fe6 ("Documentation: add meta-documentation for Sphinx and kernel-doc")
>     22cba31bae9d ("Documentation/sphinx: add basic working Sphinx configuration and build")
>     234d549662a7 ("doc-rst: video: use reference for VIDIOC_ENUMINPUT")
>     5377d91f3e88 ("doc-rst: linux_tv DocBook to reST migration (docs-next)")
>     6dd0394f5fcd ("media: v4l2-compat-ioctl32: better name userspace pointers")
>     7347081e8a52 ("doc-rst: linux_tv: simplify references")
>     789818845202 ("doc-rst: audio: Fix some cross references")
>     94fff0dc5333 ("doc-rst: dmx_fcalls: improve man-like format")
>     9e00ffca8cc7 ("doc-rst: querycap: fix troubles on some references")
>     af4a4d0db8ab ("doc-rst: linux_tv: Replace reference names to match ioctls")
>     c2b66cafdf02 ("[media] v4l: doc: Remove row numbers from tables")
>     e6702ee18e24 ("doc-rst: app-pri: Fix a bad reference")
>     fb9ffa6a7f7e ("[media] v4l: Add metadata buffer type and format")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

I'm happy to provide a hand-backported version of the patch for the older
kernels if Mauro and Hans think we should do that, otherwise I think it's
we're fine with having it on 4.19+.

      Arnd
