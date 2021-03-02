Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D4432AEA6
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 03:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhCBX7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442323AbhCBCMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 21:12:24 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF50C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 18:08:53 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id r5so12786863pfh.13
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 18:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tIJhHElVhDLnO3tpRDPP73TcsgLG9SeLX20//iW9XQo=;
        b=Wz9DQ862WIZgMWbPgPA69/51LUoQR33pvGDUdEdx653CscDOqcO4pP17CcHXlJQWgE
         PviiB+4XDhVWmbYYXXkFusQtmtjQoEefVm50Rtkjrh+aNcvb5uzJSq2+DwB9tUtWRog2
         c1bFbUDa6nVuGaF1DsHsOeQuGiQirRFt4IHx7dLy8vXrwx3jzN8ukVuO32MesOU1sr4V
         9VsGPvbVgAXQTdizdyLunCcs0fli00J8V5kGCoBDaXsWQDCuUZaqfyuqfBkq7Um7A7df
         IK+ENN5jQ0UrKf5xuDzvJjtyKJUjcAiMH4HqU6TOgNCxyEiTUTxq/e1VXl544OSqj1jU
         9t+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tIJhHElVhDLnO3tpRDPP73TcsgLG9SeLX20//iW9XQo=;
        b=J/FKDxDtTL9MqsKBSt+oXPBNBh96gt/Jk8j4JjpYZW0pD6YKIF5ma0IO1kEPocNExo
         TTOCRLh9DFH8/R1ea9qrWuUigeYKQnySc94TSlsC38fZdGifLMLt1q39R/fXCN2WJfod
         2A2UywfQvKNgY7hGVRhYMLeEkjRHWHAGsr7HYu2FGvtoK7WSFZ/PvwbKNWbO3Ueidd/r
         /4EExfuXIYc5yuyROOUv5NChWyZ2dfku5xaTMbjOd0+uJY8uRIFxV4ciJks5NgyHvCA7
         k0An9WNRER2DGt1QZpjY1mtV+cNdTENHPJnBNAGfn7XlGrV7JGkv5X0ZI5Z9AOsBvFYK
         g4bA==
X-Gm-Message-State: AOAM531SdK0O8IlFWu18uPXY5SOJ6d1BkK9mqu4TIGWouFvxU8BWCTBG
        NH6h0D6ku2HyYYFeIb/8t5XgAP18mrxMVQ==
X-Google-Smtp-Source: ABdhPJy/2HZtRVL3PkzRmJOLhSr4lqKZe9IXLwaF3/WyMf6JElhtciqP3uCh+rz7oegfLHFO3yoTFw==
X-Received: by 2002:a65:68cb:: with SMTP id k11mr16850829pgt.128.1614650932569;
        Mon, 01 Mar 2021 18:08:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm736744pjl.55.2021.03.01.18.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:08:52 -0800 (PST)
Message-ID: <603d9e34.1c69fb81.315b7.29dc@mx.google.com>
Date:   Mon, 01 Mar 2021 18:08:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.258-93-gd82daa77183d9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 54 runs,
 7 regressions (v4.4.258-93-gd82daa77183d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 54 runs, 7 regressions (v4.4.258-93-gd82daa77=
183d9)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
panda               | arm  | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.258-93-gd82daa77183d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.258-93-gd82daa77183d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d82daa77183d98ed8ab0601324aa50523fc3a984 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
panda               | arm  | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/603d6d257a518a596faddcbf

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603d6d257a518a5=
96faddcc4
        failing since 0 day (last pass: v4.4.258-8-gd58c8b6f6cef, first fai=
l: v4.4.258-61-g381f23792ef7b)
        2 lines

    2021-03-01 22:39:29.644000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/112
    2021-03-01 22:39:29.653000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/603d72e7730f97c618addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603d72e7730f97c618add=
cbc
        failing since 108 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/603d7138cadacf7abdaddce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603d7138cadacf7abdadd=
ce7
        failing since 108 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/603d6d5640065b34ddaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603d6d5640065b34ddadd=
cb2
        failing since 108 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/603d726bd0e6a9656baddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603d726bd0e6a9656badd=
cb3
        failing since 108 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/603d7064e02b8c2a40addcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603d7064e02b8c2a40add=
cc5
        failing since 108 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/603d6d586570e071f9addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-9=
3-gd82daa77183d9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603d6d586570e071f9add=
cb2
        failing since 108 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
