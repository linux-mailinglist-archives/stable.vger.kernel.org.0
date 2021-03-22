Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3E8343B2F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhCVIEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhCVIEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:04:20 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A29C061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 01:04:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so10045786pjh.1
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 01:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DKUb+twxXWk/GUOBrf+s5Nz/O+FwqV8IydX5yxm83LY=;
        b=ZOCu9PVSIY8EW9AOxHeeY51385ATjiEuyBCeDONyM0DM2B4vDaSrzU3TWLZfG4j6hl
         FX5EctdZts+ifR/v38zExquFcClgNwloc3bSOGxstp6TwFLZmnScTM8uRKASqycjApuv
         Slaw1E4Tqj7PqO8OmOq9QCkdTyoDcVQOdaJNPh/bdbRVwoaRvrD39eCw+ElgKkOnqg+e
         dU6iKIxehO+418jJXQIHLha9XLdmSYK1zxIGtJ1ExjJqZrnbRh5XR/TCACv4Alfm4GY9
         P44ayWPRdAH8FU5of3o56j9iUKT5G6xe4/h2Xy6B+MWUIh6lohYPD0SEi9Ua4NgmUbXr
         9qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DKUb+twxXWk/GUOBrf+s5Nz/O+FwqV8IydX5yxm83LY=;
        b=e4UmjZH7nUayl3XaVCqq0TpyOwwWpNI2q6h/zjHmPBjIKU6zJfFaE3fc6FIA/eoqQF
         omZe+ZukJSh2AdcJF/dXPZ8uFDgwiD4KWx9dhGwnmGhnAmZnUE9VnPh2LudvrzOoeLlQ
         3InUDsdcGbIjqgK5zLprek2Kn2qy+jioZOu/P5jIztPqyPDkeJQwLpTyB/OUY/ti0TrN
         kftIQfh0tqFhRpsYWmyWptNiF2X8ipBkuEyeYkTLoZeGNPWmyeTuWUwdnWWzkZJgLXc9
         XmdlkMOk3Vy3sevOdVU5oopCNxSB2+jeJUoCKUFUDFPzekpGX9/4nFDZNG9U4uPhEs7d
         apDg==
X-Gm-Message-State: AOAM532QfjBwkHLfGOsSHZ8lF+FsTzXo1wkHE8ExDAdUSYTk5VHYvRoP
        bmqZGb9xlsfhn1nfuzHosxnanuav55uAOQ==
X-Google-Smtp-Source: ABdhPJx0A6bqGWyYLUUNkP9lTfU34ZnDGDJwpbFtnMMU6/hyh+WOZVTJa80fWg8CFofTZQ+B76DS/w==
X-Received: by 2002:a17:90b:1044:: with SMTP id gq4mr11880101pjb.232.1616400259540;
        Mon, 22 Mar 2021 01:04:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10sm866665pfn.55.2021.03.22.01.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 01:04:19 -0700 (PDT)
Message-ID: <60584f83.1c69fb81.739d2.18d9@mx.google.com>
Date:   Mon, 22 Mar 2021 01:04:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.25-114-g24e7920fb9b31
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 173 runs,
 3 regressions (v5.10.25-114-g24e7920fb9b31)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 173 runs, 3 regressions (v5.10.25-114-g24e79=
20fb9b31)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfig=
   | 1          =

imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.25-114-g24e7920fb9b31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.25-114-g24e7920fb9b31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24e7920fb9b315fb2e1db38ec39854149195af14 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre    | gcc-8    | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60581bad98435ae9c4addcc7

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
114-g24e7920fb9b31/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
114-g24e7920fb9b31/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60581bae98435ae=
9c4addccc
        new failure (last pass: v5.10.25-59-g387026133273)
        28 lines

    2021-03-22 04:22:47.006000+00:00  kern  :emerg : Process udevd (pid: 10=
2, stack l<8>[   13.448264] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESU=
LT=3Dfail UNITS=3Dlines MEASUREMENT=3D28>
    2021-03-22 04:22:47.007000+00:00  imit =3D 0xa7bd5367)
    2021-03-22 04:22:47.007000+00:00  kern<8>[   13.459054] <LAVA_SIGNAL_EN=
DRUN 0_dmesg 12595_1.5.2.4.1>
    2021-03-22 04:22:47.008000+00:00    :emerg : Stack: (0xc4215e58 to 0xc4=
216000)   =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60581df80f5f8410f4addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
114-g24e7920fb9b31/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
114-g24e7920fb9b31/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60581df80f5f8410f4add=
cc6
        new failure (last pass: v5.10.25-59-g387026133273) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6058208b7eaeb6ebd3addcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
114-g24e7920fb9b31/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.25-=
114-g24e7920fb9b31/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058208b7eaeb6ebd3add=
cc2
        new failure (last pass: v5.10.25-59-g387026133273) =

 =20
