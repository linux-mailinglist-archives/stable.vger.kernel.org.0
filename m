Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340614D3C4B
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 22:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbiCIVq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 16:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiCIVq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 16:46:29 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7D611E3C6
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:45:29 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cx5so3515677pjb.1
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 13:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6sNkkpNtM5foNZucclMG+NC5U4w09zhnwuJEdGJYSEE=;
        b=u6KPir+7usLOqlHhCWEVQxy4vMJ+TqDq1sLwGtuObTqOh76pbo2cmRMl7jClvKWS37
         hna6sOmFNSGAHzbDyCw4zIGeik5jiXe5Oud2mhiQrGORl+X8kBi0q1qaooT6Z9H2v5bw
         YYmX14ud95o+0nG97K8xLMqgwG1MAwFcGWFysMCOGCyuFBptJ30zlJd7YiqSQ2dA6UYe
         jhb7tGFel32+Fp/mvs/NItXyKEfgasyKb8F5/YNl3Zi2cVz6+MHxFswSYcHEXTaLaVTx
         XvWsdh9ki92d36D6/92iZ4L1rc3aCimgeole1uojxAxi4yY9Q8UX1LONXXiZrm8TMOI5
         dMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6sNkkpNtM5foNZucclMG+NC5U4w09zhnwuJEdGJYSEE=;
        b=VEnIxgOdPUzL7U989YBHouPlPmYKZ/XLxD5xrgTZlrkNpZwfXXwkLUybW6RYQ4+LX/
         dBk7C5e8BtzUY+ZWi6teReHmmV43H8b5puWgLM28E6pnUN7GWbygpcwgaiiefgHYG+iB
         9DIhYzdBLiOAObhbJqany5qDE3cazDUvpSP9CjV4avy/aAJgPZ4zu3AtXLEM8xSpTb44
         PO0BCB8+S0/253w8JikJ9WVzivx8XiJiP+3bIgmkUEK4V52Usen9Hy3NFt/a7J+LyH9X
         CtYF0iqfVFoxKpopInma3cxLQWuRdhURNnt6sK6DekyDLzfVGR1azQH+H1ezdjNljz9K
         snPA==
X-Gm-Message-State: AOAM530smF2s6f1XqSYWsP/QSmQAreVVbL705qgXjZDBL0Jts3kF/dT9
        Xjx6sWqL+xZ/0NJTqFK/uwMrkWE316h5PSoVcW4=
X-Google-Smtp-Source: ABdhPJy0YKcwgOr1X5/Up36j0b2S8GV6ZmGZuSL3sdnwK+D9w01XV9zJh4+BKjEy0vNA7Fa/QXOKuw==
X-Received: by 2002:a17:902:e806:b0:151:ca94:7563 with SMTP id u6-20020a170902e80600b00151ca947563mr1711459plg.151.1646862328766;
        Wed, 09 Mar 2022 13:45:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lw18-20020a17090b181200b001bf057106ebsm7709324pjb.41.2022.03.09.13.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 13:45:28 -0800 (PST)
Message-ID: <62291ff8.1c69fb81.47c5.41e8@mx.google.com>
Date:   Wed, 09 Mar 2022 13:45:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.183-18-g46ae4c2abf4c
Subject: stable-rc/queue/5.4 baseline: 73 runs,
 3 regressions (v5.4.183-18-g46ae4c2abf4c)
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

stable-rc/queue/5.4 baseline: 73 runs, 3 regressions (v5.4.183-18-g46ae4c2a=
bf4c)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.183-18-g46ae4c2abf4c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.183-18-g46ae4c2abf4c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      46ae4c2abf4cc631324e7c8c19963ce5fe70a7ff =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6228e7d12ec4035e03c62999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-g46ae4c2abf4c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-g46ae4c2abf4c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6228e7d12ec4035e03c62=
99a
        failing since 83 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6228e7d28a90ae5525c629ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-g46ae4c2abf4c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-g46ae4c2abf4c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6228e7d28a90ae5525c62=
9ac
        failing since 83 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228e947e9ab809cb1c62970

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-g46ae4c2abf4c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-g46ae4c2abf4c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228e947e9ab809cb1c62995
        failing since 3 days (last pass: v5.4.182-30-g45ccd59cc16f, first f=
ail: v5.4.182-53-ge31c0b084082)

    2022-03-09T17:52:01.946800  /lava-5846784/1/../bin/lava-test-case
    2022-03-09T17:52:01.954481  <8>[   32.604746] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
