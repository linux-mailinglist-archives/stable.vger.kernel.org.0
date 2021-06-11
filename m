Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC953A434E
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 15:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhFKNvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 09:51:52 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:39670 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhFKNvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 09:51:50 -0400
Received: by mail-pf1-f170.google.com with SMTP id k15so4510744pfp.6
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 06:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qFjjPDO5MhAfiSssn69nZqrdveGn82dI4vlSGjYzMu4=;
        b=vdypxuS0aUuaBl4uWJA1J7BfNqlYTqWt/h70PwxGkVD8rTvPrv3UhA72rFUeuuOv1U
         Frqd52kVljIl2O+K/Xy9RNIjwJ6VRM5dFMXVGWyepn5udxz+msMCvE+yQH9p31CBdExF
         ESkwigP31StBIhdwqQKzBIRk7au6jyCd5/+OF710YMe5sG2cLPzrRUZxHKu8pt1BnJak
         Hc6pF7dlB1xqYlx6QmGXDl+YqYX4BgORA6v9f4bRpX2m+mXr11JVW0SWxopRe7/TKolU
         z/zsNs/cXywK6hVfiXyM5bxa+ro5bxBlmTSBeij4tNV++tDd5QuffD9T3hgEwmyPqcZV
         fHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qFjjPDO5MhAfiSssn69nZqrdveGn82dI4vlSGjYzMu4=;
        b=MJ6IiRcIax9UDtoSF8AXUwfxbN4v7e01X52u9YpENWVr+p4kUJSH29XuMDFTxNsXZi
         kYPh3pOl5fhDk9ha+9/mTSDSpGhDo8m5+3/caTAbJbpdDyV40VnAqSCcze93NReTC6G5
         BU7kLFCKCnFKz07Upj76ViE/WAzgdB4VbiO6PHbVYn2R8ailqcnbQK4+8yqwGX2oR1be
         HgHvB9ZoRXBvJy7gU4GjUgsNTTIm+F1QozLbbbelIoK0VT1jgfAbWoVvTXEkvLvqQR2Q
         84UI8d7ZpLKq/UfUneuaOEs9GYI1OF7B+CjT3ARjlg7REmBtudCElMMDJrCZM8bNgVbW
         ip6w==
X-Gm-Message-State: AOAM532JeY3AvB4DzMwD2WcyVcvX2vSF6KhWMQ2icT7+kxspk9WlaViv
        cm+RRpcYmQsaRSBAO0TrfuKscSv0s3MovaV/
X-Google-Smtp-Source: ABdhPJw53SBVgAL+QBqfnoBnpbuz/rQvp4dMTWPmjOwXkg2kxK4l7AllVVBefiV6tMA900oITRznnw==
X-Received: by 2002:a62:800d:0:b029:2f0:fe27:2935 with SMTP id j13-20020a62800d0000b02902f0fe272935mr8482412pfd.15.1623419332664;
        Fri, 11 Jun 2021 06:48:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i128sm5123469pfc.142.2021.06.11.06.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 06:48:52 -0700 (PDT)
Message-ID: <60c369c4.1c69fb81.e0735.e398@mx.google.com>
Date:   Fri, 11 Jun 2021 06:48:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.272-20-g957131fccff8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 138 runs,
 5 regressions (v4.9.272-20-g957131fccff8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 138 runs, 5 regressions (v4.9.272-20-g957131f=
ccff8)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.272-20-g957131fccff8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.272-20-g957131fccff8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      957131fccff889add770891788f32d0d34071fdd =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c336db260e9c98940c0e28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c336db260e9c98940c0=
e29
        failing since 209 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c3373e89f74a6c170c0dfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c3373e89f74a6c170c0=
dfe
        failing since 209 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c33715409cc609550c0e1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c33715409cc609550c0=
e1d
        failing since 209 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c341d93bce272ce60c0e44

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c341d93bce272ce60c0=
e45
        failing since 209 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c35f49de4b10d6420c0e31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-g957131fccff8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c35f49de4b10d6420c0=
e32
        failing since 209 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
