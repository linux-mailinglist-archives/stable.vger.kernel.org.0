Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A837624C22F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgHTP2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 11:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgHTP2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 11:28:10 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35915C061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 08:28:10 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id i129so1279165vsi.3
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 08:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uYPF26fOsnSxq0X3BeFPOk0SUrFLHUyRFGGzgVJXfq8=;
        b=yL9tqtIiWrwVP/vk+PNTbPQudFqQ/Nku03VDHttP1IrTMx970xW8h0wDtHQ7KNfK+I
         SWrGQnvnwuRocjuXw6z77wNdi8Nvhd5I+47g+pDfhaHGkxBrHs04+0q9VRPmUi9bTZlD
         CyuWwq4cV7pUsyLb2cOjDle8eG+aggRgOAFAwDs0D6Ae1uZ927VlLwHo6AXcdIyZePh4
         js71qeG+n+b7/7Iy3nieGkp+iWW2pfeTaKbyCK8OA2Kn/JfDUMbsjTIKuFqRsGkM8i0J
         MEXNsxeYZg2U1hetwLztffdgRucy6cAy8re+dFL3IgCy2CgB5p/DZOVQRHd3lgEY8iS1
         WySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uYPF26fOsnSxq0X3BeFPOk0SUrFLHUyRFGGzgVJXfq8=;
        b=OVpH9SXWJRwnRaAclvrp3C13l8DCM5v+F+tAx47sxpdJiJPERjpCtKA4SmzF5hEU0U
         K7Dlilqa8vhqFNQR95mK2Wep1rMuAMbjWzTBzkQR5IAzn6wB/66dcER/QWgt2cFjpA9C
         4La2cET1OHaC1HRtiJc8Twe2PMcyG8bxTeJiWcVdLqPKRmJwx+B/b9l+sNo3GK01LO1z
         nx08z8qB5yttX9cVu8J3AyzghRagri+2PhZZKXVb/mgfG8STwmQ+f3w22dVaJsiQxvT3
         nrDfLV7DwjvvZtxuE2DX2w94OXL0c+C98d/5E3EEZ7bkA3K7ahULf0qcgD9YoDgIHLe2
         jZOw==
X-Gm-Message-State: AOAM531t1yC2Jchj1CeOfTZeQ3VsJM95/DvNNDkuTzqZ3WdqFCUFHHXM
        BO6+XbJ/D3xXn5ZSXVA9aXhXc1Ipa3cezAKE9nhFHQ==
X-Google-Smtp-Source: ABdhPJw3x/JjWeGkqsHzLhjFeoMAMLmCjvIghKiFM19pnVR2pzadjfWz1sl+deP5Pc9dZd8e9wEdeR0iwIOlz36At6A=
X-Received: by 2002:a67:e45:: with SMTP id 66mr2349582vso.191.1597937289189;
 Thu, 20 Aug 2020 08:28:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200820091612.692383444@linuxfoundation.org>
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Aug 2020 20:57:57 +0530
Message-ID: <CA+G9fYtebf78TH-XpqArunHc1L6s9mHdLEbpY1EY9tSyDjp=sg@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/232] 5.8.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LTP List <ltp@lists.linux.it>,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 at 14:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.3 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: af_alg - Fix regression on empty requests

Results from Linaro=E2=80=99s test farm.
Regressions detected.

  ltp-crypto-tests:
    * af_alg02
  ltp-cve-tests:
    * cve-2017-17805

af_alg02.c:52: BROK: Timed out while reading from request socket.
We are running the LTP 20200515 tag released test suite.
 https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/cry=
pto/af_alg02.c

Summary
------------------------------------------------------------------------

kernel: 5.8.3-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 201fff807310ce10485bcff294d47be95f3769eb
git describe: v5.8.2-233-g201fff807310
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8.2-233-g201fff807310

Regressions (compared to build v5.8.2)
------------------------------------------------------------------------

x15:
  ltp-crypto-tests:
    * af_alg02

  ltp-cve-tests:
    * cve-2017-17805


--=20
Linaro LKFT
https://lkft.linaro.org
