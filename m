Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7241AB336
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 23:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371387AbgDOVMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 17:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S371372AbgDOVMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 17:12:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E052C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 14:12:50 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u9so584561pfm.10
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 14:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7/Fa4yLPWRc1eopXEP4u62x0ZFZijAnzkOV0q9RrfJ4=;
        b=vnULVdQOTTUNiB/CAuYxWxgCjbXeZSuLwSvpQTXjRM51JSDLTwkZd6bIORGJ23HQxu
         YzpECmg+9IGPG5rRiueszYPjt9NHGlT5LVr3kMUFMwxuMzGVOEs2gF5tlcslEx/vEVsF
         hBnrqW1ygBf7UYi5W735DivbZKkn/cNRfhqC3jKSae5cgYdPSSuanADGtIkHcHlvLbua
         Gsi6oDl/o02lX5Lh9oe0WN7mU+LDvNO44SKnu5z7I8E/3khtnQYqesTvLbECvBsOlNX+
         lZnBGIMJir4wrETUX45ZLBKz2TxCFsaD0ib/RDRB3XxLiM2ngLElLdOVZ4ks8U21Tc1E
         P4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7/Fa4yLPWRc1eopXEP4u62x0ZFZijAnzkOV0q9RrfJ4=;
        b=AOuIrzfB72EwI+LZ0CI8PVBA/bbqCxrbov2Y0kajxkby0l4bIzC7Q3PCvgpThxVJhx
         TqINp2JvSksDehDnbIPpfN0GRZyA7KHw/Ca12vPfKnXLtaeCymX5fViHWL7Np8hhX52Z
         1iOwHT6KwSG9KRMmI8thKrvdGlHyDOSkXagHRtsuKt7uWC5C5NwtbaTgdrOupUXabE3x
         IguEqAHL4sIA7DFKd7gHdCcU7PWOemIzP1gne9v+aifyBi1PVqugNAe2dNZL44hoh5P2
         vCeIlFxQT//0LtHTLplbdve90LFsfNKnD1MPuE91ucYkwFWONIGIlY1drVyuMr14a6ge
         3bfw==
X-Gm-Message-State: AGi0PuYe5HneX0hXwbM4A+NAsYrtcpCsEfRbo0cJZuMkeZClmb3wj8vF
        O6K1cZTgfYovcc1E/B1FpovjV9bUP+M=
X-Google-Smtp-Source: APiQypJ/Rh+mklCjIY2ZmXU6L6M57FWKM85y6JopQhm2I8V+02/IvoCHAPe0euvIQXD0nf4P8YcB7A==
X-Received: by 2002:aa7:9e4d:: with SMTP id z13mr30200145pfq.6.1586985169359;
        Wed, 15 Apr 2020 14:12:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j24sm474724pji.20.2020.04.15.14.12.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 14:12:48 -0700 (PDT)
Message-ID: <5e9778d0.1c69fb81.84ecf.191e@mx.google.com>
Date:   Wed, 15 Apr 2020 14:12:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-81-g3402d0b47634
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 74 boots: 3 failed,
 64 passed with 5 offline, 2 untried/unknown (v4.4.218-81-g3402d0b47634)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 74 boots: 3 failed, 64 passed with 5 offline, 2=
 untried/unknown (v4.4.218-81-g3402d0b47634)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-81-g3402d0b47634/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-81-g3402d0b47634/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-81-g3402d0b47634
Git Commit: 3402d0b4763432c90703e2562242a388776b26a6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 16 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 67 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 20 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

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

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
