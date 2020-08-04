Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA6623BC91
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 16:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgHDOrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 10:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgHDOrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 10:47:25 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29970C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 07:47:24 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id l2so14065939pff.0
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 07:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q2y0gVn6fsm50drQoBzlgY4kRmYibYzsAGPTmi8yE78=;
        b=nJrG20xsWmNBjuy/sdSCugBXe1ZqKtCm7Ygblo79BBRVwkH7O8m3bDp7rQWX0rEoos
         cli9OWAlu1aTfzrEjvAK3ffH2SysppuO/h1vtj6CpwU+m7qJo/Rw8tmezloTXVGvtQQ+
         hd/DqUHwZYXE/cLh893wBJY/xq0NpctUCnvRZxkPQL/dU3roY20cu98GL7d/XLwAD1MO
         DoKYxDb6IT4r3D1gmvEgi86FIZ+HTQIVSt0vDXerv2yZpEMCKmGVyU9c4i/QdCQBhSur
         zkIdkIloKz0c77o5d6DN8vOKUffK638JpmZhwCfTrxaAt2xDLkq6bfqwM2SLmHECVPvC
         /KjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q2y0gVn6fsm50drQoBzlgY4kRmYibYzsAGPTmi8yE78=;
        b=a4W58BiC8sjYAH6u7WuSlFxQ++Yrq5XjOFbe1vGHvI/aHZvO+bLvHbDrTA5WSuWocn
         avNGp2v7VYL5LtC/LAtNcB5iYiRwoUNeyCk6kkKMmo2JT5pvEeavUFt+v473coKuP+Y1
         Z/JKj/PxoQpSiKk1gIzUYoIaZvkqTIfC7d4sso8JLIS2iUw3iKt/ngdVO/hBMfgP1PgM
         I6hfvh6PEqkrD2i3BsTun6rPhvXYsYbDQeFHzTYswBG32qPVOjXfZBv+E5iR1U2ei/es
         xbR2H4zAAKaZ5SycAbbcTyQNoqgXhWYzfm6FCr0olb6rb1OJ9do8AuGzF3PsBFgInySD
         NZRQ==
X-Gm-Message-State: AOAM532bSnrT8K69dgntkyL1UGEU1xuZaSSsW0A83Y6o7wAoxjbxwBHV
        TnWT2qlBO0bJOnbH2mD3ohoku7fkmv8=
X-Google-Smtp-Source: ABdhPJyUrdHCuNY/3qyKVX+DFHUnCRZ4vHI8ixDVGGD9Qet6Y8y78fuCPbodzBhMgrGN2rH69sYcRQ==
X-Received: by 2002:a63:4543:: with SMTP id u3mr18162754pgk.398.1596552443258;
        Tue, 04 Aug 2020 07:47:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y27sm23124077pgc.56.2020.08.04.07.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 07:47:22 -0700 (PDT)
Message-ID: <5f2974fa.1c69fb81.555a1.7b56@mx.google.com>
Date:   Tue, 04 Aug 2020 07:47:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.55-87-g47b594b8993f
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 163 runs,
 1 regressions (v5.4.55-87-g47b594b8993f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 163 runs, 1 regressions (v5.4.55-87-g47b594=
b8993f)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.55-87-g47b594b8993f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.55-87-g47b594b8993f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47b594b8993f9c5a04eaed3d5a9f9ed77be876f5 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f293e9848ebedaa9352c1aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55-=
87-g47b594b8993f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.55-=
87-g47b594b8993f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f293e9848ebedaa9352c=
1ab
      failing since 114 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9) =20
