Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2A26C035A
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 18:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjCSRB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 13:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCSRB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 13:01:58 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BE8199D0
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 10:01:56 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id bc12so9576932plb.0
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 10:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679245315;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XMomCwysju7Qei5LAAE1c79bpOR++ZY89SxjufY6BDg=;
        b=fn2Ucn9PpgGv65+1jnNTaDtU8HGPx4cp76yC3fnQNMqDC/+R0vFNWpRuhWG/4eiZZH
         lvTCUPf65ODZ7hYcO+pCI+aYF6et/1KpH1a1KmpewDLS4jezOHMZDEdMW6bbS9PvMZNJ
         aOZbgcQH9UEX0+r3LLb2W3wpwxIh94odXICuXuRvONRM8JTdWVxIUr9vepzqtQ1dV2UA
         c7AO/auGzL3TS/UujphzyEHfehMZPxzQPkdrrMYdiYK2QANJ1kRmPIuIZ3EwJqcVSCqM
         IXNY/uSCio9aILTLHznpfw1E6c511bzf4vB9ogw1DgBnlIju/4x1lCOqQ+EGUReg62Jc
         RCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679245315;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XMomCwysju7Qei5LAAE1c79bpOR++ZY89SxjufY6BDg=;
        b=h0gP4G2efAOis/BsgCCz6quWJc4qp8OIWlR4Vp6E9JHLmNj9RqGteCStg+h4ILajWz
         aZwnQIPt3fg7+JF3ss8EjwkgGb3I6RTmITrx52daE+Up9A78nx0D+cGqChfon4idFNYf
         JKQWcQ0o5W9nEzG3BPP44rCr8xZ0F7sPR8B3pPtSH2m7Gd+SF3VQ7sKXX/lQEkIzStYX
         4ussj+aX+8gfxLp6jSPgd2NCbvQwU5H+mMpnSKGX0OHCnNMkSSPlaygnB4SaUhwtcfo2
         0H992iie2M+emEFe9gYp8MOGldXyp/oFhbfSHGitF3OovCOLhSG8fq6EO0OSvNHMq3SY
         YboQ==
X-Gm-Message-State: AO0yUKXax88HCXSYAxDCe2GiCpM2lhA4oUyvD93BogI2KyybvzqCvXeJ
        bwzIuqlNEsBWvtWlT1VAKqniMoiKro3gr2bFHp48oA==
X-Google-Smtp-Source: AK7set/Zmx7VN5BltpmgwSTsSc7WOIzQpDk+3s3ofuJbFtiGwWvDON+uR8R+LmFp6Q80p8wirplBIA==
X-Received: by 2002:a17:902:c40c:b0:19e:e172:2a40 with SMTP id k12-20020a170902c40c00b0019ee1722a40mr18511011plk.65.1679245315308;
        Sun, 19 Mar 2023 10:01:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14-20020a170902a50e00b00194d2f14ef0sm4958634plq.23.2023.03.19.10.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 10:01:55 -0700 (PDT)
Message-ID: <64174003.170a0220.17169.8a41@mx.google.com>
Date:   Sun, 19 Mar 2023 10:01:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.175-39-ge676dbf2bc3a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 182 runs,
 11 regressions (v5.10.175-39-ge676dbf2bc3a)
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

stable-rc/queue/5.10 baseline: 182 runs, 11 regressions (v5.10.175-39-ge676=
dbf2bc3a)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.175-39-ge676dbf2bc3a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.175-39-ge676dbf2bc3a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e676dbf2bc3a2132a478c235b475327738612b74 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64170de879657868a38c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64170de879657868a38c8=
633
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64170de8a91413e8b68c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64170de8a91413e8b68c8=
63c
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64170de979657868a38c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64170de979657868a38c8=
639
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64170deeba369a4be48c8664

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64170defba369a4be48c869d
        failing since 33 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-19T13:27:57.682762  <8>[   21.025399] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 186622_1.5.2.4.1>
    2023-03-19T13:27:57.791711  / # #
    2023-03-19T13:27:57.894310  export SHELL=3D/bin/sh
    2023-03-19T13:27:57.894860  #
    2023-03-19T13:27:57.996494  / # export SHELL=3D/bin/sh. /lava-186622/en=
vironment
    2023-03-19T13:27:57.997086  =

    2023-03-19T13:27:58.099120  / # . /lava-186622/environment/lava-186622/=
bin/lava-test-runner /lava-186622/1
    2023-03-19T13:27:58.100333  =

    2023-03-19T13:27:58.105090  / # /lava-186622/bin/lava-test-runner /lava=
-186622/1
    2023-03-19T13:27:58.211561  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64170ed7c2ca8fd9228c8632

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64170ed7c2ca8fd9228c863b
        failing since 52 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-19T13:31:44.434707  <8>[   11.019307] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3424238_1.5.2.4.1>
    2023-03-19T13:31:44.541147  / # #
    2023-03-19T13:31:44.643082  export SHELL=3D/bin/sh
    2023-03-19T13:31:44.643498  #
    2023-03-19T13:31:44.745300  / # export SHELL=3D/bin/sh. /lava-3424238/e=
nvironment
    2023-03-19T13:31:44.745678  =

    2023-03-19T13:31:44.846998  / # . /lava-3424238/environment/lava-342423=
8/bin/lava-test-runner /lava-3424238/1
    2023-03-19T13:31:44.847519  =

    2023-03-19T13:31:44.852756  / # /lava-3424238/bin/lava-test-runner /lav=
a-3424238/1
    2023-03-19T13:31:44.894399  <3>[   11.452319] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64170de8ba369a4be48c8657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64170de8ba369a4be48c8=
658
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64170de7c9e03da1488c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64170de7c9e03da1488c8=
638
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64170f1471ef79580a8c86f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64170f1471ef79580a8c8=
6f1
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64170e870365ab0c7d8c8657

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64170e870365ab0c7d8c8661
        failing since 5 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-19T13:30:29.308545  /lava-9686299/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64170e870365ab0c7d8c8662
        failing since 5 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-19T13:30:28.273545  /lava-9686299/1/../bin/lava-test-case

    2023-03-19T13:30:28.284741  <8>[   34.035853] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64170eb300a5b61d8f8c863d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-39-ge676dbf2bc3a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64170eb300a5b61d8f8c8646
        failing since 45 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-19T13:31:01.648316  / # #
    2023-03-19T13:31:01.750231  export SHELL=3D/bin/sh
    2023-03-19T13:31:01.750766  #
    2023-03-19T13:31:01.852096  / # export SHELL=3D/bin/sh. /lava-3424231/e=
nvironment
    2023-03-19T13:31:01.852639  =

    2023-03-19T13:31:01.954031  / # . /lava-3424231/environment/lava-342423=
1/bin/lava-test-runner /lava-3424231/1
    2023-03-19T13:31:01.954820  =

    2023-03-19T13:31:01.959285  / # /lava-3424231/bin/lava-test-runner /lav=
a-3424231/1
    2023-03-19T13:31:02.023398  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-19T13:31:02.058215  + cd /lava-3424231/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
