Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3B43C95BB
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 03:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhGOBxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 21:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhGOBxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 21:53:43 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F35C06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 18:50:50 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t9so4426097pgn.4
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 18:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iZs8oytzBwdgTecp8LF2PyaenOD4tnBrf+Vdo9r5Pxc=;
        b=jqIyQCy5OqFF1fFEVOkj9GxlTYSfRBEEIxz3K40Pz63jWGQK2kQOVW3olXpiN1v5YD
         aqxRbxVjszhDlKDEZYrz/9KfhyvPgrUllDuFcQRDaNbLpPBcFfOYtq2VKk6ZZg6yBwmi
         wn1b5Vau5HocJrijTKi++2zqP6fFSn9UO6ammBBesX0zxFQY9s95UH3800aC28XSoJdx
         zLnBxwKyVJnq4WLckltyggbL622pxE4UH/EnFDmwl0DJi/0dh7fbZj2xB/mURcAk2wW8
         hdRMcxLC0GGIv79cwE4NrGyDZAlEBHZ5DL+ANwcXD36NsxU52SIkfx8cc2MEFumDLApL
         EdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iZs8oytzBwdgTecp8LF2PyaenOD4tnBrf+Vdo9r5Pxc=;
        b=UfZ5Jq7FTPqAypg+V3+jdkdDCOpccOHT43Ajvc7kaoitU3fnS3NzXJKWIC7L2Pxrt/
         pLXxkT5wzdED3WVfUakC7vas2sTL/JT6PT1unciq0q85uo2E+OR/XjI/I9YUMeDE2DA0
         N9vblYVp9Bk6XpZrEpvKCU589Ig4IHC1jq92NCpnDVAF/j2mKjNWufV0Qwtlto9VeisQ
         8mumynvVcYFSoQ+pP06RvgssVJXtjv7fE/Nthlcc7fM1CilDMkqnOnEpFIoCLo+XkcDv
         sXrOUfxeZhmVbi7uAQMa/YvBHIwD3bS8lI7fxqEQIwPLVMhRQ89uDTjeH1ZQ1a+s2P9o
         MPgQ==
X-Gm-Message-State: AOAM531urx+tbMWFqxGHVb+YfilkYnndAEj3WgdfgTfxzipGW4UvgRto
        ZLAeU5ZmYR4m6dfNu329Z/jEGctJ6VoOOdk0
X-Google-Smtp-Source: ABdhPJyWqLUmMis88Hep1WsDKiGnMl9VD0nGefLykgzffDY4XSZRfBJ2v46b6Svj4eiMEc5sS0zoEQ==
X-Received: by 2002:a63:f654:: with SMTP id u20mr1241591pgj.89.1626313849937;
        Wed, 14 Jul 2021 18:50:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r15sm4780550pgk.72.2021.07.14.18.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 18:50:49 -0700 (PDT)
Message-ID: <60ef9479.1c69fb81.f804a.014d@mx.google.com>
Date:   Wed, 14 Jul 2021 18:50:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.50
Subject: stable-rc/linux-5.10.y baseline: 179 runs, 3 regressions (v5.10.50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 179 runs, 3 regressions (v5.10.50)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig | regressions
---------------+-------+---------------+----------+-----------+------------
hip07-d05      | arm64 | lab-collabora | gcc-8    | defconfig | 1          =

meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.50/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43b0742ef44c30f202afbf8355e9326710af9ca1 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig | regressions
---------------+-------+---------------+----------+-----------+------------
hip07-d05      | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef74bc6312d7d4238a93cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef74bc6312d7d4238a9=
3cd
        failing since 13 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform       | arch  | lab           | compiler | defconfig | regressions
---------------+-------+---------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60ef63348ece761ac98a93ff

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60ef63348ece761=
ac98a9403
        new failure (last pass: v5.10.49-594-gdb2c2c1f4b16e)
        11 lines

    2021-07-14T22:20:06.030703  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ffff80001844bce0
    2021-07-14T22:20:06.030958  kern  :alert : Mem abort info:
    2021-07-14T22:20:06.031099  kern  :alert :   ESR =3D 0x96000006
    2021-07-14T22:20:06.031219  kern  :alert :   EC =3D 0x25: DABT (c<8>[  =
 46.057139] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D11>
    2021-07-14T22:20:06.031336  urrent EL), IL =3D 32 bits
    2021-07-14T22:20:06.031458  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-07-14T22:20:06.031567  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-07-14T22:20:06.031682  kern  :alert : Data abort info:
    2021-07-14T22:20:06.031797  kern  :alert :   ISV =3D 0, ISS =3D 0x00000=
006
    2021-07-14T22:20:06.031904  kern  :alert :   CM =3D 0, WnR =3D 0   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ef63348ece761=
ac98a9404
        new failure (last pass: v5.10.49-594-gdb2c2c1f4b16e)
        2 lines

    2021-07-14T22:20:06.084950  kern  :alert : swapper pgtable: 4k pages, 4=
8-bit VAs, pgdp=3D00000000025e1000
    2021-07-14T22:20:06.085186  kern  :alert : [ffff80001844bce0] pgd=3D000=
000007ffff003, p4d=3D000000007ffff003
    2021-07-14T22:20:06.085324  kern  :emerg : Internal error: Oops: 960000=
06 [#1] PREEMPT SMP
    2021-07-14T22:20:06.085447  kern  :emerg : Code: bad PC value
    2021-07-14T22:20:06.085562  <8>[   46.104306] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-07-14T22:20:06.085676  + set +x
    2021-07-14T22:20:06.085794  <8>[   46.114789] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 562579_1.5.2.4.1>   =

 =20
