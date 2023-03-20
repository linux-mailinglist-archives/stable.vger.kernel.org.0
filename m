Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9626A6C1F3D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 19:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjCTSNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 14:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjCTSNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 14:13:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CB61CAC2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:07:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a16so8698153pjs.4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679335633;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sHgIdiLaPv+p7nA/+LPZ/iqKAtypJjVOFfI7Kt8T4kE=;
        b=Ah2Vlniw5n7igjw6DxOiTmy4PEHH+yGkwIYIq0qJfGiY+a62jc2002sZaoHVtfb+9t
         QCfshCd1GAEBDQp1mRUOJuY1sbcJgGJBTEW4SXuymsDNAPyWIs7SUUhRiBw3xJCcy1qh
         M1iKxHT9hkwiLewToSJtatxMXKfOZ5A2gGm4MZwQrtqFelqMWoePgLdcItydxLTwGQ1M
         Ul4bhKmWOWh26JlsCoADgh4z3HYOySRRX5P0Y5/HY2tfnQ1n/y16XQNc9Wp+xFvErTXO
         gA576g70X7XTVDoQ3Jnxo1dCnU+2AOfJyIltWks2pti5vdGSUpsdDGn6HLiSnG2vLYfg
         pj9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335633;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHgIdiLaPv+p7nA/+LPZ/iqKAtypJjVOFfI7Kt8T4kE=;
        b=LzuRICFrvDyrNKdw1xtnRtcQ8kxZSMhgaiN+AJ/Y2QRh+TqpdlXZiStus/SQcVjplC
         jXLBwzRqArdilNqY1fXYV9gWg5hZIeySwMW3cjUULTFizTVv2+cQsin5EY6scBIXuq9k
         TBP0Qe/kZpCij4r+w7Y1v8ZQ5Uivn8R4ufwLHZnICUaA3mCe7fZJqB21yXsWsVm9z9vl
         l213ltR20c+smXPhIEltIpr68kQQ/8H0/hdXqSLYSbtUy+ebdHObFAJTFik6CghMOrxh
         rlUHcR2vuWwJZVpNFFGHhaJHToHNF/dFBjZtfLtEkYKC6Q7eJC9WS8mokUDyb8SQXiY1
         d5yw==
X-Gm-Message-State: AO0yUKVtsdriS3C+MprJzVAziy06Gcft4/OEG85Z7ydtlHub7JHgmTe0
        hq3n7iBeaO/tMvQSPJAXdVgTook3ssSxc5We8g0rHw==
X-Google-Smtp-Source: AK7set9e/M2Abby9Z2GrSWoxSz7wgCG8nS60CqMDQ57UM90B3Pm64Pmnh1xlrL/6AeOo2YDpX1E+jA==
X-Received: by 2002:a17:902:d48c:b0:1a0:57df:861c with SMTP id c12-20020a170902d48c00b001a057df861cmr15631808plg.1.1679335632713;
        Mon, 20 Mar 2023 11:07:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fs18-20020a17090af29200b00230dc295651sm6546540pjb.8.2023.03.20.11.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 11:07:12 -0700 (PDT)
Message-ID: <6418a0d0.170a0220.de528.b17f@mx.google.com>
Date:   Mon, 20 Mar 2023 11:07:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.103-108-gd392d7ce01bc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 1 regressions (v5.15.103-108-gd392d7ce01bc)
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

stable-rc/queue/5.15 baseline: 172 runs, 1 regressions (v5.15.103-108-gd392=
d7ce01bc)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.103-108-gd392d7ce01bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.103-108-gd392d7ce01bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d392d7ce01bc5a2b4f37d2bda3d8bc4108673e6e =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/64186c540030b1206e8c8756

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-108-gd392d7ce01bc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-108-gd392d7ce01bc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64186c540030b1206e8c875f
        failing since 62 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-20T14:23:06.930847  <8>[   10.022353] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3429117_1.5.2.4.1>
    2023-03-20T14:23:07.042003  / # #
    2023-03-20T14:23:07.143864  export SHELL=3D/bin/sh
    2023-03-20T14:23:07.144666  #
    2023-03-20T14:23:07.246629  / # export SHELL=3D/bin/sh. /lava-3429117/e=
nvironment
    2023-03-20T14:23:07.247108  =

    2023-03-20T14:23:07.348538  / # . /lava-3429117/environment/lava-342911=
7/bin/lava-test-runner /lava-3429117/1
    2023-03-20T14:23:07.350015  =

    2023-03-20T14:23:07.350526  / # <3>[   10.354240] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-03-20T14:23:07.360025  /lava-3429117/bin/lava-test-runner /lava-34=
29117/1 =

    ... (12 line(s) more)  =

 =20
