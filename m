Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF56A18604A
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 23:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgCOWqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 18:46:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38012 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729289AbgCOWqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 18:46:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id z5so8838992pfn.5
        for <stable@vger.kernel.org>; Sun, 15 Mar 2020 15:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LccAiugr5ytVCQBGgRLCamogEdxwXKgAFtXonaIQ8oI=;
        b=HQzrfVgty1SaMgXvpyyIZBPasxU/ZKIonAIfMbCV8RHOiPFAWeZsaDVcGAa6DJkLZq
         fRTk2KTSNsM+Lx/OREZHQ44lMVlf7Pk+Ya3t/KRjKNhiQ42a9RJJk4Zckdym7U4Bcz5r
         0WHwRhKgTguA74z6h34BVb5MO4EAehun1+gGkWQ1NLNad83A6QMDJtTsDoVu8vFPoFCG
         /iucWMWvldDOe4EJm6O27ipiwIYKj/P7nbbALXM02ZrOQttVl5ZgrfFhurJBG1bX3Fpm
         Kpad9VO2ECuA0QOQPMdLsEohRPlalHMTRsF+JVIjFvUQnFY1oS8aZiVewY620xyJW1N8
         dbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LccAiugr5ytVCQBGgRLCamogEdxwXKgAFtXonaIQ8oI=;
        b=AoGkWV2oBSVC7b9/ASRf/JSlzN0XW70X3825Vl0h+g11BnY3vb4pWBTPYzM+rf46cR
         A2spRhIKNmx5WUsvXBC2eF2zRZU8SKFf9NTPvDI+gwKEYcIjMGndMf9ozoj6/C4ouQ4Q
         t0osObCOwPnnMuRbKgteNYgbxNiCsBqwICjaVkw8brJ++UxDytHBs/Fn6RUuHWlmoOZJ
         WEnbr80cm+eKXjewlbIGy9sfpZfPmRZl3KNGfyPetuFhM8Uo/1UXQQBhiHVqy0qIt1ql
         ru1wWVYpMfbl+DeUp2pUcVAPHCJIJC2dtbyVieqDQwv3CWK14NYnHNEQwRTfRYyf8iFy
         Yrxg==
X-Gm-Message-State: ANhLgQ0ZarO1JmGWcgNRGciRyg5BDpdxOfXkfyXqGsqC6Aq8NKNJHX8x
        klTq17Z9b/9Ulh/0IRnunOdq3dkKWaI=
X-Google-Smtp-Source: ADFU+vsOsuBvloaGXdSPMZDHEMH97Vhg7wGtPvBXjR8hETrgrQd5AX5576Klqj0RYOuIsfR7ybteFw==
X-Received: by 2002:a63:df15:: with SMTP id u21mr22294228pgg.95.1584312411455;
        Sun, 15 Mar 2020 15:46:51 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k16sm27087133pfa.10.2020.03.15.15.46.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 15:46:50 -0700 (PDT)
Message-ID: <5e6eb05a.1c69fb81.7fc41.7fc5@mx.google.com>
Date:   Sun, 15 Mar 2020 15:46:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.173-37-gddbe3d93df89
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 131 boots: 3 failed,
 118 passed with 4 offline, 6 untried/unknown (v4.14.173-37-gddbe3d93df89)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 131 boots: 3 failed, 118 passed with 4 offline=
, 6 untried/unknown (v4.14.173-37-gddbe3d93df89)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.173-37-gddbe3d93df89/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.173-37-gddbe3d93df89/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.173-37-gddbe3d93df89
Git Commit: ddbe3d93df89a846409463e1f6ec6c8832f8abc5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 22 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.173)
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.14.173)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 36 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 24 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.173)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v4.14.173)
              lab-baylibre: new failure (last pass: v4.14.173)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v4.14.173)
              lab-baylibre: new failure (last pass: v4.14.173)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
