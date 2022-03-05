Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863D84CE66E
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 19:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiCESmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 13:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiCESmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 13:42:02 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362CD60DD
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 10:41:12 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id s8so6259738pfk.12
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 10:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cmbf3FF20lXrdt9fIpQGrh7uCh+efiec+JFaHtj3+xA=;
        b=7avGh5zXdH9ux4MnmfGi+xlQxlhA2OkpI22gKn1c09m01vtP41sPLluYj/xk8wqZOR
         JTY1cZVVuqAYX15NzE2OI4LOtOBvND/1TmAm6iICAZkAnwnBFRhdUNQBQ9PJsfCDM9vl
         A2Bd8nh1Rk5XiPa4ahwEqaM2i02/8EXrZWCD5AxpLuqHaxpMCEF/iph5BVWKFioLoYuo
         xpRPDqwOUv97+MSockYTcSCvhRubxiZAznmHWkD1CZtzVLLAot3dPRsGi7WDn7dabZQ1
         R1PoGvghCwYf04Xd0hrqCqv8psLmWDSGefPbcUgh6DGxgGmt7D/UXbvI7z9Z5tBwpcVa
         OdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cmbf3FF20lXrdt9fIpQGrh7uCh+efiec+JFaHtj3+xA=;
        b=HCBq41Oxy69d8crrC3qFA4SVz7LfFn+nNQiJiO7WuUpI0KwchioWsy3yqSoIsRwaLS
         XlQSamyaQNu2Z9f/kvMdnirKjnY5FK/doU352qTJr2LUaOlK/xvNFjgtHt5ak6EUpGsj
         /7taju3S4NvSiOnEfb4e3sNraqk6AdCYh/yBb4CZidEpOUT5pv8Q0hHg6B/MO3h0/JNJ
         Gl9HTrj4EaONnIPDSirSx3LSFFWC4drHRU/OKb562ciqaTc0LCOGjdZEi02vB+RjEnL8
         LTWWpLAYOWzKm+nIm9bxodjnE8zewWtKnqB7sgjSYrlCJBnPG7ooSJutBZW3ALqVe9DZ
         8JMA==
X-Gm-Message-State: AOAM533uxiuAmQPsPz3Fc3pnkSqr0yQebuV+SI9PDhdpe4d1cYyze1A+
        KJcq1heCfS4uj8gXGedj/Fiz6azakp4eVrqsg7w=
X-Google-Smtp-Source: ABdhPJxv8AT5npmxzd4itfJjm1qCM2pMd9DygF0678CMjon9RMHWsFQ8Achn0umAdhJakTkkAzggYw==
X-Received: by 2002:a63:81c1:0:b0:37f:fa5a:7383 with SMTP id t184-20020a6381c1000000b0037ffa5a7383mr2774532pgd.596.1646505671593;
        Sat, 05 Mar 2022 10:41:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k17-20020a056a00135100b004f3a9a477d0sm10438181pfu.110.2022.03.05.10.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 10:41:11 -0800 (PST)
Message-ID: <6223aec7.1c69fb81.66e1c.a987@mx.google.com>
Date:   Sat, 05 Mar 2022 10:41:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.26-172-g796cb97bb4fd
Subject: stable-rc/queue/5.15 baseline: 22 runs,
 1 regressions (v5.15.26-172-g796cb97bb4fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 22 runs, 1 regressions (v5.15.26-172-g796cb9=
7bb4fd)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.26-172-g796cb97bb4fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.26-172-g796cb97bb4fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      796cb97bb4fdd91e5e8f67646e454d9adad1965b =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62237b323f5f22644ac6297a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.26-=
172-g796cb97bb4fd/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.26-=
172-g796cb97bb4fd/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62237b323f5f22644ac62=
97b
        new failure (last pass: v5.15.26-136-g6aaabed66d45) =

 =20
