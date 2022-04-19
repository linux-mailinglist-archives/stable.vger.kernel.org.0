Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC855062EB
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 05:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiDSEAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 00:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240345AbiDSEAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 00:00:33 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBED21825
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 20:57:52 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t4so22608435pgc.1
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 20:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nfeEFbiis/pRGR+HIK00X3UkgaJvOE8QWHV567Jn8l0=;
        b=RKLFWFdKNPM2NLLNW+vtDfJ7gMMzRbskWKuLK0LohzIAbekS/AenBI5r4jsu7kdfN8
         x/M5uW9rgUMEkO1HJ9tG7liPDlJZC3SKOeVKS9IZxQVZTFBfkc/hhlVfbQLbW00FC+D3
         9vqZo5zL9URHZbaqQ0wCrAgEw7QFsV0ZKzU5YQgUfmnWvmuxT3xPZoT7U0/dwhG1Tsxv
         gHKLtc/MEOoEgZ5FmqSn5t3/8NCWehvAGdw1bOqjR2AQeg1IxWLbDbAquQhFysBcoDG7
         sYCWod2gdofimaFhWRaxOuNxAjOOzZ/8DeX6iTBIB2JokjL8N0ZPQETWYpaMhgtMhk1M
         KAnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nfeEFbiis/pRGR+HIK00X3UkgaJvOE8QWHV567Jn8l0=;
        b=syS065P4aDL0Y2SYBpI0x9kGX2kETwuWpxB6vD6uI3mHNg9vKVbcOLMSCUc/sPomE4
         yBxotIr6bT4LtzkVQrJh2eYPfGNLbSAdG3cTUVvA/9cap7p7wtUnaljWWpGLyiacxGQE
         cmlUN1FruraQYQKm/sLJlwQM74bqqP//D1rL5pY0l7UXUkthBj+vOZ19UHKXfXNrD7FP
         XB9FLNI0CEgiOwbLrnf13uCi1wSTQbGubSLrBaZkomSPWlXj/h1228zwrS0BKAzVsS2E
         5Q+qVpPLAyzQutYtuay3zd42PzrLN3YxZMSXi3h70R7EgX2HhXylkdlKJFeEIGnIzCux
         sb9Q==
X-Gm-Message-State: AOAM533PN3eDX6fiufe2ty8F7h5fY/HL4vbrFRmPImviMD9T4JGGUZPe
        ifinw/TCyivPtUFhEZMrzrdwUtgFRSA9Tfd1
X-Google-Smtp-Source: ABdhPJy4WR3NoWV7yZunwezP7yr1D46ZwZ/PD6LenWR3vlUo17FxCOZWWeli+ADDg6+dj0bXpK+l0Q==
X-Received: by 2002:a63:2305:0:b0:39d:1299:29c9 with SMTP id j5-20020a632305000000b0039d129929c9mr12727222pgj.244.1650340671456;
        Mon, 18 Apr 2022 20:57:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6-20020a626406000000b005060889f2cdsm14399844pfb.191.2022.04.18.20.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 20:57:51 -0700 (PDT)
Message-ID: <625e333f.1c69fb81.4df39.26a8@mx.google.com>
Date:   Mon, 18 Apr 2022 20:57:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.189-63-g979c306c190c0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 90 runs,
 5 regressions (v5.4.189-63-g979c306c190c0)
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

stable-rc/queue/5.4 baseline: 90 runs, 5 regressions (v5.4.189-63-g979c306c=
190c0)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
at91sam9g20ek            | arm  | lab-broonie  | gcc-10   | at91_dt_defconf=
ig  | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.189-63-g979c306c190c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.189-63-g979c306c190c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      979c306c190c0fd2a2f72095f8afc3d8b7c5c883 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
at91sam9g20ek            | arm  | lab-broonie  | gcc-10   | at91_dt_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/625dfe77a191c9b51cae06a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625dfe77a191c9b51cae0=
6a2
        new failure (last pass: v5.4.189-40-g9b0b28a795f06) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625e0239080314483eae0698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625e0239080314483eae0=
699
        failing since 124 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625e0215080314483eae0680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625e0215080314483eae0=
681
        failing since 124 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625e023a9572da4930ae069e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625e023a9572da4930ae0=
69f
        failing since 124 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625e02169572da4930ae067e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
3-g979c306c190c0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625e02169572da4930ae0=
67f
        failing since 124 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
