Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5439A41E59B
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 02:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350283AbhJAAqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 20:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349760AbhJAAqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 20:46:14 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64570C06176A
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 17:44:31 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k24so7886821pgh.8
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 17:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Af9xcJtsLbZFWkWRZ8sGp7HXoof3lE3LmnJ35mtXkGA=;
        b=dqrU2nVY6i532WKoWJvvkFt2yNbDgFWG+bT+WKSUrP4SrOumqKuOry2KMR6HPqb3YB
         B/G6v9nqz+VYNNwsN8eEa1nidFrWs9UefRTegoPcFnGrz3l6t7W8mTcVZnbwq8Bigkeg
         61+YJ6mtKP29YGF+00P8jixumihqB+7aDP3q2yEm/rKL/zazdMT3Za3eJpAywv0ILvL1
         99JojkeuJYg41Up/wvyw4KbmT55XAy4MLJYf1ZtLc2N7oJ/DjZndxZDAepm+W+xUFRow
         itOo1xV6ftXqjJvZHA57nj2ObpGbx6EQVJz+LVaxq3hr/u+t5lUwlNc6HQA3P6FQQCyN
         +vOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Af9xcJtsLbZFWkWRZ8sGp7HXoof3lE3LmnJ35mtXkGA=;
        b=6dcL8KWqDgzqxgta9k705dyuvTYFOASDsdZck0V58TpqgPYqKcUeTlPEuYj+4R1p3x
         G+HgFmqINoknWYsFw31iLDr1PoUB4O6QJAEF9Kj0CviNqCBcrcRzjI8JrB9JRm679iK9
         1t12D5Jgc9DssrGuNUCHHGaUO5x5imaRcmWhILwswSZxWP2TcaohEdYulayguFAL1oZh
         vetn/aZx6+Wv970PgdRTPhtoO7oUZ+vUooIkjctrnf4qjH9XqMQdjb31jl2lwqOZxM9e
         QBLOH/7H632m2kzlmEMEP39kqaT6rqDvcFZferxHI4ARSgm/0O5JVHVxYdYSJNDkgC3a
         i4bg==
X-Gm-Message-State: AOAM531NGe/39XCUnuTF057jqscxhxN3owpAc+A2fq8pXumk8Bi0pNzh
        FGC20TfFr+08CbesG9iMwHWDr3EvMzAaNyen
X-Google-Smtp-Source: ABdhPJwSRwRJ3rY0tV/VMNrCIDyHjnxmM8h/FSbQfulOsx3CXJ59X0+pXl407MWjtmIAiGdfZ7S9qA==
X-Received: by 2002:a62:2587:0:b0:44b:2d81:8520 with SMTP id l129-20020a622587000000b0044b2d818520mr7163833pfl.43.1633049070547;
        Thu, 30 Sep 2021 17:44:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm3671511pjf.14.2021.09.30.17.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 17:44:30 -0700 (PDT)
Message-ID: <615659ee.1c69fb81.0e6e.b82e@mx.google.com>
Date:   Thu, 30 Sep 2021 17:44:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-31-gc481e9eb55f9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 106 runs,
 4 regressions (v4.9.284-31-gc481e9eb55f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 106 runs, 4 regressions (v4.9.284-31-gc481e9e=
b55f9)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.284-31-gc481e9eb55f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.284-31-gc481e9eb55f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c481e9eb55f9d35afeef51f620b5080ff9eea569 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61562158a9176d6ffd99a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-gc481e9eb55f9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-gc481e9eb55f9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61562158a9176d6ffd99a=
300
        failing since 320 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6156217e46d4637b2199a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-gc481e9eb55f9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-gc481e9eb55f9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6156217e46d4637b2199a=
2ec
        failing since 320 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61562143ead2243e3399a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-gc481e9eb55f9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-gc481e9eb55f9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61562143ead2243e3399a=
303
        failing since 320 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615621328d66edecc199a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-gc481e9eb55f9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-gc481e9eb55f9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615621328d66edecc199a=
305
        failing since 320 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
