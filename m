Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C641298A5B
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768633AbgJZK1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:27:41 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:35004 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1768422AbgJZK1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 06:27:41 -0400
Received: by mail-pg1-f171.google.com with SMTP id f38so5843695pgm.2
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 03:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DS5mHDDquyzbJDDN7nuqFBJCBhKfE2SeYbI2MtcD2U4=;
        b=MCXqTbphLlgjp7xlwweBgf1/2dtMw1djl7I433oSjNQzMlEQPmiy5Tru542DlV3m59
         PWkceNXk168Ed0nGs87dM+cj7KwyF2PVRpFTuZI4q3WMSOQXjtIX/jrSpTnh4YWwumr0
         X8/ksqCwf5lV8E5t9P3RD6NIonwRX+l2mksGM8jnm9uEJy83OV0Y7/w1nkcnqYNsy0xb
         1rbn8ay5cbppK6/cXOdc/LQuOEeY3HaTDfJSYM4cfgCQ5LNLgV3e6VucoBsJOIICq9x1
         +snp1d+6kUMB4SYegJ32LJU9feMAHmfIXg9ICjA7YfkHQTsh0exsIgnkr8ksjCVEK/J2
         MIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DS5mHDDquyzbJDDN7nuqFBJCBhKfE2SeYbI2MtcD2U4=;
        b=l8VixQv63ZR0AGWAhFIu4wrFePLlrYwKn8N4bM24vfSvVxz6L26J+/3EsadoptaCGs
         67Pw2kYgHYvX2AbGXHh3uxJZeowvRHaXq2dPam9tNyjLzBeR8JiHNFyo6l0fOhD10Z5T
         ncs7GPJiVDXZ48Esk4HfLORfAWAyinLSGkyHvFVvBBvxg9OMmFED1A9AYL49qSDG2hBn
         5qNKK/JS5pZQ3Q4mPtlqLp5mImXhyAMGaovTGndTyMwYgclTlcmnxEjJ3eCoIjEM5X02
         DM6C7qDJIygWX1i1qgDYPYEe+9f/EiqFNumRh/Nw05P7yIp8CuQNMEB57VD4/LMI4GLO
         TPDQ==
X-Gm-Message-State: AOAM533zuEf4ll9Y3+CqG1L5puCLMvf407dD/uf9mgzR9EGCb/svTyeY
        +NeCAAn6DqTO4aZitBcmzohKc5KJRlCSYA==
X-Google-Smtp-Source: ABdhPJzVPHFyUc4Rq0XVbFC1hBSlpXuJCcBUbTqdCiYlKyx8GUxHrVucfLVIFPmeBluFBDavTSoBjw==
X-Received: by 2002:a62:1ace:0:b029:163:9dce:5496 with SMTP id a197-20020a621ace0000b02901639dce5496mr5137037pfa.72.1603708058555;
        Mon, 26 Oct 2020 03:27:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p5sm11854504pjz.47.2020.10.26.03.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:27:37 -0700 (PDT)
Message-ID: <5f96a499.1c69fb81.bad37.85be@mx.google.com>
Date:   Mon, 26 Oct 2020 03:27:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.240-136-g2de2492be746
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 132 runs,
 2 regressions (v4.9.240-136-g2de2492be746)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 132 runs, 2 regressions (v4.9.240-136-g2de249=
2be746)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.240-136-g2de2492be746/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.240-136-g2de2492be746
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2de2492be746dc9e44ffc5502e35d4bc88d81471 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f96735faf97111c2f381012

  Results:     2 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
36-g2de2492be746/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
36-g2de2492be746/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f96735faf97111=
c2f381018
        failing since 1 day (last pass: v4.9.240-5-g556e4f1b1550, first fai=
l: v4.9.240-12-g493707a5601a)
        2 lines

    2020-10-26 06:57:31.999000+00:00  <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3D=
alert RESULT=3D[   20.366699] usbcore: registered new interface driver smsc=
95xx
    2020-10-26 06:57:32.002000+00:00  pass UNITS=3Dlines MEASUREMENT=3D0>
    2020-10-26 06:57:32.050000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/127
    2020-10-26 06:57:32.059000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff234 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f96712f2a6b162d4b381012

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
36-g2de2492be746/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
36-g2de2492be746/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96712f2a6b162d4b381=
013
        new failure (last pass: v4.9.240-14-g52afac38fdf8) =

 =20
