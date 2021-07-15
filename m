Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB033CA58A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhGOSdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGOSdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 14:33:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322B3C06175F
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 11:30:12 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id go30so10861497ejc.8
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 11:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P4slkhyczmC+CsmvM2UgLVpvSQZZhkKWHkh4TUILEXE=;
        b=u7t72vkwNVuUjuIdzMQQxelsZJQgjwbxkr7kKvbIX0HWJKas8i/P6Cdil4nG6MzfaC
         uuOEfYZ70T5m+eHwnPDkbMuY4/eat+o+C+FJrO+T2iA1bSov8ADBJBUbJxBZ3SX5pW2K
         X+kGo7Jdq2KsS3L5bYb8/wk764HFgi5d3/L/E7rqTSCEEvDVAORHJTWVihTXNmKowg73
         tbkidC84J5x6RKhEHfLBzudQlU03XVciuw8mwdIvv3WKpA8vH1N4qq08j4xl6IGkeRzd
         f7JgoAQpEzen8tzofJghog1cDmKXP5YIF57YXk+BCXqim38MZi4bla3vWqOB4QSzDCYb
         4yIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P4slkhyczmC+CsmvM2UgLVpvSQZZhkKWHkh4TUILEXE=;
        b=Aa0AI0fcy8wQq0cmKQJqvuJnHwObiLoCkQYPn1zKAlA1iGf0P9c4ZTMWJp7cno5pS4
         78ykDMA79FQVeJp2Z+mvWN8K/GwhuGqr9036Nkx/nyMYU8XU3h9qdV9TkOibzaezuYY7
         r3XvP5ymvPbzTdurVjTIEhMew7V3WGPelBE0B+OFClaNODL5ned8FmrXR+ur6g5Ycjk8
         XFlnJof2Knzgqg/+dn6M3P7EivAmLlQ3LEyknJVgM/UVpJddrj8hxiI1Pz5dJ9xUcQQF
         7uJZn/KBJww/WemcuPKNTbc8unmTZh/ejiVWzd0jhev60kUlClfkyrO2vOLTlifa63Gx
         b1Zg==
X-Gm-Message-State: AOAM533rgL7F70QjUaatnY0AYtloy3NlhyODgs9/jHpnkhzxLNLcEarI
        lrdRMO06vBJMZBa2qcx8Ig9mC6gaTmfOz5pVP7+YJQ==
X-Google-Smtp-Source: ABdhPJxQaLy1XsdrS4KyT9xCXP3hYvBvsh5UiPH1CVKYOkNBzqsRzG7PgRL+Id4F9sxNpChJFekBccig35sHgYcATzI=
X-Received: by 2002:a17:906:844d:: with SMTP id e13mr6981557ejy.503.1626373810547;
 Thu, 15 Jul 2021 11:30:10 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYud=G=NhZdCVrHbadbv2xmeUUmW9vQr_YJqSGBWtNRdfQ@mail.gmail.com>
 <YPB3CrJtAdDmnVF8@kroah.com>
In-Reply-To: <YPB3CrJtAdDmnVF8@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 15 Jul 2021 23:59:58 +0530
Message-ID: <CA+G9fYuGv1XS9bQdjpT3ONdFjvc2G-etJX+VbV-ZKfePHtt5NA@mail.gmail.com>
Subject: Re: coresight-tmc-etf.c:477:33: error: 'CORESIGHT_BARRIER_PKT_SIZE'
 undeclared (first use in this function)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Jul 2021 at 23:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jul 15, 2021 at 11:22:52PM +0530, Naresh Kamboju wrote:
> > Results from Linaro=E2=80=99s test farm.
> > Regression detected on arm and arm64 due to the following patch
> > with CONFIG_CORESIGHT=3Dy enabled,
> >
> > coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()
> > commit 5fae8a946ac2df879caf3f79a193d4766d00239b upstream.
> >
> > Build error:
> > ------------
> > drivers/hwtracing/coresight/coresight-tmc-etf.c: In function
> > 'tmc_update_etf_buffer':
> > drivers/hwtracing/coresight/coresight-tmc-etf.c:477:33: error:
> > 'CORESIGHT_BARRIER_PKT_SIZE' undeclared (first use in this function)
> >   477 |                 if (lost && i < CORESIGHT_BARRIER_PKT_SIZE) {
> >       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > ref:
> > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/14=
27834041#L384
> > https://builds.tuxbuild.com/1vMA3olyV9E6Yr1Ix0LWLlXinkv/
>
> I have no idea what tree/branch/queue this report is from :(

Sorry,
stable-rc 4.14.240-rc1.

c81cb98781af ("Linux 4.14.240-rc1") arm64 (defconfig+7) with gcc-11

steps to reproduce:
------------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1vMA3olyV9E6Yr1Ix0LWLlXinkv/config


- Naresh
