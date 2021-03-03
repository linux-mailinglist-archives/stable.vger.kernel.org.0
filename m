Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D5C32C841
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377431AbhCDAfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389714AbhCCVqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 16:46:25 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2DDC06175F
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 13:45:40 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p21so17354230pgl.12
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 13:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aXrEN2zsa6UR5cRpfa9AEdXTllIUXWY1QSLjNuZCJzU=;
        b=epXDybZNUGG+v8m+Bh3RE/Geog9S6G8I9bi4L3IFC5Ua6704/DUbZ8NXBSRYQSGyTo
         YpDaLA4DlUMWdapLhs+TD3f+ahjTSmHgkdRyQHO8AjmQEkURCxSVNDdCUE+h3ZCpTpgz
         SbQc5jQrkYuH7EcqAxLTwSYRQXa8ETveJqxpF9upmYplNdbcf1x5ImZhGC3LqyxSzABH
         mW7/m4QNLSeHavSwwNONZ5msha65+3u2FmEj6TwT5BS0GLGnugSfe8iuojVQ/ve/xkYW
         cyzj6XgdFIxCrii48MWCQvUIOSXA4EFMS01AjxmGyoMO449s851kXydFbKH4FNqqVxlv
         t67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aXrEN2zsa6UR5cRpfa9AEdXTllIUXWY1QSLjNuZCJzU=;
        b=rkLy+DlenUendmPIV3F0Mn8h7F/UIh1v+AqCiPIUkCvz9d9sD3hmF4NEsOUZ9ohjUP
         w2vTxiw+pbeuVjVV9X/X6JiSGb67Nv54/evzX4555oFmKVgfBQw/nh4xGUX7eA0Oihjk
         99J3IQvnF6Ec6cyJtyzZpMIgU8CaShzmPdEAeaf99Ke5vNW1a4NBpKt4KZgCYnBHeB8M
         kcNmTv8Hx3ijEDHpeF6e+reugJqkZ/ijBbkxmxbygoyvznwL3sXgyIB9Uj5VTip8c0Vj
         zy8icniPuy9DbCAg7TB7F4iCrKtrN0/5SFf8sv+pYP0OFRtIDqXbfOI77sc8HHYFtN0p
         FmNQ==
X-Gm-Message-State: AOAM530X0JLNNK1LDNY9xl01TawbaDg/5sNS0eN7PE5mrNqeJr12FkNT
        rdTHGy7n9iejqJqADPktECuSZCopS4TSwip7
X-Google-Smtp-Source: ABdhPJzZCbou/+QgFYRzxEJ4VdvfeLZdDmejd2dl4MABKSXR/hBSzXzPxbNS8CvymXBIzE/f20k6xQ==
X-Received: by 2002:a65:6799:: with SMTP id e25mr859121pgr.388.1614807940291;
        Wed, 03 Mar 2021 13:45:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f13sm6977749pjj.1.2021.03.03.13.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 13:45:40 -0800 (PST)
Message-ID: <60400384.1c69fb81.e8d7f.d9c4@mx.google.com>
Date:   Wed, 03 Mar 2021 13:45:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-246-g660d05282cf58
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 91 runs,
 3 regressions (v4.19.177-246-g660d05282cf58)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 91 runs, 3 regressions (v4.19.177-246-g660d0=
5282cf58)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.177-246-g660d05282cf58/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.177-246-g660d05282cf58
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      660d05282cf58c4661bbd433ed3734ddbeb7a526 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fd045c992b8574caddcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g660d05282cf58/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g660d05282cf58/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fd045c992b8574cadd=
cd1
        failing since 109 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fcc155f1b1c466eaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g660d05282cf58/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g660d05282cf58/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fcc155f1b1c466eadd=
cb2
        failing since 109 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fcc215f1b1c466eaddcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g660d05282cf58/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g660d05282cf58/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fcc215f1b1c466eadd=
cb5
        failing since 109 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
