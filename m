Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7C12F0318
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 20:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbhAITJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 14:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbhAITJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 14:09:34 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD57C061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 11:08:53 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t6so7419835plq.1
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 11:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OlhUc0pMoUQ8GZEp0yo22CZY/clYgJQMQjBO/JkotVU=;
        b=ZwcNTmmw1DtqVadO6BicCzKcwqsXjfzAKDb8C9AbBLCIuRuZlN9C85Nh/zVpJ7kR7K
         YkixrVyiWfZNhHt/PLeEyOv9NEpZGShCEsPp6tTI8wI5R0G2w/XX6FiMtE7l9SeoVTY7
         e6OTCB69b4B52+BdiXcVzfRiUSkIIKjJXvgX/PCZdEwXcVGoS4KY2Kf9ZtMiOjnu2mlX
         COd3MjdL9jUMUtyXwnNN0u+jbtyhHccTLaSsXmQn8UzyaWet9EHXQ2Dxvuc7bkOeLbrq
         2LxgSCIN94Iav/PK/SudpeisNlNppcDYhlCstQfX1mbN9E77caBV+JUznHffBYmEp4qV
         IZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OlhUc0pMoUQ8GZEp0yo22CZY/clYgJQMQjBO/JkotVU=;
        b=jGtXxzzldO7DqZs9RXjXkfz2msKx7lL4+lSIrFfSY3gvC3LfBNg/UEvtYMiYGC9Itl
         C6ksU1RTGheijL6LCGRdm089OtAidqin0XvpyXRGR3wNxTYXdd72gRGW9vyv9UpRZsud
         ynoCbvG/HuytPshQylOoRH6CTaY7sK5h/n8a9dgGpyoDbr1JfYDNqXn989EiFMqQKV+0
         qQ0hgh4uVVTLQFXt8i62IhypyxCM1rG/uJu3iqSFZOeXocqwg+ucKBh5Q7+Ia6poWV7L
         radHbSIN/qh4AfuLNrQhAXMtwme0CNojCX3cTsXHWd5/QgesDCTLd665Eznc1QsGJps9
         xnOA==
X-Gm-Message-State: AOAM5307CN2ErcxvV1iLxLp9Fso4KZNIGbq+kSzOU9zUIvGCj09qwK2R
        8KzHFotXfbtJ+tADJT0XTCIaHUg477Finw==
X-Google-Smtp-Source: ABdhPJzHbJBOaSyHoOK2RgDwUDui6XTFroUf8x5loRyfAf0weMsICGkR2pYhDPVZMG1al+X0URs0Pg==
X-Received: by 2002:a17:902:9a44:b029:da:3d4f:abe1 with SMTP id x4-20020a1709029a44b02900da3d4fabe1mr9472498plv.16.1610219333128;
        Sat, 09 Jan 2021 11:08:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v15sm13110282pfn.217.2021.01.09.11.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 11:08:52 -0800 (PST)
Message-ID: <5ff9ff44.1c69fb81.7ae1c.e04e@mx.google.com>
Date:   Sat, 09 Jan 2021 11:08:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.88
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 201 runs, 6 regressions (v5.4.88)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 201 runs, 6 regressions (v5.4.88)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.88/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.88
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f3a4c8d501452b8c2e04c4500c317ce4bdb1b47c =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9c55e7453dfd1bac94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9c55e7453dfd1bac94=
ccc
        failing since 51 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9c2ee0c57d9ab38c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9c2ee0c57d9ab38c94=
cc4
        failing since 51 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9c2fa0b42eb45dfc94cf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9c2fa0b42eb45dfc94=
cf5
        failing since 51 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9c302790222fc97c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9c302790222fc97c94=
cc1
        failing since 51 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9c2b1bc5415d970c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9c2b1bc5415d970c94=
cc6
        failing since 51 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9c2b3bc5415d970c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.88/arm=
/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9c2b3bc5415d970c94=
cca
        failing since 51 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
