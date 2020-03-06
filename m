Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C136317C0F5
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 15:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCFOxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 09:53:47 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41973 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgCFOxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 09:53:47 -0500
Received: by mail-pf1-f194.google.com with SMTP id z65so1223602pfz.8
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 06:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=umUuQusO9s1lUTfFeHw4eF7Mgmnb4kMqsXkyQphEPKs=;
        b=2O/oceESBKKs+eMNafod07vlRYiSpod3KhvxxxXWo8zz7WbCCqiINqlE+r18Zz156P
         1b+7LDXp6i+vzw5ZWULjEnwcD9oFdsiEl55Y6OeabhV8Rm4qGWH+Jff8TH9gjC5clVTn
         aDuWFezr0fX//Kvt1lGG2Avf6sXkSjI0hq2bNLis1EYLUJhCpJk3kNiRJzIJbsA/kmmh
         xa2sR4VFzdSOtyOLy2krICx525MWMUGSukFtjWm3v1/jctFLpWTetBdt5P6DT9EK66KP
         N1Lhpb5tuxHuRSSlIvYZFh79OcQPHaxnhawkgJfZoTMazRonZeRZLm7yyH2QEP7zg1J8
         unPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=umUuQusO9s1lUTfFeHw4eF7Mgmnb4kMqsXkyQphEPKs=;
        b=f3lqV+wgeFNGW5Tdt3Sn/3Jye/NXI5mYdi/iyinFeoqeVRM6Ns0VgBHQ3kp/ZcskmI
         1q0NOThUiMXE2fgxrAlWVEx/K+Lo0JcJ3OZNNDQodMthHi+NPskixXoNJI3qLosZ09dg
         AVTcrGs8J1IRuXF2Q7jvVMivNnHNNfs8dEabgjWAjfwabQQHa613FqwZAIls2vzfTG6a
         PyjZ6ta0PdBTQ1WkGvvtkic9KjKac6Je3MvSvpXu2NCEuTKhIBOPuJ8wsxPoq62Dr3vZ
         o11JXMOWxbLR0DJBzuDkssj5xDO7nzcgebCfMrlPxqFIiw89B56B8ehhWa/NKGX0Tt9W
         2udQ==
X-Gm-Message-State: ANhLgQ1PgRfr0cAUGExygt0uCC6qhU4cSdkiKliRDTX/lISjNVzLgVFc
        7UQlI4zm8b3utu+wVhdKRR3pt+bFEbU=
X-Google-Smtp-Source: ADFU+vsOjtzRKYs6CWZN8lWAMuay9/D6lBD+QKfgH9rCM1dPMVTnO74UI3LMl5kjI/fB4s3Sn+VhOQ==
X-Received: by 2002:a63:f454:: with SMTP id p20mr3789489pgk.149.1583506426376;
        Fri, 06 Mar 2020 06:53:46 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s25sm9094269pfe.147.2020.03.06.06.53.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 06:53:45 -0800 (PST)
Message-ID: <5e6263f9.1c69fb81.82118.7003@mx.google.com>
Date:   Fri, 06 Mar 2020 06:53:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.108
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 103 boots: 3 failed,
 96 passed with 3 offline, 1 untried/unknown (v4.19.108)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 103 boots: 3 failed, 96 passed with 3 offline,=
 1 untried/unknown (v4.19.108)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.108/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.108/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.108
Git Commit: 7472c4028e2357202949f99ad94c5a5a34f95666
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 23 SoC families, 18 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 26 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.19.107-88-g6=
19f84afab6a)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.107-88-g6=
19f84afab6a)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
