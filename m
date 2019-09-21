Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36ECBB9EE4
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 18:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407812AbfIUQrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 12:47:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52477 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407811AbfIUQrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 12:47:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id x2so5521830wmj.2
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 09:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gGxZ+FFqtqSQPA7lTukLcQhjNCorbZJ9oI+PnBuPU+c=;
        b=NU7KqV4OjFKRhe7n0RrQG9VVYfO+fRosJeemR560kupnCwcodlrCUcrQ0R33pNbU/e
         5SB79+zPeJGJs5/aC5GIC1xmkO1Dyqw33ORy9XyT0qPf7+Xl+v2Dp/vra3b2VEWSUos4
         FvztSSVqkcSkhpU4oEbeV1aJ2ZI96EWmTHKPxgU/PLV+AwMxiW+xx1d9tN8IsEMZUkMd
         6QklXn3hbYUjbfWW1pUxqQtUMcWGLc9JFPbTC4K9Iy6PX1T76HzHQ/899vlIl+WtfFgS
         azu1MoVyCRWj1S6DYUR6b5kUphRwJOxiF1a+ZChikuujOE9VBs0JDEIhHYyKgiVBXVgo
         ENsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gGxZ+FFqtqSQPA7lTukLcQhjNCorbZJ9oI+PnBuPU+c=;
        b=TZUEz0xaHhYTobVSJ8VejG5Pz0JwFPWWlXuVfLUsWO8YFi90RS1sfluxkBN6aOlZKs
         tjrtLv8tMXR+EVPdtg7NZNvHRdR1PmyYky5Bm33ZJgEEQlbB0n51SR6Mmx3ajbheDEQ/
         2BNQoQ2Fb/eZBI8hINiQv6/z6sA/kN3+tTSLskbQX6wvG+jqvlmSYb2+AOTyyRyOHbCb
         ckmbYEVmnhR5CLuvYSIcnwBAwmD9Y8OdcgYMLjE1BZRY6ODCPoHitAQE2XTE2VIDREcs
         PMe83Lsy1cOEpjkNnYwBYrl/tu+DOrDXGvF9plGVoPXpN/4ybsdU2WBzepOYxhj5knt/
         HWMg==
X-Gm-Message-State: APjAAAXYUyFuuuxEEbBI59DOEeLW/IMdyiFvtZ22Xv+nG4iTOalpFN+i
        M7/N7NuKXM9TuvR3OKm8PvlCWCXwW5MsYg==
X-Google-Smtp-Source: APXvYqyKkm8sVlrgWGDo5GhFe8+3/K7yJV3sAT7m6gXHoN3Odms224n5eGYr8PepUko8Je1BiuzLWw==
X-Received: by 2002:a05:600c:2311:: with SMTP id 17mr7391569wmo.39.1569084472552;
        Sat, 21 Sep 2019 09:47:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d78sm6191183wmd.47.2019.09.21.09.47.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 09:47:52 -0700 (PDT)
Message-ID: <5d865438.1c69fb81.f4100.e993@mx.google.com>
Date:   Sat, 21 Sep 2019 09:47:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.194
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 100 boots: 3 failed,
 87 passed with 9 offline, 1 conflict (v4.4.194)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 3 failed, 87 passed with 9 offline, =
1 conflict (v4.4.194)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.194/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.194/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.194
Git Commit: 5f090d837b1f61ba12780a8b8196b69a00d7cd70
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
