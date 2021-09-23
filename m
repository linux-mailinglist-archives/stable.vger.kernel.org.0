Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576B1416547
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 20:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242708AbhIWSjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 14:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242626AbhIWSjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 14:39:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B73BC061756
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 11:37:51 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y1so4568039plk.10
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 11:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9PDZRQmtbMrD075USyJodxdTcKeH/p1ORbh3u79NPFA=;
        b=6+eSD5YqCJJcFR3Rl/fEjTHTUKleqz6eNHMz65RBacDLAojuE+rK3VnfdQi7wXCZ9h
         Ws/QVBT0hkuCnQUulEe8AWDgD0ePcoc1iZAmFA2qlzhYOg9hlQTvrlgAfzUaelsvwYtl
         K8XDtZmAfigHMxjT1v+BZ5oMNVhRCZVssaeN15w6OYG47wobo34eV+4hPrWvTxhmdEmr
         /1TpXbmgRgpzMT6NGXFQTsYUAYMD0cbVVI9dxTocOYjWhGfTRANALqfEDHLSe2oY1ZCi
         +n/YCvMrk1Gu25n/jZHsrsaJNnc9stW/f8OszWxyq8E6rEtzB3JMdz6IWuAhZZ0WFlGs
         kCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9PDZRQmtbMrD075USyJodxdTcKeH/p1ORbh3u79NPFA=;
        b=vJ1T4g6N5JYgy8h0DLPKtCRiIoRUljyqiOZ7nE6HXCSxh/GI0LilXTZWpEk4Hc0dWe
         rWUObmi3XL+eJQqovh3/Lp4LaLZGMLEH3mcmswB2zgDh7mpizdGet5k6aHKAOFo9Pexk
         AxwLVSH/rlD/S1j1V7p8NI8Z0W/ufAD0Xv/lpCLVF3jnSH12oyO+rYvLOfOZPKs0KYLA
         kEBvPMOCcrSqZnxX7mqUdpGUt9T/ooWFnFZ0bBArrHCw/49b+KsAGNedOuJQvRRtAOt7
         I520OOVoP55UuUbAMXe43fkQso/2BaiHlVrYk82Fn7hgW08PFEeb178zshvQM1o/s6Ca
         8AvA==
X-Gm-Message-State: AOAM532wtsWIjMWTOOCBCCgpAEJIXpLEMpiy0GJ5U2q2Kl+gsKkbr38O
        d1bGbvTW7Tth5UHmcosRjH94A02PcENTE4TS
X-Google-Smtp-Source: ABdhPJwMTzGevAWSYxfVjI1GH1FrGFmrgjlTwJ+vO0ImKC0aX2bfYwZXIYtdYHnLatk1T4DYuG4csg==
X-Received: by 2002:a17:90a:62ca:: with SMTP id k10mr7013784pjs.38.1632422265434;
        Thu, 23 Sep 2021 11:37:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 22sm6744176pgn.88.2021.09.23.11.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 11:37:45 -0700 (PDT)
Message-ID: <614cc979.1c69fb81.ffbe5.4638@mx.google.com>
Date:   Thu, 23 Sep 2021 11:37:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-7-gae42816493bb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 97 runs,
 3 regressions (v4.9.283-7-gae42816493bb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 97 runs, 3 regressions (v4.9.283-7-gae4281649=
3bb)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.283-7-gae42816493bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.283-7-gae42816493bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae42816493bb12d145ff8cdb0497160171d7168a =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614c907cfee820b81899a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-7=
-gae42816493bb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-7=
-gae42816493bb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c907cfee820b81899a=
2f7
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614cc5b4291a6d1a6e99a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-7=
-gae42816493bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-7=
-gae42816493bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614cc5b4291a6d1a6e99a=
2dd
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614c9083b53067f9c599a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-7=
-gae42816493bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-7=
-gae42816493bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c9083b53067f9c599a=
2ff
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
