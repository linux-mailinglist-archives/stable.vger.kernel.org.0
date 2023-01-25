Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989E267A95A
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 04:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjAYDo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 22:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjAYDoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 22:44:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806905BA4
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 19:44:53 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso3061382pju.0
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 19:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=l8UWO/qdyeWpCSCpv/THX0XCciEgwQhnub173Qv944c=;
        b=h1Fe6GUWz8O+LqCqCSoBvklHJHGH/IKfDiAINSnP1a/3oQDQLG7LtOY8rJaQ9XzDg1
         1pobOeiJsybbCQ1iKPBoDuVsN0H+3bDax9hQ5JzoFf6YR/yyuRFlUWxom/1zqlW93NZH
         LI9apghx6FtSdOSltJa2sc5o0sgarCB3rt7ypr3E5p9MX0XLDCVD6yj1FKHtqSUt6U9U
         ShslFeqsKP9pIdEz2qohbFEB3BPvBCAscGBN5fX0ZZPwCozTDWHrO5clNrfcIM3AYzYS
         u3mhELXssyhPf2742+MTdggTrEdejJDQNNyujBQmaX+JdmdiJ28fYwLGL6WhUDCRjyCK
         IajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l8UWO/qdyeWpCSCpv/THX0XCciEgwQhnub173Qv944c=;
        b=2YfIcQrsHYuaHad51LZcvKdtfUpjnvFe0iNyB7osDG04JMdpdaESCHy3qhn8NGWeTD
         xOMDusGDCAEu9pBVLOI1w2M4gp62LoiErDaHUHfikByURGRtBl9tWbkPriJ/6+zkKUw8
         pXPRDLrPb5MQHkZetgQ4/k+pJpuSEayqeJ5joPkbIe1c5v4Bp9sIknSu2W4scJ2yF9iz
         xg/xhq/bf1z/6PZzhc0sb6mECG51D0dmgMTOS2654ITCQBymMfUReoGGmcKG7cAkoqHm
         0cPSGuOPFXyyDsxcW4NwC4yNIr1FZsEFb+KcKouUqRx6Mv9K07dx592MngBK6/BbJmUr
         7HcQ==
X-Gm-Message-State: AO0yUKWqRtq5NSjcLMjS7WWUIBpGsA+I1xEsznosRBanMdlThTo1m/ZP
        m9qyvsouQlhla+KFnJ6d5X8RZFuwbTuWhe18
X-Google-Smtp-Source: AK7set8Tfbsd/fY9aToe0cjzcHbTyWK4Kt4SsF6SDO9wWzzyA69PJSN+Z40N5wN8sKZpv9krpJ74Ug==
X-Received: by 2002:a17:902:d48e:b0:196:cf4:b4d3 with SMTP id c14-20020a170902d48e00b001960cf4b4d3mr7590134plg.48.1674618292831;
        Tue, 24 Jan 2023 19:44:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g18-20020a170902869200b001892af9472esm2410112plo.261.2023.01.24.19.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 19:44:52 -0800 (PST)
Message-ID: <63d0a5b4.170a0220.abb8f.502d@mx.google.com>
Date:   Tue, 24 Jan 2023 19:44:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-342-gce672ebc0240
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 141 runs,
 1 regressions (v5.15.87-342-gce672ebc0240)
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

stable-rc/queue/5.15 baseline: 141 runs, 1 regressions (v5.15.87-342-gce672=
ebc0240)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-342-gce672ebc0240/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-342-gce672ebc0240
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce672ebc02409df261276e135dc083a99979ef78 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63d076c6159acfdec7915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
342-gce672ebc0240/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
342-gce672ebc0240/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d076c6159acfdec7915ec1
        failing since 7 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-25T00:24:20.248442  <8>[   10.001775] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3205927_1.5.2.4.1>
    2023-01-25T00:24:20.357346  / # #
    2023-01-25T00:24:20.459174  export SHELL=3D/bin/sh
    2023-01-25T00:24:20.459893  #
    2023-01-25T00:24:20.560994  / # export SHELL=3D/bin/sh. /lava-3205927/e=
nvironment
    2023-01-25T00:24:20.561493  =

    2023-01-25T00:24:20.662939  / # . /lava-3205927/environment/lava-320592=
7/bin/lava-test-runner /lava-3205927/1
    2023-01-25T00:24:20.663606  =

    2023-01-25T00:24:20.668607  / # /lava-3205927/bin/lava-test-runner /lav=
a-3205927/1
    2023-01-25T00:24:20.754680  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
