Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7515B5D1A
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 17:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiILP3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 11:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiILP3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 11:29:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D962496B
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 08:29:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso8517691pjd.4
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 08:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=eoPkz2SkVaQ88YyGN+OEJlvpAkauhvp7/bb0gZ11cUg=;
        b=CmaBXaQR0ccQCbjh/S08U+EwoIF840lXado2FksvHqbuvmJe2GcXItV44Lsi10wDMT
         AL5HL243xwmvGrSVoociibLpAjIVWF6REpttLRD8auiAr74h8P9CAyey3rxhMkYMWHhq
         oKvCUMjuendQ1Ge0Gfe911SxUm3P2nH8/+yASwbLiJ3qlL3BNEuGPlRcycBraqSqsE5H
         q2cs/xCFeo5eREry/Mk5yyeFBjrbXxYoc1FKGohPBmqW6yngUOEsy2/xTspYhKC0RSeQ
         NxE9Mqi8YAITdA/ZtL1pFoz3vCDsGEXMjd1GBa62pLE6CvYFk1rnfa4E6RCwYOMe+yiZ
         Irqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=eoPkz2SkVaQ88YyGN+OEJlvpAkauhvp7/bb0gZ11cUg=;
        b=BjO1SeK5Cv4pOI1xpEhD9/JIsnhZHsY3OZDNCfew//Ob7RbQzEGlyCAox+0ISPVq0c
         j8FIGjCllK+rW9dYMrvts+gdCqmMgIuRGUfyBsT3rGzGobxdp5bbRB7FcnoA2HbWTEFI
         CVxnAyJBxm4u1zO0G3zyCu6xemkCI72D1MV5r2ZO+5R6Owmjo8zInX5xolgPv0Rh7vFX
         BJhH7Av4faFlFLb9ekJPZ+FHPGvNFOW5tMwejHAfD/UYYSsYCn4fXjYTHakGL2zIeSZD
         20s5k9blzn91vbp3NJsfd/La7ftLylZ/mQcfa+YuEQi+bxTs7PIEtoKb8O3jSzY+JYuc
         vMQA==
X-Gm-Message-State: ACgBeo3V4IWUgt4R4ps705s7x6eJc0gX9FAJnRuK8xC0N7VHlmlrEjct
        gsYMubeZ0LeT7KXaFqRsTIbko2lRlGAxIhHGmKA=
X-Google-Smtp-Source: AA6agR5BwDUIazxfYi5yBhq5WFBOniVGrSf0xL97oKSFwZv6cUMa60XUbsuSssyas79/ykSZgpMnVQ==
X-Received: by 2002:a17:902:efd2:b0:176:b888:2481 with SMTP id ja18-20020a170902efd200b00176b8882481mr27151678plb.144.1662996549634;
        Mon, 12 Sep 2022 08:29:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j16-20020a170902da9000b0016dbdf7b97bsm6129675plx.266.2022.09.12.08.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 08:29:08 -0700 (PDT)
Message-ID: <631f5044.170a0220.a64b0.a266@mx.google.com>
Date:   Mon, 12 Sep 2022 08:29:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.327-41-g6bcd25aa883d7
Subject: stable-rc/queue/4.9 baseline: 105 runs,
 8 regressions (v4.9.327-41-g6bcd25aa883d7)
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

stable-rc/queue/4.9 baseline: 105 runs, 8 regressions (v4.9.327-41-g6bcd25a=
a883d7)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.327-41-g6bcd25aa883d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.327-41-g6bcd25aa883d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6bcd25aa883d75141fba10291b0d82e898cddc79 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f22e122baa840e8355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f22e122baa840e8355=
646
        failing since 48 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f1e761d35b76315355664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f1e761d35b76315355=
665
        failing since 48 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f22a60160f47bb5355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f22a60160f47bb5355=
649
        failing since 48 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f1e8b911dfcf14a355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f1e8b911dfcf14a355=
647
        failing since 48 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f22e3d7bdbe56cc35568b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f22e3d7bdbe56cc355=
68c
        failing since 48 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f1e9e911dfcf14a35565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f1e9e911dfcf14a355=
65e
        failing since 48 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f22a51748523cf2355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f22a51748523cf2355=
655
        failing since 48 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f1e892611a870b7355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.327-4=
1-g6bcd25aa883d7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f1e892611a870b7355=
65a
        failing since 48 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =20
