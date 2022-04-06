Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FE74F63CD
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbiDFPl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236494AbiDFPlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:41:03 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87ED1AC727
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 05:57:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h19so2401871pfv.1
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hBep/CrI6vSg2aKTQgvaCKzMuOnlJpVxTC+bBY5H1bI=;
        b=03r/Mg9/xUTTaroeOhZkxiRyf7tMtuqgzZE2CrUr54ccdWBFjVC2ds1YHgjo/GFdWT
         odfnfTR5PCfdsC9ebTzoSlMrNc2iF4q5aasGD+LSNrYxrYaBPwYfUSF0HaTpuYQYRPik
         IMWav7D4ZlWm8ykv5Jm0Aaq1Me3UekCx5bH6f+6NIOPv7hpIGQQyslXTh8esIgoN09G/
         4OJFcIH9zZUozwAxvhEWZI/kd/kGNf7yimCpZqn+l1Pc5ZMEuf7PdIjkrMOGXyeATZ2F
         1tNTBwV9NyWvbjqW21w78vQEvQ2lcrDW+pY+piicLwgXJS3rSvzyY/LGvat6lzzgV/ti
         Y/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hBep/CrI6vSg2aKTQgvaCKzMuOnlJpVxTC+bBY5H1bI=;
        b=nwZH6glNV0XH0i1/8K6qa4+x+FO2VzJ52JRryg8RpXSsgFqdNHFtASqMfUXM4vfLdN
         I1Vl0yKvpxXUS1zOZTVNA0YTSbkl1cMMDaNp/MOEZwuFV//UuWLxy9vYd2nPZUBRdEU0
         cgAW5MzKInCfOUXYE7RFWjTdSRFOycxpPQTxZwo+ITDuzPCHtMdTrkhbTQF4KT9xQtsZ
         gpeYfarWV9uV+6qA6ms7/6SnSBXPTCrlFTNS2JO1HJpTPRtgT6GzkadfckPxfD0ADeKo
         MP+45gwgUoBOIyCH1DslSh/SE7GFBGdY9ySZr3kNb9muALxZUwk9BNsLz9mMHLQuOuEb
         zp0A==
X-Gm-Message-State: AOAM533yju/x88rPupkRsoW74oqKe/X6DnY7TS/DPKGmEL7hsIxPzv8S
        keFFEWgG97CEhWQnXkOh0N5xAQUkUsaSRH0s
X-Google-Smtp-Source: ABdhPJxCzQy03tDzwM4vvl8QGdMonCUfK3c1KK//3TCXSTagGFPKKTOUZc6H7lfzdIuSsLzecJv9iA==
X-Received: by 2002:a05:6a00:244a:b0:4fa:ebf9:75de with SMTP id d10-20020a056a00244a00b004faebf975demr8611751pfj.73.1649249865029;
        Wed, 06 Apr 2022 05:57:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a034300b001c779e82af6sm5538233pjf.48.2022.04.06.05.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 05:57:44 -0700 (PDT)
Message-ID: <624d8e48.1c69fb81.7caf9.e9dd@mx.google.com>
Date:   Wed, 06 Apr 2022 05:57:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-369-g3cb60cd4b204
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 59 runs,
 3 regressions (v5.4.188-369-g3cb60cd4b204)
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

stable-rc/queue/5.4 baseline: 59 runs, 3 regressions (v5.4.188-369-g3cb60cd=
4b204)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-369-g3cb60cd4b204/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-369-g3cb60cd4b204
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3cb60cd4b204539825a81f8fe055ac408ff70f3e =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624d5aa111d1fc7d79ae0684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
69-g3cb60cd4b204/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
69-g3cb60cd4b204/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624d5aa111d1fc7d79ae0=
685
        failing since 111 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624d5aa06a32319978ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
69-g3cb60cd4b204/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
69-g3cb60cd4b204/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624d5aa06a32319978ae0=
67d
        failing since 111 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624d6079d6715f110eae0687

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
69-g3cb60cd4b204/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
69-g3cb60cd4b204/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624d6079d6715f110eae06a9
        failing since 31 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-04-06T09:42:01.807827  <8>[   31.613081] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-06T09:42:02.819754  /lava-6036826/1/../bin/lava-test-case
    2022-04-06T09:42:02.828262  <8>[   32.633851] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
