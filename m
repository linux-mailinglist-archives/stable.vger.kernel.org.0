Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203D26BB657
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjCOOmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjCOOmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:42:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844448614C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:42:52 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o11so1153815ple.1
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678891372;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RxcChDQvAE9Z/kXeaRxgDVBtFxAjlKBpJFQNt3xbudM=;
        b=wh4KZFcsObvgWTQ8JTJsakD7b21X0WR7XuYV6shSpWsPAlkS4+VFcm36IzmShfa7QV
         lPD2UmkANJ+gDiPBDg6tEwzQCQpM+gkYfnFEYCXnahgtC+3fccI5hPMnDCrNnYW2rOQV
         VNUZPWyvCKBj8ySXRes9quK259j7j8Jwk3neK+yBDj++JkqmrKg+fddgENo/OHLDMJ78
         2t7URCvU5ENB819tZN/O18A2CheiK7uFKAC72tc3LtM8MqezCI9OAv/DjQufQvM4LkMp
         e8puqY6tyrm8CWZo0glZcIqm0QeV9yPxyqrYLDOvGlFoCNkO27JrYNrh/Quo1OmSiE/O
         laUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678891372;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RxcChDQvAE9Z/kXeaRxgDVBtFxAjlKBpJFQNt3xbudM=;
        b=Z69pcKgimD4MJ/WR7lOyPTFJxBjwOWXxWhxI9Ml2YzBewXjjfXGmGO3aDJ+xK14x0E
         aIwOW4ha9ipKoYkCMeuts4o4bJwJb9bnVQ3eA0rB1P0aX3gXZP3ZIQEOU4pQ/JHMUtoF
         kRTxy+08p2j0+crPrQcevUYx2qPjfmDpVUolHBmrwl1AS2cgcQHdLaSdQ8lDq/8vH2G8
         vdizgHvOtHQf6QM6g5CPDGUQCQLMWwOU1UIdFJhDms1XFDSqCxvtV0/Mnlkxh07OueRZ
         pyYjAwtCQgd6zE9F8ZQYKcGsFe9Xh0WeUpgCFJnE3aipfO3INqBQO6lS0e5Ac4LSXBP5
         W4yw==
X-Gm-Message-State: AO0yUKVmvlIwN+9tLuzdsqwyKX+kElRP+GBgemHyNppaskSUsTPAj7nG
        DsDdV7gtuLfJkSUqnVyv5cbuH0OecWYOdaYxjLRNsgsF
X-Google-Smtp-Source: AK7set8n8ZW30+0ypJqRZva7ViC9KF9YyKBXk9nQlH6iT+r8C4sU+jxmeUaye7/oO7yZEMikLppdZQ==
X-Received: by 2002:a17:90b:3e82:b0:23b:3641:cf16 with SMTP id rj2-20020a17090b3e8200b0023b3641cf16mr9823pjb.11.1678891371766;
        Wed, 15 Mar 2023 07:42:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ju17-20020a170903429100b0019cbd37a335sm3768124plb.93.2023.03.15.07.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 07:42:51 -0700 (PDT)
Message-ID: <6411d96b.170a0220.19f46.8ae5@mx.google.com>
Date:   Wed, 15 Mar 2023 07:42:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-145-g008d5c2e06c7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 176 runs,
 1 regressions (v5.15.101-145-g008d5c2e06c7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 176 runs, 1 regressions (v5.15.101-145-g008d=
5c2e06c7)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.101-145-g008d5c2e06c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.101-145-g008d5c2e06c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      008d5c2e06c76b7dd505c338ae2af912776bae9b =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6411a82838697634c38c86b7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-145-g008d5c2e06c7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.101=
-145-g008d5c2e06c7/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411a82838697634c38c86c0
        failing since 57 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-15T11:12:19.489762  <8>[   10.035000] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3413481_1.5.2.4.1>
    2023-03-15T11:12:19.596049  / # #
    2023-03-15T11:12:19.697539  export SHELL=3D/bin/sh
    2023-03-15T11:12:19.697969  #
    2023-03-15T11:12:19.799129  / # export SHELL=3D/bin/sh. /lava-3413481/e=
nvironment
    2023-03-15T11:12:19.799535  =

    2023-03-15T11:12:19.799747  / # <3>[   10.273666] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-15T11:12:19.900960  . /lava-3413481/environment/lava-3413481/bi=
n/lava-test-runner /lava-3413481/1
    2023-03-15T11:12:19.901612  =

    2023-03-15T11:12:19.906529  / # /lava-3413481/bin/lava-test-runner /lav=
a-3413481/1 =

    ... (12 line(s) more)  =

 =20
