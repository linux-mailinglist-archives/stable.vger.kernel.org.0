Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D785BE8B1B
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 15:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389334AbfJ2OqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 10:46:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46167 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbfJ2OqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 10:46:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id n15so13920072wrw.13
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 07:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MsqtGRyTVXgJL1XKhrIH+wAzYShq/k/GNu/Wj0ZNAgY=;
        b=dDKk+9B2Ed9BpmWZc+Cfvv1MYyMbDqUWzya/1LTqM0ln07q2Tm6A2cILpIWSY4ZSbp
         Dx6EL3xrzTYGYK379K6RFSfKZCKTKg6FufOr0+VZBFNkh/qMaiRb+oNZrC+3sbwIzNC8
         aD383q+jDUJKYINBp6JOeWOo8OhMHz5q6C509oixNIYu6CY+vX6fh4D0hKasgTISjaB4
         3yElxAXEISfDkVdqkTxiy39zUaIlrbv1am41/vhRZ29zvVh33D4MCP1P1b9rbOteU+gM
         Ll4RHQfGjOcSJkKNcCcGAq3UQnP0j1zGQtwGL7kZPXYUu9q0Txq7vCIxErYqurcig9Mb
         FaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MsqtGRyTVXgJL1XKhrIH+wAzYShq/k/GNu/Wj0ZNAgY=;
        b=n2BNbQy8ku2rMBLK4+pDW+LZcAKuEGrBJ/qZI7JpNQLvPkZaKYLqg4kdhbeoV30+wx
         kI5jWYbhHicBgTF5pU4ZN19VQUsR3R/m4woqb9DsEYENuXXOCZUhJy0jo5D+Nmpjjyos
         bzqAnumcSxHWe2QuCrZbnqPPBq8WW9vuNj1jPgAHEQU/aYYHsfi/pnRu2yp59eY0pQR6
         2GIUNVcP+vOEqCXovhez360WDXJF3+VEYBJZgYJiwlx92ja3AkQdF6fVgV5p5av4ahb6
         xI9UbiQS3fNCSI/v0V8bavx87RiwhFIFqE0CdIdK3cC/e2cyq/YV1Kl77iViFTlhLdfq
         JHhA==
X-Gm-Message-State: APjAAAVxAf/HlSprTRk92jeTh5GukCS/DzLOuX7qaXkMjqvsJhG9ggPb
        jbAYyecznX3eN8uP0vob0qCrdeIua1lyMQ==
X-Google-Smtp-Source: APXvYqx0jHdY1Rgv+CMmK99zeZ9F14XPKAQcX28n88xXXjC6D5oooQw6yuEjpjlCuPGX7cHulBjUmw==
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr21633459wrw.79.1572360369425;
        Tue, 29 Oct 2019 07:46:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 37sm25700383wrc.96.2019.10.29.07.46.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 07:46:09 -0700 (PDT)
Message-ID: <5db850b1.1c69fb81.a88fd.2d5d@mx.google.com>
Date:   Tue, 29 Oct 2019 07:46:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.81
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 102 boots: 1 failed,
 93 passed with 7 offline, 1 conflict (v4.19.81)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 102 boots: 1 failed, 93 passed with 7 offline,=
 1 conflict (v4.19.81)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.81/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.81/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.81
Git Commit: ef244c3088856cf048c77231653b4c92a7b2213c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 22 SoC families, 15 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap3-beagle-xm:
            lab-baylibre-seattle: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
