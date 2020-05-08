Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFC01CBA01
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 23:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgEHVoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 17:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgEHVoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 17:44:24 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F06C061A0C
        for <stable@vger.kernel.org>; Fri,  8 May 2020 14:44:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 145so1609083pfw.13
        for <stable@vger.kernel.org>; Fri, 08 May 2020 14:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AxtRPd53F6s9hZLdQ4ERn/UEdT1uSiG5HSbNwNdvvAY=;
        b=uvhxs2CsY5g1dwiop2gnp+Vk/yGf8hlpZhvZWZ2mfjKxYA/hum3TOhnX8FROxcBj6h
         kXJuiu7n5Xvmy0T8yUtvW9ClQAXPaM6BeKitDi4DLFoeGpk4b2rlcfv2CPnGGYGx4A40
         GoENsMq2pw7qPIOsDvmPFt4ixsKXgjVzlIWwOsFok5IDMCVOj7DCKGczmfE8P4ESpW1r
         ewTFJ0TUB/+C4T1PD2JrYrTy7hh7gXksa5QzPCE6erGHPJtOHRZ0q62v7d2QUZ2vAgfn
         tALDxJUCJQ9RxilM7oAL9GsOzQnEswANKGZyY9n9h/ePDSV7sX8OAU0NQ1dWnc8UFegk
         BE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AxtRPd53F6s9hZLdQ4ERn/UEdT1uSiG5HSbNwNdvvAY=;
        b=phTwmjSJIYMJjYsuBXNS7drgVa6uYS1qq0kQ4rCX/rBU4yUwRjo24v0Wp5W0fhRz+Q
         WEP2qEd3p7lrAktqSU6yHc8eEkyt3Fo2qUwUwcmFHM7slbw++IJoYFc8pPYkNhZqxXDI
         BdNQyDndbMoyjS/G7x+MHqAzbmAIC7PXZmCR+UPc//+IMEXrgsAHQd8YNXvGZNGA9K9B
         lrh3eL/Pj/VuDV9PCHMDRGjL1Zlro/zT76D6E+QdGXPFYVHmXL9tfwouYlpi+51JY59g
         cvjd5rPef0DyAiwmpfQpCfi13MzbxBGXdUuqBA7s6co2MhYQ0+w7gNXeod9qTJK+2WrW
         Wrng==
X-Gm-Message-State: AGi0PuZj/U6VhZs7UiSB+AhbnOiMiMMK0fO+20OpjQtKdoTIjtdyWL7I
        oiAdACelZT+vCGruRczAlt/8GcUG3kg=
X-Google-Smtp-Source: APiQypIRIkP95BrwJ0S/knI41AM097wBvGC197YES+zbys96x5xLJd7ywITiSDcw9ShqQRPWFvpqDw==
X-Received: by 2002:aa7:85d3:: with SMTP id z19mr4866232pfn.215.1588974261743;
        Fri, 08 May 2020 14:44:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 131sm2011943pgg.65.2020.05.08.14.44.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 14:44:21 -0700 (PDT)
Message-ID: <5eb5d2b5.1c69fb81.31c51.7aa6@mx.google.com>
Date:   Fri, 08 May 2020 14:44:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.222-309-g1a571d63aabc
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 82 boots: 14 failed,
 59 passed with 4 offline, 4 untried/unknown,
 1 conflict (v4.4.222-309-g1a571d63aabc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 82 boots: 14 failed, 59 passed with 4 offline, =
4 untried/unknown, 1 conflict (v4.4.222-309-g1a571d63aabc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.222-309-g1a571d63aabc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.222-309-g1a571d63aabc/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.222-309-g1a571d63aabc
Git Commit: 1a571d63aabc342ca6ee6ff5ce981c45dee8e31a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 14 SoC families, 16 builds out of 190

Boot Regressions Detected:

arm:

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v4.4.222-166=
-g7ab45cabed0b - first fail: v4.4.222-321-gb1cd678a0c39)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-321-gb=
1cd678a0c39)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-321-gb=
1cd678a0c39)

    multi_v7_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.222)
          sun7i-a20-cubieboard2:
              lab-clabbe: new failure (last pass: v4.4.222)
          sun7i-a20-olinuxino-lime2:
              lab-baylibre: new failure (last pass: v4.4.222)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 90 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.22=
2-166-g7ab45cabed0b - first fail: v4.4.222-321-gb1cd678a0c39)
          sun4i-a10-olinuxino-lime:
              lab-baylibre: failing since 1 day (last pass: v4.4.222-166-g7=
ab45cabed0b - first fail: v4.4.222-321-gb1cd678a0c39)
          sun7i-a20-cubieboard2:
              lab-clabbe: failing since 1 day (last pass: v4.4.222-166-g7ab=
45cabed0b - first fail: v4.4.222-321-gb1cd678a0c39)
          sun7i-a20-olinuxino-lime2:
              lab-baylibre: failing since 1 day (last pass: v4.4.222-166-g7=
ab45cabed0b - first fail: v4.4.222-321-gb1cd678a0c39)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.222-321-gb1cd678a0=
c39)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun7i-a20-cubieboard2: 1 failed lab
            sun7i-a20-olinuxino-lime2: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun7i-a20-cubieboard2: 1 failed lab
            sun7i-a20-olinuxino-lime2: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-wandboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

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
