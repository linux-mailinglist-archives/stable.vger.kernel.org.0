Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD4A22A710
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 07:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgGWFsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 01:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgGWFsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 01:48:16 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E53C0619DC
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 22:48:16 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id w2so2498898pgg.10
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 22:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JwZkDrgGL/UksDPtmTihmYBA/5EqOYtVUrdjL5liovE=;
        b=tlnU9J8lhxyvuLlMvi8OjiHErQ50eVT7Mcm3WYU3vCVa2lvn4H20ZwatOTfwg4+cnk
         Wsg6oK27xZq1U/L/JOw7sWjv+Fn+zWsvWYddA1+qfY2YILT5eGAGYvZmKpNPVVPGuW+w
         jBVBmCc+2VjoJNg0g49xm18pb85ixnHFdmMGhatvreM+XyRK6+2W9g9Zps+AO9O3O51F
         uEKJ913ROjv/3kaObQXtjfTGMK0EmgAghGvJ1s0G/NzWrRYQHoREbWdD/sGFBKAYFNaU
         z8SfR4zjuuOMCbiIPHuweHX0GGQ5Ksn/QninbrHHLzLQFJJKsk7FQjJk73SKj8UZL19M
         8Wcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JwZkDrgGL/UksDPtmTihmYBA/5EqOYtVUrdjL5liovE=;
        b=aa9PYGXUemHSZTOGwdRjanlA0fbBPokloyV5Kgri2nip9SPUnn4Xpc2uMkpPVMFyjB
         /td3Hf7wqS6wXyyP5LbX/IRv0xpr0IkQCCldWKBqRp8k+f/7HKHcSQJi/bYGzmti2CJB
         83TvOYPY1AyrJLQd8fJloQN9Czy9i1AuXRzhsMV2NXZGFSNojVjLq4mnwbO3EWzalXL3
         +ckxaYkqx+N3enXQM0rYgT6FiItQGcYSCjU0PGWS5wTsAcgMv1gBGhMH67uJTVIxl4Hd
         XzVcsT377YLyZS4NIkue1S27By//hPUsbMe2nM57jp+Hhp8dfs+7Qefz/wf0qRy+H0jg
         mTPA==
X-Gm-Message-State: AOAM530qTdXJnXPYk7okdAf43pnHLUDzwp1CM01wEnGnng6Yi86ZDJ9q
        GqfU2263LCtYuZ95EPHVHEUOa7zz6t0=
X-Google-Smtp-Source: ABdhPJxQuJbm9K0tf+WBtjVu5ZfIoOmbIKX2KRjT9TKXDMIf6bSLWVlJncEdCizu7U1et/jvCZ+o2A==
X-Received: by 2002:a63:3e09:: with SMTP id l9mr2916290pga.235.1595483295327;
        Wed, 22 Jul 2020 22:48:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 204sm1478087pfx.3.2020.07.22.22.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 22:48:14 -0700 (PDT)
Message-ID: <5f19249e.1c69fb81.9599a.56c7@mx.google.com>
Date:   Wed, 22 Jul 2020 22:48:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.189
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 155 runs, 1 regressions (v4.14.189)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 155 runs, 1 regressions (v4.14.189)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.189/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.189
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      69b94dd6dcd14d9bfcba35a492f5e27c15cf4d0a =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f18bafd92cae881cd85bb1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.189/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.189/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f18bafd92cae881cd85b=
b1d
      failing since 111 days (last pass: v4.14.172, first fail: v4.14.175) =
=20
