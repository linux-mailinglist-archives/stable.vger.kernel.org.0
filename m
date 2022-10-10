Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7E5F9E36
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 13:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiJJL7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 07:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiJJL6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 07:58:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AE45C9F3
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 04:58:40 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f193so10180767pgc.0
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 04:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1UypvYkwMfGrfl3ed3oNspgyq7edAXdTP2k9wtvguM4=;
        b=Hj1UpezLsI2u34PIfFoe8oMO//a56lcbFxQvJOGmR2S46ef9Js/Fm81Q65qpL88TkY
         yTEHUFJqlCnT8gntVTqS3bxf7ziCfNJLsjtaOX576njCAnMm3APB8Q1wiTpqwtN15iMV
         5YI9fLBCsqdJWl64JGlTJlHSM5uHMUBGh10Af8B9a14CdoQSMY8EXFsPa9M3Ua+/41Y7
         eNBDBZPipz4eIohby0rAalvE2QrentyQmq19Xo/iWmCm81vu/7S5mchgIbHeNdjqz8W8
         BEHzb1rpUbRXuLptn3vro08YMC9GL17xdDktk0Q7Dmg/ncvCyf3g4Sd5xIjmfbH6Du/K
         QHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1UypvYkwMfGrfl3ed3oNspgyq7edAXdTP2k9wtvguM4=;
        b=gKjFq4V1TCqCpf7qjYfwK411X243xumZjbiCDu/kIVGPrfQ9sX4mwz0J2M7C3epPiN
         U2I4oCyuv/sFp+oGl1NePHxa8E/RN6cSYFLI5xq3R49baXLMDKKzQ2xNJdmJxe0Pm98w
         zMHCpaFnDa/HBy2cJMJbPNlFHiwEQy8dL872Hs1iseIRMkCfN03NAcO3vU0PEqQsYUAe
         lE4feQdlX48V/gDS9x3fmot8nofwzoBfgn59pMdy+u95CEAMZ1t77ZXPqTERvcbS0KMZ
         xvk8S5Q5ti8KOSAkytYrnRGkGFms++nyxrMZNwRaGHAIHMwVgh4j36TcNEjLoY50vbAK
         W25g==
X-Gm-Message-State: ACrzQf1XoBPNL9Tq+5Q2zY5zMPzExnyfESuOytT+MtrOdXvH5+0dyvRI
        dj0n46h3qZ5yxZBDqT2c5ZdiWE6dVB3XCk2GpTc=
X-Google-Smtp-Source: AMsMyM6D27JZEATy5T2FVN7CkPYqc3DZZ3t72UZ4+xJ3l/Ca2CUrp1PVhFthT0JgrFYpniP4+IVtzA==
X-Received: by 2002:a63:81c3:0:b0:458:f345:7ff9 with SMTP id t186-20020a6381c3000000b00458f3457ff9mr16471134pgd.378.1665403119243;
        Mon, 10 Oct 2022 04:58:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a2-20020aa79702000000b0053653c6b9f9sm6785613pfg.204.2022.10.10.04.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 04:58:38 -0700 (PDT)
Message-ID: <634408ee.a70a0220.54ca3.b176@mx.google.com>
Date:   Mon, 10 Oct 2022 04:58:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.72-38-gebe70cd7f5413
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 191 runs,
 6 regressions (v5.15.72-38-gebe70cd7f5413)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 191 runs, 6 regressions (v5.15.72-38-gebe7=
0cd7f5413)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =

imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =

panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

panda            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.72-38-gebe70cd7f5413/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.72-38-gebe70cd7f5413
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ebe70cd7f54131bf594f842a69d363a9e2812d67 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6343d744888e7d66a3cab643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343d744888e7d66a3cab=
644
        failing since 150 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6343d6c0c368dc302fcab61c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343d6c0c368dc302fcab=
61d
        failing since 13 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6343d5583d45896c05cab5f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343d5583d45896c05cab=
5f2
        failing since 13 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6343d62655a4a4b221cab61b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343d62655a4a4b221cab=
61c
        failing since 55 days (last pass: v5.15.59, first fail: v5.15.60-78=
0-ge0aee0aca52e6) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6343d7a11d02207258cab61d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343d7a11d02207258cab=
61e
        failing since 47 days (last pass: v5.15.60-779-g8c2db2eab58f3, firs=
t fail: v5.15.62-245-g1450c8b12181) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6343d852987a89e013cab5f2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-38-gebe70cd7f5413/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6343d852987a89e013cab614
        failing since 216 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-10-10T08:30:55.271558  /lava-7540985/1/../bin/lava-test-case   =

 =20
