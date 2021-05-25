Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAAB3907A1
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 19:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhEYR3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 13:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbhEYR3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 13:29:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA57C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 10:27:42 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q25so6105335pfn.1
        for <stable@vger.kernel.org>; Tue, 25 May 2021 10:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ktzHkBMVZutm8xbzPMcBmHa7a2qLRuWtRytg3ElfxI8=;
        b=0VwO/nQl0+0TchpBBU6VkkmdS244jIDIcSzBLkdpzco+igMlnSY0+ML/7yOv4NNpsj
         vOPGOUbnMTjgteAxWCYMZEWGJRBSir5aMVGg1INNum9cTrwQn9vwL/cDT7pYv/1wcZwc
         WA82apH3fD5nqgB2s2K1mIBvjDxmF26Z/PnVi6A9Tot9nXCYZa6T6USzRCbflA+xb0SY
         Sbtbm5v/JTdvpMcuPeGEVjxDNCmyt0V1F/cZB/yXblhXMJIG08JJrSu/BVauoQ9A7L2j
         dH/V8+qRBMMhRWP3FKlfmOqVVcUBHvHsHSoIuVuRHdeGOB3zvQbU2MXrSPUEVu+MaYeD
         RUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ktzHkBMVZutm8xbzPMcBmHa7a2qLRuWtRytg3ElfxI8=;
        b=ga3iOTN9y36s/pV20xIOxJTa87gAgcXywNKUqMwuSNVucUJJBLRDHFayYDXBHdDbh9
         3Ozf2yerdCDErveR/C+xLEWPWNjwdf5dIgU8QHr4Tpavi1UI4a7MAwiMFaY73krB8/gI
         Ze3dI3crnR4sv3RRXTOTYXvY8aJTRoGCH9upnvkwNuVjXOTs9YmcetD7g0cBKvfQAt0U
         LXZXsALsRrjccXq+5hvU3GKbz6FDhW368V/UVBKS3YfsQ4oHtwhi+1izWzsTGaNKCroD
         CWy0KqbupNYeVl6Tnpfctl1PhOWqwVHm4xHUBN5KEIk3+m5CcuiWPVvy+ZcA6TP1UKX2
         BoYw==
X-Gm-Message-State: AOAM532s3nww5SFwhvTHaqev21s+0wLPJVpc+0AmlkRkTRU3LOFD9zZI
        cfzeKHieabZz9UbBWLtn4Wzh5otciUnstr+/
X-Google-Smtp-Source: ABdhPJwgF+67jmQz/u+gJ0pn61W33/QFFPtVh8aBnELGiBvr1cS7pEqa/B5F4lP78w7wjohlQYjx+Q==
X-Received: by 2002:aa7:930a:0:b029:2e7:708:fba with SMTP id 10-20020aa7930a0000b02902e707080fbamr17933999pfj.2.1621963661890;
        Tue, 25 May 2021 10:27:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u190sm1615311pfb.151.2021.05.25.10.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:27:41 -0700 (PDT)
Message-ID: <60ad338d.1c69fb81.6ffe.3ee2@mx.google.com>
Date:   Tue, 25 May 2021 10:27:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.39-103-g5d71e5f41792
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 133 runs,
 1 regressions (v5.10.39-103-g5d71e5f41792)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 133 runs, 1 regressions (v5.10.39-103-g5d71e=
5f41792)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.39-103-g5d71e5f41792/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.39-103-g5d71e5f41792
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d71e5f417922d53190df446bba295193c2fb1f3 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60acfce443e3dbcac7b3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.39-=
103-g5d71e5f41792/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.39-=
103-g5d71e5f41792/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acfce443e3dbcac7b3a=
fa7
        new failure (last pass: v5.10.39-104-g15b194ce40af) =

 =20
