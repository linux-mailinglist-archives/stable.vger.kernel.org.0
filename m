Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48B14E6907
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 20:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345568AbiCXTID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 15:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345232AbiCXTID (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 15:08:03 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC0EB82CD
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:06:30 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id b130so3160376pga.13
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pr79+ls5044Sr/tF8z6MFiveRgAwHghjshmxYnZlQjE=;
        b=MELz8rzTxw0iX70+Im4lRJG+ZB8Rj7RA9UK5z3UZYJI665981nNb7M35ZRgS5EU137
         FAHqSzzWOy562OcjnIl4C7Kso6BPPhW+/8ptDLQWL/zv0+12Zi7XPok723Seq0EWttp3
         CdlD0TukYlh+XVy6SHgeUzjsPhGxKya4dBwPJs9LmPA8/P4x8x6T0onXMjjnbOR43YTK
         j1QwisyFsYMZ2ziL7FggrZqiCqUC9aGmaCGDlVrC3eYbCN3GKsk4cD75sNDlQFx3qXou
         n6Lx36PdBk71+oYtPqzS7ILbBMP+LLc+4Vw6Ma7ATBZxALSrNJYhfITAWGMmmFq4IP3l
         UAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pr79+ls5044Sr/tF8z6MFiveRgAwHghjshmxYnZlQjE=;
        b=mFcNoGSIE9PvfK7fha0x5m/QUKmGenHUBzJ9OZJZBhueWUS1NgqhvuRb2Vpom2yDIW
         q84SHtUrsegb14nS5bSJKl+sJbaZao8nsTmQByLHKAqCU92h25XFiPVkbctNNQl/qBdT
         nGJIxSDgdldUbQBUxgkMAHnWMb5ub3NZuRN4M5fgHedYb8/KYbi07FSLeN6vaoFPxJay
         FtaQXVoeexACYO/JgpZz1v9rpPrqnbnsvOWRK6crRVklj0Pz39Hx+vvgRW+A/l1Vj7J1
         2/ZlwaUObGRRA3NharAp7P6JFqdT5bKZYjfzaSDdUrLA4zaQ+GsCZSXJWrs0PaMa2aBw
         BLqg==
X-Gm-Message-State: AOAM533m/N0NEmHpyBIwjFaC9H1QNtbTRAi71n3kZZJCNlWLMQvz6GIH
        MMZs5ypu5YUr+4X1VHYeyvDeCkO6yz+a7ODTjQQ=
X-Google-Smtp-Source: ABdhPJzA5htv2L5OHTgbMfQpDLsL03oqCfoWDZB2Ks6zR2IgsBxTH+rJg9ytkvLCZgDfEWe1LtC4ig==
X-Received: by 2002:aa7:8d88:0:b0:4f7:a2f1:8e77 with SMTP id i8-20020aa78d88000000b004f7a2f18e77mr6211954pfr.48.1648148789715;
        Thu, 24 Mar 2022 12:06:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004faaf897064sm4155614pff.106.2022.03.24.12.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 12:06:29 -0700 (PDT)
Message-ID: <623cc135.1c69fb81.28cae.c282@mx.google.com>
Date:   Thu, 24 Mar 2022 12:06:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.17-2-g6b71a4160ddd
Subject: stable-rc/queue/5.16 baseline: 62 runs,
 1 regressions (v5.16.17-2-g6b71a4160ddd)
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

stable-rc/queue/5.16 baseline: 62 runs, 1 regressions (v5.16.17-2-g6b71a416=
0ddd)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.17-2-g6b71a4160ddd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.17-2-g6b71a4160ddd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b71a4160ddda806ac2b6b025a160986c926fafc =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623c94b97950bfd95a77250f

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.17-=
2-g6b71a4160ddd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.17-=
2-g6b71a4160ddd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623c94b97950bfd95a772530
        failing since 16 days (last pass: v5.16.12-85-g060a81f57a12, first =
fail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-24T15:56:31.183622  <8>[   32.435503] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-24T15:56:32.205682  /lava-5940632/1/../bin/lava-test-case
    2022-03-24T15:56:32.216770  <8>[   33.468288] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
