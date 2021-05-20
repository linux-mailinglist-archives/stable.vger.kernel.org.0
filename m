Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C33538B9BB
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhETWwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhETWvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:51:44 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCCEC0613ED
        for <stable@vger.kernel.org>; Thu, 20 May 2021 15:50:20 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x18so9182928pfi.9
        for <stable@vger.kernel.org>; Thu, 20 May 2021 15:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3cDhkrZSfXIB1s+4+7xysBRUZOrlyYvfYCdw8sWW1CM=;
        b=nOadyPiWtVOVury2sQwaF3OvBdE9LPb4BwTBYqGr6FgbdVboEHqF6MBtt7nVay6Gwy
         R2ZpKYppiHXYWqPwn068RgbyzGCTdBWKL2uRDlO0F2S+BQNIqjrWtHgtrqg9Ry/DmjpA
         8M3xkkdBn3yiwQSZ1Usjl5OG2b9RiqygkjYboRp+L8svmWWk3d9G1xCUoW5nSLmPidRb
         QtIVs1me4LyBD/2ozhNEm4f2KL3KLXfmcZNFT13H9Q3Row9A3lR7pTSAept6y8FSAIuo
         N+pdn0RbaAj3cPa/YUt0Onc/r36Pch1vvJ1CjqOklH6uhOybxAcdum8CbptBOMFKb6Zc
         Klcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3cDhkrZSfXIB1s+4+7xysBRUZOrlyYvfYCdw8sWW1CM=;
        b=M56+hhozOWKe616KF94W+gi+dR22DMQF9NQwPBrOxrjip2YuKVQahNTcSk8kWzIomp
         4wgFQb7PzpQsC6gRMTx1oteoQYT6YrDFtW9Det+W1i8GR6ZyMFnfl7yQYXzzhFHWrfA/
         RUWoi3ZYLV+9Aea/h72S/ZohHFWhSqHenNZLAlgcVnOhNIJ2Vwq/HMEREIYThpYArr/E
         ioyBFUQx19NfgSOATZLFalvBvjPnXVhimHfLIkKDDpsasc7ojRtu5D7KR/ExWLYHWJ1b
         lH4nT9Dyv+gtnQ6XMciAe5eY7uNdO+9RyMdRYHZy8QGizlZhqoZYNp9cfxS6gITst1H1
         juWA==
X-Gm-Message-State: AOAM530POSwgBSwTysfpBkxlGMUATU6xqefAmB8PbFa5wclzqFbD9KEi
        N36tHo2M5mVhEgj1hBHoVHB+Zh10RKFBKPvC
X-Google-Smtp-Source: ABdhPJy2FqooY3zyrDB2/LMW365gG9qWagPPcmcgvoYaq43H/iGqmhLbVtLD5+YNPenSZcet5xdifg==
X-Received: by 2002:aa7:9533:0:b029:2de:3b90:57a7 with SMTP id c19-20020aa795330000b02902de3b9057a7mr6784863pfp.15.1621551020224;
        Thu, 20 May 2021 15:50:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm2732693pgp.10.2021.05.20.15.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:50:19 -0700 (PDT)
Message-ID: <60a6e7ab.1c69fb81.f62a2.9f5d@mx.google.com>
Date:   Thu, 20 May 2021 15:50:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.5-44-gee71fa12d93b
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 155 runs,
 3 regressions (v5.12.5-44-gee71fa12d93b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 155 runs, 3 regressions (v5.12.5-44-gee71f=
a12d93b)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.5-44-gee71fa12d93b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.5-44-gee71fa12d93b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee71fa12d93bc1ea09ff69a8e6b7f44399cf209a =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =


  Details:     https://kernelci.org/test/plan/id/60a6aee7fac53e9beeb3b025

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.5=
-44-gee71fa12d93b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.5=
-44-gee71fa12d93b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a6aee7fac53e9=
beeb3b02b
        new failure (last pass: v5.12.5)
        12 lines

    2021-05-20 18:47:52.489000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00<8>[   43.017041] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D12>
    2021-05-20 18:47:52.490000+00:00  000008
    2021-05-20 18:47:52.490000+00:00  kern  :alert : pgd =3D 24615206
    2021-05-20 18:47:52.491000+00:00  kern  :alert : [00000008] *pgd=3D0424=
2835, *pte=3D00000000, *ppte=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a6aee7fac53e9=
beeb3b02c
        new failure (last pass: v5.12.5)
        111 lines

    2021-05-20 18:47:52.495000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000008
    2021-05-20 18:47:52.496000+00:00  kern  :alert : pgd =3D 8b0d409b
    2021-05-20 18:47:52.532000+00:00  kern  :alert : [00000008] *pgd=3D0424=
7835, *pte=3D00000000, *ppte=3D00000000
    2021-05-20 18:47:52.532000+00:00  kern  :alert : 8<--- cut here ---
    2021-05-20 18:47:52.533000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000008
    2021-05-20 18:47:52.534000+00:00  kern  :alert : pgd =3D f2b651ed
    2021-05-20 18:47:52.535000+00:00  kern  :alert : [00000008] *pgd=3D0419=
c835, *pte=3D00000000, *ppte=3D00000000
    2021-05-20 18:47:52.535000+00:00  kern  :emerg : Internal error: Oops: =
17 [#1] ARM
    2021-05-20 18:47:52.536000+00:00  kern  :emerg : Process udevd (pid: 10=
5, stack limit =3D 0x4d87c817)
    2021-05-20 18:47:52.537000+00:00  kern  :emerg : Stack: (0xc425ddd0 to =
0xc425e000) =

    ... (89 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a6b251c164c391eeb3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.5=
-44-gee71fa12d93b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.5=
-44-gee71fa12d93b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6b251c164c391eeb3a=
f9d
        failing since 3 days (last pass: v5.12.4-343-g1fa9b48b0d6a, first f=
ail: v5.12.4-364-g8c6ba5015aff) =

 =20
