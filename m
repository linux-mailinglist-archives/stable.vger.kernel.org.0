Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6446B5975C3
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiHQSbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiHQSby (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:31:54 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD89AFC2
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:31:53 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l64so12690418pge.0
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=wXcvznCjcsnW0WYocWLqLCWrO7zPF3xWuyPgRNCvZeU=;
        b=E4PI9JpVIhvnIVLv8bRRMRvsDzxgYI52Lq+oYKISCe179vBMXznNiygQNJwB4MC9DA
         JHkY/uXpnaFgCpWB0l5O8RFz3ZtSAWn1hwa/oJaoCjBmxFBuGKXHQIGQ+2H7v7mF4Nbd
         2fyX7NyKaQx2IN2+xGfOJSjw3MDhr1Q9go5ZQTBB6qjKjenSZV9fCc3shm2zEsB6udW1
         4kMYoLc86Zc0HhtyMCjjfmficKeJExoqoxMIqR5HugdozKyxTpxR5MQ8kJaBKpWBllZ/
         NePRuzGfn8LMR6KlrjQSzk/d7856+eth56MexK3UXNURl8KeqK2B1yByIuSc+flc3qO9
         bk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=wXcvznCjcsnW0WYocWLqLCWrO7zPF3xWuyPgRNCvZeU=;
        b=RSQQTigeQOumW2OZE2+QWS/hiuj2iM1OlRjFUR7O6hOL276iEnA/y+CtsDx1vUowDC
         XzAG/bHWOsA/Aa+80vurgcW7+E0i3KSqmGRfVm6Ylg4l9iehxWAM2XomjpKzdyRzYmTG
         DUROLD8IKwJrJRiQDEaqQX+QlHTdCCwYoAKRfHXxOWCG7fNtvObDMdh9VXQkTzJME9nf
         2MY9NOC87yNFGtII+9iBInTjHhyGIDG3if3Llmb57xFo0elcEXpUop2CWNjT5JTOLXnt
         DZYJV5usr3XZZ9tZlS5X97LkaCGCUtqP5wKja/rLAGYsnHzBNU1vgL7eJszH2nnKOlcg
         a5+A==
X-Gm-Message-State: ACgBeo15fIzKb9EksycHnygH/nGduD5fNBNJiM6g663yIrGlHR3Dgvyx
        0Fzdbdka0VUJeJTGOi7+GamJSjjArZ68w4tJ
X-Google-Smtp-Source: AA6agR5SlLducYM7ODXSZxOZHbZ3gWmBOxsPoBaKlXEXkAO3EaNv15e/3PYIFQakoaIhlyaNaBWtow==
X-Received: by 2002:a63:d703:0:b0:41a:8d7a:eb3d with SMTP id d3-20020a63d703000000b0041a8d7aeb3dmr23499870pgg.59.1660761112530;
        Wed, 17 Aug 2022 11:31:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b0016c57657977sm263106plk.41.2022.08.17.11.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 11:31:52 -0700 (PDT)
Message-ID: <62fd3418.170a0220.14252.0970@mx.google.com>
Date:   Wed, 17 Aug 2022 11:31:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.136-539-g2b0d128e38cdb
Subject: stable-rc/queue/5.10 baseline: 135 runs,
 11 regressions (v5.10.136-539-g2b0d128e38cdb)
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

stable-rc/queue/5.10 baseline: 135 runs, 11 regressions (v5.10.136-539-g2b0=
d128e38cdb)

Regressions Summary
-------------------

platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
hp-x360-14-G1-sona         | x86_64 | lab-collabora | gcc-10   | x86_64_def=
con...6-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora | gcc-10   | defconfig+=
arm64-chromebook   | 1          =

rk3399-gru-kevin           | arm64  | lab-collabora | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.136-539-g2b0d128e38cdb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.136-539-g2b0d128e38cdb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b0d128e38cdb54c2fe4239a128e46882d5bd380 =



Test Regressions
---------------- =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
hp-x360-14-G1-sona         | x86_64 | lab-collabora | gcc-10   | x86_64_def=
con...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd02ecc9d7de32c3355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd02ecc9d7de32c3355=
643
        new failure (last pass: v5.10.136-539-g452d6f33fed31) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd01efed14f94d3335564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd01efed14f94d33355=
64d
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd036a7678f6c505355673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd036a7678f6c505355=
674
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd01b19ea87a7745355685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd01b19ea87a7745355=
686
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd03575a3997e61e35564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd03575a3997e61e355=
64f
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd019ddb55b37191355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd019ddb55b37191355=
676
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd0341316b0646af35564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd0341316b0646af355=
64d
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd01eded14f94d33355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd01eded14f94d33355=
64a
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd035691d8e7a6cf355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd035691d8e7a6cf355=
644
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd074228fa317162355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd074228fa317162355=
658
        failing since 99 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                   | regressions
---------------------------+--------+---------------+----------+-----------=
-------------------+------------
rk3399-gru-kevin           | arm64  | lab-collabora | gcc-10   | defconfig+=
arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd02c25ac6dca231355644

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-539-g2b0d128e38cdb/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62fd02c25ac6dca231355666
        failing since 162 days (last pass: v5.10.103-56-ge5a40f18f4ce, firs=
t fail: v5.10.103-105-gf074cce6ae0d)

    2022-08-17T15:01:07.776942  <8>[   32.731215] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-08-17T15:01:08.800353  /lava-7061257/1/../bin/lava-test-case   =

 =20
