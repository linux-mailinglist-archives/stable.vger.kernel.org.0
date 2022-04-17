Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70146504961
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 22:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiDQUJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 16:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiDQUJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 16:09:27 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14175CFC
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 13:06:50 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t12so10884514pll.7
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 13:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TeAf8U1S0iEVRZc5BoFRS4h09RnNrlj+mCH5RdGg7iE=;
        b=yXMv6H1kmMqGhv7RmhP54/uXbwQnYKhkpZWvS/ZE8ImspsEWAw0/cv6agzikAa2mMX
         nolrLRdiGu9MbxQPPkL3eV8NS0mav0V6KSmADR+60fTOBxqJGAMSEzNIBFKQB0eQT7M1
         VUhUnIFZDCsnJgCdpRG7w3JMCNo8DQMrowSwmHXlok3UJDImOIU2H+qGg0Intx0Bger2
         tLOgImGEHxA4aCfPEeyWjBq0pe/YVBSNf6saP/F+Nx9M2369ToHiorDF6WknWp6Y1/kR
         Jju9PMmqO1YuvJSyB6yfea+NRUD4BA9ep13qTI+8RVbmORGFBGw0xuAuX/Fpg1X1Wh/m
         TUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TeAf8U1S0iEVRZc5BoFRS4h09RnNrlj+mCH5RdGg7iE=;
        b=tUN8hDZQNCE4FP/QnH65BVyqiBNL4/p4jNpeRsoYaDjMt/LN9rkga4enaxK8175iwa
         gqlPnqiWw106oVJWwC5GjBb7HeVaqgnVh4zWCAmaPbvun6bcOaLdiMhnwQm+ESSD0eHa
         N24gGtGjGjkWue43t3QXJs4VcMgAu/bD0X69Q3uMcL9Fj2JM305PKpVoE7cHDYBkm9sk
         fgeRZyCVywjVVv7B03DEV7SW/FW21Pd+Xb4wrAqdWKvQqbBp/DjcS+SLBDnZHcZSAXl6
         vN3uwcZOO8MlIFAgsb9XKMo2g8qfmrBILvzOajsFRuoahWQkJFK7Hd7ZnwCKiOVgchsH
         9Lxw==
X-Gm-Message-State: AOAM531yNOa/7ulP9RyWoU0GwcerSStFAKL4P0Kv24eUIHqo4hetPlSY
        PKoOPqodEF+eymEoLjg5Vc+HcudWyH+AeDc4
X-Google-Smtp-Source: ABdhPJwtDLxQS7huJ40ROt+4ip0ENIQMayKoXM6TUmbGq5LCqx8aVXfTJCNk9spUCg6+aDQl7k17Fw==
X-Received: by 2002:a17:902:b60a:b0:158:9543:70ab with SMTP id b10-20020a170902b60a00b00158954370abmr7803957pls.82.1650226009386;
        Sun, 17 Apr 2022 13:06:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16-20020aa78090000000b0050583cb0adbsm9381504pff.196.2022.04.17.13.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 13:06:49 -0700 (PDT)
Message-ID: <625c7359.1c69fb81.8f0f3.681b@mx.google.com>
Date:   Sun, 17 Apr 2022 13:06:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.189
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 108 runs, 4 regressions (v5.4.189)
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

stable-rc/linux-5.4.y baseline: 108 runs, 4 regressions (v5.4.189)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.189/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.189
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7f5213d755bc34f366d36f08825c0b446117d96 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/625c3f20d771bf0645ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625c3f20d771bf0645ae0=
67d
        failing since 10 days (last pass: v5.4.188-371-g48b29a8f8ae0, first=
 fail: v5.4.188-368-ga24be10a1a9ef) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625c4345ccc444107cae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625c4345ccc444107cae0=
67d
        failing since 122 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625c43212c0aba2e6eae06d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625c43212c0aba2e6eae0=
6d4
        failing since 122 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625c415d94c96ee98fae068a

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.189=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625c415d94c96ee98fae06ac
        failing since 42 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-04-17T16:33:13.765565  /lava-6110772/1/../bin/lava-test-case
    2022-04-17T16:33:13.774073  <8>[   31.403209] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
