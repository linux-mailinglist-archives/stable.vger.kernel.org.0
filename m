Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D43678040
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 16:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbjAWPpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 10:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbjAWPph (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 10:45:37 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388614EEF
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:45:36 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k13so11841808plg.0
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NLeXpjvnrMrut7CB2hujY5SXolmmICZd0KDNHMlIe1c=;
        b=F11w4R0g7qVgFqyMyg5JugNrTCkOp1hVQMMirvXiQsIFKszaM7tcjmWq587m7unFBw
         92TFJn4X02jpD16+q1F4xq+xiYRa1UzhqEYG5NqUc7QodDtNLZUojreciP1GBalEbLE3
         FDnm8mf8faPeKBbWOJvxg185JpXwmbXiYAFKgaGv2+PmKMcLu1HBfnLJ8IFvt1ObJR34
         l5jDLo20Ag4FALDqkFNsxnhE3QC1J6Efso0O+DySSfJwsBEAYCRONEch/t+55ZVk4w3l
         ytzaaLMq9712SagR3UaMT+m3l0a5cLJhXdnA2aJYcKa024QHcZ+mWCQm0ogmx3zGjs0g
         bxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NLeXpjvnrMrut7CB2hujY5SXolmmICZd0KDNHMlIe1c=;
        b=aKMt2iuAxHi9f8wZfuPOKkmts1jfSAutz8usAWMBBfSG6cVuDCt/T1EnGK92p7UVq0
         J9ApxhlC14iVrI/tiMzody7LgY6OTIK0urnjI1pdXqBTP5E28Sc3Ma5iDXtC12OZqKWZ
         HPpNpsIzwMFNe9d5wF9lADLuh2bpwxwO6oXJ6koGzk9ij1VSfOiS6iLvtqfCcDMNnQO1
         Yp1h2aZBP4ehrzBnGkX43gIh/KFC5j62nENa42BsLNwMEuUG2MKM1WLeDtnSqZO6dgpp
         tKSAKHQ8svFzfbnhRbrT/mpOSyUKKCy2/4dvMZxxImO/1dC2Tz/aeT/ssIx1n93ae/37
         AUSw==
X-Gm-Message-State: AFqh2kq1d6s44498V6ac8FGD2c3Cj4qJ9MdASiSi0bawp/3ra9FF5jLu
        +EE8UPEbFlnvaxTC4L0WuVC7bAeMwFaPh4/L94Q=
X-Google-Smtp-Source: AMrXdXv9YhLZUA//nheaGa2jzfEWQRenFomoMDwkmdKICTbuTM01a4l2edD9lTqEFBH1y5M7QfJZtA==
X-Received: by 2002:a17:902:d342:b0:189:89a4:3954 with SMTP id l2-20020a170902d34200b0018989a43954mr25752256plk.41.1674488735532;
        Mon, 23 Jan 2023 07:45:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w6-20020a1709029a8600b00196085e1bbdsm1515954plp.161.2023.01.23.07.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 07:45:35 -0800 (PST)
Message-ID: <63ceab9f.170a0220.d9a30.253b@mx.google.com>
Date:   Mon, 23 Jan 2023 07:45:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-218-g7889a110d028
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 156 runs,
 1 regressions (v5.15.87-218-g7889a110d028)
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

stable-rc/queue/5.15 baseline: 156 runs, 1 regressions (v5.15.87-218-g7889a=
110d028)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-218-g7889a110d028/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-218-g7889a110d028
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7889a110d028dd5832b09d5584be8bc41b4dcd46 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63ce7ad0ede79cbc6c915edb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
218-g7889a110d028/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
218-g7889a110d028/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ce7ad0ede79cbc6c915ee0
        failing since 6 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-23T12:17:11.500695  + set +x<8>[    9.975838] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3190097_1.5.2.4.1>
    2023-01-23T12:17:11.501008  =

    2023-01-23T12:17:11.608405  / # #
    2023-01-23T12:17:11.711656  export SHELL=3D/bin/sh
    2023-01-23T12:17:11.712019  #
    2023-01-23T12:17:11.812963  / # export SHELL=3D/bin/sh. /lava-3190097/e=
nvironment
    2023-01-23T12:17:11.813432  =

    2023-01-23T12:17:11.813689  / # . /lava-3190097/environment<3>[   10.27=
3578] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-01-23T12:17:11.914648  /lava-3190097/bin/lava-test-runner /lava-31=
90097/1
    2023-01-23T12:17:11.915313   =

    ... (13 line(s) more)  =

 =20
