Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3189031D329
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 01:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhBPXw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 18:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhBPXw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 18:52:29 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC16C061756
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 15:51:48 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id b8so5924526oti.7
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 15:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Iq1gkpVHEz387Gom/8X56uBSKGCqa4TA+SA+jctV79s=;
        b=r5YC3E3sRUKcFQ1s5h6Gjsz/denswBuwn1idqOnNTpH8a757IuRghBvh8WDPYmdqz8
         MBhxBLs7u9YJ8PcUAQ4qfPB8QrCX1C1CB3rKqnxTS5tb5Lwu039e7J0I/tL3ft/I38Hd
         JZ9V669kezEqkMqbmyqtC0cYaWeFDaq1STSsuSawsjgAhYCAd2ldn8/PqAB6lXLxZjLb
         llQEBlRaGrxGWQepaeAJj5WpB3pS25YuSVOwdD5LyXTCHbYp1oaRTInXtkfKA0cb+cRv
         DoktPEUXm0A+NN7NLjsZS25t/qB4+bASp0Vbak3fFNhXdiViRk88v6EeKMHp7Tkz8jTp
         r21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Iq1gkpVHEz387Gom/8X56uBSKGCqa4TA+SA+jctV79s=;
        b=H5OPH+7Bp8yZB/3N5R8Jq7dXEUGg0K5WJ88Wd+PCiDfhYMsR0i4ULbHJxkYYJcDQsJ
         E/drjp0S46jRiMhq7xGVokNPiX7ZHT49z7enQlSbCG/SbgJbhI0B1EQvb6Grih9nJ6gb
         PVbSmxLVC3mz+Bgt2W4LLiSTLrU1iNQc2xL7ynqOW0WJ4EQQpfdtMoYUDr7psHB3rdiu
         11vSr33PqWHJDqy4/blkwFv7QaZ1l7vIdGBY2nz9iqS/zUN0foxbvCh7Do+J9JwkHO0X
         5mMsw/LWkAktOWDHgU7kokFCqaHwPq7tNuGW/w+AtVYjuU3CkcKTWTtlLpXRdNvYPpCo
         05gQ==
X-Gm-Message-State: AOAM530EeLqJxfieOtUfcwt10BAbtFlMkzliOdWwdtTx+WOFGRFWMAL5
        AQR7q1PUrlPKtUHM3Chdd9yVl/eVpSQSCr8gZqMOjw==
X-Google-Smtp-Source: ABdhPJz/bQox8VXGGzo01NmrWUpOOra3c67gz0H6lLkJwv1Ew+qZyr9yBWf6EgOJVnRpfNPc2vQTQB+AnMHUaH5L6PQ=
X-Received: by 2002:a9d:6756:: with SMTP id w22mr13978900otm.50.1613519508054;
 Tue, 16 Feb 2021 15:51:48 -0800 (PST)
MIME-Version: 1.0
References: <20210209050047.1958473-1-daniel.diaz@linaro.org> <CAK7LNAR-OFSYERwX45gy=WyVkBBaUEVY_UBS0ZNj5T+B0a6+Xw@mail.gmail.com>
In-Reply-To: <CAK7LNAR-OFSYERwX45gy=WyVkBBaUEVY_UBS0ZNj5T+B0a6+Xw@mail.gmail.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Tue, 16 Feb 2021 17:51:36 -0600
Message-ID: <CAEUSe7_W4uGU5VQw8ibxAVgQW6MjJj0=YrHd+sCKkh76vRwuyg@mail.gmail.com>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Rolf Eike Beer <eb@emlix.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

Apologies for the delay -- Currently experiencing power/connectivity issues=
.


On Thu, 11 Feb 2021 at 01:12, Masahiro Yamada <masahiroy@kernel.org> wrote:
> I am wondering how "HOSTLDFLAGS_sign-file" and
> "HOSTLDFLAGS_extract-cert" worked for you.
> Kbuild supports HOSTLDLIBS_<target> syntax,
> but not HOSTLDFLAGS_<target>.

Thanks for the insight! The pointer you have provided are very
valuable to try to fix our problem.

What effectively happened was that LDFLAGS was removed, and therefore
the gcc line did not include one -L path that's proving difficult to
use under OpenEmbedded cross-compilations. This discussion has
provided much light in areas that are unknown to me, but so far it
looks like the fix will need to happen in the OE recipe and not in the
kernel itself.

Thanks and greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org



> I see $(HOSTLDLIBS_$(target-stem) in scripts/Makefile.host
> but failed to find $(HOSTLDFLAGS_$(target-stem)).
>
> So, presumably you will get the same result
> (OE build error will be fixed)
> even without HOSTLDFLAGS_sign-file
> or HOSTLDFLAGS_extract-cert.
>
>
>
> But, I am still wondering what the correct approach is.
>
>
>
> Basically, there are two ways to link libraries
> in non-standard paths.
>
>
>
> [1] Give linker flags via HOSTLDFLAGS
>
>    This is documented in Documentation/kbuild/kbuild.rst
>
>    HOSTLDFLAGS
>    -----------
>    Additional flags to be passed when linking host programs.
>
>
>
>
> [2] Use pkg-config
>
>
>
>
>
>
> OE already adopted [1].
>
> I think the following long lines came from HOSTLDFLAGS.
>
>     -isystem/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r=
0/recipe-sysroot-native/usr/include
> \
>     -O2 -pipe -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d=
83-r0/recipe-sysroot-native/usr/lib
> \
>     -L/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83-r0/reci=
pe-sysroot-native/lib
> \
>     -Wl,-rpath-link,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f=
250d83-r0/recipe-sysroot-native/usr/lib
> \
>     -Wl,-rpath-link,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f=
250d83-r0/recipe-sysroot-native/lib
> \
>     -Wl,-rpath,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d8=
3-r0/recipe-sysroot-native/usr/lib
> \
>     -Wl,-rpath,/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d8=
3-r0/recipe-sysroot-native/lib
> \
>     -Wl,-O1 -I/oe/build/tmp/work/MACHINE/linux/5.10+gitAUTOINC+b01f250d83=
-r0/recipe-sysroot-native/usr/include
> \
>     -I ./scripts -o scripts/extract-cert \
>
>
>
>
> But, some people are not satisfied with [1] (or do not notice it)?
>
>
> Then, 2cea4a7a1885 introduced the second one [2].
>
> Mixing [1] and [2] perhaps confuses the build system somehow?
>
>
>
>
> So, 2cea4a7a1885 was a problem, but
> I do not think this patch is the right one either.
>
> (At least, HOSTLDFLAGS_* additions are pointless)
>
>
>
>
> --
> Best Regards
> Masahiro Yamada
