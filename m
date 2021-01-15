Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4428B2F825B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 18:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbhAORaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 12:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbhAORaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 12:30:14 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6627BC061793
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 09:29:34 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t29so788413pfg.11
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 09:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qBUrD67E9FG1a51IiH6aN+aIAm3sV7KLKkP0kJNn0tU=;
        b=yhUU6xTjeipFnHpH/zYG4mRVaA1JAXy0X41NToQE6O8TfpooR/O4f3v3YKEaqSk3r8
         Rs6No55GY7ESh0soMltH64Wn9vVq4RW4hhqZVssy2ZV39tr1kA+T9j3/HNpXYA52wVSV
         A1aHPbntFPvPHe1Zb2uopZ+cUikfl4Um8CFlCi5Evu4ZlId1j1g4Saig1XeeBhqITHW3
         Is+YEnIcsSMH0kqP16JA1FmvYmsGj9zQl3wnv6CWNN9SwbNEduchk0TZr4ZtHw9ZUOoc
         1APrM91wary0m+J7GVO6wFerM/l1SXzWwh1Z6L7cNVOC9n0Rjv7KCDd0ve5KLEYj4yvZ
         I5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qBUrD67E9FG1a51IiH6aN+aIAm3sV7KLKkP0kJNn0tU=;
        b=aqcIEFgFG+adxwVqiIBz4imwafCPbtA3OjrGr30pI2f+WK6Tvyv4rAp9mk7cZ3gejl
         baojZggPW6epI0qRGSvSxa9bfrNpX8bXYIEhOFb9UeTQwpvcXJ3CyyGHV4bbE2GEy1fz
         x+Ai5SaNvocqZNizpv/2XpQ9GtMK7YUC3Dj+H5YOwvS8rbGo09yyp2+8bbdGOgzIWKD/
         cWkTqUDIzQLNJzgDJzJ7ODtMHJjsAyEsgGgJL81eoVXWaQOmJ0VjMhqbetUZkeIJBJ7x
         RqwCoQuiIboJ8RHAN+abHlfy8PUfzc7U81XmoOabNf/JeWuB559LLIy9gI74ePViCiAA
         YSNA==
X-Gm-Message-State: AOAM533xQBzfPzU9wFooqo47HK9XbsuAuQ68VXUPGOA5LhUzb5NcEcOK
        cIG2aq85KzxjfT6kcY1GABb80i3JtbyHgA==
X-Google-Smtp-Source: ABdhPJxCZ+X2/L7S257APmnNsxjcPF0t1xZOeG8os5of6IwpC9neVxEIF1gcHIHT2lwSqS9MgdpStw==
X-Received: by 2002:a62:d14f:0:b029:1ae:72f9:254c with SMTP id t15-20020a62d14f0000b02901ae72f9254cmr13565671pfl.38.1610731773433;
        Fri, 15 Jan 2021 09:29:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c23sm9284246pgc.72.2021.01.15.09.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:29:32 -0800 (PST)
Message-ID: <6001d0fc.1c69fb81.5ef4b.693c@mx.google.com>
Date:   Fri, 15 Jan 2021 09:29:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.251-25-gf56a3ca86b32
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 108 runs,
 5 regressions (v4.9.251-25-gf56a3ca86b32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 108 runs, 5 regressions (v4.9.251-25-gf56a3ca=
86b32)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.251-25-gf56a3ca86b32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.251-25-gf56a3ca86b32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f56a3ca86b32fa12f6fcc727200490940073077f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60019e6d835400acd4c94cc8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60019e6d835400a=
cd4c94ccd
        failing since 0 day (last pass: v4.9.251-9-gaad962dcf3ae2, first fa=
il: v4.9.251-25-gcf38131e4e86)
        2 lines

    2021-01-15 13:53:45.431000+00:00  [   20.940063] usbcore: registered ne=
w interface driver smsc95xx
    2021-01-15 13:53:45.477000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/126
    2021-01-15 13:53:45.486000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-15 13:53:45.503000+00:00  [   21.008941] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60019c1bae07ae09c7c94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019c1bae07ae09c7c94=
ced
        failing since 62 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60019c0eae07ae09c7c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019c0eae07ae09c7c94=
cd8
        failing since 62 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60019c44d51e231451c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019c44d51e231451c94=
cd5
        failing since 62 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001aea8c27e80d757c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-2=
5-gf56a3ca86b32/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001aea8c27e80d757c94=
cdd
        failing since 62 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
