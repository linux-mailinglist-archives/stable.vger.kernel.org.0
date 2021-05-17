Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00D03827C8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 11:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbhEQJHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 05:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhEQJHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 05:07:05 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDA1C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 02:05:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b13so757029pfv.4
        for <stable@vger.kernel.org>; Mon, 17 May 2021 02:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=La9nbnjLtPo3Mf/TOriy4f7y9RbffAgvO6f27UocKyQ=;
        b=MSdpe3YO+9theuoTTkjTP2B9eqHBDkM5EftylZUSvWpjMTMTnmlcMFjEcY5EIp8NRC
         hXNRLlOY4ynXVZUEeJx2PRoOr+4QGuxWgz6bOX/k9Y/fbN0ujJ0UqgdqilgxGRQ3dshg
         qOzrrfbtljC5Tlg2lyNt0N65s8D69j2mGwonWwUANLfA6mFT6NqRTfhYzu/hcCd4dgee
         FgXXpPY+ehtrZHsvK3YakfNDNUapAeYCzQtn0fUtJ2xDov0PjaRG0O8HakLXKFq1xCnJ
         fxt2lutb66lpHTZ0KmzYQFtrdouYpjNkkq82GMw9n7Uv6cpn2ZHLV8gYh8vRDNelBSGZ
         p1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=La9nbnjLtPo3Mf/TOriy4f7y9RbffAgvO6f27UocKyQ=;
        b=DDIH8mYELZn05a+lDEtni1nEImm3xbbC1/w29AR98YCHJ11idMsmd74k6prePpG2Ym
         3EZnTR3BYAVwuEK/o2BftgL+bY/2f5wb2OeQPsFCD1ZM5f0JwJZuXrgTkSyK0ihTm1Td
         mW68rR/g/LPbXPN79VBtln4SrvvoNsNXpHYXxJVKJZ58M1DY1MGdIsbpD2GRYb8PbNU9
         ahoEdYGo7CSX6FLBtkJIBNuck0jGnRL18olUzynB/2lF/+7K7vecKpV1WZ6qzqGLsLHf
         Yt6xK5d5QaV2/cwRnva/vCMKdDIaKw+295Ad2KzpuXbhQv2nbVMsf83raZ01lR0KD+z8
         qHSw==
X-Gm-Message-State: AOAM533+fBmcItaglyaJncaFuB6DhWF2G4bFQ2yCoZq0Jc271DhxEiF4
        9xx02tEBhHu5gx964jiRcqSDyCAqKMYhNjaX
X-Google-Smtp-Source: ABdhPJxKfdNkttkf37TQ1jGzXtoEiFdQbf2r9+6RsvOfMgZLysrD1/xiRPGgww6AwT+cgzeXgUjElw==
X-Received: by 2002:a65:41c8:: with SMTP id b8mr9776030pgq.196.1621242347906;
        Mon, 17 May 2021 02:05:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w124sm9245223pfb.73.2021.05.17.02.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:05:47 -0700 (PDT)
Message-ID: <60a231eb.1c69fb81.d11d5.f3a1@mx.google.com>
Date:   Mon, 17 May 2021 02:05:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-239-g9ceb91ab8393
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 5 regressions (v5.10.37-239-g9ceb91ab8393)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 157 runs, 5 regressions (v5.10.37-239-g9ceb9=
1ab8393)

Regressions Summary
-------------------

platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre    | gcc-8    | bcm2835_def=
config   | 2          =

imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =

imx8mp-evk               | arm64 | lab-nxp         | gcc-8    | defconfig  =
         | 1          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.37-239-g9ceb91ab8393/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.37-239-g9ceb91ab8393
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ceb91ab83931abd2225ebc2834060554aebb513 =



Test Regressions
---------------- =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre    | gcc-8    | bcm2835_def=
config   | 2          =


  Details:     https://kernelci.org/test/plan/id/60a1f8a26ad3cc8414b3af99

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
239-g9ceb91ab8393/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
239-g9ceb91ab8393/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a1f8a26ad3cc8=
414b3af9f
        new failure (last pass: v5.10.37-212-g8d2b6fc5d616)
        5 lines

    2021-05-17 05:00:58.275000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00<8>[   13.754340] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D5>
    2021-05-17 05:00:58.276000+00:00  000005   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a1f8a26ad3cc8=
414b3afa0
        new failure (last pass: v5.10.37-212-g8d2b6fc5d616)
        36 lines

    2021-05-17 05:00:58.281000+00:00  kern  :alert : [00000005] *pgd=3D041b=
a835, *pte=3D00000000, *ppte=3D00000000
    2021-05-17 05:00:58.281000+00:00  kern  :alert : BUG: Bad rss-counter s=
tate mm:f32235cd type:MM_ANONPAGES val:1
    2021-05-17 05:00:58.282000+00:00  kern  :emerg : Internal error: Oops: =
817 [#1] ARM
    2021-05-17 05:00:58.319000+00:00  kern  :emerg : Process readlink (pid:=
 135, stack limit =3D 0xd855cfc9)<8>[   13.797331] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D36>   =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2007fc817f6cb1db3afb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
239-g9ceb91ab8393/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
239-g9ceb91ab8393/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2007fc817f6cb1db3a=
fb5
        new failure (last pass: v5.10.37-212-g8d2b6fc5d616) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx8mp-evk               | arm64 | lab-nxp         | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a202fe906e2dc577b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
239-g9ceb91ab8393/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
239-g9ceb91ab8393/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a202fe906e2dc577b3a=
fa5
        new failure (last pass: v5.10.37-193-gcd21757d3cec) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip         | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60a201f2ff72988d81b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
239-g9ceb91ab8393/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
239-g9ceb91ab8393/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a201f2ff72988d81b3a=
fa9
        new failure (last pass: v5.10.37-193-gcd21757d3cec) =

 =20
