Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2967BFFE
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 23:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbjAYWiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 17:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjAYWiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 17:38:11 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CA35A830
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 14:38:09 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id g9so50377pfo.5
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 14:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EvNg/1skJqkjSJ5+cHz6nQ4n415aKjhD9BfC7neFGXk=;
        b=P0K0/mqUutBlDFY3LRO/oTEfEAWyQZI3Si/ovoyQmbmCVUInCEIPQ5wqU7/l3u0kgD
         o8ivzYkSjpo7oxmk3sZbQKTL/zaivEa3zQdkG3QqMmdEGXXcs5oWgjZIrufDadLA4Gys
         H8iMQB4SqLjVvpuSms+HDHpsEtYDw5rvWlcwxrCrwkrFeyqRBXjewVRLH7sGhH10afkX
         yBwdCZWEPkCBjFi9F3JNPqb2gfWbuVetfPmHB0iSkzUn79lUq/9vwjPTY1yrX6XcRlc1
         gcSvUe6UDvuh9bcNGeDyejx5EPQ5F9nhr9CnZcT6dQ5KNTmodl4s8yYWlKpNxUsye0Lp
         AvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvNg/1skJqkjSJ5+cHz6nQ4n415aKjhD9BfC7neFGXk=;
        b=0h3VwtagaAk4NQE99yhC0o989N2nU9k8J9cINLkoJUlrQNy7XvkwOwGF7cV3/dQ8+m
         IoBNBPqTz7cnxq1DoAkvRU8NweMm+Usf4fpMu6cc35UmhB/qF+X/l/16rTOqRVlLACPT
         Dl3JKvABeqYf5M0PsmGVZt2OEFq0RN++nPRAR3++JHvJmFOQZ/ayjLDQW7sa7HpN3aYA
         KrdtJwOwdcU9tbMYd2iACcOm4yZWP1Blx0UG8UV+U6GdGihT8XQ54FmL4rH51t+/Rxr4
         wus79pSFk8onoxwhpU+U7ITtnbBArqjUgZoSi6dQ1uUsusTFzbB/h3fvY8dFAboJvHVc
         Snlw==
X-Gm-Message-State: AFqh2krrxY0djRvp5G7YuiYxibN3ZAn3lHkr1NqgegPGTFeUK37FxRLT
        rjgeBkNebbKukCqwUpFqdrSlEl8hu5r0J2e0fCYvsg==
X-Google-Smtp-Source: AMrXdXuqdgecRaw5bRj0ztEOyfHqzcvwQsetow+k2+Y5IyO4MDbub4CGVEYgdJkb4rLf7+YvdB0oAQ==
X-Received: by 2002:a62:1cce:0:b0:58d:c617:8e9f with SMTP id c197-20020a621cce000000b0058dc6178e9fmr35556963pfc.3.1674686289046;
        Wed, 25 Jan 2023 14:38:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7842a000000b00582f222f088sm4142003pfn.47.2023.01.25.14.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 14:38:08 -0800 (PST)
Message-ID: <63d1af50.a70a0220.f4ff.82c3@mx.google.com>
Date:   Wed, 25 Jan 2023 14:38:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-122-gdbbbfd1f5b2d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 148 runs,
 1 regressions (v5.15.90-122-gdbbbfd1f5b2d)
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

stable-rc/queue/5.15 baseline: 148 runs, 1 regressions (v5.15.90-122-gdbbbf=
d1f5b2d)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-122-gdbbbfd1f5b2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-122-gdbbbfd1f5b2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbbbfd1f5b2dbdce5e9ce1b5e3565c6ad7e5d62f =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63d17af1278f43d4d5915ee0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
122-gdbbbfd1f5b2d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
122-gdbbbfd1f5b2d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d17af1278f43d4d5915ee5
        failing since 8 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-25T18:54:15.685726  <8>[   10.107097] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3212068_1.5.2.4.1>
    2023-01-25T18:54:15.797267  / # #
    2023-01-25T18:54:15.901621  export SHELL=3D/bin/sh
    2023-01-25T18:54:15.902953  #
    2023-01-25T18:54:16.005782  / # export SHELL=3D/bin/sh. /lava-3212068/e=
nvironment
    2023-01-25T18:54:16.007177  =

    2023-01-25T18:54:16.109828  / # . /lava-3212068/environment/lava-321206=
8/bin/lava-test-runner /lava-3212068/1
    2023-01-25T18:54:16.111743  =

    2023-01-25T18:54:16.117035  / # /lava-3212068/bin/lava-test-runner /lav=
a-3212068/1
    2023-01-25T18:54:16.211582  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
