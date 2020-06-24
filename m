Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3942D207606
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 16:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391165AbgFXOqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 10:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403975AbgFXOqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 10:46:49 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6968C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 07:46:48 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id bh7so1131794plb.11
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 07:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kyDmjMZc5qXDYHMWmSaSNk//kVzuzWGOpPsJ4VbITxc=;
        b=R3iv0ABVxFLqjI0BTH1czih2CmlWMbAfp3iKBk3VFOM2mFM3hSeZv5e/WrEb9YZ876
         Zy8DeC4eKVd3NGbVE45QN6IB3nxjrHVWNhoCXugkYOuWe0n0zW6wTM8sUskfMuE6y2s9
         w2eqvBzJLpR55fXoquCRRv66kmV+txgeFEjRVTSt/zWNYzuPBMw8hBgPJng+LE9x+a3p
         3zJ9PvBCS7Ox+twMqQBzai4XO9kg6qEscyQ1eXN27rIGQELKzZAEW5eUI3WPwA8kSw0k
         HM4RAovSxvnXgale04XOsfzgoiSm8vkDCYx2qZBg+cdEJa/1bhIM0SBAKh3oQePfnM21
         Zxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kyDmjMZc5qXDYHMWmSaSNk//kVzuzWGOpPsJ4VbITxc=;
        b=kB1VCmNLl6WpTqZ4LfIq0hRAz39TtrqXV/Z9QfccrQl6k2x9Aa/M4spHplASNITonj
         oalu0rmbYk8utUYZ+CnZknS5eHoigvvbl99rBBUOJbPczmrPSnN/brGaN6glqVN+27t5
         cHBjdmBcWKByqGtGqfNA50ekp7pHz1FM9oPSpk+aOJMtq0dejVktmrdMrEkhonbXf/Yj
         lVrcMERkB2bBuibaXVNio2ng0KrfOjSH+UomZtND/g5CIcbZ0CkewWnlxJXSlwwppyW0
         /vw9gAKI5gH1o+/pgZxVzIPKKHhWqaPu7eEjNd+KJdSCzkocQzvF1pc1cz6qCLoJxVSn
         rvRQ==
X-Gm-Message-State: AOAM530dGuC1lYpyfzA3JXqXXoUL4C1oa16oSqpMCoD7DeRrcltI0o3b
        8e56mMK3NvZwnQh3nX3noOchT0szpLA=
X-Google-Smtp-Source: ABdhPJwdivZJCVuMP4oEAzV3KzkSH9FiRqgpQg2f1opqTmaKAXcZEYNMeaepqkAqw1EKMC6pK8rVzA==
X-Received: by 2002:a17:902:ba81:: with SMTP id k1mr28955361pls.218.1593010007865;
        Wed, 24 Jun 2020 07:46:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o8sm9853361pgb.23.2020.06.24.07.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 07:46:46 -0700 (PDT)
Message-ID: <5ef36756.1c69fb81.c426e.d38d@mx.google.com>
Date:   Wed, 24 Jun 2020 07:46:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-778-gf7f032930408
Subject: stable-rc/linux-5.4.y baseline: 54 runs,
 1 regressions (v5.4.44-778-gf7f032930408)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 54 runs, 1 regressions (v5.4.44-778-gf7f032=
930408)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-778-gf7f032930408/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-778-gf7f032930408
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7f0329304087129517c90fe7d149309706936a6 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ef33135f4146b03dd97bf20

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
778-gf7f032930408/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
778-gf7f032930408/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ef33135f4146b03=
dd97bf23
      new failure (last pass: v5.4.44-781-g065c1728d31a)
      3 lines =20
