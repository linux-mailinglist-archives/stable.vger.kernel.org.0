Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9884D0CC9
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 01:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiCHAa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 19:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243667AbiCHAaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 19:30:55 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99FB381AE
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 16:29:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso821831pjq.1
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 16:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0HE387jJJQH11KJUEU7ZkM1O/VCOlDBVc03vM2FEWd4=;
        b=8Wqa0nuSgk9rgoUgPFcyhXpm25xRQrS0YcTcD+x2mtvETuaKqc7QFupgJ31eIjBcex
         q2NTUp77AgtE5WGv92AcIuJOwAZe3GaCqphHWloO0YOClM2zG2E3q1JOBMk/BLniWspi
         ktHUT86vVraxcNwizHD8YaruRq9IRA4c7CHGmqiND6rQY/fiNnYTCZ4SPQVjOcKcimeZ
         tVVFJtoGbQs0zIqmMHryD+oot1ZDBBBfjFvE53p/1+kutmhLkgrizx/N/G8c7NAI9vDw
         6r9yG+GhuBuAkgQOxFYhCBkgOsf2IEi2q2Pkq1iC3Ft0luxVqwL+H51RAZkrNW2KdYo9
         UXgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0HE387jJJQH11KJUEU7ZkM1O/VCOlDBVc03vM2FEWd4=;
        b=vQ6T8ZMlM16FLB98wOuI2ckSqhM5AcGvZzMfPs1FKbFHKRGt21wkU1pmFk+9bWT9Sc
         BdY1JsSCKQRqFSim0W4x5lg8gjK+I+gY+MAGWW3+K8b7T45lW/3myPMZWqUQGBx+CUtp
         cq+LXk++qe5qzIF/qxj6H7izZbk9SDWyBOysvFDMDHaY6urRdfMtj5Q1K6IKp5gHTXzh
         iqtRDMxteRNqpvV6KYnf2LjckcslYpJQPpHPbje3O6qFD1dBmEGYIxe73azlxwSwbxZU
         6nRFjIJ+JbZWrpJnVRdsjW/+e/xEePnjq1TEuBoq4bbBB41hzjDAR2IFVQPyeuQZLtIf
         DwLw==
X-Gm-Message-State: AOAM533V3iqPhrG3PRA4HgV6spHrHw3YWt25KDTq2vKt49O3LwPnX+jc
        gE+MjWF2So0MOrL53pV95ZUwWAFyytEFv3a3EVk=
X-Google-Smtp-Source: ABdhPJzQb4K09fe5Fssh5bSHQsrRd3Bw+vdolfu02u5M5ZLD1Xh2XD50HGfta2nvcjFUWT3uBjk0fg==
X-Received: by 2002:a17:902:f68b:b0:151:d869:3b16 with SMTP id l11-20020a170902f68b00b00151d8693b16mr12343561plg.85.1646699399312;
        Mon, 07 Mar 2022 16:29:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00234900b004f6fe0f4cb2sm5788336pfj.14.2022.03.07.16.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 16:29:59 -0800 (PST)
Message-ID: <6226a387.1c69fb81.6217f.e88c@mx.google.com>
Date:   Mon, 07 Mar 2022 16:29:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.26-258-g7b9aacd770fa
Subject: stable-rc/linux-5.15.y baseline: 124 runs,
 3 regressions (v5.15.26-258-g7b9aacd770fa)
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

stable-rc/linux-5.15.y baseline: 124 runs, 3 regressions (v5.15.26-258-g7b9=
aacd770fa)

Regressions Summary
-------------------

platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
beagle-xm                 | arm    | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig          | 1          =

hp-x360-12b-n4000-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =

rk3399-gru-kevin          | arm64  | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.26-258-g7b9aacd770fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.26-258-g7b9aacd770fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b9aacd770fa105a0a5f0be43bc72ce176d30331 =



Test Regressions
---------------- =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
beagle-xm                 | arm    | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62266d1084375c6f51c62999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6-258-g7b9aacd770fa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6-258-g7b9aacd770fa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62266d1084375c6f51c62=
99a
        failing since 46 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
hp-x360-12b-n4000-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62266f6a7a839ea807c62989

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6-258-g7b9aacd770fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-n4000-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6-258-g7b9aacd770fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-n4000-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62266f6a7a839ea807c62=
98a
        new failure (last pass: v5.15.26-246-ged373242c999) =

 =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
rk3399-gru-kevin          | arm64  | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62267208de6a7904e8c6298d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6-258-g7b9aacd770fa/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6-258-g7b9aacd770fa/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62267208de6a7904e8c629b1
        new failure (last pass: v5.15.26)

    2022-03-07T20:58:21.290565  /lava-5831128/1/../bin/lava-test-case   =

 =20
