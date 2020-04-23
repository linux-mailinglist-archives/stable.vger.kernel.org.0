Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF07E1B5CC6
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgDWNnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728470AbgDWNng (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 09:43:36 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F04C08E934
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 06:43:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d24so2353791pll.8
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 06:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IQgxfeBD+UOYTh/BaWvQiTP9T8/HnQ2ttxOhiKmKjY8=;
        b=qcvN65INF89+giqxCxCYGF26cpgPECLW9YgU7CPoG0UyBr/CF0LTLocN5+wWsiMs+6
         v0cfWJA2253SagA5fejNDBKr6MDagN592Npv+T3cg2j0gbheYitbsN5omETLMnOC9tG1
         Pp2MSCM/bME0cyF/lw9Uy5OWhdLozlzcADs3h7kr8Gd7au3pMhztzTaeKDWwGkS/z7Zl
         syeyHNhem7ttqz/XWSk9xEGQ2Tq2+hgr7W5jxDCONm8MsFTS9sDceJdiqEADi5SPEgvV
         6cERtM3NT00VFTUYFZBOBWQUwLAzKgPHJyMZTTUEMVxOtdDU/a9eCb0Gw5bZFhKqgWfo
         v1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IQgxfeBD+UOYTh/BaWvQiTP9T8/HnQ2ttxOhiKmKjY8=;
        b=NtiD77WKl15k6at+yJ0MvNQeiNM6zTEpkP/G1FTj2esDf/ZPQuB9aAzPIusXxmHaQQ
         9Mw2FVayycnQfFXSA0jgiTvOSjVDTj7UYgBtHegVuw+9xBNC6KyaM5Lvmtb+DiCj2pL8
         tGhaXNyM5ea/RJnauSQIxx7KgXuyJFGFcvA757kPdWjXnYVlDaH3FIV2vgcM6n7/6Is0
         mNzOtRIA5nnAmBw8PbZT3fnviVVwqKpqRep4nrjUAUpPlLPJgaxC8n8OQcRTgYXW4LuU
         6LwDY68JVR58RyR5xnZVmdE2fksseyJXtIyo/+4F7Xyd3nkyEUy8+gnzlEDCJvXHa41G
         VQJg==
X-Gm-Message-State: AGi0PuYEcwV567A46egh2/dBVONApMmrBWa+UlGTR04LCtD4neQmAiu7
        HcXl1IiJgaP/F6QyxpMfQo9ocmMmGgQ=
X-Google-Smtp-Source: APiQypKbbj6d2quPJ0Mu6VwkkUWuqvTQIuG+/LSFlJPeTNd0pbqIgWWce/jxliB2ZiNBNawhheWWKQ==
X-Received: by 2002:a17:902:7588:: with SMTP id j8mr3515372pll.98.1587649415856;
        Thu, 23 Apr 2020 06:43:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm2379784pjt.25.2020.04.23.06.43.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 06:43:34 -0700 (PDT)
Message-ID: <5ea19b86.1c69fb81.dcd89.7467@mx.google.com>
Date:   Thu, 23 Apr 2020 06:43:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.219-101-gacb152478366
Subject: stable-rc/linux-4.4.y boot: 64 boots: 3 failed,
 53 passed with 6 offline, 2 untried/unknown (v4.4.219-101-gacb152478366)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 64 boots: 3 failed, 53 passed with 6 offline, 2=
 untried/unknown (v4.4.219-101-gacb152478366)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.219-101-gacb152478366/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.219-101-gacb152478366/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.219-101-gacb152478366
Git Commit: acb1524783663f011864b65a135442403625d4b8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 15 SoC families, 16 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.219-83-g20=
fbd20eb91a)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.219-83-g20=
fbd20eb91a)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 74 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.4.219-83-g20fbd20eb=
91a)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
