Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232824D642E
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 15:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiCKO6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 09:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiCKO6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 09:58:49 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC7665E3
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 06:57:46 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q29so6681157pgn.7
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 06:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G3zjCO2eOUR6WqQMUyWsX7x7yTePRfAadM+IuCOjz14=;
        b=ZRh070RfwdtuDWsj5/gJro92Pr2doCA2PFzia86xVkA361j14oG17mw56bZ22t33Il
         +gVrZhYZS7Hj5sO4B6LPPLQP7fSyyTQFG6yfPTxvupsH3H6aLrolzFVDOv2rNzTZsjud
         wEPst8s4+MYKBWGQlkNRHdtZqDZcMWHuxgEwtc1gnyQMpEJI9k7GXfysEpA1AF8NYKZm
         95tzRXtSgiG+IB0UQXxpv0hkYtKXaFLYiEhEEYjOc8jq7FiG3akaVTulk29mzTNfv75p
         zI2tDOKxRTtOLZoVbud1ORH43R9Ql2F6PjOAgmufmmKONmDcKVYL4dtz+CjHRD6bUpcA
         Jgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G3zjCO2eOUR6WqQMUyWsX7x7yTePRfAadM+IuCOjz14=;
        b=Bz4P+fUNOPUQKWcTe5lLFyUJO89QRQ476o/7vzes/nMqjYe4r6x3dCsRrkT6HyHr3s
         VV1ZqSaonTfnnw5MbepX4zOgLQPnkK5Vgy5AQQIPebdGKCyDWHFFeNG8iTJgYGk6vICO
         yk+/7xv+G2pN2H3gUopGOAeNJ4FbaDj+v4f8asCVl0V1EQ5EIJWc5kXUKGieylVh08vQ
         9mThh6kMrVMvdB4dEuu4HDFo/Ai03cJdPlEgfbWYQkPbCyJIgI0YOFROGch0QMYLMiSO
         lQP6ZHY0NDtmcyfeftnKSPx+DxYo8b9eBnHjstcENEclS28hy4AfC0zw3ZH2I9mU3gEt
         ytQg==
X-Gm-Message-State: AOAM531yPDH1M9IjDRouuhihjklnxzx84FqdC26Dfs14QecG/zJVkIa6
        m1rN8SlQEeEP3EeSd36jUiB4iazuXgdjoFtmtbo=
X-Google-Smtp-Source: ABdhPJzw4YOnH1QpwcWttVrHAUGFhWcwO67qudoSAdjdsNrKxkns2rmMFaIgOozMtnRs9yBof4qh7Q==
X-Received: by 2002:a05:6a00:1381:b0:4f6:e4ba:2d64 with SMTP id t1-20020a056a00138100b004f6e4ba2d64mr10230473pfg.24.1647010665599;
        Fri, 11 Mar 2022 06:57:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7-20020a056a0021c700b004f7916d44bcsm2289735pfj.220.2022.03.11.06.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 06:57:45 -0800 (PST)
Message-ID: <622b6369.1c69fb81.21ad8.4590@mx.google.com>
Date:   Fri, 11 Mar 2022 06:57:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.183-33-ga2885049c4de
Subject: stable-rc/queue/5.4 baseline: 92 runs,
 3 regressions (v5.4.183-33-ga2885049c4de)
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

stable-rc/queue/5.4 baseline: 92 runs, 3 regressions (v5.4.183-33-ga2885049=
c4de)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.183-33-ga2885049c4de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.183-33-ga2885049c4de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2885049c4de70d32438d59c042ee9962ce93834 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622b2b3978d941a0e3c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-ga2885049c4de/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-ga2885049c4de/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622b2b3978d941a0e3c62=
96c
        failing since 85 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622b2b61ce7b04276cc62991

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-ga2885049c4de/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-ga2885049c4de/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622b2b61ce7b04276cc62=
992
        failing since 85 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622b2b33484e0bc773c62975

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-ga2885049c4de/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-3=
3-ga2885049c4de/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622b2b33484e0bc773c6299b
        failing since 5 days (last pass: v5.4.182-30-g45ccd59cc16f, first f=
ail: v5.4.182-53-ge31c0b084082)

    2022-03-11T10:57:34.857523  <8>[   30.317637] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-11T10:57:35.868348  /lava-5859019/1/../bin/lava-test-case
    2022-03-11T10:57:35.876830  <8>[   31.338311] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
