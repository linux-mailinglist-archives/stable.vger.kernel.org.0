Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D395F5CAA
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJEW0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 18:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJEW0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 18:26:30 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D6A75CFB
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 15:26:29 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y8so272728pfp.13
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 15:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=dScYy91vwSGTnII/EM0rSH9KNX+tCnb8nNzPZhYa36Y=;
        b=o89S0DSuwxSW9f2mtb6fbtM8mz8scN04nqTSEAJjDNmNQxVEmEkEghSEMphJ4+nCrF
         sxZPFdaG7OY1OXDO5bUaRuqMESxOfuHwvjmcU337PT7vl2MCXpfRFvQCwiFRmjFGiFkZ
         qIdiYi40vcQo1jY6pPleCOwJu8Qci9a7m083W6am93GTP75cALJ7FseE38N1Cjt7QnBx
         7psqsdrvRTFm0QAWeGShQMf3Bc1tpxlSffYcCRRZ3kd3TSwFTqz9IX7MrjI+S6iFMKVQ
         jDWLEfQR4I2LaOmt7jLBXWQmwLTqe0sDohXePyt2n/FCbaljrJKqKcGJp7vo5P5XthX2
         m9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=dScYy91vwSGTnII/EM0rSH9KNX+tCnb8nNzPZhYa36Y=;
        b=WP7dHza0nW3LpUOXsWVSvhonLYPDu68Jced8F26n0aaBoL69dW+P1X+ZfJmqvTBa5z
         GFKRKKoxe1edvyQQm4ogJdAyzZmLCTL7C8naZimr04m0XlbEtnX3X8LErMcXu5cxywbI
         tM0GJbe8KfHNpkKFl1QIWUmlRWhX4rS2ZAAhLCiN9T+jm8VD3ah1bfCZD3K1gTeK0cHi
         OOu8gbsRGZ+PWFms15e/JbyA9yFIOBMIZdNZKGLjrVwOtIANgLVYI273iC9GvXCGCdo5
         mJ728OW+8+0Ox6m9MGzaANtDaDmM7hGCtS5K0RCT/0tbfgyrZuaN7utqvq0Yg1REajd/
         o8uQ==
X-Gm-Message-State: ACrzQf29Yu2rYKYmR32mvZiQS9BAkSENPkHoVWPY5nqsunsuurmaxwxW
        UQJfEAm82U1TzAXjYqajTuXg5rxy044JPWB8sYk=
X-Google-Smtp-Source: AMsMyM4+vrDGxJGfX/X2cDFf3iC1YmOUPTA8WUUPxBOBkhtxpkvyah/Ntu6jq98OVUJIBtMG+U17pQ==
X-Received: by 2002:a63:2b4b:0:b0:440:2963:5863 with SMTP id r72-20020a632b4b000000b0044029635863mr1684999pgr.28.1665008788785;
        Wed, 05 Oct 2022 15:26:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79910000000b0056247dfdd3csm1401592pff.182.2022.10.05.15.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:26:28 -0700 (PDT)
Message-ID: <633e0494.a70a0220.dbdca.2e24@mx.google.com>
Date:   Wed, 05 Oct 2022 15:26:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.12-116-g5104816afb77d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 126 runs,
 4 regressions (v5.19.12-116-g5104816afb77d)
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

stable-rc/queue/5.19 baseline: 126 runs, 4 regressions (v5.19.12-116-g51048=
16afb77d)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =

imx7ulp-evk          | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

imx7ulp-evk          | arm   | lab-nxp       | gcc-10   | multi_v7_defconfi=
g  | 1          =

qemu_mips-malta      | mips  | lab-collabora | gcc-10   | malta_defconfig  =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.12-116-g5104816afb77d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.12-116-g5104816afb77d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5104816afb77d45eb9f24ea0bcdba2d68bcbeb55 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/633dcf9bf46df75274cab5fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
116-g5104816afb77d/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
116-g5104816afb77d/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633dcf9bf46df75274cab=
5fd
        failing since 2 days (last pass: v5.19.11-208-g633f59cac516, first =
fail: v5.19.12-101-g42662133e9bdb) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
imx7ulp-evk          | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/633dd2552475ebd1d4cab682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
116-g5104816afb77d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
116-g5104816afb77d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633dd2552475ebd1d4cab=
683
        failing since 10 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-186-ge96864168d41) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
imx7ulp-evk          | arm   | lab-nxp       | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/633dd62709b99c4958cab5f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
116-g5104816afb77d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
116-g5104816afb77d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633dd62709b99c4958cab=
5f3
        failing since 8 days (last pass: v5.19.11-158-gc8a84e45064d0, first=
 fail: v5.19.11-206-g444111497b13) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_mips-malta      | mips  | lab-collabora | gcc-10   | malta_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/633dd13a91b7cb4777cab5ec

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
116-g5104816afb77d/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.12-=
116-g5104816afb77d/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/633dd13a91b7cb4=
777cab5f4
        new failure (last pass: v5.19.12-114-g34c12937d8e1d)
        1 lines

    2022-10-05T18:47:06.649610  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 32c20cb0, epc =3D=3D 802006a8, ra =3D=
=3D 80203380
    2022-10-05T18:47:06.677817  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
