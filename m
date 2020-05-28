Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19661E7021
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 01:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391551AbgE1XR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 19:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391508AbgE1XRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 19:17:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADF4C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 16:17:24 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n15so229048pfd.0
        for <stable@vger.kernel.org>; Thu, 28 May 2020 16:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pJe+M0M11QJZEQF+vTZp5qN5F+CYoBkAZ/CUP4Tk0Zk=;
        b=XTphfjpOoN6kv6fPBjQtWaRPUcKDTR5jibjLmSUhYaUSlCNjjmsLztdyQDWUrnwPby
         IMkfrIislYf9WiSGtoLqXk7mtz6SfJGpOjhiMpn2/5gVXgrNaALLPpg9F9mIA3wSJYhx
         aEkwztpCLqFmwqckTODkmjQF3SpP/TVEAxHyWphX+RLS5TprLk+p8g4DMF13grTAhU8S
         +KipZdqOi1nwO74TwwY1oGjBdtsOWr/BtkkT4IxQjJ8iO8i1bH9ocyUdugfbVRXSA1v9
         POD/H3lOM+04o4YjFowvYi0dQOtzgCS9fWlVN0ljfZzK+k6uxgkHEtuY3pjCGJLGTOz8
         BwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pJe+M0M11QJZEQF+vTZp5qN5F+CYoBkAZ/CUP4Tk0Zk=;
        b=hKSe/VizueestQ2wDl31bBFnzdBaDTNtNmUCa5MA3D2vN3nv3EIkY74gpPYFCUdq/g
         38K663BmhJ7vmXxAi9A15vrUJ6OvRiXINLKfGY1SQk7eHsiBwAxenTIq9ooYensH4v1o
         zQl/zVW6lEPkJRaDtd1ixqeglGRT44yVsXuYGwSVcl2tXD4wzjQIa1cxarIr92fN6Qyp
         iIcCoW84VNpEZC9yMj/W56DoCMLhXNd6PanGkk1iibvv+aOgYZzKvTrYgBvdEDffStGI
         81J8UIFDaliBCXvGOYH35VhQ5BWNF4LNcLNdnFmbeu4Zg9eSpSgXSaeBiBe2gsp6pr6D
         7mVw==
X-Gm-Message-State: AOAM533hKxi7o5R5b6LbU+PdMb4FRTgsNiDhPCB3uYsxYhRIWqvfX9I2
        hEXPMldlFv8nUrn00blOxmosT+VFMP0=
X-Google-Smtp-Source: ABdhPJwEj3GymiDmZQX268AgOZbe1R/Nu2bQ86Fba4Y4fNQaqNIzAk34HHTlFMBZheJyhvFLMje2rg==
X-Received: by 2002:a65:6804:: with SMTP id l4mr5446255pgt.76.1590707843619;
        Thu, 28 May 2020 16:17:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z138sm2627996pfc.70.2020.05.28.16.17.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 16:17:22 -0700 (PDT)
Message-ID: <5ed04682.1c69fb81.4e2dd.fa80@mx.google.com>
Date:   Thu, 28 May 2020 16:17:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.225
Subject: stable-rc/linux-4.4.y boot: 90 boots: 3 failed,
 77 passed with 6 offline, 4 untried/unknown (v4.4.225)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.225/=
plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.4.y boot: 90 boots: 3 failed, 77 passed with 6 offline, 4=
 untried/unknown (v4.4.225)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.225/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.225/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.225
Git Commit: 646cdb183bb780e11e0ad4534d9054f77c31c8dc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 17 SoC families, 17 builds out of 154

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.224-66-g14=
7ece171c0d)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.224-66-g14=
7ece171c0d)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 15 days (last pass: v4.4.=
223 - first fail: v4.4.223-36-g32f5ec9b096d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 63 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
