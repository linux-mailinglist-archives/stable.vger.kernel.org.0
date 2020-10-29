Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B192029F62E
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 21:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgJ2U2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 16:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgJ2U2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 16:28:36 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB9FC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 13:28:36 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r10so3286304pgb.10
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 13:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WtmJuUI0erpAy8qPnPeQwyn6qFlxFr493jbqSDcY0ic=;
        b=KVdN3/q0wHk1/TgBIGt9x7YxSrnD+jwhLgWggsJCYkaNuxJLrfLmR+ebunFEa/vFUs
         AulR2GlYQgXSJDcDy7J3QdzRScyRZl2oGRLTUyf++/g0UEwEvkoCdawTV43K4ob422Yi
         1WfYfEx3WRtcTG8ZJuqqxS/+4NqUD99GXWEcs6j+iPpG8yIFC0tc/O4/J+T8iAEIl0E1
         5CN/q5TNpZPtCsP2BnV5/tV0NXllU3SVcY9VvarrwEsd2m4rez96DHxVeqwWTjK4ZYS4
         Dm/vPcaC6KLLyjk8MiqD31wOMTWs6WKgpzldairu7wJYJDB11O6OI2pCXMpfwKcrPXNy
         RkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WtmJuUI0erpAy8qPnPeQwyn6qFlxFr493jbqSDcY0ic=;
        b=LsRZ7e7whhrgnPQx2pSdTCnnqUkVFAMh9qjEKPfCO6lI7mF6/On73IhzUlErphzeOK
         XjWFIDG44kanuOwGgh4pzO4JulQWSFsulu2c/uIZJhogHWu38UhZZlIoXPiJmPnsZiwp
         xFfnOadj+7Dqj52kjIM2mQRa1ik+DEnjsXynVgFi0gQYpcUDOk76fXfUgVOu1NO8Mn+j
         EQ9VzFT21dxLKqUBspyP0HfGCyByB69orJx1B+vY12Jd2R8qOrOJe7D7ECwXLvo8ESaQ
         Z8MjOH8UEVc07Zv6VVviOlbDGbqN+cv2xC40FZR6jAw6KDVgEEX0spE/lRSnOb+aRVDe
         lNSg==
X-Gm-Message-State: AOAM532NEkYMKH4jC9y/J9IvKk/3N3jhoLo4uqsQvN+8I5eZTIMfjaI7
        hKaMuMbc10EnNmK4tT6RMfcTJf/mvh21cg==
X-Google-Smtp-Source: ABdhPJxc50JO0U0b2OqhkWFUgzomdM3kCS9KGK6DmZmd07AUzMFU/y3WSYgjohpGsS+Y32o+oZEbTA==
X-Received: by 2002:a17:90b:312:: with SMTP id ay18mr926198pjb.17.1604003315905;
        Thu, 29 Oct 2020 13:28:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w187sm3714289pfb.93.2020.10.29.13.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 13:28:35 -0700 (PDT)
Message-ID: <5f9b25f3.1c69fb81.fc942.8aaa@mx.google.com>
Date:   Thu, 29 Oct 2020 13:28:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-2-g0b3b9f46127e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 125 runs,
 3 regressions (v4.4.241-2-g0b3b9f46127e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 125 runs, 3 regressions (v4.4.241-2-g0b3b9f46=
127e)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | 1  =
        =

qemu_i386   | i386   | lab-baylibre  | gcc-8    | i386_defconfig      | 1  =
        =

qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-2-g0b3b9f46127e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-2-g0b3b9f46127e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b3b9f46127e8be6e2a1f33c37ef9ad362403f39 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9af2ecc9f10d5739381041

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-2=
-g0b3b9f46127e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-2=
-g0b3b9f46127e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9af2ecc9f10d5=
739381048
        failing since 0 day (last pass: v4.4.240-112-g4dcf57ce1d3e, first f=
ail: v4.4.240-112-g1a1bb4139b4c)
        2 lines =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_i386   | i386   | lab-baylibre  | gcc-8    | i386_defconfig      | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9af4c35cfd779359381019

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-2=
-g0b3b9f46127e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-2=
-g0b3b9f46127e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9af4c35cfd779359381=
01a
        new failure (last pass: v4.4.240-112-g1a1bb4139b4c) =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9af3c24c4a7af725381048

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-2=
-g0b3b9f46127e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-2=
-g0b3b9f46127e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9af3c24c4a7af725381=
049
        new failure (last pass: v4.4.240-112-g1a1bb4139b4c) =

 =20
