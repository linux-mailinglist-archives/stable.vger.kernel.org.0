Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08316D2A97
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 15:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbfJJNO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 09:14:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37630 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbfJJNOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 09:14:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id p14so7858481wro.4
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 06:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sceiITXJpZZwXjbZr0v1ycsxz1Z+Jz7Fjb4yEahC00Q=;
        b=BJkChjXuys8ky+58IStkYobyGt+62RMKoNSX0BzJocvF8jmju6oF/SftexYMqryO6e
         3uO1pki1mPx5tVBFTb7TT5mDdplpfvNZoqMMG54bGtllLnXfgzaVWtwRuEkUzkdWXjrl
         S6d3MneNHFdH90eQxIZ5HQlQnZ/8xPCJ2AKAQXsJ7NLirN7P6HIPwgwF9rjK1x6tds2s
         Z0X3a6SWpCaf9htztDXVW+X2hKvyLgxY9J07Wb/YE3m9FQRpdo+PIM3AOSL55bD2OHQX
         zelktfrP249aBPhQZmbnEt6kf55dt1BUDWV9HmNYKVh86fFfgHyuaVB4etvPQAy9Ktxm
         HR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sceiITXJpZZwXjbZr0v1ycsxz1Z+Jz7Fjb4yEahC00Q=;
        b=OM6znhbeMcIRUJMKAk1Cv05S36Gy58KYBwsdnogPbhs9qjRZ4cd5SHwIvjlBqmUIo4
         Xlf1BtPSugGHg9A5hoQuJkPW6IoC2fZZtl8XLzctZ8px3J63hwp9GXsxgSRENBPU+Ret
         gO0fnEx45JG5umAZgSGPexVlEGClKZ7BF7rcYfWUbtfwTVH9MJ5aFPFJ9aMwwSD8mEmg
         ACyTQFDxEGswoh4plqOBxXTR3uPtUBthqmetbkEuRuQt94hXRnRaQxPgmltoOx7P7aon
         kC6Ys3IsF1sALcZjRlTr/+CcI5Ty+W9Jzc7rf9VZdJk4kcMv5c0lCGL6RcaLKBJRfNVl
         AhPg==
X-Gm-Message-State: APjAAAWxVrspbe8jYO5EA5qt7psfOkW1JSqDfDhVxiR5YLWiPa9Utl1J
        LE+ttkurFNx3/RkX54gozUchlmHu3l/9NA==
X-Google-Smtp-Source: APXvYqyvMnVdlEMiFGkW42vI8lgwWWdy1W0HIo9KGVgFdtVaEvHXnyt3tGvZkeyKEO7MF/9XIhJDuQ==
X-Received: by 2002:adf:bd93:: with SMTP id l19mr8324313wrh.1.1570713263445;
        Thu, 10 Oct 2019 06:14:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h125sm8845224wmf.31.2019.10.10.06.14.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 06:14:21 -0700 (PDT)
Message-ID: <5d9f2ead.1c69fb81.5a1eb.ab0a@mx.google.com>
Date:   Thu, 10 Oct 2019 06:14:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196-31-gc03a561a2969
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 94 boots: 3 failed,
 80 passed with 10 offline, 1 conflict (v4.4.196-31-gc03a561a2969)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 3 failed, 80 passed with 10 offline, =
1 conflict (v4.4.196-31-gc03a561a2969)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.196-31-gc03a561a2969/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.196-31-gc03a561a2969/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.196-31-gc03a561a2969
Git Commit: c03a561a29698dec1e1dba6ac96ea4a46d7ee18e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 15 builds out of 190

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
