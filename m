Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FF96C2052
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 19:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCTSu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 14:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbjCTStu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 14:49:50 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60273BDBC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:42:55 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id cz11so4932074vsb.6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679337772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6qDlxgrvXVQRNB9kUbn6eufRRtTHPLdDgSZt+65vJI=;
        b=f4tYwGPHEiPX9T9NSQEefkwCMwavF0Hfvbj8MPt8OzL6EDMfSsCfBfOjHcWUPINIYO
         9ZL/1zFGenH3AzWv9GV0KXiADSzo+VifNzGX+xdaveJasZVWPs86w8AHE3037eSicsTt
         W43IW3n/QcpZBLnGR3WvNGApR8libNVl60RcIJrrrziM44R40p2A9CINpYv2KRzKMDoJ
         OkCQRcPkeAYra3fLCg2RE27/RiocXxzaspEN4Ngo+hL/I7Vxzk0GJDyy86SyNuimXbYj
         ++tKvusG3Ooqy+780AhinPAkinpjJ8vsgoBuqnLayzMZ7eLNDKSNOj4oabisOMENf/lU
         p2nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6qDlxgrvXVQRNB9kUbn6eufRRtTHPLdDgSZt+65vJI=;
        b=N61j8pHyF5ogmw+UqwAvlWzLc1b8d5xNJ+PFVF/P2IX/MW0uziXg+PyV1tPT7DHPY6
         wSgvHR/m0aVuG6fkuTevH2LKlzg8FvUwr+Th2btz1xAVYmB07Kas6iQ/1rSrfYm17kz4
         Pkh3uaxWb+hW4MBwrB+ydKJ4+WfeAd0z43ViV+JPnSTfHCsSeZhgtTDBVXWpWzGReysz
         xzCu28dCx4DjmmZ5uRF2K+heiwBq0EEifBQKVDd6e0W/TfK7F1tIhQ6mkwAF5SoFP56U
         Ct/FjJojLlqI53Gbi15VY1st6qfYKLgzJo6TIyNAm/ZAyYtvC67Knf9lPMGZJdAfptKk
         E62g==
X-Gm-Message-State: AAQBX9dQflhdaMBchac5trdG68/i7EsAE0uzqr3NSOgGhpjjoqOCVEV3
        ci87n5SptPiKtr7k4CqVsz28iGuwYJ6frCS4hYBJHw==
X-Google-Smtp-Source: AK7set/vVlTyUh2BRkhjfN5Eql28JK/M5ok9ZONQir0aJp4DhxnNQlA6ExlGsyH5oMhXl2OBLvkb746J5x0qgMXmI+w=
X-Received: by 2002:a67:c01c:0:b0:402:9b84:1be4 with SMTP id
 v28-20020a67c01c000000b004029b841be4mr4451vsi.6.1679337771950; Mon, 20 Mar
 2023 11:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230320145507.420176832@linuxfoundation.org>
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Mar 2023 00:12:40 +0530
Message-ID: <CA+G9fYtCtfSqrje=1wkw1ODpnJorDMFkB1bSVexpyc4gi3X0ZQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        llvm@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions on PowerPC build failures.

> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/64: Set default CPU in Kconfig
>

We see PowerPC build failures with Clang 16 and nightly on the
following configurations:
* cell_defconfig
* ppc64e_defconfig
* tqm8xx_defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Error messages respectively:
-----8<-----
error: unknown target CPU 'cell'
note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
powerpc64, ppc64, powerpc64le, ppc64le, future
----->8-----

-----8<-----
error: unknown target CPU 'e500mc64'
note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
powerpc64, ppc64, powerpc64le, ppc64le, future
----->8-----

-----8<-----
error: unknown target CPU '860'
note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
powerpc64, ppc64, powerpc64le, ppc64le, future
----->8-----

The bisection pointed to this commit,
  45f7091aac35 ("powerpc/64: Set default CPU in Kconfig")


Follow up fix patch is here as per Christophe Leroy comments,
 powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG


--
Linaro LKFT
https://lkft.linaro.org
