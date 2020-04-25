Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5577A1B87B0
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 18:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgDYQX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 12:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgDYQX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 12:23:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF76C09B04D
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 09:23:56 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so5209544pjh.2
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 09:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AZGqElrQ8f9p8FmjY7z8snRL50XLy5yPOmroe9vS1t8=;
        b=peZNv2bTxqk3/XLwusjFcbJ7wU1gzPWOY5DUEK6zrSRHc3b9631XFuV16WVBkngczv
         ikGSy0SXtlON4zITPHnhpfY4272ckjhuxw7wsVnNhgbVbw4sbaGUmHkaEXxoarMwAnvj
         FD0eqd2xf6UVRH+zP0ZuHOrgTRSCqLdcuoHp4y9wZG+o0VmKHwtT71FdJU/k3uJZczgQ
         ASYmBoqaf3lHK7Sjj+Ouar8KIQ2UH1MdtU2fr4U0vAkHWGaCp/IsJ1BvbfSbBY2zH8xL
         dZ5tdqXF/rapBHJO1dImwRq8vGLdWW29qLv+vY+1W8imouUKZLjnayaPfdw0sSU+Tsqq
         XP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AZGqElrQ8f9p8FmjY7z8snRL50XLy5yPOmroe9vS1t8=;
        b=FIVNvo2z1Sq5g4gJlcbphvBwbHzf0f8qFC4+jIPz0KWkdr6PaPxZAX+8nlNGLAsG9t
         Cr16lFgCMh5n/yvQn3NXIB6dHWfR0zo1jGtiLkjbTEghpGHXMBlxwY6BTMiXp3vSbMbD
         izXTq6Prrq44lVDQ9k7WE9uu775rRCmqa2lrbmojbnQxJHVsK5zWVM/imOon2dLE5KCX
         0SJqK55yZTU1Sns/bDcqPqN6N94ph/0AIx8o1AGoUQ9/g44vUQ7luXGYyxj70sFXpi0p
         yKPgPsUKGKKfMDEPYZWD+9E+ykYRlTcYFUx7gqo2qWcMNEimovOnXdwI63X3/ULiMQpc
         zR8w==
X-Gm-Message-State: AGi0Pub9qXdP2G4HRtJz5JjQVKfg7SujnTVwQczI2HBj06PgZlfLm7cX
        XSWXF+Wf0O8X2lXuyPTVmmgzs+d4G9Q=
X-Google-Smtp-Source: APiQypIDC+QjuexEZxhFyfIqYRutVJ6QVuC5xDL/n3CzYPLeD8P4HbSIrHaJtEAhNyJsMAtXMOzilg==
X-Received: by 2002:a17:90b:1104:: with SMTP id gi4mr13702525pjb.115.1587831835239;
        Sat, 25 Apr 2020 09:23:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l1sm7416495pjr.17.2020.04.25.09.23.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2020 09:23:54 -0700 (PDT)
Message-ID: <5ea4641a.1c69fb81.3fa7a.8924@mx.google.com>
Date:   Sat, 25 Apr 2020 09:23:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.220
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 91 boots: 3 failed,
 77 passed with 6 offline, 4 untried/unknown, 1 conflict (v4.4.220)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 3 failed, 77 passed with 6 offline, 4=
 untried/unknown, 1 conflict (v4.4.220)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.220/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.220/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.220
Git Commit: 5efe91c00c98c72cbe8475caa6e72c520199e32b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.2=
19-83-g20fbd20eb91a - first fail: v4.4.219-101-gacb152478366)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.2=
19-83-g20fbd20eb91a - first fail: v4.4.219-101-gacb152478366)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 77 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 30 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.219-101-gacb152478=
366)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
