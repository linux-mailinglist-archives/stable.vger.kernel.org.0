Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1655BEEF6
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 23:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiITVHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 17:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiITVHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 17:07:01 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF6617077
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 14:07:00 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j12so3881492pfi.11
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 14:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=aJt8ZMXMAjERH9Z5XqRSP3nZK+lZokMukx8V0z2Z86k=;
        b=RhemOK8BQrKE9fUq0EVMwRRnCjESmR87ziSqnyxNzYwzAcym2uqiEMAmD1ly+jC+z8
         8gZ8kHLISQy6fdTTIc6XGdD2DaOXbd11wmH3cUjcXORg3QyQo5PvIQ6ZbSqqhP8gX7G3
         lIFPEngc57fXLr2H4PeVXsZ3mNR3fdA/7DsvnN2530BUDTSB5gS7h6u4mZxI+yo9eVBy
         5MvOnqVmqwiw6HWh5BwDfl78wpwxcmb+Uc7ieHxE22zyu70PBOSuVFSIDr1bJOvp3TXK
         vyvCBgFhos9aSQtly0rrXMLKPIoyHmngRXAeQIzJLmyQtYPmlTZKNnH/X8k1KvdLuBYV
         I9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=aJt8ZMXMAjERH9Z5XqRSP3nZK+lZokMukx8V0z2Z86k=;
        b=K9cr3+vXObFkCHJOMCa/rddtswsKDO6NhKNJzz6JYVNG1Yveo+L27PTa1CJG7AujQr
         y2hOW2fY71a6lcfDXLmIXL4JKa6UIB/Qe6rW4tTX46gz/fU8juE+aIuw2mmZFu4/Rg/7
         ewkROuc4WYls25XPo67sPsSIX+58v8a9FAtac0vNfUbTbaIU7QG0Z2rJCiJc77/Ovq2s
         kEmVp+Df/aAVIcw1MNPiTW2wldHjB7BUWd5DPW8/BlyAXiInUsi/XkgYoGdbsQRVk2jl
         ihTGIocSBopPCECYT3QIVw2rDkzalfWmieA499IBsm698OM+OET93bKZ5vy+3OamU12W
         cIiw==
X-Gm-Message-State: ACrzQf2znDjZ9d3jrpHWM+b184wBHDg9MD+WCRI5mPSO432inJ2leKNa
        vxa0F7j5hXObTkbb3T6Sen+widFT9cSn7AhSrmw=
X-Google-Smtp-Source: AMsMyM5DDDbVbT6mBQAWr4MlPxauDWELE+s3EofVmtziSdg9yHcnNgBW/pfgHf4vNzDvVnpTHo92yg==
X-Received: by 2002:a63:2646:0:b0:439:8a52:fd0e with SMTP id m67-20020a632646000000b004398a52fd0emr22031822pgm.193.1663708019732;
        Tue, 20 Sep 2022 14:06:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 38-20020a631466000000b00419b66846fcsm363387pgu.91.2022.09.20.14.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 14:06:59 -0700 (PDT)
Message-ID: <632a2b73.630a0220.d6d8c.13a0@mx.google.com>
Date:   Tue, 20 Sep 2022 14:06:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.10
Subject: stable-rc/linux-5.19.y baseline: 153 runs, 3 regressions (v5.19.10)
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

stable-rc/linux-5.19.y baseline: 153 runs, 3 regressions (v5.19.10)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
  | 1          =

qemu_arm-vexpress-a9 | arm   | lab-collabora | gcc-10   | vexpress_defconfi=
g | 1          =

r8a77950-salvator-x  | arm64 | lab-baylibre  | gcc-10   | defconfig        =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b80678c1e00a34f01bce79c27afb7555666f559f =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329f8bfa241dbdd3035566f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
0/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
0/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329f8bfa241dbdd30355=
670
        failing since 7 days (last pass: v5.19.8, first fail: v5.19.8-193-g=
3acd07a8c4dd8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
qemu_arm-vexpress-a9 | arm   | lab-collabora | gcc-10   | vexpress_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/632a02d46ad9ece12435567f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
0/arm/vexpress_defconfig/gcc-10/lab-collabora/baseline-qemu_arm-vexpress-a9=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
0/arm/vexpress_defconfig/gcc-10/lab-collabora/baseline-qemu_arm-vexpress-a9=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632a02d46ad9ece124355=
680
        new failure (last pass: v5.19.9-39-gf5066a94bca4) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
r8a77950-salvator-x  | arm64 | lab-baylibre  | gcc-10   | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6329fab4b12146770c355695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
0/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6329fab4b12146770c355=
696
        new failure (last pass: v5.19.9-39-gf5066a94bca4) =

 =20
