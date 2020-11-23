Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B8D2C0BFF
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgKWNe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729847AbgKWNez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 08:34:55 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17016C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 05:34:55 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id v12so14883885pfm.13
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 05:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XQ4VtwTxcPupvQfuOol3/nDJYM1+xvOIA+KCXdVnRYQ=;
        b=r3eR7z6sbcFCmlKESFsLcxo+80XO/m79f4XhvwZGjbsgFW1+37xRZwimuz7wzg4je+
         w8A1Q2KmHpUGbb4iM6XMOI8ObUzaRJTeZmuktOGYHwTAQ2IMVXzqSMIegTIUVcN76CQp
         MrHnl2Dfs7SA4UvHcqyJxCW3i8AjwTnxKavFcCx3NCMZ4iWtGnXhpAsWWuoNghmCLRFA
         9JX5CnTtAWdxav0uPZzqlGPBKV/ldhqYLMeackG1PvAPhEHEw5C8GEEg8dBO/8aUFM2P
         biqi89iAKmi5G/F4aN79Uch+oULAKzEN7kfCUpIpbASD9GDnk+Elk30e1LtbEMhhRMQ8
         KuSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XQ4VtwTxcPupvQfuOol3/nDJYM1+xvOIA+KCXdVnRYQ=;
        b=PYij68MGs9DYmhsxw3lWjj1xz95WDdlWegNW6X5YofyRVcS+aR9/Tf8ID8RIcJOE3J
         F8xnxS8xZvMq5vI9sV9J4TLMj4fNmS1TSFRJcB4hkNGmT5yudfjVp2qOEUnB9f3gVIU6
         BT+NzwAYy0Lqyl5+BrFOccTe28XmD0XbkixWicCw+PZBOOpgQwd6W+8iiUQIJ4oxNDU8
         1CfuIBwM0XIVRWTiY0lHKkag1MccabDIu2xDhjlkb9XJphTroHCgA3S6pYOxRQfkj60n
         +ClgCM+QxUBgMaSN5vzxey7Y5tinEyXB9iAh/w9YozT1omCPHL9xr/iCl8Hh4gOxMyXz
         DNEg==
X-Gm-Message-State: AOAM530t8ITyMMThkqgq4swRRbOiggFQOUDT5sJjbU+kLTBnVQG+vxLp
        KnQLfWl3elD2BYz60j5cOY0wqMknuzh/aw==
X-Google-Smtp-Source: ABdhPJw+/bIllYV9teVvs8+atyDR5Zyp3mj8i4cl9dK7b8CA42UAej74hbyW39o+vq/nXxCHwir8zQ==
X-Received: by 2002:aa7:8ed0:0:b029:18a:e177:7bce with SMTP id b16-20020aa78ed00000b029018ae1777bcemr25902265pfr.0.1606138494203;
        Mon, 23 Nov 2020 05:34:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o29sm5335034pfp.66.2020.11.23.05.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 05:34:53 -0800 (PST)
Message-ID: <5fbbba7d.1c69fb81.a1295.cddd@mx.google.com>
Date:   Mon, 23 Nov 2020 05:34:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.159-74-g444d23e5b966
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 166 runs,
 6 regressions (v4.19.159-74-g444d23e5b966)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 166 runs, 6 regressions (v4.19.159-74-g444d2=
3e5b966)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.159-74-g444d23e5b966/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.159-74-g444d23e5b966
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      444d23e5b96650914d017a140cbadabad6a4b5a0 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8147b8e3d00178d8d8ff

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fbb8147b8e3d001=
78d8d902
        failing since 0 day (last pass: v4.19.159-32-g9230dcfcb9bbb, first =
fail: v4.19.159-65-gf0b846fa9b5c)
        1 lines

    2020-11-23 09:28:57.620000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-23 09:28:57.621000+00:00  (user:khilman) is already connected
    2020-11-23 09:29:13.428000+00:00  =00
    2020-11-23 09:29:13.428000+00:00  =

    2020-11-23 09:29:13.428000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-23 09:29:13.428000+00:00  =

    2020-11-23 09:29:13.428000+00:00  DRAM:  948 MiB
    2020-11-23 09:29:13.444000+00:00  RPI 3 Model B (0xa02082)
    2020-11-23 09:29:13.531000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-23 09:29:13.562000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8469005f4197dbd8d93b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbb8469005f419=
7dbd8d940
        failing since 0 day (last pass: v4.19.159-26-g0e1af0d881d4, first f=
ail: v4.19.159-32-g9230dcfcb9bbb)
        2 lines =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb822bdfc0693ac2d8d90d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb822bdfc0693ac2d8d=
90e
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb822ddfc0693ac2d8d910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb822ddfc0693ac2d8d=
911
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb82206a1a4707e2d8d935

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb82206a1a4707e2d8d=
936
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb824f285517d367d8d8fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-74-g444d23e5b966/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb824f285517d367d8d=
8ff
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
