Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4E864197D
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 23:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiLCWdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 17:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiLCWdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 17:33:06 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91941277B
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 14:33:05 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 130so8021635pfu.8
        for <stable@vger.kernel.org>; Sat, 03 Dec 2022 14:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eh+syy6XN8/ushSvQKgpI0AdXF2qcXvMm3wQ5D68344=;
        b=Tbp5tc15rPQU7gSoRiSpg+Io4BR7sx7Y5vYMQ7Rq+vCpIgBSX+aPR9LDwgzBCLbO9O
         FOKka9Mf2T/93L7MyiALn82o2aUw17bKAnQq5pvMxGHR/q7XGQdh7YgOwJPq9yhYM6uJ
         L41z9Z6iv96ALqO5HoMEjGV9PrnZLQEyb3gmHBWTcpph03OH+oc9dBbOEuXfOC9GTuvs
         mnF8PCFmQqu4ZmmtwDRuVDnE5BfYJE/u32Fw6HxcLQcA/LWpiCmV632GBbicPstrjRga
         AXf8DEwq8PmdVwzxQvc+sfdEaVB09rv0uBrBKz+SI1wPsTgZNfLlevKPbunXWBZHtTwg
         w7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eh+syy6XN8/ushSvQKgpI0AdXF2qcXvMm3wQ5D68344=;
        b=qNVYyhEHPZMLBibXKOGADY92Pa2eLRY7zrKt84G+jrv3j2eEadPpWrXuMJsTa77oc8
         e13m19gbyEO8Z+5vy/egOUk2JW6lVfbVLNECc3Bf4e6BQkWnhsvJ+/ODL3hhsQed5a2Q
         +u90JijSpb5xEhaAwOfQU+OSQzlydun0lawX0PwpXX/PtBegtNf6MLpg0+s5mBulL7bg
         EWVI+io6lw9UZsoLw/JWcT581MLhRWYof/f/ppZ6yake3iaK2++GPjs3Ro1knuDlDXzZ
         F1cJYZ+09Lc4hr9v+wi5Bz41y7uhAVIQhS1bW9ty7zBD/Q/Dl1cpsr150HzIYjThB3Y6
         PT0A==
X-Gm-Message-State: ANoB5pmS80oQIHISQfUYR7QRV/ZZ6EG4UHSKJPISHGQ9VuYzc8RCHapE
        2vtuGdkCotWUJoMoT3y19AnKWAhMS3n7OJOOQ1fLWA==
X-Google-Smtp-Source: AA0mqf4EGYDcj/P0FCv5/ES+pHyxac1+Iu4zZOHSLFRs/5qyCYnlRSW4mOeWch1z7q16zlu0yZOFbA==
X-Received: by 2002:a63:5f83:0:b0:478:ab05:4da9 with SMTP id t125-20020a635f83000000b00478ab054da9mr1304199pgb.369.1670106785037;
        Sat, 03 Dec 2022 14:33:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13-20020a170902d14d00b00188f6cbd950sm7781415plt.226.2022.12.03.14.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 14:33:04 -0800 (PST)
Message-ID: <638bcea0.170a0220.83552.e7a1@mx.google.com>
Date:   Sat, 03 Dec 2022 14:33:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.81-93-g6fa237c94d97
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 122 runs,
 1 regressions (v5.15.81-93-g6fa237c94d97)
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

stable-rc/queue/5.15 baseline: 122 runs, 1 regressions (v5.15.81-93-g6fa237=
c94d97)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.81-93-g6fa237c94d97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.81-93-g6fa237c94d97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fa237c94d97f5ad01ae67781b97fb8a4be3a6ed =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/638b962fdab85161a92abd19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.81-=
93-g6fa237c94d97/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.81-=
93-g6fa237c94d97/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638b962fdab85161a92ab=
d1a
        new failure (last pass: v5.15.81-87-gedea17cf07b5) =

 =20
