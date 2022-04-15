Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63402502AEA
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 15:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbiDON3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 09:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352499AbiDON3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 09:29:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD9772449
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 06:26:34 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id bg9so7268677pgb.9
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 06:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4VPNv2E80aVkGN3gttPT1ZnUi7Hg+dthL8rcgaHdhuI=;
        b=zSvsMzrV5EiNqI93Lit2zTg7qELV8tsZoFZvSl7eoQfZ+FLmTtWcUaICIC36nIR849
         qNCh3DLlYDvsz+0ZfETjikla7K4BVly83YLREK+60NV11qzPKEWI0ozoWv5afmlAfdrk
         mBWZCJKEBQ2lqXHrI4LQqaJXVFHmZ4Ncf2+zREwCZNkd+4DwSQV+LMA4jGmT/dX8vZNu
         MUBncufuubw1BWwtcqXowVTNPwJVHZU6FWcWzy3n6QAEXuyObLB8UojApTLnQ1fVH5qI
         M5t5VklncI7qP2t3okj9gcXpKHTJjFKRgZ8FM6b9iZ95hCo3o6RMg0Z6TnqdMSzn/w7o
         W1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4VPNv2E80aVkGN3gttPT1ZnUi7Hg+dthL8rcgaHdhuI=;
        b=iaKBD6eLq5PV7hVGD9Rjy5GUGbmVH2wZHQvLg17vOU+bUFEV8dfwq6Ib+bujD8iZ4g
         jEyzJh2qk4VEhgbeoYHON0xq1c633rSZTzO1X9b79tKheX6OufVT1kmnclqwjcOjEKnI
         n7jh6btTOp1YG2r3jQA82WsuxjMvhcT5Mn2C4RsVkzE3uBUAgFapDkXtWsfU3PrWgH1q
         WBf8k0NrErMUel5Z9MxAhXpmwNWwA74rO5LjSaPPL0XwSo7HEWPjNWRUUuNV9BqQcDEU
         WcH12v27tSMwNggdeITOy2AwVjavFsasvGdC0FnjCSg7w4XXRxlrF7GOs5jYZC+kpI48
         igxA==
X-Gm-Message-State: AOAM5318mbJuvB0Y5w14gzMUGdb4BB89XS9P5XBOZJprjZZQMrDux7XV
        7R1gOgYbaGZRGOsxqF35ojktpz/TQ+vcUf1z
X-Google-Smtp-Source: ABdhPJyWoGzFZ86TMZpZgTMQMVGttxhTdOoUKwCYCAU8Zm6rOBLyYKvAIx8xpqkzrbtyAXhlZM3Bug==
X-Received: by 2002:a62:7b58:0:b0:508:1ec9:4908 with SMTP id w85-20020a627b58000000b005081ec94908mr8815366pfc.31.1650029192989;
        Fri, 15 Apr 2022 06:26:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kx3-20020a17090b228300b001cb7ed57660sm4754111pjb.52.2022.04.15.06.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 06:26:32 -0700 (PDT)
Message-ID: <62597288.1c69fb81.d79fe.d036@mx.google.com>
Date:   Fri, 15 Apr 2022 06:26:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.34-11-g069d3f023b9fc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 143 runs,
 2 regressions (v5.15.34-11-g069d3f023b9fc)
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

stable-rc/queue/5.15 baseline: 143 runs, 2 regressions (v5.15.34-11-g069d3f=
023b9fc)

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
nel/v5.15.34-11-g069d3f023b9fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.34-11-g069d3f023b9fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      069d3f023b9fcb138d938c0717248c599726d1c2 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/625940764d362aae19ae06aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
11-g069d3f023b9fc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
11-g069d3f023b9fc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625940764d362aae19ae0=
6ab
        failing since 15 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625948d33eae298825ae0689

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
11-g069d3f023b9fc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
11-g069d3f023b9fc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625948d33eae298825ae06ab
        failing since 38 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-15T10:28:07.184550  <8>[   59.482221] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-15T10:28:08.215016  /lava-6096657/1/../bin/lava-test-case   =

 =20
