Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20675425D4
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiFHEj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 00:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234239AbiFHEj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 00:39:29 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B6C401BFD
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 19:31:06 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x4so8558376pfj.10
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 19:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9ivvlvXAp7hG0tq0JlKUBW5+RPLBZz2wjF0qUqBcPtM=;
        b=pcJqeur3SbVtgz1Qvfxm/qL9KEK70ILp3vzcX73N5ZkH9t2ojoxhm46QlNengzxNjK
         nJwWSa60v1bEchcZl3TieL3NW1ydqXRH5cw0HEHPjJAE/Uxgze0SwFDdA7izUDPubpwX
         SjM45Qa0TPVGTqmi+AgP7p5JT+Irn5O/Ct1Lmxp/MJuA4D+LeJGbcU9AeRw5+k811zvr
         34vg8uERDwi62JyTXYsFwAGk8LrJwchEKPYlxpyk80hpaNteLKVsimHL+gbK+3aG5vzl
         jLq3srNHIXBNFbHq8zu5qbm/K7+hE3FcMh/2Etuv19s+0AlwMCguZYjiybJ2yFAhkgDr
         t3WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9ivvlvXAp7hG0tq0JlKUBW5+RPLBZz2wjF0qUqBcPtM=;
        b=Du3tNz4H65CXZuYyh061og2ic7I7B4SeMA+5/PZLRbKsU/AZ58b9t/uSWFKTJprvE9
         On0jwLkfQ8v/buNEocOfhwytqo8uLoq8ZND1DfG17NS673lKuwZudBtbFZ1/JJjyYx0R
         8bqbXpZ4wAoh0c8aNcang7aI3Pphu/U/yoRNKJqPm9V/x4UWC4JzdQpJbydUwDoMzXzW
         D0zsDUaUZO/V8JmmAEScqX0tDQglhOcBB/2xXcXCUBmfzVgezm14BjgY6V6wqpOFcc02
         TuKhSMRTo8WSmOSTm3q4d3Qi0u1CqEMK4EkKAt4JKXsWZ24ihZyBS7wx+qQvLhh9qpGD
         IB2A==
X-Gm-Message-State: AOAM533Ud7WMIkNQiKMU8twUn8N4H5tf4HvOAvEWeJpEPAY2wplGtpLa
        4D8/yYxWPyhKaHfCgOUT3PmjeXyDeBMxMh/+iRE=
X-Google-Smtp-Source: ABdhPJx34iugknluZ8sQxFMVBFk7XjiJbNZpmOcFd4Eq4f1+sq1W7RHqMfAtqmM9dCK20rZCv6+LUQ==
X-Received: by 2002:a63:1708:0:b0:3fd:8a03:dcd2 with SMTP id x8-20020a631708000000b003fd8a03dcd2mr14767908pgl.556.1654655461710;
        Tue, 07 Jun 2022 19:31:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e63-20020a621e42000000b0051bbb661782sm12821516pfe.192.2022.06.07.19.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 19:31:01 -0700 (PDT)
Message-ID: <62a009e5.1c69fb81.53f61.be1f@mx.google.com>
Date:   Tue, 07 Jun 2022 19:31:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-668-g53f46ca17ebdf
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 130 runs,
 2 regressions (v5.15.45-668-g53f46ca17ebdf)
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

stable-rc/linux-5.15.y baseline: 130 runs, 2 regressions (v5.15.45-668-g53f=
46ca17ebdf)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.45-668-g53f46ca17ebdf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.45-668-g53f46ca17ebdf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      53f46ca17ebdfbda0ddab0ba7aaad7c9b2493f02 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62a003aa24229fc589a39c1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-668-g53f46ca17ebdf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-668-g53f46ca17ebdf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a003aa24229fc589a39=
c1c
        failing since 15 days (last pass: v5.15.40, first fail: v5.15.41-13=
3-g03faf123d8c8) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629fd4c4f00ffbf5fea39c16

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-668-g53f46ca17ebdf/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
5-668-g53f46ca17ebdf/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/629fd4c4f00ffbf5fea39c38
        failing since 92 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-06-07T22:44:00.861534  <8>[   32.655280] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-07T22:44:01.883369  /lava-6566712/1/../bin/lava-test-case   =

 =20
