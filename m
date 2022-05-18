Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC48552C327
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 21:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbiERTSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 15:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiERTSJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 15:18:09 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2321712B039
        for <stable@vger.kernel.org>; Wed, 18 May 2022 12:18:08 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n8so2710559plh.1
        for <stable@vger.kernel.org>; Wed, 18 May 2022 12:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4Mbo7otWqnif+q3O58IgSvdP7Mqft6iUeGs9khwXacI=;
        b=lWLX4EJk4CviwXP9fHPe5wkMJN7U8omW3zaST/ls5/XZ1cosNGBLlRgHV5ynK3PuwL
         AWKLLT5R7a46pVRoBTjxnR2ulFQuWQGTNMen6Z5kiCKfjl7A9jtmJ88IKUnI3zRQrhzA
         E1dUvhMqGLkP5Tt4MWRRkBRhEAtFBgFDuWk1Vq1b0adFnfqaQJUkcXlTCqueJGK+ws9D
         Mq0x4ARSjAtvwLse9ZASYWLMtZPeunzvdqNIToMe87Ld+jU9JjIpuE++6wgR7yRjMrD0
         ooKBvoVVy50dVCBgQebLizPdW4dJcJqdsg8uw1J4+FMebclbBMB3C6eCt75N7w5i8dtE
         cN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4Mbo7otWqnif+q3O58IgSvdP7Mqft6iUeGs9khwXacI=;
        b=zzQyC1+4+1vSwk14yFrxXbCFifEUgHW2psqhcX/VEwvMJoHiGnBEi+e7pvxuh8f481
         RnRf9zjH4JgX7x6xrEWIbC4lJU0bD2DQQifQdVnwKsuHNkCCcGYiu9mVCkpwgJZl0wyN
         hn1gsmAO2I3LAJnSuluLn+UiOygmTNSQMiYx3qKyMQiAEWICUkuLgEw/Gy9+qRgZ3kdK
         Tlii32xgBQGcVpH2OsoH01Ga1TTdArsbh00eH9xTDzUbsZv8YleRN0goNkm2W7JoQQ7a
         PYFmqHtEZbfKth1zE9oGHyWsCFsmNC6IrXZZXtXMGpbaaDRyLMvwPgABcGeBrG0D3cPd
         d0pw==
X-Gm-Message-State: AOAM532U75P1uI/gtJ1if9wjmHiKqUKGEoU0Jy6AkExA8yxt8H1rcxUE
        R1mdNGI/+ECSL8SOzaqTC4qYyT6uywNIlFdzgN0=
X-Google-Smtp-Source: ABdhPJzeeOA3/HtJjOcUkdW9RKDgnFS/4PjJ33v4E2WKL06ZBcuQ5ftlhReuUlmiQqvvjn1ab3UGew==
X-Received: by 2002:a17:90b:33c5:b0:1dc:eff1:d749 with SMTP id lk5-20020a17090b33c500b001dceff1d749mr924669pjb.239.1652901487529;
        Wed, 18 May 2022 12:18:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p22-20020a056a0026d600b0050dc76281d5sm2381393pfw.175.2022.05.18.12.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 12:18:07 -0700 (PDT)
Message-ID: <6285466f.1c69fb81.53811.5dff@mx.google.com>
Date:   Wed, 18 May 2022 12:18:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.41
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 154 runs, 3 regressions (v5.15.41)
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

stable-rc/linux-5.15.y baseline: 154 runs, 3 regressions (v5.15.41)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
beagle-xm           | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g        | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.41/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f43e3ac7e662f352f829077723fa0b92ccaded1 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
beagle-xm           | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g        | 1          =


  Details:     https://kernelci.org/test/plan/id/628514784cc5233303a39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628514784cc5233303a39=
bd3
        failing since 6 days (last pass: v5.15.37-259-gab77581473a3, first =
fail: v5.15.39) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/628512e6df05fd57a0a39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628512e6df05fd57a0a39=
bf6
        new failure (last pass: v5.15.40-101-gcbfc4f42bd5f) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62851ca0908ea84fc8a39bf5

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62851ca1908ea84fc8a39c1b
        failing since 71 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-18T16:19:35.039741  <8>[   59.442169] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-18T16:19:36.060842  /lava-6415617/1/../bin/lava-test-case   =

 =20
