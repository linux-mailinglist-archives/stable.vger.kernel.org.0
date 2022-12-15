Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7B164D5F5
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 05:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiLOEq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 23:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLOEqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 23:46:43 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B13389C5
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 20:46:41 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id k79so5931955pfd.7
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 20:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VpLLS/NefwVKuiQ13tE21QT/sGqlx1hjoxbo+dDX/U8=;
        b=zVICHXTBuVTNkXuHTCgnlSeAAYgkLpb76Z9r63la2RaICPkPW44KN2L30dAO/dcWJq
         vyfkfVShXoJXNJQw80f8aEOrr7H6XYdlWNbH5gdtTk9V87C36MZ2nb2AB17SqhdzQKLv
         cFrN0Hhq6G0GtY7oYWb7Cm5VmtnEqnmkEv++Zorp4pAmcVAbT+x9Ng5EAU1SjanE8Ct5
         kYsH6UbmiuAfLfJbOlaIRhyrTEyfBW9YaeTFC68qLygbpWvfy7go2QrsQcBLiesXqTZ9
         A7Rh7VpfxFx+3Qvf/k7+Y8ImhR66V8vWQMyMkSjUD7pYGDKvIs/Ik/Py7E+RykeJvJOO
         kryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VpLLS/NefwVKuiQ13tE21QT/sGqlx1hjoxbo+dDX/U8=;
        b=M6jjuBG33+h5mpKMNKqfJgWnbwhZETc+Jt0SLDSKg86fLh27xk5Kz2rAQ/yKpHrrdT
         JsLtbo4/99XFaEyzG2h/aP5CgfvjqC9I7lU13pKnEVQyTMJfXZ/4liJy7zZltAk6S8iP
         ggScKxQnM25nZ9dHLsgTGt3HuPF4utxcM5J1uEFt0sZK/m+VHQa1eplrqqgzxJd9pOIz
         vYBs1uHTBqAKtSW/nS05+qSaxJBpqSVBDHOT+apL7ckG+uUV1Ka9LS8rcFkdLfzIVZGa
         QVYH5CD0I6IiTXtPiqhhLTr0cB9YP89b+GeQhWUjFEF6wLAoUAs6Ipm2YyGDbFDW/qOo
         t+3w==
X-Gm-Message-State: ANoB5pklAmO2p0T1V/5tQ2+j1+o0fLUtu7xpO6yYmj+uqvi0YRD2N/lb
        WhOtC89B92F7f0cWnOYQeL/+9Dabj3Kt8iI1suK+BA==
X-Google-Smtp-Source: AA0mqf7qzeE3WzGY2tx/4MceBIRpFJCdoOfQUDwqqbZPwRiGGxsWxyQtFumPKjo/faVinEJ1korc0g==
X-Received: by 2002:a05:6a00:bd8:b0:576:65f5:c60a with SMTP id x24-20020a056a000bd800b0057665f5c60amr23993288pfu.27.1671079600747;
        Wed, 14 Dec 2022 20:46:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 19-20020a621713000000b00574de4a2fc7sm633254pfx.205.2022.12.14.20.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 20:46:40 -0800 (PST)
Message-ID: <639aa6b0.620a0220.2a952.1b1b@mx.google.com>
Date:   Wed, 14 Dec 2022 20:46:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.302-2-g4908b59db49d7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 93 runs,
 10 regressions (v4.14.302-2-g4908b59db49d7)
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

stable-rc/queue/4.14 baseline: 93 runs, 10 regressions (v4.14.302-2-g4908b5=
9db49d7)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.302-2-g4908b59db49d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.302-2-g4908b59db49d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4908b59db49d7edc1d3067140e71712a42b63e43 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6b5103684898ab2abd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6b5103684898ab2ab=
d20
        failing since 162 days (last pass: v4.14.285-35-g61a723f50c9f, firs=
t fail: v4.14.285-46-ga87318551bac) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6bfd6cf002cd532abd2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6bfd6cf002cd532ab=
d30
        failing since 240 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6b6bdabb55edb52abd3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6b6bdabb55edb52ab=
d3b
        failing since 218 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6bcdb8603d6bc02abd07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6bcdb8603d6bc02ab=
d08
        failing since 218 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6b68dabb55edb52abd21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6b68dabb55edb52ab=
d22
        failing since 218 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6bb9b8603d6bc02abd01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6bb9b8603d6bc02ab=
d02
        failing since 218 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6b66dabb55edb52abd1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6b66dabb55edb52ab=
d1f
        failing since 218 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6ba5ddfd1d4d752abd27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6ba5ddfd1d4d752ab=
d28
        failing since 218 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6b65c21c75ccc62abd21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6b65c21c75ccc62ab=
d22
        failing since 218 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/639a6b912c3c25aad72abd2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.302=
-2-g4908b59db49d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639a6b912c3c25aad72ab=
d2e
        failing since 218 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =20
