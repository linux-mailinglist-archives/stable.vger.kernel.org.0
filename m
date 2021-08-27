Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D403F93C2
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 06:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhH0Emu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 00:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhH0Emu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 00:42:50 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F90C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 21:42:01 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q68so4957078pga.9
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 21:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8/mYlgmqNcvP6hSo/lMir8c4xc6KBXp4Dcv7RfuWRvg=;
        b=2O3CKGYFC7g9C2Y+x5RyVUK6PkM6tzr7tY0aQRGJaJwVcDUjDL3AdlZrOTAKYv7Cni
         UR+YDRBH0ivyhrjgE8So7G6TftoL3D3OUUkM/R2mbdZiN+wYsdiT1ZNhzsKhpSeP9TKo
         j6+lQQREZriikrfOtEYXCN+6W0bUdJLlzidRxLd0oTpW11cfY5l1qtF7kyhX4u5J/a9P
         z7mYiJm97xr5CT7PkNOOVbCQ9zbVlL9AAQ076gmoNd3weV2KUkMwbyQUCwAhg3jTegNm
         fHtQOzKielEUHINjC2YHrx22VUyvmczr/ouaZGjWGaFYArobfwCT/9zyh7uU8RsALnad
         WMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8/mYlgmqNcvP6hSo/lMir8c4xc6KBXp4Dcv7RfuWRvg=;
        b=q83It2UGfSN+YEUNA6+mpsxgaV3PCoJD2hJV1mC56FXoSgqBS24q+1K9TUePtBEILN
         Nums37IlHfJ6DIMmkKmTd1ZWxezAjF0HmcddbAu0pegmT+ymUBeg4LO+sGd0Q9JcvsGe
         F4+wIM9xq2SSLgfNxqdyGaOGvD5BLuMbWv7U5D9PSsfoWdvNB0vtYh/bC4y9ulMqBIjA
         YPhVBmvZdUQRndZc5IjimuaUsEoVUDP1AdmEGmp9CT9zGnyRmz/Puz40DBrngBtJtLLv
         b0qq5O7UdYBZoT2ilTffJXho9rj9mYkZ8HekmFWI3xANhl8ne4TgJJ8POnzU8MK4/Bal
         LqsQ==
X-Gm-Message-State: AOAM532sDZR1QlriplIi6gZKNcJ6I/i9wJY5+ZsbOZ/m+Gp+lyf7v9Ua
        oNsNO1jYBPPd7qedI9QXIaxNjIXQrBMExk2T
X-Google-Smtp-Source: ABdhPJxTcDJDLykVYJbM9Nh1+1X5b/0qSF+jo5mKYfOlkFwUY0TMzaRM0hSK959Ea4VpDv4MUltSzA==
X-Received: by 2002:a63:f94c:: with SMTP id q12mr6220552pgk.171.1630039320857;
        Thu, 26 Aug 2021 21:42:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10sm4782767pjv.39.2021.08.26.21.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 21:42:00 -0700 (PDT)
Message-ID: <61286d18.1c69fb81.13841.d9b8@mx.google.com>
Date:   Thu, 26 Aug 2021 21:42:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.13
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.13.y baseline: 129 runs, 4 regressions (v5.13.13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 129 runs, 4 regressions (v5.13.13)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 2          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.13/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7aeadb5bb82ad21ffbcd54c81d77727b7a05e6c1 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 2          =


  Details:     https://kernelci.org/test/plan/id/612834ef30daf3e2178e2cad

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.13/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.13/a=
rm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/612834ef30daf3e=
2178e2cb4
        failing since 22 days (last pass: v5.13.7, first fail: v5.13.8)
        17 lines

    2021-08-27T00:42:00.924850  kern  :alert : 8<--- cut here ---
    2021-08-27T00:42:00.970346  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ef9f632a
    2021-08-27T00:42:00.971324  ke<8>[   13.630879] <LAVA_SIGNAL_TESTCASE T=
EST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D17>
    2021-08-27T00:42:00.972097  rn  :alert : pgd =3D 3b3c937e
    2021-08-27T00:42:00.972944  kern  :alert : [ef9f632a] *pgd=3D014c5811, =
*pte=3D00000000, *ppte=3D00000000
    2021-08-27T00:42:00.973760  kern  :alert : Register r0 information: non=
-paged memory
    2021-08-27T00:42:00.974552  kern  :alert : Register r1 information: non=
-paged memory   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/612834ef30daf3e=
2178e2cb5
        failing since 22 days (last pass: v5.13.7, first fail: v5.13.8)
        38 lines

    2021-08-27T00:42:00.977128  kern  :alert : Register r2 information: non=
-paged memory
    2021-08-27T00:42:01.011145  kern  :alert : Register r3 information: non=
-paged memory
    2021-08-27T00:42:01.012494  kern  :alert : Register r4 information: 62-=
page vma<8>[   13.673291] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=
=3Dfail UNITS=3Dlines MEASUREMENT=3D38>
    2021-08-27T00:42:01.013287  lloc region star<8>[   13.683922] <LAVA_SIG=
NAL_ENDRUN 0_dmesg 743169_1.5.2.4.1>
    2021-08-27T00:42:01.014002  ting at 0xef8c8000 allocated at kernel_read=
_file+0x148/0x260
    2021-08-27T00:42:01.014711  kern  :alert : Register r5 information: non=
-paged memory   =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61283b3dc251b46e668e2ca8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.13/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.13/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61283b3dc251b46e668e2=
ca9
        failing since 26 days (last pass: v5.13.6, first fail: v5.13.7) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61283c05f6cfa8af878e2ca6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.13/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.13/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61283c05f6cfa8af878e2=
ca7
        failing since 8 days (last pass: v5.13.7, first fail: v5.13.12) =

 =20
