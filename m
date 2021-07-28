Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA23D97A8
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 23:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhG1VkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 17:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhG1VkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 17:40:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485A8C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 14:39:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so6260191pjd.0
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 14:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PsTlhohyGRijf/tR4IXRUWtyzIEgf3nScVypBvsQIww=;
        b=kWjJZlCU5ZOOD5+xLgvqbtbVPATZVLGM8QuJVs3gBGK9wguSeuC/CQ8v50GvaAIzzD
         BvJHPcfdM3ORw8g6wcBaj8QJIMk53Be+SwOaYggg1MNyiUOlRRUBFk0s2dv/+BOq6jfo
         HiwnDWH6OKDfQUrBbQncvI9auAHbQ1Tc8su/TrKSeJyb+cs273/RW0DUzLo2+awErDTZ
         EFf2SXEZ1grqwKq2mlcqmOEDNApYZq10h1Z3P5V4lkFN+aTYWYDnsMHbHQfyLbZrUvnd
         9ZEyqJIi3JvSVLRyNf9svvEOR+8slfhKfx2mBEMemeYhhps1qWcs2DBcYyCvK3GSZFSF
         r6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PsTlhohyGRijf/tR4IXRUWtyzIEgf3nScVypBvsQIww=;
        b=P9GfDKdmRXFD2fqui6F5EFwZSj6uS/AH3tfzWQaYpFb0WerpMHQGtPgkiPQVAr+NVe
         qM1D8WNRYkumx2bd/HCzjswtawN8LTonsNJsFnm8d7/kocv4Gxw9yxZcXJRcIm6W2/av
         Cyws3zJf2e77mPX7yjzSRbGbQ2YS+RgrRFHCfadBfT2RgUakop/2QK9VmUrOKoIt/FAO
         oBFqPfLsmK0+2PoR0nukfSW2GJ6UdGxNwSZ/VkjAImeGntyII1Eudf++zCDblWrxNRxl
         012zofX0Xhf9j2pVf/D3/GsIyozRnWxK2dNAfEbA+j+huPvD/YpziyxHewrQj9gPIWrf
         biAg==
X-Gm-Message-State: AOAM533cKQEN90MEf8SeAwfSacOykDSn+sbqjYSv3WN71ZApnBl5CX1V
        SKbM5DZB44a4Ek7vwwL4C0/UJbo7IpmuCz75
X-Google-Smtp-Source: ABdhPJzi/Los/3obXfnmODa5cOq3Umodoh/CI9P9UlavqnG+Qe5p4O2tJ89M9W6wb+ijkmSmA+UyXg==
X-Received: by 2002:a63:c04a:: with SMTP id z10mr853127pgi.99.1627508397694;
        Wed, 28 Jul 2021 14:39:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 26sm698836pjg.8.2021.07.28.14.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:39:57 -0700 (PDT)
Message-ID: <6101cead.1c69fb81.aa09b.2e6f@mx.google.com>
Date:   Wed, 28 Jul 2021 14:39:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.241-1-gdaf138d437dd
Subject: stable-rc/queue/4.14 baseline: 119 runs,
 1 regressions (v4.14.241-1-gdaf138d437dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 119 runs, 1 regressions (v4.14.241-1-gdaf138=
d437dd)

Regressions Summary
-------------------

platform   | arch | lab     | compiler | defconfig          | regressions
-----------+------+---------+----------+--------------------+------------
imx6sx-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.241-1-gdaf138d437dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.241-1-gdaf138d437dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      daf138d437ddcf33d69276ba345693792f9572c4 =



Test Regressions
---------------- =



platform   | arch | lab     | compiler | defconfig          | regressions
-----------+------+---------+----------+--------------------+------------
imx6sx-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61019ea6fe8722642c5018e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-1-gdaf138d437dd/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-1-gdaf138d437dd/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61019ea6fe8722642c501=
8e5
        new failure (last pass: v4.14.240-81-g22f1df13e264) =

 =20
