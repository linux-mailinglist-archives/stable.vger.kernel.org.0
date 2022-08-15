Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAC359337A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 18:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiHOQtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 12:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiHOQsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 12:48:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75701165B2
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 09:48:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t22so7412703pjy.1
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 09:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=67En1lS4DAq0vfrO3QnAitxu330W+qcCb5sAB//lmjc=;
        b=a1IUjbrvFdMpRapkFD3M85ZNvf0EbKnLZr/7iOChtGKd5jQThsAOsuLT0mMXmntApl
         LW4MC/DRWz2zb9rDG7UWnRiaBTkygmjABTCSkV/+UAGpTCDCr3r6KFTLksPcB/3t7J7N
         fgc05B2AUW8jxIJMqfdCNyYAz2/4vT7ajZEjjZCiQgXB/SeTUlGXJ/W/yjUwKbeGokjs
         ZUUqwFNQRGPEIghLo9ooZ9j3VonUOejG+JHKV/aMzxD+U8Jlc+w+m+jx/BPzopz0Eb2S
         K3JE0dCu5vXvzXZlFxJA5cGET83lXBkL5IalZKw+yo1L4b6oVho7YcRzuH8WDBsu5kuJ
         Fs6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=67En1lS4DAq0vfrO3QnAitxu330W+qcCb5sAB//lmjc=;
        b=1zuGDE+YOWB7rfDOyjy0FwbTq8cAAjO2ayiJuh/CUVIagbuJUutHtprgjmy4isXr7t
         vkfRVhAmsLppXfBeVlGYlZfJ04TTRFr3oHgBDwk+YZroeWigRD3tBVoayHEF4x7DiM3H
         4AyoJTmAyIfP6fFNbQ2y6hwNtj/L0AeILwFkKDNBIT1h8jVik07UFE/MKFigRHiz+MaC
         hx7iwmJYMyjEnljgmV/QOknxIe7Rmgp9GijBO/htl+ZNx/qDQpCsrL6y6vWoayK+I93w
         mRXTR4bBNXMsIB0S/98EStgJ4Qk55V8jRPf5JYkYhp3tXPg7ewevpZo1NQbohxyRUcBW
         wfXg==
X-Gm-Message-State: ACgBeo2uZ3UyfHxVBl/E33AkovxostGTGAaYTRjaqbedx8ZNGVXkJYzI
        LUQK8SrS5kCs1GlUQUEMo139XiLdwgOjsFYt
X-Google-Smtp-Source: AA6agR7bA7HxtUdDHi03hUpRbw9Ut7iE6K+BT3hO1wVZ0LCfmWaFUQC48Enu/wbZkuYFN1040FXldw==
X-Received: by 2002:a17:90b:38c8:b0:1f5:1311:5bd3 with SMTP id nn8-20020a17090b38c800b001f513115bd3mr19070619pjb.161.1660582130398;
        Mon, 15 Aug 2022 09:48:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b0017086b082c1sm7235003ple.173.2022.08.15.09.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 09:48:50 -0700 (PDT)
Message-ID: <62fa78f2.170a0220.94daa.bb94@mx.google.com>
Date:   Mon, 15 Aug 2022 09:48:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-1079-gb280aa862bc2b
Subject: stable-rc/linux-5.18.y baseline: 95 runs,
 30 regressions (v5.18.17-1079-gb280aa862bc2b)
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

stable-rc/linux-5.18.y baseline: 95 runs, 30 regressions (v5.18.17-1079-gb2=
80aa862bc2b)

Regressions Summary
-------------------

platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
at91sam9g20ek               | arm  | lab-broonie     | gcc-10   | at91_dt_d=
efconfig   | 1          =

cubietruck                  | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6q-sabrelite             | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6qp-sabresd              | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6qp-wandboard-revd1      | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6qp-wandboard-revd1      | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =

imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =

imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =

jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | multi_v7_=
defconfig  | 1          =

jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | tegra_def=
config     | 1          =

panda                       | arm  | lab-baylibre    | gcc-10   | multi_v7_=
defconfig  | 1          =

rk3288-rock2-square         | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =

rk3288-veyron-jaq           | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =

