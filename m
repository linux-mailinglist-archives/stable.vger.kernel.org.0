Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AED391CA2
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 18:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhEZQFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 12:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbhEZQFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 12:05:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D79C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:04:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g24so1044989pji.4
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/VU+8bq+MXFeIWiWuY5gYDMBRPIn0xrnqF3lpEi/O/s=;
        b=F2t00nY8iCmxw92nhE/7dH471xkUpRU/HGT8Kd/ku4Ig2o1gKR/f0gZ7aYi9Kzvn/Y
         EQVOcZdYu0w/2iTxgIYCdwQVVCSXethDEFPJJWGgPRtUVSM5rwAK7hJEzXMP6DhvqezY
         9eVqJQJkM+En+i49LjXld47xKSC/+wdIxAsd/B87u/03l0b0QWsPa03+DtZHYhC+8GZ9
         JN9u5uL9SvJ7BhCiVWuzcWsIOimn/uK3ShahrEYHdQRr6TDRCsleDeu2I2A3Eq0txxjO
         V7S6gx3p6xekDlifjRHOGuZuH8/RUevB9jr3TQ3yHY6wObxg/hhsFpsFnf04BiCh5pnH
         xwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/VU+8bq+MXFeIWiWuY5gYDMBRPIn0xrnqF3lpEi/O/s=;
        b=Nl6+rxs+z6rhSHsZlITizHUy71iLhmaqh1bC87tx71dqTuTVVXC6XTm4JcQz3rE3fP
         ghch2PB6wzyb+qPQY3DaQTcNxgSR4ssSJ7U290+0geEo6aPOOxU7mlAXIV/JNTr7A42E
         M1ASMpfVwHHaual3fe3UiaSeOD5qffNZfLg0oaop7pvIfztBbRBJJGw40OQqaZD7P8VU
         cnXv0Pft6rC0695zWhPxuIKU/ZTM2/as8US7350Lg1QMz+b1Se2wQj7DjVpwYfgFZNhx
         V/IWfDkEhkwnILFa8m1DABnC43W4aO1doxZMlmZ+ayaj0o5UkbOzwX3sb7cZ0U89YOZQ
         4lsw==
X-Gm-Message-State: AOAM5303QSZgSlDRgCameJW2IJoACKCld1goLAQDwY+JqAfuwmUq/9wE
        rnhleNPnCvZrwo2JMaJI5/5OwRMyv2r8fq5y
X-Google-Smtp-Source: ABdhPJyiRnd5rpkkQNjO75f3NxPhc7b4W8UpT1h1CbLpC7Eyz1pusGPEQTxP/r/7RX4IqwKcPho/Pw==
X-Received: by 2002:a17:902:bb91:b029:fd:6105:c8e6 with SMTP id m17-20020a170902bb91b02900fd6105c8e6mr4015214pls.0.1622045040087;
        Wed, 26 May 2021 09:04:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w22sm1747415pfi.122.2021.05.26.09.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 09:03:59 -0700 (PDT)
Message-ID: <60ae716f.1c69fb81.f2d68.495a@mx.google.com>
Date:   Wed, 26 May 2021 09:03:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.270
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable/linux-4.9.y baseline: 81 runs, 4 regressions (v4.9.270)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 81 runs, 4 regressions (v4.9.270)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.270/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.270
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b56da4caac598e69d707ee64bf6f6c7b832cc807 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae3863fb676adc70b3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.270/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.270/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae3863fb676adc70b3a=
fb6
        failing since 188 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae397db116f3cacab3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.270/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.270/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae397db116f3cacab3a=
f9f
        failing since 188 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae380cbb961fc1cbb3afb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.270/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.270/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae380cbb961fc1cbb3a=
fb4
        failing since 188 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae39482a6555c544b3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.270/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.270/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae39482a6555c544b3a=
f9e
        failing since 188 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
