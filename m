Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C2835FB19
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 20:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhDNSuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 14:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhDNSut (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 14:50:49 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83F0C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 11:50:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u15so2100426plf.10
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 11:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UEc1Ul6UqTMGqv0+tcjF1SaoEhVSlNcTNH4x7IrGb+g=;
        b=oC8UeufunASRofZmwy/l3ayvcGga/EPXhq3WtqdncHJoRV7aPO/+6l18i2NVORhiWV
         e/QEh5OkO6B7aJYNOpe1IgCRwde9IIrmntQCSH9Wq4EMkPO+cC8FztWCt14VKYn71zlo
         mMPDq6lrFWOfSeSM4rfutnXWhTznwitZjTHhEnq6prqvuwS+Vo1gXuky7kXrgbcZZ5Rb
         e9xXfGGTzHQip64V8gVSbT6ST7SPwEmgWwjOCPGshSyITWajbhuRHZ/yCd4I7T5p7SK3
         LsTL2rB27XeD4H9DebqCPKkry8/xDPeJfbJ/Ow7qDLQlnv/KWq9oQ2G1WUdkHWxtlW7d
         aVyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UEc1Ul6UqTMGqv0+tcjF1SaoEhVSlNcTNH4x7IrGb+g=;
        b=tjIWcg7Olb9x6YU2iXoBD2hU1NxnbHaWjIbQzSP2aoMhp+rxo7I2QlpmJxEwBTPBWh
         NIqkxdD5UIBE6XdcoQXQwnKNxEAy6x470llfLcYojOsorlUm6iJlzbv7+p6oymkTXuMV
         T3eblvpHBggEMf7CItW2U0Jg+qrNyTeIe6KU53cbmIcDRTmSu/BfuyygyCvZXdzXc5fa
         rY2g9s9Iyd4qziRsMm+Y5xyjrK7vtdt8y23onwASBZFQrWVGoERVcDzqPm7PrYbd3xor
         mIjl0VvmDZ7YtH7Royrre/wa20zuLdqy/ZMJycOFbuGgufmuWDgXlXkumXxUi6LXmORn
         nkdw==
X-Gm-Message-State: AOAM5320eDwPgFuRiCF0Dta1AL9CRdaNB57YyCma6aO1g2zpUTJrCxSr
        7iZ54LTdFUVJ2WXhqFzydAFW4Lui1aeG6Lsk
X-Google-Smtp-Source: ABdhPJwFRCRRRSJJ04qRYMLgeEVr77mVziCqtTKtFmbshiVtOsnFFCe0vzr47O0QM8p+mHCFhDj9kA==
X-Received: by 2002:a17:902:d2c8:b029:eb:424b:84c with SMTP id n8-20020a170902d2c8b02900eb424b084cmr7585822plc.71.1618426225385;
        Wed, 14 Apr 2021 11:50:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w23sm242655pgi.63.2021.04.14.11.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 11:50:24 -0700 (PDT)
Message-ID: <60773970.1c69fb81.a5755.0fc9@mx.google.com>
Date:   Wed, 14 Apr 2021 11:50:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.112
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 140 runs, 3 regressions (v5.4.112)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 140 runs, 3 regressions (v5.4.112)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.112/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.112
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f55ad4daf001b6ee8ddf672e14475a35403b258 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076fd1c92fe380778dac6c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076fd1c92fe380778dac=
6c1
        failing since 150 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076fd1992fe380778dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076fd1992fe380778dac=
6bb
        failing since 150 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6076fcc6cb8fe15b84dac6bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076fcc6cb8fe15b84dac=
6bc
        failing since 150 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
