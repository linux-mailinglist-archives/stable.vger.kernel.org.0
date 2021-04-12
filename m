Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4C435CEE2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244502AbhDLQvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345285AbhDLQrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 12:47:03 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B760C061370
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 09:38:16 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y16so9548273pfc.5
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 09:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/B1oGD/pkAoTUsKBPeEAF3Zr3VJF0lcROqdxtVqGeig=;
        b=OfOwWiYrs9qz4amLPwPDI+VfSssOvXMKg7dPyQgarghydeRStXWsJH3C5ilkvj/Frd
         xjaX3cgw0n6VgYbGbnOpMdAKRwK1aa2uMCez9Z7Fit11980hSXJWCApgfyWnE28qYw7L
         DlK+ybH0iHFXUEliepxbt23/m1cTT0ZgRa3AEbUKuavV2cmGwWBdiXIez/J2Y8SFp/ix
         JIKaUIHWQ7H0XzaU3XHNFr5hSaaKDPOwCl/DgXl0YMf84xX7apDYspV7wtl9IKOsrqY2
         mk/RAEBeWQM1BGdjLDhVbqtGgFNB39ZZsPacxAp2Dmyq3bK5lTQGtdbsoJvUmopEsVbO
         fGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/B1oGD/pkAoTUsKBPeEAF3Zr3VJF0lcROqdxtVqGeig=;
        b=lmNCre8+6/nss6CaIKIcvvE3LZcE2eXCWWSO4wNSE6KdBJ0Jz3uo4V+3mSdB0fPfXw
         98+q4NcXtmCLl6QDQp78kCpJywURjqWDIcpcSjoLbGhpEDVd8L2SmUbl0TWiGsFz0bmc
         fjE2TiIQuJoxc4wYphWczPMXNWZXP3J5YFXMwkk4LNTunooCahyyp8FoJOPUs99XYU2q
         ostDCA6grET29XwqcSzowljo/gu81+3DIB5l196Iqx8QmbQ4JX7OmsIVqBw13FCfvAbg
         N3iKVflN+n6NamyZA16tkvDOmAII/xdK1IHPz8djCXq06CTRae8tNIETHOOHPdqpLvN9
         gZMw==
X-Gm-Message-State: AOAM532OGLeNdPKvGHfr45G5Rdxi6AL/Vo1G+1p9635mmleNAAyvApw+
        Jf6L9/VqkI8toYZQgZK/C+hmwEp+xop/RUM+
X-Google-Smtp-Source: ABdhPJzioCiSvhGO5gchzKK3P9ZtxBFEQio/MstFIMdH2j9WWKluG4nYlPc1NLVFITEFN6RTcxMvYA==
X-Received: by 2002:a63:f715:: with SMTP id x21mr27341449pgh.399.1618245495108;
        Mon, 12 Apr 2021 09:38:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm10628889pjx.8.2021.04.12.09.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 09:38:14 -0700 (PDT)
Message-ID: <60747776.1c69fb81.30ddd.8146@mx.google.com>
Date:   Mon, 12 Apr 2021 09:38:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-42-gdbb6abd454db9
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 4 regressions (v4.9.266-42-gdbb6abd454db9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 4 regressions (v4.9.266-42-gdbb6abd4=
54db9)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-42-gdbb6abd454db9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-42-gdbb6abd454db9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbb6abd454db9a04782db36dd06d5e96bfcf0d77 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6074441eb9302a89b7dac6b8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gdbb6abd454db9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gdbb6abd454db9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6074441eb9302a8=
9b7dac6bf
        failing since 0 day (last pass: v4.9.266-17-gbef36b8f37175, first f=
ail: v4.9.266-17-gb18de8247ff14)
        2 lines

    2021-04-12 12:59:06.656000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/129
    2021-04-12 12:59:06.665000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607442d33863db6adddac71a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gdbb6abd454db9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gdbb6abd454db9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607442d33863db6adddac=
71b
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607442a1cdb12f7e73dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gdbb6abd454db9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gdbb6abd454db9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607442a1cdb12f7e73dac=
6bb
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6074426b67c5641d2cdac6fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gdbb6abd454db9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
2-gdbb6abd454db9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074426b67c5641d2cdac=
6fb
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
