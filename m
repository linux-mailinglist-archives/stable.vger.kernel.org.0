Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0612635C9A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbiKWMSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbiKWMSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:18:41 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD75015700
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 04:18:40 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 140so17161442pfz.6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 04:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rQuIOkk+hDo6MRU7wzPKsJsYwmVCwbqYtSlcRb3Agc0=;
        b=uyuer4a7R74uIAi6l+kfkBGIOZKel5fi4bU17YQXfTPk9VQF4LC8Fqi+kgmwRp62q0
         RrCiv7D3mvb8FPQ3ZbBzawNMkJrRe48ZyL+iqWwaaQi6M96VAVPUqSnN2J8fNoBBbMY1
         7KFUjsCZpJYSCBJLuwvSceL2s1fpWxdUp1GiHctJcQI41YXJkw1rmjUeketCoBRh7m0d
         6uLQb2ru9yBWt1hjfx/diii29/ZobAQcQIPghxxBpwOlm5r4pVbXuZCDp4Z0tSpArTk/
         EkRwSTWcv819jCYFIiT3tchBwkNN738S7sOBSjbzDvr1chqSX6UhqqTzY9wAZRSI28S0
         Tb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rQuIOkk+hDo6MRU7wzPKsJsYwmVCwbqYtSlcRb3Agc0=;
        b=muOtc7l9C+XXIHe0s9hux5BWTn6kOm6eAgoC+mjjLrNsHb2vybpUMp4bNxSkbmUj8l
         I52g85zIyL30V/v58iSj3jTEjsPDt8+xHB/xOkQ964/MJ8OwzjKln+uaocxjCeZknfCp
         BJZHM145utEzmi//0Vtbma12oWR9EpdxxzSnbAs1oWbzcIgpC+MunLk0dx8jQpMucGCq
         ECH/Djgcg2nR5FIZDD1gvgiOFHmyPpXHrzPQ5dHTgQ50xn3knCdRJyZV5oxVPMfLFvrn
         vPpRdxhWLxWOnqXbu34uZTSUCfaC7uNLclT5HKvde8XXVWYWomTmFAyGThId+ar7Bk21
         /d/A==
X-Gm-Message-State: ANoB5pkAiAMoaPGcPjPXh13w+JFabqOZsdpWYRJtL/IeLgrHs4fW6W0f
        9tp4t6+I+PF3p9UL2YEgULOYTLo2MPyNCca+
X-Google-Smtp-Source: AA0mqf6tSaliSXpvuVqoE8VBIR2V/0NmNcfkXrY1lz6sDGYRUz3rKYKo0hLXEWDJ7I6BdprSRJnPCg==
X-Received: by 2002:a62:f252:0:b0:56d:a243:7d86 with SMTP id y18-20020a62f252000000b0056da2437d86mr9006499pfl.38.1669205919978;
        Wed, 23 Nov 2022 04:18:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a26-20020a634d1a000000b00476db6fe510sm10676873pgb.75.2022.11.23.04.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 04:18:39 -0800 (PST)
Message-ID: <637e0f9f.630a0220.e23f8.fb50@mx.google.com>
Date:   Wed, 23 Nov 2022 04:18:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.155
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 162 runs, 2 regressions (v5.10.155)
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

stable-rc/linux-5.10.y baseline: 162 runs, 2 regressions (v5.10.155)

Regressions Summary
-------------------

platform          | arch | lab         | compiler | defconfig          | re=
gressions
------------------+------+-------------+----------+--------------------+---=
---------
at91sam9g20ek     | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1 =
         =

r8a7743-iwg20d-q7 | arm  | lab-cip     | gcc-10   | shmobile_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.155/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.155
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41217963b1d97ec170f24fc4155953a2b0835191 =



Test Regressions
---------------- =



platform          | arch | lab         | compiler | defconfig          | re=
gressions
------------------+------+-------------+----------+--------------------+---=
---------
at91sam9g20ek     | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6374d24affdbbdd2692abd0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374d24affdbbdd2692ab=
d0d
        new failure (last pass: v5.10.155-126-gc1a10e1f62eb) =

 =



platform          | arch | lab         | compiler | defconfig          | re=
gressions
------------------+------+-------------+----------+--------------------+---=
---------
r8a7743-iwg20d-q7 | arm  | lab-cip     | gcc-10   | shmobile_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6374c9c65865f54e642abd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374c9c65865f54e642ab=
d20
        failing since 1 day (last pass: v5.10.154, first fail: v5.10.154-96=
-gd59f46a55fcd) =

 =20
