Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4835A631DA8
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 11:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiKUKFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 05:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiKUKFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 05:05:01 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152391EEFB
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 02:05:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y14-20020a17090a2b4e00b002189a1b84d4so4402826pjc.2
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 02:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hVSsHEVdiVhy20bcE5SMMIfJQHFY30iY9AqTHgUicFE=;
        b=UHx50GuI5BLxFk8aWsE9zLLLn2h6/eA5M3AiYmC5C3S3rxx53SGgT6459rhNygfhVu
         RwMM17phV8mQUNN9xNHcw9Fgy9GEQmj36CHqBqk3FOol98vfL0b6MrEKHMfE9QzodCRD
         L26oEKzkBKcKIpnOZLdkgJN5YtWrnVV07uyvbiQAAeCysmvVKt62okfhGTf8B8+R9et0
         flmaIeiQV3SjVXVXpytjo2sf/4Q5wz0Z1vGLQg+Hg54tIxxrm57OF/Oi672TbiMJP0xQ
         yn9rdLwtJIG76SZuOGHYIYGM9BiLrh7zgpEiNlMdJTIivG+3oRmgTmktw2630uy8zBj1
         cniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hVSsHEVdiVhy20bcE5SMMIfJQHFY30iY9AqTHgUicFE=;
        b=gwyoKrXrWS0h+ytzUCGkzTXBAv+NGqEHDWJFPsIBmMo2BTmtEQZl0l8kXtping/HtL
         4yCjLSPl75G1OqSWuMn5lCpqPpE5zW3vsPXjIuwuHW1ANEi2RK3tLNKteA5jNrDEb97P
         yAKI7/Ek6rKQ12HJz9NAY9ps2LpDUXgcvep0YWUpNqRzmARPiyC8P9gmiNa6OgnxIVfO
         7F8vInJQaGD0eCkJke22QeqnUJihJWHPNMdwsPWg6ou+2vHtAx7/L8n7pbp9LJaYJukv
         WBocCkHDO5tfWb3CljzST0+Od2Fw3vkS9lrnCcXXO+pSaAUwMcSVv0cH8aUjHhCzGM2n
         GFUg==
X-Gm-Message-State: ANoB5plIO2+JX6vCG7Kg5zNLMFukoSOdf5+nRv/P23aZ7U8KMLrIPiLF
        OqcAg7SXuxaSoBv/6IEQ2/dsIt8ir4tOvccUyXA=
X-Google-Smtp-Source: AA0mqf7YK63qjIaZT88cXzjz67CRbuVV1UINDhV6tfV5td8avMNL1gVl0pkVHZHYc3vJkRDvwzjKhA==
X-Received: by 2002:a17:90a:17c1:b0:20d:7716:b05f with SMTP id q59-20020a17090a17c100b0020d7716b05fmr19933198pja.104.1669025100390;
        Mon, 21 Nov 2022 02:05:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j8-20020a170902da8800b00186881e1feasm9460884plx.112.2022.11.21.02.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 02:05:00 -0800 (PST)
Message-ID: <637b4d4c.170a0220.5acf.d42a@mx.google.com>
Date:   Mon, 21 Nov 2022 02:05:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.155-81-gf6f75cddc177
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 1 regressions (v5.10.155-81-gf6f75cddc177)
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

stable-rc/queue/5.10 baseline: 157 runs, 1 regressions (v5.10.155-81-gf6f75=
cddc177)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.155-81-gf6f75cddc177/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.155-81-gf6f75cddc177
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6f75cddc17705cbbf84c71fecbd3bca65863122 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/637b28c1d9628e6dde2abcfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.155=
-81-gf6f75cddc177/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.155=
-81-gf6f75cddc177/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637b28c1d9628e6dde2ab=
cfc
        new failure (last pass: v5.10.155-31-gbcdd8d9154e2) =

 =20
