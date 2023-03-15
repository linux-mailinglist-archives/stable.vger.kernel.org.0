Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958626BAA13
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 08:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjCOHyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 03:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjCOHyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 03:54:21 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EC5144B7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:54:14 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q189so10276650pga.9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678866854;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pVs0bY4mR6gCQaA5k2YvBE+31GoS0Ee1+HQu3mWGFTQ=;
        b=kLqvjQtplowzcxjkSf+w4X4aWO6COZS3Na9z64ekaD08HTddHjHf2zG8iljLAglCe0
         bNE1aChnPtsOlkJVIP8IiYX0T1TgHbvYyRF6nEoyplmzNx6R2NbH1xoRe/5Abwk06+JJ
         HUJH1UEzyZOxoDdBhBOLE7e5tQMBcMzEkuuEvkabfDTc7HFtzqXU9KN8DQ/o5nvugtN1
         29gDo/aJAgvgRrewozIn+xf6EE3GV1pyvZdEa0g/QFkB8FPvMSmw+ensP34MR5I5E6MC
         m80ts3SM8nXvixT1IdXQMYPd6jUurSP0LVS9T9BNqIbeeuIZbhgaOE7vCWAeXG57XPm+
         5Tiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678866854;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pVs0bY4mR6gCQaA5k2YvBE+31GoS0Ee1+HQu3mWGFTQ=;
        b=Qr2xZdYs0jQp6mKB19173Oj2+jK5ZkzD3JJe9icGdobGhw8SqU4qB1iUJDI9EOgBjZ
         jp3nuhSRotPgpCYtQHrWXJVsXRBQfmSr8JP1jzKBvRTJ1ogiROhChj78plu7TXMv2x3V
         pVUCV+NrCnDjH4ZBge16J06lTZYtql+EhL9C2VOCAfG6sijKtWvxRRCjd7G8jP3od27I
         Ry8FMa6jiQnK1ByIy/4XqtIp6HLdcQjTfxU7AdU826k5k1XRxteyNuKC7AerHCyU9otM
         ekuELFBeZlQ1zrw7pCO6/xQaPcteVdbDNW4ZhKS9kecK2ZuVfnnsVqK/w/NY+b/1vH1v
         iwIw==
X-Gm-Message-State: AO0yUKW/aa1u6KcWsZdfFXV+JpYZ2KhFIn4L8G/1F9DFPRIeobuDEZ3R
        FubEtiuxcHft6NNZVEJj7XCCBCMYuAiQMmlamqVRWl70
X-Google-Smtp-Source: AK7set9k2jcb2IRqxTE8Y5h6Ct4mYRFuOK2GfsaW459ucdwXFKXHLwCqaeIxKhgPFuW0AwMuWabphQ==
X-Received: by 2002:a05:6a00:3021:b0:625:524b:9712 with SMTP id ay33-20020a056a00302100b00625524b9712mr5374114pfb.2.1678866854044;
        Wed, 15 Mar 2023 00:54:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 14-20020a63164e000000b00502e1c50af3sm2737210pgw.45.2023.03.15.00.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 00:54:13 -0700 (PDT)
Message-ID: <641179a5.630a0220.b5fc.6356@mx.google.com>
Date:   Wed, 15 Mar 2023 00:54:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-120-gb40b805eefb9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 175 runs,
 1 regressions (v5.15.101-120-gb40b805eefb9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 175 runs, 1 regressions (v5.15.101-120-gb40b=
805eefb9)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.101-120-gb40b805eefb9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.101-120-gb40b805eefb9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b40b805eefb9fb4372c396dda4c6fac57e157be6 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/641143f9362a355d468c864c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-120-gb40b805eefb9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-120-gb40b805eefb9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641143f9362a355d468c8655
        failing since 56 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-15T04:05:02.076690  <8>[    9.982923] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3411660_1.5.2.4.1>
    2023-03-15T04:05:02.186663  / # #
    2023-03-15T04:05:02.289886  export SHELL=3D/bin/sh
    2023-03-15T04:05:02.290732  #
    2023-03-15T04:05:02.392829  / # export SHELL=3D/bin/sh. /lava-3411660/e=
nvironment
    2023-03-15T04:05:02.393897  =

    2023-03-15T04:05:02.496316  / # . /lava-3411660/environment/lava-341166=
0/bin/lava-test-runner /lava-3411660/1
    2023-03-15T04:05:02.498053  =

    2023-03-15T04:05:02.502891  / # /lava-3411660/bin/lava-test-runner /lav=
a-3411660/1
    2023-03-15T04:05:02.598057  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
