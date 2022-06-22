Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3363655523B
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 19:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376334AbiFVRTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 13:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376324AbiFVRTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 13:19:49 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934441EC41
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 10:19:48 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e63so15170636pgc.5
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 10:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xXXRLFSrBde4kSKjOFsD9Uro55pVh9qZ6BtgNifUpSM=;
        b=uTn/rupc17c7Ni2CRRbxOARWJc3OSYCrFs8yJDRj4//NsvsuwdMIIIdXTzlYsxInUl
         +YL8ilgU0ZX2XhOe+soJCNTPrxhpNcI3Aqdro2qFNzdKHV00dnL366Sk4utq9byJ3UDW
         Mo5D5zbd4aqmtes26w/aJFglExwJqyhnnscNWizGJMX/eYplYdeL+kR4A0NWujl9y5/G
         riNXnz8jfjTFmtSU3O5Dg5bEiBnkmUV++HAV6wO4T92OWW13uLkEKiLrF1N18Dy2In8E
         HTktC3JFZ0dOcNJoO9pJACoPsJdMEt8drRWkaGkQrWZtAFuM65BjNZhDGNs7dxJ3BM+5
         +ahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xXXRLFSrBde4kSKjOFsD9Uro55pVh9qZ6BtgNifUpSM=;
        b=zWm1cbpuotZM/OzqnG+tXn4OaUHeOhgUCGxcwQZdFe/wKPgJTtQhwqMvhyv+XK1WaR
         0eARToDEm2McGMtxvXxYUHvlZlSCo70ohnpkObTfXewetF+b5Dah2+qc8NWYh2NBxPCc
         ozvyZJL+72KNwlpcvg4ilsr20ZzF/2Nti6/sWJP4n1UKQYOOJuP+jaYZlDzwa8fqQVYk
         GKHxZgRCX002uYQTDQ6EpPk4q5SPDbTuSsiJXL0nuqWlVGchit6qxVB+1Uhha7xkhhQe
         uvgydz/3uNJY1T3+C1CdJrBaKXbcJ07etrra1FLLzkt/VKtmuEZoxiRhfLiq5UTeyUSB
         jQqQ==
X-Gm-Message-State: AJIora+MQZTdQapZdAU0Qofu8gUOG5IM7JEQN0l2Od3tosTnP+78GGuG
        9MHcGlg9xxFZfSkez5sQvqsv+cLhlioLsE30pc0=
X-Google-Smtp-Source: AGRyM1teAvjtA6c+E5dGF4BPWplOGbnC8LgGji8i0ZeR59L8oMUhO0/7gKvCyBpWz230chmbJaoZgw==
X-Received: by 2002:a63:794c:0:b0:40a:88ed:db99 with SMTP id u73-20020a63794c000000b0040a88eddb99mr3768346pgc.81.1655918387761;
        Wed, 22 Jun 2022 10:19:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12-20020a170902820c00b0016a42366127sm2529822pln.75.2022.06.22.10.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 10:19:46 -0700 (PDT)
Message-ID: <62b34f32.1c69fb81.1534b.4041@mx.google.com>
Date:   Wed, 22 Jun 2022 10:19:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.124
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 138 runs, 12 regressions (v5.10.124)
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

stable/linux-5.10.y baseline: 138 runs, 12 regressions (v5.10.124)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | at91_dt_def=
config          | 1          =

imx6q-var-dt6customboard   | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 2          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.124/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.124
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4f3fee72a74c88c9039ce0405a715f6221791d06 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | at91_dt_def=
config          | 1          =


  Details:     https://kernelci.org/test/plan/id/62b315890c87791d78a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b315890c87791d78a39=
bce
        new failure (last pass: v5.10.123) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
imx6q-var-dt6customboard   | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/62b319844bc3c65afda39bcd

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboar=
d.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboar=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62b319844bc3c65=
afda39bd4
        new failure (last pass: v5.10.123)
        52 lines

    2022-06-22T13:30:12.216323  lert : [0032001c] *pgd=3D00000000
    2022-06-22T13:30:12.232302  kern  :emerg : Internal error: Oops: 5 [#1]=
 SMP ARM
    2022-06-22T13:30:12.272711  kern  :emerg : Process udevd (pid: 137, sta=
ck limit =3D 0x(ptrval))
    2022-06-22T13:30:12.272971  kern  :emerg : Stack: (0xc3a21cd8 to 0xc3a2=
2000)
    2022-06-22T13:30:12.273200  kern  :emerg : 1cc0:                       =
                                c344fdb0 c344fdb4
    2022-06-22T13:30:12.273419  kern  :emerg : 1ce0: c344fc00 c344fc00 c144=
5f34 c09e3360 c3a20000 c1445f34 0000000c c344fc00
    2022-06-22T13:30:12.273852  kern  :emerg : 1d00: 0031fffc c3bec000 c200=
1a80 ef86fd80 c09f0acc c1445f34 0000000c c39c1140
    2022-06-22T13:30:12.277156  kern  :emerg : 1d20: c19c6cc8 97b4f6b2 0000=
0001 c3a56240 c39c1580 c344fc00 c344fc14 c1445f34
    2022-06-22T13:30:12.315796  kern  :emerg : 1d40: 0000000c c39c1140 c19c=
6cc8 c09f0aa0 c1443c58 00000000 c344fc00 fffffdfb
    2022-06-22T13:30:12.316083  kern  :emerg : 1d60: bf048000 c2298c10 0000=
0120 c09c6a88 c344fc00 bf044120 c39bfe40 c3551508 =

    ... (37 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62b319844bc3c65=
afda39bd5
        new failure (last pass: v5.10.123)
        4 lines

    2022-06-22T13:30:12.213719  kern  :alert : 8<--- cut here ---
    2022-06-22T13:30:12.213977  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 0032001c
    2022-06-22T13:30:12.214205  kern  :alert : pgd =3D (ptrval)
    2022-06-22T13:30:12.214422  kern  :a<8>[   39.660574] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31cb41cbaa6f20ea39fd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b31cb41cbaa6f20ea39=
fd3
        failing since 43 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31e4d5181cf7e3ca39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b31e4d5181cf7e3ca39=
be9
        failing since 43 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31cddf2bf319079a39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b31cddf2bf319079a39=
bde
        failing since 43 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31eedefc0180385a39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b31eedefc0180385a39=
be8
        failing since 43 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31cb51cbaa6f20ea39fd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b31cb51cbaa6f20ea39=
fd9
        failing since 43 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31ed939a177f93aa39c41

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b31ed939a177f93aa39=
c42
        failing since 43 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31de0bbb97c8133a39c26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b31de0bbb97c8133a39=
c27
        failing since 43 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31f298969a656b5a39bf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b31f298969a656b5a39=
bf3
        failing since 43 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b31c90058c7821e9a39bd0

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.124/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62b31c91058c7821e9a39bf2
        failing since 105 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-06-22T13:43:31.279326  /lava-6668297/1/../bin/lava-test-case
    2022-06-22T13:43:31.290493  <8>[   33.720176] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
