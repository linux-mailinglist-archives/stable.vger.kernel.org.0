Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0C5330CD8
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 12:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhCHL5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 06:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhCHL4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 06:56:50 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C80C06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 03:56:50 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id e6so6265713pgk.5
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 03:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dyk1JBvaQEIWsnvSSs3a0IIRQHYMOeWWmzolb5D2V24=;
        b=VSbNEH6SD+ee/YNpKA10sDRVnBiQ3HPSEv1nYy01nb3t1493w754b/7ovDJ/mJsccn
         smZr78LroJUCcxIIQSD9U+F95T+oFuToArBGWxsb/eim/0kX40AIkCbnVY7qO9jGflKx
         zJUGYHW3fG4bivCh0gRgaz6jLv1fGglxk+ZCIV/pfe6cA/WrSsVoFeEL4bHCAIC4cn6F
         ansUmm26YL0nyDM7dhRFSxiMtUK85EsHngxuJo6966zDLJp3q6QJ5VdowcFZkMLHTL8i
         5pvfR/8sHsmol5ke+j3xPfv5EHrl1pRoJ5fxVDYhgQWl16JtMdDp71QO7Ff0BseHrhZR
         KD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dyk1JBvaQEIWsnvSSs3a0IIRQHYMOeWWmzolb5D2V24=;
        b=aPsFFuWpIrEDFiRywH2MAHZGVu7iStY6RBtP7HOBsHO8R8kuz+gRSRo4sWipbYNUNz
         jJB7lB+sN/Nzvx4yT+aa3AZInHgk+wV66vsi7M44xv92QgVN8WthbWPDt9FXjfgE/jiH
         jl+zQXjmKaM7A1uOPKsoBGDVNQJyQ303qo3QUCGmxzXFeufNaumTJlKtjvXnI9KuejiW
         aayduc0AxFeMo05tIWzUOC1lWxe7EbabsL/J5wL8b8nAsKWQPlJRFtHbnW7RfdDJLIZC
         /qAOX5mQg6dpz/F66VpDyQ4E76sYgqfLMoCybtpcRghRGVxy0n2gazlKsJhXJHGmd6Z/
         ea1g==
X-Gm-Message-State: AOAM532MCD0MsR2lds+0tUaHRwQSMoELxeW+vpCxQ4xqhuuokdiUvQM0
        NN2C6QC+JFkJ8xf0KGlcBZZn66e80V9i2exK
X-Google-Smtp-Source: ABdhPJzeupTR8ATkGQI8gE3RE8jKP67OHox1cOA8S33hoHN8o0npiJba6mE1dUH5EfFAQBMwUgvIpA==
X-Received: by 2002:aa7:92d9:0:b029:1bb:b6de:c872 with SMTP id k25-20020aa792d90000b02901bbb6dec872mr20796008pfa.68.1615204610001;
        Mon, 08 Mar 2021 03:56:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 134sm10392738pfc.113.2021.03.08.03.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 03:56:49 -0800 (PST)
Message-ID: <60461101.1c69fb81.9a1b6.9d05@mx.google.com>
Date:   Mon, 08 Mar 2021 03:56:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.21
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 156 runs, 3 regressions (v5.10.21)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 156 runs, 3 regressions (v5.10.21)

Regressions Summary
-------------------

platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =

imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.21/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.21
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      012f78dadb7186c479343b77e97df2925caf681e =



Test Regressions
---------------- =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =


  Details:     https://kernelci.org/test/plan/id/6045df4a5c0a127032addcb5

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboa=
rd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboa=
rd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6045df4a5c0a127=
032addcb9
        failing since 2 days (last pass: v5.10.19-662-g92929e15cdc0, first =
fail: v5.10.20-103-g80aaabbaf4332)
        4 lines

    2021-03-08 08:24:11.604000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-03-08 08:24:11.605000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-03-08 08:24:11.605000+00:00  kern  :alert : [<8>[   42.469769] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-03-08 08:24:11.605000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6045df4a5c0a127=
032addcba
        failing since 2 days (last pass: v5.10.19-662-g92929e15cdc0, first =
fail: v5.10.20-103-g80aaabbaf4332)
        26 lines

    2021-03-08 08:24:11.657000+00:00  kern  :emerg : Process kworker/3:2 (p=
id: 80, stack limit =3D 0x(ptrval))
    2021-03-08 08:24:11.658000+00:00  kern  :emerg : Stack: (0xc33dfeb0 to<=
8>[   42.516836] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-03-08 08:24:11.658000+00:00   0xc33e0000)
    2021-03-08 08:24:11.658000+00:00  kern  :emerg : fea0<8>[   42.528176] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 790840_1.5.2.4.1>
    2021-03-08 08:24:11.658000+00:00  :                                    =
 1e9b10fe a8140f08 c213ec80 cec60217   =

 =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6045ddd3d7b416d382addcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
1/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
1/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6045ddd3d7b416d382add=
cca
        new failure (last pass: v5.10.20-103-g80aaabbaf4332) =

 =20
