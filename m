Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E8242261
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 00:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgHKWOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 18:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgHKWOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 18:14:32 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A4CC06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 15:14:31 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id f10so182203plj.8
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 15:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WHGaGUu0EMQMgv7phupIQS3ayoydF4t1sdW0L6eVq5I=;
        b=gaQJvMfIOpaHissAhgCoIsIMFFPi1QKSpMDtIiJo1N5wR4/5+XLOwqCNyzhO68ZkNZ
         zB7luI2iHUbc1HyMRo8/TJ+ERpbzkWF7wT65evmvgAoletCe5VXT9qm6TH/brVosGLE6
         2AQ4j3OMDkByhd4J8aesxeTfBj97ga4H6jXo2Wok588eLek48AEfpXP+ixIyElgXM6jY
         9e0rlfS3fgIHhenhMHDBnPsrplzeOAp5bVR9wVNlDj57phe6a2aIgxFX0chAR25ttfx+
         HqigHwKARIBj25DMm8cLgPd5HvlVHfQGXtyOAqV4xSMX7XPg5sZg1R5fp3ICpL9+shJ4
         TRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WHGaGUu0EMQMgv7phupIQS3ayoydF4t1sdW0L6eVq5I=;
        b=cJKFehlu66vGac0yG5SnWE2vTTc9nQFLoEgxkTGZXPMtG9z5S8K0qDfnk6YtBV/e7h
         Q6LLz+khu3K5KYfEddPcfb+JgO239R7ls6XhEneIv38MnDjzsNaEd+cgJpnsTLIWvVjr
         5QkVRuqd6g12rYODbiA11RE7HgtfvMhnuaHqKp/63fBxxXLRJXFDuZprgojHmyYrxZBf
         Vj53KEdoXy+ZiT+XF+I8kF2LMaPAd1lbvcOzfquf4BH74QYKTBGknNkAlwx92RVxiI8D
         nEwTF506MQgGqAbli9gxILDWSFToIRawAFfNPAmyHaJfsvezGeKQ8jthJrOJq8+8heGF
         zR4w==
X-Gm-Message-State: AOAM531RxHtq6K4ChAHJu/AyTK2GhCjFwhKqT6jt1o38DlAqA436I2mb
        fhgESTpEabG9OwpMFR8apHB7sZM5hqY=
X-Google-Smtp-Source: ABdhPJwJSzhtosSdZIIjp/X/DcHQv5An7yM1J17C/CixdgNVA+Tb4+vvT1P5oes0f13Ja/Oco/SpHQ==
X-Received: by 2002:a17:902:fe10:: with SMTP id g16mr2776448plj.43.1597184069889;
        Tue, 11 Aug 2020 15:14:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10sm79496pfs.75.2020.08.11.15.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 15:14:29 -0700 (PDT)
Message-ID: <5f331845.1c69fb81.a872c.05f2@mx.google.com>
Date:   Tue, 11 Aug 2020 15:14:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.58
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 195 runs, 2 regressions (v5.4.58)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 195 runs, 2 regressions (v5.4.58)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | results
----------------------+------+--------------+----------+-------------------=
-+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 0/1    =

omap3-beagle-xm       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.58/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.58
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cad17feaf0d05e60f7fe3c29908f9e2d07fbb7ee =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | results
----------------------+------+--------------+----------+-------------------=
-+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f32dd9b297886ef9b52c1be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.58/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.58/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f32dd9b297886ef9b52c=
1bf
      failing since 54 days (last pass: v5.4.46, first fail: v5.4.47) =



platform              | arch | lab          | compiler | defconfig         =
 | results
----------------------+------+--------------+----------+-------------------=
-+--------
omap3-beagle-xm       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f32dfe66a1b94b73e52c1b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.58/arm=
/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.58/arm=
/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f32dfe66a1b94b73e52c=
1b8
      new failure (last pass: v5.4.57) =20
