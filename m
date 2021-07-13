Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5886B3C69AB
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 07:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhGMFTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 01:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhGMFTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 01:19:03 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B049C0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 22:16:13 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d12so20561534pgd.9
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 22:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gwS0fHldPqPXUifQj7qDjO3/9E7JxgvzVHGlVOA7BJU=;
        b=gP+4F8MUT3xP4L4bU9qfM959zsSXf56pHTLBS40IkeYoYKVzilup9tShfnBn/d6ZLU
         qWoceUNtmg59fZAMPaceZMLv1fvPBO6xzUO8JqsIAga3QhKm1OjLM/tDh7nYDvKEXXb2
         WMGd1WJlZAfSExFM5mq3Zr6XaFMlJUljsMovP/tLXE8n5KhRM0xsm2l1xbGZChaOXyv/
         bQgIfanhBfqZlQFubJRpmz4HsMqXymK/nE4gFMB1ph7NUCfNhjZEMLrRKkPZARvP2z6G
         GBTc+unyzmNQXiUF9TqL+dYTvaLC8XiluuI91NOqmgZOOy/qV0RA0+SW6CbZU6IICbQp
         XzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gwS0fHldPqPXUifQj7qDjO3/9E7JxgvzVHGlVOA7BJU=;
        b=ZezgolAEhXxq1wi4HTO2X5sAkPF2NRunye50BbgsTjDOAHE6qU+VHLeVnkowCTr4F2
         yFRUoOFNBhwRVSeYoYk7GzS7Tl0S8tMr1HXJdbaPYMqPCpjfBvbaHahT7q4LtfcCXi8q
         +w2WuZV/FVj/HKPjBK2lQdQkZum5+eagkjvz9X8CnznxMK4JAZUei4hCc50/Cy1I5Ylv
         y0zr6LQ/d/TIlcd7a4SjSm/i1XVJFkX4LKj7LM/p9kTQ0enk+5/dOZoJVIQ7OMRypvIe
         i9GeN8F8HmhKL7ULJ2syJ7tH3I5ICv+DdmJPniaD1wDQxVezWiWtB2ANxiTK02Av3E1v
         yrMA==
X-Gm-Message-State: AOAM533XRArwfzHmOdwpPsyMpVhyVn9NR0yTN5YrD/e6dpEvsfr7XFIR
        Nb0EEQ/538fWdALSXcxsyEhx4LlqD6Erel8v
X-Google-Smtp-Source: ABdhPJzaXiiV45URrGQvYMSXCZMnjEa8nXL60wGo1uQxozFCf6xI9UJELB+kOO+ia14MxHoPUb/B7g==
X-Received: by 2002:a63:de18:: with SMTP id f24mr2573794pgg.112.1626153372567;
        Mon, 12 Jul 2021 22:16:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm1133151pjo.50.2021.07.12.22.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 22:16:12 -0700 (PDT)
Message-ID: <60ed219c.1c69fb81.cac5b.4f87@mx.google.com>
Date:   Mon, 12 Jul 2021 22:16:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.1-804-gbeca113be88f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 193 runs,
 2 regressions (v5.13.1-804-gbeca113be88f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 193 runs, 2 regressions (v5.13.1-804-gbeca11=
3be88f)

Regressions Summary
-------------------

platform            | arch   | lab          | compiler | defconfig        |=
 regressions
--------------------+--------+--------------+----------+------------------+=
------------
d2500cc             | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig |=
 1          =

r8a77950-salvator-x | arm64  | lab-baylibre | gcc-8    | defconfig        |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.1-804-gbeca113be88f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.1-804-gbeca113be88f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      beca113be88f342762d1d8a512dbd644fa8e36c2 =



Test Regressions
---------------- =



platform            | arch   | lab          | compiler | defconfig        |=
 regressions
--------------------+--------+--------------+----------+------------------+=
------------
d2500cc             | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ecf0dab9b1d15b1011797f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
04-gbeca113be88f/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
04-gbeca113be88f/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecf0dab9b1d15b10117=
980
        failing since 1 day (last pass: v5.13.1, first fail: v5.13.1-782-ge=
04a16db1cc5) =

 =



platform            | arch   | lab          | compiler | defconfig        |=
 regressions
--------------------+--------+--------------+----------+------------------+=
------------
r8a77950-salvator-x | arm64  | lab-baylibre | gcc-8    | defconfig        |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ecf078c9f3d7f6791179ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
04-gbeca113be88f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.1-8=
04-gbeca113be88f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecf078c9f3d7f679117=
9cf
        new failure (last pass: v5.13.1-799-g450544e613d4) =

 =20
