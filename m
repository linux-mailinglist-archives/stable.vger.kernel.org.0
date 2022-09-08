Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555A55B2247
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 17:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiIHPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 11:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiIHP3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 11:29:31 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA76EC770
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 08:28:38 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h188so17067843pgc.12
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 08:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=tyJ0iG2HAtNWIAk3hrcPi/ZZCmWp/AUIUU7nEFHnFzg=;
        b=kf97rD0sVMagPwYvm6l1GQdyEh0ZrZGeSSpMczpiY/Y6Iplr1z4AGKTcKA3pSYoV/C
         2s7szcmrswkT92BIlWZLR3QRupGJkbrG1yIle4v6DDsQVlTJGljGCNQUnOXs0xKucfOh
         A0BhCgiGMFA0v9uJrsOLB6UGk+/DLhXmavt6eGE6cN291EZy8ob/GBOhLSpuQEZ+Z0KL
         igARLc+nDJcCnz6Dlo3J02ulil/pL3amZHghp8kDA0djOeaulRxuZDP6iek+yXn0tS1g
         IiPD4hRQekUpyXR/us2z1WmXVKez5Wcqnb+FrVsXcesrqBJpvjjmxNUVAgxacJ/6bJVf
         xRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=tyJ0iG2HAtNWIAk3hrcPi/ZZCmWp/AUIUU7nEFHnFzg=;
        b=mylcmfqqpGrDqH2htzokOY9Zfr4MtAcHxjPY3iZ5oayA4uMCgOl9VSdNiC5+WbxQgc
         EA6naOseYxVfZFcxa+wZIqSvZ9DqtmW0u4OpdghTeUf/v+AKl0iGQpRZDhMiGubbhvbD
         p+1WXKhzGGc7Fw0MZOJFzz8TCGFALuE22310F54/PTp8/2Wxe6PQyxWMuFVopBLalnZT
         yC1bEAdjwvHjbtXnvg/w9RDI0Q+n8e2kg2czFq4EZXmumDamSxOQUFk42eepa/LmYvlS
         jlJn+cxxlXA0HHyVJKD4KJMkkVDYlYHCpMBhAyArYRLlzayuRSzMkh9FcYVnCgpgHMNE
         toVA==
X-Gm-Message-State: ACgBeo0m/iu6ErcGFDCjG/XaPfqq1PnKFk6dI/LVBsjSm0khNiGD1GrM
        3f1/2t7bipD5DhA1NLEX3ZFcDpjDXAj5PCzzBWk=
X-Google-Smtp-Source: AA6agR7EVIcAjj0e4DiLFSpz+VJ4gD3D0sMV/fiWKtvVnLBRaBt9Z7tABTS/9SdJ4fFaGAKJJtD/KA==
X-Received: by 2002:a63:5a44:0:b0:431:fa3a:f92c with SMTP id k4-20020a635a44000000b00431fa3af92cmr8548373pgm.471.1662650917549;
        Thu, 08 Sep 2022 08:28:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h23-20020aa796d7000000b0053f9466b1b2sm2159730pfq.35.2022.09.08.08.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:28:36 -0700 (PDT)
Message-ID: <631a0a24.a70a0220.a219d.39a1@mx.google.com>
Date:   Thu, 08 Sep 2022 08:28:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.257
Subject: stable-rc/linux-4.19.y baseline: 133 runs, 4 regressions (v4.19.257)
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

stable-rc/linux-4.19.y baseline: 133 runs, 4 regressions (v4.19.257)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.257/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.257
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41b46409f97a703ab1dd9227c40e76a0d3eeea1c =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6319db5b7dbd00abc935567e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
57/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
57/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319db5b7dbd00abc9355=
67f
        failing since 120 days (last pass: v4.19.241-59-g7070c1b6eeed, firs=
t fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6319db812d7bca74ba355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
57/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
57/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319db812d7bca74ba355=
661
        failing since 120 days (last pass: v4.19.241-59-g7070c1b6eeed, firs=
t fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6319db59e55000be4b355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
57/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
57/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319db59e55000be4b355=
661
        failing since 120 days (last pass: v4.19.241-59-g7070c1b6eeed, firs=
t fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6319db6e710daca345355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
57/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
57/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319db6e710daca345355=
655
        failing since 120 days (last pass: v4.19.241-59-g7070c1b6eeed, firs=
t fail: v4.19.241-89-g71a9ee8b0cfd) =

 =20
