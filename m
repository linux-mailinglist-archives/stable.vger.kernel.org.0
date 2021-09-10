Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDF7406D78
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 16:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhIJOT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 10:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbhIJOTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 10:19:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED0AC061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 07:18:01 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n18so1237670plp.7
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 07:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FsP2fuI3Ugi4nxvmPOVGCzpKCCK4L1NFlv+TTYFzVkU=;
        b=JE2fznhqKTQ1KgEPLJ4i6YCsl5+6jDijFPjyJVFjbLD1eW91ZRrNuCEiS4et6nN7sJ
         CNsACzymQz36k3OLB5BGg9yykBvdTrove6nnFkXnLoVhtewMkjlskdV7wCajELvXkAH2
         SxoW4+JYK3xmuz+A4tOJ9GuTh+5ydsjdLz7CWuiAd9bWiGyAyueDTv3kXjDEqEpXCeCB
         llvqQAnOnIPT8fCsM6bHcNFCROcZeZJEVIT557dP4RsnlMiKGqfEjvTpHRZxUsQdtNOA
         sncLsXhBPmOoynU3PB6dUYVwPO9dCNU4D2EAf2Bvo46HIvKsAZBlvOmBvfoz8TpHe4LR
         kD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FsP2fuI3Ugi4nxvmPOVGCzpKCCK4L1NFlv+TTYFzVkU=;
        b=00WUfu50ogOGTUG2FXtI0QuxbhjvdFqx8Rq96Tck/+Xd0rwMn3dEYvcOvu5d6YoASQ
         6IV7ygtQ+XkGS5J0I3oSujdD3ykgRbGzEsTfo+PyomyeOLitgy+MyW+od5AXihOsbmI7
         1V947gi1KOypjtyBC0dOTgOZgqEbAYCpHZ0cca6uHLa2evrVH7r63XHm6J1vEKk1fMml
         nItY6kRMNs2IoYOAqg88mxpDPutkISUWbPR+ZySY4gnnMEnIz4IjC+7x4OwOcQ2nVfuG
         MIOUgois8RQ6wtvddyQKN/SfMqqRFrDvRPVSo2o875M7xgpIiBFzCn2tfHPJM85Of23m
         69tQ==
X-Gm-Message-State: AOAM5328Ea7V6lYF92imiyw9ZsnTg8FLEwlrMTX2kMs5Yc4KO6cFR2Dx
        JvYpaYdP7lVbOG7jamvUa99YgjQM4f1BX3Eu
X-Google-Smtp-Source: ABdhPJweO++w8SQSaByrUJtLwbi+eTXqaFGULLwxKH8LA6zjxn8ZkFrqavwXjUdrMrIBQIkLr5kV6A==
X-Received: by 2002:a17:902:a50f:b029:11a:cd45:9009 with SMTP id s15-20020a170902a50fb029011acd459009mr8039105plq.38.1631283480736;
        Fri, 10 Sep 2021 07:18:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm5471049pfd.124.2021.09.10.07.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 07:18:00 -0700 (PDT)
Message-ID: <613b6918.1c69fb81.92fac.fb97@mx.google.com>
Date:   Fri, 10 Sep 2021 07:18:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-22-g225806fcbb98
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 190 runs,
 3 regressions (v5.13.15-22-g225806fcbb98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 190 runs, 3 regressions (v5.13.15-22-g225806=
fcbb98)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =

beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.15-22-g225806fcbb98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.15-22-g225806fcbb98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      225806fcbb9876c4434b2bcd36ebd64677d693e4 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613b353dea7b9c5464d59676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-g225806fcbb98/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-g225806fcbb98/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b353dea7b9c5464d59=
677
        failing since 1 day (last pass: v5.13.14-26-g85969f8cfd76, first fa=
il: v5.13.15-3-g247080319c1b) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613b36a6c0ae30b414d59694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-g225806fcbb98/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-g225806fcbb98/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b36a6c0ae30b414d59=
695
        failing since 0 day (last pass: v5.13.15-4-g89710d87b229, first fai=
l: v5.13.15-6-gd33967f7a055) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613b375a3d193410e3d59679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-g225806fcbb98/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-g225806fcbb98/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b375a3d193410e3d59=
67a
        failing since 2 days (last pass: v5.13.14-24-gff358fe92fee, first f=
ail: v5.13.14-26-g85969f8cfd76) =

 =20
