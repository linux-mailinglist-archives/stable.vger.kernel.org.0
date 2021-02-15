Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA0B31B3A6
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 01:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhBOAm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 19:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhBOAmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 19:42:55 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C776AC061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 16:42:14 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z15so3203556pfc.3
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 16:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k9Eyk2oFeLieSbl2pS5d6A5xxy36tvHVuYZq9ZcSMoA=;
        b=uSsz21QixA5Gb+PnhSCRmzFWtXN375r/LTlY3RmAX78kSe09fnCEr0EAx14jo1wbBP
         QcYqa8MTfPw5GR7ewi//PBqry0QGV8iGoytML46cx1lRAvpVIeRAjaZz2Iqj5WtFALC3
         syiPqIr0lkKEoyW26JEadoPXQPFS2U89dAxM5GSLeg3TgtxB8UqhKqd1dahZnmlBkXBJ
         7B+v7XFt+pdcWNzV5jRkE9jOVle4/v6+lgigqRwA+iDAbrEsrc3D5OBeqEZ6/P/FErvD
         RbqlOOORKNj5anunFcipTdEJVks9Hc876UhfAq8LaAIhOR28Bb6dBfnFIBh9bDb0cRkq
         hmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k9Eyk2oFeLieSbl2pS5d6A5xxy36tvHVuYZq9ZcSMoA=;
        b=psVrNgV0a+zPNXDncCyStUoLut7O+VettA0IYk9A8T/fcv7BUVaz8XR5k4wGvWKOVu
         OG/1eTuUMtSaYpMqu7Ee1tdRBz10zhDJPyQ73bl+E6ITYRzdVVusxlRLlod/6LuLuA2D
         N2/Ze65CoX5cj/rLuptyE6b+9f/VuDh4NQ5PEDtXnNpaDdeIbnz9iv0cY5+R1f0k/K2s
         LCTNNF2Rps1d1oH7hSA2xACb9YoJkdxrolPVbmNnPzgY/evyDyQomQtjVGqjnWyCBNc4
         xgC6EaAAZiOZo+9uH2qj/wS1dvT875eMGdDaHIJbRXwWSuWbqLdgXXKJCIKxRsmGc/D5
         DNRw==
X-Gm-Message-State: AOAM531h4HS+IDC1QeasEVllUNiYMX1vb7iDDuvT6+1Rh2A6l+39620t
        w03icflAjkU4aPPqAK/MxH8udUnfx/Hyjw==
X-Google-Smtp-Source: ABdhPJxbZQSSBiLoSwxT7wCc34VjBs0/K/MRhXxTCrPXgDMNzlpOT/qyOvejim6KcKI9QXyedCQEBQ==
X-Received: by 2002:a63:ec4d:: with SMTP id r13mr12864085pgj.53.1613349733802;
        Sun, 14 Feb 2021 16:42:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa10sm14528534pjb.45.2021.02.14.16.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 16:42:13 -0800 (PST)
Message-ID: <6029c365.1c69fb81.40a17.e6bf@mx.google.com>
Date:   Sun, 14 Feb 2021 16:42:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.98-23-g73a6e97e8c78
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 95 runs,
 4 regressions (v5.4.98-23-g73a6e97e8c78)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 95 runs, 4 regressions (v5.4.98-23-g73a6e97e8=
c78)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 2          =

hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
| 1          =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.98-23-g73a6e97e8c78/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.98-23-g73a6e97e8c78
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73a6e97e8c78165beed4aa24e6fc5861351bf699 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/60298c80210bf6ed453abe99

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-23=
-g73a6e97e8c78/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-23=
-g73a6e97e8c78/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60298c80210bf6e=
d453abe9f
        new failure (last pass: v5.4.98-23-ga860ca302099)
        4 lines

    2021-02-14 20:47:36.772000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address bf628fa0
    2021-02-14 20:47:36.773000+00:00  ke<8>[   13.691257] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60298c80210bf6e=
d453abea0
        new failure (last pass: v5.4.98-23-ga860ca302099)
        29 lines

    2021-02-14 20:47:36.777000+00:00  kern  :alert : [bf628fa0] *pgd=3D0000=
0000
    2021-02-14 20:47:36.822000+00:00  kern  :emerg : Internal error: Oops: =
80000005 [#1] ARM
    2021-02-14 20:47:36.823000+00:00  kern  :emerg : Process udevd (pid: 91=
, stack limit =3D 0xce8f03b0)
    2021-02-14 20:47:36.824000+00:00  kern  <8>[   13.734511] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D29>=
   =

 =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60298c44a64391b5c03abe9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-23=
-g73a6e97e8c78/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-23=
-g73a6e97e8c78/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60298c44a64391b5c03ab=
e9c
        failing since 86 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6029930c074a0396943abe8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-23=
-g73a6e97e8c78/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-23=
-g73a6e97e8c78/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6029930c074a0396943ab=
e8e
        new failure (last pass: v5.4.98-23-ga860ca302099) =

 =20
