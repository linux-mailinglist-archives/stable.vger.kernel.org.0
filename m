Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A30A33CB3E
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 03:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhCPCGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 22:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhCPCGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 22:06:08 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64DAC06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 19:06:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b23so7777584pfo.8
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 19:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6V+a8kq8JUaWyJ89OobIjPw0B/2Uq/B5nqInbsvyYRs=;
        b=eL4urc4HHi6uA/hTpNPBepiZ8CII8NMKO9iBLOKM8XcWTP7VVj9JBBszi67TP5MyOO
         TWS81fNQmDRxYtfYONRMUitjNR9KcjaXuGBQgR4EBmiSrlTjpjaciovCcEILtGQ/LEV9
         ZK03wmB32L5fslzizOLEv0/S72N4D6stCMRA3AuppRxGBUJYTaDHU5IlAhTxOVCTa5Eo
         uklxOzdde8p8nuikvJv/0Dmky70dJjbEoKrFUWc2dDnny0lp7KqImHLZUprXdLufPKhG
         uMXRyp88AgPXv7UH6nYkQe3gFdtnwkk4kpJkKv7T5FlC4erkmVJer5h3zM+UdXfDCrxu
         XzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6V+a8kq8JUaWyJ89OobIjPw0B/2Uq/B5nqInbsvyYRs=;
        b=C7NxKEvTpLyLM1wGLdzblyXwMuc976B0lff3UQg0QhOPEudF7FyYZ9qECmAhfYzgKH
         IhDqmqAbMjWLDIhKm3jFKLTnhJfIAp+cHWVKMp7u2RoQ5Q9q4/sF2rt+BcIuZKORiANl
         mFt/RI0nOQE+fp7AkrkQNpFLqIcnUY/AtfjH3ZvKsySvFE02v/qKcweT/VHKWnlRhIyH
         t4/gn5MRQ2D/dYehL+sGMxx6GTdjFrd+BsIb5Tz2AhcVbx50JKJes9fWvlQmr7w5afBy
         k09Dgbw8wJhy+PU7Bg7RqsnYoKDc30eh7386RevN/b6wRnXVVsE4bHPeyyGsI7ETdTwy
         K62w==
X-Gm-Message-State: AOAM5310Kz5+3zQ2LjyPYX4R96eGwDn/oCb+nfoWr8ZjD09QBStLih6Q
        eJNLIHjLaNsah0Oc0igD2CFveO+nDoVsKQ==
X-Google-Smtp-Source: ABdhPJxhyuCvgd/oMYhWuouDI7fAMD9hcAbbdxDFKfj+Y7599N2hYfHt2giRkMk/bcqF4MSbdzGTrw==
X-Received: by 2002:a62:2a4c:0:b029:1ee:1854:1f22 with SMTP id q73-20020a622a4c0000b02901ee18541f22mr12625479pfq.25.1615860366515;
        Mon, 15 Mar 2021 19:06:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o13sm14827746pfp.26.2021.03.15.19.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 19:06:06 -0700 (PDT)
Message-ID: <6050128e.1c69fb81.22f9f.5553@mx.google.com>
Date:   Mon, 15 Mar 2021 19:06:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261-77-g10f6eedd1e21
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 106 runs,
 5 regressions (v4.9.261-77-g10f6eedd1e21)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 106 runs, 5 regressions (v4.9.261-77-g10f6eed=
d1e21)

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

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.261-77-g10f6eedd1e21/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.261-77-g10f6eedd1e21
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10f6eedd1e216e5fde5e6dfab18e6deb477a7941 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604fe11583a8732991addcb1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604fe11583a8732=
991addcb6
        failing since 0 day (last pass: v4.9.261-64-gad97aba1f3798, first f=
ail: v4.9.261-72-g9a97181c50fb8)
        2 lines

    2021-03-15 22:34:57.590000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-15 22:34:57.603000+00:00  [   20.667053] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 e6:0b:02:1f:0d:68
    2021-03-15 22:34:57.609000+00:00  [   20.680389] usbcore: registered ne=
w interface driver smsc95xx
    2021-03-15 22:34:57.633000+00:00  [   20.700408] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604fddb1dcf4f77692addce9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604fddb1dcf4f77692add=
cea
        failing since 121 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604fddc7899fbeb6d8addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604fddc7899fbeb6d8add=
cd2
        failing since 121 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604fde8259045c872baddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604fde8259045c872badd=
cb2
        failing since 121 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604fdd5706e2304034addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-7=
7-g10f6eedd1e21/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604fdd5706e2304034add=
cc8
        failing since 121 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
