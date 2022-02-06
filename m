Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1FE4AADAA
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 05:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiBFEDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 23:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBFEDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 23:03:03 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8D7C06173B
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 20:03:02 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id on2so1182688pjb.4
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 20:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ifKOhPGSITtEqXFEsOKRDJerP4xXEZ/eLLt61XbFWL8=;
        b=1IFk/mAm/g1BcmPk7U75ay2/TrnDcraoNSBePDUdwp078KPgRqmNhm9G0hiSIGynQa
         wM4RbFda7jxcssQsRstS7hEgfvfl1PlWSk5E2g5yIkSCHsQKRhP16Z+RHMb0tZdkVRHA
         oq3tnFezM9JEjvQoGBP6fYDprO0Z1ZSVfjvjZc/PclpwQLyNl8Ci2QBZPp81YCV1Nt7G
         4mKq5LQcXUNjgYMSaVtsMJnVnrNF/kZBv3l2jIeTZzj6bHea1nm9tUmh0MacUqzvWnA7
         oCo6nz6Jx6A9pjZMM002QW+ha/+Ba6duyC9swUrJGlSy+/Yn/HRfjYMUwmph5wtnGpLF
         /1oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ifKOhPGSITtEqXFEsOKRDJerP4xXEZ/eLLt61XbFWL8=;
        b=GQxeVXG0uSE+s6NGrvSXePJhvoFMBVxisOofz13DqvXFpq9qUanH/pQKBKEhOuf6HL
         6BDuyrGAzKX3OXTh03BNuE2je20+7Vq87K6lirRx6tXwJ20ldLguQd9pfSYxCnQSdy3a
         4VvY/Bz8MqnDBE3woynePrWf4ayti4iZIS1wJpGPhc7b3RbypaxfkHeChq1t+rkxMgrC
         v/l960nb6Ig5ayJPwPlOtN7y/vc3rccMtIv0A1V8zgBW94clv1IFJDavOdfEqB9uzEzG
         AHrrNQXC92rO0WYhwSSqGsD7BvAuH4a+RBh2bTgQIFEpPdADZfs2UAk1XpfWijMYcXjx
         Ymzw==
X-Gm-Message-State: AOAM5306B5hKGy3YFLLm6wiMmH/Uggfin4bO4R2CW9un77Q9vH/k8hLu
        x2miVQfZ77OCiAQK3RMLhiuM0hBFsYZ8txzk
X-Google-Smtp-Source: ABdhPJwGJQduRfqY4sV2PBmRFVj1ZiNIQ//3YrQn/VHqYn9mQy6Z9YQLy33snLrDy7/FJoGU1QGV0Q==
X-Received: by 2002:a17:90b:249:: with SMTP id fz9mr11484666pjb.99.1644120181386;
        Sat, 05 Feb 2022 20:03:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s19sm7285026pfu.34.2022.02.05.20.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 20:03:01 -0800 (PST)
Message-ID: <61ff4875.1c69fb81.aaf97.3942@mx.google.com>
Date:   Sat, 05 Feb 2022 20:03:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.177-13-gd38aa20195c3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 105 runs,
 4 regressions (v5.4.177-13-gd38aa20195c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 105 runs, 4 regressions (v5.4.177-13-gd38aa20=
195c3)

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
el/v5.4.177-13-gd38aa20195c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.177-13-gd38aa20195c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d38aa20195c32ec2245b351ae36e190ac228bebf =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ff0f368e8c107c655d6f04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-1=
3-gd38aa20195c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-1=
3-gd38aa20195c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ff0f368e8c107c655d6=
f05
        failing since 52 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ff0f40198cbb47385d6f10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-1=
3-gd38aa20195c3/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-1=
3-gd38aa20195c3/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ff0f40198cbb47385d6=
f11
        failing since 52 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ff0f378e8c107c655d6f07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-1=
3-gd38aa20195c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-1=
3-gd38aa20195c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ff0f378e8c107c655d6=
f08
        failing since 52 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ff0f418e8c107c655d6f13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-1=
3-gd38aa20195c3/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-1=
3-gd38aa20195c3/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ff0f418e8c107c655d6=
f14
        failing since 52 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
