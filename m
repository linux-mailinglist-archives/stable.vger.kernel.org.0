Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85254B3D23
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 20:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbiBMTcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 14:32:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBMTcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 14:32:53 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A1156C1E
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 11:32:46 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c10so16069pfv.8
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 11:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4QBEFxchFjd8WMum8Gf4qu95ZB7xs25vTo9RvtckL2M=;
        b=HWlQV5XkUMNAZlcWAMtFKSAqAusC+FTvi0gPpFrCwAhRBKn5uKUkV7eytYykv9jGMd
         5lf5IjCeT8xrusOmGs4iLWehmUkY7plcA4WTwF+y0Mle08qzPInyhqQUJRLigSL+4KkY
         MX+4Zztw8vK7Yj0715gYtjM8k5Elt5gXe4sgvdZnIR3jkikDFJCuIfZP6D7oge3mGK+i
         51UiKjLQwjuZtvn4dHWHimP0LOG7mOaoESwOpiBuMj+LA/cmLaLg6fl84AEAEMRwx9Vu
         HS/ePrxcCNB8YRGbP0PC9NlO8Vt03QW63V/jwXlOyAH/VzZYfkmFAQmnEuLTPgQJPp7K
         2wZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4QBEFxchFjd8WMum8Gf4qu95ZB7xs25vTo9RvtckL2M=;
        b=UFZkm/nCJIy+lvX7O3yaO0sdG0Inm+oRTPFgInW9ReZedUZ+9ha7hwaXdp4ZRDLVBF
         KvFr/hMR5TRpohnUcmOcnd5ApQQxGXt6Cy+5iEDV8OGPeCBBrIYDzpypliGo2LkVI0rW
         FwyYT9QRdojj7UNSVq7RaqjdjJAV6jTFaTIwww41QLWjRjzFhUEPVdv1hHRBAGzZaeN1
         CBYpOojSk7ElklRYIQUEBzB03vFaLDwJvQsqK9AqXzUIMx1U/5TJNH+wXLQjjKqTb828
         MEPUCBJOYNAwC7bsOsx8BS3HhQ7D6XUiC6BruY0h+elW35q8MwcMdTfNPUrQZAOFCTVB
         4pzg==
X-Gm-Message-State: AOAM531H3GhSQwrbUfY0EG29gFgkqv+oyizQFECOPLcxe7rwQ9g8GexF
        K2wPJeZoAvg3lwEXYjwN3D+MafpyH674alz1
X-Google-Smtp-Source: ABdhPJxR65zcSga9oi0/MmS/j5bCuNXvEIK9YijbznXXLwGTb/uMRLdwhphxV1h7XQuKqUZtdP5Stg==
X-Received: by 2002:a63:6aca:: with SMTP id f193mr9009455pgc.85.1644780765573;
        Sun, 13 Feb 2022 11:32:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l17sm33494399pfu.61.2022.02.13.11.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 11:32:45 -0800 (PST)
Message-ID: <62095cdd.1c69fb81.5be43.2d27@mx.google.com>
Date:   Sun, 13 Feb 2022 11:32:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.23-163-g45e450825953
Subject: stable-rc/queue/5.15 baseline: 114 runs,
 11 regressions (v5.15.23-163-g45e450825953)
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

stable-rc/queue/5.15 baseline: 114 runs, 11 regressions (v5.15.23-163-g45e4=
50825953)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
ox820-clouden...lug-series-3 | arm   | lab-baylibre | gcc-10   | oxnas_v6_d=
efconfig | 3          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.23-163-g45e450825953/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.23-163-g45e450825953
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45e45082595304779744c5b9469dc0341305bfc3 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
ox820-clouden...lug-series-3 | arm   | lab-baylibre | gcc-10   | oxnas_v6_d=
efconfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6209256c01c259680ac62996

  Results:     2 PASS, 3 FAIL, 1 SKIP
  Full config: oxnas_v6_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm/oxnas_v6_defconfig/gcc-10/lab-baylibre/baseline-ox820=
-cloudengines-pogoplug-series-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm/oxnas_v6_defconfig/gcc-10/lab-baylibre/baseline-ox820=
-cloudengines-pogoplug-series-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6209256c01c25968=
0ac62999
        new failure (last pass: v5.15.23-79-g21ea1dc6c11d)
        1 lines

    2022-02-13T15:35:48.608795  / # =

    2022-02-13T15:35:48.714665  #
    2022-02-13T15:35:48.715400  =

    2022-02-13T15:35:48.817010  / # #export SHELL=3D/bin/sh
    2022-02-13T15:35:48.817810  =

    2022-02-13T15:35:48.919739  / # export SHELL=3D/bin/sh. /lava-1557696/e=
