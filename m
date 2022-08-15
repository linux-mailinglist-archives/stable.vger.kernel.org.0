Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C075932CA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiHOQLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 12:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiHOQLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 12:11:01 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAC25F63
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 09:11:00 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o3so6733261ple.5
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 09:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=0QyLYAEUzvlS8iTObru9GjU6h201uVHjnskt6M6qSnw=;
        b=2Se92TMCRr/ha9AN29SOCdTFYq/hRlT5LkaZNoPuDLukYhp0GCvKtbSR1BkyNRKHj/
         iEz7ZZs1bKoJQQ6e7w9jlRr1Ay3UVmTMLGfzsSXc3RtWH3TYxCuUQOdYSJG/RTfOm6VP
         we7P/klRQfHCd3/9d+yf9WJQ0afdCtrJ5P89aP9sef/dUD3ZOcGLNnXSFCDT9iMRqVvn
         V9ku2n11BLWEho3XA39uJAidM0rN1QY/Vuw8t2gVOiWVdrvYWh7v2LBR0MyY00dF+ycg
         QtTvFK50XUtgioSk6zUt6w3ylz1a8D7mPwyoWD4jRYaoZ0UskLudjiBAnRb+auEsyZWg
         vWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=0QyLYAEUzvlS8iTObru9GjU6h201uVHjnskt6M6qSnw=;
        b=Gojq2z2B86xIFNDh/ZQHQCJdNSndwIE8Zzai/7a7NRfCHfk46h0tdWTEdO/6RHZUSf
         CQ7krKAzaBSmFgxh5EFxfF3O86qeyrKJXUQ91POAXPE+TnLJwACp7L6lZkNBd+XMvVFh
         +TmhUdbVydPqxQHR6ArwPI+dpIcvJNQ9crhdh6AFde8L/GJmY0pxOGcbrBf9oHv1ULSh
         MYDN1YvsMgrlUYW96arjMCCpgJcQ3pTyKNa6ipTOQcj3s2zB7LrCTgRgyjXa4dY48VH5
         l3I0ct1vNrv09FG4RDw8w88lWyJjv4eADyz/IpHZulLCjOSzmaN01MlCPjwqHwwIAj/6
         UtlA==
X-Gm-Message-State: ACgBeo0wYK+u2bQQ9V0kURVZKsMbmtJtOuj4a8frIH/dD4FQHWMrfDhY
        uzjNdfWW51/vIR+Xf6xapv3xQTU/3IwSv56m
X-Google-Smtp-Source: AA6agR6+o0TFtUsqsdP7Jps/nvtfpyUWxeQ7fqA4xt3jZ0p6XYqBRYBmS4/t/KTWNGcApr1SO8J/sg==
X-Received: by 2002:a17:902:eccb:b0:16f:9355:c117 with SMTP id a11-20020a170902eccb00b0016f9355c117mr17940512plh.167.1660579859366;
        Mon, 15 Aug 2022 09:10:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s18-20020a170902a51200b0016cf3f124e1sm7148215plq.234.2022.08.15.09.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 09:10:58 -0700 (PDT)
Message-ID: <62fa7012.170a0220.e71ed.b87e@mx.google.com>
Date:   Mon, 15 Aug 2022 09:10:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-758-g5ab97c8bc34ec
Subject: stable-rc/linux-5.15.y baseline: 57 runs,
 8 regressions (v5.15.60-758-g5ab97c8bc34ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 57 runs, 8 regressions (v5.15.60-758-g5ab9=
7c8bc34ec)

Regressions Summary
-------------------

platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
bcm2836-rpi-2-b        | arm  | lab-collabora   | gcc-10   | bcm2835_defcon=
fig   | 1          =

imx6dl-riotboard       | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defc=
onfig | 1          =

imx6qp-sabresd         | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defc=
onfig | 1          =

imx6qp-wandboard-revd1 | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defc=
onfig | 1          =

imx6sx-sdb             | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defc=
onfig | 1          =

imx6ul-14x14-evk       | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defc=
onfig | 1          =

imx6ul-pico-hobbit     | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defc=
onfig | 1          =

imx7ulp-evk            | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.60-758-g5ab97c8bc34ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.60-758-g5ab97c8bc34ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ab97c8bc34ec5e96ce9722a5d56c4e79662712d =



Test Regressions
---------------- =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
bcm2836-rpi-2-b        | arm  | lab-collabora   | gcc-10   | bcm2835_defcon=
fig   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4366f522079610daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bc=
m2836-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bc=
m2836-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4366f522079610daf=
058
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
imx6dl-riotboard       | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4868fbde2856a4daf109

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4868fbde2856a4daf=
10a
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
imx6qp-sabresd         | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3f7a828158b660daf084

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp=
-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp=
-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3f7a828158b660daf=
085
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
imx6qp-wandboard-revd1 | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3f32a3add982cddaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3f32a3add982cddaf=
057
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
imx6sx-sdb             | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3f7d828158b660daf08a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3f7d828158b660daf=
08b
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
imx6ul-14x14-evk       | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3f7e1a1b9df509daf096

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3f7e1a1b9df509daf=
097
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
imx6ul-pico-hobbit     | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa524066c49cc9dbdaf07d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa524066c49cc9dbdaf=
07e
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
imx7ulp-evk            | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3f86d36bd39548daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-758-g5ab97c8bc34ec/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3f86d36bd39548daf=
059
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =20
