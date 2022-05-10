Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D22852150C
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbiEJMVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 08:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241671AbiEJMVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:21:02 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10861F6891
        for <stable@vger.kernel.org>; Tue, 10 May 2022 05:17:05 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v11so14793703pff.6
        for <stable@vger.kernel.org>; Tue, 10 May 2022 05:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NEhaWyaGGt8rwnihDwWCEIrBf2YRfmhv1EZ2piLe3/o=;
        b=o0C6+B2dNSDx35GnKUB/JsEmMxmZcA+kUxDMtbyv9yrhUG+LwDP23zP/WSSbnWgcY9
         GrHZDkhiLxEXf8to/tsyBsmOwCVZuLgnRSSkikdwUv2+56+m40y7Mtu1MmWUOzRbRRoI
         Zy2atQfPmwQVCFTKam8z3janFq36+X9ciEc054AeNqSYepGbELjpl4ihAYBxm23ZngMj
         7Gh5vpQg8gYR7FpLyszUognhl7JN02oYNmSn4EUGChjArmXw7itttKOp+OIdOMB3iNq6
         ZRG+l7RIizkmgSRjZB3UOGUene0GZI5O968Y5qZwx20rESKvJjWA4Mv/AYb9dlhsd7mS
         TI+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NEhaWyaGGt8rwnihDwWCEIrBf2YRfmhv1EZ2piLe3/o=;
        b=1qsxVHf8WwsMN9cJdfHmkPu9CyMNsQu1p+mA5/OkX4m3g+Swgv6l153y8G30A65nXD
         CFxXnRLwzH3gm/uptPhA+jy03x/J3ipU4zTodVn49aXHIULHyG1OPo0MbiOzO6Pt8VhD
         RqtKUK1eKNyfrkOVNiAvOhvozw5uRpAU7TBWgf/EsNrjwxuXwaLFNJjwF4GKbBaKOnmu
         XiIjzvG/sWQNhW3tdASO4LFUmzH7bC51Phh5o7YiemDfO4OCG4UbF+laaMNUwtZYUGuv
         1KslzzdSVt40jn3CCMAj1lrCo7owCDZOC9Skzhj8Fvy1nqWiPgUhjON6WCYTwh6vC889
         CkAw==
X-Gm-Message-State: AOAM533/g7UikmTfkei3Jd51EabS/mDjt2Jnx8Zr9FIhoAIL1AwXqtdr
        V9tVTlw42qXnF6IHFuC0kB2GEqFZh5OdyygCGLo=
X-Google-Smtp-Source: ABdhPJxmZ1y0QVZ7x/T31nXWdVkt6dWqLqdz18/4Tkcchpj0CURGIDi+TxgTOU/0p1Ry9aJRpcAG8Q==
X-Received: by 2002:a63:3409:0:b0:3ab:4d72:1f0a with SMTP id b9-20020a633409000000b003ab4d721f0amr16560768pga.420.1652185024400;
        Tue, 10 May 2022 05:17:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c10600b0015e8d4eb2a6sm1829691pli.240.2022.05.10.05.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 05:17:04 -0700 (PDT)
Message-ID: <627a57c0.1c69fb81.213e2.46cf@mx.google.com>
Date:   Tue, 10 May 2022 05:17:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.113-195-g7c30a988fd24
Subject: stable-rc/queue/5.10 baseline: 148 runs,
 8 regressions (v5.10.113-195-g7c30a988fd24)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 148 runs, 8 regressions (v5.10.113-195-g7c30=
a988fd24)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.113-195-g7c30a988fd24/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.113-195-g7c30a988fd24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7c30a988fd2413cb1aef7e3cf481c2f11a6f8473 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627a3b3c88044039508f57b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a3b3c88044039508f5=
7b1
        new failure (last pass: v5.10.113-129-g2a88b987a070) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627a26d605613bf2f98f573e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a26d605613bf2f98f5=
73f
        new failure (last pass: v5.10.113-129-g2a88b987a070) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627a3afe140958b79d8f5731

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a3afe140958b79d8f5=
732
        new failure (last pass: v5.10.113-129-g2a88b987a070) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627a26ad24398d90938f5750

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a26ad24398d90938f5=
751
        new failure (last pass: v5.10.113-129-g2a88b987a070) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627a3b3bb3826c34848f5738

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a3b3bb3826c34848f5=
739
        new failure (last pass: v5.10.113-129-g2a88b987a070) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627a26aff2bb67302b8f5746

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a26aff2bb67302b8f5=
747
        new failure (last pass: v5.10.113-129-g2a88b987a070) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627a3b3dbd11794c3f8f5719

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a3b3dbd11794c3f8f5=
71a
        new failure (last pass: v5.10.113-129-g2a88b987a070) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627a26ea8e6e9c81cb8f571a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-195-g7c30a988fd24/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a26ea8e6e9c81cb8f5=
71b
        new failure (last pass: v5.10.113-129-g2a88b987a070) =

 =20
