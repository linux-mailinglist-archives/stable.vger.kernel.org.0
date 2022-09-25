Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABB05E95D2
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 22:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiIYUO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 16:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiIYUOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 16:14:55 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B198715A0E
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 13:14:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fs14so4522295pjb.5
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 13:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=yshGbv6D08kvz/66QUCCD+HQg8ysS6qFq9AN317sqfQ=;
        b=VyrPHb/LWeqANi5ZPRqxdIBrXXYt7DXaxjjJNdManTLQDkATmz4ZSMNoqjBAvf5Zwn
         hzd/90VQhLQ+/QbiUZiooRUi83b5HE5n91KxSg4ClvmzHyVeHPhY6vduPNCNty58+VoR
         GZnPD5XkcPeWO5XXnb4tiMu6o99X8ekHvJmNX0D1GCEK4+Tm/NWIj62NPIog24YnCuRi
         DmX8/VH5w4jVub0N0513lsFNaKgrfac6ODjgVrR3kyyD2cCIKSnbg+fYEGIqQe09lwc8
         CCjNLLXB0d3wHty5VM1rwnA2tTSZJOqY1RC5fOI7RkTSJe5nMRhT0pu7too4Ml3quJ7+
         V44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=yshGbv6D08kvz/66QUCCD+HQg8ysS6qFq9AN317sqfQ=;
        b=hYk0SV/HKCCqY6oLpm71rWqQACnr9+KOyt1eJQAxwrJxYXTJudpksNQO/NkBaWo+Sr
         gSKx+171pYxR+kLMBNud0gzJg1MEQbFscO8cAT6Uf6OvnMBrGh9h1wm8u+Cv8WYt6sW1
         /8GqYapsD1zP/ajmST4MuNa3ViT+6hLzwQ3nhvfQqI2vz/4mo2aVD86Ij1zC+HLhmvX+
         SbF4NIGY7I4Ry92Yzk1mznAtJS5SFmKN75I57DqV8aX9hjdjyFQ8ObSNdhtbVqMfCqJh
         V0ORK6X/7iLstvB8YRfBtuzKEmCISNZzGLZQIJ1DMsUmTd78trznZ3QDfXsvtBYu/wUj
         loFg==
X-Gm-Message-State: ACrzQf2DFYO9z+pk9nYTXdZArEYnVSDg18N7ICeo0VosZgP++sCqcMec
        KpuKgm1CEpoK2znEwz/92fvWGmV1tYN9Q61b
X-Google-Smtp-Source: AMsMyM7lJGGVJVHtaSbg964avOg2+7Afz5cBCrnloYwamYj8FnM2kzW4LXW/HD35jGmAO+HrRU9kUg==
X-Received: by 2002:a17:903:2411:b0:178:5653:ecda with SMTP id e17-20020a170903241100b001785653ecdamr19410227plo.166.1664136892053;
        Sun, 25 Sep 2022 13:14:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i3-20020aa796e3000000b00535da15a252sm10292888pfq.165.2022.09.25.13.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 13:14:51 -0700 (PDT)
Message-ID: <6330b6bb.a70a0220.d3d8d.3525@mx.google.com>
Date:   Sun, 25 Sep 2022 13:14:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-133-gbad831d5b9cf
Subject: stable-rc/queue/5.15 baseline: 121 runs,
 5 regressions (v5.15.70-133-gbad831d5b9cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 121 runs, 5 regressions (v5.15.70-133-gbad83=
1d5b9cf)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-133-gbad831d5b9cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-133-gbad831d5b9cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bad831d5b9cf09edeb04375094afc3980f645a2c =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
beagle-xm   | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633086d09bd1adf207355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633086d09bd1adf207355=
669
        failing since 3 days (last pass: v5.15.69-17-g7d846e6eef7f, first f=
ail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63308526058dbba175355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308526058dbba175355=
645
        new failure (last pass: v5.15.70-117-g5ae36aa8ead6e) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6330868f7accadd039355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6330868f7accadd039355=
643
        failing since 0 day (last pass: v5.15.69-44-g09c929d3da79, first fa=
il: v5.15.70-123-gaf951c1b9b36) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633085aa8f051bbfdf355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633085aa8f051bbfdf355=
649
        failing since 40 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63308764254459387d355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
133-gbad831d5b9cf/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63308764254459387d355=
664
        failing since 33 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
