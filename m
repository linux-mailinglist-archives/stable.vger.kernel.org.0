Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6374327BF69
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 10:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbgI2IaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 04:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2IaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 04:30:19 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FEFC061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 01:30:19 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h23so1122664pjv.5
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 01:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hPTJ3zK++ZEDpljfr32qzyCZPdz9Mh5GLGiLPKIHnG4=;
        b=0Fz6LRq3OuI3vUnNr7UbKv/r9nGZDSKASTZTIzhJY1kk/+unDETTGE7lpzMrnkLAon
         Awa+emjf24doKWXjVH0/wuFiiKdBPkcjAymjz8hoMIaS3Ak6Tviff00r8wWPF7ekPG/t
         kQ/GJ2Gp/8mpuCCjaNrugm/NZVcWAqNIWf8bThkfJsBvMAdwOzrqwqTXtZykvJKQ9HEF
         NAsB/gmDro//Vdx3CFq6wgxpDq8V5Op/KciJQeSC42oZ7CQ8RFzqvcHjQZQY4LqvMLw9
         SMBKhOuXbH7bk34RY8ZmrY3Zn4J/MKNVKeOCMEycn/+o0wcMnX1Ql93xHWLjbCkkE9Hw
         OF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hPTJ3zK++ZEDpljfr32qzyCZPdz9Mh5GLGiLPKIHnG4=;
        b=r15hVpIkBrjFL2NXwTUtdlRm8tkMGN073oJUVt+15vLaP+qpBZLQmKbnTdrXjiRYgD
         LLchman5q315/b5wifxtd2u/x9Qr/CsPg9waXg7wV5lPn5bsWjXH2OiqBzm8xGkWEKyF
         slvJrW6nbHR30bTyFjP9wnT7LhPi4ANsy+n6ixqCGKYlL9jRcPO7VlwNVibqF1sX9Sag
         nC8gvQmlLAfRPuAqc5KIpkE4VWsNzH+repdMdwWEWoMvTGq1HkxvCgq6HwQDWi7qFQ6f
         G8ujVmN1YudGxRCOHlHr9Bobmeqq8luCYOVapIp50OvlizsjqLQv3wwqZvvEAO3Lypen
         t+wQ==
X-Gm-Message-State: AOAM5319zuFlm8dmVgwJ3/uyQAY82WYI9s1GDvJqMUBVFTfY8ODkg6Sp
        nIUZfR3R1OfH6dSsIKAVthj3c1uXy0INug==
X-Google-Smtp-Source: ABdhPJwh9ej7J0K5JfRzkLR4hKtBu+iBVaBE/Kqy2A6s91GL1kqbMthD73nJgkunI3aJt0AppP6ZVw==
X-Received: by 2002:a17:90a:f309:: with SMTP id ca9mr2993475pjb.0.1601368217852;
        Tue, 29 Sep 2020 01:30:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d8sm3868584pjs.47.2020.09.29.01.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 01:30:17 -0700 (PDT)
Message-ID: <5f72f099.1c69fb81.39819.7bb7@mx.google.com>
Date:   Tue, 29 Sep 2020 01:30:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.237-118-gdc37d06cbd7e
Subject: stable-rc/linux-4.9.y baseline: 65 runs,
 1 regressions (v4.9.237-118-gdc37d06cbd7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 65 runs, 1 regressions (v4.9.237-118-gdc37d=
06cbd7e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.237-118-gdc37d06cbd7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.237-118-gdc37d06cbd7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc37d06cbd7ec615d5a4d6869e0b0144f6517edf =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f72bf605a66fef97fbf9dcf

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.237=
-118-gdc37d06cbd7e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.237=
-118-gdc37d06cbd7e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f72bf605a66fef=
97fbf9dd6
      new failure (last pass: v4.9.237)
      2 lines  =20
