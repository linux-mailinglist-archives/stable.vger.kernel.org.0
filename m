Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0EB2F94D7
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 20:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbhAQTVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 14:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730096AbhAQTU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 14:20:26 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DF2C061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 11:19:38 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t29so3784599pfg.11
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 11:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J2Xd9LVH817mwGqo0jmHUxcIprXxl3+dYfYgCSyj1Tg=;
        b=i0ept49BFqK/AHDMfijTkWv87eyz5PiqlTpMuR5JCA/XUtbaucyiIvYJ1la5EF0LAo
         4TPdfAkS8UYi5/JG72kIajunB6iln7zXrcNo7FlVnF6e6iTdCYQKXIxg+28vEevT79oK
         fqr21o8EGl0Zii+Xn2zs/P4y00Z7Igj4dYit8b2jqcYxzgAjzP2Pxw2tH4hwaC6xcg8n
         pwJecPS1qQtJpX9iCQaAMok+qO3AohEyxo5aqRliGcn6zTJxn4eXEtYxepZevvTqHpLt
         6Ec3/bj+yqqU4I476Xh/9A0DFyM5beIIVmRdAgevFTJJSO03/eBHQwDFUy8D4mDPc6V1
         ybng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J2Xd9LVH817mwGqo0jmHUxcIprXxl3+dYfYgCSyj1Tg=;
        b=Q1lVkXIiZ+3TxqXRBC4Jb4tR8dQYa3eDzRbRlxCdDJ0ZR3iCqXbMHaTtwen9nVSRL2
         QT4+QMSR1/vJenpww4o9q8dL2nGUWlzlczG6r6Ylex3WzC5Ykiz//JKx5i4wPBpYVU2D
         EoN6TYkOQT7sUXM5PU2ZG0NnNMxe/9DSG81NF0tY57qISPFq9xoBJSGYQqMlHuK94rJG
         bjJT9Om0fp0YPUyajeGFQ9d6MFhgbCa3/UQAbf+RwjU8okkE1JGN70uxPrGjjx2nJMu3
         Zc+k6cjajEF56BDrHT9SLcndqvnpCEbNCOZWqRFmZ00V5WhuZwJ4fjQnerdf/P0qWqzW
         vkbQ==
X-Gm-Message-State: AOAM530DS8Xwm9mFeQVC8MYO4kGzkk5uLjcr2ovnmpw0rACSxPJYn7j+
        uD8ItwZaeK09x38bjWLCIZHGq9TANZRCQg==
X-Google-Smtp-Source: ABdhPJwno3LkHZkor9SHc8gySLd8Qe5hOmS212DNb6x62L4UmqpMMtbgDwauzxy5WbJfFNMMlQYqkQ==
X-Received: by 2002:a63:f44f:: with SMTP id p15mr23149947pgk.141.1610911177839;
        Sun, 17 Jan 2021 11:19:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fr1sm2911056pjb.7.2021.01.17.11.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 11:19:36 -0800 (PST)
Message-ID: <60048dc8.1c69fb81.09f8.710f@mx.google.com>
Date:   Sun, 17 Jan 2021 11:19:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.252
X-Kernelci-Report-Type: test
Subject: stable/linux-4.9.y baseline: 137 runs, 7 regressions (v4.9.252)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 137 runs, 7 regressions (v4.9.252)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.252/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.252
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      10161a5e7a07212efa9152f31611570ba95b3b24 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045b0e3a76b4e61bc94d11

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60045b0e3a76b4e=
61bc94d16
        new failure (last pass: v4.9.251)
        2 lines

    2021-01-17 15:43:04.443000+00:00  [   20.420196] usbcore: registered ne=
w interface driver smsc95xx
    2021-01-17 15:43:04.479000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/118
    2021-01-17 15:43:04.488000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045afafcd81f6c91c94ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045afafcd81f6c91c94=
cee
        failing since 59 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045b38dcfb8ca5d5c94cf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045b38dcfb8ca5d5c94=
cf3
        failing since 59 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045bc9f0615319fac94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045bc9f0615319fac94=
cc9
        failing since 59 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045ab813a4273612c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045ab813a4273612c94=
cde
        failing since 59 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045ac0b7a6e4a2c2c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045ac0b7a6e4a2c2c94=
ccd
        failing since 59 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60045b712d343043a3c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.252/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045b712d343043a3c94=
cc4
        failing since 59 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
