Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84132468CED
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 20:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbhLETOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 14:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbhLETOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 14:14:21 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005F1C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 11:10:53 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n26so8163418pff.3
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 11:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KC7XTz0ArqWJicC1q+YqZHYkRk/fD2tqjk2NyYifhXA=;
        b=IO1AwksTskoynOEx7sLjGDCLfcyeP9n3cx6Ry28cFXfYa6WM/ngfP66WtLDdTzoA36
         zgf+2WPZBL1PPZxRTBR0PXmzvknivGC9e+Rcu3ZzknUiCJbWXNccwWz0qwDO27NaeJsx
         gQMzdYL/F+Kp5SwGonMtolsJ0X9Y+syPMT8QYI3en3b1t+XMzKkP//+vyeHIdenSHC9s
         +2fpDL28CkqIQ2CdMhQZwEos4eVXQpErqRVYO/zylM1l0XuZ4bgoAXE9hgCFJWJpWLIg
         zswXgm0JH2ijE4+14ohLUcM8VHafStYwYG+taAX2ZYXVp1NIMcUGI9oRAYCJmEjw5+Jo
         VLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KC7XTz0ArqWJicC1q+YqZHYkRk/fD2tqjk2NyYifhXA=;
        b=lGB2HarWhcUTaRmTb8tnvSo4ehrbL+ma4qrWO/WB2M6Ktgrwo/bWsPtoiU6jqSfg4Y
         LdBTzirwGafPbwEOgQg+9eOgamFsNQiJpT7ut3PrFxGh78znmNecQzC5s2jIQMkCUuuM
         rrRECAsIROPiVaf/e8UK60EkaK4F4UrHCd89qXgBSzEs+7IAO5q5tR2fvMmdMtD0FSTB
         VkAtPZDt3Fk+/r80Ja80sNN3ok5bXPgIEee8IqL4SdLjg7mACzq/B2ic+olZ948fZAXd
         z5ZZ2N+cT3EkGKEPILVj/3o/k9Uz9+HFAeuEumah7MLkAk8wPCJtopE/8aWoiWDUvK63
         nKMg==
X-Gm-Message-State: AOAM531i8zZn8gLoP6SVkimu6smOlw86E4cnBC1F24rqSzL0J/6tSHeh
        Z1KJIrLXo8ySu9PjNRsjQF5SvX7Ohs+aD9P/
X-Google-Smtp-Source: ABdhPJzkY0lC+5kEoU2wRWm44u1NXU3SV1NFhgwyVkeivzzzfzkX36hygpZ+9brp+OaeVwSHHS1aJQ==
X-Received: by 2002:a63:db08:: with SMTP id e8mr5356768pgg.212.1638731452927;
        Sun, 05 Dec 2021 11:10:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8sm10493007pfh.10.2021.12.05.11.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 11:10:52 -0800 (PST)
Message-ID: <61ad0ebc.1c69fb81.4d954.e15c@mx.google.com>
Date:   Sun, 05 Dec 2021 11:10:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-96-g0a8417bc52507
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 107 runs,
 1 regressions (v4.14.256-96-g0a8417bc52507)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 107 runs, 1 regressions (v4.14.256-96-g0a841=
7bc52507)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-96-g0a8417bc52507/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-96-g0a8417bc52507
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a8417bc52507378468bf72ba2c9f357c48eea04 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61acdc2644179001141a94bb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-96-g0a8417bc52507/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-96-g0a8417bc52507/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61acdc264417900=
1141a94be
        new failure (last pass: v4.14.256-86-gce5b7722e4968)
        2 lines

    2021-12-05T15:34:47.717538  [   20.042022] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-05T15:34:47.759947  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-05T15:34:47.769431  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
