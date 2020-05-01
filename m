Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A4F1C0C4A
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgEACux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728024AbgEACux (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 22:50:53 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252B4C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 19:50:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t9so1823138pjw.0
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 19:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vOBjDrQ1agSI7NcIsQOwFY95zampU85FwO1xP7kP8L8=;
        b=090lNtyN5zydN0O3gs80LHvKyMOPFI2EsyHc4dw0UaSeqlIhba2A3nCeJ1dPAfqWi0
         fwpfuJrg0N88EBwxMZldHo9h4llE8H6w0YZ3GCPXB9gCZKu1SXSVyTXvfao5XhnGcnWY
         1MFsyEecLXKr0Wl/+mjdKli8alB+0yd5QYgHGiL7alf4GFCQgBOGVPi7GfeOX7fFfMHx
         x6QB9D0WJrqa3/qHVZRAh4DR9uWZlwlsygogAdxP11c0uWQgXqGunD+oPwccoF3b2oAI
         wx8SQXFjGcJZT4xRKoySXeAnMMPEXMoCCwGfPI4/OlOm+EOufwvA4nBM+Pi6bjwcxSTT
         gIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vOBjDrQ1agSI7NcIsQOwFY95zampU85FwO1xP7kP8L8=;
        b=txzO9jUqWXLHFY+QOlu+q1MzM1q04LpgL/U0w9YmmUk4V5pSxqiFGbsN+irhsrxnSM
         guHgqt3fWq52K6GIdPWKbdKuOxbpkt/Nyjfs8S0A0ZNUGjVwXowGKgxIIf/Ty7hfQ/89
         oMJcrhiuyVaoGH9zrqA3DOcroh9gpQ9Zl1Rjb+eCy5tFcxjfy9HNmO2+4WqFuBLgVOq8
         hxUEEqhk+9JHCuK75dqW2bud/fFaYw7lykFw2oFan1ly1IhUeDqe66j4tPGoSvXt90mn
         syK5jiy3CE8uLOj+b5GKD0acs/QVuo7xqcVtFZC5l39SLmMMgH+GA1xy21K+tsu3aQLn
         RNpw==
X-Gm-Message-State: AGi0Pub2M5l8Rq+x0lpSzE7P/rXSrJENYySNoBXRPcG1drWp+0TrzCAF
        mk85THmxasc8ZLYYi+v7VqfirJEvdpg=
X-Google-Smtp-Source: APiQypI9ZZI7YbIa0o3GR0Pp5L3qKI0sysEb3YfhnkEj6YxZW2sJAlnAMz/c2fWV2M9KjdB0gTqfTQ==
X-Received: by 2002:a17:90a:fd89:: with SMTP id cx9mr2105545pjb.64.1588301452066;
        Thu, 30 Apr 2020 19:50:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bo19sm860698pjb.26.2020.04.30.19.50.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 19:50:51 -0700 (PDT)
Message-ID: <5eab8e8b.1c69fb81.19ca8.3f81@mx.google.com>
Date:   Thu, 30 Apr 2020 19:50:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.220-61-gf597674b96ad
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 96 boots: 7 failed,
 80 passed with 5 offline, 4 untried/unknown (v4.4.220-61-gf597674b96ad)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 7 failed, 80 passed with 5 offline, 4=
 untried/unknown (v4.4.220-61-gf597674b96ad)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.220-61-gf597674b96ad/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.220-61-gf597674b96ad/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.220-61-gf597674b96ad
Git Commit: f597674b96ad2907d2b567b0e7738c9d7f9d1cac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 82 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 35 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.4.220-54-g00dcb2acee=
8d)
              lab-collabora: new failure (last pass: v4.4.220-54-g00dcb2ace=
e8d)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.220-54-g00dcb2acee=
8d)
              lab-collabora: new failure (last pass: v4.4.220-54-g00dcb2ace=
e8d)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 2 failed labs

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
