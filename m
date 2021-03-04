Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DAE32D91C
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 18:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhCDR5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 12:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbhCDR45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 12:56:57 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1A1C061756
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 09:56:17 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id w1so51168906ejf.11
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 09:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+ruJecJd7EOFEws1Yrx7o1yatnr4qLLm/7nk+06U75U=;
        b=p5otBQGQwZYOnbYxbE1LdapAvezxmx+V5fGRlF421cgoSCo6xcD1/dmcfgI6dBVpi8
         6/8ye2TPBofCuZmw4gCzcM6ymilKi8imi8/pjipCP32SPRILqzczclIe1Q42jRqRHzfP
         jDu6EC4OkucFLFF0cmwtITipIlJc9qECmgI6BAG0+8h1dmwX/gBNu4fxXKrOchE1BJgG
         IkvLr6B4mJZ89YQGuEFzS+QpLSh74OQ76HMGLMmZA1lA1VEWfeNUnwhxg4wKQ0+EfTNt
         uK5mNMZVK9bmcVncc0Zl24PJMlUdnFoww/b4P4DvT1ffjAEtsWKLvf4krHBZdMzhPsOu
         9Mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+ruJecJd7EOFEws1Yrx7o1yatnr4qLLm/7nk+06U75U=;
        b=MgubL85HozbapqGI6pvpK21OoG6sCL7nJmDenOx25waqb1kwTf8QZ+1EaNIPX+8Rce
         3vne4JxLy3k6gfyP/Q/gFbpd9s+hXx4YJIIM41zGb6JSAqHpxmr30bbwMss5A6bgWd0p
         O6gj6IcwgfbsDSifII+F27cBqMX80W7hwpS/NbPFXsmO8RT+DjJzVmpYFUtPqyaRgROK
         P40FgiIzIlSuAv5keIJO2MvJkFBNH4NObjCQRcYJrEvrE7fpRyHiaSWTf2h3hKiCvsLa
         rUVocvtwVTPKzVYkbRq1vSj0v8B3UJ8Ro4/fvCCBGueNmi02bSZJdAsA9ipqiyzYVLg+
         +slw==
X-Gm-Message-State: AOAM533FXTKprPqLJVo3FVSS0DxfVnhwWm3NTX3o/Pc/bksAEQqb8qaQ
        9/mUfrhio8Y1rdedNy8iFi+1nCqjeSgKsJAWU6POPA==
X-Google-Smtp-Source: ABdhPJwIjY1L+21KRQRTMStDHQsUGdaStrDDtkG8oceZVy++aoNpEhRoYb+ehu9LSGDL09wN2Htg64qWKhJJVaS7m18=
X-Received: by 2002:a17:906:229b:: with SMTP id p27mr5712013eja.287.1614880575956;
 Thu, 04 Mar 2021 09:56:15 -0800 (PST)
MIME-Version: 1.0
References: <20210302192700.399054668@linuxfoundation.org> <CA+G9fYsA7U7rzd=yGYQ=uWViY3_dXc4iY_pC-DM1K3R+gac19g@mail.gmail.com>
 <175fac9c-ac3f-bd82-9e5d-2c2970cfc519@roeck-us.net>
In-Reply-To: <175fac9c-ac3f-bd82-9e5d-2c2970cfc519@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 4 Mar 2021 23:26:04 +0530
Message-ID: <CA+G9fYtkrAs=ASaVVu6-Lnck8A6Pt_LGODxnpTYouvppbw_rbQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 4 Mar 2021 at 01:34, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 3/3/21 8:12 AM, Naresh Kamboju wrote:
> > On Wed, 3 Mar 2021 at 00:59, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> This is the start of the stable review cycle for the 5.10.20 release.
> >> There are 657 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, pleas=
e
> >> let me know.
> >>
> >> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pat=
ch-5.10.20-rc4.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git linux-5.10.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> >
> > Results from Linaro=E2=80=99s test farm.
> > All our builds are getting PASS now.
> > But,
> > Regressions detected on all devices (arm64, arm, x86_64 and i386).
> > LTP pty test case hangup01 failed on all devices
> >
> > hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > This failure is specific to stable-rc v5.10.20-rc4 and v5.11.3-rc3
> > Test PASS on the v5.12-rc1 mainline and Linux next kernel.
> >
> > Following two commits caused this test failure,
> >
> >    Linus Torvalds <torvalds@linux-foundation.org>
> >        tty: implement read_iter
> >
> >    Linus Torvalds <torvalds@linux-foundation.org>
> >        tty: convert tty_ldisc_ops 'read()' function to take a kernel po=
inter
> >
>
> Upstream has:
>
> e71a8d5cf4b4 tty: fix up iterate_tty_read() EOVERFLOW handling
> ddc5fda74561 tty: fix up hung_up_tty_read() conversion
>
> Those are not present in v5.10.20-rc4, which may possibly
> explain the problem.

I have applied these two patches and the reported problem did not solve.

- Naresh
