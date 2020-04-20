Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DCA1B132E
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 19:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDTRdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 13:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726296AbgDTRdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 13:33:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223CEC061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 10:33:05 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t4so4189165plq.12
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 10:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bhf92DpJzg5M6q5XNSu0Z/wtjrVpMgkBiiaETe2AuN8=;
        b=ia24aDD/VKx/PrUr8nWeVtwSfm/+swfGtAWExOCU14TWXFgFS4cQoHRdnKHoG6ZEgz
         r4Jeyk25lqhA50mJ+X4BO6VWuPQYw8AH1EcLNv4x0pZVG3MV7R/8mt1wwIRAEn+WSzgE
         4QEWaUVtpPF5vcooQwOJasoAkMrmKmXLyQVIAl0RzexQIw/hsNEs1VzrsynBVbZCrDT3
         G74YXBRb60os/FVvuKG4MtdcSgzO8ZEc+Yf0DuSURN71o9fD9pGHagzlVEp9qTF0+M8x
         FSDR7mW7oV97EJNtHIh1cLfqu4LqBz97zQ+sY/OFN05O5u6NPf/krYWIDni3dnLjwT+N
         nRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bhf92DpJzg5M6q5XNSu0Z/wtjrVpMgkBiiaETe2AuN8=;
        b=l0u08S4jewQqxXArDiLcmtoDxWJYBda6otTf75mnZbTmT4NzFTAMv2h+CP0M6WyiXp
         WMsg+pVH2IQlJlUA9sJ/doPSfuFNm7PD0s3ZGrdq85EfhzLzLiNnhturpUaMNcSYRpwc
         MAqtPY5o/YwIuu2aSIFzBaD3XdI1jcQnCBkFRkH4p2A+MFwab2uU7o0DZKsbrn63ZP3D
         VWiJGeeVhXLI3LHQUlcmQx6/2pm0qBI+fSD3Bwkj1z/XgKdVJXDz4qCdiSxTrdgmKizJ
         cjwTek8P7SBD/K7NYOz8HyLToNMJ6g+CJobaC2n7yAtNWKg4pLfh1VE6Uq99oU9nArL9
         IaqA==
X-Gm-Message-State: AGi0PuZK13jZ7nMOyo2e4IO+grl7NxwthjAzCMfLv4uaVVaaTaFxeOJ5
        NyOXA2vQbcAfc3ljZ97qve2+Vni9mUw=
X-Google-Smtp-Source: APiQypK3Fu/T+6oTj9CYKV7CMQHdrZMI94+OaC+ekalix3DEkGZgNFiWQPQ9p+ch+17O1NRl85ECmw==
X-Received: by 2002:a17:902:b10d:: with SMTP id q13mr17352924plr.265.1587403984342;
        Mon, 20 Apr 2020 10:33:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 127sm73124pfz.128.2020.04.20.10.33.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 10:33:03 -0700 (PDT)
Message-ID: <5e9ddccf.1c69fb81.5d0c0.03aa@mx.google.com>
Date:   Mon, 20 Apr 2020 10:33:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.219-69-g1e8fb731b4b5
Subject: stable-rc/linux-4.4.y boot: 84 boots: 2 failed,
 70 passed with 5 offline, 6 untried/unknown,
 1 conflict (v4.4.219-69-g1e8fb731b4b5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 84 boots: 2 failed, 70 passed with 5 offline, 6=
 untried/unknown, 1 conflict (v4.4.219-69-g1e8fb731b4b5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.219-69-g1e8fb731b4b5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.219-69-g1e8fb731b4b5/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.219-69-g1e8fb731b4b5
Git Commit: 1e8fb731b4b54ce20c995c2248d2548a0dac04fa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 15 SoC families, 16 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.4.219-66-gb854626c87=
20)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.4.219-66-gb854626c87=
20)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 72 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.4.219-66-gb854626c87=
20)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
