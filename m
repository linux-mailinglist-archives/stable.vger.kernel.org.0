Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105F22997E9
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 21:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgJZU0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 16:26:08 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:33320 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgJZU0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 16:26:07 -0400
Received: by mail-pf1-f172.google.com with SMTP id j18so6854495pfa.0
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 13:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AeJ9Zz5rDN99eqaf7u42h6nt8cSdXEW+QEwZOqBJ1RE=;
        b=rUnzFg3POl/VD87GDkUeSdGuyW164y1Hvor8gCmRoiv5UJ0HJPn1UvY8rnCgoZXrZ+
         aPEHb+dV/DQ7LzsjqEZ0hRy6eCfZCV0D0cRMcYde8tXYLQhsRyQS2mQ5kwKWPnDDAldZ
         1SjOSkDvAenC+ilVIdxBe9OsglHTeNjY10W0d4+0T1Pth5Qpilfi1MEBjq6S3qC0Expd
         oNz23K77NFqLZmUShGWdwDHf3Yac4bm8DMu5glVoI+IuoTR8AL1ACssHxA0SLkEWlaGr
         +LFbusqA65tCbSHSBNPs1Jf11kB0iRI49c9vawjJ7qIqBPt8xCJGvGHNZf9fi0XrNAGb
         r2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AeJ9Zz5rDN99eqaf7u42h6nt8cSdXEW+QEwZOqBJ1RE=;
        b=onmXxpazQhg9GDg/Dgwur6gMAg69QCCnsQPjDpmrgyCMvVFxHMh30sZ+asIBbCjS4g
         iV2k6V0XoKORLgK3Jlg4n5H8d9M6zJsZfEPHiJSjG9mGU6xcMjJRAVFUsf+418AMb/rM
         qInjz1Us5YbsHmipKOSU/k0QS7C+2BwlaPCV7Yf6kbHODWEUXDW0Nm6acCktguyWbvuk
         oA1CgfwP/cmGOPfYoqF1GoIXAaBU98CnmVAMlKgYayTSQO/AssnrrMCdW2vQzv3fOjlf
         31ZNissfU8AKgUkaLFndgir/tdSN/RILFOGArvMd+VmFkZFZ6iC9Jn3IwzfQPLx9bmv4
         knwQ==
X-Gm-Message-State: AOAM5307sAMOXLbGTnjYf9KdouVSKZZpwnZfGGTKWMYlob8lrYvWsFde
        e99YrmmoR84ymnhVGSsZPhWS1mhwt9PH6A==
X-Google-Smtp-Source: ABdhPJzGzwcjPerOsr+pwbyU2NG4dzrpiDmaTKWcMU4COg8726fg/898wjnroRFRdnEYTNdB6b90Jg==
X-Received: by 2002:a63:4f02:: with SMTP id d2mr18344205pgb.46.1603743964973;
        Mon, 26 Oct 2020 13:26:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm13246082pff.6.2020.10.26.13.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 13:26:04 -0700 (PDT)
Message-ID: <5f9730dc.1c69fb81.6a6fd.c642@mx.google.com>
Date:   Mon, 26 Oct 2020 13:26:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-402-g69786fedd1ab
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 3 regressions (v5.4.72-402-g69786fedd1ab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 3 regressions (v5.4.72-402-g69786fe=
dd1ab)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-402-g69786fedd1ab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-402-g69786fedd1ab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69786fedd1ab1b3a93dcac4cc9eff9c7b8ab02ee =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f96fca13cc20d436538107d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g69786fedd1ab/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g69786fedd1ab/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96fca13cc20d4365381=
07e
        failing since 2 days (last pass: v5.4.72-24-g088b4440ff14, first fa=
il: v5.4.72-54-g5ae53d8d80cb) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f96fac51b2e8d6714381028

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g69786fedd1ab/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g69786fedd1ab/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f96fac51b2e8d67=
1438102d
        failing since 0 day (last pass: v5.4.72-402-g22eb6f319bc6, first fa=
il: v5.4.72-402-ga4d1bb864783)
        1 lines

    2020-10-26 16:33:13.410000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-26 16:33:13.410000+00:00  (user:khilman) is already connected
    2020-10-26 16:33:31.189000+00:00  =00
    2020-10-26 16:33:31.189000+00:00  =

    2020-10-26 16:33:31.189000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-26 16:33:31.189000+00:00  =

    2020-10-26 16:33:31.189000+00:00  DRAM:  948 MiB
    2020-10-26 16:33:31.205000+00:00  RPI 3 Model B (0xa02082)
    2020-10-26 16:33:31.292000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-26 16:33:31.324000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (375 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f970039325472c76c38101e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g69786fedd1ab/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
2-g69786fedd1ab/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f970039325472c76c381=
01f
        failing since 0 day (last pass: v5.4.72-54-gc97bc0eb3ef2, first fai=
l: v5.4.72-402-g22eb6f319bc6) =

 =20
