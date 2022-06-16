Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2BF54ECB6
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiFPVjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 17:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiFPVjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 17:39:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602775C651
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 14:39:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so2570599pjg.5
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 14:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gMkzdDf70kO+F9yZBTpiVW2R4iDVhRcDocwJ4MiB47Y=;
        b=vcSGwSGsVbBuoAgDuwNkAGdj35o58fftcDWn29KNAgvOVCmB71sSapCRzLtwzYTzAo
         KUv6qYoHH0cKX7PON/yi+P7HZEP1VvuNQgxyrxmYW1TVdwWlxbXuoep/zlgzbWX9TLL1
         /H7M2Fi8Ei7xKlkUSqswXzXGDY2MZ8CiMtuj3uLiDLqNzmNnmJBX02io3Izxh8gyMgaD
         rMfLpAOR/ZOgB92ulR9RDmM8euje9dXWUWhfQFC6GmtHIeQxUS6OfskAv9Y2dNcbq7e3
         zHilbjxZApJBhEMhslymgJEhF0+Vlh1gyw/qKX63ATgoDEhbp3WewgLrSL9yu0jaIzbe
         hORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gMkzdDf70kO+F9yZBTpiVW2R4iDVhRcDocwJ4MiB47Y=;
        b=SGAyDLqPoj7o183kHw6xIVurlne8qAmR6MkQxErYR0q8OdhDz5tpgdgBUGt30Zray3
         8IV6tiIMlkeo1/YuLlhDcFgmuqj6qhdo9xXJ5Nd2I5/LKklKGEUqiA0DdfXpsPuiGbfd
         2YAxmKTuJhuhpMcQK/vU/oqSsL/DAPZlNCu4+8ZtLs9fYpdOhwcxEpuJm/cGTy4u1L9b
         45c/ueIWLMXsy5+KKtGUx0OF7VM6OnDuyp5oV6nmdlogW08UuCGAITROrn+rzhoE/zWz
         E+i2io5h8X//5s46tJykIWWIAZ+AXxC1OnzmKmp+etpxou0XlgqdHk6Y1gvpFjhzK8Rp
         Cpvw==
X-Gm-Message-State: AJIora9Bh1pFaAB4jvFudQSGxwglT6wuv7CCDT5QnLFBut1KbL7SxWrx
        iinqHKwHFPOKX/UdFuSzfglWHcRca8W1GL7IRYA=
X-Google-Smtp-Source: AGRyM1vywB2bgggfcZYjZNZzsqaT+1QVRCbeQQ7LiT28gNypdGg9BmOzNV28AD0llKdyBLh7ycS+cA==
X-Received: by 2002:a17:90b:1b07:b0:1e8:41d8:fa2 with SMTP id nu7-20020a17090b1b0700b001e841d80fa2mr7053256pjb.204.1655415546702;
        Thu, 16 Jun 2022 14:39:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902bd4900b0016782c55790sm104509plx.232.2022.06.16.14.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 14:39:06 -0700 (PDT)
Message-ID: <62aba2fa.1c69fb81.adc16.030d@mx.google.com>
Date:   Thu, 16 Jun 2022 14:39:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 141 runs, 2 regressions (v5.15.48)
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

stable-rc/linux-5.15.y baseline: 141 runs, 2 regressions (v5.15.48)

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
nel/v5.15.48/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.48
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1dd58c995daf8b632344b61df9d3cbed26454dc =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab700939de04a197a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab700939de04a197a39=
bd1
        failing since 35 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab6c98bbd350ffe9a39bd4

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62ab6c98bbd350ffe9a39bfc
        failing since 100 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-06-16T17:46:44.198835  /lava-6631698/1/../bin/lava-test-case
    2022-06-16T17:46:44.210151  <8>[   33.542465] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
