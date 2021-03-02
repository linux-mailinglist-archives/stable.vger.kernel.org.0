Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB83232AEEA
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhCCAIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382702AbhCBJv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 04:51:59 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EB6C061794
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 01:50:45 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id c10so7520993ejx.9
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 01:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5hxO8geRKHzNtxA9y8z7MoBEUJzs0Nb88tjxqpIWGmE=;
        b=ntP+ugCJeq/Nswd5B80CT/rGJ7OiG/heEnQUO+CvJ8S5nzSAB0Jjv7gbFPKtQFdtgY
         UGkA1r/XS8UmHNHg1+UBJdB2/rI/+SFu+hwskOhJuV0rKRHSZ9YddwrZqj/N9sAzLFnd
         b+mP/HypjVWLhrP9oImLXl8op+D5xCo2qV4x8h31Z57APSxsEO3MTikg+gHyn0AicN8T
         cV98ROiUZv0tUBZxpAZwtOx/yfmprwtiFb9VP3Wv8rNLTbzD5JnBqSa7VOc/P1e4oMSi
         fBqn4sucdXrg0qXBQlMulbzrw2o5pxkZ0kYVa6V/Ta21olXTsob+BUurnnV1pHlvvIq5
         v+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5hxO8geRKHzNtxA9y8z7MoBEUJzs0Nb88tjxqpIWGmE=;
        b=musYaMTu2B7ROAx9E1pXfxSrT4qJw9He9haCfSlmUYdRMpx7CzjcMbBbYoH2N5fpTR
         agiY+1ERoAcmiwaEsOn3ph7ge9B3fEvAUBDhxB+YkrW7ZrrdzLEYXK+Op/EQnUndlGFx
         nPqr1CJZ8Ui0BIKyvUlB1NMOf6nzvOz5rSv+MmGEiRF9gWD6NJCIxYE6xXtgXrv4r148
         zMGtsUL7bOx1aPgMFb6dOaRmHxY3rdzPNWKDaUeW8/OZjfxrATu1GBEx4WTm8ddT+hf0
         nFknblp/czUCRjF51ne0NX4CSlleB3Duy7azDqIUaYdtKFWbZvtlpJX8gCy9xnr7SSor
         KvgQ==
X-Gm-Message-State: AOAM530EHaYmo0PeDnpJ/iPUBkWy5N2GEYfKC33wm9m/bF2MJGV70icG
        D3/HAwolbMEO7OexKaRP3LWXWBghW8MPlsWEgxsfxA==
X-Google-Smtp-Source: ABdhPJzzRBsP3yJj7bEN/TJZ8X9qd/bTeDJ0LE+/H87gPbR1wkDmLEE25vLUJaPk0WmkiFVMQSEslUMSynFO1/qPjVU=
X-Received: by 2002:a17:906:444d:: with SMTP id i13mr19536087ejp.170.1614678643555;
 Tue, 02 Mar 2021 01:50:43 -0800 (PST)
MIME-Version: 1.0
References: <20210301193642.707301430@linuxfoundation.org> <CA+G9fYuK0k0FsnSk4egKOO=B0pV80bjp+f5E-0xPOfbPugQPxg@mail.gmail.com>
In-Reply-To: <CA+G9fYuK0k0FsnSk4egKOO=B0pV80bjp+f5E-0xPOfbPugQPxg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Mar 2021 15:20:32 +0530
Message-ID: <CA+G9fYsivUPRRQgMXpnA_XdXH8i2wx_DPH70t+6OzHkjOaswrg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Slaby <jirislaby@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Linus,

On Tue, 2 Mar 2021 at 12:45, Naresh Kamboju <naresh.kamboju@linaro.org> wro=
te:
>
> On Tue, 2 Mar 2021 at 01:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 661 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.20-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Results from Linaro=E2=80=99s test farm.
> Regressions detected on all devices (arm64, arm, x86_64 and i386).
>
> hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3
>
> This failure is specific to stable-rc 5.10 and 5.11.
> Test PASS on mainline and Linux next kernel.
>

I have reverted these two patches and the test case got PASS
on Linux version 5.10.20-rc2.

hangup01 1 TPASS : child process exited with status 0

   Linus Torvalds <torvalds@linux-foundation.org>
       tty: implement read_iter

   Linus Torvalds <torvalds@linux-foundation.org>
       tty: convert tty_ldisc_ops 'read()' function to take a kernel pointe=
r

ref:
https://lkft.validation.linaro.org/scheduler/job/2330549#L1667
https://lkft.validation.linaro.org/scheduler/job/2330550#L1202

- Naresh
