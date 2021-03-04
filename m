Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AEE32DB87
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 22:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhCDVDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 16:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbhCDVDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 16:03:43 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9B2C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 13:03:03 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id kx1so1570411pjb.3
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 13:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=04sgyWJTv7bmrtnX2AL8oujMBGXLHUnZYnHHLSuzJwg=;
        b=gI64lsOB7XemfGHP6iDiYsJTMsafO+H15WmZU1i9fsr238HN71z9qZRZr8fr8TWwGv
         pIzpSRAA/Xt03D9hNXBeP3GI4rqFsETxUdBl7Exan0BUtmZuu+kIBKfZKFFazb+u0eRn
         SfRrTTNsQlAvpTsoEJ4XshrCWrRcqOyEIgWS/xPVYOGdAyNDoYrjdMrVPk84cDuIMd7g
         Erz+BwGuZK0weTwfFHucGxn+7vlewgyFAUGoHCDb9Z8lv3knlETkrr/52se9Pe/gPV+c
         GrrD+AXjJQZI7laH8/0l7ZpacF8KuptIJXMbEBDravjRbmzYflVo4pUvYelX0uPkJibk
         ymAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=04sgyWJTv7bmrtnX2AL8oujMBGXLHUnZYnHHLSuzJwg=;
        b=qZSaL6AkFxDaM7T8IGUkH0jYv0k6UVlWIyLOHNs/eeHEpoYwEGUw+I2dAsKx97I7rV
         W7HVqo4BfvjNkz+6AF8yJnBezd2mGmObN1yWn3dhyAMl4oK+OJ5GzW0Wyoq8QrNhOEpb
         3PRYh8Yx8pNrkWA+P97SObONPQBO8jlhZY0OZ7Awz8aW7XxeJPCSon8oFFbqwYgI9I3B
         d95XIww3T4OUBt09Ue+B00rRNpsK528Q6mSlhsU2j9G9PWWn2hi3CNJK39Wh1XU80CS1
         8cQytYvhfueOnyI5gCLARSZyjQ/69aUd1Ac4PUZF1EqWjfoCrQ6+vZNejICStqpXswLd
         3iuA==
X-Gm-Message-State: AOAM531n7pYy8R/0rlM0k2iMZ51YTHIj5rimhwUyePn0scXI/7hBgTI/
        unSU42m/+nRlAyOFD3kNJUIkp3w1KQvLYyIq
X-Google-Smtp-Source: ABdhPJxSdcqbz2KCExCVkKIOBc2lO6yTkiPl2mQFa02H2Jz1mDioSTk68W1o9b4mF8jr2mBHMDtIMA==
X-Received: by 2002:a17:902:e886:b029:e4:2b8e:3c65 with SMTP id w6-20020a170902e886b02900e42b8e3c65mr5573058plg.1.1614891782348;
        Thu, 04 Mar 2021 13:03:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm261152pff.61.2021.03.04.13.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 13:03:02 -0800 (PST)
Message-ID: <60414b06.1c69fb81.70a40.1132@mx.google.com>
Date:   Thu, 04 Mar 2021 13:03:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-25-g37b9116c40a70
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 111 runs,
 4 regressions (v5.4.102-25-g37b9116c40a70)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 111 runs, 4 regressions (v5.4.102-25-g37b9116=
c40a70)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-25-g37b9116c40a70/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-25-g37b9116c40a70
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37b9116c40a703313499532834cd4bd3458605a6 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60413cabe907f1d4ecaddcb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
5-g37b9116c40a70/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
5-g37b9116c40a70/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60413cabe907f1d4ecadd=
cb4
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60411957775a51d2bfaddcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
5-g37b9116c40a70/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
5-g37b9116c40a70/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60411957775a51d2bfadd=
cc2
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604115808d69b0036aaddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
5-g37b9116c40a70/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
5-g37b9116c40a70/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604115808d69b0036aadd=
ccd
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60412b1f3fb805f3c7addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
5-g37b9116c40a70/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-2=
5-g37b9116c40a70/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60412b1f3fb805f3c7add=
cbb
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
