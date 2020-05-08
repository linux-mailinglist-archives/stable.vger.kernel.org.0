Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8282D1CBAD6
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 00:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEHWnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 18:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727110AbgEHWnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 18:43:39 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835B6C061A0C
        for <stable@vger.kernel.org>; Fri,  8 May 2020 15:43:38 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t9so4974508pjw.0
        for <stable@vger.kernel.org>; Fri, 08 May 2020 15:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JO0DoreYJ/IyA64iv863XoF3DCSSU63yU3bnADzmvH4=;
        b=HwpCGaV5JRH9WL+DjlOJUfDfQyspYLAsLegd2vLwgY4+hhzzldKd+nm8S9xW7ENNNN
         PWJqZ1bzx0PjTz6rS+28VrRCo5E36BFH9FKwgk6I+0XVFBU1s3DabJfZ8ftJDcmqL8p6
         K8CLoi15O8VHeWsSbyp1DYMOlzMv9u0NluInVDBsNSJTQUovZQSi+yvSgQ7ATvPZpkHz
         CNLwluWR789EBCltDLOD6hQz9B5bdebCA15vjmIVRdtMA34mqxaxvl0vK24ZwnxP/tz6
         LfKorrbOB74rKh5txF1p2uMejAjF1nMruJ0Pd/Wk1X6WVBiATv+ALFkOE4+HLL/EanpY
         jFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JO0DoreYJ/IyA64iv863XoF3DCSSU63yU3bnADzmvH4=;
        b=gCgA4QyXdduLDHOVljn9wZRP21/Q0dOBAhKHslhNzdmarpUJWnUyUhTM1YoM+I5yF8
         zSaM00Wn5QN64+G7kb3vTfmglCUO3aC38rLvQSrTusAx38sKnFkZ3vDTOk3R4F5PeVVM
         aikTsRub1Us2dU2MpzPRuSSRvj4iEMtH+OGrJhoS87z7wLHTv6VANvqxQ8ypGFr67e8X
         UfGNFh1GHHN/zyhnRVXq1R3qn69hp405f9D33HlA+hTLUOaba0kpeQUM5NpV/kYpoAdb
         FMN9A32wDgTDyVNf6JSAnyTex9uAPaZ+ejnyqHWmv8Oz0Gz83dWz3tyEz/v0glpZzoHo
         qHrQ==
X-Gm-Message-State: AGi0PuYwYDp1J2lVx+OrHM1YSAMz2KVRCiBuqUrHOSWsC24PpnWICvyY
        Z7oVAf3CMxvdoamIX8s/XPmcKURqaUk=
X-Google-Smtp-Source: APiQypKr0YovsQwBjXbNxXyA1vd9t3PMCGhWQbRULLgz6ICSBZG9llzOhzSArFPl6ShHFTdiKdYdwQ==
X-Received: by 2002:a17:90a:8a09:: with SMTP id w9mr8014797pjn.95.1588977817719;
        Fri, 08 May 2020 15:43:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nu10sm3520414pjb.9.2020.05.08.15.43.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 15:43:37 -0700 (PDT)
Message-ID: <5eb5e099.1c69fb81.dadd2.dab9@mx.google.com>
Date:   Fri, 08 May 2020 15:43:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.121-33-g7ad26f947708
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 125 boots: 0 failed,
 115 passed with 5 offline, 5 untried/unknown (v4.19.121-33-g7ad26f947708)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 125 boots: 0 failed, 115 passed with 5 offline=
, 5 untried/unknown (v4.19.121-33-g7ad26f947708)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.121-33-g7ad26f947708/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.121-33-g7ad26f947708/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.121-33-g7ad26f947708
Git Commit: 7ad26f9477088e4d47b22647fb90e2cb53f1c9c2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 18 SoC families, 18 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 90 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.121)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
