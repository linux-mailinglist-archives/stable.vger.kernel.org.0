Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225832B11FF
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 23:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgKLWpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 17:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgKLWpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 17:45:45 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08F1C0613D1
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 14:45:45 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 34so2191618pgp.10
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 14:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d/7bjObckZm3rhiVQJ9hjwsHsympQyjMcD41fZdyPUU=;
        b=AQNsCxWQKNePI0GvgUxVa9zTQx9Ddur/hyteA6+CmkBPQjmypeY0IgtgX9WIt+Gq+U
         O50fJxAOW6vEqEXi8iBejes3eA3r26IehnPQU/9wXtCYMKlly/FqAB7Sd/TQTc+EbWUi
         C44N3+916rpXzM4acxsRBrUwx3R9471c/P0tZ0MzGQAIi4D9oA/dRGrbkCwtIPIeZRDp
         licxl5sNC5gf43ceW1XCq1LfBhHFGIaFotOP2V1S4QuwQhoc7SWqU88YZdWrBcaHQKcU
         LvttOZCMEbZWkdPsItVhBv0UTLJt9TtZdwBNUL+5E5sqkXsSsupgIa+6OJ3s3wWV/f8P
         YUbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d/7bjObckZm3rhiVQJ9hjwsHsympQyjMcD41fZdyPUU=;
        b=tv5PRq30Pm5EX/7y/W/8WZ3SKOafftL1wDOAQ7j2aK9hcBbcyT0jZtBF3uRg7HuIJz
         soX6T5sUuMbnYcxNx4+Wmf/WbGn03oWPJRRzYSgHk29eZpJs9NlIxaQGI1Bldorw3rGd
         gijLZSwW9PcYcg5iaWfz9AJrbBj8/nZRAEKMo8bF/0MEXnPiWoT0Wz2XSF9L8hOcQuvR
         YrBrfUm6AbH21UYc4708AmWOuqr7Z1UNtP64BDjK7DVwve20YoS4fCOcy535XR1DNWP3
         C7QtEntPT7SW9r7VEUAvALA65503tVKP8cY96nNge9uRP0kdZ93JVEMPCeihixnvHvpp
         KQ4A==
X-Gm-Message-State: AOAM533a6ADAblkyh0nAtQPX1zP+Hfd+dm529x5EjaIPNJ7h7sF1OI8L
        zEdbnlXfpgLfDKPv/MxBOp7+b1zKRZhXzw==
X-Google-Smtp-Source: ABdhPJwghCSe/zmiXecs0nq0oVMBXG+0UblTi5UkanCxHOkrKeyiGqzbEKxWm6VpFRG3l6pxUoTdXA==
X-Received: by 2002:aa7:8105:0:b029:18e:c8d9:2c24 with SMTP id b5-20020aa781050000b029018ec8d92c24mr1573038pfi.49.1605221145048;
        Thu, 12 Nov 2020 14:45:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id js7sm7906285pjb.46.2020.11.12.14.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 14:45:44 -0800 (PST)
Message-ID: <5fadbb18.1c69fb81.4c9ab.044e@mx.google.com>
Date:   Thu, 12 Nov 2020 14:45:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.243-18-gfc7e8c68369a
Subject: stable-rc/queue/4.4 baseline: 123 runs,
 3 regressions (v4.4.243-18-gfc7e8c68369a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 123 runs, 3 regressions (v4.4.243-18-gfc7e8c6=
8369a)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.243-18-gfc7e8c68369a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.243-18-gfc7e8c68369a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc7e8c68369a4ef7f0a5a2e21f161ae2b46b8218 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fad87a59c40409f5adb8864

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
8-gfc7e8c68369a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
8-gfc7e8c68369a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fad87a59c40409=
f5adb8869
        failing since 3 days (last pass: v4.4.241-86-g2fa33648e935, first f=
ail: v4.4.241-86-gdeb6172daf90)
        2 lines =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fad8ad0d0bb70aae5db88e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
8-gfc7e8c68369a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
8-gfc7e8c68369a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fad8ad0d0bb70aae5db8=
8e1
        failing since 1 day (last pass: v4.4.243-13-g3ae0f9dc7816, first fa=
il: v4.4.243-13-g0e9f589aa60c) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fad87c59aa71b8215db887e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
8-gfc7e8c68369a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-1=
8-gfc7e8c68369a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fad87c59aa71b8215db8=
87f
        new failure (last pass: v4.4.243-13-g0e9f589aa60c) =

 =20
