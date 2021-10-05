Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF4422F68
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 19:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbhJERwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 13:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbhJERwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 13:52:19 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F3CC061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 10:50:29 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u7so153656pfg.13
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 10:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iBpg5b5LLIkJQ5LAPGyAVWWduc+ue3AL4/78YnAi4H0=;
        b=Vgn7XFwz8i2ZlkUxWBluooIJ62kcx5B30ulT78Doh8BZjJH3AibnkIXV6eQ6FBO863
         d7ZFm8Pc01CG/nqugWUxClhpi1Ghy9qA5O72zIJwCNHRKVka/GPST3zPtrmTsGg5hAyI
         Ioqkg+0nxPXFpVNiKsCqOa/Z7FWrIhTy5MWAI29PYAJDHul4FeKH3YjRFhoRobJLzBd7
         YoXrK6MZsmuZEDjfrVdh2xVD81EjRH1MPvzrdN7cftV0klpIupnB1nnKNu3oUPYlry/N
         u5JYW+sPlSDNErnV+bHRbwb69IIA0yes+L/tcUuETmIJsXgRAJwp0Sy1k2U45CiW4sfb
         Y/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iBpg5b5LLIkJQ5LAPGyAVWWduc+ue3AL4/78YnAi4H0=;
        b=G3Kzi4rI1T7Kn5hQabLHIF0mNBT05XCI47uKDKpi3bHuryDf7a+YU7VosZlMoMwCSp
         k3vPY4V/wcT2F7IirGMatqgi9GhB8lKRvLuXrmDPSTpTTdlkf6SpoNE4E+OB090WAFZJ
         BNLm/OlkRtEh2t/EuDqjavw0u6/oH8J41Mtj88uHaIaYstY/RBrWrUpbQ8iBUHd0bE+Z
         Pw4f6N9zVvpgc5RuJk9lc6Bvu6upCYpgn+e8hjMC2TKp9BKsfItOjFBeUFIpmOXr6Uec
         XGOO7TtfGWzGvx8vBb+ZzabNDKxBpqwnDXMXRTvWN19t7BRO7G+mbvircdScKRvd+RsS
         nbtg==
X-Gm-Message-State: AOAM5339msStyFJNsj72OHA1ZlL0c749w1ebLbVS610uVs6Wd4NICVCO
        8N7WAFS6yvtEHFxlbQ5MhBFQPq3hmAycURrz
X-Google-Smtp-Source: ABdhPJwHYPrFYfTV5Eovn5dEIlCxzWCEveJqPdhCf8suYfV0GSKOwY1+UY3ld1VTqKLKjjMuO90bnA==
X-Received: by 2002:a63:dd45:: with SMTP id g5mr3189236pgj.236.1633456228410;
        Tue, 05 Oct 2021 10:50:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d137sm19022398pfd.72.2021.10.05.10.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 10:50:28 -0700 (PDT)
Message-ID: <615c9064.1c69fb81.bf10c.b839@mx.google.com>
Date:   Tue, 05 Oct 2021 10:50:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9-173-g4ad9884c65e5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 158 runs,
 4 regressions (v5.14.9-173-g4ad9884c65e5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 158 runs, 4 regressions (v5.14.9-173-g4ad988=
4c65e5)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.9-173-g4ad9884c65e5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.9-173-g4ad9884c65e5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ad9884c65e56d0cba2ae0e9ae4afcb97dac54b7 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/615c583d7aacbb44f799a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
73-g4ad9884c65e5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
73-g4ad9884c65e5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c583d7aacbb44f799a=
2e3
        new failure (last pass: v5.14.9-172-gb2bc50ae5dd9) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/615c57d8045fee69df99a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
73-g4ad9884c65e5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
73-g4ad9884c65e5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c57d8045fee69df99a=
2ed
        failing since 4 days (last pass: v5.14.8-160-gc91145f28005, first f=
ail: v5.14.8-160-g69e08636c9b8) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615c58b2360629ba4e99a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
73-g4ad9884c65e5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
73-g4ad9884c65e5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c58b2360629ba4e99a=
2ea
        failing since 0 day (last pass: v5.14.9-73-gb9d08ffadf94, first fai=
l: v5.14.9-172-gb2bc50ae5dd9) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615c57d7045fee69df99a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
73-g4ad9884c65e5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-1=
73-g4ad9884c65e5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c57d7045fee69df99a=
2e9
        new failure (last pass: v5.14.9-172-gb2bc50ae5dd9) =

 =20
