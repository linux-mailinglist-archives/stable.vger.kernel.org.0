Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8851F29FD92
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 07:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgJ3GEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 02:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3GEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 02:04:31 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763B2C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 23:04:31 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w21so4340025pfc.7
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 23:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y4WnIz/l+gxgeRct0Y/RpilB7eRFffytTcFTL5Q1Rtw=;
        b=TIF0XEKcYen5k9I9pZApFHdgTMPVvkz89k5zwBqMGSLLsVPNKgeqz1dkBq2DohYtuM
         dv2bfnK3LY8zRo9hKdZID/mIK6PxP+6E3GDz37qjq8+4PFE1/h2S309EjRp4JMYEh3lt
         jjivJUK12ghoOwdD8mPFZUgwO9J+qYQbMik+QyZj9w+04sir1TFHWEwTQR2hQZ/vUQHk
         suX8telMb1hsxfKThtHhiz0EcJTFe2lSuGgWiCxa1iSg7Hua2fB9krD0e7iLBHIZtFoH
         QPMxMax7bbzbXWK2LMmVtgTa0QYZfCBkiUj+ZaQ+DYE2QQiEiF/1WMmsxRNlLU1W+MMg
         f1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y4WnIz/l+gxgeRct0Y/RpilB7eRFffytTcFTL5Q1Rtw=;
        b=kXjaDfWWQ+qxXjGCscOU2SqGnSbr4YcO3leKl0GaSgfWN28DfeNECdOpP3/8GCrtCi
         ZQJ3pD45CvGBMfo/AYqFq8jAEQfYEACeK3LUEdYBlcQeh/NVBUfZeFwRZQ2mweslNY8y
         VQVMpR+ignAuzrxjpx4c0LPvmxVCwAs/yQHWFbuUrmPGPja0TIlIzVitoquM0XdtC425
         Zf/J5419/t4UYOYgb0mdepeTniQuHXCqG7jwyAcH6ahXxA0Ny44Pb+8UsXHyMvI9j37W
         bLmh1Zq8UAy7TRjxjQVwnHfKoJ4UR3sUXh2X78Hd4QaqM+p5SDALZ96MlP9xhfl59AIY
         9GkA==
X-Gm-Message-State: AOAM533QpFi/OktMW9pmmRpz5SBnnbgWC3P9Fou7m68JBVhnbHmlIUQe
        UfV4IJCjVV72+yZKx8dJ0ucBn/1JNmAEow==
X-Google-Smtp-Source: ABdhPJwN/pNxTJbR+HnIKdgjtlGWosycDzl1ZFwbzzpmKagBVM3C7A9y+22gRIeyLnapFK+RIoP8/w==
X-Received: by 2002:a63:3302:: with SMTP id z2mr830110pgz.327.1604037869666;
        Thu, 29 Oct 2020 23:04:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x10sm4521422pfc.88.2020.10.29.23.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 23:04:28 -0700 (PDT)
Message-ID: <5f9bacec.1c69fb81.5ea6f.b57b@mx.google.com>
Date:   Thu, 29 Oct 2020 23:04:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.17-26-g4cd0eaef7939
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 198 runs,
 4 regressions (v5.8.17-26-g4cd0eaef7939)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 198 runs, 4 regressions (v5.8.17-26-g4cd0eaef=
7939)

Regressions Summary
-------------------

platform        | arch   | lab          | compiler | defconfig          | r=
egressions
----------------+--------+--------------+----------+--------------------+--=
----------
bcm2837-rpi-3-b | arm64  | lab-baylibre | gcc-8    | defconfig          | 1=
          =

imx8mp-evk      | arm64  | lab-nxp      | gcc-8    | defconfig          | 1=
          =

qemu_x86_64     | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig   | 1=
          =

stm32mp157c-dk2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.17-26-g4cd0eaef7939/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.17-26-g4cd0eaef7939
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4cd0eaef79397a53f170204d37f6ca6ae93086dd =



Test Regressions
---------------- =



platform        | arch   | lab          | compiler | defconfig          | r=
egressions
----------------+--------+--------------+----------+--------------------+--=
----------
bcm2837-rpi-3-b | arm64  | lab-baylibre | gcc-8    | defconfig          | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f9b757a932b1c9141381027

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-g4cd0eaef7939/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-g4cd0eaef7939/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9b757a932b1c91=
4138102c
        new failure (last pass: v5.8.16-658-gc32c23a5a4dd)
        3 lines

    2020-10-30 02:05:10.832000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-30 02:05:10.832000+00:00  (user:khilman) is already connected
    2020-10-30 02:05:26.188000+00:00  =00
    2020-10-30 02:05:26.189000+00:00  =

    2020-10-30 02:05:26.189000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-30 02:05:26.189000+00:00  =

    2020-10-30 02:05:26.189000+00:00  DRAM:  948 MiB
    2020-10-30 02:05:26.204000+00:00  RPI 3 Model B (0xa02082)
    2020-10-30 02:05:26.292000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-30 02:05:26.323000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (393 line(s) more)  =

 =



platform        | arch   | lab          | compiler | defconfig          | r=
egressions
----------------+--------+--------------+----------+--------------------+--=
----------
imx8mp-evk      | arm64  | lab-nxp      | gcc-8    | defconfig          | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f9b77a01d4d5bf2f638101a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-g4cd0eaef7939/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-g4cd0eaef7939/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b77a01d4d5bf2f6381=
01b
        new failure (last pass: v5.8.16-658-gc32c23a5a4dd) =

 =



platform        | arch   | lab          | compiler | defconfig          | r=
egressions
----------------+--------+--------------+----------+--------------------+--=
----------
qemu_x86_64     | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig   | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f9b7823105a4f137a381060

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-g4cd0eaef7939/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-g4cd0eaef7939/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b7823105a4f137a381=
061
        new failure (last pass: v5.8.16-658-gc32c23a5a4dd) =

 =



platform        | arch   | lab          | compiler | defconfig          | r=
egressions
----------------+--------+--------------+----------+--------------------+--=
----------
stm32mp157c-dk2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5f9b77b8afda434947381018

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-g4cd0eaef7939/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-26=
-g4cd0eaef7939/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b77b8afda434947381=
019
        failing since 3 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
