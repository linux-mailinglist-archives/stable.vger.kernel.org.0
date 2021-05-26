Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09154391CC5
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhEZQPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 12:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbhEZQPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 12:15:09 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39654C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:13:38 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so597419pjp.4
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d5/zFN2+/fYCT3K6WxrSJziZWUSmyTIfH4tGGQjzYTo=;
        b=qqIqNrTFc3TAjwZjjD2VpbLeZRvBCHUDFQ6m/6DTd0+5z79se1yOgAf83VL69QFUtR
         IjB8YZEUZIzRdWaI6OnwFL1u69+URFuFohiRk5SrQ8IYvxbnjd392+NWx+usi8DY9WCT
         YzIGRpQ2aBP1HKTwpsbxChDqFGD4sxEQ4vbj+16THazBOIekU5AJyi0C68LKWd9hQMPY
         IlNuzjnWKcq4uVpan+GfAbXdNSmL2jo3iaUFcGy6oIPM9e4Ig7a3XPBJBDLtneD23Ut0
         gZJFnqcuxhfmyieO547WMBMlCUGl0nvZsdnJuAmkrtPX6ucvNi2dAvkddbJ91JMIYoa+
         sFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d5/zFN2+/fYCT3K6WxrSJziZWUSmyTIfH4tGGQjzYTo=;
        b=a240KNkAKfm79rQ9hbi4lue9eRMPrdJN4bPPSszyQX1vMrIBf7QDLArcsCyIneLwR4
         LzGwf4HD7j9s6MbwDMMB8CQf8gw2UBJsNQ0MD4SfCo+Fycd1ZCcUXjLYPTWBZH7h54Ep
         9FJb4WOUP79RzmdpSejLk3c3e3Cb0OmnqO8Z3gg20zU2oXwSd9RLilIKYvC04rhgnjbF
         oXswczcM0SZhfMaDBWX2y+qnGy7hxwhNp77F9fh/MPmaa6ePBypsb8xqrn8P60q/p6lC
         O3b7u7Cbc4/ESMPJ+4zUNgk0DWTSy78z4FW728SBLk7KavwdhATeFq+sqWv6xuNGfvY1
         gO3Q==
X-Gm-Message-State: AOAM531iAO9YyVprfMdcNZD95bELZwb11ASfaOt4k+69Y/fViRcbEkqf
        oGwFp2snhDvo/8qlV2eF7U6piTipjrXt8Ngz
X-Google-Smtp-Source: ABdhPJwli/kCFeCvQ5uAep6HbuhMweleMfZ40Hv8lNsGnwkKPXAR1512EY106NKEiEQ37j3QGhkPeg==
X-Received: by 2002:a17:902:7e4e:b029:f0:d949:8ab3 with SMTP id a14-20020a1709027e4eb02900f0d9498ab3mr36497758pln.40.1622045617546;
        Wed, 26 May 2021 09:13:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w74sm16123334pfd.209.2021.05.26.09.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 09:13:37 -0700 (PDT)
Message-ID: <60ae73b1.1c69fb81.1def6.45c7@mx.google.com>
Date:   Wed, 26 May 2021 09:13:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.192
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 99 runs, 3 regressions (v4.19.192)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 99 runs, 3 regressions (v4.19.192)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.192/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.192
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6b7b0056defc6eb5c87bbe4690ccda547b2891aa =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae4072f31fc9cf08b3af9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.192/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.192/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae4072f31fc9cf08b3a=
f9b
        failing since 188 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae4194a6d346c88eb3afd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.192/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.192/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae4194a6d346c88eb3a=
fd1
        failing since 188 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae3ff97284353b63b3afc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.192/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.192/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae3ff97284353b63b3a=
fca
        failing since 188 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
