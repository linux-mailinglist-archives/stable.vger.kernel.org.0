Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EF456C5B1
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 03:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiGIBU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 21:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGIBU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 21:20:26 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15E3643F2
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 18:20:25 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id g4so365234pgc.1
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 18:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8bOMJiF/tUVZYkdPSAwnIWUdZEwrSTEy/j1G9reEBkc=;
        b=G5/jmvHeMWQDYulQ/Kg9Q2bZHQgmf83kc9ycvf2NqvN9nc3Lu6Thyqy8omUineSHtt
         AU0E8q7Rt5fTvHHqEqgwwZcWhQZIU3FsrCuyleN8qR+DoH/bmgDU7VbUovg2fwhtXj4L
         JpFvzE6IElz8Nvt2rSYZ9rNzxogwvJqEuPF4jGuq3ZrwRCVuojaWi3GOhh2l2rEiUd8l
         /rVvGgGAWKs2YAKK14MTGpfbdPhyrHksZmrVHiBzKlViWTNZPa/wuvVYvzw3VcWfnjH3
         g1gds88inezA5u6IiXccSpwGXtrcCVkn9WNhVhc+fLRcP2CaZyDUGJwAlCPFKCVTxbp6
         XIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8bOMJiF/tUVZYkdPSAwnIWUdZEwrSTEy/j1G9reEBkc=;
        b=31VdnkeG17YP345ZHs2PihzSz9XcAlrUujCo8ww33B1xmeIggjE4HaOcwT0BXKoMy/
         Xaj5iXHAYU7+7/YW5k1DQdc7Pwyu1eS9UBAsWJZbpqf6VfhGJfnRKSn1KYGDajM3EcPg
         rOthn8U1Wr2pYGDiQu2ZL5U6d0nQhFAzXutqNe3UC6VDFbEKlZOv2pdbVocCP1LfLMcq
         vnR5IWoqTsd4v7gw+vX9yqsYLXkukmLkt5zo3f4bTz4YY0go4oe5zHnAyFUYs1K8kUth
         gfNJQdw+gZqwNaeJT+bCLvGHveeHYNhcGT+MY64HQvOVv6jNhu7PRjKusqkSQegi5HOx
         BbIg==
X-Gm-Message-State: AJIora/R8/x/4ANP4PkT/ZPSrHsqRufJ1b+FwO80D2iTK0KGwJafL9fP
        pbRDx3jcqsr7AZAe3ljiI1vknf8RFhR6N6gY
X-Google-Smtp-Source: AGRyM1uNdvU67mCIz+Klhyyvvy/dDXsgU/UnKfA6clNTAQ1vxOBGbCcP2DMKpU/28/fUE9pNplankw==
X-Received: by 2002:a63:4e09:0:b0:412:1ba3:672a with SMTP id c9-20020a634e09000000b004121ba3672amr5812937pgb.597.1657329625334;
        Fri, 08 Jul 2022 18:20:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h63-20020a628342000000b00528bd940390sm207925pfe.153.2022.07.08.18.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 18:20:25 -0700 (PDT)
Message-ID: <62c8d7d9.1c69fb81.af6ef.06ed@mx.google.com>
Date:   Fri, 08 Jul 2022 18:20:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.53
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 134 runs, 2 regressions (v5.15.53)
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

stable-rc/linux-5.15.y baseline: 134 runs, 2 regressions (v5.15.53)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.53/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.53
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb18ccd146339b58faa47c1837f1b61ba05a1acf =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8a367c6a7cf351ca39c4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c8a367c6a7cf351ca39=
c4f
        failing since 57 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62c8a55790a0e782a5a39bd9

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62c8a55790a0e782a5a39bff
        failing since 123 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-07-08T21:44:34.753523  <8>[   32.846340] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-07-08T21:44:35.778289  /lava-6782861/1/../bin/lava-test-case
    2022-07-08T21:44:35.789309  <8>[   33.882186] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
