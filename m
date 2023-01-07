Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E5D66112F
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 19:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbjAGS5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 13:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjAGS5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 13:57:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA571BCAB
        for <stable@vger.kernel.org>; Sat,  7 Jan 2023 10:57:45 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n12so4739065pjp.1
        for <stable@vger.kernel.org>; Sat, 07 Jan 2023 10:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=B3R0uTbdENAQF5ITYOqS+5CyQiYSWN4nsciIP+HcxBQ=;
        b=oVTBiDHWr4DrNxhAZA9Y/ORftYu2U8rH/1crui9yQKYoBhvFARl3W3Hx2bmactRhi7
         MOmI2vjP2HibLCmsVRMl2CO1fEVwoFuPfQfCfauBzUcu04ug7v5OVjwSPaZd+OZBvmIB
         D9IqSscgsLO0ywfI8tAhP2pxcQmajTWNjfZAPimREqoWUoFAq4cm1JNGCVvHN9GC1sbc
         bccAvarrOAGtewgbFyj7WZm5U7rPFGtaeI18bCQCeMhcjgN1y4zBiw+HglfIY2hSN2qw
         ++NgzO/fcTJ1wyxSb4JVuUtEFFC2stLbLkICHSv9mDWssbiXw5XsR+EaowFe1Bh+WVDj
         BfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B3R0uTbdENAQF5ITYOqS+5CyQiYSWN4nsciIP+HcxBQ=;
        b=ueq2+H8ZNDwSD0F7km6uCKEpq49AsplFKTvip+PvzyEGL9pHixKzW8BwL/uPsIPerb
         HhYlNHEQQtlkugdXCSSJUmz6WLM4vHzp37sH25cyEaDFBqLTry7zhfUhwE+hZYoPtLAd
         rqyKtiOrUWfru34wBYG8Br+8DAAi+wCSJz1PAjouXVFDILA5wdXxt/NyXrGgK+YEsXxJ
         jaiMuisAfAvYuF9/2PsmCXO2XQ+2uJA0ng6dxh68Wykh7rZ7WiPe4oz2ju0WHQYKNRNJ
         HatrF1gI993tXqWEJXAvPkrm5Civ/q/HCmQgvQdt4QdjBBV01JYvTiO3BYAwM5kyU/vl
         iJWw==
X-Gm-Message-State: AFqh2kr4S6ZQcIvGiaTPiDugVRZ7Q/cC96EGNeZ2YhivJ65+BIgSJIi9
        EgH+ewBtyX8RjMhKSuvKq0MFc55RK/qNCCmPRjfFFQ==
X-Google-Smtp-Source: AMrXdXstFKG6NWLWl+pVVg5A1JIHvAEzrjRZ1ffi3bA1dIjJKF9f8ivP+Z0zQvW4mdSxmWeBJj+xMw==
X-Received: by 2002:a17:903:3311:b0:189:6522:7cc0 with SMTP id jk17-20020a170903331100b0018965227cc0mr62071365plb.50.1673117864647;
        Sat, 07 Jan 2023 10:57:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902e5ce00b0018958a913a2sm3050428plf.223.2023.01.07.10.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 10:57:44 -0800 (PST)
Message-ID: <63b9c0a8.170a0220.37a2b.445d@mx.google.com>
Date:   Sat, 07 Jan 2023 10:57:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.337
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 85 runs, 16 regressions (v4.9.337)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 85 runs, 16 regressions (v4.9.337)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.337/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.337
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87a72e81764d2fc5411706c551462d61cdb97660 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b98744baacbd7d1b4eee2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b98744baacbd7d1b4ee=
e2e
        failing since 158 days (last pass: v4.9.302, first fail: v4.9.324-4=
3-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b987e3a4604202194eee1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b987e3a4604202194ee=
e1b
        failing since 142 days (last pass: v4.9.302-27-ge4a64678c410, first=
 fail: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b98737dcfddbe9a24eee24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b98737dcfddbe9a24ee=
e25
        failing since 158 days (last pass: v4.9.302, first fail: v4.9.324-4=
3-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b987d7dfdced96f64eee37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b987d7dfdced96f64ee=
e38
        failing since 142 days (last pass: v4.9.302-27-ge4a64678c410, first=
 fail: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b98745f3d93ad7964eee28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b98745f3d93ad7964ee=
e29
        failing since 157 days (last pass: v4.9.302, first fail: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b987e4b8d9ec503d4eee1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b987e4b8d9ec503d4ee=
e1d
        failing since 158 days (last pass: v4.9.302-27-ge4a64678c410, first=
 fail: v4.9.324-43-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b98730f3d93ad7964eee1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b98730f3d93ad7964ee=
e1d
        failing since 157 days (last pass: v4.9.302, first fail: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b987d89c52699ce14eee52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b987d89c52699ce14ee=
e53
        failing since 158 days (last pass: v4.9.302-27-ge4a64678c410, first=
 fail: v4.9.324-43-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b98757f3d93ad7964eee2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b98757f3d93ad7964ee=
e2f
        failing since 145 days (last pass: v4.9.302, first fail: v4.9.325-5=
1-g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b988abae6ae386564eee2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b988abae6ae386564ee=
e2e
        failing since 126 days (last pass: v4.9.302-27-ge4a64678c410, first=
 fail: v4.9.326-32-g24fc65df6e8a8) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b98743f3d93ad7964eee23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b98743f3d93ad7964ee=
e24
        failing since 145 days (last pass: v4.9.302, first fail: v4.9.325-5=
1-g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b987d725300ca3ea4eee2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b987d725300ca3ea4ee=
e2b
        failing since 126 days (last pass: v4.9.302-27-ge4a64678c410, first=
 fail: v4.9.326-32-g24fc65df6e8a8) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b98743ae420d2bbf4eee37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b98743ae420d2bbf4ee=
e38
        failing since 145 days (last pass: v4.9.302, first fail: v4.9.325-5=
1-g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b988acac820aea6d4eee37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b988acac820aea6d4ee=
e38
        failing since 158 days (last pass: v4.9.302-27-ge4a64678c410, first=
 fail: v4.9.324-43-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b98736ae420d2bbf4eee32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b98736ae420d2bbf4ee=
e33
        failing since 145 days (last pass: v4.9.302, first fail: v4.9.325-5=
1-g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b987d925300ca3ea4eee2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.337=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b987d925300ca3ea4ee=
e30
        failing since 158 days (last pass: v4.9.302-27-ge4a64678c410, first=
 fail: v4.9.324-43-g54391eec23dc) =

 =20
