Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78211F4BF2
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 05:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgFJDyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 23:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgFJDyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 23:54:10 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D7BC05BD1E
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 20:54:09 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s23so507075pfh.7
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 20:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j+uOPiD1+uffZW+5MPGvLTuUK8jpLzePaNxJkM9kSbQ=;
        b=HWThd9Yj9cweZf+6NzNeBS+Yl9dg7lVt8UAD8lK+jwQyBR9kgGJJs4k1DxLRYK5N3B
         JMmH9ADvjK30vKUtvM92jn7vAo5pI7nFgta2TeNJ6yGVLPtg67Hpf+zlG22c7kbbyMWk
         +OaQeWXpKcQGnDuScc/OQI7ApgwjWwRT+XltVpGtSJJkcuPnHN/q/bbxW4O1Z/aNWdNw
         LfKPDHNYl7lD0worcOe+dcXkyjHmGS0Itk67VjxRqB1q8T9vlvCEdSFHOVg5eBkT3Qxx
         kKSOoFzX07QJV673a8KvFsb6nW7TlYjUPybutTpyAW9+z8Hv8h49QFoAXp3LMPodXj7u
         wGQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j+uOPiD1+uffZW+5MPGvLTuUK8jpLzePaNxJkM9kSbQ=;
        b=H3l32K0ITV0FJwmVfUNlHj5A3fC0TtdZL1uuD5OkVB+6PCyRqPMEVt5V+bokzBzoBo
         vx/LtaV3J955/7QWlhIZ1+UCwCf3cUmWMV9DZUB7/1fyysbg23ESLLfwY//79K2s7eom
         7F2SDL/EnKDcVKdjDnU0pOEIhfidXWqQR2lf7SBmFX6GouQWc90V3ttgEU0tITS4l2kt
         vIETKiCjeq1cwmSs8LE3Y+5T8MwELrNsc/zZjPpq371h8aSIo9uHh10iKpNyKr8eP8F6
         vH1ACzqOHS5LT4eqqbgb/79nD8rFhsAXbVh7mHmVflscq5sS8k+5BMfLcTPP/dEV7Op9
         cO7A==
X-Gm-Message-State: AOAM5313BKwY7dL8+NZrMYsR7v23JXOw5Up5HCCArajujLfo7zVk6mzZ
        wcSzbact9QIZnlqbDpsG5cGmZsh7kSI=
X-Google-Smtp-Source: ABdhPJwKVgZaEq7EEdSkpLqHvrsFZaaz5HTplNu2gtsjEAEzkdCfJl33N/rBLYioXJVTluK+xA1/sA==
X-Received: by 2002:aa7:8506:: with SMTP id v6mr920886pfn.303.1591761247732;
        Tue, 09 Jun 2020 20:54:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 140sm11035221pfy.95.2020.06.09.20.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 20:54:06 -0700 (PDT)
Message-ID: <5ee0595e.1c69fb81.74e6c.7f1a@mx.google.com>
Date:   Tue, 09 Jun 2020 20:54:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-74-g12a5ce113626
Subject: stable-rc/linux-5.4.y baseline: 103 runs,
 3 regressions (v5.4.44-74-g12a5ce113626)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 103 runs, 3 regressions (v5.4.44-74-g12a5ce=
113626)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =

bcm2837-rpi-3-b              | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-74-g12a5ce113626/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-74-g12a5ce113626
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      12a5ce113626ce8208aef76d4d2e9fc93ea48ddf =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee021e0dfe930cee497bf26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
74-g12a5ce113626/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
74-g12a5ce113626/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee021e0dfe930cee497b=
f27
      failing since 59 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
bcm2837-rpi-3-b              | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ee0269e71fd33cd5197bf1f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
74-g12a5ce113626/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
74-g12a5ce113626/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ee0269e71fd33cd=
5197bf22
      failing since 4 days (last pass: v5.4.44, first fail: v5.4.44-39-g0e4=
e419d5fc3)
      1 lines =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ee026f56e947426d697bf22

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
74-g12a5ce113626/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
74-g12a5ce113626/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ee026f56e94742=
6d697bf27
      failing since 4 days (last pass: v5.4.44, first fail: v5.4.44-39-g0e4=
e419d5fc3)
      2 lines =20
