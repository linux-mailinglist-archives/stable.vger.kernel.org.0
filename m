Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0662EC7AD
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 02:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbhAGBWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 20:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbhAGBW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 20:22:29 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3E5C0612EF
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 17:21:49 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id s21so2774637pfu.13
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 17:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j3qVsTj61F5FLvbHBWCXKGzilRycXNBogM7ADHEvmfk=;
        b=PM2lZnOmVXYo8Z+a6ruKQX926LwFZI40UyoEBpESb8ZqBOpDVevbDFWbdYy/GQ8WTN
         gXB3VMdoRXyXGikJ4IYzJufLUJzX+uASMp1AZ4UFDzxyKM8kEzgGqmjFhqOXzwH/AoAC
         00aW/I38KUy8gEWyxol1irFuGO4JZzpwXm5J7a6gZnWH18RswLSRZKs7gX/o6UV6EwSG
         bVrF9PmLB+hSBMZnCsQ7r1I57lU6CnDI+bx2taZTnVTAL1VTNXqzS6PSCrA8Mlsy31wT
         3blTdFWS+qYnzjo6i3bokDBekXmbOlR/O40j8ew0sF70bAvfRhc+/ZJ8XsORaJpmDySv
         xgDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j3qVsTj61F5FLvbHBWCXKGzilRycXNBogM7ADHEvmfk=;
        b=pArJLpElKXYcm6eVIcfaXfaGc6jzPRYV5H1GyQAca6k6Xh5wHDNSRgeLiTqmSk2Lt0
         r5fYYF9bPByYvOiedyVo/hCQxGfUDYVH11fF0REbvFgG0iOEd0tBfGMzg4oNkOTJYgPJ
         yeH0o1ZvTc+I/DYu2xrX3RIv5DFcLV03GEV7PBIbEVVYW+hDHKAsibnI1pHx8OBJNdUF
         NWeyh8FBOYBnoUx7Mz3Nnqy4YvI6f3osujTjgtMAI1VveMXml7T8XaOzo4ciBg5BauIw
         JkVcaDhazmv491fCsY3TOyPML0MhWiwcK1dny/wTu/HAc6DGDL0jzj3d/MMEjQj3sO3p
         JXaQ==
X-Gm-Message-State: AOAM5330QCfs7hk8N4J40EX+qyFyruUIAagKc7eFW1gVEGEHo3Rj5w4S
        JIDrh0UZV8OiBu6Njnz/CobR/C3GIj4Qug==
X-Google-Smtp-Source: ABdhPJxXGgK2EL+LEhXBumOQFE6Snch0fnTLpK8MQnE+k0mTCidKOc2B34XDIgr4bQKiUaRiGnCwEQ==
X-Received: by 2002:a05:6a00:2259:b029:19d:cfba:5614 with SMTP id i25-20020a056a002259b029019dcfba5614mr6320878pfu.35.1609982508811;
        Wed, 06 Jan 2021 17:21:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm219485pjs.25.2021.01.06.17.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 17:21:48 -0800 (PST)
Message-ID: <5ff6622c.1c69fb81.e94f3.1041@mx.google.com>
Date:   Wed, 06 Jan 2021 17:21:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.87
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 180 runs, 6 regressions (v5.4.87)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 180 runs, 6 regressions (v5.4.87)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.87/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.87
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b3f656a592f3ade657d14888fd3dc92a14975890 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff6288b206b85b352c94cd8

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5ff6288b206b85b=
352c94cdc
        new failure (last pass: v5.4.86)
        180 lines

    2021-01-06 21:15:39.995000+00:00  kern  :alert : addr:b6e96000 vm_flags=
:00000075 anon_vma:00000000 mapping:ec3527f8 index:6c
    2021-01-06 21:15:39.996000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-01-06 21:15:39.997000+00:00  kern  :alert : BUG: Bad page map in p=
rocess ip  pte:2b74f18f pmd:04549835
    2021-01-06 21:15:39.998000+00:00  kern  :alert : addr:b6ec1000 vm_flags=
:00000075 anon_vma:00000000 mapping:ec3527f8 index:6c
    2021-01-06 21:15:40.038000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-01-06 21:15:40.039000+00:00  kern  :alert : BUG: Bad page map in p=
rocess ip  pte:2b74f18f pmd:0453a835
    2021-01-06 21:15:40.040000+00:00  kern  :alert : addr:b6e89000 vm_flags=
:00000075 anon_vma:00000000 mapping:ec3527f8 index:6c
    2021-01-06 21:15:40.040000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-01-06 21:15:40.042000+00:00  kern  :alert : BUG: Bad page map in p=
rocess ifup  pte:2b74f18f pmd:2adf5835
    2021-01-06 21:15:40.042000+00:00  kern  :alert : addr:b6ec0000 vm_flags=
:00000075 anon_vma:00000000 mapping:ec3527f8 index:6c =

    ... (162 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff62920a6caa7254ec94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff62920a6caa7254ec94=
cc2
        failing since 49 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff6285f0140acbc79c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff6285f0140acbc79c94=
cc1
        failing since 49 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff62871cfe6b43b64c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff62871cfe6b43b64c94=
cc4
        failing since 49 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff62872cfe6b43b64c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff62872cfe6b43b64c94=
cc7
        failing since 49 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff62822bd1b4d2164c94d16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.87/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff62822bd1b4d2164c94=
d17
        failing since 49 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
