Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8C944F5DD
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 02:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhKNBR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 20:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKNBR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 20:17:29 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794FDC061714
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 17:14:36 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m14so11662652pfc.9
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 17:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GkkpPb30nv7MEvNa6dSobMeCgmtxkYw6yMr6er7owgA=;
        b=sRHBBkQMaQ222KpOnYZpuSogqnwXS204hVIhRHxLG2z86jPVBX43A7AjL4eY8aH/7t
         zQiH5rS0FQPpCrCcAV8Mc2qNUSdS2i43RRLYaF2fOsrLShTRAcai73ZCR9/BOIEC1dMp
         MElRC21M2yyTcKejGxI2jq5lR4/AaWlJWP/gI+jLDpERy84H2GB2H4R7NLR87xtT5mWe
         8a2Tx/q0yntuaZQNIcsfdYAihjqRNa5nnhBr34tuMPMhgcLYxKSMWm05h2Gh9qjfV8/+
         J+PTCpWN8Q8mTfKGmY8l/Rz+YIdCmWLXLZYU5fO0Q0k3v9tYTOgYDyr6TW05zNXi69Q2
         QHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GkkpPb30nv7MEvNa6dSobMeCgmtxkYw6yMr6er7owgA=;
        b=n7DgDGfxR3L6EnWConBCOOYOosK86DFWdVEEKgs5/ZSh2ogbsNXiqMiHHeWR9M9z6V
         dyTdu10cJ9Ss3MvnWJJRc71dvdyzv9MSAkNCejvrTFfTJ9Cfh3erXyYuUJl9Eu3o0Si9
         aRl2RRernmWnSDdXzAozMgkp0r6DKUq1JBVzG1VsoipZBnnvesBVo7tsPTelxTOO6PV8
         wUA2NNREeAJtX1OKzejRyCDf8yO1ymKg4nAmc1uxOEvz3fO/Qh1hQrHRWTke2/Xgj/ub
         aMHJpRGYH4cvOPipxoY2dYPh+ZD6ENUzDWz17txx04AHgnMDamoO3DPuDFTmLyNjdGnD
         ktJg==
X-Gm-Message-State: AOAM530P6iH6BXOr773hJjXN+hwQjhIcaZvXIGHQ363OWsBzIzfHfEWX
        iIrWVTgtN1xw8rmVRZ/U4XZHqwt1H8jf8JCe
X-Google-Smtp-Source: ABdhPJxH/6KAFvfBrUEYYJRC4S4n40aKor83TMgM7biUZk1gUMoMNU1pb5BJfpvUF6XH1OJX+DssJA==
X-Received: by 2002:a05:6a00:1349:b0:4a0:2f9:e3ab with SMTP id k9-20020a056a00134900b004a002f9e3abmr23548584pfu.80.1636852475716;
        Sat, 13 Nov 2021 17:14:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13sm8347929pgb.8.2021.11.13.17.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 17:14:35 -0800 (PST)
Message-ID: <619062fb.1c69fb81.839d2.8bf5@mx.google.com>
Date:   Sat, 13 Nov 2021 17:14:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.2-121-g0299785967d3
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 177 runs,
 1 regressions (v5.15.2-121-g0299785967d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 177 runs, 1 regressions (v5.15.2-121-g0299=
785967d3)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.2-121-g0299785967d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.2-121-g0299785967d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0299785967d30d8d04f39db10c963441ba04e133 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61902a9ff0ea146f3d3358f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-121-g0299785967d3/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
-121-g0299785967d3/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61902a9ff0ea146f3d335=
8f8
        new failure (last pass: v5.15.2) =

 =20
