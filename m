Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A4EA95CF
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 00:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbfIDWNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 18:13:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38971 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfIDWNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 18:13:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so403794wra.6
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 15:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TZPdAUlA7qNN6+jQmsqssp5ULo7w+saDdp63nLUEMIE=;
        b=ysWKWkfHqQ7X3DaVIOcFXz89SawlE5pcsYTW4g+0nJSkuCstuHVj4eqvFFaO8sNr3z
         GSvS3swGYpqA22nsPCwZP+2aa7UGWC76Wmb9A8N3JQ27CmsQCbI5jNrshX07TYvlq+os
         K9cg36tWhb6qbazQ1S50UMofAM4ojs4Bt7LV9DX4mUNtwKxKeQhZbb6Aa2jRt/gbzZkf
         HZAa17iO2veDbEXgWqwQBwdvBCeMKdbeogl5qMg2m5tmZxhjiAEEp/vJkABf99WGpyqb
         axANjCpNUV3VRCVWLQATiQ4K6YO6QQ1T6T0WekN1VFLI48G7hq57G0svCyl+Ay8fMgVS
         DLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TZPdAUlA7qNN6+jQmsqssp5ULo7w+saDdp63nLUEMIE=;
        b=AkADVaVxe02XwUA3jVx5v67Qr/8NcygkUe0enqY8nhhegOidETVesR+aWp52i1mURG
         vX488MaqG7ONcDWgnIQM53WW6UPuKlaxEYhW6+9Qtj6mqwdl/J8f55rdiACfo1CGasFg
         E65G9o8j61onqnkKzLvZIdA6GcN6eAr+XkGp0MZttTrthPPk6D/t7z7QTaCXKPmYTy1H
         uXbLB6L6FxrsYyH1nE5kszHq1yg0aFA+i0OIm181PfOpZcG3KzhsHzbECHqxFwqtuEoV
         DhCWMcOA20jpBacH3S0S0t951rKi1y4w+Z2IREGfbwCWaqt/LtuCGRaadZDBRcZo0ZEk
         +1Nw==
X-Gm-Message-State: APjAAAUW7Lrm4z4oHJgUGqEOhyxKzWi3muJA8n5s4e8WAm94VLTsm+0B
        XGRZt3q6st0+MtFu8flxbFOf/NSsPWIQ7w==
X-Google-Smtp-Source: APXvYqzRAg70wjeAm6r91yACUE9AhW3qRxaULtfEpy3Uadw3/pvargQpbr422pYJ2TZcTzkC1Ajqdw==
X-Received: by 2002:a5d:49c2:: with SMTP id t2mr4399688wrs.351.1567635183823;
        Wed, 04 Sep 2019 15:13:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s26sm157444wrs.63.2019.09.04.15.12.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 15:12:59 -0700 (PDT)
Message-ID: <5d7036eb.1c69fb81.3ce60.0c3b@mx.google.com>
Date:   Wed, 04 Sep 2019 15:12:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.69-94-gb755ab504136
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 149 boots: 5 failed,
 133 passed with 9 offline, 2 untried/unknown (v4.19.69-94-gb755ab504136)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 149 boots: 5 failed, 133 passed with 9 offline=
, 2 untried/unknown (v4.19.69-94-gb755ab504136)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.69-94-gb755ab504136/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.69-94-gb755ab504136/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.69-94-gb755ab504136
Git Commit: b755ab5041366b954c39bd97caa982539e0d1223
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 25 SoC families, 16 builds out of 206

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            hip07-d05: 1 failed lab

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

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
            sun7i-a20-bananapi: 1 offline lab

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

---
For more info write to <info@kernelci.org>
