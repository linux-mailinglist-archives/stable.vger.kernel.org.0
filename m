Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB2A5A511B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 18:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiH2QJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 12:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiH2QJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 12:09:54 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5108FDC
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 09:09:47 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q63so8089396pga.9
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 09:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=lubr/6Hp6i22CZ4i1KkL6NE+xmfCGYq9b6c6cIkV708=;
        b=c1S7Xl/ObZoFNGv6YHEkbm8yugQljblwZs8UCpZK3yJKlLfWAVtaCTReFc995nlhkx
         e1P/QcZbaK95TIBsTCLM5WNwlkJjPBxyBSkn7D0Rq5xE0ME2VHhQgplSWKoIdGHovE4S
         Isd/ugbJj9cTU5JYNefCVXozrenrHJggEiZAhl01hX8MxEn1YvdpTTW/xGeD3iiaoarx
         CFkS+2ngdFAq8iUB4bbAQGX+aTJHs8BcsuOgLTyiSLDT4MgP6V166l0ukVRS2BbBREic
         esexaAOGgKRk0BEQtz+pQhrwTOkwk3Fhox1euKSohcd+I/DvfWflwV9+QGvV9h9CEIfN
         LeUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=lubr/6Hp6i22CZ4i1KkL6NE+xmfCGYq9b6c6cIkV708=;
        b=doYBi7ySIS9dEa/HMgIOXUZ+xcIFnGckx3XuZu/g904RckLMKiM18c67KLBY2uH06G
         gnv44mI9H+is4Te+/ei35uU29DBF1FS3wiwC9V1QrzfacsjxxYietOwfoqI3EKl65Us7
         fgoTm0FOEuMF76XwyyvBNG39nldoDKxmb9cvtj3l3BPn+dCtWCVQe86/jNYi6EuIDqBY
         1t2r+oMB6YKAju4SK+/FccH1VK9rh3TDjF9LwxNN3as8UWwj64QQiCBnY3gtkCefGmh+
         32A1z58pl0kTGvMGHo6fP0BXF2U+D9J3DGJdDzlstKMx6Or8Wpz7me82Wh4bmXa4+RHm
         OrKg==
X-Gm-Message-State: ACgBeo0ZjapLoI3uX1ex5Z7jQFnLreqaYgwQLgG6Lvza9qXgT7nP7FgN
        Bn9VOp8W2JXUIqWfL03PAW4kbFDVxmsRsQKeGAM=
X-Google-Smtp-Source: AA6agR4K+VYQJVO6JhpPQHbVODVO3Bbbt+9ZZu7+pD29NVkE9HxqGFXUVDhpMI7P1zNflR2jRYG0Gg==
X-Received: by 2002:a63:69c7:0:b0:41c:590a:62dc with SMTP id e190-20020a6369c7000000b0041c590a62dcmr13999044pgc.388.1661789387023;
        Mon, 29 Aug 2022 09:09:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a20-20020aa795b4000000b00537b11ccfafsm2072186pfk.127.2022.08.29.09.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 09:09:46 -0700 (PDT)
Message-ID: <630ce4ca.a70a0220.6311d.3754@mx.google.com>
Date:   Mon, 29 Aug 2022 09:09:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.138-89-g10c6bbc07890
Subject: stable-rc/linux-5.10.y baseline: 175 runs,
 7 regressions (v5.10.138-89-g10c6bbc07890)
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

stable-rc/linux-5.10.y baseline: 175 runs, 7 regressions (v5.10.138-89-g10c=
6bbc07890)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
imx6qp-sabresd             | arm   | lab-nxp      | gcc-10   | imx_v6_v7_de=
fconfig | 1          =

panda                      | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config  | 1          =

panda                      | arm   | lab-baylibre | gcc-10   | omap2plus_de=
fconfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.138-89-g10c6bbc07890/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.138-89-g10c6bbc07890
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10c6bbc07890234ed728ef39924dcdd3bd211e15 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
imx6qp-sabresd             | arm   | lab-nxp      | gcc-10   | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/630cb289817a02f8df355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-=
sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-=
sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cb289817a02f8df355=
659
        failing since 13 days (last pass: v5.10.133-168-g4f874431e68c8, fir=
st fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
panda                      | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config  | 1          =


  Details:     https://kernelci.org/test/plan/id/630cb4e6ad6abad6e1355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cb4e6ad6abad6e1355=
643
        new failure (last pass: v5.10.136) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
panda                      | arm   | lab-baylibre | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/630cb2b603645ce3a3355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cb2b603645ce3a3355=
655
        new failure (last pass: v5.10.137) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/630cb358a4fb86068d35564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cb358a4fb86068d355=
64d
        failing since 111 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/630cb36e45632849c8355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cb36e45632849c8355=
658
        failing since 111 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/630cb36dc5e0e493b4355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cb36dc5e0e493b4355=
651
        failing since 111 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/630cb35a2a76ff1bd4355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
38-89-g10c6bbc07890/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cb35a2a76ff1bd4355=
654
        failing since 111 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =20
