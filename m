Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144F7222648
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGPO4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 10:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPO4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 10:56:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BF5C061755
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 07:56:23 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q17so3969744pls.9
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 07:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gWplR0RRgyGVu0mgK8+EFHN/GvFKQfnOS9W466SFoF0=;
        b=zytRKLkKV9Q7IIVpqR8klbh10WNRf7zqFlFHc6tSC1dAcftTTsO9vkIlusSj6ujayH
         kRqZ7phhx9/euzWw776njCuFVlWkYeiErn7hmWzo/XM7LJE2w8IPuDrvOGlpFPPKmrSw
         W7VhGN109bgwQi+MjoL57szYV6gqFEU5slBgU8b7ksKD7vqoBPCGaTzJ81RURMqOhx65
         Zu26tw4DbPW4LwFZhD8FHkJmIyvh8uWI1GXzlrEUAoJvaOGqiinRvwui6+4pN3K+cFQY
         njEs8rvrDBwcxx9Erp+OHpLE5WSGbnfBro0oW/VBSjT6aVK+eybawu4OHvWlcTzvc5vw
         wWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gWplR0RRgyGVu0mgK8+EFHN/GvFKQfnOS9W466SFoF0=;
        b=mFPJf4aOxrIYwh/RMZbMVfb4o7ek67KpCxeSVPM3mDqqC6J61XLYA2im5rtI/UySbg
         N7fbkkgJvlNoGP8FysTli3GQFwBdKTaIRiWwgFImUpmHpkeJLTdsuDe1WF7vl8tPGQHT
         uy9+85bKmVZ8B09jRbpHOjMYPlAT/Veutz7dfV9WJsjB3H9+/Ia3McrYJx5IU5rJ7vue
         2AZN8VeSWS4VvVJiXr9nSTwLEsCvQ5nFT1Aqb2yExoMKsxAtYmL5JYXkFUTugnJWapiA
         7Mg0vpoK7pnRtwWDHRhhAdQBy7YypKa2hnxjQcrWZqPfK9lq5XZb1eYTvzJJ7cELHtX+
         xZWw==
X-Gm-Message-State: AOAM531+E8UFuhcu8bw+jHThAcztEYqOGGH0L8C5VMtBRKaDFLjuF0Ke
        XnWD53bJOb+pYIrjXmiQU9fsZpF4+4E=
X-Google-Smtp-Source: ABdhPJzDgoo/iL1JeeQnoOdgkBsC8y/4EzJiFW2NhK22MOIMNlr7Burmh+KnqSHsGqe2cBuoUSN5ag==
X-Received: by 2002:a17:90a:bb84:: with SMTP id v4mr5573081pjr.162.1594911382690;
        Thu, 16 Jul 2020 07:56:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm5363668pgr.69.2020.07.16.07.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 07:56:22 -0700 (PDT)
Message-ID: <5f106a96.1c69fb81.72bd4.e8a7@mx.google.com>
Date:   Thu, 16 Jul 2020 07:56:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.52
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 123 runs, 1 regressions (v5.4.52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 123 runs, 1 regressions (v5.4.52)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.52/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c57b1153a58a6263863667296b5f00933fc46a4f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f1036c345d756d97b85bb3f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.52/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.52/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f1036c345d756d9=
7b85bb42
      failing since 14 days (last pass: v5.4.49, first fail: v5.4.50)
      2 lines =20
