Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCFD32D3AE
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 13:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhCDMxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 07:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbhCDMxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 07:53:37 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41777C061756
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 04:52:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id u12so6873379pjr.2
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 04:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ck7DEEDXBKgJqJBgNvD8d/qW6j/7FkvQJ+H+eYjdydU=;
        b=GVgLBU6T7Jw3Jr2MWPEMj3Dh0xQS0dzXkzRnuwIMNWa/EZZpA+RFXhdMUnD8owdORY
         kDtyE5hA918WC4YfIcuMXBQihcPojL11W0CRF7WNsruZpA4Fb/o09FvMmxxdu1Wku3TP
         Rxl8iP/W+DKj1ebU94cR9Th2D4dB+znKBrY29Wet8shvIi1FY2zujkCXb89JG5i6rc3j
         lsCcYR36SizH59ZM89EIoPUP3O5sMQzL0n/z6HK5tjEByJfQ9t5ILEmObuE2CJ1Fc3Q7
         Ocwn2AYN/d+UaavJ8ZvsBTxULfojjnVhxrIgwN3i27wYg7f99vKeKN2aGMh5kmX5Kv3C
         Ui4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ck7DEEDXBKgJqJBgNvD8d/qW6j/7FkvQJ+H+eYjdydU=;
        b=RZ062cPUg88hQ1SWlpTsAEd59mY1uuK/FhBOnrbsSN2TSW0mecWjGCM1x/cdGreMM2
         kN6BUK+7U88er8Q+XpC5XeAR1GHVSQtyjEqBpAP17U3RRs1xXJtIF2lxsYzUR8ps6x16
         VYDMsfTd9vFLU3CtVBEPSEpw0z22Sz82UnEr6EZHP9pOuybqN9KC8pj4VCoaHr5JhBiK
         ejKRlmZnM4EAxg4j/ohXuRQqdXwpMOergfJ30iIQu5tb5yVrteOIszTliyhEeJdoNJzD
         PW2yDJ5v51RldbQmaL07mBCCPLe6uZgbbkf0omWMI/xTedgb3gExohYIhjaReGaO+qvR
         kp+Q==
X-Gm-Message-State: AOAM530uAtwIuK7IlTpgVFNB6lxlMRZRnxhIuEH0v0CN5vFZokLcxL2T
        MqQM2OvxSw6gjVIMjCb+zsVx43Vqi6QLWUJc
X-Google-Smtp-Source: ABdhPJwxjcltzR68CRuyautpYW9ODZ/H72ShSfh8eaQwtLlelsC7r2Fx4LgCai4nbB9utRnA0Ri6XQ==
X-Received: by 2002:a17:902:ee06:b029:e4:ba18:3726 with SMTP id z6-20020a170902ee06b02900e4ba183726mr3891949plb.17.1614862376439;
        Thu, 04 Mar 2021 04:52:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o13sm27380376pgv.40.2021.03.04.04.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 04:52:56 -0800 (PST)
Message-ID: <6040d828.1c69fb81.ad55c.e8fa@mx.google.com>
Date:   Thu, 04 Mar 2021 04:52:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-247-g247050dfd4aa
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 153 runs,
 4 regressions (v4.19.177-247-g247050dfd4aa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 153 runs, 4 regressions (v4.19.177-247-g2470=
50dfd4aa)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.177-247-g247050dfd4aa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.177-247-g247050dfd4aa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      247050dfd4aa4d3f4b8380ef00dde4055c9dd00b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040a49b3e2b8b2859addcdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-247-g247050dfd4aa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-247-g247050dfd4aa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040a49b3e2b8b2859add=
cdd
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040a4c801a29dfbf3addcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-247-g247050dfd4aa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-247-g247050dfd4aa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040a4c801a29dfbf3add=
cd3
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040a835d8aa97bb1eaddcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-247-g247050dfd4aa/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-247-g247050dfd4aa/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040a835d8aa97bb1eadd=
cd9
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040a43db4eaf362bbaddce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-247-g247050dfd4aa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-247-g247050dfd4aa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040a43db4eaf362bbadd=
ce9
        failing since 110 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
