Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF4A506298
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 05:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346652AbiDSD3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 23:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbiDSD3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 23:29:34 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9EF289A8
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 20:26:52 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d15so13937692pll.10
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 20:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ddF0NRloHPKkuI7eKkoDZ2TGdPaLv6tPJePWNj4C/5Y=;
        b=AvlxF+daCWOtTY+dPwmJK3ONttjj/TJbiUBnxL3/nooBoer3FJyGfPLr5SFsTFAV6Q
         yC97ruzVU2j+8gMVuoG5bgtrDB/f8Q3USfRMof2pHqDnQ5kQhAac4ycDg8lrjjqY3a+j
         Vl+sXIGIr1beI/Yt6ggnZAzsO0wxOyJPWoZi6z9UclMD9wqmouWFp+gwde4qgwCgiDr3
         7jaCdc2SzOtlY6jqlWHuLV1BuLBXbE5gJvm03jBChvbLrZe1/OEcQSjpQ9/A6FRuRba6
         CJhKQU1sGk5oEZf5cVi0Jw/0rJOmxZ5fYu4VkEacXakAPpWhl/MWeKFV3aG7rd+VKBRi
         YnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ddF0NRloHPKkuI7eKkoDZ2TGdPaLv6tPJePWNj4C/5Y=;
        b=rUvfihrvK/l5t9sD1S6I3XNs+2YUdOMGvvTUEtbdXzY2sRcEEpQQMH5R9mOzHkjtQ7
         5XwqAyqBI1D7QoCqaqh7/Ygn3/dfJRft83E0np82Xo4MoAmIYHo23qKtlsVkttryZTfw
         S841jENRTZNg5/ouQtpIgNCW5Kvw+7QD+RHeK2Y+fNJuxdvV4FekVeDQ7KPA9bIg0ljy
         yDMqCS6pchzbEttwScqtzdZu7MHk8w8cXOZFIMOYsOJHwjTYCHopUdBYy62gN5GXTOb6
         XE194J1+17t8orLRQfoSoXrCNoD/oiSUgh8lQWJVTburG+EkP8kdevdXHC7KBgBmAbaC
         h5Rw==
X-Gm-Message-State: AOAM531cmJQK7tiopZoQn0DuOp9+auhT8ZJ9vJxHEfLSFm3OzSs4ejcv
        8D1uSVC7ebLs/JfpY3Lx8l6dw8hzm0dAAmbe
X-Google-Smtp-Source: ABdhPJzM49FJpc1lmEYeij92hjK9DbkUqZAOwIJLWAcxzfiiOQ4h8u6DWoCab72qiijOHQAXlDTmvA==
X-Received: by 2002:a17:902:9b94:b0:156:2c08:14a5 with SMTP id y20-20020a1709029b9400b001562c0814a5mr13695350plp.60.1650338811842;
        Mon, 18 Apr 2022 20:26:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b004e17e11cb17sm15114006pfc.111.2022.04.18.20.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 20:26:51 -0700 (PDT)
Message-ID: <625e2bfb.1c69fb81.f5785.3ca2@mx.google.com>
Date:   Mon, 18 Apr 2022 20:26:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.34-189-ga46de8118b1d2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 104 runs,
 2 regressions (v5.15.34-189-ga46de8118b1d2)
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

stable-rc/queue/5.15 baseline: 104 runs, 2 regressions (v5.15.34-189-ga46de=
8118b1d2)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.34-189-ga46de8118b1d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.34-189-ga46de8118b1d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a46de8118b1d2674e4504a0726a4d5ac11a360cf =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/625df38c343b27252fae0685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
189-ga46de8118b1d2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
189-ga46de8118b1d2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625df38c343b27252fae0=
686
        failing since 19 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625df428ee63c695ecae068b

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
189-ga46de8118b1d2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
189-ga46de8118b1d2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625df428ee63c695ecae06ad
        failing since 42 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-18T23:28:22.036075  <8>[   32.654436] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-18T23:28:23.065515  /lava-6118893/1/../bin/lava-test-case
    2022-04-18T23:28:23.075867  <8>[   33.694803] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
