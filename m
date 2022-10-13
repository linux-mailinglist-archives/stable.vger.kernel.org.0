Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362465FD330
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 04:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJMCIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 22:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJMCIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 22:08:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE26F0341
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 19:08:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cl1so599674pjb.1
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 19:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zfBkAXMCQW+fN/qmfuGlA8bFvcihuM3KPM33Zg8gHCc=;
        b=HSJ3S149acaP9CwqLNMCa5NWW9dlYsLjLKw0b29/YWBlDXwI26xNbF0XBhynaFbUc0
         u37PK40/JZX1/jk1UvAfl9GOwhIsqyUacFpwmWF2/QT7Z4GmPxPic7zVf+PfueVD8hc2
         Gwk6WXJsPGY8d5x/RhLFH372IeisB1lPGonTKXz4sLQ71GJC78rdfRcf+TvLh0L8xhF7
         0RtrEnBUJQ0qgElFow+v4Aj/DIwJn0ojjO+nMT95InxTkbRuy9VIvRtK7JNhYJwlvDux
         mFI4clTVFX8tFBtJ204HjQ5wz2SaeBXzz8JjyuXzKaoAfv8ygUF6eNyJl6wogW+QGmtt
         Rckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zfBkAXMCQW+fN/qmfuGlA8bFvcihuM3KPM33Zg8gHCc=;
        b=aip+DRjuPOgnr1t4Jy1/u4UW2EcF0U+SgTelW0w3ZninskB6pgv5aeMESS/IzRl2HG
         4jBJWVRiu6YJEByni6YgbJz/qY/QhxexU4NpSMDk3azFxqNjCdwVeTTWhejzlA8r11HL
         Art5yVz56McemQ85bb7qimexn1vwRqKSpuFjrXcI/y7fI7pr9LR6AXC/Kx+oljTFLWWm
         z807CXjp8G27yUbMY4Hx2rXc8dhZux2cuaIY1IqAqcRqeLdo7qAmwtk5n3ksHS4ukvUl
         gSpIhNqjnFnZrHFYiMXNmB0DlmQLYoCy5WoDDd/WBp3rXcaWh19HAhYZMl6lEHIi8z+v
         IpSw==
X-Gm-Message-State: ACrzQf3B18H4wShnvf3nBgVhL+BVELJTMtrumcILhBBvQ1b4ZRSKOSVv
        e7lrakKCiNoyRxBUN0TaPMcaA2STvxGPzS5r+rU=
X-Google-Smtp-Source: AMsMyM5/VDhBAGRRIhLSWNbN0hZIG+Ht8IeRO5pFSA9GhDhwhGGCQSPDFjByhsCIglySpz9JanTQUg==
X-Received: by 2002:a17:902:900a:b0:178:77c7:aa28 with SMTP id a10-20020a170902900a00b0017877c7aa28mr32727405plp.3.1665626919595;
        Wed, 12 Oct 2022 19:08:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5-20020aa79ae5000000b005624e2e0508sm514369pfp.207.2022.10.12.19.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 19:08:39 -0700 (PDT)
Message-ID: <63477327.a70a0220.8ae97.18a2@mx.google.com>
Date:   Wed, 12 Oct 2022 19:08:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.73-4-g3e267c5d83c3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 117 runs,
 3 regressions (v5.15.73-4-g3e267c5d83c3)
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

stable-rc/queue/5.15 baseline: 117 runs, 3 regressions (v5.15.73-4-g3e267c5=
d83c3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.73-4-g3e267c5d83c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.73-4-g3e267c5d83c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e267c5d83c3e36ae0160d8cdd8a7bb98eed36ac =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6347648b7438783027cab62b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.73-=
4-g3e267c5d83c3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.73-=
4-g3e267c5d83c3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347648b7438783027cab=
62c
        failing since 21 days (last pass: v5.15.69-17-g7d846e6eef7f, first =
fail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6347413344490b6de0cab606

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.73-=
4-g3e267c5d83c3/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.73-=
4-g3e267c5d83c3/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347413344490b6de0cab=
607
        failing since 17 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63474299e11d52192ecab60f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.73-=
4-g3e267c5d83c3/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.73-=
4-g3e267c5d83c3/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63474299e11d52192ecab=
610
        failing since 17 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
