Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6607040C75F
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 16:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbhIOOWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 10:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238114AbhIOOWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 10:22:14 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCA7C0613E7
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 07:20:55 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d18so1704040pll.11
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 07:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ywUzZAZUaBgLjAXwNo0WHiYv6InEC+W8UKnkNCqB3PQ=;
        b=aTDhU1j/AatYdd3lMOgFsH5kSumcAvP093aNGaIK55fpQq0YLG6hohKnbvHqFagPy5
         aBZ4Yuthb3kGz6daUTZ2zV3bKpY4hslnienLcCxAieL73zyo5FmJwGMG8QfQ06UiiSzc
         EnrOBEwbZJ6mUols1EE3KePcHktLL4v7xELOv70bgF8B2E++rXzz5C8FPHO2Hxi4n0ge
         B7qeacFtQBPlsvh65a12JBYm+jFo2Mb3Td634cbRFuwBVqi90UPdmtwTtNrphzljyzm1
         lem3CjX+a7ajKglSG+LV+z/c4DiykujTQ/iYxMQgpQ3JZM1qMuJ7ObnAjLyC/p9SsjIJ
         Lfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ywUzZAZUaBgLjAXwNo0WHiYv6InEC+W8UKnkNCqB3PQ=;
        b=MTPEfW5FgY2J9pZ2rdCAlfn7pzSbJD8tVow3zffge5BV8dSHwzntXiy+kLXBrFcS81
         7k2IF57r/hwqL6/lcngxfWuYuaRxZZ6ZMbghZ8feLPfzqE5ovveF5lN2JTIIlCSPOjz2
         w7mEOLqR34bXJvEjv8+87QBodjgsCXbEPFP/d4MLgLeRmsEQnOCKdSxyzPEiY+CymuHz
         oDVr89YJF/HokCdTpvEDx5Fp5MaeSHdynhkLUR27rLTZUWK0q6TTmOp8NXDvwteMqrU5
         W6hxDoNiWcHMXcsMZ2aNIjBCSaFTADnOto7Zx7UyzFWS1sZzmnVQRgdVU7weuFZe5jek
         N8dA==
X-Gm-Message-State: AOAM531xWFPe625DhgoID9/9I0lWPW+Jpb55FvC6ZEy7Fc6Qhh0Ql1kg
        AXPjNCfMAKTiBsxI4x3FzO6B8z/EgMV8eya4
X-Google-Smtp-Source: ABdhPJyyD0M1DcnyAuVt/DuJCN++fqHC3N4/JkwyZAiPn1oRZpuVRRweN6DZv6fVELSDCH44ADcU/w==
X-Received: by 2002:a17:903:246:b0:13a:22d1:88b with SMTP id j6-20020a170903024600b0013a22d1088bmr138290plh.16.1631715654449;
        Wed, 15 Sep 2021 07:20:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm13017pjc.28.2021.09.15.07.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 07:20:54 -0700 (PDT)
Message-ID: <61420146.1c69fb81.57df1.00b6@mx.google.com>
Date:   Wed, 15 Sep 2021 07:20:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.17
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.13.y
Subject: stable/linux-5.13.y baseline: 179 runs, 1 regressions (v5.13.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 179 runs, 1 regressions (v5.13.17)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.17/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e228609749a14bb736b6210738042a3c0a2127d1 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6141cf512f1ea029b199a31b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.17/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.17/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6141cf512f1ea029b199a=
31c
        new failure (last pass: v5.13.15) =

 =20
