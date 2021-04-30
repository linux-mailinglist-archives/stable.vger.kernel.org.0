Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BF5370274
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 22:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbhD3Uwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 16:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhD3Uwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 16:52:45 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E727C06174A
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 13:51:56 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b27so939768pfp.9
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 13:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lHSeMubnL1ZC/KDrSQJ0awX/BeCYA6yrgVys4fJ257E=;
        b=i9i6P9rrplWPMczAk37ZgM+u+geE5OlJCrzrr7T+pEZuyVuEOZp6j3hrD/Jgf3FuSh
         nKYajJKjYkdJL9wrZfrAa9jIdzro2LEssTcX5EvGXyvlnfgzJ49Mr4Fo6L8LLdOk6lgv
         u28SMPimiXWwOWheU+lS2yHAoQhP7W1SRj4vUCnbB4nwholT2vm0yo+qv6HCnUlONZDW
         IWJ4ib2GJ9O/VgTg5SmRcLEAkGCssVi8fe2a3bhjuDqHRcMAhPaKZcCixZ3LFzwFcIC2
         BpxXx0dD4ZBf9VH/QJlms+7Ptyxhm3BbfVGexGAPKAbnMI0XHb7pDbUVyVTcubQMISU1
         P14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lHSeMubnL1ZC/KDrSQJ0awX/BeCYA6yrgVys4fJ257E=;
        b=krZfNobDxqWfXyG774BCMP3Li/Mr1wOFsNltXtLd99UdGv4TCep23SqV1FtnRdizZC
         c3U2WNLPbPeePzbl/kOXOYnLgo+Le3Otg+J9YCQjtp7VqxcabFtvALPz5saloAQ2xuvh
         tRv9hNMV9ap5+4HOb00yJBVk2MqaLm51eRtl9OPTgn8q5uR4A1X3Xal2IZki+UIkVlgN
         990MthS88VGg92sMqjZbb85p0HLY55GxAkry96++cvaktqSM2h/i/hhNMkESScIQvJx/
         KZNmKQtneJAG8JmoeihvZ0Jz5NUKrVoEUpHrsS6rLhAMk6b3n3qEBDOw4CKqY/Eq3NBA
         sRyA==
X-Gm-Message-State: AOAM530I0BiEvjQFgAJRBl+4Zm59Q/YeOaopwfCvN5juUt5YHPa5xfug
        11TFYXvzoz2mJiNDR9cxOPcTP5iSI3netZQS
X-Google-Smtp-Source: ABdhPJzj7fdhl+XnPQu1RCzv9isSuYdKQcxg5HhVUpNQnrZDZDaPmq9rJGZvAhatmvoaZHYftVOPtw==
X-Received: by 2002:a05:6a00:1502:b029:275:f676:5eef with SMTP id q2-20020a056a001502b0290275f6765eefmr6835694pfu.30.1619815915924;
        Fri, 30 Apr 2021 13:51:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17sm2877393pfn.60.2021.04.30.13.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 13:51:55 -0700 (PDT)
Message-ID: <608c6deb.1c69fb81.a57d7.74d9@mx.google.com>
Date:   Fri, 30 Apr 2021 13:51:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.189-1-gbab36f93665a6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 4 regressions (v4.19.189-1-gbab36f93665a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 4 regressions (v4.19.189-1-gbab36f=
93665a6)

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
nel/v4.19.189-1-gbab36f93665a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.189-1-gbab36f93665a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bab36f93665a62ff5bdfd7359eeca2ff04b59147 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608c352c64350e81f29b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-1-gbab36f93665a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-1-gbab36f93665a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608c352c64350e81f29b7=
796
        failing since 167 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608c34625ece4de5c99b77c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-1-gbab36f93665a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-1-gbab36f93665a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608c34625ece4de5c99b7=
7ca
        failing since 167 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608c3622b9cb1fc0879b7808

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-1-gbab36f93665a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-1-gbab36f93665a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608c3622b9cb1fc0879b7=
809
        failing since 167 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608c4c5b06bcd1b1939b77a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-1-gbab36f93665a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-1-gbab36f93665a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608c4c5b06bcd1b1939b7=
7a1
        failing since 167 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
