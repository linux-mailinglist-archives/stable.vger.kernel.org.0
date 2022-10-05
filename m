Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3925F5968
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJERzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 13:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJERzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 13:55:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD79D31EEE
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 10:55:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e129so15845654pgc.9
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 10:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=If5DwM6h+tt/hyvmRV9z3GuIBi9xCZRbhrTRADgsZGc=;
        b=iD1OCvGax3N7WJgRHV3C3boGYweS8tnrioWwMWtY+rIwIxGBF0EqQsOoDU43dBNe9o
         W8Nzm+rjYKLWLgatRkrvZxGXUXcW4Mb4OOi6nO53lUp6kjOvJ+DvTdj2mGrFJNmI/Ce3
         2Sc2rkxZmINPtSp2cHI4zk+H6kboLNaGnDmKygdQ6KhymZIL7OTMSg6KdS8rF0Okz1ik
         9CIixro0Tw/8925xzYq1+dp8bq8xhTm1qcVrqPCf5XGs5DYk+RkDQUTNXO9AumbePlhO
         v/+9GydfLECrq9w5uzV+MepAurirkM9AuFSzBMary2gmuY41YOWUOUKKZR1LT+R8CKUS
         lujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=If5DwM6h+tt/hyvmRV9z3GuIBi9xCZRbhrTRADgsZGc=;
        b=FoTk070CmH/9YpEYEyPBUUky5cH0AvcpMUYIgaa9wONfQxPInxRoYN1n5SNSIL5QGA
         TeI/zy5AZA+G8TiJMtfH3WMzm4nFGknhWUTRfpEEskidRVPRErYXHWmFBMdS02hdddCX
         e2IsyNDWXFr2aL94N+vFWa7V4iwW/+QytWvdeNxwhFW3aBFzJW+kdW1DXr6Ny2Is4eJu
         IwyW6AQIJ24RczmXluLnm7oIvCcYLXtJ1PF9zRX+kVw84waFqV6h6h8z5MNafDb373dQ
         WWAtW0m+HnDEcQIcKr6+iq9yThXD2CsyiDGWfWYfG/83tqbJIxZgW0ZcwldoYh5rlyM0
         V6Dg==
X-Gm-Message-State: ACrzQf2EX/IyqKAlJyF+GdFdKYzcF/QcPcFXrnKLRNjCCDOkL8OTEIwW
        n963Lf+67YXY/nafYH0TDWvIN25CwsiPqCyulvI=
X-Google-Smtp-Source: AMsMyM7AjV2mYigC5x8bDNdSqRg8bgu318gBwBUThihzJFvbLAWNf4AkkzKHRREJojuZVHu/X3TzFg==
X-Received: by 2002:a63:e113:0:b0:439:e032:c879 with SMTP id z19-20020a63e113000000b00439e032c879mr808017pgh.287.1664992521132;
        Wed, 05 Oct 2022 10:55:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020a170903019000b00177c488fea5sm10908698plg.12.2022.10.05.10.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 10:55:20 -0700 (PDT)
Message-ID: <633dc508.170a0220.e923f.370c@mx.google.com>
Date:   Wed, 05 Oct 2022 10:55:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.215-31-gf28b7414ab715
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 119 runs,
 4 regressions (v5.4.215-31-gf28b7414ab715)
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

stable-rc/queue/5.4 baseline: 119 runs, 4 regressions (v5.4.215-31-gf28b741=
4ab715)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.215-31-gf28b7414ab715/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.215-31-gf28b7414ab715
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f28b7414ab715e6069e72a7bbe2f1354b2524beb =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633da2a1a346f6abb9cab603

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
1-gf28b7414ab715/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
1-gf28b7414ab715/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633da2a1a346f6abb9cab=
604
        failing since 71 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633da14efc814e6c10cab5f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
1-gf28b7414ab715/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
1-gf28b7414ab715/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633da14efc814e6c10cab=
5f5
        failing since 71 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633da14afc814e6c10cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
1-gf28b7414ab715/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
1-gf28b7414ab715/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633da14afc814e6c10cab=
5ed
        failing since 71 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633da14d9c3974c72dcab5ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
1-gf28b7414ab715/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
1-gf28b7414ab715/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633da14d9c3974c72dcab=
5f0
        failing since 71 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
