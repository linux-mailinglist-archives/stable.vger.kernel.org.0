Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A022C24A7B9
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgHSUaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgHSUaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 16:30:13 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C024EC061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 13:30:13 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y206so12239499pfb.10
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 13:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7r03ZXxk/hPUNUCo/NU7/cw02oQSuKFyrqNNc6y1oKE=;
        b=Z4k14CwzhurejalM9fRGPtJhLrCfSPyvfdLQQS2OIck/X0u0dbSKC+NU5BMNfeDwJG
         L6X6txESJ7XFzjfUbPqo2Ur9C9lEHTgYnXgMMU8N7tFFjLTeVEHDJdVSiPVhNPKi1gTu
         L71VfsnprhWLWAvJFwHciOhfS0Ibpf1dhw5XL7CXiXyJPBsvedQUPEcGNbWdWrZycD/3
         ONqy/d0NX9rb8p9Kx6zLjLD3TpRny+GP+vRl/AhKnvxFbsozR+X6HMKG64RtaogxBmXw
         VgLb03ajCPNeeuS2L5DBMneS/PM3z9DC3tAd6o/HH1BRxmOIr3Vq4vkNGhGIPNmx1IXO
         GEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7r03ZXxk/hPUNUCo/NU7/cw02oQSuKFyrqNNc6y1oKE=;
        b=ffsK9HKsp0Lsrc8c17goouXpfjY/hMSBDIH8jWfaRmPSp0lCocAuWTf1j5Tu/asOGY
         kj3UkCdDISdZPutQknk6WVZfPU19Rssdk6H/7A8aVP3qn+5zPN1Hy1MZrhwxSZUr1KcN
         wBJk+ck45j3Y94RvgZVajwwB+0l5Y5stMpZu3OFD/HTRtZ3TOEtrvBt9dJtADequoiaq
         SvO6R5trwiFK6XEbp85PuV2Oo/9ETQb/iwMQGfFOynZAV35JLPwn2yGt3XIyUWG6sq6F
         Sh/xSY+x7hE4f1n8gd5pkZKCqSzyyNE0+3xibR7fLf0/NUjm21dHxNGeuTyE3GRwlRr/
         nFDQ==
X-Gm-Message-State: AOAM533obAIu4ZSbuTVMO2h43z683LaPIhJeNXcVBPOm5pVHD6QdQBqD
        v8G3dZypL97NgIH2ijNWD28vplebbif46g==
X-Google-Smtp-Source: ABdhPJy1d6JV7+AuxTfZA4C371fdd1QpkA24KRF5KNmFIVcSburjes4x/na9WkJO9BODlXZ49S7/kQ==
X-Received: by 2002:a62:90:: with SMTP id 138mr20612577pfa.0.1597869012154;
        Wed, 19 Aug 2020 13:30:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cu8sm2696587pjb.47.2020.08.19.13.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:30:11 -0700 (PDT)
Message-ID: <5f3d8bd3.1c69fb81.234b5.5dde@mx.google.com>
Date:   Wed, 19 Aug 2020 13:30:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.7.16-99-gc5aad81e7f2d
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 195 runs,
 1 regressions (v5.7.16-99-gc5aad81e7f2d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 195 runs, 1 regressions (v5.7.16-99-gc5aad8=
1e7f2d)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.16-99-gc5aad81e7f2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.16-99-gc5aad81e7f2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5aad81e7f2df22cbf7b4e5305b8c372d7f8ac4c =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3d58541e79dfd1d6d99a47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16-=
99-gc5aad81e7f2d/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.16-=
99-gc5aad81e7f2d/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3d58541e79dfd1d6d99=
a48
      failing since 34 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =20
