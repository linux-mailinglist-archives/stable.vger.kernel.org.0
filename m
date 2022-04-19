Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2542506C98
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348828AbiDSMmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiDSMmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:42:03 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F20936145
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 05:39:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h5so23464437pgc.7
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 05:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CZGu4VW+/p3DtDVr2F/r5ULccw634LWmGMm0vp5EX+Y=;
        b=HEAh+P+7+l6CvkuA72MGk8fUlrz+/4wKwC+l4E+SXPfaF7+Zp0mjrtEba1w11OziKO
         KMf6K5UKFo7RweYn1JtF5PpzAHfsKsDf4olzF4NC1/wSOyznK+iYQk2mzraNchb1LBfs
         aAtO0oX6l+tf4xUlsMCKP86svU9iCfSBZjAfalLjZJthpYAWZ6gCBgsBZFghTo9GEdkq
         wUy2VUL85kUGsLaKsfwsFO0zF1RWXKDUQGAcBXgxcYSRdOmff1+MEekDOuDsrU3cTNaa
         3i1qcsbMf8eg7Yfj71h9KtvV/9CL/2hKY9GcTtcqVXSKir+czuUFpkhw2j+jda2QAg92
         UvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CZGu4VW+/p3DtDVr2F/r5ULccw634LWmGMm0vp5EX+Y=;
        b=fZTuhEsY7Uey4Zh+EzbyVoJ2Ab8gGra/9aAdOXz5i7hE/PABI2uHEhRXYbUQy4cCV3
         d38iJkD++lu0qfwrCCXXjdTi7I28mPWDTfq8El5uX9u9xscTb7z/yQb4l609ZCO+Ntcj
         CP6VNUKp/zbsgO4Efwn6jGeIuyEOz+ucc8KM88P9WG7mzoObzbVzJ1vekDMKwluaClbb
         KMA+Akh553P96vUjNijqFxRrK/c0fHA/wIiwT7e9vK1p5yhh135XMzNdk1jp4RZd9cBH
         woqg6FDUljPq+r3o4awuuwab9trtMUZ7+Lu8dF6IguRbr7sBEbJzkFROUbwyz4awOHEv
         JPkg==
X-Gm-Message-State: AOAM53385Dw4CG6OJEVKnamWi/l04hz0GaFu8l+vXhfWg2BkAzBinNmT
        xAhMLtrphm8Z4kQqoaDsL4/gaUjauFiJwW7C
X-Google-Smtp-Source: ABdhPJy3Lzn82/sLWhzFI5KenbWy29fnC7+WHdq36eg2Ll62jBOP+EILMzTbpO57u6f6GMadbqsNVg==
X-Received: by 2002:a63:f44e:0:b0:3aa:e66:f774 with SMTP id p14-20020a63f44e000000b003aa0e66f774mr6957373pgk.381.1650371960936;
        Tue, 19 Apr 2022 05:39:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d141-20020a621d93000000b00505aa1026f1sm16477395pfd.51.2022.04.19.05.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 05:39:20 -0700 (PDT)
Message-ID: <625ead78.1c69fb81.0d69.67a4@mx.google.com>
Date:   Tue, 19 Apr 2022 05:39:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.238-32-g4d86c9395c31a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 103 runs,
 4 regressions (v4.19.238-32-g4d86c9395c31a)
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

stable-rc/queue/4.19 baseline: 103 runs, 4 regressions (v4.19.238-32-g4d86c=
9395c31a)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

meson-gxl-s905d-p230         | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.238-32-g4d86c9395c31a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.238-32-g4d86c9395c31a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d86c9395c31ac4749110fdaabc34c93b93b011f =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/625e126f0cc99dc3daae0684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-32-g4d86c9395c31a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-32-g4d86c9395c31a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625e126f0cc99dc3daae0=
685
        failing since 18 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/625e1283dba8799eccae068d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-32-g4d86c9395c31a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-32-g4d86c9395c31a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625e1283dba8799eccae0=
68e
        failing since 12 days (last pass: v4.19.237-15-g3c6b80cc3200, first=
 fail: v4.19.237-256-ge149a8f3cb39) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/625e121629a511a525ae067e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-32-g4d86c9395c31a/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-32-g4d86c9395c31a/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625e121629a511a525ae0=
67f
        new failure (last pass: v4.19.238-22-gb215381f8cf05) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625e1292dba8799eccae0692

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-32-g4d86c9395c31a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.238=
-32-g4d86c9395c31a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625e1292dba8799eccae06b4
        failing since 43 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-19T01:38:19.622175  /lava-6119200/1/../bin/lava-test-case
    2022-04-19T01:38:19.629815  <8>[   36.703038] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
