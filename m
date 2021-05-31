Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62C3396977
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 23:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhEaV5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 17:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbhEaV5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 17:57:18 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6062C061756
        for <stable@vger.kernel.org>; Mon, 31 May 2021 14:55:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r1so9180763pgk.8
        for <stable@vger.kernel.org>; Mon, 31 May 2021 14:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p23vjgFH49dGgMRETq3wcCQyeM8OepkmoCpr9QSY2Fk=;
        b=URRv/mlT4dmk14x1prrSq5S2GNRyL3XBIxx3MRDMrbm0VaXTmAQHbaN2Epojo/Et0O
         xj2hJUeum87U6ZkmUjvivp2L3MVj+7mVqlRw9JK6WV/gM+FCWJ+DzTBqrWF+h/sWMIuf
         956oXgLKr/dUimVANKMv5ImegLyMdlRIApVd7alr2juE2kNS1txE9SeHz3XvlInztC+P
         ghb1buH31TEHMsIcHziio62p1okczwO7EVXLIOQBcUWEfhOZFkBg/mVPCzZkBHnzv1wW
         DbI75efy/nqC03gUBzK0IZwY5zHKm6R1GBYqL2LKT0NQjjxJPUrHQESIQp5FSs7js3ag
         267A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p23vjgFH49dGgMRETq3wcCQyeM8OepkmoCpr9QSY2Fk=;
        b=m+1nP24tZ6GStcTOED3uanES4ES6/ab5atn4MprnVwGKsfUCzqDaEnOcgCHRBh5LVt
         VOzJzkoJ9tixM6B4+5OWSDvSoU2Qm5seK5zP719D2iJR5dazTiA212NH1BDgdjiejm9U
         fBeqWOpJAyRCIwK9qz0c5w1wu/XBn4vbFnzVaj9KiKNUNXSri++OQbFdTl4++YgOY3In
         k1x1JVsFdkPSYEufY0Y+rGRhfVnfVztX9DKTP8RwvRClTrS18sn0gCLOZqHLMq7RZiZH
         5axwcPh8Q12Wc3ghX2497ZOIL3j77OneuPRDuX3P+/bnz4RQC1YpQcPYaD0S1ig/c6zn
         N+Mw==
X-Gm-Message-State: AOAM531OEL2jJRjEgFHPuyzvXQHWdaReFhomGLZBTXmMpm2iSQSoIPp8
        Fh7VjaXC7M9lT2jh62MFH3hnCzn6rReQ/xvI
X-Google-Smtp-Source: ABdhPJwH32ult8kZ/BlSCaIE9WDCggtnBwaXVRsNN1aX6xXouc4/gcssXFQOY4iCUWYn+9sSCGgGAg==
X-Received: by 2002:a63:925c:: with SMTP id s28mr13093216pgn.260.1622498137083;
        Mon, 31 May 2021 14:55:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15sm2932718pgu.71.2021.05.31.14.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 14:55:36 -0700 (PDT)
Message-ID: <60b55b58.1c69fb81.3e74b.9665@mx.google.com>
Date:   Mon, 31 May 2021 14:55:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-116-g147b6be34aea
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 132 runs,
 4 regressions (v4.19.192-116-g147b6be34aea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 132 runs, 4 regressions (v4.19.192-116-g147b=
6be34aea)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.192-116-g147b6be34aea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.192-116-g147b6be34aea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      147b6be34aea3bf6fe6fbd32a5a89d6050c7919e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b51f4ea6f3396dd8b3afc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-116-g147b6be34aea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-116-g147b6be34aea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b51f4ea6f3396dd8b3a=
fc5
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b52096c8674decd4b3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-116-g147b6be34aea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-116-g147b6be34aea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b52096c8674decd4b3a=
fb3
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b51f74c5543ed843b3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-116-g147b6be34aea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-116-g147b6be34aea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b51f74c5543ed843b3a=
f9a
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b5336b9288e3d158b3af9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-116-g147b6be34aea/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-116-g147b6be34aea/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b5336b9288e3d158b3a=
fa0
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
