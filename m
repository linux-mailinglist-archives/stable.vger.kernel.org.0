Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7289768A635
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 23:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjBCWbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 17:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBCWbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 17:31:01 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E0611A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 14:31:00 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id hv11-20020a17090ae40b00b002307b580d7eso2705596pjb.3
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 14:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PFFn/i0ctvsW+zoGGf5y/T7keNaeX6/+hxinf85parc=;
        b=Ab9SiRz3ZMuL84Hy07iheTigQ99tE6Jyb1ksN12f4rTj4XlLdp4YejS44z7/wPV9WV
         /CkYTzGt3A23vtBVw8BouIdmzIPfAr0EapN2AwK8bS8q6A8yLF3GkAtdRmP+uWl7C546
         wSK9e2RHhOfnLDIsTKzmu223FGwC+9s9utKasjLqo+7nDTaS6TiPDFJ3zXyoAU9da+E7
         nNn9i3ZVCnmpZGd+MInZmEu2GNFGQDLwvIc9PICUdo+ytMWQUibtcz8LwbiVN+qPHJ33
         EbV4e5q3973WgkfhbJZX3Vqt/1o92revOucBK/QYJjXIlIq1qYZvn5N73kHF5/fU/oiZ
         nImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PFFn/i0ctvsW+zoGGf5y/T7keNaeX6/+hxinf85parc=;
        b=cnNeR4GnKCpaHIxTsjX4r0JbPu+D3akHpc0F+bPghH14BAlC3d2NZQPZNGtsiLQyFc
         cvl4uGnJN8emM3cahSJSvqzhT1TBdKlMJrJG0FAKYDEdRLZXH2ehDUXVHHYUq47GZscF
         RvkjsALUHvXIVM3fwm+vyQS/vxvOG9/IDZ35nphDR6MT4mnbBaBzRSDEPxmu4sGIkRqV
         jJqCayRY1aFKl7dtkOzvALxn9LFHN9FvlXFXD7zI1ZMUgUREEqWVJZjffFWO2cLbo7L3
         efFeSpTq9QSlMP8kJwNFEE3uyBXCEIH2vXLJ1RkGMssKrZq+nK/e4hon/FvZXxSV9DXJ
         TThw==
X-Gm-Message-State: AO0yUKU/y6tlGuFm3vmiW01eLRe8pREBbwUJHp7g/Jm7JYbh/faxU+Z1
        +jZjRLSXplzG0WxyBaFTWjifKvzwKhZLRg3AqoOT/g==
X-Google-Smtp-Source: AK7set9F49XAswYN+iYbzLa5AU/tbHT9w2KF/4pQJiCNPOwsBoaf8Lo3MbjnKiZ7/YB7db8zX0CgYg==
X-Received: by 2002:a17:902:ea0b:b0:198:a845:fb96 with SMTP id s11-20020a170902ea0b00b00198a845fb96mr12618897plg.20.1675463459165;
        Fri, 03 Feb 2023 14:30:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jh2-20020a170903328200b00198f2407ea1sm1566plb.241.2023.02.03.14.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:30:58 -0800 (PST)
Message-ID: <63dd8b22.170a0220.bb035.0006@mx.google.com>
Date:   Fri, 03 Feb 2023 14:30:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.91-20-gee83b058ad832
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 169 runs,
 6 regressions (v5.15.91-20-gee83b058ad832)
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

stable-rc/queue/5.15 baseline: 169 runs, 6 regressions (v5.15.91-20-gee83b0=
58ad832)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =

cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =

stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.91-20-gee83b058ad832/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.91-20-gee83b058ad832
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee83b058ad8327b0caa3d881c271380d1072fb1f =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd5b0d445b54a5f5915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dd5b0d445b54a5f5915=
eba
        failing since 0 day (last pass: v5.15.91-12-g3290f78df1ab, first fa=
il: v5.15.91-18-ga7afd81d41cb) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd58bc3a073bb444915f4a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dd58bc3a073bb444915f4f
        failing since 17 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T18:55:29.372406  + set +x<8>[    9.978669] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3284458_1.5.2.4.1>
    2023-02-03T18:55:29.372960  =

    2023-02-03T18:55:29.481829  / # #
    2023-02-03T18:55:29.584884  export SHELL=3D/bin/sh
    2023-02-03T18:55:29.585822  #
    2023-02-03T18:55:29.688040  / # export SHELL=3D/bin/sh. /lava-3284458/e=
