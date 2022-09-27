Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EAA5EC724
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 17:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiI0PCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 11:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiI0PCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 11:02:40 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183FEB6D7B
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 08:02:39 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a80so9935682pfa.4
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 08:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=/4f4qfKR1sfm69WPvg9b1W8GYM1lElqxT8B0MFZiC0c=;
        b=u0KNhhI6+Z3QUb5QEvlLH1J3p4K/lrbaUa5cfV7/LkrF7IbWf/01Oa9+K9JhjvabYq
         BA/Sk4qGshxLsXHs974rmvagkvzH47bCtqBmo3o2b0ZRWosIVM6kNuFsOslcN7oY5bPH
         bQfhqbS4sO5aLdenKOcSXKnX+K6mLfUhgwOtwNqOnvk9yC/MmNZRla9IE4YsUqSFhUs3
         ayKLivDTGzE1UrniDDL89IuEE0O8hQMn+iwCU8q9AiHGn/e5D/jfJuLcDoIzqqR3sXVu
         S5jLXSpOVcf92I7MabSmpX+F9XJyoehOrnYmG1Cm2Jf5RxSy0Sq45KK9Y7Y58B/LQABM
         1cNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=/4f4qfKR1sfm69WPvg9b1W8GYM1lElqxT8B0MFZiC0c=;
        b=WvulGrFHd+S8RygEXuwiaUGQh0xrNc8SW/4SBOIrcanlTQhvOlsLVXaZRR4s92yZaM
         +P6SjA29NujT6LETstN6fwKatgZV8YozzazLcQtO1s5S+GoYhbWRdYQVsZaDG/yLXHVZ
         jzgRtmnlATVeEcSH9238XVuz2xJjcSvuGFOhvvng3GxigE/UhfZ4DRH7ttU4eyuNL0XE
         mWZ0zvilEBAndgjbgU1Uw//WjoCh7LoIq36YfzfKeawzciir+qgve65m+5eQQg3KjZTO
         8GsCeV9HyCUCz/2+UXNkyj+e0J7UrKRsmksQjHg6093YXe5+jVnNizNUXzU9NxcZITC0
         CTUQ==
X-Gm-Message-State: ACrzQf2hnWeQ2iigADlz6MYjIVE7BXAzYF8uiNRrosWiVMUDbXbQPkiw
        DPR8OD8+DTV+t1YgJoVZa6/CAU7nQUxLxAr8
X-Google-Smtp-Source: AMsMyM62cG+ebTf1joSj8B31W4vmKMxeWKKFRFzLPs+21sjK1AvjTYtrdTQBMn9XjYHLPSFE3sA2rQ==
X-Received: by 2002:a63:201c:0:b0:434:8bd6:87e1 with SMTP id g28-20020a63201c000000b004348bd687e1mr25104942pgg.394.1664290958168;
        Tue, 27 Sep 2022 08:02:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0016909be39e5sm1660355pll.177.2022.09.27.08.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:02:37 -0700 (PDT)
Message-ID: <6333108d.170a0220.7d410.2bba@mx.google.com>
Date:   Tue, 27 Sep 2022 08:02:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-207-g5704e94c78ce
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.19 baseline: 176 runs,
 3 regressions (v5.19.11-207-g5704e94c78ce)
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

stable-rc/queue/5.19 baseline: 176 runs, 3 regressions (v5.19.11-207-g5704e=
94c78ce)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-207-g5704e94c78ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-207-g5704e94c78ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5704e94c78cef1862a12df9c7852ae6c8c977c00 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6332dcfb387f259763ec4ea6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
207-g5704e94c78ce/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
207-g5704e94c78ce/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332dcfb387f259763ec4=
ea7
        failing since 1 day (last pass: v5.19.11-158-gc8a84e45064d0, first =
fail: v5.19.11-186-ge96864168d41) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6332de7542ae949f91ec4eac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
207-g5704e94c78ce/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
207-g5704e94c78ce/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332de7542ae949f91ec4=
ead
        failing since 0 day (last pass: v5.19.11-158-gc8a84e45064d0, first =
fail: v5.19.11-206-g444111497b13) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332df7b9cb48f678bec4ea8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
207-g5704e94c78ce/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
207-g5704e94c78ce/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332df7b9cb48f678bec4=
ea9
        new failure (last pass: v5.19.11-206-g444111497b13) =

 =20