sun4i-a10-olinuxino-lime    | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun5i-a13-olinuxino-micro   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-cubieboard2       | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-cubieboard2       | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =

sun8i-a33-olinuxino         | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h2-plus-orangepi-r1   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h2-plus-orangepi-zero | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h3-orangepi-pc        | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.17-1079-gb280aa862bc2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.17-1079-gb280aa862bc2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b280aa862bc2bb8c45562251fc68652d5c30343a =



Test Regressions
---------------- =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
at91sam9g20ek               | arm  | lab-broonie     | gcc-10   | at91_dt_d=
efconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa402f07522820f5daf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa402f07522820f5daf=
065
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
cubietruck                  | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4ab80f2596d4e4daf078

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4ab80f2596d4e4daf=
079
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4c8ce4d418a2f9daf099

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4c8ce4d418a2f9daf=
09a
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4ffcac5bbb674cdaf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4ffcac5bbb674cdaf=
074
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6q-sabrelite             | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa442cd073b1f672daf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa442cd073b1f672daf=
063
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6qp-sabresd              | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4389f522079610daf06c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4389f522079610daf=
06d
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6qp-wandboard-revd1      | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa43545b2a47a5bbdaf05d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa43545b2a47a5bbdaf=
05e
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6qp-wandboard-revd1      | arm  | lab-pengutronix | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa44f8f8face1ca1daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa44f8f8face1ca1daf=
057
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa43bbf7e21bed12daf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa43bbf7e21bed12daf=
060
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4623fdd9adcc16daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4623fdd9adcc16daf=
059
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa43b31c13ffe364daf074

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa43b31c13ffe364daf=
075
        new failure (last pass: v5.18.8-7-g2c9a64b3a872) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa462025d357d6e1daf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa462025d357d6e1daf=
060
        new failure (last pass: v5.18.8-7-g2c9a64b3a872) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa56783220288bd0daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa56783220288bd0daf=
057
        failing since 13 days (last pass: v5.18.14, first fail: v5.18.14-24=
8-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa43b9f7e21bed12daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa43b9f7e21bed12daf=
05d
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa460952d0850220daf0bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-=
sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-=
sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa460952d0850220daf=
0be
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa43b1d0a38e8e0ddaf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7u=
lp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7u=
lp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa43b1d0a38e8e0ddaf=
05d
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa462685d5dd617edaf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa462685d5dd617edaf=
063
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa646fda0f354cb1355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa646fda0f354cb1355=
647
        new failure (last pass: v5.18.14) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | tegra_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa5ad2eed7a1d04e355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa5ad2eed7a1d04e355=
649
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
panda                       | arm  | lab-baylibre    | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa46836746773d7adaf06c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa46836746773d7adaf=
06d
        new failure (last pass: v5.18.14) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
rk3288-rock2-square         | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4c076245e1c1cbdaf09c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4c076245e1c1cbdaf=
09d
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
rk3288-veyron-jaq           | arm  | lab-collabora   | gcc-10   | multi_v7_=
defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa685cfcce5475f8355676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa685cfcce5475f8355=
677
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun4i-a10-olinuxino-lime    | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa6c1c441522566b355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4=
i-a10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4=
i-a10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa6c1c441522566b355=
648
        new failure (last pass: v5.18.12-232-ga04b1a5cb7d28) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun5i-a13-olinuxino-micro   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa50479269341777daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa50479269341777daf=
059
        new failure (last pass: v5.18.14) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun7i-a20-cubieboard2       | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa40023cd686364bdaf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa40023cd686364bdaf=
06a
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun7i-a20-cubieboard2       | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa40143cd686364bdaf07c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa40143cd686364bdaf=
07d
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-a33-olinuxino         | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa402807522820f5daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa402807522820f5daf=
057
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h2-plus-orangepi-r1   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4d414e56b9482cdaf07f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4d414e56b9482cdaf=
080
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h2-plus-orangepi-zero | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa6edf6a0e0adf51355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa6edf6a0e0adf51355=
648
        new failure (last pass: v5.18.16) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h3-orangepi-pc        | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4168bf5162aa6edaf066

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1079-gb280aa862bc2b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4168bf5162aa6edaf=
067
        new failure (last pass: v5.18.16) =

 =20
