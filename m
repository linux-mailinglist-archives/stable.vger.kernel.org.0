Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B90D1E1B62
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 08:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgEZGe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 02:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgEZGe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 02:34:26 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B68C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 23:34:26 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s10so9549023pgm.0
        for <stable@vger.kernel.org>; Mon, 25 May 2020 23:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M5wPJ6gm6rCAEYxkj2isSW8Bw+SGvmEI+2ESFeNWQTw=;
        b=cQO6lxD3/e6i7R5UFJ37YQDSF6PHzwl4BQmG8S892GbRZ5Bddm68BYv1aIOrJlVD9M
         uqUBe6NWEtX+oP8Hb5RJCwwrNr1SBYsxEcV0Jg9WRbZIi7mIeuJGBdxNWCZJ/aiHAQpT
         ABMUMivHjYj4DputqO4nvE7ER1SqrB9REzmymqf85pRW8DFYHHy+kjqt4c70uggrhtry
         hSTn8Gv63PS1wAmyKVXAJgs9l6NsJ3tyD0bsgE0aUk4paWroNOntgHg9JddDNuy95buo
         eLATwc6Y6DRORaq6zKuT7Rt1Zdyoj9xGKpezwAhUkf+f4xB7T7vtN51gkk4g8ihxBgrJ
         3mAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M5wPJ6gm6rCAEYxkj2isSW8Bw+SGvmEI+2ESFeNWQTw=;
        b=m6oWwYS8x0CdG97hBS0c1qDrayhKnoYFHNA7SxIVTvJc9D/LHC/J/CzF91Jp3hoR8R
         SydsxBpnG3E08pr6XRPM64YQkdkoPhgZzMNud/NwblWUMl7QzsQXNHCn4a2RAHpzErz7
         Qj3PwlGyzMv9C8nUuIiOVB8qOFOu4pmuqv2OuzKwt1G+/uAMgaf4FF6uewwVuCkcJAmV
         23rYW4mOvcp4HPJYbdIFZ1NMky4o4B7VDc+XHNgi7y4eibEuig5cMq8LXpL2GDNTa7Mn
         R51/73BM6pO8ev3xrI0KfZDyRICdm5fk69JUc//4CCCeAfaoCOZvVCUDPbLVrg09f3xo
         SMHQ==
X-Gm-Message-State: AOAM533VNNG2CkntmhwUzYCgz+ILlf7J5X7EQbmOYio3tnz1RqIZIjOR
        DdihsUlF4wJD2ToGIyY+W3ynTO0cB4w=
X-Google-Smtp-Source: ABdhPJy2OqSCMO4HDEEq9EEBVL4bGoF1uA/4GuzyzP0seYybzLuMoEN4Ib7CBslFZo8vdfgJb0twnQ==
X-Received: by 2002:a62:9244:: with SMTP id o65mr14135610pfd.138.1590474865353;
        Mon, 25 May 2020 23:34:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s63sm13966632pjj.16.2020.05.25.23.34.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 23:34:24 -0700 (PDT)
Message-ID: <5eccb870.1c69fb81.843b.26d8@mx.google.com>
Date:   Mon, 25 May 2020 23:34:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.42-105-g3cb79944b65a
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 161 boots: 1 failed,
 145 passed with 7 offline, 8 untried/unknown (v5.4.42-105-g3cb79944b65a)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel/v5.4.42-1=
05-g3cb79944b65a/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.4.y boot: 161 boots: 1 failed, 145 passed with 7 offline,=
 8 untried/unknown (v5.4.42-105-g3cb79944b65a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.42-105-g3cb79944b65a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.42-105-g3cb79944b65a/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.42-105-g3cb79944b65a
Git Commit: 3cb79944b65a695eeefe570faadb81f64ecad390
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 97 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.42)

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.4.41=
-148-gcac6eb2794c8 - first fail: v5.4.42)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.4.41=
-148-gcac6eb2794c8 - first fail: v5.4.42)

    multi_v7_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v5.4.42)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 107 days (last pass: v5.4=
.17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 48 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.42)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v5.4.42)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
