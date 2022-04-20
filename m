Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED26C50922A
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 23:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382567AbiDTVl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 17:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382572AbiDTVlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 17:41:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C24638D9A
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 14:38:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n8so3011547plh.1
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 14:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VytmDXgBeGFsnyL7ZqAHkT1HToMjYOSkI/p8yDfx/6o=;
        b=hDDA/pM1OJ+w+QPU7XLlF4Acad8trNkPmmoEF8GB+3SulP6/rAuu/v9H9m0rJwT8Kr
         DqksdnS1Fyhhgv12Hd7K1EYtDbZeqrbD4dp46mVIO1YSUi79BqACfc7H/DPrGuCqPCLu
         0plpuS7dZmGwBsPVgLvZW8WVNzGBssrHQlCS+us7DmS73v2e5nNaG55kx3C44bmWGF7Q
         XW1R8bLME5Dd2Iov6bP5c68i6JRJ4faljkRWsht8WRI3sZLhAuxr9t5+t9tQyXIGNKHk
         gCMwnq1sg9r5GATRLf5QxLsKJyL0X66d1Zn84TTwmUUUBhoSxScysDaTAmdDSbHbc+At
         wsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VytmDXgBeGFsnyL7ZqAHkT1HToMjYOSkI/p8yDfx/6o=;
        b=PuJK2b1a5mVNABsknquYp5NYsPfBksa9KBQj5xplw22iDdyg3dA6K4LF/Srhn2Gh6g
         R2M2s2BOXNEDR+D85z4O+XQs7I6Tiy4E53bPIjXJUbwSpCwxEfYO+7g9E+FGc4GcI4O1
         QotbgG0ccxAr7FOnPjxl0FEA2QD3WwvyCEfWAvkk9w/TnMTO+v7q7gU5Hfa08PkV+Zx6
         xhpUAhjXf82kAhcRuXCGvrPYq4HyFuki4eK7i5qee3Zw9clpZNE7w869Lv3KrBYlytRg
         y2y0wceqOFLFLRhJ7nXL8NSrxlU8G+YQTastldperesIExAzt/Mhr2DrNftrIgPglNks
         49bA==
X-Gm-Message-State: AOAM5307cEgBhcqGc/aMEspZ/4xG4Ux1e3YemXOqalaQhR09OcC1sjbX
        kFYT1R117JPvyo8e0RG3xrburgxaLmomPaZ67hM=
X-Google-Smtp-Source: ABdhPJz0R3zYFNt/Ayn4Rf12ow7fJgSG9EqYJRg97bvNoouQyB4KalMyDXyFHkdD0/sWyJpgjFCppA==
X-Received: by 2002:a17:902:c944:b0:158:de4a:6975 with SMTP id i4-20020a170902c94400b00158de4a6975mr22128510pla.131.1650490713589;
        Wed, 20 Apr 2022 14:38:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10-20020a62d44a000000b0050ad4053840sm458597pfl.149.2022.04.20.14.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 14:38:33 -0700 (PDT)
Message-ID: <62607d59.1c69fb81.cce33.19cb@mx.google.com>
Date:   Wed, 20 Apr 2022 14:38:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.35-5-g3dd53da69cfca
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 68 runs,
 1 regressions (v5.15.35-5-g3dd53da69cfca)
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

stable-rc/queue/5.15 baseline: 68 runs, 1 regressions (v5.15.35-5-g3dd53da6=
9cfca)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.35-5-g3dd53da69cfca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.35-5-g3dd53da69cfca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3dd53da69cfca7100e32f685313c551a4f2d9225 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62604b7526109e682dae06b5

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
5-g3dd53da69cfca/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
5-g3dd53da69cfca/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62604b7526109e682dae06d6
        failing since 43 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-20T18:05:21.622871  <8>[   32.645004] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-20T18:05:22.643774  /lava-6134445/1/../bin/lava-test-case
    2022-04-20T18:05:22.654846  <8>[   33.677514] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
