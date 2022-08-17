Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04EDD597666
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 21:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbiHQTYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 15:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241196AbiHQTYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 15:24:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9948D5F87
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:24:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gp7so13332870pjb.4
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=ci/PqB9aH4MCSqF0AMfxDJ/pKguhwuw9T6tgEEWFPDU=;
        b=WaAQfi5mvKUoJP7jFWOIzl62KWEh7mnbc1EvW8ypFdLj22tg0Rg+j/wp6oIni1b+9Y
         qq90oMbW2TLpqWyJp/VecQgVzmXTzUxOSpNdYPTk3JkyKI4G019e4vNR4zTINbsyjn8g
         7ut5drDXjQ4NlQEC2VawmFFQu3o+sP0pcuSC4rxSFrczmtNQl6a2GbMQ9UmPUH3zU2PC
         wnJ8kKEASI8WjBASYcOYYR/XjofLstzk/kPKSox5WS0LuEXCg3xy22dEtsZPwwPE4ltk
         AC02kwOH9HUcH6OSvIYli7QUkqfC6YMNeXzhPl7i4URgQBmX2TrtsK6zXBfNNB4uh2TG
         MSNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=ci/PqB9aH4MCSqF0AMfxDJ/pKguhwuw9T6tgEEWFPDU=;
        b=LCTb4RqedKDtxLjGCskBfF+fJv+wA41HSRrYUxNWtxpDuYijKn2wW2qluA3XN47v7r
         V7pn/RPtu1G3KgNbIlV11tSP2ghAiyja5sRjMYYg8nZe8PzBuKHXVu68Hmwi/GaLk+I3
         c1RTKTeTv+v94uiFeKfcKalZze2L+MGLmdGjJRjBG0wQou7htv6TobcVY19idLFjdk82
         lmXHo/97uxwTzGB00PahJDrGI5H6/Qy9JL+nmnLJhrvxofFD1A1oTjxKYA4gztvbwApr
         CD7P2a0kSbibIauYFPusB9UWX2B5Adfcx9vaczr7VBG/KyrnYJ/QI9JPDND/yb9sb7lk
         jqIA==
X-Gm-Message-State: ACgBeo0596KMmwXi5X/Zm0prEK5och8sNkBiCVZLQWiyQYBoJl7kfXC0
        x9sb9TA8wzCOxJN0jS2nVuQ39UHQYokV+8nx
X-Google-Smtp-Source: AA6agR6OaeMB/rl+lQkR+iQvbIiJu2sCeUAcEOu8unTwnmdr1M1e+58H61EAI90G7LIaifa23rrI5w==
X-Received: by 2002:a17:902:f54b:b0:16f:14e1:c484 with SMTP id h11-20020a170902f54b00b0016f14e1c484mr27428579plf.28.1660764287922;
        Wed, 17 Aug 2022 12:24:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v20-20020a170902f0d400b0016ef7235e09sm281451pla.168.2022.08.17.12.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:24:47 -0700 (PDT)
Message-ID: <62fd407f.170a0220.a1f2f.0b11@mx.google.com>
Date:   Wed, 17 Aug 2022 12:24:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.210
Subject: stable-rc/linux-5.4.y baseline: 106 runs, 5 regressions (v5.4.210)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 106 runs, 5 regressions (v5.4.210)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.210/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.210
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de0cd3ea700d1e8ed76705d02e33b524cbb84cf3 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd1065fb850f94ef35565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd1065fb850f94ef355=
65e
        failing since 99 days (last pass: v5.4.191-85-ga4a4cbb41380, first =
fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd1064fb850f94ef35565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd1064fb850f94ef355=
65b
        failing since 99 days (last pass: v5.4.191-85-ga4a4cbb41380, first =
fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd103b2bcd4c68da355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd103b2bcd4c68da355=
644
        failing since 99 days (last pass: v5.4.191-85-ga4a4cbb41380, first =
fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd10274960b53a8035566a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd10274960b53a80355=
66b
        failing since 99 days (last pass: v5.4.191-85-ga4a4cbb41380, first =
fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd111119d71e083c35564a

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.210=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62fd111119d71e083c35566c
        failing since 164 days (last pass: v5.4.181-51-gb77a12b8d613, first=
 fail: v5.4.182-54-gf27af6bf3c32)

    2022-08-17T16:02:02.495833  /lava-7062124/1/../bin/lava-test-case
    2022-08-17T16:02:02.503683  <8>[   33.141149] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
