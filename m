Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A331F9A0
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 19:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfEORzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 13:55:13 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:50848 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfEORzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 13:55:12 -0400
Received: by mail-wm1-f51.google.com with SMTP id f204so953252wme.0
        for <stable@vger.kernel.org>; Wed, 15 May 2019 10:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8a0Ne4dNSZVwjHUcXcSPoak6AY4jKew3Xjufj621ND0=;
        b=YICVRYoYuX/NCReLTH3xxkH4cTS83I0STrL6H2OSzHMQzP94fCnYzyeZji3VfPPxFu
         rbZjsLStPzJxMVOQMu4YW679lD3NeHT1J1krsnXm6KV+NHkFwTXG6Y+Nu6g1+zm+kAiz
         QGcjaIuc5pSltpW3guBzqknRRZc7+HqT7CNLyHa/Ncw71TCKKtAiieA9kG/Thp6W+Aif
         zv9Qq8NI7y73SJjMpVbbVDe9di6onNVwiLfWKF/FXVrjnSNFqGCOY6h/GTRT4dWHqnxA
         E90dQvycqKJfGw0089pYd1PkqPt3NPoMzX18wSdb0ZBTwQiZUwxOgvAoNdhWQdQYF4OJ
         B6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8a0Ne4dNSZVwjHUcXcSPoak6AY4jKew3Xjufj621ND0=;
        b=bCQrxO7fPzoUlfgfXxN7etElWKvp+79yLIKx3fndq/pfZiRy/FF0yO9AQ9o0spZpFD
         LjKJAZkIncs98PNyt+hq9sPxfC6SKQEDk+ZZoFQzD9G9nZcMpR4J7/JJQNZ6xV+6ylBC
         NK+XC+OEMStNa4Y1TV6WyIFgXUU1gE1TtltlQWm3kSrpG7PzEtqrGepeegLS0y1ENCRA
         vuYnBTWxfgHT/uFR6FlXG2e0oB1yxmihEih+EMiwstAPxgErnVjqTsxIC9Rztng06z/+
         X5+9y61fSlN6c51t4BlyJ3LEyENoveVMxGPUhmvQ5s7cnNSGyBDtnUbN7cGnp1wSMBTb
         LMhA==
X-Gm-Message-State: APjAAAU5cx9f/biZIEEQDt6miz6OECeYNnygAUAzaxKJJPeDRby0aqQg
        qbDOZVOwf3yRBB7z51vnOt9aec8dl7ibZw==
X-Google-Smtp-Source: APXvYqywryB3+huf0+8d3R+BYGoFwTVJDAWnrnLjgLpIUkFOm1+kCoyps02gc1UBVeKm+2k80/9ZFw==
X-Received: by 2002:a1c:f407:: with SMTP id z7mr23440376wma.34.1557942910355;
        Wed, 15 May 2019 10:55:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j131sm4195037wmb.9.2019.05.15.10.55.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 10:55:09 -0700 (PDT)
Message-ID: <5cdc527d.1c69fb81.b976a.9062@mx.google.com>
Date:   Wed, 15 May 2019 10:55:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.119-116-g7b9ae876e241
Subject: stable-rc/linux-4.14.y boot: 128 boots: 1 failed,
 122 passed with 3 offline, 2 conflicts (v4.14.119-116-g7b9ae876e241)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 1 failed, 122 passed with 3 offline=
, 2 conflicts (v4.14.119-116-g7b9ae876e241)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.119-116-g7b9ae876e241/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.119-116-g7b9ae876e241/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.119-116-g7b9ae876e241
Git Commit: 7b9ae876e2410f72fbc14db54f141d516adeabca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 23 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.119-98-g8d3df192f=
d69)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
