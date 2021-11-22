Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0978C4597DA
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 23:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhKVWvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 17:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhKVWvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 17:51:54 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3A3C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 14:48:47 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so479032pju.3
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 14:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mbZvtAoXUXOuc2ozg6LJLjsMxDHnzIGD1MrL3Xo3hks=;
        b=tlhqPuKbxaHB8xe1Va16bMxKrhGi+i9DTDInmrVw96J3gRMCfdknMbkAALyM3OoutR
         x8sImPDuywbogslfMLQZ3coB8uu7/QF9CscnrZoZbF+UgxGdMIL3nhU5AEtJg3naFXmz
         eWu52W7nszM9dSU9R5/QRIBncyhWfdvh1JDUxI7a5573zdO/AZpB/WWWfGIW8gxhhM4M
         /dShev+kQ/1Ot3/7kW+jOvnrx4WO06GPCEBW+wLrbp5oC3U6wiku3gBDya65iWSL3qda
         ubq0M5NwG795zq0CIsCbKhrZkw0mOpDMAwHX8xM9FqcBL8kK5dzIJSxcsWwNVe8skaCq
         dMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mbZvtAoXUXOuc2ozg6LJLjsMxDHnzIGD1MrL3Xo3hks=;
        b=yKUOJ/7yXptP65hkvHpkPn74pvQT5r2vJro5OQ/fCxdmsu8SqpX1s+MIvEGBDftO9r
         GqMb2IRB0HxUW6Cz8V7qnmRDUMzC3wSbY+t3TjR+7CP9e9HUO3HSiN0Ych3AH6lNl439
         H/5O7w7AyJ/ZaEuWY8AtM4xPKaAE+HjlkZjsk5Wic6HjjPy1MaVP1wgJAkV/jK+PCfPP
         UK7dpKvG8tjgunhHE0bubfmOXFkBxH8G5QL8R35OzFhBhkrjFcd5wzS7frSleaa/naou
         Stcm+hiGnbeQ8kb51XBtr80ASM7XDnDlouVKlJ5XmsoPj3jBw1F7bVBerYqV5VwehIhv
         KSqQ==
X-Gm-Message-State: AOAM531nf7y9XziyKCmIR+Flm77CiflIAC4xvepB7EgxmvEV6nQlnIiX
        O9qugYfy1ZdNWIvgmLkVpm/CucFwZzaWmxK3
X-Google-Smtp-Source: ABdhPJyEZk968+wBSRhIAl5QgSDVQLMqMsgBemM6vB6Cipcq5PpUghP5JUWtg7yhEc1ZaJmY9fU4lA==
X-Received: by 2002:a17:90b:314d:: with SMTP id ip13mr512823pjb.228.1637621326740;
        Mon, 22 Nov 2021 14:48:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1sm7096522pfe.158.2021.11.22.14.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:48:46 -0800 (PST)
Message-ID: <619c1e4e.1c69fb81.74716.532a@mx.google.com>
Date:   Mon, 22 Nov 2021 14:48:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-236-g8c7335c4b8de
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 100 runs,
 1 regressions (v4.14.255-236-g8c7335c4b8de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 100 runs, 1 regressions (v4.14.255-236-g8c73=
35c4b8de)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-236-g8c7335c4b8de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-236-g8c7335c4b8de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c7335c4b8de3b6a097d4df06d18721f25e3f2fa =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619be3e22ed85fd634f2efb0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-236-g8c7335c4b8de/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-236-g8c7335c4b8de/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619be3e22ed85fd=
634f2efb3
        failing since 3 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-22T18:39:09.320840  [   19.961120] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T18:39:09.362595  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-11-22T18:39:09.371387  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
