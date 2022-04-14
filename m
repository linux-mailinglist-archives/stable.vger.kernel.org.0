Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E0C501A58
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 19:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiDNRph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 13:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245382AbiDNRpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 13:45:30 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276B7E41FB
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:43:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bg24so5770892pjb.1
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BPNkDsZDhr+lgBMBEXmwC2Y3np8vqGoZQXFXL8QS2QE=;
        b=hEtSRpRoTrpIzL899uCAhlsoTzYEoVQW4Na/+CpMXWOaCeOgjxEgCWFfx9CLTwho77
         QA06+QP/hcz16K1DU8+42eNhcdF/OyqOPmHD2O35Uobmw9HnfHx72ztNunjYyYS6eeuA
         eEivnvNA6GAUU/dBemLm1xK27crUOc148XF2ys6XfevBDNytuquwVYNyk3UmdyAkC8FW
         wDRS0qRdS3lfLY5AqN6pkcdj0eE5/uTgZEoxtV5kWa33qSfGrxE/3/12Qizy4CljGRjF
         GG6J6G/bfnysXYwy8/bEOXEeIQgHnxE3J9HZ+YDnuvZSD/O3wLAd5mncTfb1Upcp5thX
         i7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BPNkDsZDhr+lgBMBEXmwC2Y3np8vqGoZQXFXL8QS2QE=;
        b=2LRIXsM3Ya1nbWR85/k5sizeNmD1MsjDZxQYTQJOYHArkNlml3ZfRpeVMX9bNHziW3
         uru1hakbWNUzhENBT3Rt7vIS89MTK0hze7sJDEUbL2etCnBq7fonhFxkpfapKf/fHAwf
         noH6M75X0hsqvQ7eJ7wWrpJ0zTC2ojCTifGYDZKYGBAuKoYYcABAEkUVTumMuOG91B6x
         fwi6hyCjJOqDlqtc1PFYzmaIrbP/Y/Q/BT9yNKBsEb6IATvsYxtZ2IwwlkjuadkYqSk4
         Lm5NACu74Tb69fjz4Q4VfgORdmqEmE8SCC6h5pr6F8bV/9sAzxPvBTSDWb/i+jmGQFl3
         mcDQ==
X-Gm-Message-State: AOAM531p4+37eMsT86zhLDGdyYKc3srDxZbafPb3qdDFFwlG1K7cofV6
        EfW6ISFxup/f8WJMzFOlmKRtBiRYfpfr7aHI
X-Google-Smtp-Source: ABdhPJyO+jkVZxHGnoNaUfMXR8U6DHw2gam6RZTcbfCzckgTmt9dvJMl+z93vsDyG6XHJdvF2R/ejw==
X-Received: by 2002:a17:90b:2247:b0:1ce:6d98:919d with SMTP id hk7-20020a17090b224700b001ce6d98919dmr2840625pjb.24.1649958184476;
        Thu, 14 Apr 2022 10:43:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g123-20020a625281000000b005056c5b7014sm459560pfb.203.2022.04.14.10.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:43:04 -0700 (PDT)
Message-ID: <62585d28.1c69fb81.60dd.17a2@mx.google.com>
Date:   Thu, 14 Apr 2022 10:43:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.34-8-gab0f295ebec91
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 48 runs,
 2 regressions (v5.15.34-8-gab0f295ebec91)
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

stable-rc/queue/5.15 baseline: 48 runs, 2 regressions (v5.15.34-8-gab0f295e=
bec91)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.34-8-gab0f295ebec91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.34-8-gab0f295ebec91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab0f295ebec919a1330edcc119faa1f15d50c6ad =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62582c956816d79d1fae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
8-gab0f295ebec91/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
8-gab0f295ebec91/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62582c956816d79d1fae0=
67d
        failing since 14 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62582ce8f608ce74ffae0689

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
8-gab0f295ebec91/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
8-gab0f295ebec91/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62582ce8f608ce74ffae06ab
        failing since 37 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-14T14:16:44.725329  <8>[   32.650512] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-14T14:16:45.755745  /lava-6090153/1/../bin/lava-test-case   =

 =20
