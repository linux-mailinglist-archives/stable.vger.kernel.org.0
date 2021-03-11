Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0172336AA2
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 04:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCKDYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 22:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCKDYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 22:24:37 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46CBC061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 19:24:36 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso8641062pjb.4
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 19:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L7IHP0047mOu1TbSvcv7++UnZcMgAOpEbEMo0XgED64=;
        b=wMysKh3KK3xoM9y4muithpLequlxHAH1CnT95zSdZPjIimPwYmDgNAFrBjp6fpDI5N
         o1TZEL7ZjnLIYuiqChIZYjxEHwrI/U+JtDWfO7DTbROVinPq4DjanOT/0JrDj8iI5ZOK
         MJ9B+TZfnHj4sclHlN3TkdbA/FJ9iyUaLX+3xJMHwItNFsmG4LAHOuT3jzJcj9jr4vvQ
         t+vu9ACz5juDqZHlAX04invmRQwlIjtoTXxSdo5LXOVhP9hYdRttXfoMT4qvLgUa/c6x
         EbJzDXQi/X2kMne5aFad6pWKTdHUZpH5SLAw7fxt4cFYfa7jJ6etcMxPu9Mh+8r/dw9c
         BvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L7IHP0047mOu1TbSvcv7++UnZcMgAOpEbEMo0XgED64=;
        b=d04Pywo/luLEA/QC2ETgDOWSwm9rEuJfVPj4YQdW7U30u+OrXp65Kt6qdjD0bpL8hA
         C1YLiNw1XLZQbLC04iJWrkjLCrx7z8Rc8PDOY2yNl7HSySBdvxqz8IIyDSRfGSOVuCsy
         aZKVWDY5aB1wbma4fj/9WSJE0vD5a7nQff3LXqPX8dkOO5WVdu3ikSmzQnrx68XxwXWn
         4YplYvtaOLNnA/sv1HrZEETAqnwFS4oGv6x85r2kHFgfhCIlZgmFjWXgGwOetZ7t9Z5Z
         9vrO9HYbC9CQtoo8x1R3yXZtKnpDoiSApzpS0KTrAVIbtgxi57vm6NZZZwUHADnM4ZxJ
         c3aw==
X-Gm-Message-State: AOAM5324Zz7bQ7W1AQwUNwH+CPbF65Y3PmjtDXOOrpa2r4RhiQ2liA4g
        T9iFp3NkCA5/PzK7ysHtGhH2Saalu+/jnitJ
X-Google-Smtp-Source: ABdhPJx/WdEJ2RGAr7Gu2ACGy3PNZ8GQXO9nMR2uiynGCrUcd5/mu0eLOtpWOGve4K5XDLrmPOqh8g==
X-Received: by 2002:a17:90b:1082:: with SMTP id gj2mr6657242pjb.155.1615433076183;
        Wed, 10 Mar 2021 19:24:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q25sm790694pfh.34.2021.03.10.19.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 19:24:35 -0800 (PST)
Message-ID: <60498d73.1c69fb81.2eb64.344d@mx.google.com>
Date:   Wed, 10 Mar 2021 19:24:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.224-20-gb94c80c18fb0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 98 runs,
 5 regressions (v4.14.224-20-gb94c80c18fb0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 98 runs, 5 regressions (v4.14.224-20-gb94c80=
c18fb0)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.224-20-gb94c80c18fb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.224-20-gb94c80c18fb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b94c80c18fb0c726401599103053af60561c863f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604955b15f3e30d203addd8a

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604955b15f3e30d=
203addd8f
        failing since 0 day (last pass: v4.14.224-6-g893f1fb0db77b, first f=
ail: v4.14.224-20-g23c40a6cdbfe)
        2 lines

    2021-03-10 23:26:37.751000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/96
    2021-03-10 23:26:37.761000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604955be400fd2dd08addcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604955be400fd2dd08add=
cb6
        failing since 117 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60495625ecab2a8a94addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60495625ecab2a8a94add=
cc7
        failing since 117 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604955617a8aee79a9addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604955617a8aee79a9add=
cba
        failing since 117 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60495577c53d8a0712addcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-gb94c80c18fb0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60495577c53d8a0712add=
cdb
        failing since 117 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
