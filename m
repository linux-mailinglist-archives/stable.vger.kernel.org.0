Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2697947D43C
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 16:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbhLVP1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 10:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbhLVP1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 10:27:43 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CDEC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 07:27:43 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id co15so2608041pjb.2
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 07:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aMdGSgBwl72leNTNRwzVq/p1uU0DUmULW06f8QJ0Hmc=;
        b=m7s654KwlsNkMLdc0lYNh0sSuph/Sdxp++V9bMpxysd0GkeOZPZu6XTzzoDRGKpUaP
         WgHz+g4OCfuyqhwVb8S9IfUWEyuxTzyhvXEhGoQU9BFZ0E0as5NiJijXsKEPi1803fVd
         UrvsixQCAOxp/0DgiPCtNzByaHMjGIPcSxCXBx4YNWuU3oC4juzIAI9/zBHtQh8yksER
         7ZMvuzKBI8OWxkodD1KNJwmjdgfrJYqOHowp91y5mecgPhINIDIDZ678JGmcWzybs/Bt
         JRd838cSY0XaVAo/3Zgd1K6FKfA1CaGOIRqj1niQ1O9lsd7o5n4yuDKxxoARwl+fMwpW
         WD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aMdGSgBwl72leNTNRwzVq/p1uU0DUmULW06f8QJ0Hmc=;
        b=riX6tM/cIN3rgKIh94L0+HcI1Bd+5Dhf3HUZPpqM6zKk//lVds9g53Nr3U0g/VYJdh
         3fP3teT/f2u0Y6LJuJfxsDhJ1yNTGl5Mx1B/VMMY06vX98MKrEqKAHqx2BigMLzqyxUD
         OUaLoo1JvFSlpqfOpx8MdnQCVfTuaAZhE2cUN9HZOOFQBX29TDPBXjF6gc3jUKmoKCcd
         62To08Dx7bDNPydEHcYhFy++3swe7q4xpV2BljfkBuMeqy5yFKBUuhVjJjuyz/HYpVXq
         7XBmK85/aqBmdh6A4HJGp4XkkwGrODd56WH3SJrvFCW03qbghReIof37ueotvi43vt+3
         NvJw==
X-Gm-Message-State: AOAM533NLFIb98e8I9HKwsawhxVnebXY4QK5sxZqxIb3gL9pspm89l6Q
        K5jEunsUunIr17vknhZ3rLzr8Pmj7RMaDlil
X-Google-Smtp-Source: ABdhPJyJige6ejVjfwwIjU44xF7DuLn0DetMls3shRO+z4w9RNcU2E5ERmiwjDNLqnj/arQu8tiC4g==
X-Received: by 2002:a17:902:e5c3:b0:148:f91d:2611 with SMTP id u3-20020a170902e5c300b00148f91d2611mr3205317plf.91.1640186862941;
        Wed, 22 Dec 2021 07:27:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4sm3391150pfj.61.2021.12.22.07.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 07:27:42 -0800 (PST)
Message-ID: <61c343ee.1c69fb81.a115a.8693@mx.google.com>
Date:   Wed, 22 Dec 2021 07:27:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-55-g2f4642b7ff18
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 187 runs,
 2 regressions (v4.19.221-55-g2f4642b7ff18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 187 runs, 2 regressions (v4.19.221-55-g2f464=
2b7ff18)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-55-g2f4642b7ff18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-55-g2f4642b7ff18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f4642b7ff183bf1c2af12d2a55a4fdea7b442f6 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61c30a74b01d7cae4139712f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-55-g2f4642b7ff18/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-55-g2f4642b7ff18/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c30a74b01d7cae41397=
130
        new failure (last pass: v4.19.221-56-g9f6406625bbb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c309eb3f6c98fbae397130

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-55-g2f4642b7ff18/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-55-g2f4642b7ff18/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c309eb3f6c98f=
bae397133
        failing since 5 days (last pass: v4.19.221-9-ge98226372348, first f=
ail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-22T11:19:56.554272  <8>[   21.297607] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-22T11:19:56.601280  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2021-12-22T11:19:56.610783  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
