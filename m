Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257656AA734
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 02:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCDBR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 20:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCDBR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 20:17:29 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82CE13503
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 17:16:53 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso7942743pjb.2
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 17:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677892583;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ISZsny4GJfgpPYzl8TscvtNvvVTbXG3Yv3F1bl3CJwg=;
        b=R1irZBNw7W5txzvpaTwbtGyK+Kdj2XwtidwMsaRsuwJteoNMN1BzTekg80LyDYD2F7
         gzejb8nqwop3thUNVGlNHsMjHOsU8T4YyLJOMQgggjUEnw+j1qR7Now1fj6LH0WdDnq4
         heZGepr06t/83UkjchIsRZuBZ0P4YtAK6643yARhhl8900uyiMVkxtNY1ldA50gq94tN
         ttN7YH7PH+QxSJPoA9trpA8I8l4w/qwykZeT3mdUkV4BwgTjybRJ6RNpC2NHhX5y2n9P
         iRYjWU5y4XypVNltWv5+6jvVhSVEyUtltmw2BjIUkvrZJd1QVSdUnznnh699tO6eiDtF
         QDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677892583;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ISZsny4GJfgpPYzl8TscvtNvvVTbXG3Yv3F1bl3CJwg=;
        b=5MJtjNz78j/cwAtpJLV+xB9Sed9K4N9IL03998vHBYhIboG6EXAy6PabxQnX5zzjm4
         tnFGrHA+YeJc3EMhkCGf9DD5ZJKQvhZv+cuzl3jlxzZzKN8fQbgZArry7l9ouWXgStfm
         qmJ1LKifrGoAyKoY8R0joQZGCPhMGMspw8UQQ/tmsYDqlBFFXV3bXT58S2kQ0Y20dRm/
         Yd1B6CQmWaBF5OaXnUJC/Q4vqF9Vkc38AWPhN53yI2xx9mG6M6TB2+GTnnheYIaZ2RoH
         CIWmfbC1UtAJ5ywqcmtUZurGNR2Zetjm9rxmZFZpXWTP/hiD96fdupQcOSMcxYGUQHe3
         ISBg==
X-Gm-Message-State: AO0yUKWvpeob7FL8YVgt+HeVzKj4dghXkpRfFNCydAC6x4eHEknhVYTK
        xhD+7jzkkQve2qhstDyrituuZKkXaxQZR5vmO5ubq2r1
X-Google-Smtp-Source: AK7set9mGhPhKOdJXBiAd7LFrgVkR7Lc+Z+SvdLXqTEIQZnl6fh6cDkfFcZFw7+PWEaTGEI+FiyiRg==
X-Received: by 2002:a17:902:7c8e:b0:19e:2860:3ae8 with SMTP id y14-20020a1709027c8e00b0019e28603ae8mr3388457pll.33.1677892583276;
        Fri, 03 Mar 2023 17:16:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902cec600b00198fde9178csm2089987plg.197.2023.03.03.17.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 17:16:22 -0800 (PST)
Message-ID: <64029be6.170a0220.1bff4.48f3@mx.google.com>
Date:   Fri, 03 Mar 2023 17:16:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-3-gecd1b5690765
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 174 runs,
 1 regressions (v6.1.15-3-gecd1b5690765)
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

stable-rc/queue/6.1 baseline: 174 runs, 1 regressions (v6.1.15-3-gecd1b5690=
765)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.15-3-gecd1b5690765/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-3-gecd1b5690765
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecd1b56907653cf4ac86a79d4d99ec145845168e =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/640263465c2265f4b68c8654

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-3-=
gecd1b5690765/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi=
-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-3-=
gecd1b5690765/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi=
-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640263465c2265f4b68c865d
        failing since 6 days (last pass: v6.1.13-47-ge942f47f1a6d, first fa=
il: v6.1.13-47-g106bc513b009)

    2023-03-03T21:14:37.833784  + set +x
    2023-03-03T21:14:37.837412  <8>[   16.006946] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 94024_1.5.2.4.1>
    2023-03-03T21:14:37.950511  / # #
    2023-03-03T21:14:38.052728  export SHELL=3D/bin/sh
    2023-03-03T21:14:38.053291  #
    2023-03-03T21:14:38.154830  / # export SHELL=3D/bin/sh. /lava-94024/env=
ironment
    2023-03-03T21:14:38.155373  =

    2023-03-03T21:14:38.257064  / # . /lava-94024/environment/lava-94024/bi=
n/lava-test-runner /lava-94024/1
    2023-03-03T21:14:38.258272  =

    2023-03-03T21:14:38.265444  / # /lava-94024/bin/lava-test-runner /lava-=
94024/1 =

    ... (14 line(s) more)  =

 =20
