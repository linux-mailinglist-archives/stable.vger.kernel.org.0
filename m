Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DDA4932A5
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 02:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350823AbiASB5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 20:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343660AbiASB5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 20:57:32 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3D7C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 17:57:32 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so1139065pjp.0
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 17:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hA6FG+38HKYUwK5UMqr0iBtGi56UoiK3BQDPS2Ax2zY=;
        b=t67hgFjG4nM6Y5PIuspejmqf1h+890dSRL2lVTJQvwME9u/otlYov4jIq4xL5EMj0K
         hI1vx/Ra6rtI31wfZr0ZjQNPu4H/Cd4XZVAiZaapMShV2pjcaEihic7I2+Bj0ciO5WPb
         Y293+S6USwygp6Y5PUJvBBolONhpgds7lzsQGFg8NpB55HjAnqfMjMe2/LUO/GDBUsxw
         HunKcER0zpqlPXNI62D/+AFLEDKV49ZG2oaHY34M7UNWrTcM73iTG5nEoOPiMpxWrAUD
         JAVJWBWzxt7yRvZHSsuZwDS5jXLQNSCZkPtV2sAfAJWIqo06wp8yyvoj91W6GVe1e81y
         K6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hA6FG+38HKYUwK5UMqr0iBtGi56UoiK3BQDPS2Ax2zY=;
        b=XhwmVY2JzHIwcQ3MOliKJhARMIxGIvvX7dGQdm02tpPMvPMZAUyrrmur4r67do8sv3
         0Twgw+c5b7NKX9q0iHHFiZzowXv+C1FRit1Zp1wUvhHVms4fkkgD4TXpo+vSY7HchyeN
         GIGMcK1qecSbpXc+49KpBJ74o8D5sYsYFvD+a2ZXzJTqBE6YtJegToEpLQZGg0kblMY1
         ifBUSJ9nE6dWIaij13XEXy23ZpstILLJhR1JhbNUK3FYUEbhXwJvavQdpLvn8JjwUUbT
         g6bQAt9PpRJpp9zN54bO5C0Gnzbm6e42zMzg1kfrGEqfB8vmgLF05oA5Xku4b/EkNxrX
         j+9w==
X-Gm-Message-State: AOAM532k4noKWbqzlmDIvlI1/iMwa2j2bz/XgSiUfBaccNLWyKadTLJf
        NbG5u5onl760llR8C+/J2T5abYSEUEb13bbK
X-Google-Smtp-Source: ABdhPJz7n7echo+DAJAarn+XJ5npK8jx8sLOro3yu3L04ZR2n8lXT71g4snda+olWaDnUWNDpcJWkA==
X-Received: by 2002:a17:90b:4f49:: with SMTP id pj9mr1596233pjb.187.1642557451474;
        Tue, 18 Jan 2022 17:57:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq15sm4489693pjb.24.2022.01.18.17.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 17:57:30 -0800 (PST)
Message-ID: <61e7700a.1c69fb81.1e3f6.c94c@mx.google.com>
Date:   Tue, 18 Jan 2022 17:57:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-14-g9d1769c0487b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 122 runs,
 1 regressions (v4.14.262-14-g9d1769c0487b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 122 runs, 1 regressions (v4.14.262-14-g9d1=
769c0487b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.262-14-g9d1769c0487b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.262-14-g9d1769c0487b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d1769c0487b2c68f26bda420d33c9e4c9303e8e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e73e1e89ff91f583abbd11

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-14-g9d1769c0487b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-14-g9d1769c0487b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e73e1e89ff91f=
583abbd17
        failing since 4 days (last pass: v4.14.262, first fail: v4.14.262-9=
-gcd595a3cc321)
        2 lines

    2022-01-18T22:24:13.980961  [   20.757812] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-18T22:24:14.030310  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2022-01-18T22:24:14.039552  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
