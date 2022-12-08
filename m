Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D884647407
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 17:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiLHQSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 11:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiLHQSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 11:18:02 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D554512A8A
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 08:18:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y4so1972260plb.2
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 08:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=A9q0iXwSxrgkFt7OwU0zqs22BWfkn3S4QZDyvVUGcUA=;
        b=7J7vgArVGio+O6Q9PeTKJTRFBo7419FEztDvs0hAADDq4KwJX+6iQJAYawTloNHqeN
         rUlsQ0w3IqgMXzFbHaEIif0zWHoKD1cIPMCnzXFy2uEsiGnSC+MbjGD2CEtJIRa6qzQf
         UmAdHiPcg1XAYmHbfTU3llPkCwgW/xebqtGrjJPYSJcvAYd8QpgZE+N5T7YVTkE3PofU
         kT9aKl4RKIWhtA8JQqgrXT6JVhLjssy0LnkTp8xrYWaaHoi0l9OYLFvsdPlj2r4W8sqN
         mj0XU8KaeK9TXuiJszTvjGUs7c/j2v81wNnA15jVwHB2fOZvWbBvD9/MhJ+TQt4LGVvf
         2cyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A9q0iXwSxrgkFt7OwU0zqs22BWfkn3S4QZDyvVUGcUA=;
        b=nq8d8+9+yJ+I2NyonYTsreS0C4T8dAc5M6db3bMXbxeVyfFmHLGl4HgCGwx51aKI6A
         kSi+c9hf1fMmc3+cPv8dlfFe0OOfMSg8jgPAY8fv44oGG4ROXtwmvjgbrq3IED3Hhm6O
         X/kkZFCxzkZnxrfuFIFotG4vDH+DoCXqWtkGlNN0SzIxgPyaHwgWLsCDpNRJp+33aYW7
         inpHtOoJlivJeoHbrJohAc2CFACRdZ8weD40N2/SPnccJL5vsBZS3jpu8t2J0FGP4tWL
         27wrBZlwMnNoFlAmHWswncYqWhxsq4vBACOimf1HDMON4kjtpTk1ZVMebQWXyHUxuiZu
         iKmA==
X-Gm-Message-State: ANoB5pngYYbVWTWHU05MsVJREsB1NVCL7KapHSb/7+v8LAz0q8ayP07k
        NazBNlkpJkLHmU4XitPngEs1jrLGEfIoGLmJRW0=
X-Google-Smtp-Source: AA0mqf76xSMuZ5b05xRf7kdD38W3sbxPe5pay7213UAIWpBm1azLjGWETLiDD4iSDsBeZ/APVynUYg==
X-Received: by 2002:a17:902:ee45:b0:189:894c:6b48 with SMTP id 5-20020a170902ee4500b00189894c6b48mr2687839plo.59.1670516280936;
        Thu, 08 Dec 2022 08:18:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ix19-20020a170902f81300b00189c536c72asm10970979plb.148.2022.12.08.08.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:18:00 -0800 (PST)
Message-ID: <63920e38.170a0220.8eeb7.4a67@mx.google.com>
Date:   Thu, 08 Dec 2022 08:18:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.158
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 158 runs, 4 regressions (v5.10.158)
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

stable/linux-5.10.y baseline: 158 runs, 4 regressions (v5.10.158)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
meson-gxbb-p200          | arm64 | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

r8a7743-iwg20d-q7        | arm   | lab-cip       | gcc-10   | shmobile_defc=
onfig         | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip       | gcc-10   | defconfig+arm=
64-chromebook | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.158/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.158
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      592346d5dc9b61e7fb4a3876ec498aa96ee11ac8 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
meson-gxbb-p200          | arm64 | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/6391dccf5ef313b54e2abd46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.158/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.158/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6391dccf5ef313b54e2ab=
d47
        new failure (last pass: v5.10.149) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
r8a7743-iwg20d-q7        | arm   | lab-cip       | gcc-10   | shmobile_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6391dbd70390ca831e2abd61

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.158/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.158/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6391dbd70390ca831e2ab=
d62
        failing since 12 days (last pass: v5.10.155, first fail: v5.10.156) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip       | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6391feeb3eba92fbf42abe08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.158/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.158/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6391feeb3eba92fbf42ab=
e09
        new failure (last pass: v5.10.155) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6391e24dbdb5be842c2abd0d

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.158/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.158/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6391e24dbdb5be842c2abd2f
        failing since 274 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-12-08T13:10:18.257888  <8>[   60.148566] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-12-08T13:10:19.281328  /lava-8287761/1/../bin/lava-test-case
    2022-12-08T13:10:19.292201  <8>[   61.182973] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
