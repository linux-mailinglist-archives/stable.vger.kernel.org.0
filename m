Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A28232C9B5
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242534AbhCDBLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 20:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhCDA5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 19:57:39 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C463AC061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 16:56:52 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d8so4669569plg.10
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 16:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a79yH92F8dnyrK2/cparGW6fsTP69VMb6qnbGooMH8g=;
        b=mHDv8ecGFjoJthU8kwC8uiyUXYtTlm3S0L/WZI/GlsFSHbf0Fx3ymrH1jmuadtxtKd
         jLi77gdByAG3bA+kCgOjq0M2lcPTtFo6WApCzsYM4Wu2rnX3YZcShpvOwaRNFxthviIA
         MOrFloL2tQ2971kfBMS/AWyYh441TxA+PoPj1EMThcIvZzrXemAGPppvdpW7USitpA+Z
         /tCC4yGIKiQdeYtmHQ6MLWZT7ar0fQX7WLnpJaTobzLPoKv4AuKxSl5vafugdXXk0JKV
         i3vXzEMRppCRTdT3PLXHS/+hbCN0jk1rxeY6F062m1900ddt5VOZD+S+7SmO8NiZje+c
         yQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a79yH92F8dnyrK2/cparGW6fsTP69VMb6qnbGooMH8g=;
        b=bJ4B7O3t/ALUn23Uz63KJOYIZ2oQ0jXWXyGYWOgUFaU3vqlW5/u8cuEreXEXYlNMj0
         wRC2ioL2O53+PY9hVEqIvCW71mQopnBoE/PCZ2GixXptF9L29/cJ0kNgoNxYdwCXUZbu
         H7w5B2ySot/D14M9ppqCaiXLV+xqe+qw32nbPlfKhth2KPPWPzl8IPJfvnsaPWu7/Gel
         UvNw4pE0XeoTrpidopSIMLc3kk5mTWbyMnSi6QG8kb98nmJEMQHOhyPzRE4e+uBaJIjr
         44zndX8kHChmR14t0fcFCwvJYXo175yDJSkYBl/WueQ3jc9ZNQX+ARs1GbrXopYY6Byg
         /f0w==
X-Gm-Message-State: AOAM531BdzV9ae08GRY21X3CCZl/CR7gS38AF1KoFnUsxfO/v0VX6csO
        KwJgJlFoJczMYrAWpfAeKDaPeWkA5zI60/Ea
X-Google-Smtp-Source: ABdhPJzxyfFoDLi0HsICe/I6B3y/4Z5ozUkPdfX8qMwft1Q+WnT823KxVtYAgKgJQzW8bB7Xhme66g==
X-Received: by 2002:a17:90a:3f10:: with SMTP id l16mr1683769pjc.131.1614819412170;
        Wed, 03 Mar 2021 16:56:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b22sm3845570pff.173.2021.03.03.16.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:56:51 -0800 (PST)
Message-ID: <60403053.1c69fb81.8dc53.8b2d@mx.google.com>
Date:   Wed, 03 Mar 2021 16:56:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.223
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 84 runs, 3 regressions (v4.14.223)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 84 runs, 3 regressions (v4.14.223)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.223/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.223
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      397a88b2cc869c823bf40bc403d36a62afec1edd =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ffd2a7c1c018550addcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.223/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.223/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ffd2a7c1c018550add=
cd4
        failing since 105 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ffa81c7670e8f49addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.223/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.223/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ffa81c7670e8f49add=
cd2
        failing since 105 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/603ffa89cd6997f4ecaddcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.223/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.223/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ffa89cd6997f4ecadd=
cd4
        failing since 105 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
