Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481FA35AF8B
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 20:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhDJSVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 14:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhDJSVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 14:21:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECAEC06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 11:21:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso4825941pjb.3
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 11:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DO0p+4vHTbUwBRZxayTozJdZM8s8u/7wohZJq/NfAb4=;
        b=USL8R+yjWuLRe9cn3EKZdqzAaH2bN4DTSPXGTtupQbC7jBDG3p1sva07KXznVAs473
         qNPGgBPTbEztDKM0CbgwEnNN2Gg+jMlsdz+Ugug1yKLTOVvfyKx7P6PviHsfOoTP3aon
         qFamOaSYBp7t26CY2z8LjzbdqnqmS8Ye6L9ZJb7o09R0QR2GTy9bybauE9U3vE066nTj
         5xZvBkvHewP6DeEkyLhlUeW/07+VvTOl3jsXj2lmpoTa4vntJBDNsFcDy5upwJGExb5e
         ZA6UvPTi/ww20Hx77ODf4GypYzrPeoZRwQa56u3UkEGRa2gZYPIdUCLVEvVNGsiF+whk
         fanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DO0p+4vHTbUwBRZxayTozJdZM8s8u/7wohZJq/NfAb4=;
        b=QUGKFpXWWI4+S8n40yS0AKtuvAMMGfvdJPzH2AIz+Ucd5Us6Nj03aZwaQosRAGk6LT
         Sx/jK+WdFMcQ8frfs0PBvaI3YjmH/UtyPjxiZjRMJCJssYXYq0rRFW6OtU7rA25KwLL/
         oVzJzrINALYsOeqZb7Dz7CZgPi25K6UQwvN9nSGZD3THWG4FeBAW7UR0kFqfbgZr6Y0e
         81z6t/3gHmEmasgeD7bHbL/1OWF8hYP54vFON5wzYhW1tj9CyqTJLD41GVCPCHJmTjQ6
         JgmJooDrgs5Emhdll8S9hFtN9vRGE2nYd8puhQh62h1kI0dXeiuba0ZPllvYfb4+kG6A
         M08A==
X-Gm-Message-State: AOAM533aDDtqO+5CukHaokyLCzHcki5IDk6c91GSU2PASzclJawTpdib
        +vZ6y7qKtGZiQJ7O+2gBwmAFrUU3eMp7aQkV
X-Google-Smtp-Source: ABdhPJxkAwWgxHFKM9zaBhcGCBkWcUTjpXsQA8LTF+B/U53ol+5Ce1rnTpNnoAiYy7bBIH7ThqumTA==
X-Received: by 2002:a17:90b:17d1:: with SMTP id me17mr13062435pjb.73.1618078864042;
        Sat, 10 Apr 2021 11:21:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12sm1677323pfo.114.2021.04.10.11.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 11:21:03 -0700 (PDT)
Message-ID: <6071ec8f.1c69fb81.d6683.3501@mx.google.com>
Date:   Sat, 10 Apr 2021 11:21:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.28-41-g300d8849aaaa
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 145 runs,
 2 regressions (v5.10.28-41-g300d8849aaaa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 145 runs, 2 regressions (v5.10.28-41-g300d88=
49aaaa)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =

tegra124-nyan-big   | arm   | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.28-41-g300d8849aaaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.28-41-g300d8849aaaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      300d8849aaaa4da8adf406246776238bcd072344 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6071b58dcbb5ac35dedac6dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.28-=
41-g300d8849aaaa/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.28-=
41-g300d8849aaaa/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071b58dcbb5ac35dedac=
6de
        new failure (last pass: v5.10.28-41-g4005a6006d0ae) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
tegra124-nyan-big   | arm   | lab-collabora | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6071d5842f92fb7be8dac7b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.28-=
41-g300d8849aaaa/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.28-=
41-g300d8849aaaa/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071d5842f92fb7be8dac=
7b9
        new failure (last pass: v5.10.28-41-g3a4f6976974a) =

 =20
