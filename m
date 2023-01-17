Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6009F66E878
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 22:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjAQVbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 16:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjAQV3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 16:29:44 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0D34E50C
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 11:55:51 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d8so2337976pjc.3
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 11:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hlYMSlxa26hUAglAlzFc1VVYGqDE50OqDzPQKwiqyGg=;
        b=lv21erjJ9Af1yqq6TnE1gtk7VVad+PxHy1EtR/q8gvaCl5mAjdGxJZV0akVrJU0RX1
         JliFqXYnUH3rk+3UbjOiVTMHpYrk8HY9q/1GDd0WnQpleFppM48hzOKd4mCe1PyiawHO
         OPw986wWPc+kTA+3erLfq5fpPZdnE7nMMUatH93pqZbs1HwPSVc69TZHdfRvbUeNsoPn
         R1QFsc2m3KOm0giJ9FwnlL04U3W4ji55tPxhMdXYX5YbH6dzcSCQmOnmCoxnRsYqiR4q
         J5/qnXxyB9V2dFpUdR5FjX3owwFKRwfw5k0VLMdQ0vXRfCcg4WcQ8HUaaE9cy9zZWDal
         YfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hlYMSlxa26hUAglAlzFc1VVYGqDE50OqDzPQKwiqyGg=;
        b=Mf4OnitjpDjIe9PfYnKF5P0zUpBeF/IroWJ4eyw1f7LM36WxWu3otab0kWIJir9LkI
         EdabhHJiUKzH2HMVjMNt4Sr0LVRVAV+97xOd2Qa4CGC4nDyL3P1goPs1CMM2fWtRpVdi
         pNZH9ie3eaOPwg7r3GM8lxr2WHD2qKuiP/1ZJBw4adN7q1K8G6xNTmP5j0UTzJvUIBdS
         OsuQQDFEGAm0xnNKRHdOWfglHb+h0flG7zyjM34SxqpqxE9RwFqUVcYYqQyJQ3iEZFKh
         bk4VO3UkK9gbaZna3McCo8Zfmg0bjnn72xFJ3mBM5Q65rRCHyz039/xEzB2EC8/A6rJk
         KFfw==
X-Gm-Message-State: AFqh2koeAPApkdixkloDybWuQOxqB90Ok8fr3Faa6nLWmX29ya68Yt7V
        lAejz9glqryzpCQLzhg6kki2p840oIkRtoAhs6nJOw==
X-Google-Smtp-Source: AMrXdXvf5ZIF4HHR0wcfx/5V0ZO9LJ8/UbmmbYuCulNi8LFZeYeNREF/T/WskS7Su1u8yybyYp8lcw==
X-Received: by 2002:a17:902:8688:b0:194:77d3:627f with SMTP id g8-20020a170902868800b0019477d3627fmr4133123plo.69.1673985350796;
        Tue, 17 Jan 2023 11:55:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v13-20020a170902f0cd00b0019324fbec59sm4218874pla.41.2023.01.17.11.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 11:55:50 -0800 (PST)
Message-ID: <63c6fd46.170a0220.c8f97.78e9@mx.google.com>
Date:   Tue, 17 Jan 2023 11:55:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.87-101-gbe338c42efd1
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 161 runs,
 3 regressions (v5.15.87-101-gbe338c42efd1)
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

stable-rc/linux-5.15.y baseline: 161 runs, 3 regressions (v5.15.87-101-gbe3=
38c42efd1)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
  | 1          =

at91sam9g20ek         | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig =
  | 1          =

beagle-xm             | arm  | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.87-101-gbe338c42efd1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.87-101-gbe338c42efd1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be338c42efd1c76e4dc1392ba44b99a1d45355ea =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/63c6cc9561d42ceef9915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-gbe338c42efd1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at9=
1-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-gbe338c42efd1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at9=
1-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c6cc9561d42ceef9915=
ec0
        new failure (last pass: v5.15.84-18-gbef75c6188c7) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91sam9g20ek         | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/63c6c9ca7ac9056a1f915eed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-gbe338c42efd1/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-gbe338c42efd1/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c6c9ca7ac9056a1f915=
eee
        new failure (last pass: v5.15.87-101-g5bcc318cb4cd) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
beagle-xm             | arm  | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/63c6cab75a64823231915ec4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-gbe338c42efd1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-101-gbe338c42efd1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c6cab75a64823231915=
ec5
        failing since 250 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =20
