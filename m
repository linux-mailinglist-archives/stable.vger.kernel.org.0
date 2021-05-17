Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F930383A22
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbhEQQjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242830AbhEQQix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:38:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1642CC09C10E
        for <stable@vger.kernel.org>; Mon, 17 May 2021 08:42:18 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso5801079pjp.5
        for <stable@vger.kernel.org>; Mon, 17 May 2021 08:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GKOESGDZu9AKNFhKev1jY3BOfQt8B9k/Gz3sACCOEjQ=;
        b=mawUvrJEgtm+pO3hx26RVjkSEse54fj3KyPmItKVCbhf0tHRKDx4WhQrYfynojz/Pk
         EMyAJJWMlFMw5FQNuhtc4p7dEmkoMj0cp8KOoiEFFeWQe++3ggVIXk9ZLJw/qpILsJBO
         qzLxQBaxty43NxSSNPrCXPhFVRSOhKX2FwsHs94IvqNdmXr6KPQstQcV8YuiHmZ9P9PK
         Mx12NbyRWP2HSmpK3uPTKBgM9dSARXL5G71Wjqs9R/4NoOj7N9l1lBSgn4EgaD5lOJYb
         w73xLwjZDy4sCNMJAJJL/2Vei2CSd7p1we9CxdoJL3SlHjOofR9cL604bJYti5xxFGNF
         TFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GKOESGDZu9AKNFhKev1jY3BOfQt8B9k/Gz3sACCOEjQ=;
        b=JkcIBldDxQCE1jVjhykY+0VAmVbs76dXrWpPCkI83Wm2MAFO3K1CVN9E6pzcbfp6uu
         e0ErUGmTE1EXjTIDNywPIjmzshE6pIkrPrrt0AwCU0fqmfMBiQIOgzNhyXp1V53rkYKq
         Ws/zsCATcqIFgk1YaNV/SaC9xoH0r7xbbq1nSEGySQ9zg4muoKXFz/ZcZkhpGKSovMaP
         VPHe3p6yR1KJ/Ke27j4wsFcaf6/6QOYQukQ3+uNJbZdpyqXDxEYLHPimMj2jU6NzQxJv
         ZOtAr+ChNYlRVQmaw0+IsEv1P4g+aU4ryNqYihqY5RecOya8PYqzA3minjFUm53qHu9f
         vMDA==
X-Gm-Message-State: AOAM5322IBoz7clOBKQqvydUgZto1T0gFLPRxfh/EAjGrLZVlSSZ9Gv2
        Lazq8cJ+vN4mJfvF/vzQAMPZMe3zji6gGTwI
X-Google-Smtp-Source: ABdhPJxKyM4U1i6rxZGj565Xp6j0CsXVna71CPkv7A1561yJ6RdLne/vAtfOBvLL8hNkVeiGGrwyyA==
X-Received: by 2002:a17:902:ab95:b029:ee:f899:6fe8 with SMTP id f21-20020a170902ab95b02900eef8996fe8mr610070plr.81.1621266137413;
        Mon, 17 May 2021 08:42:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a10sm6212053pjs.39.2021.05.17.08.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 08:42:17 -0700 (PDT)
Message-ID: <60a28ed9.1c69fb81.19b36.4919@mx.google.com>
Date:   Mon, 17 May 2021 08:42:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.21-308-ge37d6a211413
X-Kernelci-Branch: queue/5.11
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.11 baseline: 132 runs,
 5 regressions (v5.11.21-308-ge37d6a211413)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 132 runs, 5 regressions (v5.11.21-308-ge37d6=
a211413)

Regressions Summary
-------------------

platform                 | arch  | lab             | compiler | defconfig  =
        | regressions
-------------------------+-------+-----------------+----------+------------=
--------+------------
beaglebone-black         | arm   | lab-cip         | gcc-8    | multi_v7_de=
fconfig | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre    | gcc-8    | multi_v7_de=
fconfig | 2          =

imx8mp-evk               | arm64 | lab-nxp         | gcc-8    | defconfig  =
        | 1          =

qcom-qdf2400             | arm64 | lab-linaro-lkft | gcc-8    | defconfig  =
        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.21-308-ge37d6a211413/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.21-308-ge37d6a211413
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e37d6a2114137b1b60bf8133a8d5ceb5d197d779 =



Test Regressions
---------------- =



platform                 | arch  | lab             | compiler | defconfig  =
        | regressions
-------------------------+-------+-----------------+----------+------------=
--------+------------
beaglebone-black         | arm   | lab-cip         | gcc-8    | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a25df4f10e2e6c64b3af99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
308-ge37d6a211413/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
308-ge37d6a211413/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a25df4f10e2e6c64b3a=
f9a
        new failure (last pass: v5.11.21-249-g923b46b3a2c0) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
        | regressions
-------------------------+-------+-----------------+----------+------------=
--------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre    | gcc-8    | multi_v7_de=
fconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60a25e8e5a209d7360b3afc4

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
308-ge37d6a211413/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
308-ge37d6a211413/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a25e8e5a209d7=
360b3afca
        new failure (last pass: v5.11.19-48-gd53cc5ac4f922)
        4 lines

    2021-05-17 12:14:03.365000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-05-17 12:14:03.365000+00:00  kern  :alert : pgd =3D cc818ead
    2021-05-17 12:14:03.366000+00:00  kern  :alert : [<8>[   10.700631] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-05-17 12:14:03.367000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a25e8e5a209d7=
360b3afcb
        new failure (last pass: v5.11.19-48-gd53cc5ac4f922)
        26 lines

    2021-05-17 12:14:03.424000+00:00  kern  :emerg : Process kworker/1:1 (p=
id: 61, stack limit =3D 0xa468fca2)
    2021-05-17 12:14:03.425000+00:00  kern  :emerg : Stack: (0xc26e7eb0 to<=
8>[   10.748325] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-05-17 12:14:03.425000+00:00   0xc26e8000)   =

 =



platform                 | arch  | lab             | compiler | defconfig  =
        | regressions
-------------------------+-------+-----------------+----------+------------=
--------+------------
imx8mp-evk               | arm64 | lab-nxp         | gcc-8    | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/60a25b6c871f17615ab3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
308-ge37d6a211413/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
308-ge37d6a211413/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a25b6c871f17615ab3a=
f9e
        failing since 0 day (last pass: v5.11.21-249-g923b46b3a2c0, first f=
ail: v5.11.21-280-g28a979e1dfe0) =

 =



platform                 | arch  | lab             | compiler | defconfig  =
        | regressions
-------------------------+-------+-----------------+----------+------------=
--------+------------
qcom-qdf2400             | arm64 | lab-linaro-lkft | gcc-8    | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/60a25a48158cf86b54b3afd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
308-ge37d6a211413/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf24=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
308-ge37d6a211413/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf24=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a25a48158cf86b54b3a=
fd3
        new failure (last pass: v5.11.21-280-g28a979e1dfe0) =

 =20
