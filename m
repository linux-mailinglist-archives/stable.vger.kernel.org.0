Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A783D8EAA
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 15:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhG1NKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 09:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbhG1NKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 09:10:21 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04686C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 06:10:19 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so9967679pjb.0
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 06:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kZnwwS0yICGsShWqg+YfdsXR1dhRadr6Ke1xvrzG7CI=;
        b=MSIzuz2kplSngdwuT+1geoEKj1v5/shVFEhe+RqS08gKEwGa79Dv6ptxXCLAjZKfAh
         ROixMB5VAokm07S3W95URdMojfluY+eQ7hfuCCrNUHO8yL+qamsIGZpJnNjh0ARuwPW1
         8/NEQJr9l5VdW0hYCHu0rrKFxiqzOuVK0UpFyE19Od3KEe71AhV29pLFvPTfAgVlfp6q
         Cf3Sdy+in1A1ReUkDzNPmilPHxfHhr0FWQGQmSmRu4WZMOmqDnZz2EKkqiyBUqymw0Aq
         ED4Je8hmPf7nf0Ye8/mlpBE1sRsitV8Fjw7AgIw4k4AMhNdOz20HiPqBB9ebS03MF3XE
         tmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kZnwwS0yICGsShWqg+YfdsXR1dhRadr6Ke1xvrzG7CI=;
        b=HFtXGbnJsqEgEyB1x+2MsqENvgMAm4CX5rgn4ybPieJwVRjwMGzI9zAGKUvBRot5Cd
         6WtMctHk2DeWvdmbg4LS8pdR2GW+hwkOFBKjgmd6V+pHri5TTLYAV36Gmfsm3B7il8md
         s462J1j93Pk8PbfFBLOOpMlmkkg8qlFVjRy+copG7M8ovG6yWmmBWeFYZ9gD4a0HRp97
         bYOaugES34787LrCmWmggdjTeQl2jESyhgnp0QoRI7yM7mSb73dDlMzcI2xc2Wuz2Psg
         oS2gLlmqDZ+XJuNQ1vXcUiWTxqNY5g8MEioOsLQPayvVwd6Rk4nVPmX4MMrp6mrSv6Cf
         Md4w==
X-Gm-Message-State: AOAM532H+FWGNlOe9zMIwlYETCcOZRvLZizLs6zYs0XZqTVKzALRFYUz
        YPnOJLqsv5K9ZGmMqY83iCyprN4Q+PCwoveb
X-Google-Smtp-Source: ABdhPJzfLw4JW5Hk4V+xgwuSnZOSKws+BEuzB85gpU0cOgAOk4/RTenHkgrqOldbTdXtugeZLzEyaQ==
X-Received: by 2002:a17:90b:3905:: with SMTP id ob5mr13773042pjb.211.1627477818315;
        Wed, 28 Jul 2021 06:10:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y15sm7724228pfn.63.2021.07.28.06.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:10:18 -0700 (PDT)
Message-ID: <6101573a.1c69fb81.a85c1.73f4@mx.google.com>
Date:   Wed, 28 Jul 2021 06:10:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.53-167-gff9fbe06f641
Subject: stable-rc/queue/5.10 baseline: 182 runs,
 6 regressions (v5.10.53-167-gff9fbe06f641)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 182 runs, 6 regressions (v5.10.53-167-gff9fb=
e06f641)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =

d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig =
            | 1          =

hip07-d05           | arm64  | lab-collabora | gcc-8    | defconfig        =
            | 1          =

imx6qp-sabresd      | arm    | lab-nxp       | gcc-8    | multi_v7_defconfi=
g           | 1          =

imx8mp-evk          | arm64  | lab-nxp       | gcc-8    | defconfig        =
            | 1          =

r8a77950-salvator-x | arm64  | lab-baylibre  | gcc-8    | defconfig        =
            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.53-167-gff9fbe06f641/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.53-167-gff9fbe06f641
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff9fbe06f6418363967ed045cb3b8a7dcc827427 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/610128276c75fdde1e5018e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610128276c75fdde1e501=
8e1
        failing since 16 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/6101298f8b439403ef5018d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101298f8b439403ef501=
8d8
        failing since 16 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
hip07-d05           | arm64  | lab-collabora | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/610120b74e2cf1ae6d5018ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610120b74e2cf1ae6d501=
8cf
        failing since 26 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
imx6qp-sabresd      | arm    | lab-nxp       | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/610123493ef29e05d95018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabr=
esd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabr=
esd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610123493ef29e05d9501=
8c2
        new failure (last pass: v5.10.53-167-g06e8f61b67ed) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
imx8mp-evk          | arm64  | lab-nxp       | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/61012062e9ab741e9d5018d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61012062e9ab741e9d501=
8d8
        new failure (last pass: v5.10.53-167-g06e8f61b67ed) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
r8a77950-salvator-x | arm64  | lab-baylibre  | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/61011f37f3532ac8f15018c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-gff9fbe06f641/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61011f37f3532ac8f1501=
8c5
        new failure (last pass: v5.10.51-239-g1c3a4b93b5820) =

 =20
