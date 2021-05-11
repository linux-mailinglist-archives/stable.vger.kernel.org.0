Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2917F379BB6
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 02:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhEKAwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 20:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhEKAwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 20:52:53 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8E7C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 17:51:46 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i5so9801428pgm.0
        for <stable@vger.kernel.org>; Mon, 10 May 2021 17:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BCDcUr6VCP4MRh22ERpcU7pig2eAiV3ZbGCv8DLB3jQ=;
        b=L1LRLVzmA1i60N0fFa5fr1yRL4yKnLP+4++AdJ3bSO+wp4elNCsWsbyY24lgA1mi6h
         2p8ZrU7FfrMFEaUbobAk2VLcX58BWw+vqN4Rj5rzf18S0+ZZPsJnNLRccwBX9C0GH5EC
         6Dw3lRwN4oOfUKEV9FI45gNg0wQCMpk9X+9eaZA/8bhyHZh7nYjWji0Pr7eMhZArtEct
         HQ8ZUZi3Jc2CtJ41jGhOpHG0m7v4X8sEn2X9jzD5m0PeIWixXL2ZHRjCoXV1z0u9F4Lj
         JRvhGQVvo1F0nDW/gLW/u3hE25+eBE8e+c5QuBHRt46lTgTjZMVhfQOBSVJCKfLWqbHu
         +ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BCDcUr6VCP4MRh22ERpcU7pig2eAiV3ZbGCv8DLB3jQ=;
        b=DxfATuoNd212Qo+rks9gjXJsFdn04RjP0aEP7Qc7CSao50w+bhIy5TctpkvSY9Fplm
         sEhg+lLVjGQYev9sTp7/Cn0oyRJNwRsNOW7PQTMdoLxQF4yXte3CVRt0CtYLHNYJVLha
         2WJ7Ob8MbgTiIK+pVGd6fDcUJY9XS56AeeFsBfqJTiOlamfkMVgdZuV8Mbk91IGcY8zY
         3vhHtTg+yRqPHSBbN7K7GsXorT/G0JOmaNhig3Aq2tEqdWzwUdDrP9acViHNzahTm32R
         w9L9E8k1wpmOsvK97PShJ7W1W3WTqhqzv7yfIY9vSXEivGhtqPZekFd6DG0OTIEYcjfG
         7Ybw==
X-Gm-Message-State: AOAM533Gu5TCKYrqbDjv4nBdtF3jtw6JPEC4vOcc7kZvYIgQkwCizzpc
        R76+NbCkB5VD4xTz1kjU7ZEXRoa0gsQqrCP0
X-Google-Smtp-Source: ABdhPJyK7qIN5SQsXM35U2oHWRSwqnZNKTACxIq8FrFEXIjHvNQQaCdFXcUxkW9oyyzC1Benug7hvA==
X-Received: by 2002:a63:b211:: with SMTP id x17mr20518600pge.106.1620694305893;
        Mon, 10 May 2021 17:51:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm12373491pgo.66.2021.05.10.17.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 17:51:45 -0700 (PDT)
Message-ID: <6099d521.1c69fb81.58bf8.649b@mx.google.com>
Date:   Mon, 10 May 2021 17:51:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.35-300-g4edc8f7e8676
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 113 runs,
 1 regressions (v5.10.35-300-g4edc8f7e8676)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 113 runs, 1 regressions (v5.10.35-300-g4ed=
c8f7e8676)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.35-300-g4edc8f7e8676/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.35-300-g4edc8f7e8676
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4edc8f7e8676bbfdec9d67dc6b90ec72fd3bacaa =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6099a5e0bcebddbf5b6f5472

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
5-300-g4edc8f7e8676/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
5-300-g4edc8f7e8676/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099a5e0bcebddbf5b6f5=
473
        new failure (last pass: v5.10.35-221-gbb0eba64e018f) =

 =20
