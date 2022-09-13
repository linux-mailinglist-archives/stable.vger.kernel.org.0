Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3885B78C5
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiIMRsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbiIMRrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:47:46 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9226543
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:45:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y136so12324205pfb.3
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=4Y0JAz7SjOxBigi7gjJShtSnAYEDUYLe/hDIM8rxnts=;
        b=700Po4NfH6R56ZaI32U7D3LCsJv/4O5NKU8DddJQyJ/Yt6jB4+DhtCYSq1ASLnC2aO
         etdxDInHLUkvOe5PWc+PsigckaHBVC3Cm+ljQmHjv9x7CsVJY78hIhtD+T7vqf4ejaHJ
         VtwJLtCXvulDoiesKzmimxDSz8caBuxBdUD1xQ+oG91DEA7PlZu5TTg6FfYCRcEQYU6I
         Sd7AVso9mcGAZyra1w/GdXmmPUPLRXazMu6uDV6KgB90S3fvSKQSFZ8DQo6ZBIUWI7qw
         Kbo3GFH4iDv19B/7Tk43l1IOqf6ZB2McyZh0KkIlqaea388Ina9BPRy+jw1Re5GQjlyu
         w8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=4Y0JAz7SjOxBigi7gjJShtSnAYEDUYLe/hDIM8rxnts=;
        b=r1Z8JQR0MJzNQEG533DG2uIEkWCopZPhnnVg+PEAnhMszLqeSgQ7HgK7SbgnBet9+c
         njXBMGAt0/UWxlOBbdAMnown28n2V+Yx55IsLRZ0gOB3LRGKdas8mISxFLmkXxHLFpng
         sovbMTD9Ic0kTjMbCbhVEH5BfA0tN7P1PpcbZCwBqVgT59/eZIU7wRIadWX3Bdcu2Aqw
         t6qhh7/8Ml8ZnrbHfvfemX/spWfsBxzIsEH2zm2b4z4vjLaYSuxxKgftk2slxwCHijig
         eRuOCJz1ih2xTp/bJpQoTK0OjejdvmnpFwh/+kKTcOdK3b+gl5VpxhA74kW588zVfGKX
         eA7g==
X-Gm-Message-State: ACgBeo0di0waem9HWWwdHc5G8ZYLlXcWcV1rEAFVqGmJ3CEngLj7oYlz
        LvDVc0mXRlJd9qT7PpTXMsVrV66qvpw88tMXTQM=
X-Google-Smtp-Source: AA6agR7/fkG2Kh0lhX66BusEGUKUw70j7FbIMBAVcJK1jFvSnPXCKdIXNZoH0ysmZUID+vuaLUMZ9A==
X-Received: by 2002:a63:2341:0:b0:434:d9b8:cfdf with SMTP id u1-20020a632341000000b00434d9b8cfdfmr28300919pgm.446.1663087504405;
        Tue, 13 Sep 2022 09:45:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7-20020a170903124700b00176e8f85146sm8863179plh.185.2022.09.13.09.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 09:45:03 -0700 (PDT)
Message-ID: <6320b38f.170a0220.fd06f.f0cf@mx.google.com>
Date:   Tue, 13 Sep 2022 09:45:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8-193-g3acd07a8c4dd8
Subject: stable-rc/linux-5.19.y baseline: 183 runs,
 2 regressions (v5.19.8-193-g3acd07a8c4dd8)
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

stable-rc/linux-5.19.y baseline: 183 runs, 2 regressions (v5.19.8-193-g3acd=
07a8c4dd8)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
  | 1          =

imx7d-sdb            | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.8-193-g3acd07a8c4dd8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.8-193-g3acd07a8c4dd8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3acd07a8c4dd8598b9a97082d8c9ea516bf4973c =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/63207f118066c6d89d35566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g3acd07a8c4dd8/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g3acd07a8c4dd8/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63207f118066c6d89d355=
66e
        new failure (last pass: v5.19.8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx7d-sdb            | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/632080fd316dda4f023556c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g3acd07a8c4dd8/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
-193-g3acd07a8c4dd8/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632080fd316dda4f02355=
6c1
        new failure (last pass: v5.19.8) =

 =20
