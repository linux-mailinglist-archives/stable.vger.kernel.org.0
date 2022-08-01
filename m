Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD695872E8
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 23:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiHAVOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 17:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiHAVOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 17:14:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E672F3F316
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 14:14:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g12so11768192pfb.3
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 14:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0A6vs8JE/K3RFaRpNDSPm4NGrUNHFm2suj10tLO3TI8=;
        b=zR3i3eEZY6QZX5J70iHu0M/N8dKNpmGwBfSgqU2Gel92nRrNlTlH47GJK2MDpxLIQ9
         DviewGUpcjW3hOdojvHo5/NZotYIuxjqKiodzd3rjSCFss9Xts9B4liZ4dkG90rbFCw8
         FcjMaNEpPO2fjaIpbjtOIR5eBh196hftKAa/ovtoUIzfqA4XnSZ6FOrGCNxKsUpLIj0I
         0vZe65MxxBMKxaaR/PSB/z3qsyaq2GbuM2V8WiesPkMbfXwETRCT2rwDfPqbb2geslB4
         Yy1H+SubxtisV2aoUB/1DSONRvc9Gm5upggy8kkoj7PGM28bOZu8YeC9NvV7NLE9Yn5m
         XSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0A6vs8JE/K3RFaRpNDSPm4NGrUNHFm2suj10tLO3TI8=;
        b=ZyGo5yKFwwLflXSpJdxu1TcXO3sR7spblUcSSU2UYWjWsnLpJXz5wJ8LMoMe1nWv6N
         mdb+8kPGyQP2KClsEssIwsWNIUy2cEqvHoeetAsIo1Gm3yrAmTz6HEVBejslVBtIeJyH
         OEowcztcUrv5nTx6i6+zgt35HJgCVyH0KHjl90RPI6Ox1iv7o9+QNESkqS3HjEZo93Fi
         M7o7GSuEWjgBHZ4DjTMA1i1Z2cOHUI9SLw8NU0bEHufRAnu6GkQ8VwRC7MNStuMMcwSG
         oJswMeA5QwN3tgTQdGtqB0akeWKikE+xTL8ZxA/eb09jCmq8YU8QeAGEh0JnB6bGNjps
         Lstg==
X-Gm-Message-State: AJIora/BnyG6DoGUTm+ew9OZOcvBKdSF0AAJVQujevmJM+K9Hl+6dmXG
        g0ITb+Uli5qVPphS+vA+VOQ05478lTesuVFZuSA=
X-Google-Smtp-Source: AGRyM1vjrCRsjhoAYzyzWQgdfir6upUn1Vf+gG7cRCcP+GvrsjnpBvLinbYkhNQ8kU0qgwgbddIn7Q==
X-Received: by 2002:a65:5381:0:b0:415:f0ec:ac70 with SMTP id x1-20020a655381000000b00415f0ecac70mr14919169pgq.473.1659388445360;
        Mon, 01 Aug 2022 14:14:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090a2a0900b001f23db09351sm5794071pjd.46.2022.08.01.14.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 14:14:04 -0700 (PDT)
Message-ID: <62e8421c.170a0220.a5bbb.7f34@mx.google.com>
Date:   Mon, 01 Aug 2022 14:14:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-248-g7e8a7b1c98057
Subject: stable-rc/linux-5.18.y baseline: 117 runs,
 1 regressions (v5.18.14-248-g7e8a7b1c98057)
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

stable-rc/linux-5.18.y baseline: 117 runs, 1 regressions (v5.18.14-248-g7e8=
a7b1c98057)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.14-248-g7e8a7b1c98057/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.14-248-g7e8a7b1c98057
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e8a7b1c98057a3014222a505c28c6bd43ed5666 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62e813c4d0ec6538c9daf083

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
4-248-g7e8a7b1c98057/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
4-248-g7e8a7b1c98057/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e813c4d0ec6538c9daf=
084
        new failure (last pass: v5.18.14) =

 =20
