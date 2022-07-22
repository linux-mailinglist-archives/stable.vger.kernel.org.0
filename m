Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8FE57DA7C
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 08:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiGVGqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 02:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiGVGqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 02:46:13 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC146D9D8
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 23:46:12 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q16so3683806pgq.6
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 23:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BAcP7zmKsdo+wzF6i1eeEvec0UsdXJYqtYaftpjXlKQ=;
        b=dJD/zLTCAMWut7rvsXvWUWOpBZbfXtqdXLooIRicttptHi3cL6aJqsXyy1f9QM6ykM
         3hBYPyA0gWi8/5hg+VvUoj4WU1q2SyO+YUX39VgmCydEkqrHuOSb4gaAJjYLfmuCMQd4
         rWXSvnPWRIsO60SBM1rwUGjbESdL+L7RzM+H/KAXq68qN55O4WbtLFV+tAYYbJIZjAwr
         eRIwt9wrVeWkr8dTeYwTanbMsfGqWPsL9tGvBNLY/KSBnbsAh1p8xnAL8dIiyRaM8oC6
         8qTRL7BnGr8BB7hQsXBXAy3hO6DfBMwcUDhW/F4OgYQoTMnmKIovKs6c8Yx3m4aqflH3
         6tUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BAcP7zmKsdo+wzF6i1eeEvec0UsdXJYqtYaftpjXlKQ=;
        b=Vqt2YPyL2NBqudm7YLTYs7Zrd/HNHcvAc7pd+AN0VII19qwhipaHA2TGz4hZ8t6aID
         YAoGgfMci+B2+9k+f3WeC2tQJ2NbAN24bkOSmE71dYj5bWpY+PBgV/PRFgNtBWhNn65O
         vQjjbVvOv+DoL6D1lKeImX+gANQpUC6YB198C5W/xleXy9D8AalLBuxKou10+S6d7+bY
         Mxd6I/ThF3Oma+95BOBMyrwoUrk80Js+/PouA99OZf3pv7lSrDRexKR6Qf0pX1N2I5jr
         qbS9v3tWidq4EaxaRe7Avd1jbGzh0cJpEu5PyE1kvYo7+h4MOHBTNIqejwk98JdvEs3M
         vB8g==
X-Gm-Message-State: AJIora8VvW+srnjqt6sCNG0TXSYOdwwqiHd70CatsFJvzGA+D658hvdo
        PzL1PySwBF72DUXs+f4wI3QZmcHEo1u0EszW9pI=
X-Google-Smtp-Source: AGRyM1vKVV4Jh3BDTsp8khJvXrwVMMkPHL60CAmDojaQAsWq+jqbooDV5lRWoU7/80DsGhKslDm1mg==
X-Received: by 2002:a05:6a00:1693:b0:528:3c0:5825 with SMTP id k19-20020a056a00169300b0052803c05825mr1961725pfc.21.1658472371839;
        Thu, 21 Jul 2022 23:46:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i4-20020a170902c94400b0016d25402bb8sm2904685pla.25.2022.07.21.23.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 23:46:11 -0700 (PDT)
Message-ID: <62da47b3.1c69fb81.dad2a.50c2@mx.google.com>
Date:   Thu, 21 Jul 2022 23:46:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12-228-gec4d1360df1a
Subject: stable-rc/linux-5.18.y baseline: 173 runs,
 1 regressions (v5.18.12-228-gec4d1360df1a)
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

stable-rc/linux-5.18.y baseline: 173 runs, 1 regressions (v5.18.12-228-gec4=
d1360df1a)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.12-228-gec4d1360df1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.12-228-gec4d1360df1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec4d1360df1afd7b884f6c3a923f97307e898d12 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62da17d5a8ca94b4f3daf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2-228-gec4d1360df1a/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
2-228-gec4d1360df1a/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62da17d5a8ca94b4f3daf=
07b
        failing since 20 days (last pass: v5.18.8, first fail: v5.18.8-7-g2=
c9a64b3a872) =

 =20
