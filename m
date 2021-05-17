Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4A8383CFC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhEQTMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhEQTMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:12:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E181C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:10:57 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p6so3704676plr.11
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JGBLiP6+tUnJmjpIz0IA0ADGqhR9RSgYbbg+iD/ySl0=;
        b=aDZ+QCAAJbIXtakNuxfUPpVAFBfoE9djdtnGyLrBj4MYovAhU33LFfaTTt0LASE5JO
         Pg2+Zj0pCLDw70O1AAVe9Kzd4XjwEUwWA1f46lKAAmCIkzZSeSo0cjygFgAVHrHbx6te
         8OhBJRBO76yj5xNlB6q0eZjyweBhRqCA9g+1R9eb0C3QVF7svR96kKBuq1zWJk4liTsj
         fY//I2JG0jL5+XWYQP+4bcZ+pQZV0wepw92C6KzuAf0/3Pmv7Y/avf3VrhIRoUvdN7KI
         qf7s+TqHnkIIV5y457aeQtukA/7qbQYap+UdiKhC528WrytinLUhAcZ1ng2NdNedJzgx
         TXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JGBLiP6+tUnJmjpIz0IA0ADGqhR9RSgYbbg+iD/ySl0=;
        b=EGhvAV+vYYKVLdydxMX6vtr35r+yIh5MghdC2wy8a1cboo3bT5eObg1CR3AIcSYpXg
         o/kr2hz16/1y1qFSmpiSMA4vRB3AsOdfce4Tlgwku20H44E3QlB7QCflRPMaaTGNZFc4
         nuVOkmT1c3iY1IPkgl0VrHOqh0NQU8NDO2/E0uW4GmCBiJPsaAvsfmfEqV1aBmD8J+zO
         E3RCFMthE4tOE6xiNkO4XxXyt6Arp6kCQ7uZj2aOJNqGmw0UhC3Cz/VdSmRrL3UOiAUM
         3AhtHgBzPP3ORMdLr/tlmAEl3IMGQjOOyc7qGj3uIt8R8y2g7ZkBTjr6TFZyfGRomBOK
         oEdQ==
X-Gm-Message-State: AOAM5305yUXanja+ciXWljZh6uDyciisXt3rpAwA3sGRiQGyfbkOl/0j
        eaB/Bf7/zlkdzE7JvFk2iiccWlWDXA8q/PnH
X-Google-Smtp-Source: ABdhPJwYDQAXrKig9x+sgwbMgZCfYEd/VCKAJRbaOLNdqQJ+90/IVNde1wAXyfa6mXOL9mNeTfk3Ag==
X-Received: by 2002:a17:902:f20c:b029:f0:af3d:c5d8 with SMTP id m12-20020a170902f20cb02900f0af3dc5d8mr1379496plc.23.1621278656577;
        Mon, 17 May 2021 12:10:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s16sm11223548pga.5.2021.05.17.12.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 12:10:56 -0700 (PDT)
Message-ID: <60a2bfc0.1c69fb81.636e8.5eb4@mx.google.com>
Date:   Mon, 17 May 2021 12:10:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-301-ge5a8731df5a7
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 94 runs,
 4 regressions (v4.14.232-301-ge5a8731df5a7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 94 runs, 4 regressions (v4.14.232-301-ge5a87=
31df5a7)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-301-ge5a8731df5a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-301-ge5a8731df5a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e5a8731df5a7c7e09507706470738f30702e0f85 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28ec62a35ee3dd4b3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-ge5a8731df5a7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-ge5a8731df5a7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28ec62a35ee3dd4b3a=
fad
        failing since 77 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28a60524fcc2033b3afd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-ge5a8731df5a7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-ge5a8731df5a7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28a60524fcc2033b3a=
fd9
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28a51524fcc2033b3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-ge5a8731df5a7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-ge5a8731df5a7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28a51524fcc2033b3a=
fbe
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28a41c40eaf89ccb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-ge5a8731df5a7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-ge5a8731df5a7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28a41c40eaf89ccb3a=
f98
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
