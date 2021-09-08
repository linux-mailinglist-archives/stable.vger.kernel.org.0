Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233F4403E92
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 19:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352137AbhIHRsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 13:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352579AbhIHRsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 13:48:15 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A913C061198
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 10:46:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id bb10so1790784plb.2
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 10:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=66PCOpPA3tRnwjKyWHFwmt4aUD87qqRT4Ps4yoClaFs=;
        b=AOjDR3RFcFMXfqiEj3hoMBHIg5IDcwYVcl7nKMMA4k2s7SgueTxNdxDAnOB30lNJ8T
         OWGClSnjG3eCcRhfGGLNxJHWfIeAolMrDqKNbNVmcj1HP+BvThHjl98ZcyAtqoaGs5jL
         g5syxpppOmG4kgpy+3DezGU1rctpfy5b4Scqfc2WQdmzFf0Y/etAfFXuriSPJ4tKFwsY
         /r0R1wMeLT95/krrK4tSO4E9AdUUDQjrd/6pB0oyBxPt8w6wzabxH/Qo9MhlJDb5grQs
         /z4iCC1eCOe+GLoiBn2ptmxcUdOGE0nV1YryPKA9hFh2wvIl/Tvr2RoVCyz8LYDp5QKX
         OMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=66PCOpPA3tRnwjKyWHFwmt4aUD87qqRT4Ps4yoClaFs=;
        b=8NjGnNHj1wV2myNBc/EOvWCioOsyLUW8gzX5br9Ptj9kjVZZKiHz4RKSXX3iIS1+Ec
         YIGbunrSiEBZGqydWcp0CIMo6v5n03NKp3bTkvMfU1NNVb80tYBMGc+tmmUkWYbf9q7g
         8JhtkDsGHPsfscVYzBDpanUN1/IMSaYWActYOLsKluRtBBtVZh0Nm1eTR2nypE8rvGix
         0C/2Db8CK6QtSWum3ASw1UCM2g+UgFeaP70cdLc5hIS1N4BYxVR0vlPS8sAu2Q07HDvi
         bOLTHNvP5A1UBBr+LH6PEwkHhHGmGnrwwPkuamzIycenuLo5lLyTRdF01LnpiCnhUKFJ
         OIPw==
X-Gm-Message-State: AOAM53356t3F1YOF9148KQ99bUtwn9WRQT1pUrwilRlpWzBhSweZ7sl7
        LnB1LJUncZ03Hn+MIF6lwqEh4N+3+bJi0oIi
X-Google-Smtp-Source: ABdhPJyaLTk6nP5WYMqyPzkBLhtlvCHOyI/Wh2NNe8mge5oGiR+3xdq0EA/hR/pXCz36eY3JEIa6Bg==
X-Received: by 2002:a17:90a:5513:: with SMTP id b19mr5518301pji.16.1631123188292;
        Wed, 08 Sep 2021 10:46:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6sm3191906pfa.110.2021.09.08.10.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 10:46:27 -0700 (PDT)
Message-ID: <6138f6f3.1c69fb81.71144.9056@mx.google.com>
Date:   Wed, 08 Sep 2021 10:46:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-31-g5893d5a47be1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 145 runs,
 5 regressions (v4.9.282-31-g5893d5a47be1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 145 runs, 5 regressions (v4.9.282-31-g5893d5a=
47be1)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
i945gsex-qs          | i386 | lab-clabbe    | gcc-8    | i386_defconfig    =
  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-31-g5893d5a47be1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-31-g5893d5a47be1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5893d5a47be15a0f2d924c921e0d01dd7fbb8835 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
i945gsex-qs          | i386 | lab-clabbe    | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6138c21353946c4b1ad59677

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6138c21353946c4=
b1ad5967f
        new failure (last pass: v4.9.282-15-gce3c8ceec498)
        1 lines

    2021-09-08T14:00:37.641664  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-09-08T14:00:37.650773  [   13.983183] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6138c4137efb1a9065d5966d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138c4137efb1a9065d59=
66e
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6138d062d9f8f224c2d59691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138d062d9f8f224c2d59=
692
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6138c6b49f66058c8dd5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138c6b49f66058c8dd59=
68c
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6138c704a0895cb163d59668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g5893d5a47be1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138c704a0895cb163d59=
669
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
