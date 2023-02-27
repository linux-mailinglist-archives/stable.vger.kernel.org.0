Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869AB6A4C52
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 21:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjB0UiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 15:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjB0UiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 15:38:20 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E2218B0E
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 12:38:17 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id ce7so4357062pfb.9
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 12:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677530297;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CCl/BkAJl1F9DnGgbWDMbYgoqYgGz2GBS25SwHLrqsY=;
        b=iWMeI49zYUIHWvB60fc09do+4EzK6fr3zqz7RndWVSZzR/1l4z6bMNjmZSBWM/Q+Wv
         hKt4K3pxrljcTEy75TpHp4Y6icQoPdyGjKD5FmxqohEqNfXRZwNpq02gZuy1h6c908Wi
         2mq0aLJkdc5BNyKjl1pRznCSJp6pS9+Kj5kLZvrqLPE0ZRm4hebp+TLhClWd/GTWfDZc
         Lje6nvFRMiurXCx8lymOOOlVtPLITvMp35gw9taq/14z/YfGYN+5a6f3kjfN4C9q8t8t
         pah4cyn+cmmLBX6FdYEdebufho6LcPJyKiOkt0cj9Yg3F+Xgac/cMULt//5z87M+YSNr
         jK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677530297;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CCl/BkAJl1F9DnGgbWDMbYgoqYgGz2GBS25SwHLrqsY=;
        b=IRsWl1eG9U+SLHm5dQXiH+h/JeCBYkTeBSYQ0hf3llHgjhzxJ13BLtMgUwVeWyR5EB
         f9iARGUPBROBR84hg5rqfBptYtpcm7fpo7v9dqdNfrFQENigk+U6JNDoFG6Qlmx3YZrJ
         K/tB4nyU7x3DGBv5hc7TufbbjbsuWJ2nv3LUUqxO6+oA7yh7oL4vGGoE18+RSG2DvQP2
         VH6lj91tTP4GchplCEqoaZ9lzeZ9AwTraKBngpq5V+cRF5SLOx2uV2qeJ0HYHQRpLszG
         geMdIZEcMNRrNdfbMxxtX0MyCAXHLL91BI6YBDXfWBno3vhMSc9yCXlickNlxPs8OKLJ
         bvqw==
X-Gm-Message-State: AO0yUKXwYrEPBFpbcZDq2U3goD1WUVxN06T2R+3TjtYmtNcur3EQlgvj
        fsC+soUivuPiOskCMfLeAoEtliB8+CfQIoxF7NAWxw==
X-Google-Smtp-Source: AK7set9CyZkETKRUZppPDnGsQTOcuIMmplfoTtecYfJK16F3mlhfaLARopmRBM5zDroNl6/rwUo+BQ==
X-Received: by 2002:a62:8494:0:b0:5a9:bf42:fcc5 with SMTP id k142-20020a628494000000b005a9bf42fcc5mr405020pfd.0.1677530296866;
        Mon, 27 Feb 2023 12:38:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w16-20020aa78590000000b005a8cc32b23csm4619867pfn.20.2023.02.27.12.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 12:38:16 -0800 (PST)
Message-ID: <63fd14b8.a70a0220.4b602.7aeb@mx.google.com>
Date:   Mon, 27 Feb 2023 12:38:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.14-25-g50c28d473e45
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 153 runs,
 1 regressions (v6.1.14-25-g50c28d473e45)
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

stable-rc/queue/6.1 baseline: 153 runs, 1 regressions (v6.1.14-25-g50c28d47=
3e45)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.14-25-g50c28d473e45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.14-25-g50c28d473e45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      50c28d473e459a9bfaf90a6ebb21809de3ae2d03 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63fcde279b9646cd438c8665

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-25=
-g50c28d473e45/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-25=
-g50c28d473e45/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63fcde279b9646cd438c866e
        failing since 2 days (last pass: v6.1.13-47-ge942f47f1a6d, first fa=
il: v6.1.13-47-g106bc513b009)

    2023-02-27T16:45:02.903349  + set +x
    2023-02-27T16:45:02.907209  <8>[   17.294214] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 80858_1.5.2.4.1>
    2023-02-27T16:45:03.020101  / # #
    2023-02-27T16:45:03.123044  export SHELL=3D/bin/sh
    2023-02-27T16:45:03.123776  #
    2023-02-27T16:45:03.226065  / # export SHELL=3D/bin/sh. /lava-80858/env=
ironment
    2023-02-27T16:45:03.226809  =

    2023-02-27T16:45:03.329150  / # . /lava-80858/environment/lava-80858/bi=
n/lava-test-runner /lava-80858/1
    2023-02-27T16:45:03.330299  =

    2023-02-27T16:45:03.336881  / # /lava-80858/bin/lava-test-runner /lava-=
80858/1 =

    ... (14 line(s) more)  =

 =20
