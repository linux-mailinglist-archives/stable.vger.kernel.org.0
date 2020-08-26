Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDD825331C
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHZPMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 11:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgHZPMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 11:12:39 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCEAC061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 08:12:39 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x143so1144170pfc.4
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 08:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=897PdjDMocdd2SoADGcqePpQI1CRTcxzWAe9vM7Ay2I=;
        b=KqxWlonNZeycg5EsbxOfcWIqcwWxYeuhPaaxrsKsncqsqTgO7LN0H2JAsvaaQZqTKT
         7O2Ibz6b6tOZlu/+Q+++y2fMYZd2KGUqDeTmmxSyKm/b30ib2635KFcl3vvOeVaHa7bC
         WEfZwTI4ew4JY7Cw8ertgRHjVBEYUNxibkTImwGZlTdlKaszgL/MsQjBaitQLW4u+sZ+
         0ASda5ScYF1Btsbg9MzzixAwR3hcSq7BtmmTwbJp2UWTB34Q6H9PBGxzFNTaluCG+ee8
         RR4kChYIwaNOIVc54uVLovuIUYkGD8rCDfF6B2bhdbKl9/2CMEkxaJ8BvOvqKlFbXwOf
         BJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=897PdjDMocdd2SoADGcqePpQI1CRTcxzWAe9vM7Ay2I=;
        b=XMK0Ejn1a+ftIvfkBibO0wy7e+hRq/UqSo+1OFARjpyxZLVEJgJ+xyORnro5vKV9kr
         IwnCgiX669fXMFnoMIS0iIGenCzt2415Ktb7S/d2V64PeHWqN7Rm3Fs0SLT6Ki8KXlhE
         y+nZGdk7cuXJ7g5kfde208ORXWddshSd8/CaOZshD9j9WGEHwnw/TXIb/0RPQgifYy6Q
         T3DAOc6Vd3iBY6SsYMPyy9sCjjZ+VQz3kQ/h3TuYMs5rhxYz+Ej8BuLMo/oMaN0AbDrB
         G1CjHa+rPvptQGn6CJkidMuEXEWEf/+/bAD15HCO6M/SZk9x3fehch6ujFcZ7epyrFE0
         Sv6w==
X-Gm-Message-State: AOAM531XAAAxcPvVps1NtbfcKv+q4UlWbcyvAFchJaYQ1O3oIuhnGIcD
        sfsSlcYF79IYclXHY3xh1nNUhh1WvIixIQ==
X-Google-Smtp-Source: ABdhPJzNN4U+lJVusFpLZCUFtIdxLnPaHl77d0szmRxrqvXHZblTQh4/SEr0yc/Zaw6RByTTq4mH6Q==
X-Received: by 2002:a63:651:: with SMTP id 78mr11271418pgg.344.1598454758196;
        Wed, 26 Aug 2020 08:12:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k88sm2646253pjk.19.2020.08.26.08.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 08:12:37 -0700 (PDT)
Message-ID: <5f467be5.1c69fb81.4cc7c.5941@mx.google.com>
Date:   Wed, 26 Aug 2020 08:12:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.142
Subject: stable/linux-4.19.y baseline: 175 runs, 2 regressions (v4.19.142)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 175 runs, 2 regressions (v4.19.142)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 3/4    =

hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.142/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.142
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f6d5cb9e2c06f7d583dd9f4f7cca21d13d78c32a =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f4647a791035b0e019fb435

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.142/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.142/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f4647a791035b0e=
019fb439
      new failure (last pass: v4.19.141)
      1 lines

    2020-08-26 11:27:41.262000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-08-26 11:27:41.262000  (user:khilman) is already connected
    2020-08-26 11:27:57.429000  =00
    2020-08-26 11:27:57.429000  =

    2020-08-26 11:27:57.430000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-08-26 11:27:57.430000  =

    2020-08-26 11:27:57.431000  DRAM:  948 MiB
    2020-08-26 11:27:57.444000  RPI 3 Model B (0xa02082)
    2020-08-26 11:27:57.532000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-08-26 11:27:57.563000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (369 line(s) more)
      =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f464b9f3e7ae296d79fb45f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.142/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.142/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f464b9f3e7ae296d79fb=
460
      failing since 41 days (last pass: v4.19.124, first fail: v4.19.133)  =
=20
