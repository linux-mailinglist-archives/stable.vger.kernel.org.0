Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C134C209884
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 04:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389439AbgFYCdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 22:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389438AbgFYCdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 22:33:07 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA82C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 19:33:07 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w2so1774290pgg.10
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 19:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Aw/g6175E298i0MmMp0E5bICkaacKRz8HXjlJAeXPa4=;
        b=0QG2IChg5CQHMOGcLQLpCASGVwXNVdGuzJiZJN8SpTeXutReBeTzNaQ5hl3ixBLLLA
         Ar9e/KRhXsdLCX5UXu01qrcbl2fauM0BXnj4vqhI09r9AN+DEqOdsN7aHGfCCsMFev8D
         IddleUYFBMX92F2LHtqRVxIk5ed/QNHiRgtg1/V5/R+kB+dbt09dTYMJOOKgkghpsHso
         oHagzWZq/CRekjWfevLinjtNOjmZn0inK8kvRLazRvSMRtF971vUnC7FBhde0nPOzNLF
         fSbqzGhf3qXt184GG7MRRTkk+5i9uMyDWXN57YDg58+lJE/0iVSON5oIkWZpKDoZlUuN
         J95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Aw/g6175E298i0MmMp0E5bICkaacKRz8HXjlJAeXPa4=;
        b=Q7pIamxSi9BoJvwIe6TXS+yOixQB6G1LFXtDlYTzPmDxxWNGphRV9HA3+Da/v8bbaK
         s5GrrZXShwykxN0wot+YJE0Q1gipL4NyBU0mOr3Ci/He+HLMn/HKP1jo4QUi8DyNiNfe
         ESm8ArM9raBhohP2+578kb+NdrIhcyWp6Fogssf6DMeV9wR0XS28+Iw1hhGnqBwAXX+f
         nlbipZLy43HzmmjKtDtvEcYOi3fGwfIRvcOxb4+5P1uqzzktXuJ3Mw1JCmZm8WyOZz+4
         LgChOYjY4gEf3qN8DfaSvY3qVFvt8sKsDjhET9LGDMSgksfoR+c7to8/8yvDrKJOxD8g
         kHPw==
X-Gm-Message-State: AOAM532uDNdV9+B/BaOAHoLB/pZrcuVFdQ4bk7HtPR68kOqHD9itiGsi
        nOqqDLcedqPtujki2pGtSNyQd5EiZd4=
X-Google-Smtp-Source: ABdhPJxx7BZapw11lmCRzIjq5P58ZsMUoJJoegKiwRWkFGOb3VuwGlZKtOeZc+XLm7jGq7wN3P2DsQ==
X-Received: by 2002:a63:d944:: with SMTP id e4mr24281964pgj.376.1593052385530;
        Wed, 24 Jun 2020 19:33:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q6sm20833402pff.79.2020.06.24.19.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 19:33:04 -0700 (PDT)
Message-ID: <5ef40ce0.1c69fb81.41aa5.158f@mx.google.com>
Date:   Wed, 24 Jun 2020 19:33:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.129-208-ge864f43593cc
Subject: stable-rc/linux-4.19.y baseline: 66 runs,
 1 regressions (v4.19.129-208-ge864f43593cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 66 runs, 1 regressions (v4.19.129-208-ge86=
4f43593cc)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.129-208-ge864f43593cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.129-208-ge864f43593cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e864f43593ccf9180c61738abdf1c1dde091367d =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef3d7421dc0ca5bcf97bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
29-208-ge864f43593cc/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
29-208-ge864f43593cc/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef3d7421dc0ca5bcf97b=
f0a
      new failure (last pass: v4.19.126-528-g54d0fce94603) =20
