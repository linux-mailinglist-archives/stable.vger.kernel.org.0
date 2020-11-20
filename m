Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB7A2BAB72
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 14:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgKTNlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 08:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbgKTNlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 08:41:21 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988EAC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 05:41:19 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 34so7305602pgp.10
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 05:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=joQNKx+/Ly9C8mn3JIFUlGoXimhRaxLoWPzbBlLuzHQ=;
        b=VY3qltnxJ4dNylUgjQ2pSZf8lP3t2RYqhT7hhKTqqCxfsQKzhuiRLnnNBusWfmKrxL
         dwg7PDeM/4mt+m/EAn1tXG7nGrBX0oBFOmmcimRW3EaO7dKSqx9F3xJc2cYN2B9SelvS
         sggQktqFGktTqUiyWSARs1MvO6q6htLkGq4ael1sIcg9Hp7I2tqEZ/jTXWBNkJ4BYF4m
         PNJAOcu+xIbcARsOEvt63wsy65G/5a3xI7e2JEmT5UmL6qe0qK02L66KhRtXUFWE6kw6
         MupLe4Nud206OsH/aFbry0+rOFRnYSnr9LzHsBvd7J7y4PGl8HL8pg35zdnBDparQa9U
         xtRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=joQNKx+/Ly9C8mn3JIFUlGoXimhRaxLoWPzbBlLuzHQ=;
        b=SBE+zGWLBQn6DRPOBpVqBZpVW+pOXjqKtsX9nD9zahsXvyxt5VyTR3PeUtgS9P4XXT
         LU4T7wTLMOnUEMy8dtt95xGxNXsyDfGMlxEreGayLFuHx9paHnLQoI+FmhyIjS3ryhC4
         BrY3RixZ3pWavMUbcFP+8xdaLeHoXYEs36eK1dCkGYAVT5UnsdKHsAyJfOb1JdBV0l+/
         WbV9Xy1YtZMGVqSgHNPGBKrsQQRzvze5i21X0mqG1tmlJx4QzgvoOAmM1Tj0oH8uxYHd
         A1UYi+z/ryrSToEFbmBSzCSiCyde1MuTETDWXAVqaSEEoq2mnLqKXHNb1tehgc5zAev4
         TBgw==
X-Gm-Message-State: AOAM533zgnVn9SMxDjYtaLb0JPGjqgC2NH5fixJqXKPoSZCJSkDUzHt1
        +2JIm2Vhws00dZJgGJJnlFxWf47ccF/3YA==
X-Google-Smtp-Source: ABdhPJzbc8OAIk4WugWaab9uvSnl4xg0i0m//+P5FxEXb5gHLm7kTOGO6/oBT+IDfT+R5hJLNWN0tg==
X-Received: by 2002:a17:90a:c214:: with SMTP id e20mr5987754pjt.212.1605879677828;
        Fri, 20 Nov 2020 05:41:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f134sm3704391pfa.208.2020.11.20.05.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 05:41:16 -0800 (PST)
Message-ID: <5fb7c77c.1c69fb81.e4829.6cfe@mx.google.com>
Date:   Fri, 20 Nov 2020 05:41:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.244-13-g7fb6fc1e8169
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 113 runs,
 6 regressions (v4.9.244-13-g7fb6fc1e8169)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 113 runs, 6 regressions (v4.9.244-13-g7fb6fc1=
e8169)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.244-13-g7fb6fc1e8169/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.244-13-g7fb6fc1e8169
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7fb6fc1e816970b858a8a10c0817816810b1d568 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7952ce68d3d6066d8d910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7952ce68d3d6066d8d=
911
        failing since 22 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7961d517f2104f2d8d8fd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb7961d517f210=
4f2d8d902
        failing since 1 day (last pass: v4.9.243-77-gb25c2d614872, first fa=
il: v4.9.243-77-g646866ecd6a7)
        2 lines =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb794d8352f5efcc3d8d90d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb794d8352f5efcc3d8d=
90e
        failing since 6 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb794d84411e04554d8d92c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb794d84411e04554d8d=
92d
        failing since 6 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7948efc3b645a60d8d903

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7948efc3b645a60d8d=
904
        failing since 6 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
r8a7795-salvator-x    | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb792172a11d55b49d8d912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.244-1=
3-g7fb6fc1e8169/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb792172a11d55b49d8d=
913
        failing since 2 days (last pass: v4.9.243-24-ga8ede488cf7a, first f=
ail: v4.9.243-77-g36ec779d6aa89) =

 =20
