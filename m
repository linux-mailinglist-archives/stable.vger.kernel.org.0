Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E69595FE1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiHPQLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbiHPQKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:10:46 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6719A6410
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:10:19 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p18so9625550plr.8
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=HhVq64bxR1pjpfBiGct8bIYfHN2OhIw1aivghGdR/Ro=;
        b=eE4HniuMbsL9SKUE6eHe1mRCzE/CiaOUZjq5JaktIlbWTduLa8lUac/AskXydk82+R
         HCmw9EzgnZr7BvarPXmd3aSxTBmJcMh7klpE55Sk+JaNw/84df5xl+PpLBpSErZh4PhQ
         mkWgXzPfJnHM7lKvesxr69VQqYvZna9BqkbBuLLhfNJopA706LqWb8aJXXuD/1W6uWM3
         4V/futuMjGrMpUdl42unJXpv8ET3hJcogf8/lR3nP540srHCTF9EFm0W9FragMXmCsNv
         2BUGfiI0nri6sFsZHjVHtJ9WdWHfmD9q9qRdntSXRSwuTfgo8gT+bEH981LaJ3rrGS33
         B22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=HhVq64bxR1pjpfBiGct8bIYfHN2OhIw1aivghGdR/Ro=;
        b=qXLTvOz5qV6jZtqTbxMDwX3OLskPxzrstS3eWIgYN+3lNzMQpCktG9wxlGFPfC9cfm
         nAfvseUtUMsaBbvBHQcLkyBIPq5/0rkAmvMvuOGX8PPZaiSop3MVuHJ+rJiNiZdVTAgE
         oX3zUHZhq6uf1kmNUuHnyWbKItP/QdShhNHXZyS23MLqh9avzzPDN608jJnoL14OQEPs
         mcy2hq1Plz9S53xSNy93081dovpf4Ka0XmQbkk2cIHj5ebz0gIrJ1b459LSRwPjoXihO
         t6y8L8oiD2ywvmSM7eGFHmWPxdZNAvM1n6QLAD0+rN6al28u2thWnTUk+YrSFC5rkZWi
         2XjQ==
X-Gm-Message-State: ACgBeo3HRDu5pGrJQyjz/4KrVMDF/yG0qzLnBrkGNYV9pn5PL1dCuCXu
        46El0reLOT6wgKBkQo/S3pjQsoiB21ZBYYuZ
X-Google-Smtp-Source: AA6agR50UbVB6Hh/U0jk066algWH62K/ZsjlnvasCWqphWnFTueO5vl6oM/B5UCWFbNjLNE81Uag5w==
X-Received: by 2002:a17:90a:5605:b0:1fa:a77b:9e with SMTP id r5-20020a17090a560500b001faa77b009emr1913867pjf.198.1660666218768;
        Tue, 16 Aug 2022 09:10:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t12-20020a170902dccc00b0016d4f05eb95sm9195130pll.272.2022.08.16.09.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 09:10:17 -0700 (PDT)
Message-ID: <62fbc169.170a0220.b36e5.0051@mx.google.com>
Date:   Tue, 16 Aug 2022 09:10:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-777-g484e5dee10f8f
Subject: stable-rc/queue/5.15 baseline: 158 runs,
 5 regressions (v5.15.60-777-g484e5dee10f8f)
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

stable-rc/queue/5.15 baseline: 158 runs, 5 regressions (v5.15.60-777-g484e5=
dee10f8f)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

mt8183-kukui-...uniper-sku16 | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

panda                        | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-777-g484e5dee10f8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-777-g484e5dee10f8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      484e5dee10f8ff931950475414b187c6764d53b8 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb8bc491df1d3b8535567d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb8bc491df1d3b85355=
67e
        new failure (last pass: v5.15.60-779-ge1dae9850fdff) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb88736d91c1c794355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb88736d91c1c794355=
672
        new failure (last pass: v5.15.59-9-g01206bfdee44a) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb8af88a350cb1a3355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb8af88a350cb1a3355=
667
        failing since 138 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
mt8183-kukui-...uniper-sku16 | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb8c151183b78353355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb8c151183b78353355=
646
        new failure (last pass: v5.15.60-110-g5a4012ec04fef) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
panda                        | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb8e11812c136e14355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
777-g484e5dee10f8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb8e11812c136e14355=
652
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-779-ge1dae9850fdff) =

 =20
