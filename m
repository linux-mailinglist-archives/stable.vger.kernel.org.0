Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0911303BAB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392508AbhAZLbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731145AbhAZL3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:29:46 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3359EC06174A
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:29:06 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gx5so22429341ejb.7
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oDB3T8AKpEpg3Xybzk0fb/WX7K9m2Ab08PpSD6fK2oo=;
        b=WhKtObgnJL0l9MTJ6hWjxZ+EyPAuSjKMHED24swRKzpS5V0BNlOUPxBGILTfsx69BI
         FU3T6RDJivkFQpE/ym6qOcuvAmgjkFvCfG4Fir1JmccMKLm9aNauKZLhUeg2iXgMBOf1
         cpmoqqj5XMuCUZgYgCe2UkcM8rRadPKFtoF1eKtK1i37llsw7XnY8iBcq4KaDJeJ6Mwm
         RkthqEJhQwkXeWgv0lAMWzmRFJVOJfGBDbLB35f8vW/qsQyrOqxu50cCd/BxFobozf4M
         zvxcBa7HMEMYzBtvKI4SPn0PpUHWuhY5N+OTL3sB+zsR0r0Ka32XI4mDPRpL4Yh1byws
         xJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDB3T8AKpEpg3Xybzk0fb/WX7K9m2Ab08PpSD6fK2oo=;
        b=Ib/mtXf11aLJ9krWfO8fPGWvfYPf+FzyXm6w8t9I+Uu4l6kCuM8lpggDQTgILgoON+
         jKBjEcM+KyEhL6LxMvWFbAplZnwSp6/vh81W0iIUk/pVrjdimge5atnXROYr325ibr/E
         myuLC8mxSyvciM7ZDEk4N5oPTXOF/kHgeMCyZaM/rWcsNXSRemb5b7K9gBp88l5mWXSO
         1lFVy8pXYlKJCeXP3dhRe6VMRnpvM3oxaSjydvORXgbmWLzm1/t6PTd5BT13MDfznWMB
         4yieXulwJtpzCWIeZsjjf3rSm01U79r/U2pjJP24693b54zUcOYKumOCETMAz6qkUcyI
         vxBw==
X-Gm-Message-State: AOAM5325apdHXJXHqMrbu3LWxfsHCsoPT8uxbWXXPUTDXz4kOsAWxSfg
        Xb1g3sMCFWunidaEHKdysDDnd64Vq1OT3MkQ5lJr1lQUsdB++Q==
X-Google-Smtp-Source: ABdhPJzY9SmvC6FZ4r/vpqAwZYizcvSQItU221qIVJ2NGUUEYNH8RFkuLEiZicyyCSq67MmnNYpZNrcd4bxbrFqNrv8=
X-Received: by 2002:a17:906:796:: with SMTP id l22mr3183686ejc.247.1611660544861;
 Tue, 26 Jan 2021 03:29:04 -0800 (PST)
MIME-Version: 1.0
References: <20210126094301.457437398@linuxfoundation.org> <CA+G9fYtqJDKOwFGevaOmmK7gbKgo61CpL70yyG2daOxvRp5FSQ@mail.gmail.com>
 <YA/6KP4DNVkpSBA5@kroah.com>
In-Reply-To: <YA/6KP4DNVkpSBA5@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Jan 2021 16:58:53 +0530
Message-ID: <CA+G9fYsvMq0W-4gSq4=D8at+J286vSzTx6SavSLjOpNoW8UUkQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/88] 5.4.93-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, sagar.kadam@sifive.com,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Jan 2021 at 16:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 26, 2021 at 04:43:51PM +0530, Naresh Kamboju wrote:
> > On Tue, 26 Jan 2021 at 15:33, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.4.93 release.
> > > There are 88 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 28 Jan 2021 09:42:44 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.93-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > As Daniel pointed in the other email thread,
> > riscv failed build:
> >      * clang-10-defconfig -  FAILED
> >      * clang-11-defconfig -  FAILED
> >      * gcc-8-defconfig -  FAILED
> >      * gcc-9-defconfig -  FAILED
> >      * gcc-10-defconfig -  FAILED
> >
> > the riscv build failed due to the below commit.
> >
> > > Sagar Shrikant Kadam <sagar.kadam@sifive.com>
> > >     dts: phy: add GPIO number and active state used for phy reset
> >
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=riscv
> > CROSS_COMPILE=riscv64-linux-gnu- 'CC=sccache riscv64-linux-gnu-gcc'
> > 'HOSTCC=sccache gcc'
> > arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts:88.27-28 syntax error
> > FATAL ERROR: Unable to parse input tree
> >
> > Build log,
> > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/986616680
>
> Crap, forgot that one.  Will go drop it now and push out a -rc3.  Is
> this an issue for 5.10.y?

No.
5.10 builds are successful.

- Naresh
