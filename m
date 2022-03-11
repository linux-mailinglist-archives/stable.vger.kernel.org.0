Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08184D58BF
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 04:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbiCKDSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 22:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbiCKDSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 22:18:02 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAA71A41EE
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 19:17:00 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id p8so6803695pfh.8
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 19:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ggMMO5LvKVU7P46K4IVpxI2bP1Lv9LO0y00cdfuNq6U=;
        b=TIPNlx/dKufK6e6+2VKkyMO229bS4FoRk/KrvDwMLmVXjy8YZGX/VejE9Azo1a2B2t
         hTKHskQwwL1JmUAUUhHRcSNoqeSyNwu4+l93y6GFSuLkPq+A4yrpg0GijGeNnJIrEozq
         3t6jYZUPm9iWddMLskdKjeOIl7/zCQTJeV3QJ8JETDkLVgo0LUL3qBOTEKDe7rD/QsLl
         dD8Df+tC/wOI1/sjWPsUQtA03hVOPZmmkKHKbGf9yu7q+ov84GDpH3wKG+hzwPGDFLz+
         iNIr/jKVQMwBXIUWhzpbdBdchavKBt2iGnJOlXCzB1uD6pSdff15MMo/QortshFuyFKm
         rn8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ggMMO5LvKVU7P46K4IVpxI2bP1Lv9LO0y00cdfuNq6U=;
        b=kBCk1osfd2u0J0F5jiCPMxRlDEnFEynJ5Pei734+cn5/QbjxXXJwoS0N+1dXtRhrjX
         1jG4714RFPJtTFFUbhJ6xSe6m3bdpp1zECOrYdTf4uYk6FFDna/VS3jPlNBdpKtTbyU9
         cqhJiiGT/sPHFjsHCSS1BiS59E/QuqkdewpdcNi5U4RVZM5fO6GGAixJmWsOQze5EIPA
         uc+F8Pj9JMmUaq79pdioh5/FmoPTNpQU5lPb6da5VYJaq7dd2D1LwXNP05QNqL8XYn26
         y2d6gX8fyOZPyRsvYo2KWVgHC4WFzYveK1qmZOKzlcwO9GYc5QkJR/XbYQsMPUd3u05p
         a0tg==
X-Gm-Message-State: AOAM530Oi1bai2hOksjvMhpzaVpEGTBV3wcTwG9vYDkGUhm6Yr41xZBR
        aHd4tWp/U2OYnHjjKT1mDoH8X6GHO/f2wMhsvmk=
X-Google-Smtp-Source: ABdhPJyMH1feetkS7WpzvtnxXQjgnKyMs3HmhtMW2XONovcbFGUMjsjDXDS8u8iQpitcRP7Wl1/0ug==
X-Received: by 2002:a05:6a00:1307:b0:4b0:b1c:6fd9 with SMTP id j7-20020a056a00130700b004b00b1c6fd9mr8269789pfu.27.1646968619364;
        Thu, 10 Mar 2022 19:16:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm10964611pjx.1.2022.03.10.19.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 19:16:58 -0800 (PST)
Message-ID: <622abf2a.1c69fb81.fdc18.e11b@mx.google.com>
Date:   Thu, 10 Mar 2022 19:16:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.233-33-g87b0d005012b
Subject: stable-rc/queue/4.19 baseline: 83 runs,
 1 regressions (v4.19.233-33-g87b0d005012b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 83 runs, 1 regressions (v4.19.233-33-g87b0d0=
05012b)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.233-33-g87b0d005012b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.233-33-g87b0d005012b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87b0d005012b8a6edf49949d2bb675f0ac0da12e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622a8e6545d6e29184c6297e

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-33-g87b0d005012b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-33-g87b0d005012b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622a8e6645d6e29184c629a4
        failing since 4 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-10T23:48:43.264436  <8>[   36.115093] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-10T23:48:44.280402  /lava-5854904/1/../bin/lava-test-case   =

 =20
