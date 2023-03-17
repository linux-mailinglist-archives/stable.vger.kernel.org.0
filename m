Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340D46BED5A
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 16:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCQPyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 11:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjCQPyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 11:54:24 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7059B7181
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 08:54:22 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id k15so2398410pgt.10
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 08:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679068462;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mf1bvvQQ0zsSovPMTia/dqBLABtx2pootkXe8n0Zm5E=;
        b=UYp6bfrrVTDgal5AN/U27h/nvsfxHHQz+SE04QbP/vcZViTb+lzRuDVRHrUiwXmOtG
         rb4PQ8sJMKWWAUIu7F8WcyvIVX/CeSa2nFFgRZWP3sCF6aOx0bsJVOvGh629uwWjC6Lb
         8UewClKLgpIZu4gVY+4cBnceL7hFvYGQndz1cUYrLvJOAkAFfn4oVzcksDaV3wiOeFVh
         iG1z7B0LT9EOlZN+KJIhpKxYBtTmEK83AVBjODYin4QQMnlwAOt2Sog1c+KSecwmgJRW
         iK8ZNto+5bPE6IAUQGNHEG7i4nJChNV84KPOj74WTyE4u2jgo7XGWN2/F2mNk5kZ78vy
         imMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068462;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mf1bvvQQ0zsSovPMTia/dqBLABtx2pootkXe8n0Zm5E=;
        b=ubM3GQ65FescYp5iwXE5RaRezliHcRIIKMPF/c7764asS0/YrXKvbRJgbroyacR/E5
         ikvXlafWCSu8gir2BJ5cwl+x7+/8GMI4w0z/yXncq+LjuZ3KUKTVWIjZXIkU9BYquMJD
         uluCaPJwVtG5cFL+MCnoCoRT0DHNBS/RvQZMZpsbEOCV9QkQcPN5fkgk4ATjfNfdh/u2
         3Tns0Sj+ZMAdCm4w6fY8Jlf7IPWW+aRyyzMaCfADsgVzxF0SVpA6Hjl1zOPCClUkfrWy
         Cd+rY5cTHScgD3fJuPnmE8NKA/w19E6adntmnHwWhBy6xkovfj7ZacH8GXOwSyXa0DcS
         D4Vw==
X-Gm-Message-State: AO0yUKV4P5OyhAC464xkMMtiiuOiGhRjl3Tpyr3u7NkcmuEoTSySVOwO
        xreFNWIs4DmiGXXCB1MjUGO+v56uL6VUtTMWJ46+9Q==
X-Google-Smtp-Source: AK7set8TJLd9NEDSZ+aldyNi2NewPLkK3r+rDmCO64L2lafnwHnAkaBw2jYE4Zi1b/36KOycAfxl/A==
X-Received: by 2002:a62:7946:0:b0:625:2636:9cd2 with SMTP id u67-20020a627946000000b0062526369cd2mr8487037pfc.18.1679068462255;
        Fri, 17 Mar 2023 08:54:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v6-20020aa78506000000b006251e1fdd1fsm1702483pfn.200.2023.03.17.08.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 08:54:21 -0700 (PDT)
Message-ID: <64148d2d.a70a0220.158b0.32e0@mx.google.com>
Date:   Fri, 17 Mar 2023 08:54:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.102-136-gf9d511e739be6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 187 runs,
 1 regressions (v5.15.102-136-gf9d511e739be6)
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

stable-rc/queue/5.15 baseline: 187 runs, 1 regressions (v5.15.102-136-gf9d5=
11e739be6)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.102-136-gf9d511e739be6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.102-136-gf9d511e739be6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9d511e739be6738ff9a463b6cf97e4b8419e078 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/64145bf364abdcf17c8c86a4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.102=
-136-gf9d511e739be6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.102=
-136-gf9d511e739be6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64145bf364abdcf17c8c86ad
        failing since 59 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-17T12:24:04.143997  <8>[   10.084243] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3420415_1.5.2.4.1>
    2023-03-17T12:24:04.255061  / # #
    2023-03-17T12:24:04.358461  export SHELL=3D/bin/sh
    2023-03-17T12:24:04.359741  #<3>[   10.193563] Bluetooth: hci0: command=
 0x0c03 tx timeout
    2023-03-17T12:24:04.360397  =

    2023-03-17T12:24:04.462573  / # export SHELL=3D/bin/sh. /lava-3420415/e=
nvironment
    2023-03-17T12:24:04.463443  =

    2023-03-17T12:24:04.565376  / # . /lava-3420415/environment/lava-342041=
5/bin/lava-test-runner /lava-3420415/1
    2023-03-17T12:24:04.567483  =

    2023-03-17T12:24:04.573174  / # /lava-3420415/bin/lava-test-runner /lav=
a-3420415/1 =

    ... (12 line(s) more)  =

 =20
