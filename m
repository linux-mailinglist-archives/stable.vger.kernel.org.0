Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1DF4B04AC
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 05:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiBJEzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 23:55:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiBJEzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 23:55:38 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B388F1E3
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 20:55:39 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c8-20020a17090a674800b001b91184b732so4879089pjm.5
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 20:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VOELICGCKJsR0dJGrWcuQyEPepPtiWXIThz9SQTzDko=;
        b=VChwtW0QGdPzEdKcuAdEXf9QHGvCK9PjKRW8e08nDPs5CvQZSjPqkIn/cpAoHG5gOE
         GEBivf0rPr663kpJBBp7Xp89XWeZ2rApdNsScSDE+IMPh/7i6CXRFjuqgYEJ17TWv6U2
         CAzxZWKaIho3cm3J+P66TNQfCt0w09ss517B53lO5058ii4xtgiLasTTfAy+en6LsxN6
         UjJljGC4rHJjMNe5yHulhvPjud2ieB+E1L9LRsXjWIXFOFe9ybyLB/dVSdCaDZYMd9GU
         QpvDdDIeL2AHUJ8qIUxy/dn/n6R7kvmjn6dr/O7sxya4F2oHNTBu6SRFnCLe98ThSDh3
         NoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VOELICGCKJsR0dJGrWcuQyEPepPtiWXIThz9SQTzDko=;
        b=0Jig1pQwEK1oifOACffa4T0cKQgbKMQY+HhOY7JRvquXmdX5pH9OL43jpNtxGyKQzH
         FZQFwMCe5fGDn5wxhg3NPY8v3STj5X5eqRQ0087PqJFQRB8drUrLgZ5LNyoZK00mbl8k
         wiBCvmF+P8bTH05UIdOvUDJiRZUcatfyL/wfcAvYbRkm6e7aT3Yc0C8BOzBAM60WNsk6
         Ba4GruxmX+BAtlDgOZ+Wnd32lz51TO8+/HpMehy6oTdanLMLZNXWRIHMvY1J7TQWm6qb
         8TYU0YLr9GAI4LLwwgl/ZH/3xM9uN+SgvAS5+ZCaeEkMZvE3QtskqSRD7cAqc9vPiV3N
         pdkA==
X-Gm-Message-State: AOAM530WdrrFw4EAIc8t91Htt6g2lLAIgKD3saZV5lW1pn8zX6Sc0xJM
        aBl2UnnQk/uwn5HquTH8U7pWzWUJbyTtyal6v68=
X-Google-Smtp-Source: ABdhPJyuY09P86fD8jFk14IC2xS6QiNdY7Zxy/XvEol7MzuVk9Kg1vSuJ6Y/YK1K1abhYJZXZtTGnQ==
X-Received: by 2002:a17:903:110c:: with SMTP id n12mr5672196plh.127.1644468939022;
        Wed, 09 Feb 2022 20:55:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b21sm531807pji.22.2022.02.09.20.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 20:55:38 -0800 (PST)
Message-ID: <62049aca.1c69fb81.a2147.1bd2@mx.google.com>
Date:   Wed, 09 Feb 2022 20:55:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.98-78-g06ef1e6fb8fd
Subject: stable-rc/queue/5.10 baseline: 75 runs,
 8 regressions (v5.10.98-78-g06ef1e6fb8fd)
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

stable-rc/queue/5.10 baseline: 75 runs, 8 regressions (v5.10.98-78-g06ef1e6=
fb8fd)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.98-78-g06ef1e6fb8fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.98-78-g06ef1e6fb8fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06ef1e6fb8fd2492a9d403a7c3c96532cccf8484 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62046069206704c1a0c62998

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62046069206704c1a0c62=
999
        failing since 1 day (last pass: v5.10.98-74-g5fa2d158ab2f, first fa=
il: v5.10.98-74-g6e61834816cd) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6204607376d713bd01c6296e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6204607376d713bd01c62=
96f
        failing since 1 day (last pass: v5.10.98-74-g5fa2d158ab2f, first fa=
il: v5.10.98-74-g6e61834816cd) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62046056bf946c9095c6298b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62046056bf946c9095c62=
98c
        failing since 1 day (last pass: v5.10.98-74-g5fa2d158ab2f, first fa=
il: v5.10.98-74-g6e61834816cd) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6204607276d713bd01c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6204607276d713bd01c62=
96c
        failing since 1 day (last pass: v5.10.98-74-g5fa2d158ab2f, first fa=
il: v5.10.98-74-g6e61834816cd) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62046055d33c92a5eec6298d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62046055d33c92a5eec62=
98e
        failing since 1 day (last pass: v5.10.98-74-g5fa2d158ab2f, first fa=
il: v5.10.98-74-g6e61834816cd) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6204607129926918d5c62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6204607129926918d5c62=
982
        failing since 1 day (last pass: v5.10.98-74-g5fa2d158ab2f, first fa=
il: v5.10.98-74-g6e61834816cd) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62046054206704c1a0c6298b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62046054206704c1a0c62=
98c
        failing since 1 day (last pass: v5.10.98-74-g5fa2d158ab2f, first fa=
il: v5.10.98-74-g6e61834816cd) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/620460708b4a121a3ec62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.98-=
78-g06ef1e6fb8fd/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620460708b4a121a3ec62=
969
        failing since 1 day (last pass: v5.10.98-74-g5fa2d158ab2f, first fa=
il: v5.10.98-74-g6e61834816cd) =

 =20
