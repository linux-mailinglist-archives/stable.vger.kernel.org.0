Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D323334CD9B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 12:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhC2KGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 06:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhC2KGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 06:06:37 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F197C061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 03:06:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 33so3230928pgy.4
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 03:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=csUoKERuRvlOgVTEJ8Ps64qt9ZY8uepSqr/7OtF+YE0=;
        b=aVn8gCE+3gKljeXxlTdM83foDwqdwBjVaU+KW+hhqzFTtjFvjXvcxp1J7TIzU0E9uR
         OMCk+v3rn7Sg9QVcvFeMlf4tZi6KLHtkvpWbXl0oOSQittHFMSGO536HM9U1FZC52YYs
         qqNfDlyTSWh9ulhh1YC/Hmd7rKJfrtnxb2Z48rtjx2CRgLHPRymjxDwCM/QYTK0bOPJq
         zRpJc27XSetYLVy9RRXDip5J/k3Mx2Zh1BbD3afNzH6/KFeu75/b6kclVLe/TH2o4iJn
         up2K9jQPlHG7uXm7RmVsWCu/JvR9djII5YL5/6M/uNlZo35tMXQ/ZKjGZO42dHndD5MI
         tSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=csUoKERuRvlOgVTEJ8Ps64qt9ZY8uepSqr/7OtF+YE0=;
        b=C+8ntpHSyAPkPic7sRKa677oWh6NZmQvpYM+LfiaEakFH8pfcdNCjEZYo96kHBLsZV
         GnH/JPBVlQTYqcoBNQxkcdaTUbN+U/ygNxKMn/IhCF64ggNdRceG4vscXymcXSAkZAbW
         e5JSMNqh7AovT1n28350cmMdjUNhn8qWTfOI4iWwLguARY7COKiBk4/0EIbQD4WhDLiq
         jRKFVjaGNeVrfOEgNvPlloUVIBaWAIj7laGfP+IrPlJBy8TXU104HDgQ+OoOQ+Q4iqbC
         R7rPD6oSggaWapnN1r/kUprNlAS6iIENlJiXLiUDcP6zHhCB5VJYRz9NriTZpDXEAun7
         aj4w==
X-Gm-Message-State: AOAM530jPXzNhs4GQARe/fKjMN1JU4RLOpClJFi7N/fl+XP4UYyMDUcO
        TfAo4GUZRJtsHQhvUPtZZJCnYZstcuTVYg==
X-Google-Smtp-Source: ABdhPJzlMlIzg+nySHdB0TB8aR1cyIEvTCbYGgtW1JWxsK7186O8CHPMAAZxPgx54a02/C7E4D1vYw==
X-Received: by 2002:a65:640b:: with SMTP id a11mr3857991pgv.357.1617012396305;
        Mon, 29 Mar 2021 03:06:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l22sm15787597pjl.14.2021.03.29.03.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 03:06:35 -0700 (PDT)
Message-ID: <6061a6ab.1c69fb81.35b90.701a@mx.google.com>
Date:   Mon, 29 Mar 2021 03:06:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26-204-g20c4f011de84
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 3 regressions (v5.10.26-204-g20c4f011de84)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 171 runs, 3 regressions (v5.10.26-204-g20c4f=
011de84)

Regressions Summary
-------------------

platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =

imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.26-204-g20c4f011de84/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.26-204-g20c4f011de84
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20c4f011de848823cef23f59a3fd2a2557bd9c47 =



Test Regressions
---------------- =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =


  Details:     https://kernelci.org/test/plan/id/60617346c50af95804af02bf

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
204-g20c4f011de84/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
204-g20c4f011de84/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60617346c50af95=
804af02c5
        new failure (last pass: v5.10.26-197-gbede60ff0a573)
        4 lines

    2021-03-29 06:26:38.467000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-03-29 06:26:38.468000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 43.741108] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-03-29 06:26:38.468000+00:00  =

    2021-03-29 06:26:38.468000+00:00  kern  :alert : [00000313] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60617346c50af95=
804af02c6
        new failure (last pass: v5.10.26-197-gbede60ff0a573)
        47 lines

    2021-03-29 06:26:38.521000+00:00  kern  :emerg : Process kworker/3:1 (p=
id: 53, stack limit =3D 0x(ptrval))
    2021-03-29 06:26:38.521000+00:00  kern  :emerg : Stack: (0xc2437d58 to =
0xc2438000)
    2021-03-29 06:26:38.522000+00:00  kern  :emerg : 7d40:                 =
                                      c3b965b0 c3b965b4
    2021-03-29 06:26:38.522000+00:00  kern  :emerg : 7d60: c3b96400 c3b9641=
4 c1449f24 c09c4c0c c2436000 ef83ac20 c09c5fcc c3b96400
    2021-03-29 06:26:38.522000+00:00  kern  :emerg : 7d80: 000002f3 0000000=
c c19c77a4 c2001d80 c327dd00 ef85cfa0 c09d2364 c1449f24
    2021-03-29 06:26:38.563000+00:00  kern  :emerg : 7da0: c19c7788 e4b5ade=
7 c19c77a4 c21615c0 c3958780 c3b96400 c3b96414 c1449f24
    2021-03-29 06:26:38.564000+00:00  kern  :emerg : 7dc0: c19c7788 0000000=
c c19c77a4 c09d2334 c1447c4c 00000000 c3b9640c c3b96400
    2021-03-29 06:26:38.564000+00:00  kern  :emerg : 7de0: fffffdfb c22d8c1=
0 c226c7c0 c09a825c c3b96400 bf026000 fffffdfb bf022138
    2021-03-29 06:26:38.565000+00:00  kern  :emerg : 7e00: c36cb200 c392c50=
8 00000120 c223f2c0 c226c7c0 c0a01da8 c36cb200 c36cb200
    2021-03-29 06:26:38.565000+00:00  kern  :emerg : 7e20: 00000040 c36cb20=
0 c226c7c0 00000000 c19c779c bf049084 bf04a014 0000001c =

    ... (36 line(s) more)  =

 =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606175f37194965a25af02b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
204-g20c4f011de84/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
204-g20c4f011de84/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606175f37194965a25af0=
2b9
        new failure (last pass: v5.10.26-197-gbede60ff0a573) =

 =20
