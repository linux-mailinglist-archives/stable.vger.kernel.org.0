Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4B35F954A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiJJAR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiJJARF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:17:05 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EACB68
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 16:52:47 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 78so8994746pgb.13
        for <stable@vger.kernel.org>; Sun, 09 Oct 2022 16:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=W/vjhCBDhW3tHWa1+eSOS2YwWicC18cRR7t0HzEfgbY=;
        b=R2DPqXMkSevOnRRFIo61n+sNQh/611CJS9XxtjOgb3dyjQ0hsh0gj8fbr/4q9kl1eC
         L+JMviX8xNHYJILyScuHWqRDXo04GoMMWZRHXhr8981knP85GIk830fRVehx5fXfi5vh
         lkOcCMMq1wOEBFARiqc181qW1l6R815UYXPasfrYMP8NU4V24bWuLznGylYqbisbv2jw
         LFiB6T7UOBfqCAVFwiYGwOvc4B6iS/Dv6D5D3lNv4/isv6k7FPdvk6Xw81vcFDnDYm7P
         18Io5Uc/pOL+sHVBS7WKp/r1ZaniptBCKjtIhqNGBHzvIRc1nQIDXvclCJFaV+m0HThU
         Myrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W/vjhCBDhW3tHWa1+eSOS2YwWicC18cRR7t0HzEfgbY=;
        b=n9eT4kZ/EJW4Zm5GngxACqANijnsqxFG0ZnnCcyno86vyFKetRNyMA3vKkqk90IKCX
         2mDYmRYdlA37GtdpnPMFIDC+y2ghO9UhRISaUWA/FkOXhko/T6SIpqZrPMPbDkJAFijc
         NW64s/bOZ3UNrRMpDMn2p8zkLNSoEwIBpwZueFlkB26WNYMq+JNuNkCBa1flGtQDiQM6
         2wYeHPrU/sXROQKBVsYE+5r3QzlWVhbFk90OYqMRcBGA29nCvjqDf4xaFqTm8Y1s1CUM
         BFCwQWDmywfdZSV+62Ig7OcUzZ0e+fey8mRm1w8wIZ6qdbCTOLoENzcal6mI805MNlk9
         zC9g==
X-Gm-Message-State: ACrzQf3FmMrBi1ZYPkv0h1TKG7ODrX7b7/5/1ZbX/P+aJ5GPV0LZHEDk
        ejFhZL0tHVcSZFsUHMUKw2iWg8QYBX3ZSpVEBTQ=
X-Google-Smtp-Source: AMsMyM4DAV9+0+6uy8xa9M2/i2jw1tko+jd/YWMzPtePuBfzPwp7oTMX3ovT+RaqsgNkivXSrU11Cw==
X-Received: by 2002:a65:6148:0:b0:458:88cd:f46 with SMTP id o8-20020a656148000000b0045888cd0f46mr14211395pgv.303.1665359566462;
        Sun, 09 Oct 2022 16:52:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s10-20020a170903200a00b0017b264a2d4asm5251883pla.44.2022.10.09.16.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Oct 2022 16:52:46 -0700 (PDT)
Message-ID: <63435ece.170a0220.da066.8914@mx.google.com>
Date:   Sun, 09 Oct 2022 16:52:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.72-36-g65c395d4451cf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 194 runs,
 5 regressions (v5.15.72-36-g65c395d4451cf)
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

stable-rc/queue/5.15 baseline: 194 runs, 5 regressions (v5.15.72-36-g65c395=
d4451cf)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.72-36-g65c395d4451cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.72-36-g65c395d4451cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65c395d4451cfa584571e1b842c90df91c1b4568 =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63432ca5e5d353cdf8cab601

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63432ca5e5d353cdf8cab=
602
        failing since 18 days (last pass: v5.15.69-17-g7d846e6eef7f, first =
fail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63432e88333e488289cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63432e88333e488289cab=
5ed
        failing since 14 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63432ff0e4bc4ad43acab602

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63432ff0e4bc4ad43acab=
603
        failing since 14 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63432ed8f7fb19f04bcab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63432ed8f7fb19f04bcab=
5ed
        failing since 54 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63432ce42ab5772276cab616

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g65c395d4451cf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63432ce42ab5772276cab=
617
        failing since 47 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
