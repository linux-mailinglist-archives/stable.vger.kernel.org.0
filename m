Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B590234E93
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 01:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgGaXbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 19:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgGaXbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 19:31:51 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F53C06174A
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 16:31:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id x6so1622060pgx.12
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 16:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G4YyJvWg3ax3eZdJVUHm81llHQMaOR7XPMt+MVUrf/k=;
        b=ofnww+bekpdncdbptwLBogMQREl8dp4FJqcjnaKCbb9urAU0nywuKYBbkTKsrj1qtL
         v3rIaki8lW5mLqK0fFfQDE3tttWTHGaL6NX4IOvG/1ciB17L+MH0YHxivU4H46wPojSo
         KYVbZKNlgtiBXCkg8n5chg3FqVU9GI0RuifX8eawNWmxMMjxgs4CyaWv/oUSWUUb91uy
         esGvo1v81X7tJhDIqGT10xYfnZJbkGCFMP1nKPMA0U82RfAsTssQJzuP7xsEOFWYx7/b
         Z5Rh0OLpctP+3yFcD29GEFfcLm041M0exXluvE1CwerX2YhcNTS2zR3lwNCZI6oR28X1
         cgvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G4YyJvWg3ax3eZdJVUHm81llHQMaOR7XPMt+MVUrf/k=;
        b=lQq2sRvLJzCYpne9EzWHETU8Izs0SXaz76bmquvTdTfwdz1cy73kxXtCxHxAcwiVkd
         R3W1roEuk7V8qWpk6TcImwPyqwQWl3JfCOAbLNpBNrqYQfW1tyE3rJqw+dS3M8OOZ9Wc
         fwS4JAntuNDjRW05yK5YUGEbd/0J+4KfvzGzLgNSHo0n5LB8cfuxxKijUK8ufA2Q2sYF
         kT3wsfxj3ZdlRjtXl0wivnH+/uD+1+2D42xWROnEhRGxBQr4BfcOoor42Kqy7G2CyWIp
         IdWWAQ9Gy+YJlmghVinw6HzI1liJgvWn6LViwiDHh0CHr+CGlX6kh75IdszNYge97ajn
         PBcA==
X-Gm-Message-State: AOAM531Uw1aHCsTfrQJmWBPedUPekj+pOXcjB7cd5J7p3XsxsGrZhk0N
        +J9fm5xtforM3o/MYqyP0okrm72WEuY=
X-Google-Smtp-Source: ABdhPJx0yNP0DC7NljjktRvYE/7SuVMljwKXRvWrxSGV/aXfts9h63wlvvgsHR3HWNoo0EcDlSAp2Q==
X-Received: by 2002:aa7:9d04:: with SMTP id k4mr5733532pfp.256.1596238310563;
        Fri, 31 Jul 2020 16:31:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e129sm11183307pfe.94.2020.07.31.16.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 16:31:49 -0700 (PDT)
Message-ID: <5f24a9e5.1c69fb81.2b446.d5f3@mx.google.com>
Date:   Fri, 31 Jul 2020 16:31:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.191
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 168 runs, 1 regressions (v4.14.191)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 168 runs, 1 regressions (v4.14.191)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.191/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.191
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7f2c5eb458b8855655a19c44cd0043f7f83c595f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f24754b2d8189e75752c1c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.191/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.191/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f24754b2d8189e75752c=
1ca
      failing since 120 days (last pass: v4.14.172, first fail: v4.14.175) =
=20
