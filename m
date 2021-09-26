Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B405418B06
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 22:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhIZUh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 16:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhIZUh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 16:37:57 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BD0C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 13:36:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w14so13920456pfu.2
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 13:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QXMUCA2C9yVBhnordv741Q+69T2Ucf1Zvd5UqzhYMB4=;
        b=QcJ5uSUDZbn5dq0odNGh93i+pKU2KxuBWPadrqxEg6GtpPWJUhRz/MFnWfElyoOsEL
         lObThVlzTkNAGELAxStZmfzH9lcZJpcFTj0d+6SJx3bGsAv8p5/xKOwmORTheU3cPiKM
         XjUiUxQ/+ous0Q0JR+lcJanPQi7D4Pl7jH+zuYacUDxgnrElE0SSXoyvtFh1CBQijiNn
         COsA1qbpAWS+D0v7tp2yRCgTM7vibeaveaYcuof46UZJEYN3Pi8Ih1XxrhvuYCXX6Pjl
         Ewt8tnaSGikBiewlEWWALYCa3JII5aRCepup0h3pXsJo6aoycQ1m/GtXYuOa05SYSPUa
         UzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QXMUCA2C9yVBhnordv741Q+69T2Ucf1Zvd5UqzhYMB4=;
        b=e/n/taYTuf99HriCRPfQIYkZOrmSlexQ7g/nKopzT2j67NFuI+fyZj0MD0ftNy1wgs
         MlbXlOXYze3xCOFthj9BvW3K3581ODcEBqQUk06YR1t2qt+oNRaTXMJC6x+wC9sibsOd
         i2JeA1ul///perVtBXP6y59YBLZkEeKIZZL/otvjlAg1v5dA7yovkXqVAC82hmegd0na
         hhmbvnXp478kBL3GrR4GakHWXRKKhboFqqNhCRAOspvBh7cw52ZUBZz1nqdtu/4jXGmI
         zUo7rWkxwBjoMwru7MNLxDMn7pNBsUNmPESDYYn1IbGmYoUSAmPsVxZdeEHWaS8aQgmC
         mpYg==
X-Gm-Message-State: AOAM531LjjlF0SXv2/o7S1BdqCQ5XX/fCApa/HEXU31ZEhytnzGj4qVI
        l8ZQ4/kK3qYHrn2ZOln5rSxHTl5v+OE39k/5
X-Google-Smtp-Source: ABdhPJxE/bLzdR+JAB3pgmobR0B6tf2KBL8B6KFAnu+Qd7Z2HJySEvIUpyBr7LY8i0bzHsZdtqB1cA==
X-Received: by 2002:a63:551:: with SMTP id 78mr8026675pgf.324.1632688580036;
        Sun, 26 Sep 2021 13:36:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e18sm14895871pfj.159.2021.09.26.13.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 13:36:19 -0700 (PDT)
Message-ID: <6150d9c3.1c69fb81.9695b.0e72@mx.google.com>
Date:   Sun, 26 Sep 2021 13:36:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 70 runs, 4 regressions (v4.9.284)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 70 runs, 4 regressions (v4.9.284)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
    | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.284/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.284
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4c0fe77545077b5052b645b28b73f3c759b4ba03 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61509d51ec87f4b21c99a31b

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.284/x8=
6_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.284/x8=
6_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61509d51ec87f4b=
21c99a323
        new failure (last pass: v4.9.282)
        1 lines

    2021-09-26T16:18:02.059738  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-09-26T16:18:02.071258  [   10.777912] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-09-26T16:18:02.071652  + set +x   =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150a277ca12d6812f99a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.284/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.284/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150a277ca12d6812f99a=
2e5
        failing since 311 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150a273773e029f6099a30e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.284/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.284/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150a273773e029f6099a=
30f
        failing since 311 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150a22569bb76a72a99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.284/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.284/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150a22569bb76a72a99a=
2e3
        failing since 311 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
