Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D951051B5E5
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 04:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbiEECa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 22:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiEECa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 22:30:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7547D2528D
        for <stable@vger.kernel.org>; Wed,  4 May 2022 19:26:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so6785104pju.2
        for <stable@vger.kernel.org>; Wed, 04 May 2022 19:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QdmfvNKkRhwKo4dxY5w8jKsFBFKLK0gu2FDAmbCVCCU=;
        b=VukDS1b1pwM+GNl8zWVt86vH0rjaFd2U7eZJ8V3JrX2YLq/jhzHR4FxBX+MoETx8Xb
         u1spm+ynb4N6hvyMaEjMXIzKycJlyRXSnWWKrVLQtdBhc1EeO4unQoVxMP7dH+QRIe0g
         Ksn59gJwi7po4+0NOlOh2uWZSBNWEWvs689faJa2pxni49vzQmzmss1UKXNreIpnofi9
         ucURNJLcDSND7zldMd7oFoC2kYsXnS2D+17jEOLnyyLltB2U7UHq+9ULMlp1WZBOFKq8
         /njFMmjjDEzqZG4CD2Z7AAcK0xc104/2cypKO+gaTal4us/ZizPNAWMjjSAGEebmEhn9
         hjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QdmfvNKkRhwKo4dxY5w8jKsFBFKLK0gu2FDAmbCVCCU=;
        b=l/sr5lNYykniP2asMJJwN4dnh8ia/CaKe+prIHs2Oa/ZqjQocMnuQJqm2NZegq2V9V
         pY+NCt5hPXcorVroJWYb1SBKTATip8KPcDk7SzVrDkVOasbdUqMOmmC9ZBlQ5z9N50lG
         zKrKdDlZ3AFUPi5LbtKOKfG3tsfnsqO2PPcdG7g7OuX3/6ihvkYpC2fGh/rAP7TUA40b
         /39vgiclP42+BW+UnATtU2UCF9nx1EL+0+JFHC1mVLAXLBQSHvwAPItb3SOoU5K8MbFp
         wb0EBbSU1+1iMZeRLfaNrBxxFvHPuAKyP5iGg9t98AN9IkciU7PrscehONKpRe2cUCA3
         l2iQ==
X-Gm-Message-State: AOAM5339E9VeR0CMlDywo6TZV57Ava9nnjTJBs4SnWbuCEL9C//34v7O
        uIhT0m+P3Faoa1U2ASFMNabFfKbQ6av5TnMCZE0=
X-Google-Smtp-Source: ABdhPJz9d23fLt/B7CdyRt3X673Nioa3bHtsxjMF8XK8m/Yz1+u2z0lSx1HCHE3mSzljR3RmzKppTw==
X-Received: by 2002:a17:90b:3a86:b0:1dc:228f:6a1f with SMTP id om6-20020a17090b3a8600b001dc228f6a1fmr3250824pjb.230.1651717608705;
        Wed, 04 May 2022 19:26:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s186-20020a625ec3000000b0050dc76281a2sm87344pfb.124.2022.05.04.19.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 19:26:48 -0700 (PDT)
Message-ID: <627335e8.1c69fb81.c73a4.050c@mx.google.com>
Date:   Wed, 04 May 2022 19:26:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.37-178-gc8851235b4b7
Subject: stable-rc/linux-5.15.y baseline: 145 runs,
 3 regressions (v5.15.37-178-gc8851235b4b7)
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

stable-rc/linux-5.15.y baseline: 145 runs, 3 regressions (v5.15.37-178-gc88=
51235b4b7)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
am57xx-beagle-x15 | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =

beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.37-178-gc8851235b4b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.37-178-gc8851235b4b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8851235b4b74c00f49cc1cf05ab6f4a483e978e =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
am57xx-beagle-x15 | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62731dfcf56a8876828f5739

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7-178-gc8851235b4b7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-am=
57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7-178-gc8851235b4b7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-am=
57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62731dfcf56a8876828f5=
73a
        new failure (last pass: v5.15.34) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62731c58f3335e0e128f5742

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7-178-gc8851235b4b7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7-178-gc8851235b4b7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62731c58f3335e0e128f5=
743
        failing since 104 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first=
 fail: v5.15.16) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627306ea1c3717b9b88f5780

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7-178-gc8851235b4b7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
7-178-gc8851235b4b7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627306ea1c3717b9b88f57a2
        failing since 58 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-04T23:06:03.944398  <8>[   32.618595] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-04T23:06:04.967968  /lava-6266723/1/../bin/lava-test-case
    2022-05-04T23:06:04.978854  <8>[   33.653330] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
