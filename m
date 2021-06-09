Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21B03A09C6
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhFICGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:06:12 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:34579 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhFICGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:06:11 -0400
Received: by mail-pg1-f171.google.com with SMTP id l1so18128411pgm.1
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BV5iObAeRI5BFyRK+9FL5gOhbIsq26ITEqCNecwXKKs=;
        b=MemPKMSbIMTN1JsN1E38uiJFF5u5pIpWR9t1g4CKy00P1qPk5/qAnuC+7/9jovRJQG
         08s7HnNe9yHSZcmrq0w0xlOPcZEXswTRsYUnVLbKNMqmf1FYycts9Rxt4hbpmKnHW1EO
         wxyFxG6xH01M8OX1bwT+qi8F5Mpna1j6ZN8bJm6oDe2DaKW339cEVim6DYs8GBqMdDxG
         t/FGsNZIOQbLlkOXTB74u36jCk870JmsKnWNSEyF+szd4f5d1APyJcKp/G4z0y+3aLmr
         zcCS0yWFwb9sv1WXNnBGau8ZN/oLz0R6/o0fNam5HZ5tcuMtOI2AxTt/15ag+RkadUnx
         f10w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BV5iObAeRI5BFyRK+9FL5gOhbIsq26ITEqCNecwXKKs=;
        b=a5yC7lOnP3/rJsVvvkz8RWzV7wtSJ61Mlp+N70TWihqGfBFZ6iUnbetqhMdloQ6jJs
         f0H0E4Gmg9bJvXMHjVAq77n3+G8nms/7/r+4bO2pYBJT8pUIG+hBPD3iWrBbJIAx7OmA
         8esS6fj+oVvvNu0yFeFNmoXlfsp/gt4Sn2uGp2VTY7O7uz4T+osyUhSuufkHDfhFFcbz
         dbg4TencK9774oJ/5ImYUT0w+wVYLHIuw/hggj6HNr3Z5oxOsiPmu3ou1hcc51QH1ip3
         5sXgFHZidsjVq613dPVKUMCmN+MVF2GYUW3GiWtht8PIPafa8EWnfwTl69Vri2EA432l
         YGEw==
X-Gm-Message-State: AOAM533Tmhv2D5CfSfZfi/1TCQc1Mq5cbClokRItkBb+jZqopbFdznGT
        lhrf6zty1YgFs5LHsr32oRc5pcyeSn7qd2E7
X-Google-Smtp-Source: ABdhPJyAF2YgFScHiBOyqCyxjfQxXLh2snyBVdTqa616q7hnI2wWI+VSp2XEMQ2XIWwnmzQaq46LTw==
X-Received: by 2002:a63:1260:: with SMTP id 32mr1307822pgs.232.1623204183169;
        Tue, 08 Jun 2021 19:03:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b23sm15712905pjo.26.2021.06.08.19.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 19:03:02 -0700 (PDT)
Message-ID: <60c02156.1c69fb81.91da0.20eb@mx.google.com>
Date:   Tue, 08 Jun 2021 19:03:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.271-29-gf7249899b410
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 4 regressions (v4.9.271-29-gf7249899b410)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 114 runs, 4 regressions (v4.9.271-29-gf724989=
9b410)

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
el/v4.9.271-29-gf7249899b410/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.271-29-gf7249899b410
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7249899b410e4f29231399f1b3a65706208bf37 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfebff104aca2a6e0c0e57

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gf7249899b410/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gf7249899b410/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfebff104aca2a6e0c0=
e58
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfec11af949ac2170c0e06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gf7249899b410/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gf7249899b410/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfec11af949ac2170c0=
e07
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfebff104aca2a6e0c0e5a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gf7249899b410/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gf7249899b410/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfebff104aca2a6e0c0=
e5b
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c006595d0598abbd0c0e51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gf7249899b410/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gf7249899b410/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c006595d0598abbd0c0=
e52
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
