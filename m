Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423481EAB6
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 11:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfEOJKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 05:10:09 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:47075 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfEOJKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 05:10:09 -0400
Received: by mail-wr1-f52.google.com with SMTP id r7so1730746wrr.13
        for <stable@vger.kernel.org>; Wed, 15 May 2019 02:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=unl8DaKp7vc8j9zsOOcoDAKEMTP/5adYVQ/K8v+ta4U=;
        b=tojRFCesYEt8S9M42AL9WmrCriOeIVe5vCJNQYSMO1qyoAjqOGB+/FoR/lq8UoQdiV
         sg7Yky7VY6PLEHQyD6VUFHec4ks+V/ZMqSCBu+R4YUaVBJJjPGvWfQr5mFkHJIoK38GJ
         ZtS4xR6xNdaCJbhZrT4xSHCz2709AKVZ1USz8M6IkDQK7Xy62HJXxXdfl9EYXW0b6DHu
         yMCYjLnt+JNzDAQBLrUN2uPXhj9l83UBH+D+tO58w+SQZ3BJc1YKP4PHFLRDD5Dv+kCA
         XgKwjwStWkcPQ6+5C5qSWEJ+i8ghNMoUq/v30Wa2JUpB37o0BEQL6zAE849rvNI5DIwz
         qOVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=unl8DaKp7vc8j9zsOOcoDAKEMTP/5adYVQ/K8v+ta4U=;
        b=HPd/lCMJe+DA6KbD74arzUuLaPi4HTesgQyM7qPvO7G+zuUM3YLs6p5r1ZcPMJoJCZ
         XRbP27VxvdmMmUy1S5llztpgBWVZfYogmj+DgpTQwwYz5x46FUjgZVyn1aYvp7ByRUWR
         ucWSdjGr8VZUZLXi0R2isW1E3ruTIWWjiBLuGcm0YVzBJRs+DrOS3mIe8H2tFHWgmvUt
         MNbND0vfpvX6O9KXlnLBWeNZK4LuTE8rv75tPNBvXD7u0pCcDlygBb5qFqoMlzqX4wF3
         oveVf2PpLj0dWItk9X4m5dC0ucQVTY/y/uBlLlowfmfqj3wdZqK+FWzedzKM5/PofxIM
         kHTw==
X-Gm-Message-State: APjAAAVc4GUAWpwS0ypQMEgGnNFdZ4MYyXdUeefr5QlsGPh0Z+X/+iQj
        6VKFHqVc5RiMCxgz7DMkwP2ZV0Dy6h4sJA==
X-Google-Smtp-Source: APXvYqzfEVIq+VnAquUEZgvDI/S9qWD/BGPfY9cPIaF4tGOvtmSOCDAqVN2iVq2B2KAZcQoAx+dX2g==
X-Received: by 2002:adf:e309:: with SMTP id b9mr24187080wrj.135.1557911407345;
        Wed, 15 May 2019 02:10:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g6sm1819108wro.29.2019.05.15.02.10.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 02:10:06 -0700 (PDT)
Message-ID: <5cdbd76e.1c69fb81.5fa5b.9a15@mx.google.com>
Date:   Wed, 15 May 2019 02:10:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Kernel: v3.18.139-76-gd3d7f4845dc0
Subject: stable-rc/linux-3.18.y boot: 59 boots: 6 failed,
 50 passed with 2 offline, 1 conflict (v3.18.139-76-gd3d7f4845dc0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 59 boots: 6 failed, 50 passed with 2 offline, =
1 conflict (v3.18.139-76-gd3d7f4845dc0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-76-gd3d7f4845dc0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-76-gd3d7f4845dc0/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-76-gd3d7f4845dc0
Git Commit: d3d7f4845dc0871e6b52a3910e782c51f4af4e87
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 13 builds out of 188

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 5 days (last pass: v3.18.139-52-g=
f85e9af98591 - first fail: v3.18.139)

i386:

    i386_defconfig:
        gcc-8:
          x86-pentium4:
              lab-mhart: new failure (last pass: v3.18.139-64-gf6ad567f1ce4)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu: 4 failed labs

i386:
    i386_defconfig:
        gcc-8:
            x86-pentium4: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
