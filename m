Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2D5471F13
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 02:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhLMBFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 20:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhLMBFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 20:05:49 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F61BC06173F
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 17:05:49 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g18so13541414pfk.5
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 17:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1cQTftxLzWaEE83qekPkuFhiZ7ALj6iZo4KEbxla8iw=;
        b=pmKCvZldSsrF260/HCoxxMwL7wUkFkBv8Oa78mZwMIHc0MIYXq6dX+sUyHZaD9VKME
         MmAFmcLiQHMVfbu/5p0+BLjS1qPTiIALKUTz8X3N3ne+Ry4VerJ64bjWHS7y7oqL3X9F
         0OLWF+5DDcCRBDs77VFyr4kLMxl4F8Du7q05rz8EhI7UtojUwNW8IY0x+ZG9w1Dul33q
         JIh0OL2ksv4wVxHkUHitNDwDkZEvCzQ3jeW/lbY9b/OVE/cAye4Ypt7b3RWEjRQ7LevP
         xn4YQAq3eT461qvZqJcHLq53iLXVyzLitSHEBAYrnFvrN42u4MmtGXnNRgYDMTR6bR9j
         4Pog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1cQTftxLzWaEE83qekPkuFhiZ7ALj6iZo4KEbxla8iw=;
        b=nracURiuspsnzV3yX4sP7qbJBiKAAaMfKT2wb3w59RjX34PnoAQDCM8q6CEnOKPRJ5
         pouGt63NFJs3ZSlVY79y5iFJuZdgGYwpW1AIeWBIfYFs3OprIxnHgYtdJajtyZyBa12C
         l9SoY07G1KDajro4/ADut7rLNrBRO2nc70HxZ14XCpfPckcBffTy8KlZS296pxDGBO5e
         ERuKwHIt8A9NtXPmYqRf6PYI2XxtCTEBo0V7nWTzWYFitAa1usCmrx+wPi4bf7d6VtNJ
         dOISyq1vyLPJr+MFPA2CRydqHyuLzHelJ10gS5ESk3muu5thRpcvZlAF3AJY1CPMHUkQ
         zeVQ==
X-Gm-Message-State: AOAM530dSYa3sT1GN71H80L0LhLvAM2E3g5pKmQLVZEPpvmb9rLYDE3z
        bBgh7ap9AGYiYeiRi1REkqFVqIFiUDZivexs
X-Google-Smtp-Source: ABdhPJzUu8VzL83APSxTh0k2uxRge8RvCp5/sxogERXp8rox6kcLP1NG2wQexIGW8fG2SlLUwR8jFQ==
X-Received: by 2002:a62:7e4c:0:b0:4a2:678e:8793 with SMTP id z73-20020a627e4c000000b004a2678e8793mr30599242pfc.75.1639357548842;
        Sun, 12 Dec 2021 17:05:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t8sm8669637pgk.66.2021.12.12.17.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 17:05:48 -0800 (PST)
Message-ID: <61b69c6c.1c69fb81.45cca.94a0@mx.google.com>
Date:   Sun, 12 Dec 2021 17:05:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.84-100-g5fae31e30f0f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 239 runs,
 1 regressions (v5.10.84-100-g5fae31e30f0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 239 runs, 1 regressions (v5.10.84-100-g5fa=
e31e30f0f)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.84-100-g5fae31e30f0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.84-100-g5fae31e30f0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fae31e30f0f472e3c32f0021ad146a8a45e3fb6 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b66184b820bdab4339711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
4-100-g5fae31e30f0f/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-m=
innowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
4-100-g5fae31e30f0f/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-m=
innowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b66184b820bdab43397=
11f
        new failure (last pass: v5.10.83-126-g05722611cd6f) =

 =20
