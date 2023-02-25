Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542D26A2A96
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 16:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBYP50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 10:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBYP50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 10:57:26 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB10E113DE
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 07:57:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id i10so2495994plr.9
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 07:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bj7BeZYpictzSxKiZQ3LlY1fWrGB9u7V21RNlLt79uE=;
        b=pubhNv4c4SWEwJTI9dtm4pOhPx2+D5HnuwHlR0esHoYdJjbtU6pePUNp2jSyK2TA1/
         oYHchz03xU1Fq2bW19E34K0dTbF+7+MxweBactIjHwvMnOGHKuD8YrUFpgJog5BBDEUk
         nL8Njj4ufYWK/HkkgcJ8Yj9KyR8addLqjsk4WTykijT63n9kr4BlkL5FdYEGkYfOL5xK
         AElqthD1btkd+jydgYiZ1CfPxow5Ht6kSBeqxEe5VlAXsrz30fbb8Vd43/LUH6XOj2cr
         IkT49vy/bKwYIitHy0dOwFYynW0wqbSyfx3Fz8UpJ4B87vkUhg+6d+6gqD+6e2JxzN/o
         sKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bj7BeZYpictzSxKiZQ3LlY1fWrGB9u7V21RNlLt79uE=;
        b=fBBfFy3FJc0KV1OjsmyEjVotbzO+l7hUrjZlD2UMmXr2b3d5wY7FULl1qBsIW0v8kS
         QwFXEFF3P6IofIw/X/FEa/Dls3uVvYeE2liOPqhG5rjsUcBKS2hLNunKkufiJ5bvbAq2
         9JFckyhuXigYth9l+SfFHYBoY9KwbsNlTKINMLFp2uC4KRYAtW1lILiHZnz0DhmKQH/K
         oZVTUoYWFurGTd0K1W1RZpNTqsIQtG20m2V7g+dtxpq2fbPKwqxMvHP3BIEJX30wnagW
         CQUFMHpbHK5ege6Mmd0PnaCK8n+ck0IxVOGikaJFmHqDsUridMx1/itTbh5lO2o01s6n
         6Tyg==
X-Gm-Message-State: AO0yUKXcxs6czq0rGEivN5RT7XmjvA1XzX6izlhwbm6LYcjVW+PVixqI
        RhYtwR7ugDaKV996BI78whsXhlghv6l+hJ+z9bqflA==
X-Google-Smtp-Source: AK7set/k+TSna3hJ7X6pjqm3mUFWgpxfeXtHkelyfrlAB2ZprZ15/xRCxFKnq1tdG9G/cLqHcCMnfw==
X-Received: by 2002:a17:902:c406:b0:19a:990c:9c0 with SMTP id k6-20020a170902c40600b0019a990c09c0mr24981806plk.3.1677340644244;
        Sat, 25 Feb 2023 07:57:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bc7-20020a170902930700b0019aaccb665bsm1424352plb.245.2023.02.25.07.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 07:57:23 -0800 (PST)
Message-ID: <63fa2fe3.170a0220.54afd.1ff1@mx.google.com>
Date:   Sat, 25 Feb 2023 07:57:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.13-47-g106bc513b009
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 132 runs,
 1 regressions (v6.1.13-47-g106bc513b009)
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

stable-rc/queue/6.1 baseline: 132 runs, 1 regressions (v6.1.13-47-g106bc513=
b009)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.13-47-g106bc513b009/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.13-47-g106bc513b009
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      106bc513b0098ed4a7332be87009b7a022c71675 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63f9fae4a837da578e8c86c7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.13-47=
-g106bc513b009/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.13-47=
-g106bc513b009/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fae4a837da578e8c86d0
        new failure (last pass: v6.1.13-47-ge942f47f1a6d)

    2023-02-25T12:10:51.232515  + set +x
    2023-02-25T12:10:51.236230  <8>[   17.053522] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 74347_1.5.2.4.1>
    2023-02-25T12:10:51.350887  / # #
    2023-02-25T12:10:51.453028  export SHELL=3D/bin/sh
    2023-02-25T12:10:51.453626  #
    2023-02-25T12:10:51.555410  / # export SHELL=3D/bin/sh. /lava-74347/env=
ironment
    2023-02-25T12:10:51.555948  =

    2023-02-25T12:10:51.657672  / # . /lava-74347/environment/lava-74347/bi=
n/lava-test-runner /lava-74347/1
    2023-02-25T12:10:51.658470  =

    2023-02-25T12:10:51.664121  / # /lava-74347/bin/lava-test-runner /lava-=
74347/1 =

    ... (14 line(s) more)  =

 =20
