Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6244FDCA5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 13:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbiDLKhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 06:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356420AbiDLKeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 06:34:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543785BD33
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 02:35:30 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y8so11835391pfw.0
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 02:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a+mcYcKNUZoZDEZ85Q4lSwyG+glgm+CFqSjsQC+B/vY=;
        b=crNsjLImo8/KiLbU1/5ipXdrutyVSGiUCZ8AqSjkKom7Ss9Cb+I2vj3n6oK/XZya7d
         CclghdrSxIG3vxvFTP7y7oRluqtRmkaK5WGKY6kJ4Www5VdYGLtWXdNwAUKCKwOGqh7k
         wrMREDIC7zJekA1UK5P7NniGQnSuEHRKvoS85NnSLYmdVR6WTXmdhOgP3rXtTpwH9Jkw
         VoIb8cgyaKKyxKm34m4WlAqnnxggvygpmnLCUzGJKTKvmNvO/7Ofww2ywkW+a8AQt5P9
         30NytAQY/G4QrXYrj51WSAXJ1vy+CtZbMZpHNB0WDmb38SZDS8XJqmP2L3oh64AWoLav
         XrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a+mcYcKNUZoZDEZ85Q4lSwyG+glgm+CFqSjsQC+B/vY=;
        b=ptOQrpbZqVvZ744vtvE+ClaH8CGydzSEPX3NAYjNUdQgbs7KdNRpBWXP0gVr4W6OSA
         iXMFSD2xBptoJuw/DHkSciVpA/sE7azl1DdhcvOKLMyw4Pam6M3El3+2ePJKlt6nqu0C
         cAZk4+QOOWUh4rrLVE6KZyGKzrXQsiyfsu9ByxxrUMi9tZvySQIjmWz1J3SlxsMHmToe
         2kCzeD4qju6UWxNpfD0dj2Nv44M7IVAlOdivhI5SOToD4PFkanFkXiRULuzSqqfI3Q08
         /KoP7aoeKrVPJ6OHBf5Jx7IXQ4UE0eg3jsKwZ6HdkWJQRaO8qwc43oopXrLmovLmoWMX
         +soQ==
X-Gm-Message-State: AOAM532VLO/cSh29wVE9XcZQULbbpE7HKOxXi/pqiqYg4sCXZRb5zlNu
        qiH/5qNkhzTE0zY0RpjLDV/u2QDA1Awr86a0
X-Google-Smtp-Source: ABdhPJxVBt9NQz2VSydr2axEqLFhqijXzqcSrbhJrr1q0md5mWwaiU+bOu6qhVCpkK5LIugb8DA+kA==
X-Received: by 2002:a05:6a00:15d0:b0:505:b651:5b96 with SMTP id o16-20020a056a0015d000b00505b6515b96mr11201059pfu.6.1649756129515;
        Tue, 12 Apr 2022 02:35:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 35-20020a631763000000b0039d93f8c2f0sm1762654pgx.24.2022.04.12.02.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 02:35:29 -0700 (PDT)
Message-ID: <625547e1.1c69fb81.dfd83.4902@mx.google.com>
Date:   Tue, 12 Apr 2022 02:35:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.110-171-gc7e3c39c7fa2
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 119 runs,
 1 regressions (v5.10.110-171-gc7e3c39c7fa2)
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

stable-rc/linux-5.10.y baseline: 119 runs, 1 regressions (v5.10.110-171-gc7=
e3c39c7fa2)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.110-171-gc7e3c39c7fa2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.110-171-gc7e3c39c7fa2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c7e3c39c7fa261a1646a4cd890def9f3ee612deb =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625514451f17650648ae068c

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
10-171-gc7e3c39c7fa2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
10-171-gc7e3c39c7fa2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625514451f17650648ae06ad
        failing since 35 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-12T05:54:54.674271  <8>[   32.935131] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-12T05:54:55.701855  /lava-6070397/1/../bin/lava-test-case   =

 =20
