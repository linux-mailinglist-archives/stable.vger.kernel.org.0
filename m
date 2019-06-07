Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9938531
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 09:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfFGHnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 03:43:17 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:43547 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFGHnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 03:43:17 -0400
Received: by mail-wr1-f41.google.com with SMTP id r18so1074685wrm.10
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 00:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q6zZEDmMRoCWC4kXdPZbMRvrjvDFFXxNc0FqmPyvKhI=;
        b=dBWbN7qrc0IooVIeECTXZJjlfdB08W7r+tJUUNpQ50IkDU9iBEd1UZdIpY6h2yZku9
         dXAyO3+xKSjvmspncT8FondZ30e4G2OUZOm5JcPJY1Hf7Wkk8bATYGdPdw52+2Mx3Hq8
         7AKBFjqIQvmFHSQkggrcyLVX6c8Ityq2y9utAb4kRBTzZGxWySskp87XA+YRAavNiBzs
         zQQBYSX9cD26aUETgNexoNb5I7cLZCYa0ru/ubHNmJhCXAjJWol51IQb3PPk84vP96V9
         tnrVmW13tkaqIy7PIotRqioHD+rEqRRWvQHhX0XkcW2hEHHc2I8RLb5XNHB+1EzA3Uwa
         EHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q6zZEDmMRoCWC4kXdPZbMRvrjvDFFXxNc0FqmPyvKhI=;
        b=YfybWIlIeWj0J2UrXzWiPnl1st3bhC/xwfZOEfZfavJ9xXp8/YZCjHqE8GPmpc1OTR
         s72f3XMxgTRPSOufnsZpwYvli1YHFSmVphzLHlZu05Ckdmxv+dwLT+tO4PifSPcOWNRl
         mqeJ4Z1vz1gyPeO2OQBjXHnoSGWA3hHvXrnV8WBfMipv96SVWSe8eHSTk/cgE3Rnzy7r
         H0i0BmsAtfqFVg9jcFCrD3/djLW4phn6GM5a6CylN5u0lkVNLEE+7OC1tXzW4WejYBAi
         FEtDjEel/L/3CYwDoRhreKgpuGkZOd156+hv3jv1vTRztgPLeRtQKrKMFYtuqsO2hsS5
         1hEw==
X-Gm-Message-State: APjAAAXlNkrHnQVYAOWfvXV/nn7MDuA6cNHMNSBjbsaXEpefVF7EhUdq
        wKgLqSWeK/dQwQJ7X/3gknNnG4PrTPlwvA==
X-Google-Smtp-Source: APXvYqyPbzFrMX/zbrf29VapHZvs9EuArTdszp5/jnlQOm6Yv5hsduTBp1w0AJa7ce2R3OVEIycPJw==
X-Received: by 2002:adf:b643:: with SMTP id i3mr3448969wre.284.1559893395488;
        Fri, 07 Jun 2019 00:43:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p3sm1323508wrd.47.2019.06.07.00.43.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 00:43:14 -0700 (PDT)
Message-ID: <5cfa1592.1c69fb81.2760f.70ea@mx.google.com>
Date:   Fri, 07 Jun 2019 00:43:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.180-62-gd9b5fd7ab17b
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 56 boots: 0 failed,
 47 passed with 8 offline, 1 untried/unknown (v4.9.180-62-gd9b5fd7ab17b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 56 boots: 0 failed, 47 passed with 8 offline, 1=
 untried/unknown (v4.9.180-62-gd9b5fd7ab17b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.180-62-gd9b5fd7ab17b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.180-62-gd9b5fd7ab17b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.180-62-gd9b5fd7ab17b
Git Commit: d9b5fd7ab17b90cb9ebd926b146b0eb16b7cc1d8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 17 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
