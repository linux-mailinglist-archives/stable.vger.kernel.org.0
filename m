Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800EB45E3D4
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 01:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhKZBAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 20:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhKZA6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 19:58:33 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC020C061574
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 16:55:21 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c4so7314361pfj.2
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 16:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y6wBr0TunA9i8GE4ArFhrx7C9C/a0zj5TU2tkVdYrT8=;
        b=37pdUKv9d8mPAKHRLtxGiKu837qKvn2sgve8NckgX+uebINxwJvMCdf8czn/Rm9aKk
         QFt6BodkI0qztATF7iPlrblHTt3qjWvDJbRirapbLQL2LbmQJ1FN/djl/RtBiS2hO+k6
         bVz464fMIEsXNwztqOZkC+/SOkEQEKSR7GyELdeeD0VCKvNeiDHsnOyU2wvgk5m2yzr8
         tqlcyKBytgthZ+ZLG2OVISloN9wz16EN+objYknuX77rL80IdrfnXttxCVTTRTu1mndP
         qt4BMkr8qMo6v3cKTPs8eGLQ/xRd7QfzSj08uoxbcoAadp6/yzW56q5KRPRPF/wxtcxM
         u3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y6wBr0TunA9i8GE4ArFhrx7C9C/a0zj5TU2tkVdYrT8=;
        b=DeifW9SYDNGXaAjWVGYECTQs364gd8BOOKo9EUu+CcS6quVONlZJZ/caBHND+43OBH
         wCJEBJqKL1X6OILiVbMO0pu8OrwbSJ2deqvXICn10moeNIygWXvnbDPhWpZMR6Ulke6g
         XxpcSbyr+Y5K2JU2+psGgapS0QtcuXqTmnS5QwUUL3CnllTkK79xW/bDpGavNtOYOta0
         Oo77qIRtbEg7Li577WBRAmsqgekoVR8cSdujZBZus2RA35VSlb1WfjWOyxSLUZ3WmzWY
         Oz6vTKMbZqBCwJDbINNSoDMTmhwAWFxD1vdeA7kzK/jBkCnCk9nNuixF9mBrjpAgQDc9
         x9NQ==
X-Gm-Message-State: AOAM5315wW+8VjpLU5ZH/HRqC7GWdL6wmqwo8PWb71wVZQasAeZLl4dg
        08LGKHNC4IVvLDSTfSffwjHqHcVx6ZNJP1X7odA=
X-Google-Smtp-Source: ABdhPJwUkMEI86hwO0kRw08FKPGIUV3EASkvMAhXJfjedHWTmtzfSjK0rcPjBdFIBtZTZZvYnTtTTg==
X-Received: by 2002:a05:6a00:1a51:b0:4a3:4af3:fcc6 with SMTP id h17-20020a056a001a5100b004a34af3fcc6mr17474386pfv.85.1637888121232;
        Thu, 25 Nov 2021 16:55:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8sm3256746pgc.53.2021.11.25.16.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 16:55:21 -0800 (PST)
Message-ID: <61a03079.1c69fb81.8fa4e.947a@mx.google.com>
Date:   Thu, 25 Nov 2021 16:55:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-249-g84f842ef3cc1
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 121 runs,
 3 regressions (v4.14.255-249-g84f842ef3cc1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 121 runs, 3 regressions (v4.14.255-249-g84=
f842ef3cc1)

Regressions Summary
-------------------

platform         | arch   | lab             | compiler | defconfig         =
  | regressions
-----------------+--------+-----------------+----------+-------------------=
--+------------
panda            | arm    | lab-collabora   | gcc-10   | omap2plus_defconfi=
g | 1          =

qcom-qdf2400     | arm64  | lab-linaro-lkft | gcc-10   | defconfig         =
  | 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie     | gcc-10   | x86_64_defconfig  =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255-249-g84f842ef3cc1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255-249-g84f842ef3cc1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84f842ef3cc15ea9ea46cab24c9c76fbb20a30e3 =



Test Regressions
---------------- =



platform         | arch   | lab             | compiler | defconfig         =
  | regressions
-----------------+--------+-----------------+----------+-------------------=
--+------------
panda            | arm    | lab-collabora   | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/619ffa7886925bc7f2f2efb3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-249-g84f842ef3cc1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-249-g84f842ef3cc1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619ffa7886925bc=
7f2f2efb6
        new failure (last pass: v4.14.255-251-gf86517f95e30b)
        2 lines

    2021-11-25T21:04:38.808355  [   20.224945] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T21:04:38.851254  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-11-25T21:04:38.860495  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-25T21:04:38.874029  [   20.292388] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform         | arch   | lab             | compiler | defconfig         =
  | regressions
-----------------+--------+-----------------+----------+-------------------=
--+------------
qcom-qdf2400     | arm64  | lab-linaro-lkft | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/619ff6d904a9ac3fa5f2efad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-249-g84f842ef3cc1/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-q=
df2400.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-249-g84f842ef3cc1/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-qcom-q=
df2400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619ff6d904a9ac3fa5f2e=
fae
        new failure (last pass: v4.14.255-251-gf86517f95e30b) =

 =



platform         | arch   | lab             | compiler | defconfig         =
  | regressions
-----------------+--------+-----------------+----------+-------------------=
--+------------
qemu_x86_64-uefi | x86_64 | lab-broonie     | gcc-10   | x86_64_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61a0096d9494d9331df2f03b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-249-g84f842ef3cc1/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-249-g84f842ef3cc1/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a0096d9494d9331df2f=
03c
        new failure (last pass: v4.14.255-251-gf86517f95e30b) =

 =20
