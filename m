Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF26C09AC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 05:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCTEbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 00:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCTEbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 00:31:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA7915CAC
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 21:31:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u5so11176543plq.7
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 21:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679286674;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qG4GyHhvXfKn6mL7EcfVFLHYoEl45V1ey0V+w0eX8sw=;
        b=hKpsvmQTGiiMrAmz94i+96jzL1DjoekZRuu/bWK6XNsu/xKqv4d7EnIQOefIyuElS7
         FymCftpN5f1N+9jXK8PVwnnnjzsmnuXqUO2gFYPvEqn328HtCENhc8dRp3X3FyEXEPKI
         c7y7DeKTDtqaUm9646gQezBsDQXVBeW9eqdbfUGBrLavS9jEFlwpex26n/agRYns5H3P
         i/OksbW2ZKGRlK9Aq5JbayYOaawb2CyAuoYomewY7pcFhrSz3d5VYMTCmfhBMFp4djbu
         6nrbQ4u6WuBL3Cf3HPDtFbr5mDk6SNLvREV7yCEzvAKsZnPqdzDd/U6XT3oKUGVANBlf
         f0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679286674;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qG4GyHhvXfKn6mL7EcfVFLHYoEl45V1ey0V+w0eX8sw=;
        b=4JN+j3/8nefl0jrIr+/a2pWLtGWmRMFPUviHnMa94swFUQP7el9NZz/f0Y5dSHuGOh
         ZIvzrXtjJGcLq9SjX/vKxRZHRcXITpjkTt1lGwRnFQbMqheA8+Yua0ayIhtMvEdbQdXo
         Z3LWEupMROQb+2Ll6lJb1VTgNztmQWOOcs4uolsbe9ViDqtRS9P2SsBLZNEV0EHGpVyQ
         i4OhSlLpu19tieqrkf+d3B2/Tedu2WIe1TQKEq3jLpWSf54lYd5c5hjZ56+1s7CNJSq6
         Jvy0//janjHcjNaBvbDUhk21hknCn2XeR/Hm+4Pno7BegTYhHgcmyW2IhNN6fp7zImIE
         CLsA==
X-Gm-Message-State: AO0yUKXHyui+yuoZp5fRA2dr/ySkX9E7OObPOXRurms82xF/LPNiCKdZ
        wG7xDfhAC4QqK6I5N1IFe/GTvWQ9NlXNW7YL1wU=
X-Google-Smtp-Source: AK7set9RdEy8SW343Z9S1uO4wTG1M30wxDA+KPVCfcoImTjxqWMRNU1qFBoVbAQQiT461TtMjj8Hsg==
X-Received: by 2002:a17:902:ce92:b0:19a:9dab:3438 with SMTP id f18-20020a170902ce9200b0019a9dab3438mr11619377plg.2.1679286674665;
        Sun, 19 Mar 2023 21:31:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902c1cd00b0019aa8149cc9sm5526777plc.35.2023.03.19.21.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 21:31:14 -0700 (PDT)
Message-ID: <6417e192.170a0220.a4152.955d@mx.google.com>
Date:   Sun, 19 Mar 2023 21:31:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.103-72-ga6fd6a418659
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 170 runs,
 1 regressions (v5.15.103-72-ga6fd6a418659)
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

stable-rc/queue/5.15 baseline: 170 runs, 1 regressions (v5.15.103-72-ga6fd6=
a418659)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.103-72-ga6fd6a418659/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.103-72-ga6fd6a418659
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6fd6a41865928f824c6c70cc89d3d5d858e6795 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6417ad37ef351345fc8c875a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-72-ga6fd6a418659/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-72-ga6fd6a418659/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6417ad37ef351345fc8c8763
        failing since 61 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-20T00:47:40.052602  <8>[   10.044572] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3426880_1.5.2.4.1>
    2023-03-20T00:47:40.159239  / # #
    2023-03-20T00:47:40.260635  export SHELL=3D/bin/sh
    2023-03-20T00:47:40.261010  #
    2023-03-20T00:47:40.362162  / # export SHELL=3D/bin/sh. /lava-3426880/e=
nvironment
    2023-03-20T00:47:40.362531  =

    2023-03-20T00:47:40.463782  / # . /lava-3426880/environment/lava-342688=
0/bin/lava-test-runner /lava-3426880/1
    2023-03-20T00:47:40.464344  =

    2023-03-20T00:47:40.469500  / # /lava-3426880/bin/lava-test-runner /lav=
a-3426880/1
    2023-03-20T00:47:40.559589  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
