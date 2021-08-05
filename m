Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E783E1D0E
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 21:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbhHETzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 15:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhHETzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 15:55:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84EEC061765
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 12:55:15 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so12204185pjh.3
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 12:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tNher0+APtfBh3CuAMfZpcCSjE6cC5uzUw9wsCWAhL4=;
        b=TCuIgsayL5CFUGK/NVbVablfl6u7FcQ0hxa5Y3BL0B59s2xdhDEQgeD6/CI9ljNhcj
         MWZjSktM19vFtTY1EDjlU7jfPS2O5/mzpXMB5+iy3xdsmDfhEzqhyWV+v2zOHl9q4ECX
         Mk6a6sNp3Z4/C9961Cb/eA4Uoz3x2tFoKpxzO0iNI87oyzb3qVEZPDTsx3AvztnzslAM
         gAc6lsIFd+B4X4umIHVHvwikvta02YPX7/IQ2XF6mlVvk8WDiciWIuVUIlWL/3FbNnhs
         8R7cYti1EZrg2pbJ0rnb+bnq4IU+12aNn/oXn02NaM2MoxMh2lpa7g4qmysAQeVL3CIs
         RTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tNher0+APtfBh3CuAMfZpcCSjE6cC5uzUw9wsCWAhL4=;
        b=CmwDASnIbD0rGCnqDlBfREMj/ry1S+cG/E/wyS1wLyKQet2bd9fYUkVJvC1vLhixIz
         jedUkuCY6qwzzU0hOfRQb3ZiwhwgBx42+zE8zqtOcfN+yWfkmk14hQPVGOE8Z1Kv/wIW
         TYEZxzF+7AtwUIBwPXmWe8YRn/J2rYDZbtt30um3wVR9HY2hF4hI45KFLIAc4EWlsXOP
         NZnsgy/LQ4rVjYL4lcJ1QpSMU64ZpDnAo48ILrFdhIc66AD/IjBMox43AF/4wVSvCvY8
         Uqb9y8R9nnF7O4VaGx+nNjXvfbHYlxaW2fo46Co9aLoJ41aUIr8+VxrT7+/Hyhkz/AZA
         egxw==
X-Gm-Message-State: AOAM531BBsNGRj6NvwKv7EOIC+0UfVqa4VN6YGR5Mx8Qd8KsqhxLKOA4
        aoYTGPrDAehJlXI89Ega5jx8PxnZnRnitq3B
X-Google-Smtp-Source: ABdhPJw+2a/JFG/6kaaAYs1ao9Cl+5kJ45jjecUA5K0C8ldkT5WF5UPrsKABsOY9JNc1K3Zkp69SGw==
X-Received: by 2002:a63:5252:: with SMTP id s18mr339916pgl.94.1628193315224;
        Thu, 05 Aug 2021 12:55:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm8700432pgs.23.2021.08.05.12.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:55:14 -0700 (PDT)
Message-ID: <610c4222.1c69fb81.8eaeb.a1e2@mx.google.com>
Date:   Thu, 05 Aug 2021 12:55:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.278-4-g0494a460c278
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 45 runs,
 4 regressions (v4.4.278-4-g0494a460c278)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 45 runs, 4 regressions (v4.4.278-4-g0494a460c=
278)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.278-4-g0494a460c278/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.278-4-g0494a460c278
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0494a460c278d87c2242a902ba368d5c595d75d6 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610c0b98a1afd09d6fb13685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g0494a460c278/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g0494a460c278/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c0b98a1afd09d6fb13=
686
        failing since 264 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610c0bb381cd59f8a6b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g0494a460c278/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g0494a460c278/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c0bb381cd59f8a6b13=
66f
        failing since 264 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610c0b841f22447c17b13680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g0494a460c278/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g0494a460c278/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c0b841f22447c17b13=
681
        failing since 264 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610c0b97a1afd09d6fb13682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g0494a460c278/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g0494a460c278/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c0b97a1afd09d6fb13=
683
        failing since 264 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
