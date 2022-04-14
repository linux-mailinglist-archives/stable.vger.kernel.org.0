Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7EB5003ED
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 04:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbiDNCCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 22:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiDNCCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 22:02:11 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFD2240AA
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:59:48 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h5so3463513pgc.7
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qDpBf3NsbFQ6D6g1ZLSq3ZhF30VErMEhgksQJiuy+t8=;
        b=JZOCRSAEUl5DPVCs10jgj9UbqxkKt7ZbaqyHow/iL6Vp2oz9+xOuwYRXnFddrrYIl3
         B2zMTJ7WLwD4N2WqLIsCzTLlcBamF/h83c3U/yvkP8Dyu7egVYwrBEz5UxBS1+6/8PSk
         bg+nZh3pXhVYELSiN/eibPx2auh9yUDUAJ+ySwcbi8NMXxKKpaMuovsRxxvOMk7FUOZY
         kmNXc5xI0NPCZBn9mK5e+5njZUi2YJiiGQCkmiQm2dUWEgSou+6V0B+OOADyDcaWGW9h
         iUmkb2ws+xq0wBqtdI2rCOTF++XoMx7G5XBcIROjHIoA5icdnhq11618yj9MLzILEfST
         mBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qDpBf3NsbFQ6D6g1ZLSq3ZhF30VErMEhgksQJiuy+t8=;
        b=Vq4PpQywFncITGWUBlv2NSuBmrCDdGbq2mb09InSU76AUbAXsiiMr8GA3ExSQsoSc7
         PwrBGhL8L3VAildsuZ/5T2UF/irDCxE0CES36VQRdm/lP2aZwQwcS+aUWQS7wOS4YfAq
         GGHh7fk89GZ3/tkYNuKRUD05C84OZkZnhMnPXY/wWStJlCVcVEPptS/e8hZKIU/QuaTe
         oFeLYwIvGyqIoHk1j+elAROGkXT64UxyBBp6aZBI/QcgRf1tjmRWKw0au8yc5Iwjd+J+
         StGNMU0CFtPZSPGd3DnTz26kplWG6Ptx6UJvd1zwhamyLjCorHRy3Eam3tvKn4dc5ELR
         IBRw==
X-Gm-Message-State: AOAM530tQPS8UHdWwDfTvDLoastJ4KaCefQ+JDElXPjY8vZY4BzUCUB4
        e7XPqlTg1TuKGq9x1wimfH6ouSpepyLXJ4a4
X-Google-Smtp-Source: ABdhPJyu4LGOuqgXHuer+y5OsUc5scZgeh4xHAJ7tPUOyJB9KKlVkgpasour/s7x32uOq7ZqYXztCA==
X-Received: by 2002:a63:24d:0:b0:380:ada1:cd4b with SMTP id 74-20020a63024d000000b00380ada1cd4bmr412801pgc.127.1649901588004;
        Wed, 13 Apr 2022 18:59:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a708300b001c7e8ae7637sm319537pjk.8.2022.04.13.18.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 18:59:47 -0700 (PDT)
Message-ID: <62578013.1c69fb81.129a9.1554@mx.google.com>
Date:   Wed, 13 Apr 2022 18:59:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.33-277-g634c6faa6190
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 80 runs,
 2 regressions (v5.15.33-277-g634c6faa6190)
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

stable-rc/queue/5.15 baseline: 80 runs, 2 regressions (v5.15.33-277-g634c6f=
aa6190)

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
nel/v5.15.33-277-g634c6faa6190/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.33-277-g634c6faa6190
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      634c6faa61904c95344614b8c25fc635f3824a56 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62575070a553a2ca63ae0692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g634c6faa6190/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g634c6faa6190/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62575070a553a2ca63ae0=
693
        failing since 14 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625755e2119c08a79cae0683

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g634c6faa6190/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g634c6faa6190/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625755e2119c08a79cae06a5
        failing since 37 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-13T22:59:36.553020  /lava-6083177/1/../bin/lava-test-case
    2022-04-13T22:59:36.563558  <8>[   33.612443] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
