Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73601373359
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 02:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhEEAya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 20:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhEEAya (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 20:54:30 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A78C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 17:53:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id p12so560759pgj.10
        for <stable@vger.kernel.org>; Tue, 04 May 2021 17:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JbJDpYIkcGLpf1zJTwEGhJ0ws+TBHSByjXW9pJW4Jm0=;
        b=Qsd9tIbE3bLRGyP+VNlT4UXTl42yphi/bIL4CY26NXci1qZsIfO7aYu53CDIrZSbBv
         /deuaDOVaUwA7nKfj+9mP8AONpKiySqQiGMjFZm6/o985GsFvz4cHNXpr20+6RBqsZt+
         ZQjyJmBwpuAHzCn6wt1XQ4mChqcRRXJV5yCf9FNNS9tqMkeCW4Z7IK4d2zsxOL+S0+eg
         4jFRcFVILSriI2VgDSmHI2EGLLYIdaOy7vMcG2KhgHcYuevsS92ZPuzh3AgEkeuypDs0
         vMtZjr4W/WvTOOrLyVpLdgsgCHHny91Jvh1cNnZURJwtrS9oGAxvZUdNeVee1c/w9+/7
         hRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JbJDpYIkcGLpf1zJTwEGhJ0ws+TBHSByjXW9pJW4Jm0=;
        b=flgOapS6Y4lLzIZelN74v9zxopi+EKN79y10Y7sc9yCsoEZVZlBdRdhf+HXaIS4ENV
         bGWd4hM49ZpOvDbRhCykxpuIv6of6AK6cpbqT5Z4ddDn4l6SNzME29AXreUT/8Nes5Pg
         IFh1c3uiNogtLCoUWjkP3ryX0In8ySSVx2UX0XJP5YOTGnEDijVoUiw1bv90KKy2Js2Y
         bKJihL195Vu5XqW522OYUkwUBz24ODJsetcMLc6KmSc1geuUO3nHHcusO4IzN15gxeDF
         Gi15t5ViZIi6QZEadCKHNZjpL173TKVclqKi74CwuHTdmn4XQfdAdBaNQH4Qx67RNm8d
         RCQg==
X-Gm-Message-State: AOAM5311aV04YcaAQzFnz5Ji9Rx18YMOgYjb5LJyfYNacrS7jeZJGOwO
        tEn06htWnI6gbEwf5PnXxn6rOiV/igLCxaWv
X-Google-Smtp-Source: ABdhPJxsmFgjUWJu8yMRFGS3yUGmntmAUGf9X+PFSQjX2PCee1vHeI2WBVOWDKvTPzxiBU6vIX7vVA==
X-Received: by 2002:a17:90a:ff02:: with SMTP id ce2mr30552089pjb.100.1620176014493;
        Tue, 04 May 2021 17:53:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3sm5419644pjw.35.2021.05.04.17.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 17:53:34 -0700 (PDT)
Message-ID: <6091ec8e.1c69fb81.32229.bc9f@mx.google.com>
Date:   Tue, 04 May 2021 17:53:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.268-2-g25a5f3c0fa62
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 55 runs,
 3 regressions (v4.9.268-2-g25a5f3c0fa62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 55 runs, 3 regressions (v4.9.268-2-g25a5f3c0f=
a62)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-2-g25a5f3c0fa62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-2-g25a5f3c0fa62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25a5f3c0fa62b426cdd906f27b9d39d5835a5fac =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091b225ddcd87351b843f32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g25a5f3c0fa62/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g25a5f3c0fa62/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091b225ddcd87351b843=
f33
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091b218e952a25518843f25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g25a5f3c0fa62/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g25a5f3c0fa62/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091b218e952a25518843=
f26
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091b21a85b19b6e3d843f2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g25a5f3c0fa62/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
-g25a5f3c0fa62/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091b21a85b19b6e3d843=
f2b
        failing since 171 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
