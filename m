Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D516414F33
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 19:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbhIVRgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 13:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbhIVRgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 13:36:43 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86168C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 10:35:13 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id u18so3532616pgf.0
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 10:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KwvAmwTkLITXcp1X4do7C5oZkon55ObGAwmDViF1Z7o=;
        b=75XC0lsOHmuqRh9Q2p0xTbKucI74YDBjAz4XHd/IXiSQMiwdmJPmVHSGF1mFinfN00
         No0gtTgeeI5YRLpqyjjwa9uSkd/wNdzGosdP7C8Fr9mIPtUFRSWITJMnGJ2tIpWFB4fg
         DIOsQ4s6uZOVmz9P6QMCS0gPHVSeEVQgMb+76B4RtLPodzyZ5ZWOVqwojNlnc9FWVzEl
         DoDBM9nIC2b81yUWPH09rz9lCSwNugN5v1PPPm9PgNADh3CyoBiLP9YQ1JsgsSt+0Drh
         OCKQcx43ISDTGyfAvgqpgorhaCvaLzbNypbncm04pn3S8e7f2K0wCR6hGWCgJXIdKHZx
         IUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KwvAmwTkLITXcp1X4do7C5oZkon55ObGAwmDViF1Z7o=;
        b=LG35C4p/OBUJYu+iC2tchKFBBm6snQ2o8X/eBR4WToUifNTIKdN1wDw8jnUWqLT5DL
         BiRlG/6iKAzJykUgXn03USx8yk3vHgGaoZbxiQd1NWL+TOR0fLdW+3k4488og7fDHLpL
         0zBChrRImcCpC9/dmcAI6ZrBMf3YvboYJGoZT29uH7DZQQYWcfmQs6zSw9XNkyM2PhV0
         kmrSIwfDL6vNRhdawpf5uK/IrIp5ZusoaLmWZoWo41fTJAEwdfizmkdx9YkhQrcO2s0a
         jPcLLCb1ojklz5Z4Kqh56wcuE9QtBnWLtOBVeUlceVlxOQxLEbvW02tFtFrv4bvje+kN
         YHgw==
X-Gm-Message-State: AOAM532hzx+pfP/gQO+xVJLzcUMVOiBIDs38wOAamMONWYgh+Qcy/Qc+
        9qQY7w0TxkWAxTjNNAw52FwfPRpMu+qXW3qg
X-Google-Smtp-Source: ABdhPJyW/LJKTf+s/83RlpXI4ZttEhlWV3c3dNJ+pFl7n+ZaKSa9p/zXna4subqJz3MPNe6yMqkVtQ==
X-Received: by 2002:a63:da49:: with SMTP id l9mr53632pgj.277.1632332112836;
        Wed, 22 Sep 2021 10:35:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm3150775pfc.53.2021.09.22.10.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:35:12 -0700 (PDT)
Message-ID: <614b6950.1c69fb81.d69c0.91ff@mx.google.com>
Date:   Wed, 22 Sep 2021 10:35:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 78 runs, 3 regressions (v4.9.283)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 78 runs, 3 regressions (v4.9.283)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.283/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.283
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2a4bf15a4f9229052ab38718ad510848947e8871 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b2f4393eb904cbf99a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.283/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.283/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b2f4393eb904cbf99a=
2dd
        failing since 307 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b32e856d766b03e99a30e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.283/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.283/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b32e856d766b03e99a=
30f
        failing since 307 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b313efdf707527b99a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.283/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.283/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b313efdf707527b99a=
2e5
        failing since 307 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
