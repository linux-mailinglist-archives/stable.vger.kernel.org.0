Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2F05F5CBF
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 00:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJEWbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 18:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJEWbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 18:31:41 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE1884E5D
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 15:31:40 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 129so181770pgc.5
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 15:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=xFLKulV66eYbd7Qq8gzRd765elGGKoQ3uuRcbncdUsg=;
        b=2h8Jo5Emzs+I7r9/2djI3xsFhJPTtHNOief5ESi+9cCUWQebxtPls9QZMuNwgDPUhM
         Bh4esmOC1F0XHZKwMO3+o5WZz70ATcRhMBfC522MFKHScpZzeeo1tBCsg+3Pv23LwMpU
         85du4mmZmWsWcRFeYeq/qB/4dmncYsau7W28bqQRp0kMVx3pXG8bUsgYs7vVGDpd2cy7
         Zuf2RAIYoKIlHzejhC8+iViCjnwSJ9t2HMfS1//0H0L6EwRwIfUK2DXZ2HCgqa+4spQH
         Mj1T7E/FWR6+XR/ge2wz9tyRKsqXGUAk/rjxSEI6OD03XdOkcrrAfYXGfafKQ7UOZ/+c
         3J2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=xFLKulV66eYbd7Qq8gzRd765elGGKoQ3uuRcbncdUsg=;
        b=adv8KPp3XgGvNjYGstfMeomt9rZcmPRodKGcZeBoBxCvQZRWHKfJn+3GMuOUMkvPco
         k3mXwtA00LoyNDNks2I+mFxhxtL6Ch+NqwHtTux4JqBSPozOrra7JOUpLtc4Bzy+/QXU
         ny09zA0J20EdDo71mKdpeJ4CcjXJKaNIrltGX3HhyNBDGbQ7ApxoYoImcT3gPQVm/Cup
         LWeN1JfgHz8iO7RQxhSe8xgphdysiUNWUY2694c0ALlJAJ95XEklPvsTRc7h62EBEk+a
         YGSunQA2JV+aPFj/B73JFRng85seyeDYNEEKJzzomUUpr/MKqQqF4vVpDS2Z9ii596DD
         Io/A==
X-Gm-Message-State: ACrzQf0yQYoV8z1U6oeX/qi1lNQORDTP7DbAnWrCHSMLsDXYxOdUgwEn
        gWWz75RdGkHINTEUKOUwQnEf86RfQI08EOqvNrI=
X-Google-Smtp-Source: AMsMyM5KiQkM5frHQRmm49ybkcRG/E24K5OON+2Wr1qFdqjcjNxKm0pOZmEwH7AimZ0W2vW/KHuT7w==
X-Received: by 2002:a05:6a00:1989:b0:546:410f:bdd2 with SMTP id d9-20020a056a00198900b00546410fbdd2mr1932727pfl.83.1665009099266;
        Wed, 05 Oct 2022 15:31:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902e35100b00179988ca61bsm10858922plc.161.2022.10.05.15.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:31:38 -0700 (PDT)
Message-ID: <633e05ca.170a0220.c5322.36d9@mx.google.com>
Date:   Wed, 05 Oct 2022 15:31:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.71-77-gea838574cfee6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 123 runs,
 3 regressions (v5.15.71-77-gea838574cfee6)
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

stable-rc/queue/5.15 baseline: 123 runs, 3 regressions (v5.15.71-77-gea8385=
74cfee6)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.71-77-gea838574cfee6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.71-77-gea838574cfee6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea838574cfee6a04c6e92cc254d6aee6812a36e9 =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633dd4bf463787f39acab5f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
77-gea838574cfee6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
77-gea838574cfee6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633dd4bf463787f39acab=
5fa
        failing since 10 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633dd64739cbe910f7cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
77-gea838574cfee6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
77-gea838574cfee6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633dd64739cbe910f7cab=
5ed
        failing since 50 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633dd8db5a94dd3677cab5fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
77-gea838574cfee6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
77-gea838574cfee6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633dd8db5a94dd3677cab=
5fc
        failing since 43 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
