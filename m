Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD24CEA8F
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 11:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiCFKnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 05:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiCFKn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 05:43:29 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5061EBE9
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 02:42:37 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cx5so10884176pjb.1
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 02:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/qU0qkz0o7JbjRhbCkCLU+DiOXBx6DmyE970Ou8mJwA=;
        b=AIXXrbeUnWikWvyYHe/ru9Sgf7wvEMOdfi226tUxXS1Uya7hL2Nt5ImwBgMHHsLUQn
         AuL9klzJGv4lo4LVG0D5VS85F2NSVINbod+vInpeDjBg8N2C2OZmmugLXK1nnA9fkbq4
         uGzmvQuKrKIAKhFyFqVqsytPyAR7+smj9BLagMU0KNC3zBGNBRvxgQj9EKDJFlObdF/C
         5Vs4pNoeJLHHyO09St9t7Gtvp1PU7q7TVtMwSzkAfOGZgSxcRVFAAWQJuY5h0YwM0xH5
         K+Rpyq8yjkGdu71ct38zffLBn9C9I+fcc99ea052SqgZAqfukGg+X4As6uMg5HDHnsEM
         DUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/qU0qkz0o7JbjRhbCkCLU+DiOXBx6DmyE970Ou8mJwA=;
        b=U2Xvk1UlX68Vbe9AGdUm7ynpcPUwK/fqNcIn0xr9/f+xCFGmxRg8MaGLnN4EyT0PTj
         KJ8Ns4dLlLDKmHhiXREr6DsMHU80WrWTiYbwHqjKVO6STTjQTMJbF6nC/T6Yb161hN/r
         C1RXqKRNoJm8iVDFOT4ObO84XOObF8O6/xmPB8Af6LG9yosTBviYCOqEeelb6+AhiOaZ
         e6aJZJ9HKVtGA8/oyM4L8uASICcQzzOw+6SHiOAbuQS39FpmgciuETOLvys/Jv8s64oX
         xZPP29iBecr78vGUDrnnGA6VC+Klo/mqP4fuQVEtL0kZaNfekRk1BjyYUO7iIX7NvIoD
         p3fA==
X-Gm-Message-State: AOAM532x3c0zaW0jl52y1GZrweIEjYMRRLKuw1Cxx7dwQTcJ/8oF8dqa
        fvjE8kg5xxuhGfwIXEETw3PN2GE3TdfajBg1aZ4=
X-Google-Smtp-Source: ABdhPJzLeX/6wzH03bCsYXNt9WEm85d7Q3AQXBdf4I2IMEcVZv47BdOjxGYWy5ED0aMSXK/K4V+nQA==
X-Received: by 2002:a17:902:8e82:b0:151:777b:6d7 with SMTP id bg2-20020a1709028e8200b00151777b06d7mr7120459plb.172.1646563356676;
        Sun, 06 Mar 2022 02:42:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l9-20020a655609000000b0037589f4337dsm9228533pgs.78.2022.03.06.02.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 02:42:36 -0800 (PST)
Message-ID: <6224901c.1c69fb81.198fd.810d@mx.google.com>
Date:   Sun, 06 Mar 2022 02:42:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.182-54-gf27af6bf3c32
Subject: stable-rc/linux-5.4.y baseline: 108 runs,
 3 regressions (v5.4.182-54-gf27af6bf3c32)
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

stable-rc/linux-5.4.y baseline: 108 runs, 3 regressions (v5.4.182-54-gf27af=
6bf3c32)

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
el/v5.4.182-54-gf27af6bf3c32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.182-54-gf27af6bf3c32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f27af6bf3c329e40e487595d9c927f908e69f3cd =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622457d50164778a75c6297c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-54-gf27af6bf3c32/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-54-gf27af6bf3c32/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622457d50164778a75c62=
97d
        failing since 80 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/622457d40ab088d572c62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-54-gf27af6bf3c32/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-54-gf27af6bf3c32/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622457d40ab088d572c62=
982
        failing since 80 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62245bdbd1d1cdbdd7c62968

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-54-gf27af6bf3c32/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-54-gf27af6bf3c32/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62245bdbd1d1cdbdd7c6298e
        new failure (last pass: v5.4.181-51-gb77a12b8d613)

    2022-03-06T06:59:24.272664  <8>[   31.485494] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-06T06:59:25.283696  /lava-5824611/1/../bin/lava-test-case   =

 =20
