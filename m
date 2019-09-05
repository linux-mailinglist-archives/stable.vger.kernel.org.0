Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18746A97C8
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 03:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfIEBFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 21:05:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33504 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIEBFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 21:05:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id u16so709498wrr.0
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 18:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kw6lFi6Ppv2LkDSXe0CgFi5cYCvUwq431DN1kesmg38=;
        b=Nma5QZmU+gAovL0JVWQ8lDaIjLkOY+Z70CTLZAg6g83P9jJ8CWh956U1Y1Qa3qY8w1
         GPRzTSXG0n9MyXYReXmw2GNrQrb4TtRbPDMoxeXUd+qcy51CUkJAqlBeRAWTOz7WHiFB
         rm4jMuuTNsMd6sz0pPPIoTlXieyROx5/4KzjsyUkY7oeNSqYrCPYJpvLNKulgh+EDz/F
         5NpMy7em+B06Oa1x3yOxydIU9EZvD4Wi8qJYDbcYp4OO0aX8iiymVnuKraGqJdTWrRyH
         Rjc06RWx2lblgbltxRP4qWABOiGL70fiBPcXv7HhYDx5nIEXfht+kN6aefFKc9S06jIL
         mW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kw6lFi6Ppv2LkDSXe0CgFi5cYCvUwq431DN1kesmg38=;
        b=rKr8UIWiXZOIeL9WpuDUJ7kKNehQODFUxSU8CSOxxVk3gxjwoRfCQugt3tMk+M7lmF
         k5Eu8kiCqGRMDGUAJ4yhCbZrPu8cxIFnWOZqB9z23tOOZIjR4rPZtcdH1XgTYxwk8UA+
         Fk/B8Kqz7Exk1BxfR3zaruLOnf4y2l2XbEGuwAGepc82vyAmr93fLVZIf/o2xr8wyBET
         A0o8UFCJ6o426kiErBW8Mw9ExNwjv29OMLStXxpDrg9E2O5F6YsCY3q9XgS81fQ+e1Mm
         9MbMQpFH3VM7aCVYsf0oFIzyiwKLHsGDZUhl8aexlEvIaW3VnpHOf0TQ5jUOB+HbSekz
         NUQA==
X-Gm-Message-State: APjAAAUaqE4rvh/4oe2QRU5UnOtT91WVgn6sxNlo8It4eCI81nYqNA/N
        C30VgfCJlmdEwZ7kkmDqzFbTYqm96DTWyg==
X-Google-Smtp-Source: APXvYqy3hBCUjQooExE0g3QcL1hr8MPhHnMAN5WccfK9E2S4j7Eu3NEmmYyi+GJp/ACJoYAlAE8MGA==
X-Received: by 2002:adf:f1c4:: with SMTP id z4mr290304wro.319.1567645506596;
        Wed, 04 Sep 2019 18:05:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w125sm1615865wmg.32.2019.09.04.18.05.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 18:05:06 -0700 (PDT)
Message-ID: <5d705f42.1c69fb81.7f0be.78a2@mx.google.com>
Date:   Wed, 04 Sep 2019 18:05:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.190-78-gfab7823b08aa
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 118 boots: 6 failed,
 102 passed with 9 offline, 1 conflict (v4.4.190-78-gfab7823b08aa)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 118 boots: 6 failed, 102 passed with 9 offline,=
 1 conflict (v4.4.190-78-gfab7823b08aa)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.190-78-gfab7823b08aa/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.190-78-gfab7823b08aa/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.190-78-gfab7823b08aa
Git Commit: fab7823b08aae873a7ab1918c9a0a5125dc89754
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 18 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
