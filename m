Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5C6373404
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 05:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhEEDwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 23:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhEEDwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 23:52:31 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A879AC061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 20:51:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h7so432429plt.1
        for <stable@vger.kernel.org>; Tue, 04 May 2021 20:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=065Cx+kJ9jq4d26RodLfP5vew6bh/5Ud33kjRgf+N+s=;
        b=kSp8AGfORmc7tFrJYydUQ4de6AjW8OV0ManyaJsKHeqXgEkF38m2al/fdAOAUFL6Hw
         +bJ7fXpR4AHujiZPzX7MHeJUmdfkoZrQxvd2YcAD+s/eptHMo0Jz1CEBk26kR4mKFpq2
         YtRoUSv4/TBz2In/C0uEPN7DUtVp53g0wHG6kJeRPSQXNkQ/qpIRvX0E7Wh3ZEtSuWFL
         FGzlPK115DkG4WGOLz4Ux7pNtjQNnclju8oiuBP/DX4FGEjYZqtEW0ydGam/6cY9CDZ4
         0kTfRjGrzEuGuEFcLzEExMP6dtKlGlRSavOxt/t/b3Qbt3owYVIQQ7esSHIHhOIKf0ne
         zRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=065Cx+kJ9jq4d26RodLfP5vew6bh/5Ud33kjRgf+N+s=;
        b=EjJhoVSBv6BBI8u+hEnj69o44yFl6T9jcT6iEmBjJqd3hGj8KzyUFB0Oh0oMXxXX93
         cvpq0Nhv/PNo2IM3l6NBUqDWhsArhockPs3xNvbwd8oVdxInrTr1/oEWfvqzhpuj/fps
         3ooR4ILy/kKeKhVhUOXLp9ZMSlXloMrXarI7QNvENxZM5t9GVnjobwFsVQLxOmao+w8C
         s7/LsLqiUC+YMr/3LCEcuvKhS3OJSvFbomccsORXZgivJMDRAvuEyBZt7a5LSA7RbvUE
         WUdkdG1CFV9MIs5TfptPp/ctIG0vxTAMU/DYt6/D5rqn/jRauUUMvd5AcRnfkdwVDJS6
         QmKw==
X-Gm-Message-State: AOAM531bkVFbmseBv80IaJWP8LEAKAIWsaLetqVq2p0s4DXeG4Be9iTq
        Esin/v+7+A1F5Z8tCsUDJmOP9e1ACLDESaAc
X-Google-Smtp-Source: ABdhPJx1yFBTeVO4yVXRldnfhZhQ+C43ad6HIoyMAakDNwZMrZ94ZE3//sTMAZmLGThUjULQGmLFlA==
X-Received: by 2002:a17:902:aa4c:b029:ee:ec17:89f with SMTP id c12-20020a170902aa4cb02900eeec17089fmr7065525plr.11.1620186693963;
        Tue, 04 May 2021 20:51:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x184sm5113826pgb.36.2021.05.04.20.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 20:51:33 -0700 (PDT)
Message-ID: <60921645.1c69fb81.34300.9983@mx.google.com>
Date:   Tue, 04 May 2021 20:51:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.189-9-g8cb7ba8c7c645
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 71 runs,
 3 regressions (v4.19.189-9-g8cb7ba8c7c645)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 71 runs, 3 regressions (v4.19.189-9-g8cb7b=
a8c7c645)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.189-9-g8cb7ba8c7c645/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.189-9-g8cb7ba8c7c645
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8cb7ba8c7c645acbacb0aab3e515412516773d9b =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091dee10e97a8e9a3843f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-9-g8cb7ba8c7c645/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-9-g8cb7ba8c7c645/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091dee10e97a8e9a3843=
f1a
        failing since 167 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091deed0e97a8e9a3843f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-9-g8cb7ba8c7c645/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-9-g8cb7ba8c7c645/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091deed0e97a8e9a3843=
f23
        failing since 167 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6091deddaf264753b6843f17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-9-g8cb7ba8c7c645/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-9-g8cb7ba8c7c645/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091deddaf264753b6843=
f18
        failing since 167 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
