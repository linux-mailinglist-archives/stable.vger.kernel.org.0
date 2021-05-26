Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BEA391D3A
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 18:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhEZQmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 12:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhEZQmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 12:42:32 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF2BC061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:41:00 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id j12so1408458pgh.7
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9i4JW0jJRjbwLRe4XfPY2lpDR48nIrfFSoysagpdvmE=;
        b=xZLaGYdTHxkp0+17FXiYbJrAaoAbJPGiqkahDVmwDC60up7O+K2bVRrYd/gKH28Q76
         qtV7Mv0hgz5z2/uKvtVyN+3JkfhBtl2HyBM8qJRoIdya2myN7aZTClYH5LbMwIrnTZt6
         JsC4AYdsbmRcCTl/OtlnyBLxN3oMmeJaFfbZK18JNgB/Q494VNH6IovlaXSqct9u4btd
         ZxM7dhndA07jN4ErXHFL1Gl8ykYyYgQtq04Ji22KWEyG3r2DhjoZFBkjDU9qWOlwAjSH
         EfLzfpUNuwCHRAB6oCS+tHZq27Fid8GxlPG78r9wTm64TqiZ2QHVmZnbyC8HiiJ7nW+R
         m9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9i4JW0jJRjbwLRe4XfPY2lpDR48nIrfFSoysagpdvmE=;
        b=OgkPwcuTnenQ5OfOrzPnqRkF0HLEw+hAdc6v3IRgKFR4Drgql0TSIoouzqwmTvTrrs
         k6IK+W0C365/Y68U1rqZPAiIjXAssCWG8PNfQ+UJcLbwZTNvZZ29qxPC98VcbccJq0/5
         WGzpCM+vdMl43ph6In2UtE4n+aQNqR+cGd1leZdk1PI2v9ol1QBN9wjwPd/rOlIUizKd
         1ClexF1mtbf/9nTtJEJLRwK2LalGkvbuPTruZDK4mNR2i5QB8q8Qbq1ik5+C/jGsB/c0
         3D10fS6IKnPSULE6hs84SujC9RTUqTGabPlbOmWsZP+kmVDbm91oQWG56k7wW64wVrDh
         v2Rw==
X-Gm-Message-State: AOAM531E+HI2h3TI37ctiz7wkd5hTjfMcQSQIW6krV9H+Q4Qu3s/a4fU
        xHk8+5WuNChVtW+6/i3GRzlEQMNPsHfgNvKx
X-Google-Smtp-Source: ABdhPJzoHSzZDB+bhxwYq1TFwnY4hMIDvUFF7Uev4efkd2FlXR8eXJ89uQZSEcz83Q0pugdpvf4PYA==
X-Received: by 2002:a05:6a00:1a4f:b029:2e0:754b:88c2 with SMTP id h15-20020a056a001a4fb02902e0754b88c2mr36500555pfv.65.1622047259923;
        Wed, 26 May 2021 09:40:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w74sm16162086pfd.209.2021.05.26.09.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 09:40:59 -0700 (PDT)
Message-ID: <60ae7a1b.1c69fb81.1def6.47e6@mx.google.com>
Date:   Wed, 26 May 2021 09:40:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.191-49-g54ee589ac591
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 98 runs,
 3 regressions (v4.19.191-49-g54ee589ac591)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 98 runs, 3 regressions (v4.19.191-49-g54ee58=
9ac591)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.191-49-g54ee589ac591/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.191-49-g54ee589ac591
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54ee589ac59124c132d9748ff6be491ced566c57 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae4572f43f4c7204b3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g54ee589ac591/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g54ee589ac591/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae4572f43f4c7204b3a=
fbf
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae4570a8d278f1afb3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g54ee589ac591/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g54ee589ac591/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae4570a8d278f1afb3a=
f9f
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae451b77c0590b4db3afba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g54ee589ac591/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g54ee589ac591/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae451b77c0590b4db3a=
fbb
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
