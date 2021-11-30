Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BFA463C75
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 18:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244573AbhK3RGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 12:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244585AbhK3RGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 12:06:37 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F384C061748
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 09:03:18 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u17so15408316plg.9
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 09:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ec13qjOQPv1cV9nvBZhlZ4pXHMIXtkGpxpqyj6z4Dhw=;
        b=Soa8TUYpWyU7g+KPgvLw2jDu0GYUotwvEML9eTVixRJHjdzhfj44ur46e7T0Ai1TOT
         5eSCBY1WLyay1yX+bvIifnChKqVMdhMcYf4wfKo96kq8hghKrOCkElim/6Ui4ehUUzag
         8mIhvpNJmlaCK/hXLJKSPXU7MZbhO4lxHhnVAQyutXNLnxTNG2XBokY1e+CcMB/2OeXC
         X7JN6Qr+8HeFr057+h1F2RPAtnI6+q+K2jpWo1gjyGX5qfV9Exq3/W1SEahB19IpGUDY
         b3VBzWt1PuqpEklMUCEvs5palVvveakybS2UBFxsTPBiCXKbO76oR3TRMgeihkRuR9rB
         D3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ec13qjOQPv1cV9nvBZhlZ4pXHMIXtkGpxpqyj6z4Dhw=;
        b=BVTwzfxSPj1d5MVo9RH6z/SkyiAV+uWeQlFf8FFkR8JbAvGw+Ds8rA1bR+T6rT5+P6
         eK+gfzu033POgXT6npt4J6r49r/QS4IMcfg+tXPuPpfaxtb5lKH9/zfgDjyJJxatQYSC
         82Or/rdjCWdpf1k/nbzsPxLZe+rUCyKiFKvq/Y3FvbnYep7n+ZN/007pCyuyuV2SyTRT
         3JGGSNN2YGmmxxg1TR84XSuDtNZ20Uo8L8FvxdP0qWmuKA3gf92BdYy86DCVAdO7bP+b
         fgsrmF42a8VrRBt8jC6KBglzxEQR+NNkxIdLyrffgmNDJr7brkMU2GZt3NCHMjGSIKfK
         5Uqg==
X-Gm-Message-State: AOAM530k6S3VCJb5hL2ti8e6GswZRcMt+ECf/zG13OINCXKLPLs6N4wj
        w0xb3okrr5HimH6rR4r3+LGCbqCnp0am5MZV
X-Google-Smtp-Source: ABdhPJybunqJEsG+Bd43xVwlVI87ecJKXMhYh4kA1jLhvuQLz30rHVkyx692c/hNO/+CxsHlZnyg/A==
X-Received: by 2002:a17:902:8505:b0:142:892d:918 with SMTP id bj5-20020a170902850500b00142892d0918mr252370plb.39.1638291797602;
        Tue, 30 Nov 2021 09:03:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm22226278pfk.22.2021.11.30.09.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:03:17 -0800 (PST)
Message-ID: <61a65955.1c69fb81.5c7a5.b75e@mx.google.com>
Date:   Tue, 30 Nov 2021 09:03:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-33-g845bf34b777ca
Subject: stable-rc/queue/4.4 baseline: 86 runs,
 2 regressions (v4.4.293-33-g845bf34b777ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 86 runs, 2 regressions (v4.4.293-33-g845bf34b=
777ca)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-33-g845bf34b777ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-33-g845bf34b777ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      845bf34b777ca77cda5d30dd12674edff09f04f2 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/61a626d1953929209a18f6e2

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
3-g845bf34b777ca/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
3-g845bf34b777ca/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61a626d195392920=
9a18f6e8
        new failure (last pass: v4.4.293-31-g052eaf60dbd3d)
        1 lines

    2021-11-30T13:27:30.033679  / #
    2021-11-30T13:27:30.034538   #
    2021-11-30T13:27:30.138397  / # #
    2021-11-30T13:27:30.139128  =

    2021-11-30T13:27:30.240629  / # #export SHELL=3D/bin/sh
    2021-11-30T13:27:30.241098  =

    2021-11-30T13:27:30.342455  / # export SHELL=3D/bin/sh. /lava-1169162/e=
nvironment
    2021-11-30T13:27:30.342954  =

    2021-11-30T13:27:30.444459  / # . /lava-1169162/environment/lava-116916=
2/bin/lava-test-runner /lava-1169162/0
    2021-11-30T13:27:30.445617   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a626d19539292=
09a18f6ea
        new failure (last pass: v4.4.293-31-g052eaf60dbd3d)
        29 lines

    2021-11-30T13:27:30.972318  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-30T13:27:30.978158  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8f2218)
    2021-11-30T13:27:30.982790  kern  :emerg : Stack: (0xcb8f3cf8 to 0xcb8f=
4000)
    2021-11-30T13:27:30.990702  kern  :emerg : 3ce0:                       =
                                bf02bdc4 60000013   =

 =20
