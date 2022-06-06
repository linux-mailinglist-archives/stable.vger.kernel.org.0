Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E0D53EE8E
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 21:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiFFTZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 15:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbiFFTZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 15:25:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF3625C
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:25:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id cx11so13623962pjb.1
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 12:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E6H46beXRpkdYvaa6Dp+3VwGF/47CVGaXbyUeF4nppU=;
        b=m2ZkQ/6t9dKc9efMFkLDrFA8EyMkonBtt+GwTgogl1Dfjru6YqVhK+Zk0PZmGj2gsT
         IVIx0JUjSmD80QR+b7IdQ6nQ/lAWU32ikV/u/z8DHjAafehjfs4uOFaxt7YhH0Gbx3Or
         4sqkmN/OGLTTo0XQ1xYNtPLDeghHNZjgMGzu91DhJHI/ulZjuc5modYdzvp8rhIHxgDi
         e2jMhRyUhzwX1BRr1JlW8P9ybJ7LWrYDQdjdx4AsRu5+09JiaHsx7a98xdbwaGpjBzLj
         Ksn4RSag/mWywQcbONvZjbojnqiJvJdLfX0SxReiC2ZUBjv270KIUOwCXd6zZKH/l8bv
         kWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E6H46beXRpkdYvaa6Dp+3VwGF/47CVGaXbyUeF4nppU=;
        b=caWZtBJ8pDiSVcXJDtORI522r1Jh8xvMW13c+iTbKEIIBD6uNw3GijojgCpimQbUQo
         mdlhuZG937OrheKITzMd/hSqhtsFEIIJPE7mEEo5BGt+y5XhSzEZZ17mDGBOmvxSKzRI
         PNdtaSR3RLtrlOhaQHquv/UkpzdkhI5GjUsS0b67Iw4iC2dVlLuGz40BBvI7XDzHTwGG
         VRGRhuPhcV8CMda18FpAWulmIorUrjprhQIlblz6B4uiMle9E1baBv2VvfZsviOaqDew
         ynFo30XI3UOCfuiRAhThKgG8hGlEDpjhwZibpdVPR572KV8ewTexyb49khc6IRpgjV98
         WStw==
X-Gm-Message-State: AOAM5307YcIQ7Py0iNnG/8ktVGJHmL8QsOmzyIcUhVBSqE6a/5RS+/L5
        rBCVewkBvJFcyD/bNlsisDBWTaKoURLgOcx/
X-Google-Smtp-Source: ABdhPJzQ1Pkeysl2d8KIgHKMIK8b2ELQpoTMcTBQiKmQ0KN4sBnYOAXMNVGh09w8IMBB4/YJh/O13w==
X-Received: by 2002:a17:902:8bc2:b0:167:7645:e76a with SMTP id r2-20020a1709028bc200b001677645e76amr8865752plo.115.1654543521866;
        Mon, 06 Jun 2022 12:25:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k189-20020a6384c6000000b003fcde69fea5sm9173023pgd.81.2022.06.06.12.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 12:25:21 -0700 (PDT)
Message-ID: <629e54a1.1c69fb81.1e575.3ce4@mx.google.com>
Date:   Mon, 06 Jun 2022 12:25:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.17.y baseline: 163 runs, 5 regressions (v5.17.13)
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

stable-rc/linux-5.17.y baseline: 163 runs, 5 regressions (v5.17.13)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | tegra_def=
config            | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig         | 1          =

tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | tegra_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8eb69e8f0d4544de764ab03c5b292ead949d9ac1 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/629e39e9e21a081f7fa39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629e39e9e21a081f7fa39=
bf8
        failing since 12 days (last pass: v5.17.10, first fail: v5.17.11) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | tegra_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/629e3a61d1880b5315a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629e3a61d1880b5315a39=
bdb
        failing since 2 days (last pass: v5.17.11, first fail: v5.17.11-188=
-g30200667e8235) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629e20257e10edf116a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629e20257e10edf116a39=
bce
        new failure (last pass: v5.17.11-188-g30200667e8235) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/629e31e231d246338fa39bf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629e31e231d246338fa39=
bf3
        failing since 11 days (last pass: v5.17.8-115-g3f3287e397412, first=
 fail: v5.17.10) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
tegra124-nyan-big            | arm   | lab-collabora | gcc-10   | tegra_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/629e3295fc168c9bd7a39c06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629e3295fc168c9bd7a39=
c07
        failing since 11 days (last pass: v5.17.8-115-g3f3287e397412, first=
 fail: v5.17.11) =

 =20
