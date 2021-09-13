Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57CB4098FF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhIMQ04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhIMQ04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 12:26:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368CFC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:25:40 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f65so9344061pfb.10
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pc7VtRpFHEgQd2d5l8nmhxwSAarzsOINkqiX/al0kc4=;
        b=2TVFPCfZO+CoSpXg2ePQsp/FTpRDdXCw9/Ka61fTX/phEH3Ss3wSJDwSD8TPox0H/m
         WQU0DQpQRd23x/JSbfeVtmRnCjD4dj+s5iWhfZAvZZR6n2SNCjqKfyFmYVBhVwBFGN20
         cz4XdqMAv+vk3nn1jCSQTErR0YMMm+G27cWTOvA5ZrH2w5wCassw0Mq+M2a/u6HGtR54
         u1JVrZpK7bYFeevMKGk2WBsY+LNTsITqS1cKQB5YeNCPi7GlXzKl2WQYT2XyCSCM6Hhf
         n03I009HrwsVsYo98JzlP2CHJQuMWlcfpGnXWPymZxYmVLHR9NInroMfAQGgYTUjk1Il
         sxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pc7VtRpFHEgQd2d5l8nmhxwSAarzsOINkqiX/al0kc4=;
        b=SA0IN2kmG9bnzXOBstYoxPqyKCa9Aa/C4qG0FWseY8BdRE/TDO0/vfqAp9e99H8p0y
         Xkk7s4bXNmGxlrcLZK05GbvElN/lkn2fHWx+rkXmzQBrEBekraCSPDlrs3cHWrj3x/Vs
         mRfDP0yX+RIhz6TS7d8FvsComXx5tcYZSeYJY3XlC6Q3z2Wga51HCQvFUoLXSMAwaNgd
         0D6ygFdUSU2XfHazCNJDVwzaMREr77133fXB/n/LTkg+bK3z6iqwa5HJSP7uIPiMoDDq
         oIbDpZw2JXMMTU8ka4TEPAF0l86HhmjEDhW2i2yCd7c1Yz1B6pVxG/Vjp/5Kcgd23sAQ
         GHew==
X-Gm-Message-State: AOAM5335/vlMDCvQIRnqRVqf/l9pNkmBsWRgtbDW+QFe5nklAfvQgGG8
        dT5lIoRVOUJYbYcKCH3+2glH+Evsp7OB6vM8
X-Google-Smtp-Source: ABdhPJwDpmWbe0e3gkcCagge7TJ/GMulDYeAEQOY6XMz+8I7UDm85dhvV6pHPxpU+cxH3twgaz2rXQ==
X-Received: by 2002:a63:6d82:: with SMTP id i124mr12027365pgc.37.1631550339543;
        Mon, 13 Sep 2021 09:25:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 131sm7834305pfw.72.2021.09.13.09.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 09:25:39 -0700 (PDT)
Message-ID: <613f7b83.1c69fb81.aa8d2.68e3@mx.google.com>
Date:   Mon, 13 Sep 2021 09:25:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-84-gfad11947c54b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 118 runs,
 4 regressions (v4.9.282-84-gfad11947c54b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 118 runs, 4 regressions (v4.9.282-84-gfad11=
947c54b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
i945gsex-qs          | i386 | lab-clabbe    | gcc-8    | i386_defconfig    =
  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.282-84-gfad11947c54b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.282-84-gfad11947c54b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fad11947c54b6f6d8734892b44100b0b7998d30a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
i945gsex-qs          | i386 | lab-clabbe    | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/613f47a42baa49d56299a2e5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-84-gfad11947c54b/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-84-gfad11947c54b/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/613f47a42baa49d=
56299a2ed
        new failure (last pass: v4.9.282)
        1 lines

    2021-09-13T12:44:04.930412  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-09-13T12:44:04.939357  [   13.454780] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f46c8c90833f11f99a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-84-gfad11947c54b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-84-gfad11947c54b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f46c8c90833f11f99a=
2f3
        failing since 302 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f46cc9a761f2e1499a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-84-gfad11947c54b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-84-gfad11947c54b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f46cc9a761f2e1499a=
2de
        failing since 302 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f4677c5ab59874699a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-84-gfad11947c54b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-84-gfad11947c54b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f4677c5ab59874699a=
2f3
        failing since 302 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
