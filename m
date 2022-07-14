Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB365750A0
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 16:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbiGNOTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 10:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240322AbiGNOTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 10:19:09 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D41A2F3B2
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 07:19:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id 5so538647plk.9
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 07:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aJy6t+//UuQW18UTXT0oBSFPdl3j9bgPf+HMNFuEvvc=;
        b=fG4IlKqze2EGikrrRmiRPDE9xY+2SomOCEuy2sOZhnTGVWohNr+PsCNFIJ/ZjUBYG1
         WPjUgkzTtV6CFZonyumB0uTabqdAz/9nwn+AP0cyZkFQf4mCyfhHEc9RJ5wq9kudjrVO
         Gx2T4gvhnLDhcTJW6wwQATdch0lPUFc4JI2/v/OI0vLpnGKxiW1UL8t3z0qFxDbBGFYZ
         wSZJwDX9m9G3M/XgTLQq34Pny3jLEIkxUj0NezeUxWyBddVBAykQbjpRXl7Zjs9JQxdE
         myHeDpN+AiAPj9NjUd9O9/rSj2J3XUk4Oh1EbusQeTV6UDm2gUhlyr0dn2GvFoiFD9hP
         mLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aJy6t+//UuQW18UTXT0oBSFPdl3j9bgPf+HMNFuEvvc=;
        b=ANv0eQmamk7KjHJkXG1dHnYLYWekP44QjUahDsjpqWmqPKEkVbUliQS/lg2bnCD5Yx
         BAmoX2C13q6VHhPPUiD4kHdLPlPKxRpfMYGQlRGDxTV6a8YLdE/ix3fGeKik/4tLJvW3
         MAgzeJbxRBjKr5+h9+2Uc6lz8o1m9W7JwP7K8KS0Dd1xac4Caoqnw1ILrCARSKrtECIl
         bj8kKh2UfbKz9iWOL7P6dCPTvTeNU/DdXHO1cxANB7fhrm/uHLHoWnmSQxagye+8hQmY
         0swi4//g1pWkfuAXaN3xPbCqE3nNGGiXf+9Rq2eSoPtOCPpCF7SEG0UuS19G2pyv/Zt2
         LlKQ==
X-Gm-Message-State: AJIora9UkIQ0eoIBhRpiBhfBkqZULSRQrHsng8WUckRD1WA7Pi9Dv+pM
        gBgrjOI865gqRLitqJNY1TGgPPTdTgU71ZvpfTI=
X-Google-Smtp-Source: AGRyM1sF3+fOJJBiAhl0oeSMLUneaPAO+17f88PJMf8bDWTtp9Ov/0YYviA8Psrp9ITu2tM7U5fn+A==
X-Received: by 2002:a17:902:b114:b0:16c:4a04:67b7 with SMTP id q20-20020a170902b11400b0016c4a0467b7mr8768027plr.103.1657808347537;
        Thu, 14 Jul 2022 07:19:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v26-20020aa799da000000b0052b11fdb353sm1330397pfi.125.2022.07.14.07.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 07:19:07 -0700 (PDT)
Message-ID: <62d025db.1c69fb81.44cd.1b87@mx.google.com>
Date:   Thu, 14 Jul 2022 07:19:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.11-61-g1fdbd5bcdbda
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 151 runs,
 7 regressions (v5.18.11-61-g1fdbd5bcdbda)
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

stable-rc/queue/5.18 baseline: 151 runs, 7 regressions (v5.18.11-61-g1fdbd5=
bcdbda)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

jetson-tk1             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

jetson-tk1             | arm    | lab-baylibre    | gcc-10   | tegra_defcon=
fig              | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.11-61-g1fdbd5bcdbda/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.11-61-g1fdbd5bcdbda
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1fdbd5bcdbda137ec27673a51b994f19b639888d =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cff238f4100a10fba39bf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cff238f4100a10fba39=
bf1
        failing since 8 days (last pass: v5.18.9-96-g91cfa3d0b94d, first fa=
il: v5.18.9-102-ga6b8287ea0b9) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
jetson-tk1             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfeedad3359ab471a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfeedad3359ab471a39=
bd5
        failing since 1 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
jetson-tk1             | arm    | lab-baylibre    | gcc-10   | tegra_defcon=
fig              | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfed5e24016b5e1ea39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfed5e24016b5e1ea39=
bce
        new failure (last pass: v5.18.11-61-g8eed863760d7) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfebeae698001fbba39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfebeae698001fbba39=
be2
        failing since 1 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfeffc57d2a049b5a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfeffc57d2a049b5a39=
be2
        failing since 1 day (last pass: v5.18.10-27-gbe5c4eef4e40, first fa=
il: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cff014589495ea9aa39bed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cff014589495ea9aa39=
bee
        failing since 1 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cff4d76cbfb811dea39be6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-g1fdbd5bcdbda/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cff4d76cbfb811dea39=
be7
        failing since 1 day (last pass: v5.18.10-27-gbe5c4eef4e40, first fa=
il: v5.18.11-61-g8656c561960d) =

 =20
