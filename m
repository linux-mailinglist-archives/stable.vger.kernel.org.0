Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB755F58C0
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 19:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJERBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 13:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJERBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 13:01:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88CF3DBCA
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 10:01:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h10so13178631plb.2
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 10:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=KRaWBuLgrEWTKa+5NiubE/J3/9/xy+EADB0oo6Jnk14=;
        b=CiKdoHgFiIVgFXkLl7rDNAUn5H1kww54SER7BhO8pMuRVkjer9FKZFQ31SdcZUy7Cy
         bCxrq4VfiL+keaehchS8D4bu7mKRPsR/mBzQzztQzSrg9/GZ2rHOKO3eg4pTdqiMyIPX
         tzidxwIP5A48DaBJ4K8pt9C/NbH3y/tr1vBIdgmVCdbL5zsZlR/wipjNhfXqSw02aqP1
         oSkRxdQV/9zHcqg65Pmx1iu+Z2js0dXXX0ivYlE1KJZ3MzTUWTJzPHLL93+7JvkZcR8+
         c0j66JehfT3vpeI9/kfVFfPqNH7WU/j7r/1KCOtv0IZFf178v4R5eWfdqpVxfig+zEQd
         /9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=KRaWBuLgrEWTKa+5NiubE/J3/9/xy+EADB0oo6Jnk14=;
        b=0PZvNybR0hyE58eov0kqf3b/xT+eMAe2MfgyF7vfNalrM8o0D9ElFkTph2zmI+D89z
         oEVYdN18gT81/IFfuwEKuwblAU2EQ5unAC8vYikZtdZnRsQPzNcytaXAbIE1WHmVFx/Y
         NhVIFxwmX0NhOqbroOWFx7wSI0pCjkqgX5i9alaCi8H2rx67xNFki30FsLkhG8cAmuFT
         rhcN8mEj6kFAIJmtwaLMw8OiePieLJBiLEEX9lcvuvXNFT2jVVJisVgL7PNXiDT0ilU/
         aHiw6rjdTC4feIY6jCY24ggHWNL3pAXkHjylB4Euyvw23QVpiPIaDmEHPKLTqBYy0ug0
         glqg==
X-Gm-Message-State: ACrzQf0uAR9Hey4lcprdME4t++bo9b9Jrey2NcD1wJOmBGdH+r1wTe0X
        gtmPsSPQJDwDwdQTvQAo5XCai7CUItFHGo9FuMM=
X-Google-Smtp-Source: AMsMyM4zryIVIwsZZ3hv0DiaAnpRhJHSQFilWYcEkx1M6LxTiKGPh78OEDYNfA//mp9VzljKa9uG/A==
X-Received: by 2002:a17:903:2452:b0:178:1c88:4a50 with SMTP id l18-20020a170903245200b001781c884a50mr439889pls.113.1664989261758;
        Wed, 05 Oct 2022 10:01:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902714d00b001755ac7dd0asm40851plm.290.2022.10.05.10.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 10:01:01 -0700 (PDT)
Message-ID: <633db84d.170a0220.bfb16.01f9@mx.google.com>
Date:   Wed, 05 Oct 2022 10:01:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.146-52-g014862eecf03f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 135 runs,
 10 regressions (v5.10.146-52-g014862eecf03f)
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

stable-rc/linux-5.10.y baseline: 135 runs, 10 regressions (v5.10.146-52-g01=
4862eecf03f)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =

panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig        | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.146-52-g014862eecf03f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.146-52-g014862eecf03f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      014862eecf03f58066a957027dde73cbecdf4395 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/633d8e1f860da847cdcab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d8e1f860da847cdcab=
5ed
        failing since 37 days (last pass: v5.10.136, first fail: v5.10.138-=
89-g10c6bbc07890) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/633d8c67cbc70b0a3dcab5ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d8c67cbc70b0a3dcab=
5f0
        failing since 37 days (last pass: v5.10.137, first fail: v5.10.138-=
89-g10c6bbc07890) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633d8464e5dc088f1ecab5fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d8464e5dc088f1ecab=
5fb
        failing since 68 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.133-102-g3dbf5c047ca92) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/633d9277a85c3dfec4cab610

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d9277a85c3dfec4cab=
611
        failing since 22 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.142-80-gd4bb3d725075) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633d83c436bcb1ab8acab5ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d83c436bcb1ab8acab=
5f0
        failing since 68 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.133-102-g3dbf5c047ca92) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/633d9251e8d365039fcab5ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d9251e8d365039fcab=
5f0
        failing since 48 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.136) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633d8433e92e22da95cab5fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d8433e92e22da95cab=
5fd
        failing since 68 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.133-102-g3dbf5c047ca92) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/633d928e7375dbae26cab61f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d928e7375dbae26cab=
620
        failing since 22 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.142-80-gd4bb3d725075) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633d8401e75042f99fcab600

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d8401e75042f99fcab=
601
        failing since 68 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.133-102-g3dbf5c047ca92) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/633d9262e8d365039fcab611

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-52-g014862eecf03f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d9262e8d365039fcab=
612
        failing since 22 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.142-80-gd4bb3d725075) =

 =20
