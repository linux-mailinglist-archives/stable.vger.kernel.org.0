Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86293FA2A9
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 03:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhH1BCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 21:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhH1BB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 21:01:59 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DC6C0613D9
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 18:01:09 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w6so5032566plg.9
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 18:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+nmxVrtzUu3kk87OZDs1qDsqRhzc4cHgKO6SKigGRIM=;
        b=ExQPVBXDb5tSJlqBhSwQQrkE9kch3RdrJHzXQZ/IFMNmNaqt3s/a8xaEwiwzomIGMV
         2Qkj76Tj6WNiiN78Dq5g/0OqeLEo+bP27mkko/TT84vFX8gO620JHbFTcT84TKTZvR1u
         a521Ie5kPO6/Z8FoYAobi+RGt4FqNXo4fZtxBkBzI1RNAvwLMZ3s8SXYUFMPe4m4WlU7
         HrGSQCNSrY500EVyWP+BNSJQ4b1PHd2B8m9IchFruER9CbMCbyCbBnZhzLvbtDlHp4vA
         Hw3MjhWvJsuqT8kw66G6omccbomWsnPnh02OyesD8GZIZLiIiGVgRWEIK2FIyeqX0wVp
         9YDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+nmxVrtzUu3kk87OZDs1qDsqRhzc4cHgKO6SKigGRIM=;
        b=ocu43PBbd3Y0PfdRnODMYXYkaeJqAPtMTSwEqs7+wZg9jU1CrvaJ0kv2bCirY2kRd7
         gI9RmdPy+ofa9bEmk/3Vr5U0M2QDPmqjVtnqq/FfW98E0bXwaJy0NoxljOF9c1em5Pla
         drtHyvVpqqQbfOS1v1+FW0DzH245+EwHee5EoGuHEIz/jVSGhohHssxWmr4kTlJVbpaE
         XPiAcCADeQ7u5ztZBVwT/qlUYUjqEMOtaQg6g2H4x6sU0TJ8NQt/E5CWCNhhEBPmgewK
         DrsK2XS2paNKk9EPtok83iY6Ax1suAmlZlOvpr0NgHN+5Z1SKb9GgeTQJgk0ZWsiRhzj
         SWgQ==
X-Gm-Message-State: AOAM530K7ad21qbOzJpUr7Z5S1xLHj6ve8UwpFsPZD6EQ+uhjqz85ARF
        TCWW/4ppj6jEG3gsnjGmrat38m2UuDNr7FIN
X-Google-Smtp-Source: ABdhPJwCbQT9nvsDTJZ1btWgSMvyuxXhsgazqq2vWA/obTYWTLQySndnqSsnIKGYXWa9M6Lg4ToN4A==
X-Received: by 2002:a17:902:9a47:b0:12f:6a05:caaf with SMTP id x7-20020a1709029a4700b0012f6a05caafmr11177028plv.55.1630112468836;
        Fri, 27 Aug 2021 18:01:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x14sm7262836pfa.127.2021.08.27.18.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 18:01:08 -0700 (PDT)
Message-ID: <61298ad4.1c69fb81.7eb4.427a@mx.google.com>
Date:   Fri, 27 Aug 2021 18:01:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.143-6-g09e44942ba1f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 156 runs,
 1 regressions (v5.4.143-6-g09e44942ba1f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 156 runs, 1 regressions (v5.4.143-6-g09e44942=
ba1f)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.143-6-g09e44942ba1f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.143-6-g09e44942ba1f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09e44942ba1f5e3fccb88f19addbc2ef88948f3d =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/612953195baa8ca6188e2cb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-6=
-g09e44942ba1f/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-6=
-g09e44942ba1f/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612953195baa8ca6188e2=
cb9
        new failure (last pass: v5.4.143-1-g6df473a6c1d2) =

 =20
