Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF8466ABD3
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 14:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjANN6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 08:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjANN6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 08:58:52 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE077ED6
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 05:58:51 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id cx21-20020a17090afd9500b00228f2ecc6dbso3496704pjb.0
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 05:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LtqJ6DJ/YxaVq+Zg0iIniL32Cj7R9NnG5iXGIrsx/LA=;
        b=MAYMI9vsK4AwKHoUvEhR0GMe+NE6qeYvhoHVrJhWE/NnBKbRxCmn+/rZVdbpFeTEiY
         LwCfqW0wQPJIpG3x+H6rnnUb/Zfm4AJIAtNCNsOgmRteCrX0MEHWHFJAYz14YXygV4SU
         dEP6Si2DoXTnmncqaM3LYRcQZ6V9hyY441a39qv9+rZ3MyrV2bqHYwuo+53WhO16ZvuQ
         cD0Oe1tJ1smyOKR09nuN0zz+EhbKuheq93tSQJfC2392QT4HaZ4LPO1afKp1sUCw5I8K
         ELYL7v2wwNe4647+o+blEZn5fU0sOuHZutVPHVj0IXMu5VW1Hx2pjNPk9tujuVktoi0w
         UbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LtqJ6DJ/YxaVq+Zg0iIniL32Cj7R9NnG5iXGIrsx/LA=;
        b=w8KaYFo1L1sXo0noSbRWt8sC1xvOGY+cE+cxVDvPatM9tVO2SvSKUGu+Sd02tYQcPH
         4oaX4ZtJpi50AW0fnfopk4uDjMB5EmvOUkGOLBIkMtzKRIXCa1HItX3We0D8Mta6rM+K
         AhwasPMPIWVieRA6Fv6JDA3Rvw07f3bHoLvZZO1LNfZYS0DnsGNNSC4HQpfiEHcqEMRh
         3VfNlxGx5pOhwubsMKLSHhN96XsxscXXILray6a+/GZu5oRzr36JHcd7SFeLuqLijJPt
         zHWJK8inTaTeuetUTZb6829Nbrg5rclp5pmqQfBTWIKIiEq6qN6ExoQ0LuOVvMyF7edX
         FGyQ==
X-Gm-Message-State: AFqh2koR51eTgF5jcRJfvzmn96MwQZUO4umfNf95HqYDUBwP5pm2hkh1
        6EGPSiNGsKiQei/OrqsxjoGVt0jyXAi7HR4Nr4Foow==
X-Google-Smtp-Source: AMrXdXuq6hvEkEZrtVvvhKYnFBY25XgA0xJrhX5P6qPJ1kAQidKSn78UVxoJK9//giHSQ841wp4WgA==
X-Received: by 2002:a17:903:1d0:b0:192:4f32:3ba7 with SMTP id e16-20020a17090301d000b001924f323ba7mr105592018plh.18.1673704730546;
        Sat, 14 Jan 2023 05:58:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2-20020a170903228200b001867fdec154sm16025792plh.224.2023.01.14.05.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 05:58:50 -0800 (PST)
Message-ID: <63c2b51a.170a0220.3af4e.9b21@mx.google.com>
Date:   Sat, 14 Jan 2023 05:58:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.163
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 109 runs, 2 regressions (v5.10.163)
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

stable/linux-5.10.y baseline: 109 runs, 2 regressions (v5.10.163)

Regressions Summary
-------------------

platform               | arch | lab        | compiler | defconfig          =
| regressions
-----------------------+------+------------+----------+--------------------=
+------------
sun8i-a83t-bananapi-m3 | arm  | lab-clabbe | gcc-10   | multi_v7_defconfig =
| 1          =

sun8i-a83t-bananapi-m3 | arm  | lab-clabbe | gcc-10   | sunxi_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.163/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.163
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      19ff2d645f7a9626146b6b3ba698488d60aa04de =



Test Regressions
---------------- =



platform               | arch | lab        | compiler | defconfig          =
| regressions
-----------------------+------+------------+----------+--------------------=
+------------
sun8i-a83t-bananapi-m3 | arm  | lab-clabbe | gcc-10   | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/63c283f21b043852a81d39d0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.163/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.163/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c283f21b043852a81d39d3
        failing since 9 days (last pass: v5.10.143, first fail: v5.10.162)

    2023-01-14T10:28:46.385616  / # #
    2023-01-14T10:28:46.487959  export SHELL=3D/bin/sh
    2023-01-14T10:28:46.488553  [   17.582609] usb-storage 1-1.1:1.0: USB M=
ass Storage device detected
    2023-01-14T10:28:46.488984  [   17.592074] scsi host0: usb-storage 1-1.=
1:1.0
    2023-01-14T10:28:46.489314  [   17.607075] usbcore: registered new inte=
rface driver uas
    2023-01-14T10:28:46.489606  #
    2023-01-14T10:28:46.591080  / # export SHELL=3D/bin/sh. /lava-379164/en=
vironment
    2023-01-14T10:28:46.591749  =

    2023-01-14T10:28:46.693360  / # . /lava-379164/environment/lava-379164/=
bin/lava-test-runner /lava-379164/1
    2023-01-14T10:28:46.694426   =

    ... (20 line(s) more)  =

 =



platform               | arch | lab        | compiler | defconfig          =
| regressions
-----------------------+------+------------+----------+--------------------=
+------------
sun8i-a83t-bananapi-m3 | arm  | lab-clabbe | gcc-10   | sunxi_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/63c27c366e961c78461d39ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.163/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.163/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c27c366e961c78461d39ef
        failing since 9 days (last pass: v5.10.143, first fail: v5.10.162)

    2023-01-14T09:55:51.795753  [   13.108412] <LAVA_SIGNAL_ENDRUN 0_dmesg =
379139_1.5.2.4.1>
    2023-01-14T09:55:51.902138  / # #
    2023-01-14T09:55:52.004710  export SHELL=3D/bin/sh
    2023-01-14T09:55:52.005741  #
    2023-01-14T09:55:52.107703  / # export SHELL=3D/bin/sh. /lava-379139/en=
vironment
    2023-01-14T09:55:52.108311  =

    2023-01-14T09:55:52.210424  / # . /lava-379139/environment/lava-379139/=
bin/lava-test-runner /lava-379139/1
    2023-01-14T09:55:52.211303  =

    2023-01-14T09:55:52.226508  / # /lava-379139/bin/lava-test-runner /lava=
-379139/1
    2023-01-14T09:55:52.328785  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
