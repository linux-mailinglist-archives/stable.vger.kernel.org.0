Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9280A452A08
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 06:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbhKPFvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 00:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237163AbhKPFv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 00:51:29 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3282EC061766
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 20:32:38 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v19so5584333plo.7
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 20:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dyXnZXiQN2EaZ6XrUYrAVxsJGicb+qnKbzow0S1J32g=;
        b=winTWl5ATzOBx0M35lwwbbcxYtzAx8Ll5wmfp4mZLX5QmU88w6djG5iWmh2UuznFN5
         tFKnwiz717tHXXDK6NZOImChGrzVJfBcbceI8hLcgFRKY0gCmiVFLUJBm6tsnmx/AS+k
         Fv/3P8D+f3iDmqvgcgMyaev9LTCS1WPyQ9cSfm4/YfUCFLjVe+MAjdjFv6R7Ew+025jj
         oba6xp5WN2TXveWQW5xcs2snv1k0CUNYtD0+JS7GVi4dxWoHrsxfC2TFHbOuYx8EfAsQ
         +qVTXZwy5bl1Z0aID5QJ0xquN6ACCZv/iYmRog3XkaGjWKnuCITnZrHLDeoMDH9FZJox
         jOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dyXnZXiQN2EaZ6XrUYrAVxsJGicb+qnKbzow0S1J32g=;
        b=gJhPucKN7eQMUcaeqY/yQgjGtZk2AzFGQnPNxiyqDEQtBtT55KzZ2FfGVMxbucvvwW
         QpQ1/mwHQnwedp/tmgeIL9lEPn7nP3dF1dZ2oudjIZEMhmmzPOZd++woXkFg39zlG0XZ
         6qx2Vtq3bAShyzkuIroCw2kGbBGDXD/i+p+n+1CAySTXzCyzhDCCpVjra4Mfdlrmrqww
         HlCcQT1KmalU221pRA13lAcG2YxJ2dCk2ClBRRdzVeWahk0TePluEmwG//nFoQSunnya
         lPPGfUEmt74PSsmnneV3y00rs6seWdDCQfFAi/v79d4YBB3/KibUUu2PGSVN08yhtnW6
         z9JA==
X-Gm-Message-State: AOAM532OXjRrqD7d6AjNKpHkWX4W1C4qiqv+GXhYcCpLOg8EOOJ/AB6L
        BPoJkZnUucBBrSQI+arz15rilKOjL/YFf/qP
X-Google-Smtp-Source: ABdhPJzFUlC2IRtw+EFiqQRsodRPLUrcNBVmTVWBdyOXzyVxSaNTSh4edRcvKk8nq0YC7ffN+2bbtw==
X-Received: by 2002:a17:90b:2412:: with SMTP id nr18mr72934090pjb.233.1637037157429;
        Mon, 15 Nov 2021 20:32:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1sm745475pfu.47.2021.11.15.20.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 20:32:37 -0800 (PST)
Message-ID: <61933465.1c69fb81.afdc0.3179@mx.google.com>
Date:   Mon, 15 Nov 2021 20:32:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.79-576-g5c7cb5c152031
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 151 runs,
 3 regressions (v5.10.79-576-g5c7cb5c152031)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 151 runs, 3 regressions (v5.10.79-576-g5c7=
cb5c152031)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =

meson-gxbb-p200          | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.79-576-g5c7cb5c152031/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.79-576-g5c7cb5c152031
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c7cb5c1520316c728b44f31c1bd6b22942a0b18 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6192fafb1d04c5fe51335967

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
9-576-g5c7cb5c152031/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-im=
x6q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
9-576-g5c7cb5c152031/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-im=
x6q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6192fafb1d04c5f=
e5133596b
        new failure (last pass: v5.10.79-126-g498eb27d1093)
        4 lines

    2021-11-16T00:27:27.708169  kern  :alert : 8<--- cut here ---
    2021-11-16T00:27:27.739381  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-11-16T00:27:27.740569  kern  :alert : pgd =3D (ptrval)<8>[   39.50=
4274] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-11-16T00:27:27.740838  =

    2021-11-16T00:27:27.741073  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6192fafb1d04c5f=
e5133596c
        new failure (last pass: v5.10.79-126-g498eb27d1093)
        46 lines

    2021-11-16T00:27:27.798226  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-11-16T00:27:27.798534  kern  :emerg : Process kworker/1:1 (pid: 57=
, stack limit =3D 0x(ptrval))
    2021-11-16T00:27:27.798865  kern  :emerg : Stack: (0xc2461d68 to 0xc246=
2000)
    2021-11-16T00:27:27.799430  kern  :emerg : 1d60:                   c3a2=
71b0 c3a271b4 c3a27000 c3a27000 c1445994 c09e30e4
    2021-11-16T00:27:27.799680  kern  :emerg : 1d80: c2460000 c1445994 0000=
000c c3a27000 000002f3 c3ac0400 c2001d80 ef86d800
    2021-11-16T00:27:27.799907  kern  :emerg : 1da0: c3ac0400 c2001d80 ef86=
d800 c09f0834 c1445994 405588bd 00000001 c374b4c0
    2021-11-16T00:27:27.841430  kern  :emerg : 1dc0: c234ed00 c3a27000 c3a2=
7014 c1445994 0000000c c223d4c0 c19c7a10 c09f0808
    2021-11-16T00:27:27.841978  kern  :emerg : 1de0: c14436b8 00000000 c3a2=
7000 fffffdfb bf048000 c22d8c10 00000120 c09c6800
    2021-11-16T00:27:27.842228  kern  :emerg : 1e00: c3a27000 bf044120 c374=
9f40 c3242908 c2276780 c19c7a2c 00000120 c0a231d8
    2021-11-16T00:27:27.842459  kern  :emerg : 1e20: c3749f40 c3749f40 c223=
2c00 c2276780 00000000 c3749f40 c19c7a24 bf07a0a8 =

    ... (36 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxbb-p200          | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/619305bf9f3aa92fbd3358f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
9-576-g5c7cb5c152031/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxb=
b-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
9-576-g5c7cb5c152031/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxb=
b-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619305bf9f3aa92fbd335=
8f6
        new failure (last pass: v5.10.79-126-g498eb27d1093) =

 =20
