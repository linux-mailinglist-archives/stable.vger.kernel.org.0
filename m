Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59CE3346FE
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhCJSln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbhCJSlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 13:41:25 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83653C061760
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 10:41:25 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o38so11967607pgm.9
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 10:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7aP/i2IDgzx8nVRGKDZGeMynfYPYZPzCfg5MT6FMBUE=;
        b=zQZRf/hk45P2IludxUVwSHT2on7U4ZMZd7+GD1WneorXBaDPui3h6aR0id5pWLs1hw
         1a3ujcxyKOaL3F9zVgRNxooZqorFD/2Im+zdEp9ni4uQFqGiIaDacn8y2mbm8lxUEBbf
         IGrrtzdIysCFW6LFrvN+XB7D9a8411DD2NREPe/nNlVfmXYWJRTfUTBiZUKH1uR/jOiK
         cs49XdUaN4GxYF0lspBru7QzVZBGyFzB7280WjnNeB0wZevjmPCrrKuOoNGXMnuD96Y+
         Xyic9G6C1t91qls71tHy4r37RpichbIhzD7RYdhELQsFW2TZ8+fa4hpdYtLlguGWlxJx
         YXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7aP/i2IDgzx8nVRGKDZGeMynfYPYZPzCfg5MT6FMBUE=;
        b=R3gVcwTMRXdIB1PkMwRs4/0wLdv67KWVd+F1AZONvHZZbYXZrw35ZcmrQZ8D8cDeM1
         bmVvOXSAhT/Hry+6tyrSFh35QUt+z6aGgoR34e4kJpOff0GiJMDtH9LkkpOf68o8heaP
         6+3sideeSy4olklwhm5h86OrG4fD1YDcDJnriWEfShyO6EgonFyQVevVB5E3qXN5cnFR
         D4u0dfBnx2Hvl9ZF1UgnVu3ggvhQq/IHiA1LV0r5jjra4I+9yvShSd/19+qLI+mXERy1
         YlDLUtJrygKO+dWRpVSD/sdqTlyh/SydzY/4AqJzw29uc9hL4IfvKcozsUR4WsuAKo1U
         W5kA==
X-Gm-Message-State: AOAM533hjVPafVUwMXCeT3tdVsfmK4uDc28zfApcvO4ZsgGDVQ0u6GdJ
        T6H+gReSkwJu0/i3Vefn15rQm75PVvM0YzRX
X-Google-Smtp-Source: ABdhPJyrqrD40Ve2+tbD4vVFDlC4iKNrnY3wjrg9vZSuvklGtaEIeAugn+eB2yqYxvucHEYL4lLHDQ==
X-Received: by 2002:a63:cb0e:: with SMTP id p14mr3900089pgg.370.1615401684914;
        Wed, 10 Mar 2021 10:41:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j27sm224867pgn.61.2021.03.10.10.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 10:41:24 -0800 (PST)
Message-ID: <604912d4.1c69fb81.bca08.0c26@mx.google.com>
Date:   Wed, 10 Mar 2021 10:41:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.260-11-g41afa6cdb0648
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 74 runs,
 3 regressions (v4.9.260-11-g41afa6cdb0648)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 74 runs, 3 regressions (v4.9.260-11-g41afa6cd=
b0648)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.260-11-g41afa6cdb0648/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.260-11-g41afa6cdb0648
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41afa6cdb0648c74e3d77e2a64eabae29e69d429 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6048dc3a8e92d13a8eaddd09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g41afa6cdb0648/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g41afa6cdb0648/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6048dc3a8e92d13a8eadd=
d0a
        failing since 116 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6048dcb34f2ee888faaddcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g41afa6cdb0648/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g41afa6cdb0648/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6048dcb34f2ee888faadd=
cbd
        failing since 116 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6048db0a7a3f37d8e9addcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g41afa6cdb0648/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-1=
1-g41afa6cdb0648/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6048db0a7a3f37d8e9add=
cc3
        failing since 116 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
