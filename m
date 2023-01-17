Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F15366DBB8
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 12:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbjAQLDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 06:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbjAQLDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 06:03:01 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE64F2CFE0
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 03:02:59 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id c6so33173881pls.4
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 03:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=g+FWSsSm243pTNR3orZ+7bR28yKMMaL9gtyvpjPBUHI=;
        b=hHHwVmLwwwK7uaZk4K3XidBhj/OiIxwoxnN/yWZNdpZKvB3uXJNgem34HS7xgPjzOi
         b2nv8v845xeFZgp5stD3IrdaOGDZ3oNFDmQ/1I5d1lSe12aUqhJxRVvZvPDu5l5MD+46
         GmucynCws9h3pvntuy/OF9ZbjpyV2PitjYRI29+VnZ5CN7eahA1L+Hn6EacU81z0B5L9
         LnXHUhC9ljX9a0GTxEte1HV+Nc2IVUs/7ACuHeaN3L1RBTuOmcH8xQoZwwKcYCjBBgI7
         zSTmeQYoDfIxVEEs4uyQRIoK2uev06wwsT2XnHSd6B9UPgK5qZKfiFNVLkASIJdkeQWU
         m35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g+FWSsSm243pTNR3orZ+7bR28yKMMaL9gtyvpjPBUHI=;
        b=dUKL6Ct1OxyD5V4Ct+4FpVn371ZHyYCMNNKuDT9849Fk8rXf1b/Iux4wS4OU0jaOK2
         59XO3EP9qKifDKjRZvkxzHyDjWN2aouzJZAHJ/YKmxcbM9J2D1voMU5Wrwo+5zcq+wUU
         TXldJ+TOrbIeDMijyEejNQzG7hPYOEQcBAlOQPIyYmiqqfy0Z8OUy0zqHAdFsIOD0rPE
         nTfuZ0muLA2iBOSufQ2EwhzCko/+hxvzj3dERTooreKtJq1aI7n/+DdTibhxq3ol3+1o
         4qCEX8RyYvMz346axEotRT6D48nC1PNZ3PmQx+2uidhhOZyXwjDMEGLwpDApL/jwfMVx
         /iTQ==
X-Gm-Message-State: AFqh2kpwfJ1ReirSubIq8eQaWerwSg0pYdQKSWOCurgfOEbkSTifRJlB
        P/sz8xOTtwb1HMMWE3pro/SoG73C2PEfdzKfTmhC0w==
X-Google-Smtp-Source: AMrXdXvutVxUN0YyyRAFtmlaHethIO/b2yGFV2P+LYZD/fyLbgWS8bjZY1n0ienamrY6w9EnSSDuSQ==
X-Received: by 2002:a17:903:1009:b0:194:4a85:b72c with SMTP id a9-20020a170903100900b001944a85b72cmr2691188plb.32.1673953378899;
        Tue, 17 Jan 2023 03:02:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902bd8900b00192b93a6cdesm20782267pls.212.2023.01.17.03.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 03:02:58 -0800 (PST)
Message-ID: <63c68062.170a0220.ace17.1789@mx.google.com>
Date:   Tue, 17 Jan 2023 03:02:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-100-ge215d5ead661
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 164 runs,
 1 regressions (v5.15.87-100-ge215d5ead661)
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

stable-rc/queue/5.15 baseline: 164 runs, 1 regressions (v5.15.87-100-ge215d=
5ead661)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-100-ge215d5ead661/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-100-ge215d5ead661
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e215d5ead661b9aae131438fbb665cbb9868cf0e =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63c65462500dd3c92f915ec7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
100-ge215d5ead661/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
100-ge215d5ead661/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c65462500dd3c92f915ecc
        new failure (last pass: v5.15.82-123-gd03dbdba21ef)

    2023-01-17T07:55:00.031406  + set +x<8>[   10.028987] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3142931_1.5.2.4.1>
    2023-01-17T07:55:00.031950  =

    2023-01-17T07:55:00.142267  / # #
    2023-01-17T07:55:00.246250  export SHELL=3D/bin/sh
    2023-01-17T07:55:00.247255  #
    2023-01-17T07:55:00.349231  / # export SHELL=3D/bin/sh. /lava-3142931/e=
nvironment
    2023-01-17T07:55:00.350120  =

    2023-01-17T07:55:00.452011  / # . /lava-3142931/environment/lava-314293=
1/bin/lava-test-runner /lava-3142931/1
    2023-01-17T07:55:00.453611  <3>[   10.353668] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-01-17T07:55:00.454093   =

    ... (13 line(s) more)  =

 =20
