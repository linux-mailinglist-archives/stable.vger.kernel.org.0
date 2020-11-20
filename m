Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9132BAA6E
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 13:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgKTMr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 07:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbgKTMrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 07:47:55 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97630C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:47:55 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id t37so7126253pga.7
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 04:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Us2+03iDViy6QSi9S3+m2Rhpa+EpgoPcqZW/sEJFrXI=;
        b=zBUjm5AT94ZJC1v5scsSYuUsQOYsBCK6R27wvL6SZyJg/zmloNW94JLPcfyP99h5IJ
         8brSAoGMLR9xU9KYY0B9cuGc+EhLcXtVwUosRcaMbXBv6U8Y41quFCmz4EIoi1+I9H7J
         BqzoxNbXAlS2W0JYIS5S6UuQAWtNnxRQSSWJmuq6wNNjd41twsVYwYUu64csLZyvoUkc
         M74COFmtQvWd54w2o1DoAmbhhiehHLo6mT04vxsWpjD9jO1CZxTf3cIiHws0g/2lBxkZ
         mRXFP/HxpD9oFpYyrir2Z7mt8oPDemxHcS+7uETKpADEOdYVxrMnrxQZVc8rrju9Spvs
         6mpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Us2+03iDViy6QSi9S3+m2Rhpa+EpgoPcqZW/sEJFrXI=;
        b=rUM2Q7ry04fo2yVMQv8rHEzSSw0PiKUSnJYRB/pqabb9/ZmS1yUZQkmOfy2/93KXqA
         TQmy7+6qQfslID7MBFalQCn+hz0iRFk2OaEH1zDRGJfbM4wq0c66QmnFUswXHgNLakxq
         HZLBtk9T1Hh3ypu7jB/1o2wS+39uQq6Nx7zxhEKHtPhDP8WQZK5DWMJIl3qEpxaPG+f7
         tsxMAhMM00GTY3ypHxS2tu8z5l6xR6/sk5mqpNO3nidtNlJD/526ipjRVkgVGgprN6MZ
         YuAHxS9mMOUOBvtFJi9jg2K4uNDUOGCBzMGJHfASYonom3tCvC9YZFRqkxUyB76rDpiq
         ySIQ==
X-Gm-Message-State: AOAM532d4qbrHirtlYb0iNBp/JkN2QYQm6qOHxudapMQff8T9APVSRx5
        RXf2xmg9U6uSktJd8JnMFj3VgF379/HPzQ==
X-Google-Smtp-Source: ABdhPJwa0/DtPQ4SFjXM2oc8/AlMJ+HorYMARGUUIIpgDb4UYyyMB1qcSyq8TL9PwXR23P4fUUbTMA==
X-Received: by 2002:a17:90a:8a:: with SMTP id a10mr9713634pja.39.1605876474822;
        Fri, 20 Nov 2020 04:47:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9sm3981362pjh.9.2020.11.20.04.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 04:47:54 -0800 (PST)
Message-ID: <5fb7bafa.1c69fb81.82565.7c42@mx.google.com>
Date:   Fri, 20 Nov 2020 04:47:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.78-5-g843222460ebea
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 172 runs,
 5 regressions (v5.4.78-5-g843222460ebea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 172 runs, 5 regressions (v5.4.78-5-g843222460=
ebea)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.78-5-g843222460ebea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.78-5-g843222460ebea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      843222460ebea2330d80114e4ddc05c71c08a5cb =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb786c3c8013a801dd8d90a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb786c3c8013a801dd8d=
90b
        failing since 22 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb786b91665890250d8d918

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb786b91665890250d8d=
919
        failing since 6 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb786f0d00590ca4ed8d95c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb786f0d00590ca4ed8d=
95d
        failing since 6 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb786ce4087286778d8d990

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb786ce4087286778d8d=
991
        failing since 6 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
stm32mp157c-dk2       | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb789a802b03d5eb1d8d8fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-5-=
g843222460ebea/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb789a802b03d5eb1d8d=
8ff
        failing since 25 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first f=
ail: v5.4.72-402-g22eb6f319bc6) =

 =20
