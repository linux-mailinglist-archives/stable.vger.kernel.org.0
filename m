Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544F11D9117
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 09:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgESHar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 03:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgESHar (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 03:30:47 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7D0C061A0C
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:30:46 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n11so5982186pgl.9
        for <stable@vger.kernel.org>; Tue, 19 May 2020 00:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BOmuz2r7A7J1MAZ/Q+d4MjLRIzoJJmLc7Y0dvtveH90=;
        b=fzPWR1WZOByLVXVQ63JdeDZBh2q+Pl/AfEa+zZuSEnREGJqH1am3e+ck1e1HrL/S9n
         PfCwd2aMo2ChP3GqRN8tN8XWouQikAhDd5qzvSyvwbGXsM//xq2K4MUW0sFsDntMRSKi
         MdV82F2mv4LrkrJumY0VFHg0wDw5C9n7tjCMUP5jdqWnXathStbiCa1g0t+R9NjjDcek
         OV6RZ9SVUJSYfPbygzCc1ElG9QhO4cRFj6sEBTfDdkVw+7h+CuX/4QphE50u3qv55EUH
         SSY2jBLEOciZvLBcpMl3MVsqjfgOAi/z9FycZ/tI0C61c17Dt/hJE74wbIQ32dZcaffw
         axjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BOmuz2r7A7J1MAZ/Q+d4MjLRIzoJJmLc7Y0dvtveH90=;
        b=i4hpeVRnAHTQqmuyqlpPTUwpkWn0MnKxL7K6mrZGxbta2On+Pk7+moUniU2bhZaIiA
         kj5XsiwpeXBVk7Je/rzRwWokzUqp689yHwKjLVtkb4FuLfGua0A13MoRaujQ6gH6ua5f
         pSx2xuwao92yXkRsUBCuV+XpD8+D3ijhCH1dzN9IorDXoJtf1QTsJerY86dGSrv0KFOW
         gIhUxiyOsGNcpa6gswdbjZkgOEkznBKt/67Ixl9jvuyDlBUt5ltTLKbm8H4ZVAZESjRx
         vBWt6OtEr5ph8kdtS4557YXtsEr8cbxzlSXM2sHlLQR+bDe5aUPLJ7WZNANLMOh947Fg
         Wz+A==
X-Gm-Message-State: AOAM533mj09ZwiQ8l+PDrKkbo1Jh5lMspEofWcOYGOpLFhA1NofNgZig
        R2Ig7eLjV+2kQH8DhoyJuwblcLiPWjk=
X-Google-Smtp-Source: ABdhPJxaDxReKrFYTyn3N2UKpHmOdOwdlRvRIJDD5aqNioWPfg8jvxoxP7W4FFaQAoW8u7fgYGJOLA==
X-Received: by 2002:aa7:8dc1:: with SMTP id j1mr20819335pfr.285.1589873445851;
        Tue, 19 May 2020 00:30:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm10254436pff.62.2020.05.19.00.30.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 00:30:44 -0700 (PDT)
Message-ID: <5ec38b24.1c69fb81.bb7b6.edf7@mx.google.com>
Date:   Tue, 19 May 2020 00:30:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.180-115-g53d55a576a17
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 131 boots: 3 failed,
 117 passed with 5 offline, 6 untried/unknown (v4.14.180-115-g53d55a576a17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.18=
0-115-g53d55a576a17/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.14.y boot: 131 boots: 3 failed, 117 passed with 5 offline=
, 6 untried/unknown (v4.14.180-115-g53d55a576a17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.180-115-g53d55a576a17/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.180-115-g53d55a576a17/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.180-115-g53d55a576a17
Git Commit: 53d55a576a17377e7713aa3aaeee0f35b06a1f73
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.14.=
180 - first fail: v4.14.180-37-gad4fc99d1989)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 89 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.14.180-49-g7ab962eff=
016)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.180-49-g7ab962ef=
f016)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
