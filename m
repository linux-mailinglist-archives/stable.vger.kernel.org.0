Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984E84E5939
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 20:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344295AbiCWThM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 15:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344297AbiCWThH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 15:37:07 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607678B6C1
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 12:35:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id c2so1966472pga.10
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 12:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fMbvBxYQ0KkcIc6LCjlJKv1G3dyvATYurScE0CFTmeg=;
        b=IL4QBB5DelPmKLBy7OyoH7Yav1vFvBDSZvSl+MLdPIvOeNcV0yC22oqtFPL2hzqyFj
         PnaZGqJV/tkPdpbi6Znl+8W/UNe5I/vujfRHHVTlvEw0nLWbUeKdDq3RLe6bQqwj0kIL
         PzY1QZEJVqUtOMj8dx+NJRFsC2/dXLb46L5VPPPVWHEsc7dM2DpNpuLlOX60pBYhwx3D
         B+x9vXUn7Bgx1bF8bwfguQYWbsmaOEKs48N7ho6+fP03XghKeRet6SPYiTzAp+DNidOI
         i3sVcOjm83BjQXu8G4i6iQL/rXf5o7BIaoVxwv+Ck7gOHuFbGnLKzwUgN5xSFfiwt8zt
         fKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fMbvBxYQ0KkcIc6LCjlJKv1G3dyvATYurScE0CFTmeg=;
        b=R8vEfJ0s52dkeWL4kerlBb4QcceQjTLb4ASAcQbBb+RequNj5gBO7tmbZmzw5ALswr
         ck0qyYOwtOPg9uoUrWpFowzdhdARGProtEEB8oTkjcoSPjhPHohsk8LCpcgBIhhwHtty
         Is/TbT9AUCeK9ELy44YvhWlwnBY0RI6mAyBXPHYY6zAKoRxOZYuXV7J0NJpCSBHAIk1j
         KgVtoPoXawI5OSgaT5403rZQp+Dxr1OwKMUjO8t0cYlnJLYQc9XNVK+mabamvdNXlUjC
         hHMNDZBQZKXkQbGVLdd+V+NNFuDvgEyasoCPi2Q1Jw8lJvaB3xf0IyMfCjGMMOmiPxOQ
         GTTw==
X-Gm-Message-State: AOAM532P/Gcidi+y4FLChHQqF8letx4bP3zsxdx5X3OPvom61jDidfMv
        AnCx4SvHGY5XyMM00oPlvAwLGzgCIqGg7T5+rnY=
X-Google-Smtp-Source: ABdhPJwfGjqsP5iyRym+t5XjsnumphsAnhGIMkXrCXmNi2AKzY0y8r1XUqY/dHVYJvQwMBSmRwkn7Q==
X-Received: by 2002:a62:6403:0:b0:4fa:c74c:83c5 with SMTP id y3-20020a626403000000b004fac74c83c5mr1314644pfb.30.1648064136684;
        Wed, 23 Mar 2022 12:35:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004e03b051040sm689971pfj.112.2022.03.23.12.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 12:35:36 -0700 (PDT)
Message-ID: <623b7688.1c69fb81.b3df6.29ac@mx.google.com>
Date:   Wed, 23 Mar 2022 12:35:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.31
Subject: stable-rc/linux-5.15.y baseline: 72 runs, 3 regressions (v5.15.31)
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

stable-rc/linux-5.15.y baseline: 72 runs, 3 regressions (v5.15.31)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
beagle-xm          | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig=
        | 1          =

kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96e48ac9a685f2f5855e2820496ed6ecf893febe =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
beagle-xm          | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig=
        | 1          =


  Details:     https://kernelci.org/test/plan/id/623b4392c060097218bd91a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623b4392c060097218bd9=
1a6
        failing since 61 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/623b46b2a73b3bbf9abd919b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623b46b2a73b3bbf9abd9=
19c
        new failure (last pass: v5.15.30-33-gca23d8a1f1ca) =

 =



platform           | arch  | lab           | compiler | defconfig          =
        | regressions
-------------------+-------+---------------+----------+--------------------=
--------+------------
rk3399-gru-kevin   | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chr=
omebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b43f46dc1567eaebd9197

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b43f46dc1567eaebd91b9
        failing since 15 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-03-23T15:59:41.163409  /lava-5933233/1/../bin/lava-test-case   =

 =20
