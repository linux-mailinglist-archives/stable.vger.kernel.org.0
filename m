Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E337591D16
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 01:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiHMXBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 19:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiHMXBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 19:01:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15C618B2C
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 16:01:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so3879301pjf.2
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 16:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=pkSAMYar3S6f1bpkS6caUS7lBl6voT7fLD8MsigjayM=;
        b=7N7bZ8LUlluuu+9Du2TlHg//SWBwxbuakV8V9xTM8BC7nwicBQfht540NV1F9SGk7e
         CT9+kweGe+gbPBiZFhdhtCvIuht6wcei/pEHu17SgILxaxXHul2EgOsH6PghZcIazSZD
         /ALArz7DCgJdGjA/T8cXzxOhR9v8PqIwwlEIjE/U2e9tNot9ftmNYrsFzAzMYPU/pN+0
         bg4gshxgAs+nzWgi+Ji5FjzJx2uHxBqbOF3Ow2TGidJ+luN6FAxERWld6AiuVplP1hXt
         7pZ2FF9Be7i1GL2F6M6gDDJdn1m3TE9z+ybLavCnKh74X5ElP08eNtQtxYW7sAzVD9nQ
         +y1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=pkSAMYar3S6f1bpkS6caUS7lBl6voT7fLD8MsigjayM=;
        b=pzYg4nYVRWOYovUd6A7DX7qTfqs4jSviqZOpoR8Nhn1UOgfCLuHyOG9qenj4jjW6tS
         XDFNVWb9sfwiaB+udDDpovW9j3o8XwqEJNAkZvRNkD1nrhUwsjtJ1F18qYcBftYXRuRN
         E9MAvC2PLhpUuHEKPebgUWVAhqtCkWpPKU7QhocBocKlj1APNxAJ2Ykqk2PdoyFHq1y5
         XJIhxF/I7IpD67HFrQBEL8Ay3hHftbYc2Ew7zeB8xd6p+aoMsP1ZnB+6wbTYyO2F+089
         Gg8X2sSUIr3dgv5xa9Mfsu6gI0Sr/e42L5LvlhNbwiGfW1zfUSOgkIRchTqouP5I8qxb
         YVyQ==
X-Gm-Message-State: ACgBeo2kteVRkDNdK3GwQcDwcf/34Zq66tY+xC2YZsltbx935miBr2Lj
        DYJwF7uIqj4LZ8WeANCF0gmTFawjFvWZ/LEv
X-Google-Smtp-Source: AA6agR69B4Z6sUZ3dQxMqNKzzQxQblks91wPgxzvuk6ubBPhlIbcbqvIVpgJFMFpfW2tZenAkVihvQ==
X-Received: by 2002:a17:902:f711:b0:170:9e3c:1540 with SMTP id h17-20020a170902f71100b001709e3c1540mr9943195plo.22.1660431671003;
        Sat, 13 Aug 2022 16:01:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i16-20020a170902c95000b0016f85feae65sm4276194pla.87.2022.08.13.16.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 16:01:10 -0700 (PDT)
Message-ID: <62f82d36.170a0220.254a9.6c3e@mx.google.com>
Date:   Sat, 13 Aug 2022 16:01:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-134-g620d3eac5bbd1
Subject: stable-rc/queue/5.18 baseline: 93 runs,
 22 regressions (v5.18.17-134-g620d3eac5bbd1)
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

stable-rc/queue/5.18 baseline: 93 runs, 22 regressions (v5.18.17-134-g620d3=
eac5bbd1)

Regressions Summary
-------------------

platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
at91sam9g20ek               | arm  | lab-broonie     | gcc-10   | at91_dt_d=
efconfig  | 1          =

cubietruck                  | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =

imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig | 1          =

imx6q-sabrelite             | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig | 1          =

imx6qp-wandboard-revd1      | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig | 1          =

imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig | 1          =

imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig | 1          =

imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig | 1          =

imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig | 1          =

imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig | 1          =

jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | multi_v7_=
defconfig | 1          =

odroid-xu3                  | arm  | lab-collabora   | gcc-10   | exynos_de=
fconfig   | 1          =

odroid-xu3                  | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig | 1          =

rk3288-rock2-square         | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig | 1          =

sun4i-a10-olinuxino-lime    | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =

sun5i-a13-olinuxino-micro   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =

sun7i-a20-cubieboard2       | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =

sun7i-a20-cubieboard2       | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config    | 1          =

sun8i-a33-olinuxino         | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config    | 1          =

sun8i-h2-plus-orangepi-r1   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =

sun8i-h2-plus-orangepi-zero | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =

sun8i-h3-orangepi-pc        | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.17-134-g620d3eac5bbd1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.17-134-g620d3eac5bbd1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      620d3eac5bbd1142f7ea482c816a4ffd537a26eb =



Test Regressions
---------------- =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
at91sam9g20ek               | arm  | lab-broonie     | gcc-10   | at91_dt_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f851d133c46c71daf071

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f851d133c46c71daf=
072
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
cubietruck                  | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f86fac2677ec09daf071

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f86fac2677ec09daf=
072
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fc004bd4b97af5daf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fc004bd4b97af5daf=
066
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
imx6q-sabrelite             | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fa7c2eeb30d243daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fa7c2eeb30d243daf=
059
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
imx6qp-wandboard-revd1      | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fa98176922cc35daf06d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fa98176922cc35daf=
06e
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7faf26d2470ca81daf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7faf26d2470ca81daf=
077
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fadeb00e240a85daf088

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fadeb00e240a85daf=
089
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fc01c1190b2ea4daf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fc01c1190b2ea4daf=
065
        failing since 38 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fae1f33321bacddaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fae1f33321bacddaf=
057
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fae26d2470ca81daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fae26d2470ca81daf=
058
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fa8caf54f810addaf08e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fa8caf54f810addaf=
08f
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
odroid-xu3                  | arm  | lab-collabora   | gcc-10   | exynos_de=
fconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fb306d2470ca81daf09d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fb306d2470ca81daf=
09e
        new failure (last pass: v5.18.17-41-g6a725335d402d) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
odroid-xu3                  | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fdece720a75ea1daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fdece720a75ea1daf=
057
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
rk3288-rock2-square         | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7fbe4eed2ced88bdaf0d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7fbe4eed2ced88bdaf=
0d3
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
sun4i-a10-olinuxino-lime    | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7faff6d2470ca81daf079

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a=
10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a=
10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7faff6d2470ca81daf=
07a
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
sun5i-a13-olinuxino-micro   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f87e736e43db74daf083

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f87e736e43db74daf=
084
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
sun7i-a20-cubieboard2       | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f870736e43db74daf070

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f870736e43db74daf=
071
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
sun7i-a20-cubieboard2       | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f872ac2677ec09daf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f872ac2677ec09daf=
078
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
sun8i-a33-olinuxino         | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f85eac2677ec09daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f85eac2677ec09daf=
058
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
sun8i-h2-plus-orangepi-r1   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f87f736e43db74daf087

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f87f736e43db74daf=
088
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
sun8i-h2-plus-orangepi-zero | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f881736e43db74daf08d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f881736e43db74daf=
08e
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =



platform                    | arch | lab             | compiler | defconfig=
          | regressions
----------------------------+------+-----------------+----------+----------=
----------+------------
sun8i-h3-orangepi-pc        | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7f9b239172c7350daf0bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
134-g620d3eac5bbd1/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7f9b239172c7350daf=
0c0
        new failure (last pass: v5.18.17-55-g185ae35b285f0) =

 =20
