Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA163906B8
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 18:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhEYQft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 12:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhEYQft (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 12:35:49 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FA2C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 09:34:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 6so23159997pgk.5
        for <stable@vger.kernel.org>; Tue, 25 May 2021 09:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8FOCLg8QjdP4lO/GpKj8ujhoQT3idHdnUW+s9tjxw5g=;
        b=1t74GX51RJPaJszJ0b4/g1OA1djU4s3xZEDR6P81lt0FF2cCwtmoxrdifrzgkj9yqt
         A5q1OYMG3CXAAcuM/LJulEXUBgIkRG9l2tGjMhhUzzeND4Avv7cyevvqJa6I4ryCttna
         /6dHesCfc2oRdYAV+xRQHKZviSh7QsWp4BFW38a66jXIedrNVbFFe1LfIjBl2TWRfDtL
         Hv3QmJeS8zXjqfGa66duYoDtVXNKoRfcg9LC85K01O+EcvHUn0JFfje5BgUasRPlf9fV
         nURGSEXXKXmZMNLrK6xwo80hFSvutmGkXWh0Lprfc6G2JcKpG4ekDuLhxcdjL+8USHpw
         UDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8FOCLg8QjdP4lO/GpKj8ujhoQT3idHdnUW+s9tjxw5g=;
        b=ioLcpw0fHe62TvDIqxQu8dvSFGHRHQEAUlQhzi4+3Zx+lljZfjscnWTuXt4MZeDXsA
         9Kq86hDMBz5qIJk/r22rm/0jBD5o6UOJlSTylNjt3YNqufzibZnGAFkZ84dqRByOLMB/
         wEQDhyC5qBTQ09dfedQwkhgnmXY9/tWiMdpLg0MPTJ/LsCUn3d000JCT6wfGIBff6dqT
         d9H5quS5qD1iSHypDgWmDqLyQmiQWIKG4x4/goYk+MCQisebaBsYTDU5sI5gk4AsMBrB
         yEOuQqlHvk/PWGyuxV2azz8/Y49C70bPpAoc8/PX+sIAuCJC4y2jtONFr4vUeK7lFftp
         d/VA==
X-Gm-Message-State: AOAM533xWHohcmg/E1DNWYo3t5tsCmaCt+tv4WaHXMuArnidui2fyr00
        6DRsOb7HFgYCYn1Ji4La/3RKa1jj+R0A2F/W
X-Google-Smtp-Source: ABdhPJxAskpojSGPYJY9jy00j8Rbzr4FyBunPLuaijUAOLwevA0ArxGMfCQrAajER7qRAU72BwbTLg==
X-Received: by 2002:a63:2bd5:: with SMTP id r204mr19478144pgr.426.1621960458208;
        Tue, 25 May 2021 09:34:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f3sm2548373pjo.3.2021.05.25.09.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 09:34:17 -0700 (PDT)
Message-ID: <60ad2709.1c69fb81.15b5a.8cd4@mx.google.com>
Date:   Tue, 25 May 2021 09:34:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.269-35-gb7f9cf71a46a
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 4 regressions (v4.9.269-35-gb7f9cf71a46a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 4 regressions (v4.9.269-35-gb7f9cf71=
a46a)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.269-35-gb7f9cf71a46a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.269-35-gb7f9cf71a46a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b7f9cf71a46a4824f3874a16ecd6fc8972509b07 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acf577a1810e408db3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-gb7f9cf71a46a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-gb7f9cf71a46a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acf577a1810e408db3a=
fa5
        failing since 192 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acf53eab52098a3ab3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-gb7f9cf71a46a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-gb7f9cf71a46a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acf53eab52098a3ab3a=
f9e
        failing since 192 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acf58e77019a9009b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-gb7f9cf71a46a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-gb7f9cf71a46a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acf58e77019a9009b3a=
f98
        failing since 192 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60acf4ea1832a18aceb3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-gb7f9cf71a46a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-gb7f9cf71a46a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acf4ea1832a18aceb3a=
fa2
        failing since 192 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
