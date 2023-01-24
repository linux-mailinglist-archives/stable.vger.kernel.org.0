Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99EC679ACB
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbjAXN6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjAXN6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:58:31 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671EF47407
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 05:58:09 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j5so1320902pjn.5
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 05:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tqtfCebl16uLuy+ZabE4YLdgydneqVIyewKJe49+YZc=;
        b=iFjbiP0wzxPMnpD1nM57cLtX+U+UhVlkfjzaQ6tCek7Zi5pGMIin4XSVa1THI8GRyY
         OQVbZXbJEUA/eB+vuSvupbEXm9c+XvyW6HDnu6SPNaQ4tCkZi/46fg0AWAEPeS5UnCZL
         9q14M6GwUT3cTmC8s3rmbkNiA6fXXcfpy3J6cKMt0BGvRPJdab5Fbcgti1Udc+9xBimg
         AmoW8Eg67p8f2Gf7SRPZxMMhGCMOoncBIPPqZ1IOU+N6rOdNDJ8QoJ2L4WXwPj2pXGN9
         d69pYKr/XvpwMiu3uJ1PHVAs/QGAz7DobNjUAK3lNdOUEH2NVwg+SclLaY39ZhuTkx+v
         olOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tqtfCebl16uLuy+ZabE4YLdgydneqVIyewKJe49+YZc=;
        b=SuKzwgTdnTQIGtxV01E5+MjXPmt4CDQxaA6Eu/h67WrU6AYf2imq99Hpu0jgdLJHBu
         9Tg+4Vm6s7dw9GuUBJ6oFsO0HE1SW0agJDZq20mZgDtvkYBAAar+8d3zVqUzbqP5wbPa
         1uMMSV89hP3JUb5Vp/DAxPU7uY4a4JaFHYdbo94aHxyaexuI2fa1V39kUVCPFhTifGIs
         +7An6SIqDMMNyP2qHnKtFuQgv3R8/dbyJAUiTEt7gR3V98ysuk8La8u7ziJj9VBIjGoC
         k7Gveo/6uUF3p4udDfRi2HOGYZJxUyQyOD1Foat/I+gW7dCIhh4/t1tSc1tAQDaK5pKP
         okQw==
X-Gm-Message-State: AFqh2kp/aQwK8pSGhJOMEAS0PLx82Ju8z+YJqNsHYxyHRygcqTVC2n7r
        60jdD7bdQYVQx/+ehSQCXMmnzB2OK1u5ynFRhEg=
X-Google-Smtp-Source: AMrXdXuas5lSBSqGglDQ5YR6nuIKa45d3igUfM9xN8xCx5+y+U3SeJ7YMajJbNIrPQsgyTEj7tycAQ==
X-Received: by 2002:a17:902:c409:b0:194:a854:6274 with SMTP id k9-20020a170902c40900b00194a8546274mr34860809plk.60.1674568682813;
        Tue, 24 Jan 2023 05:58:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902d2c100b001948ae7501asm1662028plc.298.2023.01.24.05.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 05:58:02 -0800 (PST)
Message-ID: <63cfe3ea.170a0220.914f6.2d6e@mx.google.com>
Date:   Tue, 24 Jan 2023 05:58:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.162-950-g7728aa131bf4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 1 regressions (v5.10.162-950-g7728aa131bf4)
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

stable-rc/queue/5.10 baseline: 171 runs, 1 regressions (v5.10.162-950-g7728=
aa131bf4)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.162-950-g7728aa131bf4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.162-950-g7728aa131bf4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7728aa131bf40b603a834a363ad7e0338ddb132b =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63cfad48948dfd6f15915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-950-g7728aa131bf4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-950-g7728aa131bf4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfad48948dfd6f15915ec1
        failing since 6 days (last pass: v5.10.159-16-gabc55ff4a6e4, first =
fail: v5.10.162-851-g33a0798ae8e3)

    2023-01-24T10:04:32.139974  <8>[   11.098856] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3197779_1.5.2.4.1>
    2023-01-24T10:04:32.249599  / # #
    2023-01-24T10:04:32.352967  export SHELL=3D/bin/sh
    2023-01-24T10:04:32.353949  #
    2023-01-24T10:04:32.354471  / # export SHELL=3D/bin/sh<3>[   11.290363]=
 Bluetooth: hci0: command 0x0c03 tx timeout
    2023-01-24T10:04:32.456637  . /lava-3197779/environment
    2023-01-24T10:04:32.457643  =

    2023-01-24T10:04:32.559951  / # . /lava-3197779/environment/lava-319777=
9/bin/lava-test-runner /lava-3197779/1
    2023-01-24T10:04:32.561462  =

    2023-01-24T10:04:32.566159  / # /lava-3197779/bin/lava-test-runner /lav=
a-3197779/1 =

    ... (12 line(s) more)  =

 =20
