Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399493D91C3
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 17:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbhG1PWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 11:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbhG1PWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 11:22:51 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A0EC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 08:22:50 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f13so3128326plj.2
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 08:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NjJyo0yy6XD/U9XxwqaM8krzp1yv9djngGDIsBwFmOs=;
        b=X/oS1pQ7OOPxiRMdPFnOxjwI91GNmzPd8fmBNf7YhJOzKvAB+SBqlfOg2Grll8GOn6
         Yr5z2dsZbelbEb8GpG1tGaO0erIInUzZr5XsOa+P2U2Tnpav+S2I1h62VKgljHbNFAkl
         Oag5G4ZhmJfVfvyaqkNr/GYSEUSfxmhsoXBp6Pisiy3riG9CxRiJREM39wUjiDFs5DOo
         x9CQshLWv0GfzsdqTcDmazbDOH+ZiVbC6rXLWW1Rn73jdZwXlO07WY5XK8w8T0jNIuCl
         GuA7kunbcnNG5V47MqtUYgAfayAOh8xmXI5wNcKN878ZgE1A2QqrxSI/Flbq2ANOgzZh
         4SGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NjJyo0yy6XD/U9XxwqaM8krzp1yv9djngGDIsBwFmOs=;
        b=WFnLKVMkPbL083M80jNWO5rk50yZj11WRhbvOawrnb1uOTc/NzPQZ0alAgVA6/HPNE
         HfEidNoEmX8LtH+cs9aPOlPzEJ8n6lH7BpadHFKNKiXw5pqSmCICKD1H3uZBb3hV24Rl
         37wDdsZYm2uwsgLTOU6LMxMV+FrECCBZhR00seE6uHaolHpOxryG4yKdRoSmtkrGDzaB
         C6+7dk41+ZhDw3bxtQrkfVfKhngA2dYgry/w1rFIWnqdY8TTCo4/VDMztB+T0jnfriwb
         SEC8YmLzUkQ3n13XjrWP1gvnLIZHJW6WshF/7H1ZxuM6gfVC09dUU7sNAFVwQIPnJKed
         s6Kg==
X-Gm-Message-State: AOAM531udIZC8/Ce86u/xXRUDLdwK3mSYIQaf+qu2bI7JLxw8gDvGAaj
        +I7qq+SJCt+/eg1fXxOkc+aSwReSeXx/7Zks
X-Google-Smtp-Source: ABdhPJyX5aQEKHiT1oCDA2YdxX6dtB5x4lO+OV0ZqXbrpSBxk3Xg5GV144ngJIji5x0J5r91UDvH2g==
X-Received: by 2002:a17:90a:c8b:: with SMTP id v11mr9798250pja.114.1627485769532;
        Wed, 28 Jul 2021 08:22:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c14sm4687532pjr.3.2021.07.28.08.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 08:22:49 -0700 (PDT)
Message-ID: <61017649.1c69fb81.49818.ff42@mx.google.com>
Date:   Wed, 28 Jul 2021 08:22:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.241
Subject: stable/linux-4.14.y baseline: 124 runs, 4 regressions (v4.14.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 124 runs, 4 regressions (v4.14.241)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.241/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ce4d1565392b2dc8ea33032615c934c3dc6a32bb =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61013fa81a7b9e1bd45018ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.241/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.241/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61013fa81a7b9e1bd4501=
8f0
        failing since 481 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61014149a67d123f435018d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.241/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.241/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61014149a67d123f43501=
8d8
        failing since 251 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61013e1637992deb395018f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.241/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.241/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61013e1637992deb39501=
8f3
        failing since 251 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61014abaa20b93c7d05018e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.241/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.241/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61014abaa20b93c7d0501=
8e6
        failing since 251 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
