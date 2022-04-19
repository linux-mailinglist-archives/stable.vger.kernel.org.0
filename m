Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022955076F6
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbiDSSES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238961AbiDSSES (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:04:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE9B230
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 11:01:35 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id s17so5691311plg.9
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 11:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dZPTwJ2Ba6Rdlb3av5ecRL+aYbLnLf/6KtSlWy+FLtQ=;
        b=NpvgchQzGCQNTRcUjkUeQsn0z7F99Q+toTQBLZ1Rq6516Fr6qLHyHi+qY8+8/EbPeY
         jrhQSrC8FYqmypH6nM/bz11euQV2TmZBu+PI8nnDDa4XwFO6w2acIz7DGZCU1j/MtAVN
         JFDBTbJbWpD4oN2koRuxYwBaj8T65TQOZGWlphNbPMCPyzqSzJvCu0Q5KG2LGSuIoKbq
         5LxHm4EIW7BeWeFd/2anS78/+SsjXUHJEaVHV4K5Zyd+tqq7z9EGYCoPndMSawANR+le
         pVvNngQZHoQqCU5YYp9+V1u0QHrpyzit599BzC7MTVZFvB8L8iQimRtPt/2evIZhBzIu
         8IIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dZPTwJ2Ba6Rdlb3av5ecRL+aYbLnLf/6KtSlWy+FLtQ=;
        b=QqBDkMp0NvCBR8HZMwm+hub4I9XmsG45MafeIthcf2/UgvSSeS+j2duOu863EVS0CG
         anuhmf48kRKAqCbZwWuB23UGfK2QQKMwjXqmmVZYT0+9q14ZPq9Snq5WQkLnNWkIQ1dh
         0BheARCAzU1YrwFwRbBeDLpG8zj1GWJ4mnm568VfyDH5PzNIpfiarSMlrYc5OdYNki3V
         DRGPxceoVnYBnnZIKVdUzb1ozlhezPcBlJXWeTBQokheQKO5OjX9KigY2ER0iQ4pLIEN
         De6jpmdTmoWtDrQKmwOPiUV7wRHdRREh9WRSOStfMoP+bEcYnfZCOJ915LkirJE35aKB
         hqWA==
X-Gm-Message-State: AOAM533vxwOjezOITeHoIoedrmzqpJ/iY78PmDZ1rv0Jcukzs1GY0y4R
        I1TI9WBlwc5Fq2u7VDiK2pa38x+Lrj7aMy+8
X-Google-Smtp-Source: ABdhPJzpEGEvsiXsr+H0IBI963jed0eKmS0QmUIMtKwWvZdeMv11IHvNRjoE0Mkd4Xb6zClmdfQqwA==
X-Received: by 2002:a17:902:8a95:b0:156:a40a:71e5 with SMTP id p21-20020a1709028a9500b00156a40a71e5mr16604292plo.144.1650391294586;
        Tue, 19 Apr 2022 11:01:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l13-20020a056a00140d00b004e13da93eaasm17641792pfu.62.2022.04.19.11.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 11:01:34 -0700 (PDT)
Message-ID: <625ef8fe.1c69fb81.4f1ab.9010@mx.google.com>
Date:   Tue, 19 Apr 2022 11:01:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.34-190-g1c064f1350394
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 145 runs,
 2 regressions (v5.15.34-190-g1c064f1350394)
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

stable-rc/linux-5.15.y baseline: 145 runs, 2 regressions (v5.15.34-190-g1c0=
64f1350394)

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
nel/v5.15.34-190-g1c064f1350394/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.34-190-g1c064f1350394
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c064f1350394a38644845cd96a9ee02ab604cfb =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec69207017e1113ae0695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4-190-g1c064f1350394/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4-190-g1c064f1350394/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec69207017e1113ae0=
696
        failing since 88 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec9f4dc03e39a6fae06ae

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4-190-g1c064f1350394/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4-190-g1c064f1350394/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625ec9f4dc03e39a6fae06d0
        failing since 42 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-04-19T14:40:45.872011  /lava-6122290/1/../bin/lava-test-case
    2022-04-19T14:40:45.883847  <8>[   60.890395] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
