Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C180B5930CA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 16:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiHOObH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 10:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242714AbiHOOa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 10:30:59 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EFA18E33
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:30:57 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q16so6636959pgq.6
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 07:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=5JPH4W2lGUxk5rtuUUKjPzhgHw0KKnlUs6MLrUy1Oik=;
        b=PvJSAWfgbLeyX+ge+qDL4HGzTAX1tY3dFVJP3PBx8xcfdJ8RHP/3ZNtCy78XdRiohk
         MbE7Lh5RoL1tEN3GMsxuiL30dyKA3l1KMgNmf/CYXJDq2XG+ARIzYIcnHI4L3y80Aaqk
         3+eBULcSF47JOy4yKcsbL6+iZPCn///Mp/V5FzVRGHj0XXxF9n9g2eTjOR59uS7wDMG/
         b2RlSAjdpO7djQe8dTNvX/1NTRCtsC4veVnnX5lzO9jmbn+aoOWrmhHOAHvFjpzoLY9f
         G9hoT8c6HcasEXPngZemo7EZlZGglM+k/6jZ4X2b9jbugxvaNJlpHpI+cntMp95rnROM
         OZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=5JPH4W2lGUxk5rtuUUKjPzhgHw0KKnlUs6MLrUy1Oik=;
        b=VYfWFFd8Kx54ZT4QP+CuCpqFasrTn9ghz0U4SpGXDrdEZis2WhxNudsO2Lv7oyPKjq
         z8KrBmiFV8Dy9cbHKIBUl1gUDCMAgx4kMTzBT66FbbmBXTDa6jc+MZ6GQZ3GbhJrLgJK
         Krvdd7UST77scB26PDsXQvVKuvJ6PtaI6HUb5e9LTB2H+qKFg9/PN8qTj3ay61BhPa8h
         zohwvnGBBdvlYgBY3NY4qe57zDTns8wA17oXGvqLHZJwj+S2AOH72L7hvGKrIC2dqTsn
         BNjFOd9+pQi4R3WjI6uqss4c7+7v15m3cO6gpxxpsI5lzTycuN3n70B+hXK2/nA8pPYb
         yiYg==
X-Gm-Message-State: ACgBeo1wGhS2FseHO3VeJNVnn3oizYOvLERddhweRM+/Q4qoy3dFhUpL
        FErkdC1H9gJ0cWgHSbhLxfNREFECSYKW1w+B
X-Google-Smtp-Source: AA6agR5LXb1Parl+SFfi1Kdmkw7J/DhES0ceBNQmJbwP/gT42l/g29BDiSbUWoAfTiMv3oAhLzWFXw==
X-Received: by 2002:a05:6a00:15c7:b0:52e:5a5d:27fa with SMTP id o7-20020a056a0015c700b0052e5a5d27famr16629692pfu.52.1660573856772;
        Mon, 15 Aug 2022 07:30:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d206-20020a621dd7000000b0052dcd14e3desm6609455pfd.183.2022.08.15.07.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 07:30:56 -0700 (PDT)
Message-ID: <62fa58a0.620a0220.5e53c.a9c1@mx.google.com>
Date:   Mon, 15 Aug 2022 07:30:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.325-51-g469b0835c7652
Subject: stable-rc/linux-4.9.y baseline: 92 runs,
 18 regressions (v4.9.325-51-g469b0835c7652)
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

stable-rc/linux-4.9.y baseline: 92 runs, 18 regressions (v4.9.325-51-g469b0=
835c7652)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6q-sabrelite            | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =

odroid-xu3                 | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.325-51-g469b0835c7652/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.325-51-g469b0835c7652
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      469b0835c7652c7640872e5453bd6ba9f6413ec0 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa266b9c691c69c1daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa266b9c691c69c1daf=
058
        new failure (last pass: v4.9.325) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6q-sabrelite            | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa24300c96453a7bdaf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa24300c96453a7bdaf=
078
        new failure (last pass: v4.9.325) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2689ed0df35f10daf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2689ed0df35f10daf=
066
        new failure (last pass: v4.9.325) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa26b2c5cba20cbadaf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa26b2c5cba20cbadaf=
05a
        new failure (last pass: v4.9.321-30-gaf28a1763ea8) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2e3bd62517593ddaf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2e3bd62517593ddaf=
05b
        new failure (last pass: v4.9.325) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
odroid-xu3                 | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2df37b05f32293daf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2df37b05f32293daf=
06a
        new failure (last pass: v4.9.325) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa237f149ccd4617daf0a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa237f149ccd4617daf=
0a4
        failing since 13 days (last pass: v4.9.302, first fail: v4.9.324-43=
-g54391eec23dc) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2b8cd6b77fc4c6daf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2b8cd6b77fc4c6daf=
05f
        failing since 97 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa22e9060085f0d6daf0ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa22e9060085f0d6daf=
0af
        failing since 13 days (last pass: v4.9.302, first fail: v4.9.324-43=
-g54391eec23dc) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa23a64d70b02bbddaf09e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa23a64d70b02bbddaf=
09f
        failing since 11 days (last pass: v4.9.302, first fail: v4.9.325) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2cb809a6b03682daf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2cb809a6b03682daf=
05b
        failing since 97 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa22ea060085f0d6daf0b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa22ea060085f0d6daf=
0b9
        failing since 11 days (last pass: v4.9.302, first fail: v4.9.325) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa23e3bcb0ba03cddaf081

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa23e3bcb0ba03cddaf=
082
        new failure (last pass: v4.9.302) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2ccc09a6b03682daf07d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2ccc09a6b03682daf=
07e
        failing since 97 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa22eb604eb35979daf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa22eb604eb35979daf=
05b
        new failure (last pass: v4.9.302) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa23cf2841494011daf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa23cf2841494011daf=
060
        new failure (last pass: v4.9.302) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2b8db208245232daf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2b8db208245232daf=
078
        failing since 97 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa22dbdfb69439efdaf098

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-51-g469b0835c7652/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa22dbdfb69439efdaf=
099
        new failure (last pass: v4.9.302) =

 =20
