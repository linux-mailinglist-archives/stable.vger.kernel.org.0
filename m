Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16EF3A08E8
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 03:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhFIBR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 21:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhFIBR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 21:17:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188B9C061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 18:15:49 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v13so11665526ple.9
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 18:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T1l3Nic9UxiwoK1gB00HRj9atTtTVOCX5ZxIuPA/8AY=;
        b=XrynsPRmEAV7PKBS+iRpbmst+rdGEYMgF32xy6/csj+plFF+tpnnWMjE+QEluzu5sc
         rxe2wu/RCXjp2qeCUYaPvlWz7JfvoB4w7n9zPubtQn6c+m8+Xo8reZYWb6GNw/tIwPw1
         IQ/5sm2n87W7QHMTnPV/W9B14kzWCHUBbCi/Q11AEUknEkglL6JCkR14xmi9pee5tqt3
         dX+xxBnl2bmu+KB9+L0Bje9KyYLvwVdCVqkegkrGm3clRFx3EVz8bZWyxIFgGJXODfr3
         4j9bjwyUwj4v6SYWQtaKf0dxSgP5vjRjSReeid7sPgav9wtaYYjNCzlCVu/yk98LuN+V
         /oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T1l3Nic9UxiwoK1gB00HRj9atTtTVOCX5ZxIuPA/8AY=;
        b=RystYGVMh+n1o6DGTYI6N43OYLVlWyLm4YIHZkJE9GO9Y+Bg9Of4WqWa+pvK0BR/9E
         OGbCJbO2gyHavWZlKmwwwXd6kNrlMgHZlFouVEEtKLiIKejjy2c0wxodfV9RfSFeBTV0
         JXCMylh8uCFwMmIYVXb+Pce/VGWqUmONrW++WxMrjoOfGKn4ETpocjEsqZIDDwAIg+Ae
         0grQ7im3kdzXvQU0np6tn/IpyFusowbyzcpj5DOJqeHB0ph6IPJtGP9LLkQ7uTU9maBP
         +tz/FE1IjGkt1/g1+RXF64T+d41PWyBwZ31i5vpwu3bUit364/R5xwsjpy7kqdGAcA2b
         sL6A==
X-Gm-Message-State: AOAM5336FmAeS5u6Y0fiHZPzTsaqQwUqKlFgOl9cbhCfRf7Tsa8XSOAN
        UudBv2SsFMnwoTyCMvYC8GzBjI9vqIRXLz8m
X-Google-Smtp-Source: ABdhPJzg4TGF8faI+NUdjkJLtlJiSSnqqFNzNleghD/Z6VCY0xeXPJRWLImzXxsURjvciYqv1Qs1kA==
X-Received: by 2002:a17:902:7894:b029:114:ae45:a677 with SMTP id q20-20020a1709027894b0290114ae45a677mr3005254pll.52.1623201348399;
        Tue, 08 Jun 2021 18:15:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o16sm14524551pjw.10.2021.06.08.18.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 18:15:48 -0700 (PDT)
Message-ID: <60c01644.1c69fb81.643ec.c558@mx.google.com>
Date:   Tue, 08 Jun 2021 18:15:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.42-138-gc108263eaf06
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 146 runs,
 3 regressions (v5.10.42-138-gc108263eaf06)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 146 runs, 3 regressions (v5.10.42-138-gc10=
8263eaf06)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.42-138-gc108263eaf06/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.42-138-gc108263eaf06
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c108263eaf06733c15c23cb4fdf83d188c0e2881 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
2          =


  Details:     https://kernelci.org/test/plan/id/60bfda76a4bbae6c180c0e12

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
2-138-gc108263eaf06/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
2-138-gc108263eaf06/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm28=
37-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60bfda76a4bbae6=
c180c0e16
        new failure (last pass: v5.10.42)
        4 lines

    2021-06-08 21:00:16.371000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address c4277f48
    2021-06-08 21:00:16.372000+00:00  ke<8>[   14.039977] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60bfda76a4bbae6=
c180c0e17
        new failure (last pass: v5.10.42)
        52 lines

    2021-06-08 21:00:16.379000+00:00  kern  :alert : [c4277f48] *pgd=3D0420=
041e(bad)
    2021-06-08 21:00:16.418000+00:00  kern  :emerg : Internal error: Oops: =
8000000d [#1] ARM
    2021-06-08 21:00:16.419000+00:00  kern  :emerg : Process udevd (pid: 10=
9, stack limit =3D 0x4360cc77)
    2021-06-08 21:00:16.420000+00:00  kern  :emerg : Stack: (0xc4277ce8 to =
0xc4278000)
    2021-06-08 21:00:16.421000+00:00  kern  :emerg : 7ce0:                 =
  c4277d44 c4277cf8 c069d54c c069d3a4 c4277d80 c4277d0c
    2021-06-08 21:00:16.422000+00:00  kern  :emerg : 7d00: c4277d3c 0000000=
0 c4277f48 00000000 00000000 c41f36c0 000000ba 00000000
    2021-06-08 21:00:16.423000+00:00  kern  :emerg : 7d20: c4277f48 0000200=
0 00000040 c2cfe1c0 c4277d6c c4277d40 c069c624 c069c338
    2021-06-08 21:00:16.462000+00:00  kern  :emerg : 7d40: 00000000 c4277f4=
8 00000000 c0150a78 c426e400 c41f36c0 c4277f40 000000ba
    2021-06-08 21:00:16.463000+00:00  kern  :emerg : 7d60: c4277dd4 c4277d7=
0 c06e3128 c069c5c4 00000001 c0f366b4 c0e0fb00 c0e04248
    2021-06-08 21:00:16.464000+00:00  kern  :emerg : 7d80: 00000000 c0e0f69=
8 00000000 00000051 c4277ebc c4277ec4 00000008 c4277ec4 =

    ... (41 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60bfe1ce139bb52fb70c0e0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
2-138-gc108263eaf06/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
2-138-gc108263eaf06/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfe1ce139bb52fb70c0=
e0f
        new failure (last pass: v5.10.42) =

 =20
