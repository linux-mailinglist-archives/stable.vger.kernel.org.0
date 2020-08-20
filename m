Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F0B24C438
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgHTRK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 13:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730321AbgHTRGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 13:06:54 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2344C061343
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 10:05:08 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id x2so575468vkd.8
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 10:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QMaiGT30LKtLlawZDaTsiOOUCyQJdWMlHkzyfdww7TU=;
        b=voVLMNwyYF5yt8ORXHFmegDJzN5i/p3XveW33+kSdXDEUpjgd3givYskKk18LZY8Tj
         qQGmwS6j0hJFw3+1G4/PnVK987gG4zKKFrg5An2mCffuBiFtjPIznPJfaGmMzvO+Xc91
         nfd7nJ57RyhHu4hIUdIP1snE38pYxGDi/Y+CHYrhEFEJ/C0B8kf3L+3Y2ZBAGCwSBv+J
         o0VyszodTpvhY5HFlY5/A/KU8JGyGEppW09peiWZVYDJ+r9hynM+ydaTijpmTQ083Zjs
         O8hVFJFVls1ohPR0CgMLzH+r7H8W7xji7vUYhRQxZZ+VRk01BAcAT9PwGPV5YLyKKJ5L
         hcfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QMaiGT30LKtLlawZDaTsiOOUCyQJdWMlHkzyfdww7TU=;
        b=r7tti3AmC+ASbdPRzMoLdSExdJCNH/i23PtyCX8OEXACMV/WdC7WI1/ls7/ROSpesT
         UDCe/Z5j0cG5BePqJxYM7uS5BeEo2BLJ2lIUxp4grirhPW0BqXdA1Fsh7BdX1Gd9m3Yx
         HXdqnOxrvOHPdeTGZhaSxoVjIKO9uFFLqhtuXaAxPt/GM2czy1r7Yhjb27cPsC9ngvoz
         dGwS+Gw2sDEKA5YR98J5QJMUjffD6xFg4DW5CcI9Wgnc310rTG0Np65J2dpOhfYmQLng
         oFk2KEMQ+bUegno25Sp8zDQMV6pvsPmESZzGk8e60ktAUIf9pZr3ASD6BiF/Q9lbYUyl
         vB8A==
X-Gm-Message-State: AOAM530ov8AIrz22TEcku0xeo/aC4Ha29VYRPttYlBnb7wcSt/uE55va
        4BzIzNcEBlSILgHqtfPmT3zwSKW3R/7WDicYEZM/ig==
X-Google-Smtp-Source: ABdhPJw0AHuWD8nNz3mjjHi8gb99GyFZmSI4fWRyfdqag2g9dEVL/BfYYPFVIqjS+RfYFDwHH/CT26r95B95gLAwdSM=
X-Received: by 2002:a1f:a256:: with SMTP id l83mr2291083vke.78.1597943105094;
 Thu, 20 Aug 2020 10:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200820091606.194320503@linuxfoundation.org>
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Aug 2020 22:34:53 +0530
Message-ID: <CA+G9fYuCgzAOZw6iM6sLwJP9=0wrO0WcTHLCQtEHWQB9=WCuSw@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/204] 5.7.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 at 15:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.17 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: af_alg - Fix regression on empty requests

Results from Linaro=E2=80=99s test farm.
Regressions detected.

LTP crypto af_alg02 and cve-2017-17805 failed on stable-rc 5.7 and 5.8
branches on arm, arm64, i386 and x86_64.

  ltp-crypto-tests:
    * af_alg02

  ltp-cve-tests:
    * cve-2017-17805

Summary
------------------------------------------------------------------------

kernel: 5.7.17-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: 7366707e7e9962245a618a0aee04c22ab31115c2
git describe: v5.7.16-205-g7366707e7e99
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.16-205-g7366707e7e99

Regressions (compared to build v5.7.16)
------------------------------------------------------------------------
  ltp-crypto-tests:
    * af_alg02

  ltp-cve-tests:
    * cve-2017-17805

--=20
Linaro LKFT
https://lkft.linaro.org
