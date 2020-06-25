Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6E9209822
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 03:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbgFYBQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 21:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388961AbgFYBP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 21:15:59 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC51BC061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 18:15:59 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r18so2456924pgk.11
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 18:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nb570QuvklqS1J6VeIpiNQzFo2ivd+yc1zsqYu3Fuww=;
        b=tXr3ZtcpFHNjn+h7nqqbaZYQv7NT8GW8aNl6OOrXBSp/488Q8R8dzIp1JSJiOvRMH6
         FSt8qmlyV2R9WBgZgGUQpDQwedPQGrKoX7VEp8mom8cGB3oJF3tU+oUnIDfQ1K/cZ+yR
         tKeF+nx89PU6yJrF8QeZ2Z1gH1wLsB/6yRBUWAhKaZkyh/Vk+AYRUv2KEZzlaJ7qKKQN
         tDE/T4eDiES5ZJJYG7TCXVOmJ6aJbTXc9Sp+RT5Bucp844yd7VbbMMu8DtFe4mECOOoa
         6w3+j4XYaKnJv0lzu5iUM3QWdOMLs+1gU/FhgqXDqHz9EyYJuDI4UTt2Uz43l5hbvhIA
         GMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nb570QuvklqS1J6VeIpiNQzFo2ivd+yc1zsqYu3Fuww=;
        b=RS8bEl/b8AyFaWqQSyGvKdVRKQOxzZfX4AXCV8OUT0CWAGowXK0cTUZRLwmF7UoxaL
         mBGsnKhZ8PlOsE7LCQFP12p5xr8byARld1kLtXbgsrlEpMz5GdDrxGibtZ16i8DiocMD
         +c5OcYli/WUk0/EGJ885pFglUIw6wVt9m0f7kOM7/1SSZ81C6vTeRC2e/ujriirVKmnZ
         K+w1/r7+h8s8QiinrpR0qvu30SzsJzxyjCPDMyFGPB8ueOVuUc1kxZq9/jaXo8FqLIEU
         lPVPAUd6XoFMWqLIqRrr5+vaHngTuH6ajlMFHkqbFYLUutEc2hwtE3tA9o0pz0prf7un
         1pvg==
X-Gm-Message-State: AOAM533erkWwnflfVacOlWVZ1Kxd+qQfcKjyMzVk6Y47agTmQrsmIAZL
        cBg8smdvuia6IaQUTJ3UtFQSEpnQ7qY=
X-Google-Smtp-Source: ABdhPJwihFSNpnP8w8dZenB5R+Ke1pd4KRhLmsfPrcjvCaIlnZJvTtze2PRu2tEBCQsUUXG9TOwLqw==
X-Received: by 2002:aa7:8a4c:: with SMTP id n12mr31983250pfa.326.1593047759027;
        Wed, 24 Jun 2020 18:15:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u35sm17894097pgm.48.2020.06.24.18.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 18:15:58 -0700 (PDT)
Message-ID: <5ef3face.1c69fb81.3b4d2.6ad9@mx.google.com>
Date:   Wed, 24 Jun 2020 18:15:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.185-140-gac53308e6db6
Subject: stable-rc/linux-4.14.y baseline: 68 runs,
 1 regressions (v4.14.185-140-gac53308e6db6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 68 runs, 1 regressions (v4.14.185-140-gac5=
3308e6db6)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.185-140-gac53308e6db6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.185-140-gac53308e6db6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac53308e6db6ce8390c6d53f003592db921c8748 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef3ca68514958697f97bf25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
85-140-gac53308e6db6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
85-140-gac53308e6db6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef3ca68514958697f97b=
f26
      failing since 85 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
