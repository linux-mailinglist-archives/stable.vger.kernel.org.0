Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895B64DA369
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 20:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244928AbiCOToT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 15:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237583AbiCOToT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 15:44:19 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DE522B1A
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 12:43:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id t5so634721pfg.4
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 12:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4TBelXdUNr5u3ATIMlA3F5asjggWcCFBbmfLaeiURP4=;
        b=mbLaojjAXPVg49hE/owzcZ8JX4EV78WYO2Z2Zalu8Z84kr4ICbUul7hGiGC5zBQsXQ
         RecHSejbM15wgYx7a2RycNLFE2kjjnVf6mY6Sz0jmxGRtwAa0+1NXiMPE1ErrqBvVYmE
         jFwxCyAol7VJKpS8Oc/4HefCDKn7IkzfAaPemwWuP4a+h2QwLCtHR3sUJnx2ljU4ihFv
         goJA8kA1DF917BjKrvpeNGgxNN/T/kXwYwmS4TY/YfZErXGl3k+a/Rt3dbT6Ioo5iTlD
         w5O6vbmxRoVDr0likRO1WWGYus95JuxBmQwyrayg+wFz3VWHV0qyfjkQ+3D3EH9f4Kwv
         BqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4TBelXdUNr5u3ATIMlA3F5asjggWcCFBbmfLaeiURP4=;
        b=raFDsuu2DkWdoAz9KcijRIn/WrshR0lC3ST9tyuhvh6QHfBnH/BA3ON8X8tbgYURCm
         YrNfuYq2V6Pt+IbVGRfARgxnov9xqCVOI5bA3IoaJxYnvwzXo6roPVeKR/1MgnspAzCU
         wWYh3wFYYEDpA7aP0YpigNx5+87c9EMR9nEtQJeqH3oUGW99PQ2KGcqyvRE4d1uDY9rX
         4oKHOxFyIYLJXDyS4/krSpTUsWEjUxtTYWYOFlRDS7z25/VEtDVTm8n7vyy2hXFNzrGK
         K9BqX2YdGKellzUOB/LAzXffyhAZJFtYsjgU7AZwj0eo4tQ8oHhHE5Oqj0L+bAFuNy+4
         lHHA==
X-Gm-Message-State: AOAM533HdFkDxDZS041K1cLesPsYUeFLJKuOJRf7OiNbOaFhfKL1gEpd
        DBVELTs1TqVPjmjPCM1E7USGDsc4QSMtvUK4sSg=
X-Google-Smtp-Source: ABdhPJyoMKsPREN1ZKjeJK2htu185gcXc9Htc1CBxDHv8eC/V44SqXBKJfgdYD7hw3XjijZNh3X15w==
X-Received: by 2002:a63:ce48:0:b0:373:ac94:f489 with SMTP id r8-20020a63ce48000000b00373ac94f489mr26012504pgi.622.1647373384606;
        Tue, 15 Mar 2022 12:43:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s141-20020a632c93000000b0038134d09219sm30344pgs.55.2022.03.15.12.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 12:43:04 -0700 (PDT)
Message-ID: <6230ec48.1c69fb81.513dc.0159@mx.google.com>
Date:   Tue, 15 Mar 2022 12:43:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.184-43-g447c71776999
Subject: stable-rc/queue/5.4 baseline: 88 runs,
 3 regressions (v5.4.184-43-g447c71776999)
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

stable-rc/queue/5.4 baseline: 88 runs, 3 regressions (v5.4.184-43-g447c7177=
6999)

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
el/v5.4.184-43-g447c71776999/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.184-43-g447c71776999
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      447c7177699945fe06bd9f32f19c43adf8c25c11 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6230b1b4ee8512140ac62994

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-g447c71776999/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-g447c71776999/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6230b1b4ee8512140ac62=
995
        failing since 89 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6230b1b5ee8512140ac62998

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-g447c71776999/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-g447c71776999/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6230b1b5ee8512140ac62=
999
        failing since 89 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6230b5d82c84d3a9b0c62970

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-g447c71776999/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-g447c71776999/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6230b5d82c84d3a9b0c62996
        failing since 9 days (last pass: v5.4.182-30-g45ccd59cc16f, first f=
ail: v5.4.182-53-ge31c0b084082)

    2022-03-15T15:50:30.686870  /lava-5883774/1/../bin/lava-test-case
    2022-03-15T15:50:30.695573  <8>[   31.380361] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
