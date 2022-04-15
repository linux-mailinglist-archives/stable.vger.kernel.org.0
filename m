Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628BC502B70
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 16:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354229AbiDOOIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 10:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbiDOOIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 10:08:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB465F8D5
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 07:05:47 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h5so7344802pgc.7
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 07:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BcybBYNf6Gvr3NvRHfKWdg6vVltz+tmZIlTkKQBZFZs=;
        b=bmccG/JMmc93a3lNGCvYgyT/z8mem5aRnT2KYBFxSEKvQRHU/4RcmWoE/mvehFiErP
         TC9K0iqGqHR20XFs0aG+TzHdfhyDZUjUjVUefT1TQH0XT6W4Tf0Q7ySjTwDWV9cxC4m4
         uOM6hLXYCDGH3en+YSlgmEXr4F2sdWL0tKlrhm1Ea1auknv3bT1Kd74k/SxakCZVgA+L
         LI3KuByyyUAtZ1LV1JixYJqB8nWSURrKNqF9XgbZog0y3OGUbxNLlBWUMhUKPBEwjxvn
         Dijx3ijzFlt1Q0R0BSZTtv9TGFWIQzX8DEufMIa8Tg489IHzzx5jWTCC3ewhvlTUk8mm
         WvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BcybBYNf6Gvr3NvRHfKWdg6vVltz+tmZIlTkKQBZFZs=;
        b=t0dgoFs7zTgg7IbK5m+IB7290TW0RmaFu9rrm+rRzjvtzvz1ZCeQP5bDlFqX9T5OYJ
         0U8E+rVIS7XFO0bD9qrebD4OT23hd0e57Iw8si8aYJSVEBMD3/IYSOCDYi26PhhzC4Xm
         hSk4QWNMg1YFhtY+OqzbYJCL3p93ZJAQaHSe6SlCc6wa8a9Xx4JXpcbqU5QMmxXqrcH3
         OpnAf03XBmPcYJg98JYkDiXQIDgMkj1LmN1QHuWt7Q43mxvBAzTyRxFF8kP+4YBRCV7T
         Esli2Rr85z/PG0Fw+HDvwregIrRQTohEZVkYy/xW2XONT+GEsoYHpm0ATVRJPwPK6j0j
         WV9Q==
X-Gm-Message-State: AOAM533gLHBx5iXCNhfxod1Cn1pkHIqsQ1pXfwQtEHRTckBvDMVhKFAS
        2WBzHMrDgbC43etEf7v+frjWeQiwexXR1z4N
X-Google-Smtp-Source: ABdhPJzZ4PP0FWi978DziypxzZR47NzBXkPoK9Cefu44dpLZXS0eL1iRYQn/5EF8cROFMsVsBCOZig==
X-Received: by 2002:a63:4f0d:0:b0:399:5115:ff48 with SMTP id d13-20020a634f0d000000b003995115ff48mr6572784pgb.235.1650031546952;
        Fri, 15 Apr 2022 07:05:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r6-20020a17090b050600b001d08a7d568bsm2250846pjz.7.2022.04.15.07.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 07:05:46 -0700 (PDT)
Message-ID: <62597bba.1c69fb81.4bd68.5b74@mx.google.com>
Date:   Fri, 15 Apr 2022 07:05:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.111-6-gc2210c2901b40
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 130 runs,
 1 regressions (v5.10.111-6-gc2210c2901b40)
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

stable-rc/queue/5.10 baseline: 130 runs, 1 regressions (v5.10.111-6-gc2210c=
2901b40)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.111-6-gc2210c2901b40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.111-6-gc2210c2901b40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2210c2901b4032f508e74602d2a87144d2316ec =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625950264e5df2a1f3ae067c

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-6-gc2210c2901b40/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-6-gc2210c2901b40/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625950264e5df2a1f3ae069e
        failing since 38 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-15T10:59:39.653643  <8>[   32.711552] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-15T10:59:40.674739  /lava-6097200/1/../bin/lava-test-case   =

 =20
