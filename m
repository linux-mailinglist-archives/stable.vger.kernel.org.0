Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2B5220324
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 06:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgGOEBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 00:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgGOEBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 00:01:12 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7270C061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 21:01:11 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mn17so2098822pjb.4
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 21:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sm4TO+Dj8Eg0f7D6v+Ofzdj4B2lR38yiGVLFk0z3vzY=;
        b=f6FhNgMo9k6aGa0Xnm9ysswfpcZFHRm61zJ2Iae4YKnNNUCT3OoJzK68VyhYywHJbn
         KfW+/Z4IFF45Qz+g7rKPmdGQukB2go1Nrgg1jkDKWmvvO5uU8k72UE3PYFuoa6F5VWNg
         jRJDqN1iJHDefUW09zHq2Cz2BACqKKy0kqjSMMMxe3aXaMg1aI7zk6xOiJsk9O2bVDRB
         kICjLhjjustiiUhUPxtenuNIOE386LRCXVw5kO89gySx8u4yoqlYPWr6BOw95LszCmjH
         2RHaeouJuQAeALIf02QTMTpIQ5dj9tjYW2Vl3i6vD9CUNxYfWE5zL5yy+kdnvfMicG6p
         vY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sm4TO+Dj8Eg0f7D6v+Ofzdj4B2lR38yiGVLFk0z3vzY=;
        b=FLIzkpEdTJyz0mSMM1UlsDOlqytRRgbA8jpCJL3L0a82INNvj01TNOpWJ9JZahFFK7
         bXKz/rSmdDZoknDWTKyS5VS4sHLm7/RcBFJbn2bC+37ubyLhdd5aK8ldCfY2+lCUXVa2
         7klsyNdIptfqHCUhXXRMEwi1QzxCBZHfonkpsrOUJ6/55u0aD6nC4APRpcguRWl+Ua5T
         Lq9FG7rmuzckg4ERByykUWGTnncEgK4qA1BY45vrnqXYopstPd58LCfLXEIkRiL4aSOX
         /sLrGDe32ZS5Exw3EHozmLIqVRH8yZAQbEPbc9VTrRZjtkFqZkfltxT94D3+dGyzk2QC
         eZlA==
X-Gm-Message-State: AOAM531hP9aKvh/q8V18swEQF0MVM/pFcHT3OBWWP/xSo2nJ9uKBoACt
        bLeJHotkJD4+GJ9OFMrX8WDAkMndm8c=
X-Google-Smtp-Source: ABdhPJzllfplrTe4W8j6anncYH8BlRdIbog9rQ4Tg+wSTF9HqNFZCCq1UuIYiuUZgWEDvK2gRgQRUA==
X-Received: by 2002:a17:90b:112:: with SMTP id p18mr8223241pjz.92.1594785670902;
        Tue, 14 Jul 2020 21:01:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv9sm486277pjb.6.2020.07.14.21.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 21:01:10 -0700 (PDT)
Message-ID: <5f0e7f86.1c69fb81.17c26.24f1@mx.google.com>
Date:   Tue, 14 Jul 2020 21:01:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.132-59-g4e2a5cde3f03
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 116 runs,
 1 regressions (v4.19.132-59-g4e2a5cde3f03)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 116 runs, 1 regressions (v4.19.132-59-g4e2=
a5cde3f03)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.132-59-g4e2a5cde3f03/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.132-59-g4e2a5cde3f03
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e2a5cde3f03246325a5db594e9aff787b2b7fab =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f0e4d1a54531b96ed85bb27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
32-59-g4e2a5cde3f03/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
32-59-g4e2a5cde3f03/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f0e4d1a54531b96ed85b=
b28
      failing since 28 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =20
