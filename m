Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297FA3EB293
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhHMI0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhHMI0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 04:26:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906C5C061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 01:25:50 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j1so14211868pjv.3
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 01:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nZCZSfSNo8hbpXR52cSD/wGTJqu0gSiywWE7Nd27Ci8=;
        b=LXj9VbO0d2eMlq58PqiZJ8qLAN3z36z89GW9Ag5Ls0TEvafRCUS33rB8tfoFq3GetF
         icYVF6FV9i27nLj48X15uuCvKsfs2NVkiZ8H7WUHbr2FLOPzCFMky1yVOh/GtfyEf2U1
         frY/i5m6ZHVEBSMKeN+LX2ulXLW/d70forOnEZqHRWf+UiVw9dsLdfZSgL7yqEqXosKj
         GAm2wQeQdw8igH7cCsVu+rJf9E+ZEYfNq96yDpGXfVkRT2ICVPi3/QkjSJZBdVqsAlAw
         yTrlmPy2XGFvnAczbIxQSQSBRXG2mtcYjDY3Q3C58kKA70RqPjV9wTwq+IOzFBjzRdJh
         1hWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nZCZSfSNo8hbpXR52cSD/wGTJqu0gSiywWE7Nd27Ci8=;
        b=GavQ2gFvIEAV/S3+rDNkLnjQiBbmXsXI3mmc9a+6VCAQtKjBbgtFI6EaSbcAKVggor
         SUd9WH7bf1sCUCkxJ/4C/VomjjTXwwHYQ23vXtKEmk0EmyacaCyWT6B8sG8lRHB+RJWy
         YsDKw+60OEadexack9JGN9xIQwOGKIDO1UcCQTu4C39ePz2/e/DY+MMML4N4LRpjTsFx
         YZpgPj5CEVNwtgWSoqAA1DrhR8AfnLzGlG3MMCdNeWbNAgaf0dbp34Ys6Mp5p/8Uq3VE
         amzzcMwMV7vAUKpyV0iu4heH50r+JESng6Pt+zBIQjmza80n3F/ToRGmgGqEfZkJktsp
         dpWA==
X-Gm-Message-State: AOAM530p+rZYz1t43Ylm8H6DNb96iSSe2V8HYUBNziv5xrNa/3Sac8v5
        6866LyleIaymBb2fYrwmo7yxEKREfYk7Z9Dt
X-Google-Smtp-Source: ABdhPJzu8crxajzSJG+OJt3oY9vMVZ7zhNtQTwtdIis3KreqEboww9D1zPOFADq0jTGHS393h7hxFg==
X-Received: by 2002:a63:515:: with SMTP id 21mr1389626pgf.70.1628843149948;
        Fri, 13 Aug 2021 01:25:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ms19sm1117910pjb.53.2021.08.13.01.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 01:25:49 -0700 (PDT)
Message-ID: <61162c8d.1c69fb81.2e9e2.294b@mx.google.com>
Date:   Fri, 13 Aug 2021 01:25:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.13.10
X-Kernelci-Report-Type: test
Subject: stable/linux-5.13.y baseline: 186 runs, 1 regressions (v5.13.10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 186 runs, 1 regressions (v5.13.10)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.10/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a37da2be8e6c85c438a1528f9c971e1811086db3 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6115fb7d12107fa067b136c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.10/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.10/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6115fb7d12107fa067b13=
6c3
        new failure (last pass: v5.13.9) =

 =20
