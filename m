Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAC8409C50
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 20:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhIMSdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 14:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbhIMSdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 14:33:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E603DC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:32:02 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t20so6985968pju.5
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 11:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0P8bs/UtXbyhO/unoENQKclLzPp0UdRosEEYK1iUNNE=;
        b=xxoPPT1wEZDSXCNEQJ+aHkH5JVoo0LBaZmVLZ7uEuATWWOgJ9AW9IbzLLX2qupXAVV
         T5dMrH12302HgVTyNlKQA01olI5rT2YF58HDrNf5ItrA5Z3ZsxfhZDRRtJFGMY6JN9Vo
         JIcQvZvi2/b7RrxQN7lKt7jANN8yLr9Cn8vWdwo0Z/MEPeii6tygfHdzZDnwBnKhcp4F
         U5fwwvs3yx4PBGfTiNkbUYaIwXbZYbvXGxhCSlr+5UBg7K+zysT8zf4pn3q193I4gfMq
         uFQdsAdncZggH6p8P+DPETF74xSIPg78HXdjAY/T65FedUQk7e02ZGvtal0byP4fH36d
         2WGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0P8bs/UtXbyhO/unoENQKclLzPp0UdRosEEYK1iUNNE=;
        b=KVWuwPP55cVey6kijM75zPTGqm7TsUhtJuJfqOAAsHfYOIFQFRvOBQahFpYl0vunWK
         2vemBwMClR/ppgyh9QwKAUgviDJOTgI9fd80y8a8jRkMPu+inNnrG3GpncLVaZUmGug5
         eB9pn7rOQbM0MfWI2IFpU5bFb4BiOQqbCkxhCQmzek8JpRNp0l/jR5+vrCxVWRl7XNVA
         hbMMYuCTyXsNBcSYsoOPGADOVASa7GrweCMMlh86Z1Ces/WOkL1G3Em8zzoXiJGPkMCL
         SeNoEy8Bd+vc9O6B+0YkUmHst+WOEEs7WTFPfUjy2da9git5jl3HnXzFteaCDCAILIgy
         QTvQ==
X-Gm-Message-State: AOAM530VLPIK+EZMkwEut8yqvj/6Qf+uAjCZqd8hKZFLzgOBhHb5k2VD
        TdJ6REJK7sRtQ9CP9cKdOJeR2xmlFp4+53o/
X-Google-Smtp-Source: ABdhPJyCTU1vHlFezJN44KFBZ6zrBcQ5TSqFixFIrBxeAjrQyswabSX5aKJOVkCKjloIwjs3zqPoRg==
X-Received: by 2002:a17:902:b601:b029:12b:d9a:894f with SMTP id b1-20020a170902b601b029012b0d9a894fmr11483845pls.63.1631557922210;
        Mon, 13 Sep 2021 11:32:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm2719583pfo.172.2021.09.13.11.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 11:32:01 -0700 (PDT)
Message-ID: <613f9921.1c69fb81.e0a3c.7bec@mx.google.com>
Date:   Mon, 13 Sep 2021 11:32:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.3-334-gea4f8a6d7906
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 178 runs,
 4 regressions (v5.14.3-334-gea4f8a6d7906)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 178 runs, 4 regressions (v5.14.3-334-gea4f8a=
6d7906)

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
nel/v5.14.3-334-gea4f8a6d7906/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.3-334-gea4f8a6d7906
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea4f8a6d790615a6fb67fa15fef8b4c7004913d4 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/613f6849b7723bfc9899a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
34-gea4f8a6d7906/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
34-gea4f8a6d7906/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f6849b7723bfc9899a=
30b
        failing since 0 day (last pass: v5.14.2-23-g3e6e24d4af82, first fai=
l: v5.14.3-294-g9d35f37c1067) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613f67673133b9bc8e99a350

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
34-gea4f8a6d7906/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
34-gea4f8a6d7906/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f67673133b9bc8e99a=
351
        failing since 3 days (last pass: v5.14.2-23-g1a3d3f4a63ad, first fa=
il: v5.14.2-23-ge6845034189d) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613f66e888fc564e8899a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
34-gea4f8a6d7906/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
34-gea4f8a6d7906/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f66e888fc564e8899a=
2eb
        new failure (last pass: v5.14.3-294-g9d35f37c1067) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613f65d1606da4538a99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
34-gea4f8a6d7906/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.3-3=
34-gea4f8a6d7906/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f65d1606da4538a99a=
2db
        new failure (last pass: v5.14.3-294-g9d35f37c1067) =

 =20
