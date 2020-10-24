Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27D9297D1D
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 17:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761212AbgJXPSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 11:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761209AbgJXPSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 11:18:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41BBC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 08:18:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a200so3549505pfa.10
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 08:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OHCOoE7lJGk4/gTixNGMD3xkKRQOgmki/9ld58nwYQw=;
        b=Bif72yBiHKGB1pOIwTgujscOBOVDqhNCZWrVaXD0ea8FijIEjfKT6kDI3iLvNtvAQ0
         aUhVlTjXD+VZBAdTcONBXzZ/uCc2WSQeGvx5sV95lRG8m+kHDH3DWG/td55SPK59rMmt
         KCOrEzlHs7BhWN43trcDgwLVo0TYrTDm+wQbDObAlPUr05UUCXuJa+M0wVLL9UkDwkhg
         gbElisR/KZR14Q5pxMmzAVchoAUs5gwgwDAZX/KqC0vWViDKkkC+3iKzyAGjWh6rvDxv
         eANtqM3DU+BVPIrr4AJHCvnIaqghvPMDMWYYq7jmvjxMH2YOMeuEO/SRbDLyP1zw9RGT
         KSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OHCOoE7lJGk4/gTixNGMD3xkKRQOgmki/9ld58nwYQw=;
        b=bVPSAbm9HhSOQy+ZCensuv0y2UemRS9xJlsg65I+sSm8Ag7ECQzShO9lJod0KJWyPS
         0bq5hYCcvoMGQp6R1p2TzG5P26hZVY9fSXuwLn+K8gKtg0LCtbGicozM+w6GvfvI2Nl3
         GHWqwLStxkNW4TYWCR8S3NMaLBUOlsU7UT5Lj8RU/VSlFal9MuF+M+U22sUMHMrAg3Uv
         s4PIQoYc4gqcK/5zcynk8sSaCt/3NQrKPlZ0mE9og3n8RJMphHfrHrxBid7zvy9JFlyt
         hEytccHsMr3zyqoE6lV9qwwIyhXDDG8idUTHXR+ltsDwbzzYyJPB88D3ru+WEGHewBVr
         zjkg==
X-Gm-Message-State: AOAM530EGKY9K1AOCkRTog8WAy1Xe04Holkncw7/8l1dY/m2zcjxUhMS
        DUf1niTuuAJjiXub2pz+KsuAC32rKKix3Q==
X-Google-Smtp-Source: ABdhPJwy39AemdCqFFBSt0bYj88HsLXhlvyFBdlIe8MFKlSrW3CJR7tl5jnRyy/6LMf2kbaXBMqguQ==
X-Received: by 2002:a63:5b43:: with SMTP id l3mr7481044pgm.141.1603552690960;
        Sat, 24 Oct 2020 08:18:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mt7sm2942991pjb.5.2020.10.24.08.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 08:18:10 -0700 (PDT)
Message-ID: <5f9445b2.1c69fb81.d2ca.517f@mx.google.com>
Date:   Sat, 24 Oct 2020 08:18:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-21-g136cf8fe1a50
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 141 runs,
 1 regressions (v4.14.202-21-g136cf8fe1a50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 141 runs, 1 regressions (v4.14.202-21-g136cf=
8fe1a50)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-21-g136cf8fe1a50/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-21-g136cf8fe1a50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      136cf8fe1a504a84d9c03bd71465e0b81eb46780 =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9411e1c416b5d6b838102b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-21-g136cf8fe1a50/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-21-g136cf8fe1a50/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9411e1c416b5d6b8381=
02c
        new failure (last pass: v4.14.202-10-g429275e47906) =

 =20
