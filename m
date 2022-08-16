Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172DE59532A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 08:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiHPG6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 02:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiHPG5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 02:57:52 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7C71D3225
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 20:01:38 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id z187so8213924pfb.12
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 20:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=E2Dx+7e2uU+1dXR8P3p/qWWsI+sq8p3m4HrlGGwx4nw=;
        b=g26uWPqqzv6bUFl/0EsaDa5lKnoNcXM7LnQXQye1ZJK1U5+2EmpvDIIFVjLASKrmFI
         JmoMgr9lwNgP0s1tWZ50Las16Ak4sbl856+NUwXkTInX4bT+34SlJ5p32/wwLWem1eN4
         4EacMGBDvdUahIFxNhjii67jQdYh+4gABudSFHIKz9hZpEPP4kXwu+QWkPiSgkIf/ZhV
         OkjMrM736jKXIpPVHHG/6+GH5OE64TLtK+FceLIoiVg5XHBlpImrUrVkvLBtoH+wNT4k
         CEH4QYg/IjDOjUey8Unsro7wxG1nGiJFVroIjtPTNMP2XZYS0cZwmuvwhZa2s73uLOdM
         tRAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=E2Dx+7e2uU+1dXR8P3p/qWWsI+sq8p3m4HrlGGwx4nw=;
        b=RIUSAnsrPHv78q94eN3Fbrbud0pxEXYrG92zz+auECmokYkoDOaxVpSddcTm8CnypX
         6h4gqf2ZEJbJ6pfxmU3gi79A70DvO6CYTKYoswNa8BMnlJUPOLIMeb9XwBJG63GHFci6
         d5+IZeHz1qQZXbrdG0Vpn/8K4NCOYoCWTKte4qqyhs8WwiAuz3V/FcYtUcQXk3NMQCIG
         c5I5YJ5GLq4xbv3Tu8sx2LFGHw45G0A+f++4Y3/wnOOqUgCfiBJUWrJSHY0UWkMAC4cK
         lbDyuR3nMs5ajupb0TtDa4m3THSguwNDSA1LtL4OpMs6w9cWLzZFGuJODrFuWFjDD3Di
         7+cA==
X-Gm-Message-State: ACgBeo2661yUNS5aIatxYvzxJXkT/62DLBuh0d9eCCp8VvnrQHaihN7d
        p6w60Mn0vMRYqJ8y11BEvvYcL4CrUIxJ3BC3
X-Google-Smtp-Source: AA6agR5QvApS2Y0OGTQZiMqN+RfF/7A6ZNP9OlSdgSuY6SSN7NkLC7XjE7Nr9WzeaqSOyIsM/EWUsw==
X-Received: by 2002:a05:6a00:194e:b0:52f:8e93:6cd2 with SMTP id s14-20020a056a00194e00b0052f8e936cd2mr19284585pfk.10.1660618897601;
        Mon, 15 Aug 2022 20:01:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z6-20020a1709027e8600b0016d7afee272sm7691496pla.153.2022.08.15.20.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 20:01:37 -0700 (PDT)
Message-ID: <62fb0891.170a0220.7c8d4.ce53@mx.google.com>
Date:   Mon, 15 Aug 2022 20:01:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.255-215-g0da9476f61fda
Subject: stable-rc/linux-4.19.y baseline: 124 runs,
 31 regressions (v4.19.255-215-g0da9476f61fda)
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

stable-rc/linux-4.19.y baseline: 124 runs, 31 regressions (v4.19.255-215-g0=
da9476f61fda)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
at91sam9g20ek              | arm   | lab-broonie     | gcc-10   | at91_dt_d=
efconfig          | 1          =

cubietruck                 | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

hip07-d05                  | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =

imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6qp-sabresd             | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =

imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =

imx7d-sdb                  | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

rk3288-rock2-square        | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =

sun50i-a64-bananapi-m64    | arm64 | lab-clabbe      | gcc-10   | defconfig=
                  | 1          =

sun5i-a13-olinuxino-micro  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun7i-a20-cubieboard2      | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun7i-a20-cubieboard2      | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =

sun8i-a33-olinuxino        | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =

sun8i-h2-plus-orangepi-r1  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =

sun8i-h3-orangepi-pc       | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =

zynqmp-zcu102              | arm64 | lab-cip         | gcc-10   | defconfig=
                  | 1          =

