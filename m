Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6897A1D40F6
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 00:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgENW2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 18:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728489AbgENW2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 18:28:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE95C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 15:28:16 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t40so80036pjb.3
        for <stable@vger.kernel.org>; Thu, 14 May 2020 15:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+PUObpiA76y/yhYNjpOZWpgvK7VRFpyItZHhUCmn//M=;
        b=rwOiasIkdjRAntReGK98xKV/djiruHSbGpmIQU2nuId4KzBsJaiK1Uex+q2tthKY0d
         k6I2qwNrRa6kiGVIUPOvPw9wmp0xbT4sjl6Zicda6qISmZ0uRrT1wgaNo6R1/DqUe/Zr
         eFXQ5kjtoKAn0QvitV2HsQo0pDgw/hDPkvqvpWKAaQ29AXnwCHhmpyF4qWAUVK5ECb21
         RF7d9ojq0Mrjfimvhamu5cEsq62sDXALha9vqv74KAkpljFt6nOcWZBMrcZTxsZ9/4P1
         xFtCLardPETeM+Qt6X1H+BSSKCc0eKNUev2SWG5mPkPjxqa+1KuhsVnsJwoVbRRhd899
         mRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+PUObpiA76y/yhYNjpOZWpgvK7VRFpyItZHhUCmn//M=;
        b=O8uewpLPelIiqGKHMoyh0oO3Xhe/4UDiZEa0IfFYo51b+/+A8SJr2vdbDdiujj7a5a
         /fP5GyUgQ7LHs51jXsVhsfGx4aG/Udzmf1W5leSqNrLMa7zCUtUJl0EAfBnbh9MPwNWs
         9/8Zmt+OZWt8oI6jvNl7bYX+D9frvQTh8Gz9hkQt2/b7zmuqdWkEFZJ6MpBN9xLgpesY
         hwM8cwdS3PCDORHFGA5RmTv+d0i803o2K0GoD7Z/tpFDmdl81jOT2PCrF43hTYtNSqU9
         XSsgL6L9E0UMi3JydUWp2wvfRFyOcx/QLs3aOjZ+sHvCnOyFYFJ3Wv05sn5LoHl6JBDf
         pmlg==
X-Gm-Message-State: AOAM5338m6/HeHDpk7n+mZ0nZcOBA2VdiXgQlpzmVAerVutCUC+11i79
        GY5ctGEn8wPEs1XXiw0aDrBumQhkz1E=
X-Google-Smtp-Source: ABdhPJwmwRtkey4auWHO/hhhgxqHDU3SxP5pCAtcqPmOV89e9+6FZEKPOOqKeir0Th/kUtXpK/Rjjw==
X-Received: by 2002:a17:90a:bc90:: with SMTP id x16mr221319pjr.78.1589495295166;
        Thu, 14 May 2020 15:28:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 192sm182913pfu.182.2020.05.14.15.28.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 15:28:14 -0700 (PDT)
Message-ID: <5ebdc5fe.1c69fb81.1018.0ccd@mx.google.com>
Date:   Thu, 14 May 2020 15:28:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.123-2-gbed44563668d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 146 boots: 1 failed,
 133 passed with 5 offline, 7 untried/unknown (v4.19.123-2-gbed44563668d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 146 boots: 1 failed, 133 passed with 5 offline=
, 7 untried/unknown (v4.19.123-2-gbed44563668d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.123-2-gbed44563668d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.123-2-gbed44563668d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.123-2-gbed44563668d
Git Commit: bed44563668db1bbeae9bc848d0b966a1ddb5e05
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 23 SoC families, 20 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.122-49-g6d5c161fb=
73d)

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.1=
22 - first fail: v4.19.122-48-g92ba0b6b33ad)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 62 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
