Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F294F6C05F8
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 23:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCSWNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 18:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjCSWNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 18:13:00 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6DF1FDF
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 15:12:59 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a16so6019115pjs.4
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 15:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679263979;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Pn8DpXZejDGZuGJnAzzKlYE757kOROmm3oV5FRQV4l4=;
        b=evHy8G84wqUhyWHpkl8+3ITGDMC7QAQBuPOoSO6rNGIPG9cWoV5wYL1T9MwkN4KQrP
         5trp65DfZC4tq3T2YZryzVRxA+v2ScU32qdC7yzfHd0rT5H2I73OycT4JB9g2EOSVYvv
         ytDq3rvLoZ1hcoX9niSUqbmBpfr3jgK096IczVBvGj5cD6vU7A5Bmfhgq9JeeiK6GG2B
         KYhPa7SiJRlJEQtDbdrPhPOKlEcd/1eWjP0K8MHNCnzOnPyxW2uRGd4VXMr3z39vYeWX
         cneGj5kOtldz3r/qSqEvIDFvOvZTZXm0ShmNK5C706uiKO3qStj9KRlOj7RhSTe0qK1g
         TGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679263979;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pn8DpXZejDGZuGJnAzzKlYE757kOROmm3oV5FRQV4l4=;
        b=6DAB2xYrW5WyvmQ0aV/+43oIL3BW+ij6vqGr3ETZf2jdWDxZX/hnVIqDkfqEdyDcBV
         Ta5awDHb9opvAMwZv9dgi+NpNO4AKzUtnLAEUdhmRmHy5lkkidFI7w3jAYTNcyKwGgJN
         0ADPSoqQ0K8TOj6BQLDRLONyvUgivigC2suq+IlVAgKrPzFYadIKXTM1eQ5Vy1jIQUJE
         7NUhQpMQXusIzTTj94iaW36cNM8Ftxbwb07+Bcx/m1RdppF2b8T02m0TIuKZk7OW9D1L
         LWqUmsLrSphyLGyvhKToMt2LspG9YbvieVESVsULcbI5bxPsSXA3CHVkRGQg3V4KMsxq
         as6A==
X-Gm-Message-State: AO0yUKUEILZEtDevcR+K93kSy7RlZBkopkEH8RQmI7/JcTWe7ZCew4v9
        M2YHtVYT8F/WSICV2dwiXTbq0hq5haAcnhesidE=
X-Google-Smtp-Source: AK7set9jNDQhFdoYuuWcHLk3oAeW91PC0vvwsCS4Q6NqRMEQC9BJfXZMSCC567IAMPcLx/eD9NCpfA==
X-Received: by 2002:a05:6a20:931d:b0:cc:a0fd:67bd with SMTP id r29-20020a056a20931d00b000cca0fd67bdmr12401417pzh.14.1679263978906;
        Sun, 19 Mar 2023 15:12:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2-20020a639742000000b00502e7115cbdsm2315973pgo.51.2023.03.19.15.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 15:12:58 -0700 (PDT)
Message-ID: <641788ea.630a0220.6904f.2af5@mx.google.com>
Date:   Sun, 19 Mar 2023 15:12:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.103-52-g39bd94e60b7c5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 171 runs,
 1 regressions (v5.15.103-52-g39bd94e60b7c5)
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

stable-rc/queue/5.15 baseline: 171 runs, 1 regressions (v5.15.103-52-g39bd9=
4e60b7c5)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.103-52-g39bd94e60b7c5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.103-52-g39bd94e60b7c5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39bd94e60b7c59c000b4e56ed26ac9d44be45fa7 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6417547d417e02603d8c864d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-52-g39bd94e60b7c5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-52-g39bd94e60b7c5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6417547d417e02603d8c8656
        failing since 61 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-19T18:28:47.651389  <8>[   10.000613] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3424717_1.5.2.4.1>
    2023-03-19T18:28:47.758493  / # #
    2023-03-19T18:28:47.860076  export SHELL=3D/bin/sh
    2023-03-19T18:28:47.860715  #
    2023-03-19T18:28:47.962209  / # export SHELL=3D/bin/sh. /lava-3424717/e=
nvironment
    2023-03-19T18:28:47.962788  =

    2023-03-19T18:28:48.065031  / # . /lava-3424717/environment/lava-342471=
7/bin/lava-test-runner /lava-3424717/1
    2023-03-19T18:28:48.065692  =

    2023-03-19T18:28:48.072105  / # /lava-3424717/bin/lava-test-runner /lav=
a-3424717/1
    2023-03-19T18:28:48.082723  <3>[   10.433680] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (11 line(s) more)  =

 =20