zynqmp-zcu102              | arm64 | lab-cip         | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.255-215-g0da9476f61fda/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.255-215-g0da9476f61fda
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0da9476f61fdae614fb5c6834091b7843a6a51e6 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
at91sam9g20ek              | arm   | lab-broonie     | gcc-10   | at91_dt_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad5f84adfa68eca355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad5f84adfa68eca355=
644
        failing since 0 day (last pass: v4.19.254, first fail: v4.19.255-19=
1-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
cubietruck                 | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fae3e7f346f950ed35566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fae3e7f346f950ed355=
66c
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
hip07-d05                  | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad943020e910427355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-collabora/baseline-hip07-d=
05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-collabora/baseline-hip07-d=
05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad943020e910427355=
643
        new failure (last pass: v4.19.255-215-g4373264025937) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad81e73f468fa4a35565b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad81e73f468fa4a355=
65c
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6dl-riotboard           | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadc41ec7b1f95fe355665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadc41ec7b1f95fe355=
666
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6qp-sabresd             | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4e4fd2ea9c1a8355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4e4fd2ea9c1a8355=
645
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4cfb5c7dafb9635566c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4cfb5c7dafb96355=
66d
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6sx-sdb                 | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad7c6fceadeda6135564a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad7c6fceadeda61355=
64b
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4e36ef5f5e16e355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4e36ef5f5e16e355=
658
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-14x14-evk           | arm   | lab-nxp         | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad7f00a83d46478355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad7f00a83d46478355=
651
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62faf59254cc09694f355665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faf59254cc09694f355=
666
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx6ul-pico-hobbit         | arm   | lab-pengutronix | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fafb0a872cf73ff135564a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fafb0a872cf73ff1355=
64b
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
imx7d-sdb                  | arm   | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4bdb3e81e16e7355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4bdb3e81e16e7355=
657
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad65b2c070f457435565b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad65b2c070f4574355=
65c
        failing since 97 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad7c3e1ea8b6a1035564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad7c3e1ea8b6a10355=
650
        failing since 98 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-79-ge28b1117a7ab) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad6323d76d3bb3f355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad6323d76d3bb3f355=
658
        failing since 97 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad7c4a5f4b348e1355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad7c4a5f4b348e1355=
67a
        failing since 98 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-79-ge28b1117a7ab) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad60a4adfa68eca35564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad60a4adfa68eca355=
64d
        failing since 97 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad79afdec6539a5355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad79afdec6539a5355=
649
        failing since 98 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-79-ge28b1117a7ab) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad65a2c070f4574355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad65a2c070f4574355=
659
        failing since 97 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad7860eb4892333355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad7860eb4892333355=
653
        failing since 98 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-79-ge28b1117a7ab) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
rk3288-rock2-square        | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fafdc3d4fb5531c0355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fafdc3d4fb5531c0355=
643
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun50i-a64-bananapi-m64    | arm64 | lab-clabbe      | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad5d68a1c751e44355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64=
-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64=
-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad5d68a1c751e44355=
645
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun5i-a13-olinuxino-micro  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad45154faf054a835564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad45154faf054a8355=
64e
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun7i-a20-cubieboard2      | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4314e3ccec1bc355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4314e3ccec1bc355=
643
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun7i-a20-cubieboard2      | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad41d531799b3ab355669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad41d531799b3ab355=
66a
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun8i-a33-olinuxino        | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4324e3ccec1bc355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4324e3ccec1bc355=
649
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun8i-h2-plus-orangepi-r1  | arm   | lab-baylibre    | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadd7d6a32a5c3353556f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadd7d6a32a5c335355=
6fa
        failing since 0 day (last pass: v4.19.254, first fail: v4.19.255-19=
1-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
sun8i-h3-orangepi-pc       | arm   | lab-clabbe      | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad676365eed96ce355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad676365eed96ce355=
663
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
zynqmp-zcu102              | arm64 | lab-cip         | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad5650f58fcdbf1355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad5650f58fcdbf1355=
645
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
zynqmp-zcu102              | arm64 | lab-cip         | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad6b9efa2a85085355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/basel=
ine-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-215-g0da9476f61fda/arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/basel=
ine-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad6b9efa2a85085355=
664
        failing since 0 day (last pass: v4.19.254-33-g02c6011ece11, first f=
ail: v4.19.255-191-gab9c8d4442969) =

 =20
