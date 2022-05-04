Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EAA51A4E9
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352810AbiEDQL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238750AbiEDQLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:11:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA2225C7B
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:07:48 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id x18so1808888plg.6
        for <stable@vger.kernel.org>; Wed, 04 May 2022 09:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XUOd4Cef2uEtyj+I010Pi10snHUH5Pe9rhuFzDxgm44=;
        b=srvvkcEY9bE9ht66yu4ucSaasX8//jG7jMJ4EHlr24gxYMlV0lsC2WLZGVlbRAb8tk
         xKuRlXJj61Lyf6MNDaIHa/NDos726Att457rgTU8Pnx8LHLlTXKinl01tOFJCwdZTJ7T
         6mnDmFA8Bs6rLb2953Mr6hU5/QPRKPnsYE0RQ3eQ4BHB1fz1tl1tXdqwOrCRaAZ1BePa
         1eXlYmhz9DUHLsAk+RMiJZVGSpY8QW+408bE7E5kW+dKPMGPye1b6ekqvJ53Gid/idpD
         +kJpHC3D9Mt212HHNfVqP30CLRpMhG9uAwZBh2hWG4wfD6kmOI2t83VvP0AfgV0F6HYI
         i5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XUOd4Cef2uEtyj+I010Pi10snHUH5Pe9rhuFzDxgm44=;
        b=f8ECMT4RWUG4T0x6Tg0kb/H8u5bDpbzNTwQ1NVz9pxX1wOcI0lj6FJJypC7t2r1kgP
         akCUc3ZPF1Pk7q73eG0gQbjUU6brRASwPniw7SQMQRtVYD4AJfQf92avQLLamlsrnPKu
         iIbxNLdwGenXjKo1kSrND3b1qEql8iIJGuDdQ4Z108unzFFmF14vMqjMVAm58+4dU3jo
         3BwiYLuyDW4YQXZX/uvdaylL87Lbgu+VeSu5QzbfSVwiNRhrH8+eaHnBn6auUmvdfvIx
         srec4Rkge1VrSdzTOQyUie0LT6/7BxwOyxh+2SUbhfgEwgE6TBgoQH2PSEZ3KpZp+Tqr
         /vOQ==
X-Gm-Message-State: AOAM533VMZR5a+rROeF7Bc8mxu8MQlwxTTJhFG83llMasiH7K5quH73K
        Q3UhrxfEv0SZbYlmQhB6SMO+FHnm5RAHN9VmtnM=
X-Google-Smtp-Source: ABdhPJxID9MQxMUTfdTQdkosrCC/fri2U4BM92OB25uvMAEyIjb2u1Wl8Ladq12T3q858Wcrm5XjQA==
X-Received: by 2002:a17:90a:7c4c:b0:1dc:26a1:b82f with SMTP id e12-20020a17090a7c4c00b001dc26a1b82fmr208523pjl.148.1651680468100;
        Wed, 04 May 2022 09:07:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902728c00b0015e8d4eb271sm8565412pll.187.2022.05.04.09.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:07:47 -0700 (PDT)
Message-ID: <6272a4d3.1c69fb81.ab473.4d96@mx.google.com>
Date:   Wed, 04 May 2022 09:07:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.191-84-gbea55d0a1d975
Subject: stable-rc/linux-5.4.y baseline: 80 runs,
 5 regressions (v5.4.191-84-gbea55d0a1d975)
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

stable-rc/linux-5.4.y baseline: 80 runs, 5 regressions (v5.4.191-84-gbea55d=
0a1d975)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.191-84-gbea55d0a1d975/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.191-84-gbea55d0a1d975
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bea55d0a1d975bbc086c3c870de090b9c29b60c5 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/627244f9d313477b77dc7b22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627244f9d313477b77dc7=
b23
        failing since 139 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/627244e65de4660937dc7b46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627244e65de4660937dc7=
b47
        failing since 139 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/627244ac8bc139fc20dc7b4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627244ac8bc139fc20dc7=
b4e
        failing since 139 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/627244af8bc139fc20dc7b59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627244af8bc139fc20dc7=
b5a
        failing since 139 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627249be4b8779d009dc7b22

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-84-gbea55d0a1d975/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627249be4b8779d009dc7b48
        failing since 59 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-05-04T09:38:53.098445  <8>[   31.718653] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-04T09:38:54.108322  /lava-6259112/1/../bin/lava-test-case
    2022-05-04T09:38:54.116947  <8>[   32.739256] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
