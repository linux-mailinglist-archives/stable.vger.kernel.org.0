Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8DA4A30FB
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 18:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352933AbiA2RMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 12:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352845AbiA2RMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 12:12:42 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E3DC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 09:12:42 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i30so9020989pfk.8
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 09:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2bk+AEwENoMMa5s3oRCNRJ9ZAtljYLUCG8SbHULKAqc=;
        b=kyLQ2wq6j2xg4haVahwt1sMFhkUL0EI7eYj5/cGFH2Dr16Xqk5+CtqbE9MQ2z6YQEJ
         iMshkVcXLRPdhOX+OchMN8p7ivRSDLfL9CTI51TbqQ46JeFbFxCkzQdkNRSeghKvsoCO
         IhmKo9ZjBGknY33kyHiVWowf82Enr4+lp0brK1BtiUGt533d2EJ5WGR7uQCwb6fQ5+ZL
         LRJSCWj4oTicDo7iRPQoB1NuHQ6wFkCL2StO/iBlUfqS3JneR7hVyG2RpfEu/ZS7qk2D
         OZ2edgFChhC0Io9hluzpQSz63GuXG1AMLBgx/1l1jiisqHMDzZ+MejZDfPp40A2pL2Hv
         B52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2bk+AEwENoMMa5s3oRCNRJ9ZAtljYLUCG8SbHULKAqc=;
        b=O5IJZVEdIrmLO1Nehv3qAGtbr2T2jcrW8KgrSfDjjzJmLpQ4rWlLZOiKsAFCC0s/Hk
         SPxp/eesbUQ4qW2X8ZCnqn3+RB0oHDeURsO66856p181igCXoJaTlBIl6e4fUyNI8C3B
         vgS25pfFmJxV42tf81MHH7O5VEew1kzx4QxffoPlee5wibj/HGOz6iUk4uaph5ygTPkC
         +E8C/ybRGyAJ0mq86XNjOnZap+ipCIhJZGZUl7gA7CLIneOoVdt4G8edLGpap6AplMRz
         B65YgduwhO6BUMhagHoZg5ZF0jmSImZzDyVA4Sb21/fNW7VoFubRqWQbG6qnxBmD7bq5
         dqwA==
X-Gm-Message-State: AOAM531sDVpnbav7VS01wNqbcTodJL4kwrmyk1UfRAMt1ETuBmJOoPnL
        zpNr+BMfToWbFdUcfcPk0QVIOABZQOTLIxv+
X-Google-Smtp-Source: ABdhPJwZPxuoVV7VB/qKpvyz1pZ0ebJcjF3DIz7hY/+bYuT6vamfZ4gJxs/9oKqcqSPbMpGJRxd8Ag==
X-Received: by 2002:a63:5741:: with SMTP id h1mr10634618pgm.267.1643476361435;
        Sat, 29 Jan 2022 09:12:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a14sm14207637pfv.212.2022.01.29.09.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 09:12:41 -0800 (PST)
Message-ID: <61f57589.1c69fb81.a8a1c.571e@mx.google.com>
Date:   Sat, 29 Jan 2022 09:12:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.175
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 140 runs, 4 regressions (v5.4.175)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 140 runs, 4 regressions (v5.4.175)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.175/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.175
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7cdf2951f80d189e9a0a5b6836664ccc8bfb2e7e =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f54370623bfcc646abbd48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.175/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.175/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f54370623bfcc646abb=
d49
        failing since 43 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f5438a31fc23aa4dabbd49

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.175/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.175/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f5438a31fc23aa4dabb=
d4a
        failing since 43 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f54372dff05f3709abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.175/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.175/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f54372dff05f3709abb=
d12
        failing since 43 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f5438b31fc23aa4dabbd4c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.175/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.175/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f5438b31fc23aa4dabb=
d4d
        failing since 43 days (last pass: v5.4.166, first fail: v5.4.167) =

 =20
