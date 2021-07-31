Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427F03DC60D
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 15:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhGaNHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 09:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhGaNHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 09:07:37 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5431C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 06:07:30 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d1so14390808pll.1
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 06:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jebPuzSY0zfvAs+TMVBNcUdSpCC6m1iSCgM8F9b8mU8=;
        b=ThtrkF//PJW9tKOJynEzge0u7YmXc7/xIZrKzEvg7m4GGya9Nql7rdLVb55aTK1G1j
         P1TNVZU0aIKtfUqC9mVfuiFpC5w1DGBe9zfsi63xMjCrzKpQwc6WNNGLMVvQwJH39Xji
         ZIdUqh2o5RBYF20wPmKhtLBL4dO1M/cYyLiBaspyrwCmh9n1ibZtHhCm70+sllAQSBMw
         aJ3c1+8ISwa3CjbECcCI2yUMeyE/dQA2STwTVnDLAtwrAeX9gPZwoXdwZWmUuNLcXhen
         G1dEzna4KfAhEiMza7Hp6ahnevKz1zNkduDqkWp89gacaOViV5lwZLrRq4bo7d2SJbNh
         TuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jebPuzSY0zfvAs+TMVBNcUdSpCC6m1iSCgM8F9b8mU8=;
        b=Njx03P7WhxHhtz1gSJLE/X3GdKzry9dMainjOkrnjb3RJ/ogtwqxA/zXj7DBcVXAJp
         XreQJ8YG3j8hgAzMmFZKlO/BBJPzKD4plOAMNf3tHiZOjGo41lamNNdvprZjVVJ8k55J
         r9xbgcizY9tdAJP3e4IS7R2p16L+lxgcWwz92HMPVzrJAbcxnAUkuR2B1M1QkiShO5Li
         071fCSqL+Zdge19IXyYJyKVoQXooqWNLMoWX9TuejSVQIl1vyzXHK4XBJzMCMnvATzwH
         9ufzpZUiMaQ07/y2kAnz+AsZqv9lBJTE4JLDOfS3O2W7/kHxPdoTDb82Xh7l0e93eF4R
         jCLg==
X-Gm-Message-State: AOAM531otZp2vcWxldOF09TqQqgEhpGY+FPW6Fz5fHJ3DtaW905QtEv9
        EG/4w8FwCAEDZOawiVQXb9PfLzjG0i6U++fk
X-Google-Smtp-Source: ABdhPJxKDh04vrt/OdekTp96KPXn0dJ/jXc0iG8U4B4smNmEcf752DFGeVDLrdk5D+ztcVUjDiVyeg==
X-Received: by 2002:a63:e547:: with SMTP id z7mr1092504pgj.65.1627736850242;
        Sat, 31 Jul 2021 06:07:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm5141192pjq.10.2021.07.31.06.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 06:07:29 -0700 (PDT)
Message-ID: <61054b11.1c69fb81.ce133.df94@mx.google.com>
Date:   Sat, 31 Jul 2021 06:07:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.137
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 150 runs, 5 regressions (v5.4.137)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 150 runs, 5 regressions (v5.4.137)

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

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.137/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.137
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5b1de8e15f0f3c4f91bf361c2bab5c2d9e7afad9 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/610510706ebb1e70a285f46b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610510706ebb1e70a285f=
46c
        new failure (last pass: v5.4.136) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/610513cf366a5dc48685f494

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610513cf366a5dc48685f=
495
        failing since 254 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61050fcf8dc20db95085f49d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61050fcf8dc20db95085f=
49e
        failing since 254 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/610515843af4037a3c85f462

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610515843af4037a3c85f=
463
        failing since 254 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61050fbc8dc20db95085f46a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.137/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61050fbc8dc20db95085f=
46b
        failing since 254 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
