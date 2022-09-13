Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A925B7B64
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 21:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiIMTgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 15:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiIMTfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 15:35:52 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB306D9CD
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 12:34:12 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s18so6905051plr.4
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 12:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=8Ea6DKfrkH0fcp3Kt5FhuL1+d63qbP85N8Dl8w0e4Cs=;
        b=sSDBaZkw6wc3zIUj0W0imoh8XteFHyHwvpO40VeGHJwPG0pY0MY2n2kUSPIm/3R85g
         vfQJpUf8g4uj34anorsnVOCogvDug9X6VjIM3yQ1jBwRqcyFnRdBixpqabLxck9rYgVe
         6aknq2Ot2yNMgKhDPj6yUo34ULj4rt828h6Fu0M2HFlz9qJDo0Ci9OEZlBmP+DtAOI+/
         oFH3y8bTbv1E2Dz1EI+5t0vJfGh/65nyi6NtARtjK0pPQjWkVruq0H6EXVYMPo7aU0Rf
         fZPeKpdRLpbKHpgo4aQgRvkcvr2loduPyjbuR153F7wUcLslBUHLU5c/KDb4/SdruWDI
         Yrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=8Ea6DKfrkH0fcp3Kt5FhuL1+d63qbP85N8Dl8w0e4Cs=;
        b=lfX8tp8jqdnSSyqB5IRezgCK7HSFgLDA3g/npOklAtFuJe4/9/d0COx39GUFpm2K2o
         iAwcJoHK3sHgS931VY4UHyIITFbbYOIbL4c1qf1Hx64LL0Xm2HOCrm0eN3aq3fGks1SR
         TNwf5zAkMrW8wUx/eDyLwDCNUzRuHHtD8ETGjuiDC3P44T1Qk+mWXkDpnYEyyBZYRGVC
         FYqc2kHjWcO1UNzzm3L2Sj/G+SCBUjf8sQs6V3r5oQBHHnlmN677G9s7Wmq6YKBWVcD1
         jGxWEyfU4Xt7MdAssPUqqEvG8CWHNG2zoGn2vC4M/T1jDGVbJCUGxmN+8n1MI/Ko6zst
         yNNQ==
X-Gm-Message-State: ACrzQf3gYWcyV1McK4BXa5NlY8hI6zWkDDicjURGpEsFi9ZDvMYy7XAp
        rBWQbVcET4EweiZ0lbcIwHPmoX45oyxtsw9XoDs=
X-Google-Smtp-Source: AMsMyM4FNifWCKrac47E3X8wsLLBz1/EZfg2HuxaoAxmwhnzpTRXW+pRWKEbVCweC5F0xh3XYcnjxw==
X-Received: by 2002:a17:90a:e293:b0:202:6eab:acac with SMTP id d19-20020a17090ae29300b002026eabacacmr772691pjz.203.1663097651942;
        Tue, 13 Sep 2022 12:34:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x127-20020a626385000000b00537a6b81bb7sm8478122pfb.148.2022.09.13.12.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 12:34:11 -0700 (PDT)
Message-ID: <6320db33.620a0220.e9974.e907@mx.google.com>
Date:   Tue, 13 Sep 2022 12:34:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.142-80-gc8d43c9a12427
Subject: stable-rc/linux-5.10.y baseline: 146 runs,
 4 regressions (v5.10.142-80-gc8d43c9a12427)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 146 runs, 4 regressions (v5.10.142-80-gc8d=
43c9a12427)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.142-80-gc8d43c9a12427/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.142-80-gc8d43c9a12427
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8d43c9a1242725c78f2bf5b0274413727673ac2 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6320af23d43f46c4c5355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42-80-gc8d43c9a12427/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42-80-gc8d43c9a12427/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320af23d43f46c4c5355=
67a
        failing since 127 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6320af24d43f46c4c535567c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42-80-gc8d43c9a12427/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42-80-gc8d43c9a12427/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320af24d43f46c4c5355=
67d
        failing since 127 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6320ae0cb3ae3b420f355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42-80-gc8d43c9a12427/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42-80-gc8d43c9a12427/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320ae0cb3ae3b420f355=
655
        failing since 127 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6320af4b8afdbb41e0355672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42-80-gc8d43c9a12427/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
42-80-gc8d43c9a12427/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320af4b8afdbb41e0355=
673
        failing since 127 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =20
