Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137014D27B4
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiCIDSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 22:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiCIDSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 22:18:44 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242FCB16C6
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 19:17:46 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t14so845525pgr.3
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 19:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HtiDLxcGR4fkuVHGLhHcoI5H+iC8g0RVfAhJvZz2IGo=;
        b=FijGv4gBhRML6rkSnzzTApZZenCbosjeTvoRGHqkvSl5LqsDHaa27ZpJTbaJH9CXoA
         ZT6Q8QDnZp/AMpxaWvtvSKGJVzqamRDacEIGIOOKxF533P0LsflsJtgPBm4B3hLF8wQ2
         trSFHcXBgM8Bc6Eq4MPZYcanJRHgzjzeKlWJPEj7C8jNJ1k32Beu2UjUv46sW0RBk1mR
         I6v2ImPs5TQdKLX70Ps+e2c2yRNPPHU9ZdvoG4gN2EFMPMBQsIDRjtvrO2jo1TDiSMkP
         YH86BOz6DSO7D5/kwm0AylS7xr8UJYNbNpBBTEY5hpE/mRnYS3xZDbnt9GeGhHAVoUhT
         hW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HtiDLxcGR4fkuVHGLhHcoI5H+iC8g0RVfAhJvZz2IGo=;
        b=7bb6fSLhMJM3qQ3P/ViaYTUZ8CWZNVIgTJC1xodB3kd2ftyM6GBNCf+NNKr0wb64va
         LBMT7WVSN8kotEWWjR+2iRiO2Q17AW2aM6sUhFKDsBH7sgdprSJRQkCLMKvr8Eis8/Nw
         mWUHzm/So1tqrAKztrUdzZeFh67HNNl6LYU5csreEhkrpV/Xq3n25A65l9qLO1Ke/w2d
         mHWLmVjARGr6FvIXl9b8xrnvD2ve1BxbSlvMmiROSRM2p5DXWhZzrOvSVbCcISy57nag
         3FOR9kkHSyElhFn2is7W4PYRcczWdKfPHMMVNWCmr2a5Fe93PeQH2qrB8AsQEFT8uzz4
         vXxA==
X-Gm-Message-State: AOAM5326W/waOZpe9V0Tm4M5e1QetrrTzIfXObg2b+ScnH66e5FAQW6/
        B0tZvegh0z8yyI+35I+RlH0vO1WaT170495xePs=
X-Google-Smtp-Source: ABdhPJxFZ1V7V5V9srT4eBPVoTQwDJC/VCRdcq2AUCRlL8+0F3rz8hxKx8yVpCEFFv2maBrkhNvJ6g==
X-Received: by 2002:a05:6a00:2392:b0:4f7:158b:aecf with SMTP id f18-20020a056a00239200b004f7158baecfmr10417584pfc.52.1646795865455;
        Tue, 08 Mar 2022 19:17:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9-20020a634e09000000b003790829fbc1sm481802pgb.53.2022.03.08.19.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 19:17:45 -0800 (PST)
Message-ID: <62281c59.1c69fb81.7a880.1f44@mx.google.com>
Date:   Tue, 08 Mar 2022 19:17:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.27-41-gdc13778fcd7d
Subject: stable-rc/queue/5.15 baseline: 66 runs,
 1 regressions (v5.15.27-41-gdc13778fcd7d)
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

stable-rc/queue/5.15 baseline: 66 runs, 1 regressions (v5.15.27-41-gdc13778=
fcd7d)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.27-41-gdc13778fcd7d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.27-41-gdc13778fcd7d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc13778fcd7d7aa4ce76b75adbfe50240415b55c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227ed32d66c100037c62968

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
41-gdc13778fcd7d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
41-gdc13778fcd7d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227ed32d66c100037c6298e
        failing since 1 day (last pass: v5.15.26-42-gc89c0807b943, first fa=
il: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-08T23:56:13.670669  /lava-5841639/1/../bin/lava-test-case
    2022-03-08T23:56:13.681704  <8>[   60.890249] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
