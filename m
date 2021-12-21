Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F61747B831
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbhLUCFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 21:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbhLUCFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 21:05:11 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598F1C07E5C5
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 18:04:37 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id q17so9493639plr.11
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 18:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gdvtQrn6f8mmJBCROo7DC7rqEDluH8HZcuT6rxwKhjs=;
        b=iHcxejsU3i+HBqEPEp1I4ZRHkBETjBEiCfOoNjUJufpYYgSL6TkawOsI95ZHG8hVJL
         o/vwQbWHSXBbPUIm2LFWds0pTBVbk4R3NgZECZmyk5U40XyWev7PfscwGYuVu/Tt0y32
         g+2+E4K02XcpD+55TDq+sMc5B4AW2D1pdEoZl+GRH3AnlEdPohyOjvTLSmdJJXZ37wbf
         uZouVK5TTyBQzzhRdyvZyRvUpXaPRVwndirKxXgKQ1F0cDtyn2RiFmd23UcsVAfXVvc/
         ZI56r7Ozeagp9cncdhdXSewAcNKdnpjafOkg6UqG61613RQAZmcefGoDtf69YXg9f0BJ
         BSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gdvtQrn6f8mmJBCROo7DC7rqEDluH8HZcuT6rxwKhjs=;
        b=whxEbcUxMZ5CXevREBUdKiazyKdHE4j/QSQka/3WbDo2KSyvEnTqTYGmZ6Vu4eoKF7
         NOBzj3WpHCV2OmfW2WTq2Bkj+6FwYScGfW03+1nAoECPUHdHe9c+yEDAu5l0mM9isTj4
         xlbrYFM/Du75Uaf4jyP0ZRP5YUlGsy+cM/kVjYpIIP3mDV8qdKVy51yqT0GyDvUYOzEx
         JcX8tkynhx6hvGZ5HR/Zo00vKWK5bDMp1iqDglYGVdU3Fyg6utseFhtqhVZPk8A1JuRr
         Ax11H6XdNin0Fz8sCdR8vJD76rESCAE+QWOwEqAmLbh8lmhVppMER1WEAU/xu4WBwaKp
         yHqw==
X-Gm-Message-State: AOAM53283Nnbqc3W36f+H0L8cpYlLKnn5TYo8DzLOeAhhNPYzsq2FeMk
        1C8KgAsBj6hNopSw0kbqJcKwA0sQ8nF0sC+i
X-Google-Smtp-Source: ABdhPJz4+LMUOLOBNzyBwWeJQqxb6WES+poYSxd3EPtvOgJuQH3xHwiooSv6qSHo25CkipBG3B+TwA==
X-Received: by 2002:a17:90a:cc12:: with SMTP id b18mr1131681pju.222.1640052276665;
        Mon, 20 Dec 2021 18:04:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm19700809pfl.88.2021.12.20.18.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 18:04:36 -0800 (PST)
Message-ID: <61c13634.1c69fb81.4951c.75f4@mx.google.com>
Date:   Mon, 20 Dec 2021 18:04:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.167-71-g2668f7ae1c9f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 146 runs,
 4 regressions (v5.4.167-71-g2668f7ae1c9f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 146 runs, 4 regressions (v5.4.167-71-g2668f7a=
e1c9f)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.167-71-g2668f7ae1c9f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.167-71-g2668f7ae1c9f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2668f7ae1c9f1288321995740152bda7940e95ad =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0fabae3dd2213ea397129

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-7=
1-g2668f7ae1c9f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-7=
1-g2668f7ae1c9f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0fabae3dd2213ea397=
12a
        failing since 4 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0fad38c5580217f39714b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-7=
1-g2668f7ae1c9f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-7=
1-g2668f7ae1c9f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0fad38c5580217f397=
14c
        failing since 4 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0fa91b52fb26e3a39714f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-7=
1-g2668f7ae1c9f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-7=
1-g2668f7ae1c9f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0fa91b52fb26e3a397=
150
        failing since 4 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0fad26fdf38620b39713a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-7=
1-g2668f7ae1c9f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.167-7=
1-g2668f7ae1c9f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0fad26fdf38620b397=
13b
        failing since 4 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =20
