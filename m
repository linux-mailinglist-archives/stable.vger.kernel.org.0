Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ACF1B36D2
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 07:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgDVF14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 01:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVF14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 01:27:56 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D7CC03C1A6
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 22:27:54 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o15so541463pgi.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 22:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KK9AXICrSV060Xaq1xd1Vop575GHztx6s0fAYYNE3oI=;
        b=1ntrURqb5t7G+gD7EwxsHTFdUW7xfVLnkIdZq7ff/wLpSm45pUbdzDb3VVpTSGHMuY
         cs6L33/4+6GCBzQ+PuaW+DjamYg+U5TDl2kwNxG23v+GGgEMrYFg5iyC+PJl+EUPJB5D
         Cgx8x3I77VqnlMLpvR3/el2ctscX4ZgRpzJwrjahHSeDM71r7LrnQ/7oj4woCGCO9Nmk
         XIAonv6BsFw/kefHpcsNkCECg45RcpPf+medcZoJ88Jp/2/bZ9ZF3o9DY4alD9jpbYgR
         ylr8Rr29c8n5BmMg5AprY3vWsinYp8SRYpcHh9vp8GEMxMw9pf+AVQNc2Bx1YaWbUiPu
         7qWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KK9AXICrSV060Xaq1xd1Vop575GHztx6s0fAYYNE3oI=;
        b=T6ljcYWiGcANxBu2MFRvzpQTFEWX//67jDUZGXJF3uXAKhx50WZcJQa8flfni6Wh+j
         VUJ9X1ziqGMOQ5E1/XP1q9LjFSa4AFJpKXOajtcgt1xZ1fsJpA1VpuQRm7tJ8zyTqdA3
         PnVuE7xOrzycyMBs28ukCB/9gPJpaHIvrAFVScDmU8oz6BugHp++XDAre16NSLNML5J4
         VGbt8Cmrbf6+wuHXQYtieUbsJ9ae0Jnejjgiy6fyMesrynk5qUOvsE54qdTFY+mM47Vi
         h8c3c1vsgBJXPVGbg2LoQ/agPMFiEqXJEOVsAdLqNjDJrPL+WaQy+hhNPwSrgk+ygA8g
         Rvwg==
X-Gm-Message-State: AGi0Pub+lufVlyothpoGNP7zAcB+RK9cRTUoe0VVtwbRtuj+zybsl9Or
        67o0iIuQeV/2eAjw2jKDZkKPvdyNN5c=
X-Google-Smtp-Source: APiQypKZ1gKU74LHH3sOL2HgFtW8HJ/+H+xSGKHDI9r5XLlfkHaSJ+1TaRVQtRVxnysf/on+wMryVQ==
X-Received: by 2002:aa7:8505:: with SMTP id v5mr25510543pfn.224.1587533273760;
        Tue, 21 Apr 2020 22:27:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1sm2305298pfa.202.2020.04.21.22.27.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 22:27:53 -0700 (PDT)
Message-ID: <5e9fd5d9.1c69fb81.25e3e.a0bb@mx.google.com>
Date:   Tue, 21 Apr 2020 22:27:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.6-39-gc5f3b541dbc1
Subject: stable-rc/linux-5.6.y boot: 94 boots: 4 failed,
 84 passed with 3 offline, 3 untried/unknown (v5.6.6-39-gc5f3b541dbc1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 94 boots: 4 failed, 84 passed with 3 offline, 3=
 untried/unknown (v5.6.6-39-gc5f3b541dbc1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.6-39-gc5f3b541dbc1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.6-39-gc5f3b541dbc1/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.6-39-gc5f3b541dbc1
Git Commit: c5f3b541dbc18fab0209e9a184f9f6db5056bf37
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 20 SoC families, 19 builds out of 200

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.6)

    multi_v7_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v5.6.6)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.5-72-g906e=
cc0031ed)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v5.6.6)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab
            stih410-b2120: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
