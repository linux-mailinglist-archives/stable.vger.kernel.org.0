Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC5A33CC0D
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 04:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhCPDWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 23:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhCPDWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 23:22:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8ECC06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 20:22:40 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso614880pjb.4
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 20:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yD4THSP2NorunuUStksuDoxu2W4dhMsUC6CDf/q63Aw=;
        b=OLEjNdS5Ocyz8G8683XW2VlSV7wQhLXmpl7Rfws58oWI+8GZSxF0vIBJrsYs1n0g19
         TNuRSEquTaSByVMAbsZjvxK6mvYPBN/Me8bVO/uIPOKmiXapMTtejpYcnG9Bk041eeGH
         SNh/p7MUILSVqUBO79cFfk5t7KedanvBqHreWcU/6iqkKTqj/aguPTYkDlypWppcL1Mh
         pRwjFuaZ5FHoppXFEVusDhnFv4RIVBSVIScIZLnlxoGg3OT4O94ca8lK/mANE8d8GDAI
         0e4NoKVcSO32VkekyPUzQvaHS+QVLpt9GyfpUVvj9PyiI4ZgU4TF/azVL5qR6n3qvwBh
         UZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yD4THSP2NorunuUStksuDoxu2W4dhMsUC6CDf/q63Aw=;
        b=uKTYy9v+agpcjjFRchMMXmShxS7K5GocT6Vc2nwEZr1PURtKLHL1QNw2mcJtDmHqSl
         yJewn3ilkFyXZ5QAzGdP+/Qyzg7jh8SV6Zz2PJ32WhMJPvWD+6UFXoDx4KUL/zIuIdaE
         7rvevSUkpQk7MpyNzltu3aWJwIZ7qxqC+zHNBr5gbB0/0gVKv2Z7H2G1vItH/4t8yc3g
         FDF38S7eGU1QbKgFs4THJPTlNP4JMon2HvrtcE1/2WVpC77x/GLqf2oTeO/DzPqQywMb
         Rw/smVdiWp4P4yZUVRNHB8TEHq1tD6GbKK6UKqqjciGskJV/nS5zQ+lVC/wKkaPnSdPS
         ymXQ==
X-Gm-Message-State: AOAM531zyOT/cikeBesow+CLE1puYqdYsRsq5zQjdAP5jH4W6OW9BCzo
        HzsQx2T3sVEjGCS/rs9FzfGVTv6iJMLrKQ==
X-Google-Smtp-Source: ABdhPJwi4XGi8EIc6SWtokFpeUPu9DxbvXODsXtd3fDbz4GSd7I5iMEv/Ncbd1T2NxwrV25Qcm1VTQ==
X-Received: by 2002:a17:902:9886:b029:e6:2bc6:b74 with SMTP id s6-20020a1709029886b02900e62bc60b74mr7858131plp.13.1615864959952;
        Mon, 15 Mar 2021 20:22:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e24sm14835292pgl.81.2021.03.15.20.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:22:39 -0700 (PDT)
Message-ID: <6050247f.1c69fb81.cb071.5056@mx.google.com>
Date:   Mon, 15 Mar 2021 20:22:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105-169-g26ba2df2641d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 113 runs,
 4 regressions (v5.4.105-169-g26ba2df2641d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 113 runs, 4 regressions (v5.4.105-169-g26ba=
2df2641d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.105-169-g26ba2df2641d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.105-169-g26ba2df2641d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      26ba2df2641dff3b9583fc4d1fbdc668bd346f00 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604fef9a180c7df013addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-169-g26ba2df2641d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-169-g26ba2df2641d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604fef9a180c7df013add=
cb2
        failing since 121 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604fef7f5769d6f042addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-169-g26ba2df2641d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-169-g26ba2df2641d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604fef7f5769d6f042add=
ccb
        failing since 121 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604fefd1c17f4920e4adddca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-169-g26ba2df2641d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-169-g26ba2df2641d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604fefd1c17f4920e4add=
dcb
        failing since 121 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605017726d2763bedeaddcd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-169-g26ba2df2641d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-169-g26ba2df2641d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605017726d2763bedeadd=
cd8
        failing since 121 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
