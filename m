Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07032C2EB5
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 18:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390796AbgKXRf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 12:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390626AbgKXRf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 12:35:58 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7576DC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:35:58 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c66so19196055pfa.4
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 09:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=71SqN67vYpzuwokUCw3PcNm47cvN4SVhfHV4HG/M5LY=;
        b=MlLJLMAoyjz0t8L3IX73cyzBmqibJH0Ix6qTtCiUEgm8Womx6jpsNsVbsizldm9eWI
         pZZGVlcIWlD1yznZlQLdh4nd7+I2ljoRBtIWC1Sq9T+4q9UrHrcZMyrQwbV8XuMZvPrI
         GTGn64vjRSpuOc5TBp0Py7ZZRWKv8R1t7qoNMo3T7n+jyEWWzeD7G3ADXxq0h5q3GwJW
         GwRUZSHcePIPHAFsDWbY1FnDcjKOx4VTV/0ugzXX1DX8mTRem7pcOAr1JvfFinwc8CL0
         NiPK1Waiucrgb81zPR+O6Xo+14cab6uPHSMSlmFqGEJeCy7O6E9Jn4Sr9C/HEW4S6sVS
         vPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=71SqN67vYpzuwokUCw3PcNm47cvN4SVhfHV4HG/M5LY=;
        b=VlJTqa0ua0HD6Nvycm0FNbwryHjdCB7JRQAJ1+3IYnXSK5pWeYevgSOHRU2xDv5Wd6
         kg3hX7tH1FCTRhPNZ0N91nhG7+rTAhKPuyzuz15l1w/Ymi5Y5smOStYEhvidzRLZE1C3
         ZREcbdBHmZM629wpaNVN2qw6d1gcoZx6rqtxaZAjikvBJ/j/DypovolqQj4XLQNJaZwP
         uD+UQ/PwzbKkjqu2AESTvbuh+gi7kBhcbsOSIutED8Sxchk/aV0cdCswGugsptsC8zRu
         PhUJFeRkUJrg2rV1akBg4hLaXhwJ3GxHRQE3ev1cbg4FWiFiqAZ3/mfw8i2mEmysJtIf
         0Iog==
X-Gm-Message-State: AOAM533XPxNFbPREO9Gh/9rD+voooC/JtOarYeBxD+q/Yd5iBi2PDav7
        C2cNwcOfkmi6W4vAPv9sdVtQQdqAFgNwQw==
X-Google-Smtp-Source: ABdhPJw48YxRiriG3KMRE3erVjwwgnMcwXe7ZMvDRTUqGmtcOMV/UlMeeGHMkRt8Ad668lbtQ3eNsQ==
X-Received: by 2002:a63:1707:: with SMTP id x7mr4621085pgl.251.1606239357612;
        Tue, 24 Nov 2020 09:35:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11sm15455000pfk.52.2020.11.24.09.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 09:35:56 -0800 (PST)
Message-ID: <5fbd447c.1c69fb81.fce42.2ac5@mx.google.com>
Date:   Tue, 24 Nov 2020 09:35:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.245-47-gf28ecdbfbb66c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 6 regressions (v4.9.245-47-gf28ecdbfbb66c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 6 regressions (v4.9.245-47-gf28ecdb=
fbb66c)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.245-47-gf28ecdbfbb66c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.245-47-gf28ecdbfbb66c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f28ecdbfbb66c94b7a57350d4328a7535434a728 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd11dae6663fef80c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd11dae6663fef80c94=
cd0
        failing since 26 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd10731b16c9f1fbc94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd10731b16c9f1fbc94=
ce3
        failing since 10 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd108419f9c06f6cc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd108419f9c06f6cc94=
cba
        failing since 10 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd11c95aa6d64e05c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd11c95aa6d64e05c94=
ccf
        failing since 10 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd10239376ddcce4c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd10239376ddcce4c94=
ccb
        failing since 10 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
r8a7795-salvator-x    | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd0fecac8d2ac7cac94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-gf28ecdbfbb66c/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd0fecac8d2ac7cac94=
cc9
        failing since 6 days (last pass: v4.9.243-24-ga8ede488cf7a, first f=
ail: v4.9.243-77-g36ec779d6aa89) =

 =20
