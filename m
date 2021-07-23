Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018EA3D394A
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 13:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhGWKgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 06:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhGWKgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 06:36:06 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAE8C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 04:16:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a17-20020a17090abe11b0290173ce472b8aso8411662pjs.2
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 04:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7DgN+b0iI97QKj6mKTd/D6BeWSEypXQy522a22zl3kY=;
        b=AKDcQLR1pCw0YeM35LZQ9WcXxD2x1QKc5hUDPxmJQedD0oGNkkr4QsJFMfi/3hPa8H
         2Q6zY445BQXFAWgJZuyPRKl3I/drOB4EKTtstO5WHHNeRHYT+L9jWA4GsTNMfvCtaPXl
         cqci1DYxAYpiOB6LDQd47iJr30khQC9dZYsJ99P5OTw9KW53XnCJWrfscu8dFqFFaoMj
         4L0OeyOiFG3O9NjLZCDJmySSrjbYWJjk461p2MnPLpXENjLMzMhW8BL7L7P03VPQz6z5
         pRaIkUxgMFMqVNzM43ULkGeOT5u2kWBhunW74GGLmhbbzJLNLM8zSAPrNTnYloz0rALP
         f8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7DgN+b0iI97QKj6mKTd/D6BeWSEypXQy522a22zl3kY=;
        b=ODOmTs0xGOQpt4iIsCOU8vitbQK0+oUiet/v9+ALGr8z/X4PMy+w00XXnuCLokV4aW
         Jou5PtpdrHHhnRa+6Sx5Isv+oWQiec+OIAlHSqT/oFvbVB8aDh6UHBBVKM59NHqPXwU9
         XZAprUnqL7VvtT4bbKFDFfqfVAZ4m+iTjvyA8UKioVnIT10kQvOHNmbhuvZC4PERo4IQ
         oni5Jq2WVIwrLgG2F9eNLp5webyba8O3my8tSp6lCn9d8w2j5AXGW+mTncO76EZIqROs
         Dcmvb91sWtf1ZARO9e8Puk9LMRqmkmTTvT8tdNJgDXDUl4nqwtquGYOmmtRWK7Oxte3I
         T4tA==
X-Gm-Message-State: AOAM532RGr5uPRut8d8VyjNtRs2VjwcE7p3UHQDDNLqU+U1jTeE/BWfg
        7zZNp/ZOMuI+5QSA3vdf4PszEYujlUiOh8tq
X-Google-Smtp-Source: ABdhPJzncHbAMWjlWCOBqpCf564eugwxaDcK5YdbMyZheoMpxPv0pWYr1VV0pQ6KNqWQkxl7lKOB1g==
X-Received: by 2002:a17:90a:8043:: with SMTP id e3mr1615250pjw.32.1627038998922;
        Fri, 23 Jul 2021 04:16:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm5972082pjg.54.2021.07.23.04.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 04:16:38 -0700 (PDT)
Message-ID: <60faa516.1c69fb81.e0685.2b37@mx.google.com>
Date:   Fri, 23 Jul 2021 04:16:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.3-508-g80f75a7443c5c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.13.y baseline: 160 runs,
 5 regressions (v5.13.3-508-g80f75a7443c5c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 160 runs, 5 regressions (v5.13.3-508-g80f7=
5a7443c5c)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
beagle-xm                    | arm   | lab-baylibre | gcc-8    | multi_v7_d=
efconfig  | 1          =

beagle-xm                    | arm   | lab-baylibre | gcc-8    | omap2plus_=
defconfig | 1          =

imx8mp-evk                   | arm64 | lab-nxp      | gcc-8    | defconfig =
          | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-8    | defconfig =
          | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.3-508-g80f75a7443c5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.3-508-g80f75a7443c5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      80f75a7443c5c9a01f54e3df71ccd23d13c70c44 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
beagle-xm                    | arm   | lab-baylibre | gcc-8    | multi_v7_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa7041dce406587285c25f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-508-g80f75a7443c5c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-508-g80f75a7443c5c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa7041dce406587285c=
260
        failing since 2 days (last pass: v5.13.3-350-g6c45a6a40ddee, first =
fail: v5.13.3-349-g1d9dba03aebe5) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
beagle-xm                    | arm   | lab-baylibre | gcc-8    | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa719510f8da13b585c305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-508-g80f75a7443c5c/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-508-g80f75a7443c5c/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa719510f8da13b585c=
306
        failing since 7 days (last pass: v5.13.2, first fail: v5.13.2-254-g=
761e4411c50e) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
imx8mp-evk                   | arm64 | lab-nxp      | gcc-8    | defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa6ed14da800ade585c2d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-508-g80f75a7443c5c/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-508-g80f75a7443c5c/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa6ed14da800ade585c=
2d5
        failing since 8 days (last pass: v5.13.1-805-g949241ad55a91, first =
fail: v5.13.2) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-8    | defconfig =
          | 2          =


  Details:     https://kernelci.org/test/plan/id/60fa6d2951c613fa0385c283

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-508-g80f75a7443c5c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-508-g80f75a7443c5c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60fa6d2951c613f=
a0385c28a
        new failure (last pass: v5.13.3-350-g6c45a6a40ddee)
        11 lines

    2021-07-23T07:17:46.069204  kern  <8>[   15.965820] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D11>
    2021-07-23T07:17:46.070245  :alert :   ESR =3D 0x96000005
    2021-07-23T07:17:46.071327  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2021-07-23T07:17:46.072326  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-07-23T07:17:46.073305  kern  :alert :   EA =3D 0, S1PTW =3D 0   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60fa6d2951c613f=
a0385c28b
        new failure (last pass: v5.13.3-350-g6c45a6a40ddee)
        2 lines

    2021-07-23T07:17:46.103880  kern  :alert : Data abort info:
    2021-07-23T07:17:46.105710  kern  :alert :   ISV =3D 0, ISS =3D 0x0000<=
8>[   15.994427] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D2>
    2021-07-23T07:17:46.106902  0005
    2021-07-23T07:17:46.107940  kern  :<8>[   16.002724] <LAVA_SIGNAL_ENDRU=
N 0_dmesg 587642_1.5.2.4.1>
    2021-07-23T07:17:46.108929  alert :   CM =3D 0, WnR =3D 0
    2021-07-23T07:17:46.109910  kern  :alert : swapper pgtable: 4k pages, 4=
8-bit VAs, pgdp=3D00000000026ab000   =

 =20
