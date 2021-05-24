Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48EF38F19F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhEXQep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhEXQep (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 12:34:45 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D06C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 09:33:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t11so15158610pjm.0
        for <stable@vger.kernel.org>; Mon, 24 May 2021 09:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z0HxORmlbgZ0Y5hkQ6sKpN4lHW1ed4DoERHpvSTP2q0=;
        b=LxpHRolJqHGk2q55J9HSBAARuFps4cAqgRxMGUFhF1/J1ZS8KmT5Sg2Eg/U6fCArz7
         UTSJDyalWGlOCr53ZACGuW4PlsrkjPILkPVjH1LQ9hZ/5C5xPownEDnddY6HzH7cWe0u
         GXoHKfg9jFQspc6Hn2+KrkuUsv9bNUsXQFJEUucKQrQwL7QFaqyc2ldaTNTfB6R4N8Hf
         Q1nfuF2ltn5Lxweey9Pjls+0vETxw9jL127ccim6HGvBxbMNAI4BJ/lZyU/LYTPEu3Qa
         VoP0CZqlzfoUkqoV1N6Yn1PFzatm81YB2c8PXdC7fVb3gDLZ+Cj3HBtkLeyj0JQ92Hj2
         BI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z0HxORmlbgZ0Y5hkQ6sKpN4lHW1ed4DoERHpvSTP2q0=;
        b=eSoSJImj3K2z4DTZbSpgcfbl5a0qaMNbpj5whNXkGSz+lPHMi1Y+RYUYp/fjhn7OoL
         YQZKOkfpueVC91sTwPYaBSYQpHvCbSts76lLDQ5v2Q6KnDr02/RJITUihhT7Idi2c2CG
         4MQsWKjXbeJSQT8KGT578VNKaGZMyncP799kJq9Gf5NaWdj4lR4PZimREuDA3YHSvFDW
         eAt8fuaakNqdyQgIsPeFZX9sFxDxaMAg8zDh4THPSt/gUV7JF477vh2w6BQxMGkkrgr4
         Z+UTfXuz2WmrJg0+l3mYKPfAG8t5xoXEaIOEcxhOjwTaEcnRVpaKx4XNlhhymKI1AOVO
         I+eA==
X-Gm-Message-State: AOAM530APCj2yD/eAhAlcAeOBBYoV+eB+cI8wS8V/79+JA7fpPHZlLK7
        i2B5lUAfzHvBYbyisbKfRPkbl5BubPfWdKK/
X-Google-Smtp-Source: ABdhPJzdZ2st3Nl6/JhhoXyBq46P38GSJ3fhuT+76QaiS8ZKFNpvoUKchHG/2tsCHXYKZssjFlvGXQ==
X-Received: by 2002:a17:902:ab95:b029:ee:f899:6fe8 with SMTP id f21-20020a170902ab95b02900eef8996fe8mr26094823plr.81.1621873995197;
        Mon, 24 May 2021 09:33:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o2sm10231412pfu.80.2021.05.24.09.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 09:33:14 -0700 (PDT)
Message-ID: <60abd54a.1c69fb81.540f8.0cb6@mx.google.com>
Date:   Mon, 24 May 2021 09:33:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.233-37-g8ff7c96a31db
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 84 runs,
 3 regressions (v4.14.233-37-g8ff7c96a31db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 84 runs, 3 regressions (v4.14.233-37-g8ff7c9=
6a31db)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.233-37-g8ff7c96a31db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.233-37-g8ff7c96a31db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ff7c96a31db01031699dfe651d05d84c59c5ee1 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60aba166f1c6c01e80b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-g8ff7c96a31db/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-g8ff7c96a31db/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aba166f1c6c01e80b3a=
fa5
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60aba0fd63ce04b455b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-g8ff7c96a31db/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-g8ff7c96a31db/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aba0fd63ce04b455b3a=
f9c
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60aba24a90ba030f76b3afc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-g8ff7c96a31db/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.233=
-37-g8ff7c96a31db/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aba24a90ba030f76b3a=
fc3
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
