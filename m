Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFA3328B6F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239973AbhCASe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239890AbhCAS1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 13:27:16 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAA9C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 10:26:00 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id bd6so8826015edb.10
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 10:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D2LYrhH4WHun5wrLVRpHgV6pghMUFy/mvj63NSZdAow=;
        b=jvRx2+7oXVgQ+b4Dl2F8Vj7JBvnizff4zkOvqLNdR1y8bMS/SNStpcijkyzotitQo5
         X0Bknz4zUCfWAKUQWf/mGHQ4ZgB1J5poOXWBcsQ5LMlbK5wTiFVse6y9PBfwDdrEJ5Ea
         rtYatNzpntXmA80OX3185GMnqmeX695Kvi4QLm/GcMWPUW74EeVZv4gLWYxokhfF0SNW
         NPOl+dhPMwFsgSbfIWtqWzFB/VC0DOaxYXEY7FHn0Qr/VvnM5XXIqdMAIToqIWHnMZrF
         ZtA3W4FKPBofOKhXquSH3OACh8zkjaBff8F90Mrs2NOIILMusOtThTp0Dmxi+w0NA6R+
         lIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D2LYrhH4WHun5wrLVRpHgV6pghMUFy/mvj63NSZdAow=;
        b=KgBjzJdL/R6UUxrjJk46/E1KTd1D/kSwdfoGtDw45n32j0aQH67WlLLbTRAYKCivFg
         oFGHtecVkUl3t0mAVVaHZ6u7CdANDavGCJlRgJ1EgYrovL/PhA0oSAr+0NzOHURL8+KA
         U0TaiTtswB5IVkmVmWUwWYF3MEwTD/1OOXpur7zR62ie3ov7twGVjF+9gjNjjZhqs59q
         YaRLbtN0PGCp6OjNjGCx74X72zy2PIPm7mefq4UT3L2WapxZ8YNxGluAN1YMARIRkOxp
         l3fhHdiXDHatwezoSwwnTNfEOWPsOtcUR9KhqThyi8ksyzXN8gxMG6wU+XsgyolurwcE
         bQRw==
X-Gm-Message-State: AOAM532HcVQe42Sjhjgy3PQcCIs01yTTV+VGjL9Jn0nrtpLjn1O1ir8Q
        /kAn5lF+FUg3wszEA+cw5fTjyaBZjNzE1V2M/D3jfA==
X-Google-Smtp-Source: ABdhPJzDIWQ1vPuPUrfgqBcy94TpxqmsqNAn8qqvpVbhSvU/U5uxx1EFvmTu45EOpiJsu3oW3OUur1GYcpR9HBSXN10=
X-Received: by 2002:aa7:cb0d:: with SMTP id s13mr17439251edt.221.1614623158879;
 Mon, 01 Mar 2021 10:25:58 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYufUB394TpDuO5-m2GEi=1LDZvsVcHmp-HyWbWV1tYjkA@mail.gmail.com>
In-Reply-To: <CA+G9fYufUB394TpDuO5-m2GEi=1LDZvsVcHmp-HyWbWV1tYjkA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Mar 2021 23:55:47 +0530
Message-ID: <CA+G9fYtJOq0MaVMVNWusUPQeEE==9ArSfeMP=dwd=Mda3N+d9w@mail.gmail.com>
Subject: Re: sun4i-ss-cipher.c:139:4: error: implicit declaration of function
 'kfree_sensitive'; did you mean 'kvfree_sensitive'?
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Mar 2021 at 22:54, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On stable rc 4.19 arm build failed due to below error.
> the config file link provided.

These build failures were also noticed on stable rc 4.14, 4.19 and 5.4
for arm architecture.

>
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In function 'sun4i_ss_opti_poll':
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:139:4: error: implicit
> declaration of function 'kfree_sensitive'; did you mean
> 'kvfree_sensitive'? [-Werror=implicit-function-declaration]
>   139 |    kfree_sensitive(backup_iv);
>       |    ^~~~~~~~~~~~~~~
>       |    kvfree_sensitive
> cc1: some warnings being treated as errors
> make[4]: *** [scripts/Makefile.build:304:
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.o] Error 1
> make[4]: Target '__build' not remade because of errors.
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> ref:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064179234#L462
>
> confg:
> https://builds.tuxbuild.com/1pAEVBwRxCDBXf85dL6Kki6o8Yf/config
>
>
> steps to reproduce:
>
> # TuxMake is a command line tool and Python library that provides
> # portable and repeatable Linux kernel builds across a variety of
> # architectures, toolchains, kernel configurations, and make targets.
> #
> # TuxMake supports the concept of runtimes.
> # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> # that you install podman or docker on your system.
> #
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
>
>
> tuxmake --runtime podman --target-arch arm --toolchain gcc-9 --kconfig
> defconfig --kconfig-add
> https://builds.tuxbuild.com/1pAEVBwRxCDBXf85dL6Kki6o8Yf/config
>
> --
> Linaro LKFT
> https://lkft.linaro.org
