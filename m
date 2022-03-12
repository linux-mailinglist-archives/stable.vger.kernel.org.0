Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFAF4D7196
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 00:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiCLXpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 18:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiCLXpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 18:45:04 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304B627B30
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 15:43:58 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id bx5so11270461pjb.3
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 15:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zAcDX4qmlybZtCG5W9R7t5v05e4N43W6Y2Ib97RRoFA=;
        b=xkM8MAhZ6cyOYhkpYxCYN1Jjjr4DtiGqY69kd/jJ+D2pJIQKtQN6vevz2c7Dz2Ml8D
         e9JDlLAECFSHqz7ySuoDWuf/nZKTlDekvr+IGM182baE4FegwH/QVQn6l46OKOoBlv/d
         v5kLLTtaW6tSEjIE20DLQyeEC6+uYTJSxBSwUFPj9d6xzk5dB+1NtBzz96enB6n1LP6P
         wYAoY2PXffG+o5IEijlPtqLKFr9jVjzi+3qCD+0nVeYvjg1kQQXsj8uYjNWPDun19LnE
         E8B/w2Hd+LsaHHEhADRJ6iM4zhT2rd+hIjJflHlU7COu6fJ6Ctm6r5v8GiFwX/vghqnT
         I6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zAcDX4qmlybZtCG5W9R7t5v05e4N43W6Y2Ib97RRoFA=;
        b=LfwdCxRRA63vsb4uOUPpLCbAeK8zd/Jg3su+/VtNPv849ZcrzzuZvVG1K9fmukHWaR
         InUUTrXP35KZLU4b0tVewL2fn7zPkPrR+f0MhxUbiTS+BxZEdNnQAWvGExLPp48/DttJ
         aYn4JDVGbn38F9u4othSLlr0A+BTkEZstRUU0YuzBMRRw2zFuuKpIDvKJ/hmc2BlHhHb
         su6WqCCHr17ApSRSb6zYZU5D76VEBSh/EngNBI3QlkfZDxYSB8RekwSob3J3xRexG4Gn
         Xl9UKCYutFXjKRY2DHZrU7xcYnwWPkZY5E4e2ztIv2W7eNxGXAuq6h1Y6MNHJZwiHGx5
         Z/oQ==
X-Gm-Message-State: AOAM530hucnX5P8+bzFZYD8MLxahMa0QzmwkiyAz6/Hi1M52S8yOf4Fr
        mKPxyalBLBjtTr00DovVe6UNKw897DMFJwzRWW4=
X-Google-Smtp-Source: ABdhPJxT/T0OpA6M1AZwl5x4ucyPSvKF7OhjzN1geh2cK9W6x6ZhV39OxcxGn4uthBhalPzR9j2Vcw==
X-Received: by 2002:a17:90b:4ac1:b0:1bf:6d51:1ad9 with SMTP id mh1-20020a17090b4ac100b001bf6d511ad9mr28660652pjb.199.1647128637554;
        Sat, 12 Mar 2022 15:43:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm15356728pfm.200.2022.03.12.15.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 15:43:57 -0800 (PST)
Message-ID: <622d303d.1c69fb81.2b519.7346@mx.google.com>
Date:   Sat, 12 Mar 2022 15:43:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.184
Subject: stable-rc/linux-5.4.y baseline: 90 runs, 3 regressions (v5.4.184)
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

stable-rc/linux-5.4.y baseline: 90 runs, 3 regressions (v5.4.184)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.184/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.184
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1346e17653a52c2042a486c7726f92e81481c8ec =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622cf8502d36b409cbc62977

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622cf8502d36b409cbc62=
978
        failing since 86 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622cf84e065fa97474c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622cf84e065fa97474c62=
96c
        failing since 86 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622cf7d892bee6a71ac629ad

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.184=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622cf7d892bee6a71ac629d1
        failing since 6 days (last pass: v5.4.181-51-gb77a12b8d613, first f=
ail: v5.4.182-54-gf27af6bf3c32)

    2022-03-12T19:43:09.052741  /lava-5867227/1/../bin/lava-test-case
    2022-03-12T19:43:09.060734  <8>[   32.754572] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