nvironment
    2023-02-03T18:55:29.689190  =

    2023-02-03T18:55:29.689800  / # . /lava-3284458/environment<3>[   10.27=
5119] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-02-03T18:55:29.791861  /lava-3284458/bin/lava-test-runner /lava-32=
84458/1
    2023-02-03T18:55:29.793370   =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd5792f0b60360c9915ec5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dd5792f0b60360c9915eca
        failing since 7 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-02-03T18:50:34.648899  + set +x
    2023-02-03T18:50:34.649057  [    9.356800] <LAVA_SIGNAL_ENDRUN 0_dmesg =
897654_1.5.2.3.1>
    2023-02-03T18:50:34.756756  / # #
    2023-02-03T18:50:34.858161  export SHELL=3D/bin/sh
    2023-02-03T18:50:34.858487  #
    2023-02-03T18:50:34.959601  / # export SHELL=3D/bin/sh. /lava-897654/en=
vironment
    2023-02-03T18:50:34.959970  =

    2023-02-03T18:50:35.061183  / # . /lava-897654/environment/lava-897654/=
bin/lava-test-runner /lava-897654/1
    2023-02-03T18:50:35.061894  =

    2023-02-03T18:50:35.064777  / # /lava-897654/bin/lava-test-runner /lava=
-897654/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
stm32mp157c-dk2        | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd577d662b6143ec915faa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32=
mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32=
mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dd577d662b6143ec915faf
        failing since 2 days (last pass: v5.15.72-36-g3886958cda706, first =
fail: v5.15.90-215-gdf99871482a0)

    2023-02-03T18:50:15.860734  <8>[   11.586342] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3284470_1.5.2.4.1>
    2023-02-03T18:50:15.966544  / # #
    2023-02-03T18:50:16.068672  export SHELL=3D/bin/sh
    2023-02-03T18:50:16.069059  #
    2023-02-03T18:50:16.170785  / # export SHELL=3D/bin/sh. /lava-3284470/e=
nvironment
    2023-02-03T18:50:16.171380  =

    2023-02-03T18:50:16.272879  / # . /lava-3284470/environment/lava-328447=
0/bin/lava-test-runner /lava-3284470/1
    2023-02-03T18:50:16.273499  =

    2023-02-03T18:50:16.277782  / # /lava-3284470/bin/lava-test-runner /lav=
a-3284470/1
    2023-02-03T18:50:16.344736  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd56268944d6ffdd915eff

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dd56268944d6ffdd915f04
        failing since 16 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T18:44:22.444598  + set +x
    2023-02-03T18:44:22.448680  <8>[   15.992468] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3284335_1.5.2.4.1>
    2023-02-03T18:44:22.568853  / # #
    2023-02-03T18:44:22.674444  export SHELL=3D/bin/sh
    2023-02-03T18:44:22.676231  #
    2023-02-03T18:44:22.779580  / # export SHELL=3D/bin/sh. /lava-3284335/e=
nvironment
    2023-02-03T18:44:22.781085  =

    2023-02-03T18:44:22.884556  / # . /lava-3284335/environment/lava-328433=
5/bin/lava-test-runner /lava-3284335/1
    2023-02-03T18:44:22.887299  =

    2023-02-03T18:44:22.889518  / # /lava-3284335/bin/lava-test-runner /lav=
a-3284335/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63dd557659aead6eb4915edb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gee83b058ad832/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63dd557659aead6eb4915ee0
        failing since 16 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-03T18:41:51.196564  + set +x
    2023-02-03T18:41:51.200762  <8>[   15.981655] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 247393_1.5.2.4.1>
    2023-02-03T18:41:51.312146  / # #
    2023-02-03T18:41:51.414194  export SHELL=3D/bin/sh
    2023-02-03T18:41:51.414757  #
    2023-02-03T18:41:51.516203  / # export SHELL=3D/bin/sh. /lava-247393/en=
vironment
    2023-02-03T18:41:51.516872  =

    2023-02-03T18:41:51.618406  / # . /lava-247393/environment/lava-247393/=
bin/lava-test-runner /lava-247393/1
    2023-02-03T18:41:51.619106  =

    2023-02-03T18:41:51.623834  / # /lava-247393/bin/lava-test-runner /lava=
-247393/1 =

    ... (12 line(s) more)  =

 =20
