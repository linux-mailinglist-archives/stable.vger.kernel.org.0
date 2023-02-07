Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF068E036
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 19:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBGSj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 13:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjBGSjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 13:39:55 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCE84489
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 10:39:54 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id r8so16622744pls.2
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 10:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FCZzj935cZMazVHrmycytw8PgeAFLlqherNue0Lhe54=;
        b=sAM5h0vnKxLskgUg7GM/FM+REwy4/OM+zRmIwjKalqu1Npg0bZO1zHBRpILaDIXweB
         hEjTFMxbGhJUhRQWwWreom8ymPonQ6qj56RrGuyd6WJubT1iaGhCzMqwCaqCKe50ebMa
         sQzp+93Ui/2zsBAsmjYPLkLtVqkAJoR0gWi7bIhSwEeNZ9WFvAdWp8RHnz7LrYWQe6f0
         J7Q3NR5p7bHW+WIxUJFBNUxS0MLrUZ1tJXbeiGD01VTwi5nhAPo8cm+bicAoWu1JA3LB
         VtXRMS1KI0WVI89tjl8pZcL9zz8V561FAKcn1TpJwlVXr55zpCEncoyliFjFYtQt4Lto
         VCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCZzj935cZMazVHrmycytw8PgeAFLlqherNue0Lhe54=;
        b=j3l4B6JVJrhJHk/U4vnWfTX2w0u/kYnpG1BOzSqFviVrMNNRFSqNjgnkM+tCWXHeGp
         3ejBj6k6zBOKDw71Aly4v53KrNTd8X70K4JRFciMN+vQsn1XonM/gjMtpbw6MTT3nnjc
         Nq5Bi8NynGhmSHlvaMjUKv+gHlP/9tYSQ6G3KHPTqn2J0X0PEr1XC8Fo72tPWH5msBEt
         9oQfq3jYlL1vztyrOmy1PTPC5XXQvE1q+5iEpGmDJmITeac6MP3pme90pGgciWca6b2J
         kzJlX8xK1xtxTtxk1TrPihXFXAkMkw8eSNiA12VP8+FGNgPtSXUYr+FtJCoPanq/laIA
         oOAA==
X-Gm-Message-State: AO0yUKXs2m+gNqoYFjSu7KvE8gydqcD5CKiN6sE/TIsmGrW9DriqeMRU
        B8OSs3IbcNTDWGdmD73jBH60vdIggRAdQG8FtWVpyw==
X-Google-Smtp-Source: AK7set/kW5V8MM1+Hq8vNCEDM/O0zH3hMIAl8VlUuHoNReYrw3yc5R5mgSpSYi/ih8XlnKOdIh7/KA==
X-Received: by 2002:a17:90a:350:b0:230:e771:e1b0 with SMTP id 16-20020a17090a035000b00230e771e1b0mr4773840pjf.28.1675795193892;
        Tue, 07 Feb 2023 10:39:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11-20020a17090a170b00b0023087e8adf8sm6654329pjd.21.2023.02.07.10.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 10:39:53 -0800 (PST)
Message-ID: <63e29af9.170a0220.daeae.bba2@mx.google.com>
Date:   Tue, 07 Feb 2023 10:39:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.91-142-ga0b338ae1481
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 166 runs,
 5 regressions (v5.15.91-142-ga0b338ae1481)
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

stable-rc/linux-5.15.y baseline: 166 runs, 5 regressions (v5.15.91-142-ga0b=
338ae1481)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =

cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.91-142-ga0b338ae1481/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.91-142-ga0b338ae1481
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0b338ae148124eaaf13c5cde22eb4026a783229 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/63e26b359422cd47958c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e26b359422cd47958c8=
654
        failing since 271 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e269019535f1d8f58c8661

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e269019535f1d8f58c866a
        failing since 21 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-07T15:06:32.261140  <8>[    9.965291] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3302242_1.5.2.4.1>
    2023-02-07T15:06:32.367757  / # #
    2023-02-07T15:06:32.469202  export SHELL=3D/bin/sh
    2023-02-07T15:06:32.469561  #
    2023-02-07T15:06:32.570772  / # export SHELL=3D/bin/sh. /lava-3302242/e=
nvironment
    2023-02-07T15:06:32.571130  =

    2023-02-07T15:06:32.571288  / # <3>[   10.194184] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-02-07T15:06:32.672387  . /lava-3302242/environment/lava-3302242/bi=
n/lava-test-runner /lava-3302242/1
    2023-02-07T15:06:32.672910  =

    2023-02-07T15:06:32.678078  / # /lava-3302242/bin/lava-test-runner /lav=
a-3302242/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e269048d4d2d8c628c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e269048d4d2d8c628c8638
        failing since 7 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first =
fail: v5.15.90-205-g5605d15db022)

    2023-02-07T15:06:18.389818  + set +x
    2023-02-07T15:06:18.390024  [    9.364423] <LAVA_SIGNAL_ENDRUN 0_dmesg =
900183_1.5.2.3.1>
    2023-02-07T15:06:18.497751  / # #
    2023-02-07T15:06:18.599178  export SHELL=3D/bin/sh
    2023-02-07T15:06:18.599502  #
    2023-02-07T15:06:18.700604  / # export SHELL=3D/bin/sh. /lava-900183/en=
vironment
    2023-02-07T15:06:18.701010  =

    2023-02-07T15:06:18.802205  / # . /lava-900183/environment/lava-900183/=
bin/lava-test-runner /lava-900183/1
    2023-02-07T15:06:18.802775  =

    2023-02-07T15:06:18.805267  / # /lava-900183/bin/lava-test-runner /lava=
-900183/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63e2686a1932d79bd88c8662

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e2686a1932d79bd88c866b
        failing since 21 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-07T15:04:00.458032  + set +x
    2023-02-07T15:04:00.462190  <8>[   16.025962] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3302171_1.5.2.4.1>
    2023-02-07T15:04:00.582710  / # #
    2023-02-07T15:04:00.688443  export SHELL=3D/bin/sh
    2023-02-07T15:04:00.689956  #
    2023-02-07T15:04:00.793339  / # export SHELL=3D/bin/sh. /lava-3302171/e=
nvironment
    2023-02-07T15:04:00.794863  =

    2023-02-07T15:04:00.898345  / # . /lava-3302171/environment/lava-330217=
1/bin/lava-test-runner /lava-3302171/1
    2023-02-07T15:04:00.901094  =

    2023-02-07T15:04:00.904362  / # /lava-3302171/bin/lava-test-runner /lav=
a-3302171/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63e267657820e7d3eb8c8655

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
1-142-ga0b338ae1481/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e267657820e7d3eb8c865e
        failing since 21 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-07T14:59:38.903090  + set +x
    2023-02-07T14:59:38.907162  <8>[   16.004337] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 269426_1.5.2.4.1>
    2023-02-07T14:59:39.019060  / # #
    2023-02-07T14:59:39.121053  export SHELL=3D/bin/sh
    2023-02-07T14:59:39.121537  #
    2023-02-07T14:59:39.223335  / # export SHELL=3D/bin/sh. /lava-269426/en=
vironment
    2023-02-07T14:59:39.223815  =

    2023-02-07T14:59:39.325463  / # . /lava-269426/environment/lava-269426/=
bin/lava-test-runner /lava-269426/1
    2023-02-07T14:59:39.326103  =

    2023-02-07T14:59:39.330832  / # /lava-269426/bin/lava-test-runner /lava=
-269426/1 =

    ... (12 line(s) more)  =

 =20
