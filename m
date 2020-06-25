Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F4720A52E
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 20:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390621AbgFYSrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 14:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390007AbgFYSrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 14:47:32 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFE2C08C5C1
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 11:47:31 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id z5so3719513pgb.6
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 11:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pHZR3vVZOhWb67XKWFu7uNzT4IizV83chavlvZeAnsY=;
        b=nKl/DL38otxzKE3ytI8mMUtK1E12eFQY1R4yc5XP8vxqNYQ3uxEcVsPhQ0MtBXQRF5
         Lt8c0A1hSBcXZXEadd3QdAsSETGPTm3QxI/SjaDuSaA87kTzt6BXvru+azPxDEwO+c9A
         GGWD2BBXJETYm0rABCEhIp75jiVS8kGc1JuTyDmFp5mYBCRe74VPfT6AtnurzRKoujku
         s6JwLFnWuVNtK9P5nuv+b0NFIKuALk3Y0liTe9fr8ZWpFRBryUJE0TOvdiZ+i/UPFrP/
         GPCQDuR3PH+Ft2QKOStHOs/hCitfGU434Jvc2xUQRWh5RfJGkn8kth8j2okXeRkIrtC+
         PqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pHZR3vVZOhWb67XKWFu7uNzT4IizV83chavlvZeAnsY=;
        b=sFEg9wKpYcrFnqmYKPtjZyRL5BVuELm/DZHo5BeTamdxPWDhJNZ6EBm58pf3v3e2oU
         kQwe1ThiH9G5AVzDMaonL7edlH7OkKEUuAfxkSI8SJLN/ERjE3T/tbrvSbeIlwdFKBc1
         affKwwmm050mCu6UW8j1j/ZQpK9zwmNorxisXv9cHflYKt7wLQBGzUpc9acBAs1W62/g
         2fhqkcoU3fLM1D5taMxJffJZkO7hyYGjwsF/WeRWv6x4REHmCrfApX32WLZPj+qZ0KFj
         ftmf8Povt5eBSjfVj6tW1tRxSxk4BrAIGsnYwTGjVagnxo0kVaqlSq4eogpRzLXWKcdG
         Vn0A==
X-Gm-Message-State: AOAM533EOepqhgsFmZGa13+o6xvU6hnqXgTUYEm5C8Ufs/3SleFRSDEJ
        rSDr7hYtUqeB4yHTalit/yYpxUxDkKQ=
X-Google-Smtp-Source: ABdhPJw0BwwQ+3PYNUfiQhE4PKC4R3HATki3XbWAxulcsDPWd4xKN9Ucktxek3AyH4sa6CqmQ1wydw==
X-Received: by 2002:a63:4c08:: with SMTP id z8mr26496910pga.201.1593110850064;
        Thu, 25 Jun 2020 11:47:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x17sm8885366pjr.29.2020.06.25.11.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 11:47:29 -0700 (PDT)
Message-ID: <5ef4f141.1c69fb81.8206b.9420@mx.google.com>
Date:   Thu, 25 Jun 2020 11:47:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.186
Subject: stable/linux-4.14.y baseline: 23 runs, 1 regressions (v4.14.186)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 23 runs, 1 regressions (v4.14.186)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.186/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.186
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f49027cf4ff06c384e4e16a8d45dc77bf6af3577 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef4be7db0e93c868e97bf1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.186/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.186/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef4be7db0e93c868e97b=
f1e
      failing since 83 days (last pass: v4.14.172, first fail: v4.14.175) =
=20
