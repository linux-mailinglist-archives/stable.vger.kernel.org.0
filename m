Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0025F5716
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiJEPFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 11:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiJEPFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 11:05:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FBC10073
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 08:05:03 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id o128so3376421pfb.4
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 08:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=xU7N2tkjlh5Y+ju/Oo/wD0/YxFh5P+3rtAWATpL4MX4=;
        b=oyIKURuqskZ5vxcXvGgRteEigLjERhU3QZRtquB8lhGibfjY2I7ixJIe6DVMStkkB6
         /aIGC9KgADwpjBQlUWuVGOHhSBeIKD6jjV95KdD3sJ75DxCuKAI/SbTlTuv23G8Z+Zbu
         b79CmXuM3Cn6lTXBVBsrnU7BoJz6/yYODfImlZvKJwWYkCSkqoVrfFu1kYcJWfThMN1x
         bGKLLBjI+fqRKGPhMWAoIQ5qJGRGcfXtiTIi7kqdJTN+vW/RTggk74tHrQnCGUOo9keu
         wY80clMyf83VfUx9IodiaQySw6Qxt48oZvH2HpymMt0RvtsEebOXV56hK5Jq2Ef+d/7f
         4/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=xU7N2tkjlh5Y+ju/Oo/wD0/YxFh5P+3rtAWATpL4MX4=;
        b=GmqIYyYmzooHo4FvVNIcGRtMJOpEdfBt6x7MGH0SnKuHs4DJaeDUQG5xVlXV1Dk7mz
         iBVSQV9dVEzt+C5u18JJbIdcnk7cg1HPHoSsGRiVuZj8FuVBhw/r00ZvAka0A+ZaVicv
         d+IQDa0Sy0olKc0bJoUzPJuwop1rAP8peqFsKa/eq8SwIaE6nkKNRcNJ0kYkL0GAfhUa
         /zlG0FHlPRAr2cteIGLsGSRdIxCoUVUTEBwJESgpi44MKSWK41dlIldMRhvFhfuZM7Gm
         xhMR/a6Y5LgFJiMZ7cr7LhcjOWHoGlzhOvTc8e90hGSeYBFEcAMqAZqnqRz+PGwPn4BR
         yDMg==
X-Gm-Message-State: ACrzQf33V+I9Sn4SrAN0Yx5KJjVJH2aIXXkHtbC37j8nu+KHW6tRnx9D
        IiiJs9d2qOodLodIxfAJ6gplwxxQOTf8JRwKlCM=
X-Google-Smtp-Source: AMsMyM4qZhFZy33RP1N22YmZhr5XUmUKWKBqeg8iDiHrMnRyjX2WvbCKwTI6KUtL4nVlKRFSVkXopQ==
X-Received: by 2002:a65:58c8:0:b0:438:aecf:5cc8 with SMTP id e8-20020a6558c8000000b00438aecf5cc8mr257464pgu.18.1664982303009;
        Wed, 05 Oct 2022 08:05:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g145-20020a625297000000b00535da15a252sm10972738pfb.165.2022.10.05.08.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 08:05:02 -0700 (PDT)
Message-ID: <633d9d1e.620a0220.d02e8.30ab@mx.google.com>
Date:   Wed, 05 Oct 2022 08:05:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.71-70-gda5ba601cd935
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 123 runs,
 5 regressions (v5.15.71-70-gda5ba601cd935)
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

stable-rc/queue/5.15 baseline: 123 runs, 5 regressions (v5.15.71-70-gda5ba6=
01cd935)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
imx7ulp-evk           | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

imx7ulp-evk           | arm   | lab-nxp      | gcc-10   | multi_v7_defconfi=
g  | 1          =

meson-gxm-khadas-vim2 | arm64 | lab-baylibre | gcc-10   | defconfig        =
   | 1          =

panda                 | arm   | lab-baylibre | gcc-10   | multi_v7_defconfi=
g  | 1          =

panda                 | arm   | lab-baylibre | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.71-70-gda5ba601cd935/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.71-70-gda5ba601cd935
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da5ba601cd935941e4075abf6b4a9a3bfe9519a0 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
imx7ulp-evk           | arm   | lab-nxp      | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/633d6c5f63a1bc2651cab5ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d6c5f63a1bc2651cab=
5ee
        failing since 9 days (last pass: v5.15.70-117-g5ae36aa8ead6e, first=
 fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
imx7ulp-evk           | arm   | lab-nxp      | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/633d698eba8ed0280ecab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d698eba8ed0280ecab=
5ed
        failing since 9 days (last pass: v5.15.69-44-g09c929d3da79, first f=
ail: v5.15.70-123-gaf951c1b9b36) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/633d68a9cf4be35fcccab625

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d68a9cf4be35fcccab=
626
        new failure (last pass: v5.15.71-70-gdc2f8bdb310ce) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
panda                 | arm   | lab-baylibre | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/633d6e12115f5de984cab603

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d6e12115f5de984cab=
604
        failing since 50 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
panda                 | arm   | lab-baylibre | gcc-10   | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/633d714798a348808dcab601

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
70-gda5ba601cd935/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d714798a348808dcab=
602
        failing since 43 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
