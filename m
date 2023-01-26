Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0356067CD40
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 15:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjAZOE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 09:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjAZOEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 09:04:49 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A16B100
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 06:04:47 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lp10so1613982pjb.4
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 06:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=95MI3lkWarFTw/S08rpJkacmyuG5z88Al09v1NNbfUw=;
        b=SdGTKEATaF+8+RILgqv1u7lhX7pDUqZuvsGtmLxUjT9w6OYtrg1UUgN3fhVWs2CH5S
         MfwCf4wuy2h5acUUguBtHnLAuoOqtEcnSnIn5VclccTrjqXJJcuAo4t3YRY9bxq8csI6
         c4jZV43V3RTBIgGqlalOEnt1PTafLxlRluZ8b4V++oCzVOD42kRw0Xlgou8cfAC7Bg0Y
         3Jy55P743ViCG210/gDjwR5a4KRFs5fBhSIc5ZW80CLYMDDHbC+59lzOHYx+V8sRwdwQ
         JzmOnGEiIHpL9u1tNckr5GQY55lUPisKbUwOgdYuKz9KlCWZOgqLe1h34H2seHDQgo/E
         +fNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=95MI3lkWarFTw/S08rpJkacmyuG5z88Al09v1NNbfUw=;
        b=aIFxL7PYywv48roKFPMAdzXWlK7Iv27RkKEBF1KDXVDX5DBoeKQO4MU1PnD+sD3sKp
         h8OQfrQZJHfuL2y9aPPBhQ+QIPw9ovdyM+MQLf5zR5QTNsEHa3jHeQcUX3HStGVBCnZG
         oQedIVv6XCB8hwP2jVs1G/5arHRV7m1gTZUcnhsGNRR7CPRTSn/tsKv3gUJ3bBQV6rug
         BUJlXV2OHE5h/U2N+2Ll5bhDUinsosyXxkoqbIfxL8UZn5DibZAbYU3TvVq1K/6AHpBw
         60N35c1Vh1UklY0JQDQq0z6jU07I1OXO4IF9jb8eVPxhCQ0aXsNGiy/B5+rix1OYqlVY
         nuUQ==
X-Gm-Message-State: AFqh2krXA+M8/HFn3Dk4ZBWaMEkrykOZs0+OmwqnGwHgID9OseVjxss5
        fwGSSnNS8M2i91OYjC4JN4Nin0v+uXz5O7WY0Y3xng==
X-Google-Smtp-Source: AMrXdXuPwlF5LqZ9bNUXymAwhCggb5Vrn0xKcUN04U71WYPuR5Oo3zDNGjShB7S/2JVKGHwBGt77WQ==
X-Received: by 2002:a17:90b:688:b0:225:c65f:3550 with SMTP id m8-20020a17090b068800b00225c65f3550mr37121976pjz.9.1674741886130;
        Thu, 26 Jan 2023 06:04:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c22-20020a637256000000b0048988ed9e4bsm779432pgn.19.2023.01.26.06.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 06:04:45 -0800 (PST)
Message-ID: <63d2887d.630a0220.dddf2.0e87@mx.google.com>
Date:   Thu, 26 Jan 2023 06:04:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-123-gf7d108c8efd6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 166 runs,
 1 regressions (v5.15.90-123-gf7d108c8efd6)
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

stable-rc/queue/5.15 baseline: 166 runs, 1 regressions (v5.15.90-123-gf7d10=
8c8efd6)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-123-gf7d108c8efd6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-123-gf7d108c8efd6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7d108c8efd64b66a115ed02c722fd8adb436a8f =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63d2591012c048d7fe915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
123-gf7d108c8efd6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
123-gf7d108c8efd6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d2591012c048d7fe915ec1
        failing since 9 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-26T10:41:48.364040  <8>[    9.976647] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3216846_1.5.2.4.1>
    2023-01-26T10:41:48.473823  / # #
    2023-01-26T10:41:48.578260  export SHELL=3D/bin/sh
    2023-01-26T10:41:48.579117  #
    2023-01-26T10:41:48.681147  / # export SHELL=3D/bin/sh. /lava-3216846/e=
nvironment
    2023-01-26T10:41:48.682136  =

    2023-01-26T10:41:48.784329  / # . /lava-3216846/environment/lava-321684=
6/bin/lava-test-runner /lava-3216846/1
    2023-01-26T10:41:48.785612  =

    2023-01-26T10:41:48.790518  / # /lava-3216846/bin/lava-test-runner /lav=
a-3216846/1
    2023-01-26T10:41:48.834662  <3>[   10.433223] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =20
