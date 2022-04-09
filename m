Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6F44FA5AB
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 09:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbiDIH4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 03:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiDIH4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 03:56:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDBF33E1D
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 00:54:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id nt14-20020a17090b248e00b001ca601046a4so13878634pjb.0
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 00:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=duMK2TsKFkUCJhfULhlE4N5Q7rZXUDbMEgF+Uo9RKx8=;
        b=acxXXcsucp5V6yIXxFGWV2owOljSmiokd4AX022dxmo3sTjRkONZLebA7CpF0bK10V
         KCK/EJToUYn3Lj2wFnMwJc/vc4MGT+WhzXptwjD2YBZ7FPtvc0KrhUtzP3+KU1p6R8Dn
         9ZVGQisuYRB9/Uw1GP2J0oz/5P99qRHiMFmHwCC4T+F/pxoo6HDIuQ/QdievKkgIPXgO
         pgBAkHukhE0eYoxRyD5pF6ReWNNj5hFLyYNHXWyJIOObeDWlBKg1rivFv6TxZ7HHczcb
         0j4GNHkcBJUvDPRtaJrpiHuZR0gFk3qodD9Dwf0EGImPo6CJgmHW8bx/GQfgQXXLsrgX
         sS/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=duMK2TsKFkUCJhfULhlE4N5Q7rZXUDbMEgF+Uo9RKx8=;
        b=1t0Yl/4Bn2P/02Z8dIkfll8o+vSFmT6rslnPsmBAHvV6ycpRwnb9iSHaIKECgf2E/S
         OT+pv8g9kduqOjRYb7jMMi0pa/0EKeUBYmQDgw4Nu6V3QB9MH8BPDVetAXuTJYlF6uQk
         O2kpNC3FwBG3uEuNnOSbr3ERYriAiGRB1MKE2VZO7/V7kirH4gZhCbdYVk5yD3mebnhv
         n5Wb2pcu+tXMYGvf4bkvioLKS5oeb4B07iqhMnhb4s08eNUGrDQnB7kqeFQqGC8JFRCG
         jGDjWWypPvegpzzS8DoV69EWRnqLyUnQwEnSJ34taMS1SK+off3oDsnQwwspXPVeZ3bk
         z4zw==
X-Gm-Message-State: AOAM530pTyhwJRZc5EoN5zmUANsjgJeWTOY4Im+e89gozVgfadG9ewhc
        9boDXKwLeNuFa1PRp0Tcg1/hgT2WWErXrivG
X-Google-Smtp-Source: ABdhPJy2icdPNeff1UKfc3ZI7VyXHYfvkjts7jhPAwQcE1mevaQpR5Zs0xrj9qrnOS39oRfz9K/PPQ==
X-Received: by 2002:a17:90b:4f4d:b0:1c7:5324:c6a0 with SMTP id pj13-20020a17090b4f4d00b001c75324c6a0mr26187579pjb.160.1649490886672;
        Sat, 09 Apr 2022 00:54:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16-20020aa78090000000b0050583cb0adbsm4608682pff.196.2022.04.09.00.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 00:54:46 -0700 (PDT)
Message-ID: <62513bc6.1c69fb81.e12bb.ca44@mx.google.com>
Date:   Sat, 09 Apr 2022 00:54:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.32-911-g76b53f221adb1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 84 runs,
 1 regressions (v5.15.32-911-g76b53f221adb1)
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

stable-rc/queue/5.15 baseline: 84 runs, 1 regressions (v5.15.32-911-g76b53f=
221adb1)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.32-911-g76b53f221adb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.32-911-g76b53f221adb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76b53f221adb1db1a41ec284b75391683e32027b =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62510b1cae1907d287ae067c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
911-g76b53f221adb1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
911-g76b53f221adb1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62510b1cae1907d287ae069e
        failing since 32 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-09T04:26:47.662499  <8>[   32.588701] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-09T04:26:48.685194  /lava-6053294/1/../bin/lava-test-case
    2022-04-09T04:26:48.695854  <8>[   33.623333] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
