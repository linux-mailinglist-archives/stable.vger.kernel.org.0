Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D436835E7
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 20:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjAaTAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 14:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjAaTAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 14:00:13 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B603577DB
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 11:00:09 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id s67so10773157pgs.3
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 11:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUy4ZISHuIFn41VMmoB5JpWmRo8RFnO0TR22CmZllck=;
        b=MPoMArryEuSxDSxbx4vNiwWtwpkN/qJXDYLtx5ECjf7J22Vpxa0eZMkUgzznWwQC25
         0QRpdgHxhKtPuDGr/0k1mmpkTwedJ55SEJyZBAQiV881ZiJdJOYcu46lCQl6n5HjY6du
         ONnXsOXP10vOFGsCzcHYrhYHF1A4wZZkEJNAukE6f5gMvoRy04bTJtkD8O2TAsSr7b88
         F8gGmixH+V2QpdXjnq8zLEE7bGYEi9MDRxra4vZJcbqHrghUwCo6LR9P88Bdjx4ksoS0
         4PCgDSCelH4hBy9/Sgq4dw4YuZOoHKWljNtSL7PmhkMwmF0pnh3O6s0YBp8yTEZK/QkY
         vzsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZUy4ZISHuIFn41VMmoB5JpWmRo8RFnO0TR22CmZllck=;
        b=HcZI4pHyWQlSrCwGoWRqRJphZ12rUaM1N0zPLfCLOo4tGl0roFoivRaNcDQ9nj1ya5
         jl6hT+fl/ZX7IYj0nmqytEEYIIohrnvBEGiMyKMfbQOVV3KpvVTKk9mqeaXHLQNqHuZ0
         RoCn0oYBnV1/MZKTWGc+28bzkUDu3b28DhG5sgMMq2h76FNIGfY5Epvojdvq/P2T7cLj
         wa/HfxnAAea0p8SqK9+1Wpp+9nGkpUc/kVgu/xJg3ajk8Jq6v7tuhKc6aAe0ChNKQ2wp
         2ez/qgGx2F50jlnTdJcki1F97IaMZjWYddP1RUfAk32mMPQamrrDMRnFsfxlwkIn/X1v
         WVOw==
X-Gm-Message-State: AO0yUKUSYORuVePMeBMoJn13kElvqvnBSG/B2mWVM3fZBvX+fkR7BO7o
        5WTcIi5fiVMamZbawYeU2WoOAr7GDADZiAtUy6JQow==
X-Google-Smtp-Source: AK7set+uPKKpprjzWzoezivxPQlUTHlh8VVFmW4klSBTbPp/YPoCMI34Fmy8ZE96v/0XP76iqHy1nA==
X-Received: by 2002:aa7:90d2:0:b0:593:c67e:e6e7 with SMTP id k18-20020aa790d2000000b00593c67ee6e7mr7255440pfk.24.1675191608514;
        Tue, 31 Jan 2023 11:00:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s64-20020a625e43000000b00590774b9ea1sm9857980pfb.107.2023.01.31.11.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 11:00:08 -0800 (PST)
Message-ID: <63d96538.620a0220.ba96b.1217@mx.google.com>
Date:   Tue, 31 Jan 2023 11:00:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.165-142-gc53eb88edf7e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 1 regressions (v5.10.165-142-gc53eb88edf7e)
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

stable-rc/queue/5.10 baseline: 157 runs, 1 regressions (v5.10.165-142-gc53e=
b88edf7e)

Regressions Summary
-------------------

platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
rk3328-rock64 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.165-142-gc53eb88edf7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.165-142-gc53eb88edf7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c53eb88edf7e4c32303c0de55446e5f8851fd35d =



Test Regressions
---------------- =



platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
rk3328-rock64 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d9329bfe7ff733de915eea

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-142-gc53eb88edf7e/arm64/defconfig/gcc-10/lab-baylibre/baseline-rk3328-rock=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-142-gc53eb88edf7e/arm64/defconfig/gcc-10/lab-baylibre/baseline-rk3328-rock=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d9329bfe7ff733de915eef
        new failure (last pass: v5.10.155-149-g63e308de12c9)

    2023-01-31T15:23:52.616272  [   15.897672] <LAVA_SIGNAL_ENDRUN 0_dmesg =
3253329_1.5.2.4.1>
    2023-01-31T15:23:52.721498  =

    2023-01-31T15:23:52.823400  / # #export SHELL=3D/bin/sh
    2023-01-31T15:23:52.823948  =

    2023-01-31T15:23:52.824265  / # export SHELL=3D/bin/sh[   16.061476] ro=
ckchip-drm display-subsystem: [drm] Cannot find any crtc or sizes
    2023-01-31T15:23:52.925717  . /lava-3253329/environment
    2023-01-31T15:23:52.926228  =

    2023-01-31T15:23:53.027735  / # . /lava-3253329/environment/lava-325332=
9/bin/lava-test-runner /lava-3253329/1
    2023-01-31T15:23:53.028575  =

    2023-01-31T15:23:53.031720  / # /lava-3253329/bin/lava-test-runner /lav=
a-3253329/1 =

    ... (13 line(s) more)  =

 =20
