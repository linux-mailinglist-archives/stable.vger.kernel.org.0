Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B84414E21
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhIVQcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 12:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhIVQcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 12:32:45 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91354C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 09:31:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w19so3138480pfn.12
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 09:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bEqiHNdU4PgSG7eqh+AxIcncD5ATxQtSTrLhbwBP7g8=;
        b=FRNg3TIMPkvjmhwN0G6rbXzHA5zv+4HUQvXMghwg4S9n33cC7gDEfeCv0EKKx8XsVl
         vc/NUab3fEouzbBPVuFzbAG8wXey0381nqm5qyy17EoV7CD3bDE0DxUMa31ffrk0nRi3
         6vVcpjbvCOVrejEJZTqsSovqT41mEXtF1mM+qmxFiR/+9zWiJZMci1Z9rWZv+naXXS4C
         HE/ijoFqDsaiJNB6diCycC83DXO+uvAd7MlSGj+Txkjqxy1FqUaofdcMYpMEsC32MYX4
         DFz+9h6SAc43kmhFSVSlsHv1UgSmL6i7ssYfW5CRqTlEft33csCleHfMe+BiK515rZVC
         LZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bEqiHNdU4PgSG7eqh+AxIcncD5ATxQtSTrLhbwBP7g8=;
        b=CXOXJSBzYElmJuvbtqJcVFc+ab+z7w01qmsyLAs+oEbO9F8wV5wRz6zVn3DfwMJS6V
         8cPy4apnx/nLvA0mDnmrPQQ0L58JRqcajIcGtHvn8j2k299XLwRBqt5vuFZoqYGi5SH8
         licJOVwQqP8tq1/YTqkY09ZEWf3jhTpJpqvU51iyIwisWHUvRBH+BEfoOU+RltMzONXP
         yqmJG9PwkQzOGMwJb4kP/EFc/6G8rRSDzsLkK59gtRuHFlQ/QOIqPtB7SdzwC19ouExs
         UkDikF9Y/njvWzzwJHzIc/WyaIR8iYb97yxey0nRpw6L/I2sOK+0lX5MJgI2Q48HI++0
         e8Ag==
X-Gm-Message-State: AOAM531Yrdrfp/Oe3ctUDS2lAB6S81nMWAf3tkCZ+b0uvfrch3sHT+On
        sNBHUOR4BZs6OFekBVuStenCyAwOFI37VM0J
X-Google-Smtp-Source: ABdhPJw7WHgO6djVCcpD/No3WFhCH4vh6tW1IJgkxwFRPhd8GA9rtUyF2Iu1sccLoJDYfH9nYbuCOw==
X-Received: by 2002:a63:e04a:: with SMTP id n10mr461067pgj.381.1632328274888;
        Wed, 22 Sep 2021 09:31:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r29sm2916614pfq.74.2021.09.22.09.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 09:31:14 -0700 (PDT)
Message-ID: <614b5a52.1c69fb81.89844.7953@mx.google.com>
Date:   Wed, 22 Sep 2021 09:31:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-175-gf75fa6de4447
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 93 runs,
 3 regressions (v4.9.282-175-gf75fa6de4447)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 93 runs, 3 regressions (v4.9.282-175-gf75fa6d=
e4447)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-175-gf75fa6de4447/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-175-gf75fa6de4447
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f75fa6de44474e394f01f7978f6544958e2832d8 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b1dab84f52ba5d999a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
75-gf75fa6de4447/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
75-gf75fa6de4447/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b1dab84f52ba5d999a=
2ff
        failing since 312 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b259b04f40057e699a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
75-gf75fa6de4447/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
75-gf75fa6de4447/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b259b04f40057e699a=
2f1
        failing since 312 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b1e28c69f3766fd99a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
75-gf75fa6de4447/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
75-gf75fa6de4447/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b1e28c69f3766fd99a=
310
        failing since 312 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
