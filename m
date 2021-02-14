Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFCA31B341
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 00:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhBNXUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 18:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhBNXUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 18:20:21 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FA5C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 15:19:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id a24so2707729plm.11
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 15:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jFnzCQyHimEPr6cRytZ6ATuZVThJ+zs4j1USJv4MevU=;
        b=T29L0QB84SoibyQz54GMPxX4GwuA/DdgJuI4pWtT7oGGtcUFBuspjXxXeyPL8PniDC
         P8FvD4RER7Ru/x/6imtXnOhwXvJ76ujvIRjxNEIitiZHlsv/OPlrb+ffF5WZADLdOz6K
         eJgOSVQa0M4IHQUakeSLZFhCGX1IKpCB8uDW7MkkaVoiBBHrsBtzyVyp9y55JnhcW5SI
         8r41zuwdPwfRKbfXMc2YFV1tyGOR5a7lWFq+hdrA/37DAEpo1oAHcnfuPGs1lED4YKwn
         KDgq7qaDcuyCW8tUFpYH1X1BIbu3fenhgWT2cGwUWh+XdatdVSJSo0R+RZuBjppmZvYl
         sF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jFnzCQyHimEPr6cRytZ6ATuZVThJ+zs4j1USJv4MevU=;
        b=eNs5aJIQJbSZHH0SYcWcttmS8oWEEpWR5Am0WuHGlSLajUeazTm5hGg/XtoWxnVj/i
         Ml2YRSlwI/nJ4ndNOoeY8+rYm6kElPavUj/mQY/nR1CgOv8CuqcREyr4iinuhehIDIy0
         chAHzcx1vA89tbMfCLLN/PT46sbnbUliq30wZnxMKs3fvu3OcCU16bD9Yx3gEWkEXolB
         13UxZ8OIv+2cDV1Jk90fjp660DkVR7O0gEo5jD7zfmhidq28Xi4yk516Hg4DSx8GoJAS
         EGGv+FoV2Nb589KAikqcUHDbHtrR7IJwtKzXMdsUWG7ZaTrKvhlxa5TrhFDwquaHG8Vq
         /SRQ==
X-Gm-Message-State: AOAM532vtuAKh0DRCR9vk+hNgYcznlRu+ztAKw+HVaO+nagbFz5pEdyu
        VYkSe1osOap61Z03NrnaAF7rR6A84X+HnQ==
X-Google-Smtp-Source: ABdhPJxRoNAzak65mYhfm71zVwtosKSK6Ff/qPFA30liuuNr6AVlGfSsukoQ3Ga2YgjBf5anDPVrxw==
X-Received: by 2002:a17:902:a5c2:b029:e3:2fdc:7958 with SMTP id t2-20020a170902a5c2b02900e32fdc7958mr8921338plq.30.1613344778800;
        Sun, 14 Feb 2021 15:19:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y200sm16536314pfc.103.2021.02.14.15.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 15:19:38 -0800 (PST)
Message-ID: <6029b00a.1c69fb81.963c5.2ce9@mx.google.com>
Date:   Sun, 14 Feb 2021 15:19:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.16-49-gf1350551b28c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 96 runs,
 4 regressions (v5.10.16-49-gf1350551b28c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 96 runs, 4 regressions (v5.10.16-49-gf135055=
1b28c)

Regressions Summary
-------------------

platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre    | gcc-8    | multi_v7_de=
fconfig  | 2          =

imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =

meson-gxbb-p200          | arm64 | lab-baylibre    | gcc-8    | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.16-49-gf1350551b28c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.16-49-gf1350551b28c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1350551b28c12fed704406e85eb2f4b789f4d6b =



Test Regressions
---------------- =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre    | gcc-8    | multi_v7_de=
fconfig  | 2          =


  Details:     https://kernelci.org/test/plan/id/602979cec6042259d23abe8c

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
49-gf1350551b28c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
49-gf1350551b28c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/602979cec604225=
9d23abe92
        new failure (last pass: v5.10.16-16-g8827cf44e1519)
        4 lines

    2021-02-14 19:27:50.241000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-02-14 19:27:50.243000+00:00  kern  :alert : pgd =3D (ptrval)<8>[  =
 39.525993] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-02-14 19:27:50.243000+00:00  =

    2021-02-14 19:27:50.243000+00:00  kern  :alert : [00000313] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602979cec604225=
9d23abe93
        new failure (last pass: v5.10.16-16-g8827cf44e1519)
        47 lines

    2021-02-14 19:27:50.301000+00:00  kern  :emerg : Process kworker/2:1 (p=
id: 52, stack limit =3D 0x(ptrval))
    2021-02-14 19:27:50.301000+00:00  kern  :emerg : Stack: (0xc23ffd58 to =
0xc2400000)
    2021-02-14 19:27:50.301000+00:00  kern  :emerg : fd40:                 =
                                      c3ce6db0 c3ce6db4
    2021-02-14 19:27:50.302000+00:00  kern  :emerg : fd60: c3ce6c00 c3ce6c1=
4 c1449310 c09bdb1c c23fe000 ef86cf80 c09beedc c3ce6c00
    2021-02-14 19:27:50.302000+00:00  kern  :emerg : fd80: 000002f3 0000000=
c c19c76e4 c2001d80 c3a80180 ef86d000 c09cb274 c1449310
    2021-02-14 19:27:50.343000+00:00  kern  :emerg : fda0: c19c76c8 3ff096b=
2 c19c76e4 c3a7c940 c3b7f200 c3ce6c00 c3ce6c14 c1449310
    2021-02-14 19:27:50.344000+00:00  kern  :emerg : fdc0: c19c76c8 0000000=
c c19c76e4 c09cb244 c1447038 00000000 c3ce6c0c c3ce6c00
    2021-02-14 19:27:50.344000+00:00  kern  :emerg : fde0: fffffdfb c22d8c1=
0 c2446b40 c09a119c c3ce6c00 bf048000 fffffdfb bf044138
    2021-02-14 19:27:50.344000+00:00  kern  :emerg : fe00: c3acc2c0 c32db50=
8 00000120 c2416dc0 c2446b40 c09fab38 c3acc2c0 c3acc2c0
    2021-02-14 19:27:50.345000+00:00  kern  :emerg : fe20: 00000040 c3acc2c=
0 c2446b40 00000000 c19c76dc bf0ae084 bf0af014 0000001e =

    ... (34 line(s) more)  =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit       | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60297c74ae6613be9b3abe8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
49-gf1350551b28c/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
49-gf1350551b28c/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60297c74ae6613be9b3ab=
e8d
        new failure (last pass: v5.10.16-16-g8827cf44e1519) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
         | regressions
-------------------------+-------+-----------------+----------+------------=
---------+------------
meson-gxbb-p200          | arm64 | lab-baylibre    | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/60297947853d482fdb3abeba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
49-gf1350551b28c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.16-=
49-gf1350551b28c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60297947853d482fdb3ab=
ebb
        new failure (last pass: v5.10.16-16-g8827cf44e1519) =

 =20
