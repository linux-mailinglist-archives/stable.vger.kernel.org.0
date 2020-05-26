Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F991E21B4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 14:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbgEZMRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 08:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731453AbgEZMRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 08:17:33 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59599C03E96D
        for <stable@vger.kernel.org>; Tue, 26 May 2020 05:17:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v2so5032502pfv.7
        for <stable@vger.kernel.org>; Tue, 26 May 2020 05:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0kVmE9v1Y37Py/EkUk6KvrUH6lzwL+wSbh5MS45MAac=;
        b=mIjxEEy8k7hgkRbxZbH+z2GOVrpXjFiriYR1yZ4JS/B0b2sHpAgSqp9W4mpVRr98p0
         QKEKm5MRfRG77/odNOFywO6U9g121SZe9krydPNFUFE9yuNneuKZgaf2yAKqv2K8hqIA
         8ca+5YTDzJ3nbm51u03PgOti32uC7E3OLvmyweo+rfWlBh9gezWKbKxHOfxmwrXFECor
         nxCM6jlvgNOCr6bZqlqfK02YBLwj7SW/J/bKv4dJYlrQ0LxTIOlvsV5y2sYKrbZMCU7b
         kWRDL1Jlx2Uf68O3m8rXH4CMZlbhrh3BlPVdZUPkTYwMsw87V3mme5B7zf96jasqIcqN
         ur+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0kVmE9v1Y37Py/EkUk6KvrUH6lzwL+wSbh5MS45MAac=;
        b=LMvocoqZDY/Eq3KWRGTZwt6s4EGCjlu35ULRFTnMIFbvvF6fAyCeSDeIeUxTrqtoQn
         0bF56qDwlSx14sDVhUJUgfJRyI+CQuWsQViFqRXDyUtoWq7LMjWBdTkmu45oFr3Xa1w7
         GcUwgIpcfxMaMLgbAhCinGANcV5eNXoIdzVDjLaOGxC/iv3fV+699LwVW2NLmqJAmjq/
         GzFdpKzrdy91tOLls1hz1DhbSGtkIVu8ZRNeeJT42luxlsBkZpVmXF818J2h4GSdplaX
         MVxpmsP12AioBp/HTFFH10BuzlSDjb+9DDwHHdZEx2jnwww5f6eIu1t0Tkv+HD9K2YNI
         KyZA==
X-Gm-Message-State: AOAM531o9hdfrCNr/7ITChoaSZAVCFdtrbY+H3lT3JxfeXpSonzr1FDR
        vpjzhvgPaqP07sNqCr4C9u7lB6A00O0=
X-Google-Smtp-Source: ABdhPJyudRs4dR0VpOvwHgaJkLfz58dN4i89r8EKy8ND0dGjxCliE81Fr+SEuXEx3C1ApYzmSBlAJg==
X-Received: by 2002:a63:689:: with SMTP id 131mr702338pgg.401.1590495451535;
        Tue, 26 May 2020 05:17:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u20sm15439481pfn.144.2020.05.26.05.17.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 05:17:30 -0700 (PDT)
Message-ID: <5ecd08da.1c69fb81.3091c.e354@mx.google.com>
Date:   Tue, 26 May 2020 05:17:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.124-77-g0708fb235b9c
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 139 boots: 2 failed,
 125 passed with 7 offline, 5 untried/unknown (v4.19.124-77-g0708fb235b9c)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/kernel/v4.19.12=
4-77-g0708fb235b9c/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.19.y boot: 139 boots: 2 failed, 125 passed with 7 offline=
, 5 untried/unknown (v4.19.124-77-g0708fb235b9c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.124-77-g0708fb235b9c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.124-77-g0708fb235b9c/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.124-77-g0708fb235b9c
Git Commit: 0708fb235b9c82f3d983e90bdc1a11227512055b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.1=
23-81-gff1170bc0ae9 - first fail: v4.19.124)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.1=
23-81-gff1170bc0ae9 - first fail: v4.19.124)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.123-81-gff1170bc0=
ae9)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 13 days (last pass: v4.19=
.122 - first fail: v4.19.122-48-g92ba0b6b33ad)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 74 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

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
