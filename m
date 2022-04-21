Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104E750AC08
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 01:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442599AbiDUXka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 19:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442593AbiDUXk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 19:40:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A5E4615F
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 16:37:35 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b7so7103075plh.2
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 16:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aEeZuckIwf6ZsgbW0EZ5Fq+qu5NCjph+cS7JF7EQ/qk=;
        b=rDOpFv6nzz5jBrl8SzglmyITvWzs8V9LGxfcQUgjdoyE7Fnwz8NWVlEWqEdgC6BW4l
         QP/ZstmzUotRsdf+YpRS2g+Rk81ccPPqIqRQUa0yIlVvdEaqS6j9432bsH09QG3x/a3s
         2PC+Lj+J038yGIjipCcSPMSG9mHqU6TcOmqiplR9OUbGwRUfFmJ2FEVHIsLTMmDmWe4L
         HfwyHDtPU7SRmOPmt4Cp/wY2gAVyF5ZOKvS2z55pzsehM+591hlbKQytVbioO8x7nVet
         gpyAPv9bzHybH24aZPfp6Lxe/ip/vSGN5TgoIMz9wVeZlfydvJ+fSaAk1xusQfj7FEID
         e6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aEeZuckIwf6ZsgbW0EZ5Fq+qu5NCjph+cS7JF7EQ/qk=;
        b=nPpwzWSWgfur/UtTfA/CfL1qfCq4TaOKvqN7CQvIHlGv3jXkO127vrOVESKV7VVzlW
         6zyGAhEMnZFMdNIqytXOKVFXBzshGxGKvM4UATBj0W42IoRwWr9SLuxWXv0vProxVdTB
         /yTJtBdYLpApMyYoROdGx/NYrk1ajlgwglflc+0kdLZhw6EKzWXaeyHhedONBMJdrIq5
         fe9rirSvNrC5U7DRDG8yvr3AAJRCS7c2dTW8UMLKRNoGtwV2ElPXTPcRafzbff0ksUAA
         DSTOyQH4gf7/ZVXBYRQknvbNtYBZdf4dUeQPeaWlW4DuDG0sXvu/06TX8JWLtnyuus28
         DxIw==
X-Gm-Message-State: AOAM532CDJQ1ceq0Metu4Ug1TMdKFBkBLZnpEdl2cJpBVOmYQ4bo64O5
        rt3qt5vYZtcuNWJxmIo2GTTeVZpuqMUBuwjUjlw=
X-Google-Smtp-Source: ABdhPJxcZk7g+AjKkxPJgXlMS/gGxiu3yVuZiQbieXtbo/cLj2kYMCyRm45SjITJOKbCvT3s7mCgRg==
X-Received: by 2002:a17:903:94:b0:158:a14f:f117 with SMTP id o20-20020a170903009400b00158a14ff117mr1844652pld.18.1650584254865;
        Thu, 21 Apr 2022 16:37:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e24-20020a17090ac21800b001cd4989fec8sm3772107pjt.20.2022.04.21.16.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 16:37:34 -0700 (PDT)
Message-ID: <6261eabe.1c69fb81.4fe27.a518@mx.google.com>
Date:   Thu, 21 Apr 2022 16:37:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.239-6-g5ad0881ca15e2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 83 runs,
 4 regressions (v4.19.239-6-g5ad0881ca15e2)
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

stable-rc/queue/4.19 baseline: 83 runs, 4 regressions (v4.19.239-6-g5ad0881=
ca15e2)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

meson-gxl-s905d-p230         | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.239-6-g5ad0881ca15e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.239-6-g5ad0881ca15e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ad0881ca15e24828a69d272438bbe483071e202 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6261c11e5f9272314aff9488

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-6-g5ad0881ca15e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-6-g5ad0881ca15e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261c11e5f9272314aff9=
489
        failing since 21 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6261be4e9c2f3616eeff948b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-6-g5ad0881ca15e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-6-g5ad0881ca15e2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261be4e9c2f3616eeff9=
48c
        failing since 15 days (last pass: v4.19.237-15-g3c6b80cc3200, first=
 fail: v4.19.237-256-ge149a8f3cb39) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6261b8e8b133593ff1ff9470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-6-g5ad0881ca15e2/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-6-g5ad0881ca15e2/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261b8e8b133593ff1ff9=
471
        failing since 2 days (last pass: v4.19.238-22-gb215381f8cf05, first=
 fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6261bef898ef5130a1ff9477

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-6-g5ad0881ca15e2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-6-g5ad0881ca15e2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6261bef898ef5130a1ff94a6
        failing since 46 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-21T20:30:35.247610  /lava-6143527/1/../bin/lava-test-case   =

 =20
