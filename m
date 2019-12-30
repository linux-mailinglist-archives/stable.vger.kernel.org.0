Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C7212CF62
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 12:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfL3LQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 06:16:01 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:50191 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfL3LQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 06:16:01 -0500
Received: from mail-qt1-f180.google.com ([209.85.160.180]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M2ep5-1il3HF324d-004Bkb; Mon, 30 Dec 2019 12:15:58 +0100
Received: by mail-qt1-f180.google.com with SMTP id w47so29434814qtk.4;
        Mon, 30 Dec 2019 03:15:58 -0800 (PST)
X-Gm-Message-State: APjAAAWRKPLaOKy1oQE+nPPeAArtfy5GBIADarQBAAYcO+8UG9TefZK+
        1SO8KJ6Zgj9js0Y8ea3Z3DbBKri+1PH3sHz0a5M=
X-Google-Smtp-Source: APXvYqzHiTliOPmvJABpokJdFOnog5iqQcMnXOuJ16bjZruhXTBvSkZi1OShEfRbZgiT36fzXJXLxudI1x/qQMXDWeA=
X-Received: by 2002:ac8:6153:: with SMTP id d19mr47625025qtm.18.1577704557555;
 Mon, 30 Dec 2019 03:15:57 -0800 (PST)
MIME-Version: 1.0
References: <20191216141506.121728-4-arnd@arndb.de> <20191225235522.3516B20727@mail.kernel.org>
In-Reply-To: <20191225235522.3516B20727@mail.kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 30 Dec 2019 12:15:41 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1SHpjv2xQXjfGC-A9whciH-Etp4weHScvD_HuTQG+sUA@mail.gmail.com>
Message-ID: <CAK8P3a1SHpjv2xQXjfGC-A9whciH-Etp4weHScvD_HuTQG+sUA@mail.gmail.com>
Subject: Re: [PATCH v6 3/8] media: v4l2-core: compat: ignore native command codes
To:     Sasha Levin <sashal@kernel.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:YWqY0bpM5IvDO76YC3uKR3WM1vB9fLYEUIZgNl84S/tTnFEynf1
 KTfz6OeTfeML/W54MV17RUPv3zee5NklXU0vJ74Sw40f8kDPsRXlH7aCDeBrWpVbStWVQor
 /urh0QSM4TcxpFcFradUDlYv382YNGJkZdP6l4UjYYFGzkqj/dOLYIC3pLTsLTOB76u13Do
 Qr3Cdr0yegPyNQuxmjjig==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vHNxFid2/iE=:g6rZcKxQPW2QCcTzH/RGV6
 v+qluQLQC2e6pLvSljGI6w3snnObKpqp2kaJMSuFGyLDhdiur0duFXMDkUShXCfiv+AXzK8lQ
 FNyrgncbmZdSLF8wxCyx4/OO9Ung7MfABquZHjz1kTDx/+bc2uuckNRZMw1mA64VepJfbUraO
 +ZNdgXFb+aChehU3mhca8+3yQbOEL0srcUFZQ6E6hBFk2WofA5AwkJs8Ud/8u3u0PdeoejBmn
 twbxF7/ynT/kTyoUbYErB3mGLIfUzZjuLjSziCAAoRmBiVYSljG07GTDE9pkM0PY1NWNzO0LJ
 75Lz8qcGWsCNR3yzDC75A4xFhmrqu8XS4H02kd8ObrmRIZRjMvD1yWYri1XB1nkr2vT41EqLU
 +kDRSVGQNiMRd2/aCG8+89jcyO6LcVRQawHUf2K9V+CxBdbiO+XJM83vx/kDp/+oCKE0der49
 BA5fSvOSkiRX3nqTdUFvoOFe3fcRihg2fYhzP0CoeGmx/bn1fVQJR2rn5vx9bFjon/iJm9E0v
 1XtGvd2byIklS3bk+74NTL3eX70+sfNDZFkRr8eVyTTMSt6t4CNWo2/fIR2JB/beBNBR4L4ha
 Pq9Q+VXmkXKqPROWTDxFUQHlwlzyyxlQTDwASqbHYlxxDFALVGojJ++Th2ay/Ybv0TdYQqiJP
 i5VGgSpGDUH/QS3LVyuHqLuO4yvOuP56GlrFliUQOuQ7eJs6Vj1Ty/mMwFTniICKiIwCDtmcX
 M1HgBmJayqJn2EjozUp9iSupBwE4arxTfN5wNojq2+88KporbxN+wIerkKVS0R+aacjRWiY5t
 w0VF1bTWYhccIbkK9pRxhAEYoQvHLhtNwV2qxaSU88ENLGu3TBwaoMDIwLoTHu5XkHCq6qXlR
 b1wgZfQ9xMLL4sATFUnQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 26, 2019 at 12:55 AM Sasha Levin <sashal@kernel.org> wrote:
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.4.5, v5.3.18, v4.19.90, v4.14.159, v4.9.206, v4.4.206.
>
> v5.4.5: Build OK!
> v5.3.18: Build OK!
> v4.19.90: Build OK!
> v4.14.159: Failed to apply! Possible dependencies:
>     6dd0394f5fcd ("media: v4l2-compat-ioctl32: better name userspace pointers")
>     fef6cc6b3618 ("media: v4l2-compat-ioctl32: fix several __user annotations")
>
> v4.9.206: Failed to apply! Possible dependencies:
>     6dd0394f5fcd ("media: v4l2-compat-ioctl32: better name userspace pointers")
>     a56bc171598c ("[media] v4l: compat: Prevent allocating excessive amounts of memory")
>     ba7ed691dcce ("[media] v4l2-compat-ioctl32: VIDIOC_S_EDID should return all fields on error")
>     fb9ffa6a7f7e ("[media] v4l: Add metadata buffer type and format")
>     fef6cc6b3618 ("media: v4l2-compat-ioctl32: fix several __user annotations")
>
> v4.4.206: Failed to apply! Possible dependencies:
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

I think we need it to support users of musl on old kernels: musl is
adding conversion functions for emulating the new (time64) ioctl
commands on top of the old format, and without my patch, the
new commands do not necessarily return an error that musl can
catch.

I can provide a backport of my patch to v4.4 and v4.9 for this when
the patch has made it into mainline. Can you notify me again when
the time has come?

A related question that we should address is whether we want the v4l2
and alsa time64 ioctl patches backported as well, and to which kernels
(if any).

My feeling is that we don't want them those in v4.14 and earlier because
that is rather pointless with musl already having emulation in user space
and the rest of the kernel not being y2038 safe at all.
For v5.4 I'd say we do want them, and possibly all the other remaining
y2038 patches as well, I have a tree[1] that I try to keep up to date
with the versions that got posted and/or merged, as I know there is
demand for it. If you prefer not to have them in v5.4.y, I can keep them
here myself and make sure it's possible to my branch into that instead.

v4.19 is a bit borderline: if we decide to do the backports to v5.4 and
there is demand for v4.19.y, I could also try to pick the most important
patches from my tree and backport them to v4.19.0 (including a lot of
work that went into v5.1) and then look at that tree to see if it should
be part of the official v4.19.y or not.

       Arnd

[1] https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=y2038-endgame
