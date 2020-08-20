Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9291724C472
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 19:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgHTRYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 13:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbgHTRY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 13:24:27 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B3AC061386
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 10:24:27 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id i129so1488599vsi.3
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 10:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iroUaEDH3qLhHZROzM6zvLWq0sDrELVc2H5u2dLoE+M=;
        b=ysuZfvNBK+vx+945xNpQup3DDoyflhEeTOwMbFrEn4LOe2VWylPmGC5LxeGFhLx/hM
         WyWA1FaKOkeb8txsMW19l+uZ1gHp6wBQR5JMrIYWU4u83Pw7f9+sca8O4C9FuEL0hYVt
         ISlC2z/R2BBszftREwtEAYFdoieJ/kGRJgOZu+nEWpNTH1A0Zp2xI4qPdwaJlnHiHuMU
         1CGec2c+Jz8ZUtfX8mD6whFJg7AFl1JhYCRmmv4uUZoE8JdqcXeHgncptOTLVkt8cIdo
         58Wj0uhbGbOTfA+1eN+0eOzZBXKRfL346PdOpdItd8PQ3wdld71b4OM6HqyGiNdJPayr
         Ikgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iroUaEDH3qLhHZROzM6zvLWq0sDrELVc2H5u2dLoE+M=;
        b=PVCOibMrRKLpJ42fZpRoAmexLMGwvxOk3JfgiNuVJkfd1Fa5xwK87tIgLMs1Hq2/c8
         CcPPdrVerfSTAmV/f1O11J+z5vKaExndIWrtioBC6Vh66Zce8q0SpTjD6fDRRF+Kw0bs
         TjIpzJaJv8p2qswillFDKzmHg/5fvOAk/DZVVQb56BCADK8jFVcGeS4cNc4QQ+/2PPQ5
         DQrPbzhz1601BUgxW07M1dTNMY26HOFJnRbV9z7yxQOrP/cKD/6URgcPyrTfLaQuqXAp
         1Zpjmcs/q+IG+SXP/udzJl2Eb54T38ZAGqtSfsgd6GmyAYxrNxPU8j4Mz3zocc9J5T5Q
         uOOw==
X-Gm-Message-State: AOAM532cKcdA1VPGCeOfcLpkpCqZE1KKm8IBm1IzDtfmSMjwCNSqaYuo
        iTNyeelDQPFDUfmUjCKXkKX5qeK7cWvbH/aWBmwm6Q==
X-Google-Smtp-Source: ABdhPJych8EFwNLDllMBAz9Ls3z9qWd6lvDGbzs+rPqN/ecWzogfAUcDa8dDXOv0zFSN6WDl/ROR48gqIK+aWgsEFPI=
X-Received: by 2002:a67:ec13:: with SMTP id d19mr3064305vso.28.1597944266198;
 Thu, 20 Aug 2020 10:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200820091553.615456912@linuxfoundation.org>
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Aug 2020 22:54:14 +0530
Message-ID: <CA+G9fYt+z3Cs9Cbf8HH8o59gsUkwjuKRCZmvQQ2K5OM_ydSRHQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/152] 5.4.60-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 at 15:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.60 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.60-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: af_alg - Fix regression on empty requests

Results from Linaro=E2=80=99s test farm.
Regressions detected.

LTP crypto af_alg02 and cve-2017-17805 failed on stable-rc 5.4, 5.7 and 5.8
branches on arm, arm64, i386 and x86_64.

  ltp-crypto-tests:
    * af_alg02

  ltp-cve-tests:
    * cve-2017-17805

Summary
------------------------------------------------------------------------

kernel: 5.4.60-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 6793ee834d88110102e15d8b341347c80c91a79b
git describe: v5.4.59-153-g6793ee834d88
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.59-153-g6793ee834d88

Regressions (compared to build v5.4.59)
------------------------------------------------------------------------

  ltp-crypto-tests:
    * af_alg02

  ltp-cve-tests:
    * cve-2017-17805


--=20
Linaro LKFT
https://lkft.linaro.org
