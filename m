Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4757C1ED6F1
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 21:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgFCTfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 15:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgFCTfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 15:35:38 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645BEC08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 12:35:38 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n9so1175363plk.1
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 12:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=erDdeQFrroAfpslPG3N3xQxe+lfkHWCqP4qkR8/doQc=;
        b=bwUF7DAJTr2d0bhAUSE8qzib7SGcsIMlQlNjBTp7tW/5vm9weMo/+ZV0U5DqovoL6P
         QM30QnRAfhESWZdez3O//JxA7eO91848ts5Hcz/jbV9TOWbUhx9nD8ViymMudoJ34xfE
         4840KAS2/UpfynoSNX91xoGbU6iYScoe9gdIky7Ye04/ZFIli1tV+ueYdRWX9w+Oujfu
         DD4sZ7pOoZB504WFahZ9icxizDTNHVP+K7OgZdNVBjQmP+/gY4apOuQIlRQ2VM5meER2
         c1ghK4pZNYyBRu2YcOa1UXSkvXVx2GNCcgbpU/1qgADqViqBHq2D29fLY8HCkzuly5t0
         Oacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=erDdeQFrroAfpslPG3N3xQxe+lfkHWCqP4qkR8/doQc=;
        b=mL3n7vTYQjw3QAP56hc8gGDIzgUjP08f+V2A4zFBexcFpEZRhpep1eJRiK2gyZH3zm
         aqenMHUjVjQNXBuFfeVprgJ1xXs/GkYogyS8b9boEPWAviML9MZZh1gdUPDjMEHReoiM
         tZbttsdGcEBi/vLa7hoXQ/kL8oomg4UHCiZZB8iyAEQCm1sbB4xfDqJNsuCxpWX/GExc
         OqeIVSu+4f/n4Welsu318s7ZmTXp4pEEkdnpH2Iz7YtE9+gq14rhUNTNNa7zZEZqs8m1
         3vqRxFAHhqzn69y+P/QNbyijFZV4p7CofFEW+oqsBesYne6qAwZPB7A2oqYwLp4XNdsy
         AEKw==
X-Gm-Message-State: AOAM533sSrPLmMwSoKiFTXfrziepY786+tdsubnfNa1d6Yx/TZisIGfn
        yaJ0lcpTkSGbsGBSIlCRDNCMTG6jg/8=
X-Google-Smtp-Source: ABdhPJytDimZCYDvTlhjeVwqtQDAN0cvG8ZLY9owYubMbLSDy06QXtmn6PxFHh9wufuVq3NqhbLDJw==
X-Received: by 2002:a17:902:70c3:: with SMTP id l3mr1304478plt.70.1591212937517;
        Wed, 03 Jun 2020 12:35:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2sm2166503pgh.89.2020.06.03.12.35.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 12:35:36 -0700 (PDT)
Message-ID: <5ed7fb88.1c69fb81.2eafd.58be@mx.google.com>
Date:   Wed, 03 Jun 2020 12:35:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.226
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 80 boots: 3 failed,
 68 passed with 4 offline, 4 untried/unknown, 1 conflict (v4.4.226)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.226/=
plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 80 boots: 3 failed, 68 passed with 4 offline, 4=
 untried/unknown, 1 conflict (v4.4.226)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.226/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.226/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.226
Git Commit: 95a3867e897abd7811196123f81a119a75aba863
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 17 SoC families, 13 builds out of 150

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 21 days (last pass: v4.4.=
223 - first fail: v4.4.223-36-g32f5ec9b096d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 69 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.4.225-48-gd147737ac=
3ba)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
