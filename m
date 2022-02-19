Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAED94BC482
	for <lists+stable@lfdr.de>; Sat, 19 Feb 2022 02:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbiBSBWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 20:22:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbiBSBWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 20:22:02 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3B536E2F
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 17:21:44 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i21so3682662pfd.13
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 17:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kN+/m4VAeCatj0kZlrlmNCyMDLGJpqCTyRJ1aCvyiQE=;
        b=3J+k7KpjW7o5Bfuo2zLyBvjtxYO3UnN17VeWdTp8LpM4VzBy1tdPg6YZoLwoNAv51o
         Jri+SiYs/6e0IKjzYHwpTAs1cwkCld9i6J/rkEjveUcE+LKvpctJaZBo6fz0VdEUJK+u
         NLvnz4qc6RFlbylx/jyzRw696xSTs1HyWz9sVVAapVLkvMX+HdNdv+wYHai2ismCBajp
         pmeRCtwhPsMhGxlTPjiGYwMh1Qz1kLXWd7KoTWPEkCDIHg06iAW9TNuiotvx3xkXqkZa
         xoFgHYMU4dsflM/+1jKKDs1SL12KRbgfqKDOTkom1vsqsifGUohrochxAVqW7vHzATSO
         gO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kN+/m4VAeCatj0kZlrlmNCyMDLGJpqCTyRJ1aCvyiQE=;
        b=uwOmrnMBASmemPxUydD/hHHwxXGgAEVvo+m2D/uTYU2tk7jUYW4lHRlbeG6GTkN9fq
         ATQVA42WdhpU180EHRtGVWgoI/78kVHI3s5+4ZNhVqE8wHgtzA9jQeknQAYJUBVulnhx
         UROhCDPmW5H3RhF93Nv0+H4/FFdnzYGC7ILiXGt7IBMEdMdkHE4lboJvawoaHDq9cNvR
         5jcOB8RrD5j+SIr0pvxA8KcujpdUQq16BCtCRF79ILuJAmLP2V44vpx6F95a6ACt+y+e
         GCAZ4MxkEWfHHFRrnzxFd2JBhHiyiSqPUzlD4j5TPIMZfZXr/WNAnRl3J+HRnXrrx4ET
         HLqg==
X-Gm-Message-State: AOAM530LEj7GkylSqv3cpsii5sYT6D+fVDnnzpod369LahgGlBXyGlCN
        LoYTPSpHQ9RzUaVV37x4rHGm3pQ9wUxS2DuJ
X-Google-Smtp-Source: ABdhPJzlEmMKKiQ08GYv/6+nCqUp/FDWUMsot5HAKfMhmZvi6oh8e0CeRVtqN+fUldVAyBAsuDAraQ==
X-Received: by 2002:a63:ec0f:0:b0:373:a3e9:10a7 with SMTP id j15-20020a63ec0f000000b00373a3e910a7mr8184659pgh.149.1645233703229;
        Fri, 18 Feb 2022 17:21:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a16sm513680pjh.2.2022.02.18.17.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 17:21:42 -0800 (PST)
Message-ID: <62104626.1c69fb81.2cb77.24df@mx.google.com>
Date:   Fri, 18 Feb 2022 17:21:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.10-133-geacaba49447b
Subject: stable-rc/queue/5.16 baseline: 95 runs,
 8 regressions (v5.16.10-133-geacaba49447b)
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

stable-rc/queue/5.16 baseline: 95 runs, 8 regressions (v5.16.10-133-geacaba=
49447b)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.10-133-geacaba49447b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.10-133-geacaba49447b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eacaba49447bdac11ac0789cc82e673f4961ffd9 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100f14ac7649137cc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100f14ac7649137cc62=
969
        failing since 10 days (last pass: v5.16.7-106-g04b8b791e123, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100f2e4f156968f1c6299b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100f2e4f156968f1c62=
99c
        failing since 10 days (last pass: v5.16.7-106-g04b8b791e123, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100f274f156968f1c62974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100f274f156968f1c62=
975
        failing since 10 days (last pass: v5.16.7-106-g04b8b791e123, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100f314f156968f1c629ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100f314f156968f1c62=
9ad
        failing since 10 days (last pass: v5.16.7-106-g04b8b791e123, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100f15ac7649137cc6296d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100f15ac7649137cc62=
96e
        failing since 10 days (last pass: v5.16.7-106-g04b8b791e123, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100f304f156968f1c629a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100f304f156968f1c62=
9aa
        failing since 10 days (last pass: v5.16.7-106-g04b8b791e123, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100f133659fbcc8fc62996

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100f133659fbcc8fc62=
997
        failing since 10 days (last pass: v5.16.7-106-g04b8b791e123, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100f2c4f156968f1c62998

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
133-geacaba49447b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100f2c4f156968f1c62=
999
        failing since 10 days (last pass: v5.16.7-106-g04b8b791e123, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =20
