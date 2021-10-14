Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A2242D0B1
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 04:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhJNCxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 22:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhJNCxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 22:53:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABF5C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 19:50:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id np13so3684218pjb.4
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 19:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QpQq4jMwTztV6OIwBm5Lr9snA1VCT3M8xgwcllQPENQ=;
        b=R7Yv14R5od/FWHTWXzirBlcXZSVRd0o66oYG20Fkruu77P1nmdtttn4GEDvPc1C9WP
         0N8A173XbdC6IhPS6f3dXxI6vSqh0EuZcW8zmHzLcJyNqE/YMElmkoB9E849IGyrcNIg
         QyQo6I9JyJ1c2ZZmVBOs4J3krnT93ixDl56kC4qGnZHPfHfoLzIcY8fjntK4gfG/PRSB
         FyrFj1FUuGPUP/CYX5NXd9UCgMC1Pfix1aoSunCwmYNpk2vvINlzpp5SnYRuRYCXvN6B
         Q7kQn2XBxHk+1GTll6H7mRwXD1SNXBmWIQTmSEB5aVfb8inu/dB65e2x3MpmvG9egkU4
         42BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QpQq4jMwTztV6OIwBm5Lr9snA1VCT3M8xgwcllQPENQ=;
        b=nhVST1SnujmTNppB+0EQINrdnYpXBCNzoiz40FWeEPIvmibcO1g2JUTb8qvP9A+fIN
         7hIYkBYMzUCVUnrDb2b9NYsx5z4WgcraEQI1vrFFX8z44asEMhWfgnPGwoNvpYlx9NjX
         rmz9u657bF78GKD+y8qGv1OmlV+gG4PFqSJp2koGY1rjbQhkkZd4H/RySm+pqwH5gnB8
         YZjSRCpfIKl7Sk1gJIo/wxXLhYMBumIzJVNeaqbvhjREHzD8pjgAIfoXniBpvObcyuQ4
         78Nr+ZYVdhye/XSPYmst1fyHOjobwblklN9p/osiYX9lKbBSwS9rtHzg2rrADFAbXslV
         YBug==
X-Gm-Message-State: AOAM532XF7kaCuOo5BdUtTniP/hmC81x1olvAYR2toL36gPKtR2h/vqO
        rmZ00KlvaITamkRtFuinuVJirxDG3r62JRNSQwU=
X-Google-Smtp-Source: ABdhPJxcIG6X7d9ivZfH0WTePJgeRDDbFwznJmGhJvQKoZfYzbkO4nOACVGjRqU15yZavgsjorbFyg==
X-Received: by 2002:a17:902:9a97:b0:13e:2da4:8132 with SMTP id w23-20020a1709029a9700b0013e2da48132mr2734202plp.34.1634179855444;
        Wed, 13 Oct 2021 19:50:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u66sm769418pfc.114.2021.10.13.19.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 19:50:55 -0700 (PDT)
Message-ID: <61679b0f.1c69fb81.331a.37a0@mx.google.com>
Date:   Wed, 13 Oct 2021 19:50:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.211-12-g4bd4db2313e8
Subject: stable-rc/queue/4.19 baseline: 82 runs,
 3 regressions (v4.19.211-12-g4bd4db2313e8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 82 runs, 3 regressions (v4.19.211-12-g4bd4db=
2313e8)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.211-12-g4bd4db2313e8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.211-12-g4bd4db2313e8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bd4db2313e8189709d2c0ea5384e7860a14191f =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61675de00536dc422708fab5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g4bd4db2313e8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g4bd4db2313e8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61675de00536dc422708f=
ab6
        failing since 334 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61675de40536dc422708fab8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g4bd4db2313e8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g4bd4db2313e8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61675de40536dc422708f=
ab9
        failing since 334 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61675de90536dc422708fabe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g4bd4db2313e8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g4bd4db2313e8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61675de90536dc422708f=
abf
        failing since 334 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
