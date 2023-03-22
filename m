Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42C96C5353
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjCVSK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCVSK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:10:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1CC5F6D6
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 11:10:57 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id le6so20019538plb.12
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 11:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679508656;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FRZrsAZ/4Z69J0IAtD8c2lD+G9w0Hyj3MFTObiM2HBM=;
        b=4fAY13qJpqNIMBg6/0d2mrYZQMQc+owjcrLZg2K8AaaxXJ1w9S8+VRwn8zRVEm7jz5
         kYJeyXaqU2kePxIpOFCdqvK6Uw20FATTrqkjdClGEb8dNJd2NVL9Odl9DAe8zjIP0CTL
         ouPlmdbKS8GA19/VemIERJdJ1glLrdA6lbyGlRsRm2/z4g/g78E2h9+mUVjRrLTamO7i
         hl0n13nEKyodXy60BaNeFalCjk6deJbRPGjosUghssktX5OsiX5kvFJYlmRnaS4QG1C+
         FGSk0Eg2YysnvkiBm90Ma5dz4FckdI2NIn/PvoxrRaGDXGlqZYmmrGEezHw5/qLm6lsc
         Ig6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679508656;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FRZrsAZ/4Z69J0IAtD8c2lD+G9w0Hyj3MFTObiM2HBM=;
        b=7aAHaqtrPCir8fnTgT6C+XPgpTxLRvYkrgs+tTB4jmdkdynpeAKUQvE4kjkY2v/8Ia
         U7e85/EZaInEMoGrbzt8RUzEzWYV+dbJok1XENJ40aMJn9IHGzoBCo1KzrZLV2tdgDiO
         XCkFEJ0oIogm92NsKWBulqxclAmidZ6gWRhLbMPBuq1Gh1uOjZS8WhSe1qOwYgUda1SZ
         Pj8vRBFL41sRELZ1dFKUqiG70/aXPjyEBSnkiKTpF1qRaO7C4MDimxBzDp+FfCkV/fpa
         wYPNZSZIWc1H66bhRFf4YUYCT41xTI76e6JFJQmPwl3yLYQQ2KSp8ifpl1E/k7zf0LD6
         ZtPg==
X-Gm-Message-State: AAQBX9dwTzEJWEDmvlY4nC5ySm4taz+uNX6N1lmajIf9REiXyKjECLoj
        7Ium85GI6W6FoqgAddhu3fzK5t5dvU6qJRECDwA=
X-Google-Smtp-Source: AKy350b3g5MSGWsd4UPUK4y1ikEXpyqaIXLn7vgBtSTwWtJhbn9lPr9ELJX7n0psh/6HOBGP8nkY4Q==
X-Received: by 2002:a17:90a:31c6:b0:237:d867:2260 with SMTP id j6-20020a17090a31c600b00237d8672260mr2795400pjf.4.1679508656277;
        Wed, 22 Mar 2023 11:10:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p19-20020a17090b011300b002376d85844dsm9946558pjz.51.2023.03.22.11.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 11:10:55 -0700 (PDT)
Message-ID: <641b44af.170a0220.c096d.1e74@mx.google.com>
Date:   Wed, 22 Mar 2023 11:10:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.103-115-g84847751ee64b
Subject: stable-rc/queue/5.15 baseline: 184 runs,
 1 regressions (v5.15.103-115-g84847751ee64b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 184 runs, 1 regressions (v5.15.103-115-g8484=
7751ee64b)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.103-115-g84847751ee64b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.103-115-g84847751ee64b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84847751ee64bf05c29931223ef31fd888d32366 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/641b10e8ac1c20ca0b9c95a7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-g84847751ee64b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-115-g84847751ee64b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b10e8ac1c20ca0b9c95b0
        failing since 64 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-22T14:29:46.091532  <8>[   10.014043] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3434883_1.5.2.4.1>
    2023-03-22T14:29:46.202547  / # #
    2023-03-22T14:29:46.306079  export SHELL=3D/bin/sh
    2023-03-22T14:29:46.307218  #
    2023-03-22T14:29:46.409343  / # export SHELL=3D/bin/sh. /lava-3434883/e=
nvironment
    2023-03-22T14:29:46.410251  =

    2023-03-22T14:29:46.410698  / # <3>[   10.273397] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-22T14:29:46.512486  . /lava-3434883/environment/lava-3434883/bi=
n/lava-test-runner /lava-3434883/1
    2023-03-22T14:29:46.514092  =

    2023-03-22T14:29:46.518530  / # /lava-3434883/bin/lava-test-runner /lav=
a-3434883/1 =

    ... (12 line(s) more)  =

 =20
