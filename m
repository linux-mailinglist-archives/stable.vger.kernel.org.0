Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033EA426394
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 06:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhJHEOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 00:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbhJHEOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 00:14:23 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36895C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 21:12:29 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 75so1897788pga.3
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 21:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j/AZMaisb4KJWsPEkb8gHR9heUyKM2fUBmIYLkOHFXg=;
        b=fo9PUT6Yyk+oeUJrVO3nKrtaDD41xc3uXcjESd7EX55iEjz3DKbNjAW9ggkxc3pEjI
         AcTucu8Abydjt5VSX2f4CkLwGZK9U8PJFQfYGXdTNpuYCi+Tn4mc138vFgwLYorarHdL
         atC0Rk9Rw8htwLqxUOdIVSc1NUNhdjFPm4YUYiKyjgWKXCVF4a29EfqUjCTl29XzvMQS
         jrPQSA4LOoLk6oXbuUKeUHwF/uIVU30dCzrgAQbmRCUNY4K8y9WX0DNmHNVu9mDk3Yi3
         2KeWsmGazU4YQKTzkW+1pSu5pP8twcnsMAvpi71NZ5kaESpOwQ/pS8MtXuS0da10F3Fv
         /vjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j/AZMaisb4KJWsPEkb8gHR9heUyKM2fUBmIYLkOHFXg=;
        b=6fFVVVRf0kOuVkwHntYc/claW9Y+O6oJGrMgKNZkDBMJzfaWpl9aPf3NyjV9kzaXsl
         HPfFFBYozUSdbqDOzBOFT3KTC+rCOBulv3qsBi2UbUNzMYlpYToknvZL70RVzxMM1neu
         ITCLu9P87umYo3lPpPoV1Rx0DQJvF/dhhbf1D1jzfGOqlyn1HfgsDP3xRGQ3ozjYcU/s
         IsUoyDABP+bb6NArpIlQOMUgg/Rw7VEHbM9i1jrwmvStlJAxeyJdI3BY0vYHqHyGNaL+
         oxACDZU+TB+BITZPLiSWXoxmjX9/ColL5eVrxF9uH3zCdXeO3UYG2xyC822KdTYAcPyD
         w0/A==
X-Gm-Message-State: AOAM531jTwDjMyo9DMkhHzI7M6K7yejUprrCMuBffsZKLjqXPOtO0PZh
        gs22zufMNGLyFigeGpM/d1vG5+Wg7rfoaV7z
X-Google-Smtp-Source: ABdhPJwlqJDJsAl7O3K6yw3B9PBVZdnotBlY3kYjijUhXAxSSUpfk2bd+LMS59XKCwcsmC6XY9+qkg==
X-Received: by 2002:a62:3383:0:b0:438:4b0d:e50e with SMTP id z125-20020a623383000000b004384b0de50emr8109214pfz.9.1633666348494;
        Thu, 07 Oct 2021 21:12:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl18sm724986pjb.3.2021.10.07.21.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:12:28 -0700 (PDT)
Message-ID: <615fc52c.1c69fb81.f71a3.3197@mx.google.com>
Date:   Thu, 07 Oct 2021 21:12:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.285-7-ga336b5d1641a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 77 runs,
 2 regressions (v4.9.285-7-ga336b5d1641a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 77 runs, 2 regressions (v4.9.285-7-ga336b5d16=
41a)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.285-7-ga336b5d1641a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.285-7-ga336b5d1641a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a336b5d1641a6399b30eb2255bea9742e0431f89 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f90358afa76166b99a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-7=
-ga336b5d1641a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-7=
-ga336b5d1641a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f90358afa76166b99a=
305
        failing since 328 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f9437f72896b3d299a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-7=
-ga336b5d1641a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-7=
-ga336b5d1641a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f9437f72896b3d299a=
2e9
        failing since 328 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
