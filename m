Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E495B35B08C
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 23:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDJVCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 17:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhDJVCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 17:02:22 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E43C06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 14:02:07 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id k8so6410704pgf.4
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 14:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/V/opB9xBa5YDPgsw05RPQ0ICpnM03wuGssdTXttTZ8=;
        b=m+4etYLCDU3PsNxSReqyyuFxEIPiNEWzI8vcavfq/57tf4h2rB8T5TxiiAIyBBNbOI
         qVBzlgpj2n2yLkiesz20WRYVJNCaJw9f9JHmonZ6lEEwCoVMrk4KmopdNW1IyQyhnZOV
         EUrUlfUtwb7lBOhRNWhJlBt8Nk77izqrvcy81s+LvFDvSr9nPgXF/YsfshrDdFsh39NM
         lyhW5mQ28kjD3vxMJaMS9QHvi0ORkZJATQ+ZZ+r1dsFlhukoM0iGE8fyF1V7IGN2UfSw
         f/g6XRaDYOZfbSqRc77DCkqN/CAyVb4EZ+acaoWEtpOwPdjVOhFgnC56fPM35bABNXaR
         ybgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/V/opB9xBa5YDPgsw05RPQ0ICpnM03wuGssdTXttTZ8=;
        b=Qw9r/zVhgFWGvL7fwDWMQyCQugkCyfK+DwC6fh2mp78tEJCDMkIdv/DpNqMR5GgYI7
         T2+UiPwI9w/kIybDWI5zO02lImD3xFMkmPaP0EmL/+59+AEbvlTLThlCrnPfRlXf0vsx
         hwkqyfS6EipN9OyEEwCygAOBIZbeeRtk4f4L1sLDtpJ8ww5Y10Ms1SgdL2M3rUdapED3
         yEJ22chAjheIBDgbQDLKWXt7ZiBcgbxPD+Fh5EgDcGZS+VI5PssjRMB6o+Jt4X6dfDvZ
         txtM4Wm/UnBXuJ3wRMXSZ/mpBytNHUNzhJdnubUNbq6/JVCUTazVLZIPtQtxT7dhf/wf
         KmFQ==
X-Gm-Message-State: AOAM5314s4kCIIUZT5ptVxoliitMrrHr56d/bPwIE5MuwjE2oQiU9Juv
        oagbG1674o0FpIDLShXe7J2UuI+guqwI1/oy
X-Google-Smtp-Source: ABdhPJyvCYmoeVz4r3hI/0b3VNT4To8ClT2SzjhFxdMqczGRXJVFaKsXbHHYwROgeo1k2T68GcP45g==
X-Received: by 2002:a62:de83:0:b029:23e:6d5f:b166 with SMTP id h125-20020a62de830000b029023e6d5fb166mr17992494pfg.78.1618088526538;
        Sat, 10 Apr 2021 14:02:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5sm5810060pjo.12.2021.04.10.14.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 14:02:06 -0700 (PDT)
Message-ID: <6072124e.1c69fb81.6b09b.ecd9@mx.google.com>
Date:   Sat, 10 Apr 2021 14:02:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-17-g884aa70e2c4ff
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 103 runs,
 5 regressions (v4.9.266-17-g884aa70e2c4ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 103 runs, 5 regressions (v4.9.266-17-g884aa70=
e2c4ff)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-17-g884aa70e2c4ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-17-g884aa70e2c4ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      884aa70e2c4ff8917bcb6f28134b704f55883897 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071d87b7badbe9573dac749

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071d87b7badbe9573dac=
74a
        failing since 147 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071d8887badbe9573dac757

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071d8887badbe9573dac=
758
        failing since 147 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071d86ac22c131fc5dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071d86ac22c131fc5dac=
6ca
        failing since 147 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071d81ba9bb7e73b0dac6cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071d81ba9bb7e73b0dac=
6ce
        failing since 147 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071f08876479ab3a4dac6d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-1=
7-g884aa70e2c4ff/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071f08876479ab3a4dac=
6da
        failing since 147 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
