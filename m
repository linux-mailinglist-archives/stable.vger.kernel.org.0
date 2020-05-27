Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347A31E3DA4
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 11:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgE0JeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 05:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbgE0JeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 05:34:14 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BC7C061A0F
        for <stable@vger.kernel.org>; Wed, 27 May 2020 02:34:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id g5so99699pfm.10
        for <stable@vger.kernel.org>; Wed, 27 May 2020 02:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3lhY/YZJaPdg6WyZccMVuDbNSmdFkUxy8fpVdIcc7jU=;
        b=C4Td3937GaNYCaU/TbwAEEruw3qStp/HAf3wiCg26gnorjB33iDVCuhxtB3qt1QL/8
         L9XoBhduGsQS1n8q3/a5JJ1WK9aQqryNhOQnjd8hGuPMRPPRauV6ZQaD4hn8W447zkIn
         BJOF65++GBJBb7NhF2bffkYi6hl4xNA2uQB0XERlvtBY7O7RsBolisndTLwBgbOG+Di2
         q+1HCajba990zp3MzHEIWr2OiezlE00wjoNq4MeUBGVVjEU6kA2d0ivmg1DaBTEbrOz7
         eU+WZr+AG5RSYp1wC/TTN5m2VwI9KuaELKbI0Z7hLnafE+bYZ4CNt0ZkUuHAhOOlV6GT
         xbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3lhY/YZJaPdg6WyZccMVuDbNSmdFkUxy8fpVdIcc7jU=;
        b=c0cnhi9SaYVXPYsgCWNuMCk74N1VJy3HYuxghGDBj47YhUJf8ln6dKULvg5Urqh/oZ
         zsKc13OK6Nu/G7e4yJkWYWcKcObs6K4eNv8TrIR/7ToQPpo4LGH6UB7YU4Te6ktKRz6X
         j/JTUaToc4MTcrthRLCnk1q0H0XlNU6AhKHsJzn/ZyYuj9RThpG1v/L5qtlov+RUo5L0
         ll9NtQ+noYAGmoYDn0Yp94FZY63qTfSjxw6/8qIiXG3VXDX0myaGLEH3HK53ubAn3EHr
         Atl7Ewk90vQUwuQYHbF2aE5ZkFlDlaPE+/NbGm4odwe7Ylhxr2JVio0kkdHUmJzTU0E4
         AJeg==
X-Gm-Message-State: AOAM531TMUeIfL8ZMdRAHjQH5zif2O2Al1i8b2HSJMDXD+ivGFtybGEQ
        oKoi6QeGOmq4582RqfKGUNdde2K3QGQ=
X-Google-Smtp-Source: ABdhPJwJfDyU2guILlrBgBY7ZAwZ4E8OPDUxfTnobhhZFgizcwvp5nqqIuNkmfMMZbwl2iPLPAJovw==
X-Received: by 2002:a63:e454:: with SMTP id i20mr3151434pgk.440.1590572052910;
        Wed, 27 May 2020 02:34:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f29sm1734248pgf.63.2020.05.27.02.34.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 02:34:12 -0700 (PDT)
Message-ID: <5ece3414.1c69fb81.e4258.b41f@mx.google.com>
Date:   Wed, 27 May 2020 02:34:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.4.42-112-g00dd3347ad64
Subject: stable-rc/linux-5.4.y boot: 151 boots: 2 failed,
 139 passed with 5 offline, 5 untried/unknown (v5.4.42-112-g00dd3347ad64)
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
12-g00dd3347ad64/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.4.y boot: 151 boots: 2 failed, 139 passed with 5 offline,=
 5 untried/unknown (v5.4.42-112-g00dd3347ad64)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.42-112-g00dd3347ad64/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.42-112-g00dd3347ad64/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.42-112-g00dd3347ad64
Git Commit: 00dd3347ad64830e7d9a5a6bd3036b9537887208
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 94 unique boards, 25 SoC families, 19 builds out of 166

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.4.42-105-g3cb79944b6=
5a)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 108 days (last pass: v5.4=
.17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 49 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