nvironment
    2022-02-13T15:35:48.922397  =

    2022-02-13T15:35:49.024060  / # . /lava-1557696/environment/lava-155769=
6/bin/lava-test-runner /lava-1557696/0
    2022-02-13T15:35:49.026509  =

    2022-02-13T15:35:49.034134  / # /lava-1557696/bin/lava-test-runner /lav=
a-1557696/0 =

    ... (9 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6209256c01c2596=
80ac6299a
        new failure (last pass: v5.15.23-79-g21ea1dc6c11d)
        13 lines

    2022-02-13T15:35:49.288728  kern  :alert : Register r0 information: sla=
b kmalloc-2k start c19cb000 pointer offset 64 size 2048
    2022-02-13T15:35:49.289348  kern  :alert : Register r1 information: NUL=
L pointer
    2022-02-13T15:35:49.289580  kern  :alert : Register r2 information: sla=
b kmalloc-1k start c305d400 pointer offset 0 size 1024
    2022-02-13T15:35:49.289775  ker<8>[   11.464399] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D13>
    2022-02-13T15:35:49.289958  n  :alert : Register r3 information: non-pa=
ged memory   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6209256c01c2596=
80ac6299b
        new failure (last pass: v5.15.23-79-g21ea1dc6c11d)
        26 lines

    2022-02-13T15:35:49.331549  kern  :alert : Register r4 information: sla=
b kmalloc-2k start c19cb000 pointer offset 64 size 2048
    2022-02-13T15:35:49.331921  kern  :alert : Register r5 information: sla=
b kmalloc-192 start c1fc7e40 pointer offset 16 size 192
    2022-02-13T15:35:49.332615  kern  :alert : Register r6 information: sla=
b kmalloc-192 start c3780180 pointer offset 0 size 192
    2022-02-13T15:35:49.332967  kern  :alert : Register r7 information: sla=
b kmalloc-192 start c3780180 pointer offset 84 size 192
    2022-02-13T15:35:49.333318  kern  :alert : Register r8 information: sla=
b filp start c1a49300 pointer offset 16
    2022-02-13T15:35:49.333924  kern  :alert : Register r9 information: sla=
b task_struct start c1a33c00 pointer offset 1152
    2022-02-13T15:35:49.374584  kern  :alert : Register r10 information: no=
n-paged memory
    2022-02-13T15:35:49.375240  kern  :alert :<8>[   11.533744] <LAVA_SIGNA=
L_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2=
6>
    2022-02-13T15:35:49.375462   Register r11 information: non-s<8>[   11.5=
45804] <LAVA_SIGNAL_ENDRUN 0_dmesg 1557696_1.5.2.4.1>
    2022-02-13T15:35:49.375649  lab/vmalloc memory =

    ... (2 line(s) more)  =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62092b4f799d3081e9c62988

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62092b4f799d3081e9c62=
989
        failing since 4 days (last pass: v5.15.21-111-g6704c2c1f104, first =
fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62092b47799d3081e9c6297b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62092b47799d3081e9c62=
97c
        failing since 4 days (last pass: v5.15.21-111-g6704c2c1f104, first =
fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62092b51c971c55b62c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62092b51c971c55b62c62=
969
        failing since 4 days (last pass: v5.15.21-111-g6704c2c1f104, first =
fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62092b48799d3081e9c62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62092b48799d3081e9c62=
982
        failing since 4 days (last pass: v5.15.21-111-g6704c2c1f104, first =
fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62092b4ec2b80a2e6cc62995

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62092b4ec2b80a2e6cc62=
996
        failing since 4 days (last pass: v5.15.21-111-g6704c2c1f104, first =
fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62092b46c2b80a2e6cc6297d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62092b46c2b80a2e6cc62=
97e
        failing since 4 days (last pass: v5.15.21-111-g6704c2c1f104, first =
fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62092b52e44fbf1375c62969

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62092b52e44fbf1375c62=
96a
        failing since 4 days (last pass: v5.15.21-111-g6704c2c1f104, first =
fail: v5.15.21-111-gbc928abfc73d) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62092b49c2b80a2e6cc6298f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.23-=
163-g45e450825953/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62092b49c2b80a2e6cc62=
990
        failing since 4 days (last pass: v5.15.21-111-g6704c2c1f104, first =
fail: v5.15.21-111-gbc928abfc73d) =

 =20
