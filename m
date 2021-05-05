Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C413737488A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 21:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbhEETP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbhEETP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 15:15:56 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5C7C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 12:14:59 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ge1so1362164pjb.2
        for <stable@vger.kernel.org>; Wed, 05 May 2021 12:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ixyQdisIW16WhU2u9uuOHtjiW+CZ6qmBzXB+Aj1w0oM=;
        b=lAWMj949bu2x47nivVXzJd2or06vmlV2DolSgaPeeyHawI52httSY9nyCx1mAs4gEt
         HM27EEaCkWj1FgiBKX3i7dByuLBHuDAFLJna70YFueGIA6sc+53m9oAwe/CVFLx2HXOU
         XbFetTYvvcxewgUg80BG+QbLnkRo2hawpI8HZ/nGNDJ7BKhfp+izBDK9Icys2GOIfHR1
         oL2EeMbNR3jF1mBQ37hZ89TpghoZQRuqynLitpVe+m+cjknh/vXAFaOBMDnSDU9JOQ5K
         /V7msJNo/be5ioHX6EY3wwe8Z4LDYbGcvDA2wZHawAxkIj6Dquq/FBJnb1avf9O37nkx
         Z/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ixyQdisIW16WhU2u9uuOHtjiW+CZ6qmBzXB+Aj1w0oM=;
        b=uAINF6LyjU4jpzyylwnkPd6v14T/QXwSrsnrrqGYY9Jn/kcAX+SLuydePd4rXuKZP+
         Qa889RTWK4Z4O1IrFFS2+J/W2UliDhDfCpO6LAcS11CQbkMD4jd+XW6EPAGPWxpn6ymU
         mzTw2us2t1ssHc52xF2+cKiYgyFwGxsc8SpgQn9tqL+vRQ+ppqdwASCvUMQyLs5C3siJ
         uLO2vT0bzYYZrCsCKvwzW+VcKoGIU8lYa26DH57ZueRu1zcGpmAqVD7+NXXSNWV9uGZ4
         +9Qi7nGJe23FkQO15/BRCnfDe+0wHLmef9pf9Vg1qAueTMmSB9FlDyoaxBq+Oac0NP3X
         7B4A==
X-Gm-Message-State: AOAM531NXwCfGTUhaC40ZUcqEBBdpsuNxZ9ACd4XM2Tq/7hsLrUYGNIw
        V0FaSJ0MAM2a/33m34j5OkoVUDK7/R541BZP
X-Google-Smtp-Source: ABdhPJwshpolpajmVSpxTVHb8AdBGnEsZaLXRG3AORCNsUspgTc3M0kcfexjal3mCD+yf9ZpaYCQOQ==
X-Received: by 2002:a17:90a:a58f:: with SMTP id b15mr101981pjq.135.1620242098039;
        Wed, 05 May 2021 12:14:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s12sm7694056pji.5.2021.05.05.12.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 12:14:57 -0700 (PDT)
Message-ID: <6092eeb1.1c69fb81.8df70.175e@mx.google.com>
Date:   Wed, 05 May 2021 12:14:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-16-gdb80cec6360ca
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 64 runs,
 3 regressions (v4.14.232-16-gdb80cec6360ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 64 runs, 3 regressions (v4.14.232-16-gdb80ce=
c6360ca)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-16-gdb80cec6360ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-16-gdb80cec6360ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db80cec6360ca4a43d976cdb5752175cb4622c35 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092ba51d542ed4f736f547a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gdb80cec6360ca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gdb80cec6360ca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092ba51d542ed4f736f5=
47b
        failing since 172 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092ba72726afc53676f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gdb80cec6360ca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gdb80cec6360ca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092ba72726afc53676f5=
469
        failing since 172 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092ba846df1a22aeb6f547c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gdb80cec6360ca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-gdb80cec6360ca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092ba846df1a22aeb6f5=
47d
        failing since 172 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
