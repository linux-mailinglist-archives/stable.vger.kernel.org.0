Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCF6635F1B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 14:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbiKWNQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 08:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237394AbiKWNQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 08:16:19 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F611121DF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 04:57:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k2-20020a17090a4c8200b002187cce2f92so1934378pjh.2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 04:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2DtrFTGpj9qHPmHLGW+rhncKISUSoBHFvXE+v5lOun8=;
        b=EYQn9ovBshZ9QmnQJrxhrWsnaQ4Rgtf6xfy4AVY2UyvdFXeVzbboMFZlgmmwbF8QyK
         5eSweF60461W66nAYC1+2oGUb9LHCgNPjl995AKpw+mYElhXmjaHgxCnWhkSHfJ4KcB1
         LHjhoZu0yDs7u0uq5lXsNvaLOLVvNzSM6zBuclwzgEPqQ3HM5dm/S6k9bcFgCfe+SKSF
         az2XXCmY6c7rdc/cBxgx3SlGAGlaM05z0WPk86JeI41W1GKR5cAepPgpMX4GUzcck++R
         IE75IISo82THkmUFGS95OiDdLRemZVAU0euNvlu1yJcR2XNUojRkqgiPgyQoiZ4djOVo
         Agtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DtrFTGpj9qHPmHLGW+rhncKISUSoBHFvXE+v5lOun8=;
        b=wcmAwS17WKOrMrktGYQo+JX12PiKHbs98WSj0O9vkEZCqkYrWqJdJBFIyS6sGzT8Qx
         k+SOD3UBA0VBGF7/3Zfd+5zxU0I+niOzm56YbjFyUwS0CQ25Z1pNI9Dh8UCSXaZaGqPf
         /0/zbt18MJxAwYhijS89uNxEWSWS8j856v1XO//FHKNaC0lB3d5OaEk4rHBd4QOVZst1
         dvCygBNETXpGVYFHl5m7pmXG778mE/g8MjibbtXgDZ8vXNNMZkEhJ/RogwdCoo5GhK1w
         jzFNO2xGdIwdR2qWUUy/cj8kSp82Ci75B3YqfBp3qG+6DHVQPY0Rjbm+FC1n8sX6O/58
         JpUg==
X-Gm-Message-State: ANoB5pnRBo0dBxLzYqwDT9nlHGNpi4skCKTJ2im4F7ElI00zjyxK+jE8
        ZuD2dhnpJSuEpJg1Bt+5VHWaFXuqNOp4Lrlw
X-Google-Smtp-Source: AA0mqf6IEIKjWYKMHgT7HaJ7N1mr8HHcS8ByAW56KhUw8C6o1vTw0R/jc50Ac3O3BjfmCwHBVyVlbA==
X-Received: by 2002:a17:902:cecb:b0:17f:628d:2a8 with SMTP id d11-20020a170902cecb00b0017f628d02a8mr21007116plg.34.1669208207689;
        Wed, 23 Nov 2022 04:56:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902f60100b00186ac4b21cfsm14179986plg.230.2022.11.23.04.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 04:56:46 -0800 (PST)
Message-ID: <637e188e.170a0220.ba0bc.5b74@mx.google.com>
Date:   Wed, 23 Nov 2022 04:56:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.79
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 164 runs, 2 regressions (v5.15.79)
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

stable-rc/linux-5.15.y baseline: 164 runs, 2 regressions (v5.15.79)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3df0eeae4d9a547c0f19924952ccb8290582e5d0 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6374d0e653ac79e76a2abd78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374d0e653ac79e76a2ab=
d79
        failing since 50 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6374cf7c67bf8daccb2abcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374cf7c67bf8daccb2ab=
cff
        failing since 50 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =20
