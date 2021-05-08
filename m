Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC415376E04
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 03:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhEHBHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 21:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhEHBHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 21:07:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8E5C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 18:06:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p4so9127371pfo.3
        for <stable@vger.kernel.org>; Fri, 07 May 2021 18:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L3Ug1lT/1rWZrRRCxdUeU38g+5NvWMOSQvpJpSbJ6Ro=;
        b=NGpsDTRLpIEi48fcxQtFPhiFKU2uDvtd5AK+a/BLyizN815J/Pd8WfQyl4nlTC4Sn+
         2QMjZZt5y5Wv7McBolKP5/+oNzAt5fzKydHiuzTAaM0IOaDjsr8mBTffiaecoj+fFXZR
         0cPVvPJolE3cANMADS+M8+hWvD/y1pbV19AzEhpYw9wchDU+/LUpdnGGFVmvPT+m1ChM
         uUeILr1u7MQWy0dPtoaVMfHFAD3NboejCOJzdtsWPhI6Rw5diup53J0jcBSjP32wVJ7t
         kSFa6E2vP/2TIiz9rbzuyBIiqCBCSwbFvs1nqkYev1MRAYSN7uIRy2IBDr/hwT/pbp1R
         KoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L3Ug1lT/1rWZrRRCxdUeU38g+5NvWMOSQvpJpSbJ6Ro=;
        b=J+RAqEpH3SNITvPZCLPlI1aafnTahBXrn3b9p/0FzQ52BOEqElJPCm1tDyIu7WX31D
         KcIecrKE1FFeMvJRwkiBBnC9isn2819vko2/RdZlj7piFWEkyZhlNsJYKt4n3m1a6xwT
         DUYnERIZzwdFDEc5TawbNroEyU7XGIskrq0eFuwKd6L/vBcHTUxirOsYnEoJiDDjDcKC
         NwAAwV3pSVgiyOmBv68tx/LnlR47IGhqFAFzRx/gjo6pDzwfJ/cJ5Ii7S6gZtp0eNylJ
         9HjLvwBalufx89JgkNJBCwf2uW/RV83Af1Na3eEnsVHIMPKFTFOgBcujkJH5JjcMiZ7I
         7muw==
X-Gm-Message-State: AOAM5308SdcKLnTwlaN2pGxelMRBkx6deRJVDh19BGDD2JTSNz+6oWJT
        ql7eFn+Va2Y9TdLPxiYMZ2MaxXT1+vYZRn0A
X-Google-Smtp-Source: ABdhPJwG+68ZPNdJBmgHO7mmnHFQJjheChtDMr9AUNpugGEQIevl/Ua3mS3YwPi48ZflQy+/aF2bGw==
X-Received: by 2002:a63:ce41:: with SMTP id r1mr12980912pgi.222.1620435961731;
        Fri, 07 May 2021 18:06:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o140sm5637893pfd.65.2021.05.07.18.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 18:06:01 -0700 (PDT)
Message-ID: <6095e3f9.1c69fb81.7b47.16e5@mx.google.com>
Date:   Fri, 07 May 2021 18:06:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 124 runs, 1 regressions (v5.12.2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 124 runs, 1 regressions (v5.12.2)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96e86bea450b3a00af5dc7ba5382f1b241e4306a =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095b4c63aeae742b46f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.2=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095b4c63aeae742b46f5=
46b
        failing since 2 days (last pass: v5.12.1-17-gb3226f805af4, first fa=
il: v5.12.1-18-g77358801e46cf) =

 =20
