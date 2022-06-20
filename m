Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98614551931
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiFTMnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242848AbiFTMnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:43:45 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B686363B5
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:43:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so1021216pjj.5
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZuypnuvAv0CzTN86hqvZZ83M9ZnY7AQoRoIZgrYewgo=;
        b=R8sRaPTEIp6yRUwulLxaexqO15BrosOSGAVBD9H/q3/FQCosGY6cxyd2QKYA0R8uoB
         X/ReexvVFrKvhaXXCfBg1D8cx6PjOIj5+iczbVHJ6WTA37L8GHyql1XaNPgVZcyVgEUg
         cb9dG/E8Md3wyduumkkQhw5+MstFqcow0iOGKWPRuLqa+9brHuaQNNsYeBzI3lXRAXWu
         vUeJN1N05LOaYfs04wPPp77WsYD1wQiII8K92CR++zhKEi/yPbn3l3ZV/hy2QtaNOtjW
         gA0EJWfugsDb8MS3iZVQPxia2c2iRsnuzOk2kBHIKUnP4zPijwPeRxQIlZG0Bb1kZNsF
         EKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZuypnuvAv0CzTN86hqvZZ83M9ZnY7AQoRoIZgrYewgo=;
        b=cZA2k88kyiapQuRFs+3geoCYaRbKbKXFKg1ZBMqCRtkcjWh1F9IFysvYI+HC3De/AV
         9Sk764irvv9zW3s5uMeB0cVuOTPB2EP1e8SkjdHU2WMyhg1is8sMZul/b8SVwUFhTMjI
         P4oT+TrdpBnObp/DpBtILnFpL3LTsB3z2D/u8XVqnVQbnF9FIzgit+6B6tbc8Uqy8bU+
         7EpKu77QEeByLMwkWcWaQFUxrUAsLPR5uldK8bhClNUakwVARNZcHTlsjwPorWNPF8v7
         H+gsjvMnHht8TM5jv4fY9hKkiBubTN6sIdf+t7s/CudE3jlqqVz0HGTD8XxM7aZK8Vyk
         5r5w==
X-Gm-Message-State: AJIora92Y6Mc+/NgxvdGU9DESdYSxv+EFq7rZzqNzpBLXzSwTCho20sC
        WJMabAOSHQd0esK7EchBtVcC/N9TvrGAYP7nZek=
X-Google-Smtp-Source: AGRyM1tCo7YIznmMVpeEetmM2XXf+V2nSPGttcUf7mOodqrRC7X5Db2sX3wHWaR+CNlc6leY1P/KxQ==
X-Received: by 2002:a17:903:120b:b0:168:98a9:221f with SMTP id l11-20020a170903120b00b0016898a9221fmr23170985plh.48.1655729024016;
        Mon, 20 Jun 2022 05:43:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u23-20020a17090ae01700b001e31803540fsm5198233pjy.6.2022.06.20.05.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 05:43:43 -0700 (PDT)
Message-ID: <62b06b7f.1c69fb81.cce5f.6d25@mx.google.com>
Date:   Mon, 20 Jun 2022 05:43:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.123-59-gcd76509e1d819
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 103 runs,
 8 regressions (v5.10.123-59-gcd76509e1d819)
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

stable-rc/queue/5.10 baseline: 103 runs, 8 regressions (v5.10.123-59-gcd765=
09e1d819)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.123-59-gcd76509e1d819/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.123-59-gcd76509e1d819
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd76509e1d819be042d10b05d8640c5ba23729db =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b035ebc79ef2dae7a39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b035ebc79ef2dae7a39=
bd3
        failing since 41 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b035c7acf1e4d739a39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b035c7acf1e4d739a39=
bd3
        failing since 41 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b035ee026b03f14ca39bd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b035ee026b03f14ca39=
bd8
        failing since 41 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b035dc026b03f14ca39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b035dc026b03f14ca39=
bd0
        failing since 41 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b035ffacf1e4d739a39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b035ffacf1e4d739a39=
be8
        failing since 41 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b035c8735da7c01ba39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b035c8735da7c01ba39=
bdd
        failing since 41 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b035ef731f9dfcd1a39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b035ef731f9dfcd1a39=
bd6
        failing since 41 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b035dd731f9dfcd1a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.123=
-59-gcd76509e1d819/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b035dd731f9dfcd1a39=
bd0
        failing since 41 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =20
