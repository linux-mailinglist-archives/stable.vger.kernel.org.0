Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B9567A543
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbjAXV5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjAXV5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:57:11 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EF527D70
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 13:57:07 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s67so12215995pgs.3
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 13:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MxoibKyJeYyAb680Y9UXjBCiBwE29qItADYf5Tg3bq4=;
        b=QpVag/ozNXLUkd9K5hx6fRAzRn3+XgZlFQp6KjDxTdmwKw1wJOgTFPrc+mqTMsWzAe
         ce0mg5GjXt5D9I4FivZlgHoQYsaa+FyfUDWLrEbn2q1tjTqVN40FERYngD6g+LxohPqv
         YrZrGC74BCKFAeZy20VKWIeowT2+1N8XgKHqduBZqyYOcIoumISl/tJmIQd2va2dh3Yx
         X9pG4NRtnnPAgbzzV2pL/v4yziP7zXT5MFxFNHpQl0wPIGUnZv8ixbHNPMOBD0AvRvJ7
         WgcM+lZAJ8/IgoeO4p8RH+OArPeimYkNU4cgwa8nH6R1b70hHPTY4Mz3ngocWQ5xGE2M
         t/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MxoibKyJeYyAb680Y9UXjBCiBwE29qItADYf5Tg3bq4=;
        b=oGcigLOaoSEDPrDa84fFx23npcodyQ3BVLjLWgs/FHfEOK6n0s/w8FXROe381DubuV
         XHnz9NC6KcQpKJ2TWpwVAav0Qc8cfnfWWMR+3WXAQbSUZKe9Ya8C1TMIY7eGdvh0EZZ9
         TI6cUPrHV5+B/BYLKU5lFJYMhlOPw1XdvRPMkuL+dVG+WUDudq6Eqb/E0mShvZ9MKUG4
         eNIJTRTGgE8XDVSBS43Smc4MtoH+0TqHeQFnpB3rndN1cAJrv6VqaR/cN4MziI+CvHuS
         FJwkFVB3CL2G377KEM03s7iJQjWWrL7HkiMpt4TvhxnDzSP6a21PF7YHcjEOaun4+APj
         VqmA==
X-Gm-Message-State: AFqh2koWc4tz9y8rWBPuDHzkJQ4mPfZc6FFrZPeh347Me+/0T7pzZwgg
        y51sJdYNxv+O9yx4ErYTRjkzCXzfCNThHnh+ReI=
X-Google-Smtp-Source: AMrXdXt40k+s5sfYL2A0DDjysLThxmTP1KmpLjPyF8L8vu2jU4VwnVgkjg8mr5PU52RANJdV2KJi7w==
X-Received: by 2002:a62:be04:0:b0:58d:95aa:88a0 with SMTP id l4-20020a62be04000000b0058d95aa88a0mr28390337pff.24.1674597426593;
        Tue, 24 Jan 2023 13:57:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21-20020a62aa15000000b0058e264958b7sm2148747pff.91.2023.01.24.13.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 13:57:06 -0800 (PST)
Message-ID: <63d05432.620a0220.e3239.492f@mx.google.com>
Date:   Tue, 24 Jan 2023 13:57:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-340-gf6582775c0bf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 144 runs,
 1 regressions (v5.15.87-340-gf6582775c0bf)
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

stable-rc/queue/5.15 baseline: 144 runs, 1 regressions (v5.15.87-340-gf6582=
775c0bf)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-340-gf6582775c0bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-340-gf6582775c0bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6582775c0bfead4ff0e9331cb61bb4ca1410ba8 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63d02000d0d3e6fdab915ecc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
340-gf6582775c0bf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
340-gf6582775c0bf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d02000d0d3e6fdab915ed1
        failing since 7 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-24T18:14:08.817765  <8>[   10.003964] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3202636_1.5.2.4.1>
    2023-01-24T18:14:08.926540  / # #
    2023-01-24T18:14:09.027967  export SHELL=3D/bin/sh
    2023-01-24T18:14:09.028340  #<3>[   10.113153] Bluetooth: hci0: command=
 0xfc18 tx timeout
    2023-01-24T18:14:09.028506  =

    2023-01-24T18:14:09.129624  / # export SHELL=3D/bin/sh. /lava-3202636/e=
nvironment
    2023-01-24T18:14:09.129998  =

    2023-01-24T18:14:09.231118  / # . /lava-3202636/environment/lava-320263=
6/bin/lava-test-runner /lava-3202636/1
    2023-01-24T18:14:09.231667  =

    2023-01-24T18:14:09.236921  / # /lava-3202636/bin/lava-test-runner /lav=
a-3202636/1 =

    ... (12 line(s) more)  =

 =20
