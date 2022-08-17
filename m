Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A525970BB
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 16:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbiHQOQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240063AbiHQOQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 10:16:41 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAAF5F138
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 07:16:40 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s4-20020a17090a5d0400b001fabc6bb0baso732521pji.1
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 07:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=vpFD3eqiDzx2+po5FzczbJ5rBefIh93v79s11Bskfxk=;
        b=kgrW8Nfie4yZNFpl/n7WHnoyiKfvrOnFg8k9Bw/GLRu2xCHsG3K2XY1lrJkT0Q+j4R
         MrXbcChCUzB5ox8bwY9S5TsL6joEiu/f2RIyaoFcKBzQhjZaqJtjt2/2ZePsDJHOs+BV
         KtPz97Neq7XH2NDoQ3+bohRZNXxvUPqnWG14yVuDlBCYMm+2roMYn9dqb+vRtf23GPrp
         0D5aJT8iId3jnQ8YAR5pufeZuf7nwlI3q1revLBSeuHdPzT1OJcAWmVsk4wCGkmnh1g4
         BQljEsGwWSjtUDearecrQ0sjqRcnLWcunRklUSTrbCCy7krpGJr+xvkxwARSIN7ZGXJl
         B0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=vpFD3eqiDzx2+po5FzczbJ5rBefIh93v79s11Bskfxk=;
        b=dhe76ArPHnjwRwvb/aqmS9pCCIKCuIJY28kP9Kq0DOtUQ0OK0WfkHXaMEAqCCk+/fR
         j20b384WRp+xYpCzDtrDHBry4v6q66O4kMrMXHYE/6gWJ7mU2QhzEJ7WTEqJhK7Wgt9H
         nksSAGWJyEsdwA1LdqEgLEn/7Ix+eXLv+tCQ8KFQK7hXu2vkwN+j1Bw92L7ZOQij2vbW
         ntnKQU2seaVaknn3sX1V6QehcAAH5CRV8ONxmS45T5H5FIXMfJQFIpWf6qi0e1YqqWm8
         VN9e9uEgIPyvs+1huRpDuwHhctNRFtU0iilqet8KOANq6peb/584TB2nm8ztIcFwYpQj
         eQQg==
X-Gm-Message-State: ACgBeo2jIiiBicUQ4TjUTJa+JEALUknk8d1mKpPCmAI17VcVGEY1bafe
        yTQGiPzlDlGz93681yqwOjOhh7HQ19YVLsvY
X-Google-Smtp-Source: AA6agR4nhNJvK2wB21TJwOuOEH7yvDYn93S/QSRSYi6+3glllxYJGI98cOwpfYYoMhqNCVPRgTbmfA==
X-Received: by 2002:a17:902:e750:b0:170:8891:83be with SMTP id p16-20020a170902e75000b00170889183bemr26175051plf.12.1660745800239;
        Wed, 17 Aug 2022 07:16:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f55100b00170a359eb0esm1594614plf.63.2022.08.17.07.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:16:39 -0700 (PDT)
Message-ID: <62fcf847.170a0220.fafbd.2aa5@mx.google.com>
Date:   Wed, 17 Aug 2022 07:16:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-778-gc626fe5b95b9e
Subject: stable-rc/queue/5.15 baseline: 151 runs,
 4 regressions (v5.15.60-778-gc626fe5b95b9e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 151 runs, 4 regressions (v5.15.60-778-gc626f=
e5b95b9e)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
bcm2835-rpi-b-rev2         | arm   | lab-broonie   | gcc-10   | bcm2835_def=
config   | 1          =

beagle-xm                  | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig | 1          =

panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-778-gc626fe5b95b9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-778-gc626fe5b95b9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c626fe5b95b9e858e5a0ef5486d1cdb29aadcd74 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
bcm2835-rpi-b-rev2         | arm   | lab-broonie   | gcc-10   | bcm2835_def=
config   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc19f60358d0ed6355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-gc626fe5b95b9e/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-gc626fe5b95b9e/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc19f60358d0ed6355=
647
        failing since 0 day (last pass: v5.15.59-9-g01206bfdee44a, first fa=
il: v5.15.60-777-g484e5dee10f8f) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
beagle-xm                  | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc2700884ef32443556cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-gc626fe5b95b9e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-gc626fe5b95b9e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc2700884ef3244355=
6cd
        failing since 139 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc32d1fb6d20f6f355683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-gc626fe5b95b9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-gc626fe5b95b9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc32d1fb6d20f6f355=
684
        failing since 1 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-779-ge1dae9850fdff) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fcc9f9caf3f8e43d355672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-gc626fe5b95b9e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-gc626fe5b95b9e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcc9f9caf3f8e43d355=
673
        new failure (last pass: v5.15.60-110-g5a4012ec04fef) =

 =20
