Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C5A50EC3A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 00:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiDYWn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 18:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbiDYWns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 18:43:48 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F210B2BB38
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 15:40:40 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b12so13741671plg.4
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 15:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qVmpEVzEiwxuOMG0EyIT7na1hLOFBe6jND4yDz7TD8c=;
        b=3AM8j1UtzhKKIhItnx/BCUJcieupBJbdtsownp/hwkrD8AbTgfAH4A/9dDc776XY/9
         DJRv3JFSFgPb1siAgC8LIc2xcJSvoCXuskt+fWFvOdQmUdnTakbdZMD70hSeWN6LNbwK
         38c3qB58yEn73H/ahcWaBox4EEKhAdfT3okPW39GS6SMHyFPPvWk7l4G9ZOjPbgw6VzL
         brMtHq2JX1BN4hmPH1WfwqfSsOnLhWVz7hHL+CKt58Hu9omiAmwhUtkYbp1p1DVGJg1T
         tPbRVlxsipbVImYivx0vw70bvDYzYoetYop7+hwFNzqQxo7ibFZcH3sEZakzSDFdwDCr
         58QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qVmpEVzEiwxuOMG0EyIT7na1hLOFBe6jND4yDz7TD8c=;
        b=QoeWwEHuWaWVekh/bhsG84FSLpizIsk908Gqk7NaWNcxh669AricCXo5VxF3c1wuJM
         qiE6V2e2+hNJSv8xMzK9oEGi5bN8Kw76klO8O7eI+UwwEjebBJpElI2kAhY9VD7OcS6J
         WR4al9n395XzQomzcRneeAMrtC9729qpxPi8FiJ5kUe++ISlhVBH4frThuPPwWHydZi6
         V48Y+w4XQ3qA/qcJ0FmuAhH0c7rsg0Xvt7ssd4PfmXgXfnsl6QiA66iDhuLFHIrRGjOL
         wKpp198lx3tjyO8C1d24oFnmGa8T3r0bgtwJt4nkM13B3th/hbmM8DgP277bD1+jHSro
         7zvA==
X-Gm-Message-State: AOAM5332eYK+CNuw+nah3LudHEhJKeO+gY1BeCaFp7lXSyXim8MskGK4
        M0B5epN3IAbqRk57o/AC4+siQpL2n4d9Ri05KmA=
X-Google-Smtp-Source: ABdhPJxmk7ecqpAFV8taJENxVJvS3XpltU997cc3YjjITKQqROcuJCYbPo1JoVsJLf+bXq1MdyI5VQ==
X-Received: by 2002:a17:902:dad1:b0:15a:1cc6:f9f0 with SMTP id q17-20020a170902dad100b0015a1cc6f9f0mr19835685plx.31.1650926440333;
        Mon, 25 Apr 2022 15:40:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u26-20020a63471a000000b003aa1ad643bdsm10800789pga.47.2022.04.25.15.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 15:40:40 -0700 (PDT)
Message-ID: <62672368.1c69fb81.57c4d.ac37@mx.google.com>
Date:   Mon, 25 Apr 2022 15:40:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.112-80-g72a95bfdca05
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 92 runs,
 2 regressions (v5.10.112-80-g72a95bfdca05)
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

stable-rc/queue/5.10 baseline: 92 runs, 2 regressions (v5.10.112-80-g72a95b=
fdca05)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig    =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.112-80-g72a95bfdca05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.112-80-g72a95bfdca05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      72a95bfdca05e14c9610c9214e8fcde6365670c3 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62669c3c5f009eb16cff945c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-80-g72a95bfdca05/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-80-g72a95bfdca05/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62669c3c5f009eb16cff9=
45d
        new failure (last pass: v5.10.112-5-g01ffcf58029e) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62669fcdd0782fdf18ff9470

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-80-g72a95bfdca05/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-80-g72a95bfdca05/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62669fcdd0782fdf18ff9495
        failing since 48 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-25T13:18:43.594475  /lava-6170794/1/../bin/lava-test-case
    2022-04-25T13:18:43.605658  <8>[   34.632922] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
