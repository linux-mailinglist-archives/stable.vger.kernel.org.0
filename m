Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4E29A03B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411895AbgJ0A2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:28:52 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:36121 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439496AbgJ0A2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 20:28:48 -0400
Received: by mail-pf1-f174.google.com with SMTP id w65so4325856pfd.3
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 17:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Uynv/3AjThomWUhJL9+I50m3MuvdgiyefijH2x0w+CU=;
        b=I1IpKrEZTR34U0lShM20FYfV+VOr5qX3fCOm6M8NPSCFp7j53OS8QKsHRYEQonC48v
         LlpzlcZJiFwZx2GV3UMUZl9OmeEvwGxrqmeXiSGpJiVlq/PZJlisNPlCYxbOOi5KzQ8C
         xZHXjD1v8VkOVOCCpWz53K5tvBb4Lm6mB/PMI8+rm3VBOneKlZwRQUANOeZhjEV6uZ8i
         5vCopsD0m6Ta9sxzvanjMwlLFUSWxHZQ/86F3V95l2oFuORq2ruJX4IJGyQl20TgxrAb
         fzclSVwGmw3NLypHwVgRU0bChNwMl+nIiJ8sy8pH5rY6Zt4bO/zzZ024SNubqTKVhj58
         +9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Uynv/3AjThomWUhJL9+I50m3MuvdgiyefijH2x0w+CU=;
        b=AEdXhlZc/QJ3vhd1PzEe0DDop7qIrb+V/3ogSZAkP1jhV9ywS4V3f2nA+RJu27y5LM
         Dv2nIl6kHTtnn6x32yrPvmhrsUz0mvXoK9b2H8kBfbT5HkfvFHKHuIV/0gS5tbl2d+d5
         VcdMXtLKSIHY7ftqGqVP+S/SxIIslvvHJlr7J8oHog1kVZgPrEAIX0fmf7y25ami0nTx
         X6Px+RvNlxIKgQgxGKXdNRIwpPxhb25edcz01B/yc0jzRkVaUBcn8et9rK3RlFaVeZXt
         oaHfEnLxAxOQLkw2BJ6sPzS2dVDQSyDquujpD3Im+XATMb2i+Bm/NboXwC191cdCrzso
         pGOg==
X-Gm-Message-State: AOAM530o885+CZzxLQflPhCp53uOgJI3wQOjNBNSJCjjUQbpbEHA3h4T
        O8+tOiFQBzaWFNQolK2j+La13eYNWOX7mQ==
X-Google-Smtp-Source: ABdhPJwRBCHwKZTSHmXw1awg5ouyEAWw86h7fVsrPNOv7jpM4z2g4eMfRU6rx0u+dMebI59lSgthiA==
X-Received: by 2002:a63:3111:: with SMTP id x17mr4211198pgx.329.1603758527704;
        Mon, 26 Oct 2020 17:28:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o10sm4899221pgp.16.2020.10.26.17.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 17:28:47 -0700 (PDT)
Message-ID: <5f9769bf.1c69fb81.8bf5a.bb92@mx.google.com>
Date:   Mon, 26 Oct 2020 17:28:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.240-136-gae4d5ec6fa02
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 126 runs,
 2 regressions (v4.9.240-136-gae4d5ec6fa02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 126 runs, 2 regressions (v4.9.240-136-gae4d5e=
c6fa02)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =

qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.240-136-gae4d5ec6fa02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.240-136-gae4d5ec6fa02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae4d5ec6fa022055391100d442730450856740fa =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f9736619cf108012d381042

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
36-gae4d5ec6fa02/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
36-gae4d5ec6fa02/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9736619cf1080=
12d381049
        new failure (last pass: v4.9.240-135-g36fe4866bfc7)
        2 lines =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f973748b73fbbd90c381016

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
36-gae4d5ec6fa02/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
36-gae4d5ec6fa02/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f973748b73fbbd90c381=
017
        new failure (last pass: v4.9.240-135-g36fe4866bfc7) =

 =20
