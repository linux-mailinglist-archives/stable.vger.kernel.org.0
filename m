Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98634E9EDA
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 20:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbiC1SUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 14:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241481AbiC1SUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 14:20:03 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EEDCF8
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:18:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w21so12845266pgm.7
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SqFqthWEhanPICgIJos60TVxVp+XkPOEGeMD9mQJElc=;
        b=raNQauPRZyvtkIdr08WKpfa48YDcbH+ABliEBT8r/SO5Z/C9B85LDtogOy1indpgc0
         xHc3xd2yhT9YEgxHilk0xO3W7UymObCEdr0srwkUh+DXfULOGa1Zn4w76PRekCaqe6WY
         ySEl2YqZQi/hPhiVu90lrLGu2RkbN09K12Bg39wFybH6EpQo3BL4Rr74tn/QM/T9uDXh
         syY+MaYH3yEwvhLi2V+86VTX/eqjoiI3ZnzNSwVkuRNht0nGulRNVlwYqPMhxQvitECS
         iNvqAkGjdz66nKZZydvBf4PNu3UqyANgmWicq7o3uJBy3eXAOYww6afNgF28cMTmnzv0
         HKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SqFqthWEhanPICgIJos60TVxVp+XkPOEGeMD9mQJElc=;
        b=PAxsQuep0ff61K+1AbY5xT62YjGT+Y9YBPLKJUgmZJSAdTLSoPNYN9kE4FEalkTWG2
         NH1zBXqY0Tc/7hWhh/CvRrIEAMteijwNQrQz1FKoVJI82j39+C1t+0Sza1yBY0bHg+MT
         7t/CsgYX/3vYTousKGZ6F7mL9AbXtIk7aUYewwfFUANIvroUdC3VWT7gILBL8ymZmq37
         R6tNYji8L1pl/fPv0bUYeQwOuPTJQVZRNwnbtM55dWAJKhnkCBFOqpUO71QRI/ZLjcXl
         vjX5S6DDJ5NiEvdR3ELUW7R8shIqz08y4eCMB0qxEajuPqOMQRI/VKGzgQGyAmOJcVh7
         fBkQ==
X-Gm-Message-State: AOAM533F7UhJI4nPTj6FRo3Lgd8SmhUiIv5F+SkNc2Ju/JG6e/mVw0Io
        areRzC5XLcWIvya2qgGLaG4JxY5iHLvBkI+i+0s=
X-Google-Smtp-Source: ABdhPJy3LAzbZ/RceDR8PS77lwwtrnrrQvldGYGrxfP15eVhBpWD88b+fCt6aTR+78NX6yRdSujKBQ==
X-Received: by 2002:aa7:8d47:0:b0:4f6:a7f9:1ead with SMTP id s7-20020aa78d47000000b004f6a7f91eadmr24364229pfe.42.1648491500877;
        Mon, 28 Mar 2022 11:18:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mw10-20020a17090b4d0a00b001c7cc82daabsm196290pjb.1.2022.03.28.11.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:18:20 -0700 (PDT)
Message-ID: <6241fbec.1c69fb81.f95b9.0a3c@mx.google.com>
Date:   Mon, 28 Mar 2022 11:18:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.18
X-Kernelci-Report-Type: test
Subject: stable/linux-5.16.y baseline: 127 runs, 2 regressions (v5.16.18)
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

stable/linux-5.16.y baseline: 127 runs, 2 regressions (v5.16.18)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.18/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9fec77b5f094c1bbd0432c3f98d20cca8fc07321 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6241ce29b67133c4b2ae0684

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.18/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.18/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6241ce29b67133c4b2ae06a6
        failing since 19 days (last pass: v5.16.10, first fail: v5.16.13)

    2022-03-28T15:02:41.711308  /lava-5959851/1/../bin/lava-test-case
    2022-03-28T15:02:41.721822  <8>[   33.636483] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/6241ca6bbd6055909bae067d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.18/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.18/a=
rm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241ca6bbd6055909bae0=
67e
        new failure (last pass: v5.16.15) =

 =20
