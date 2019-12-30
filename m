Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3812D50D
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 00:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfL3X2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 18:28:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35121 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfL3X2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 18:28:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so33961688wro.2
        for <stable@vger.kernel.org>; Mon, 30 Dec 2019 15:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xtVeVlWslrvn/YqUwOKZ2MNg3SXb9T39AaJssadLfe4=;
        b=vIrXavMU3ggQhoc26cqAKfCzJ7cRzeblcKA/2/CWICx/w7u1pDN4s7jiy/nhMmo0xO
         jw7XVq890Xq5P44ca6UdCOtvd7sTtX9KS0jrXqRHBNNAW418MNS9KO7vjgH6C0isJc1Y
         qmC2zjX2nwDL85qnti+//CSzajzcquwRXXfhnG3BSl6TxMa9YkYhalBgi8kl44x+YsEG
         ed7/DTfVyGNDEhnggYgWFEScIuwDo+H5sPKL1gSIqyFhDeK1ugkMpj4y1Ir7rLv5wC0r
         xwO8qMm5EOPe9EcpfgGY7WoH449EmDM193ppn+EUr/jOLzTRKQYjisakjdW6V3YM+Gu5
         W//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xtVeVlWslrvn/YqUwOKZ2MNg3SXb9T39AaJssadLfe4=;
        b=mxjLHsyVZIDhVF2Dl1onby62we+B4gnDw41LjFoMcNKAel+XKxQKz6m0OBsbN+5MBA
         hCFDhmQu4j2crPN1TME6UXO9o70MU1q5YFOgB7H0C9o6nxMznCgEnxSk6ZtlCbCcWS0T
         FnY1fnDzt5X10Lu/piArN7n3gBypxlmuOqjfgoneGbGGgvEh2EQFFIWEuKVziWVcZ6uB
         Noi4bEVQIzTGBPkoYUYpCkMsPKNXWZ/Kl0LCWOZrBqtHzIznQ/glwNDidVGQzR04r1gT
         /DEXXkL/7hBEa+wtl0c0sPUdJJNnWbGnEbbuqW77LYPh4hnTZK/jMR94f3TrETy5sRw8
         eSjg==
X-Gm-Message-State: APjAAAVMfnlJUbwOhsuPQOXIddFKE6dOqaakQZ/j0GbEdYEr8/tX7+Ce
        Ymr+3BxWzDVLnEmCYzQ4FVPT9UgT29gjvQ==
X-Google-Smtp-Source: APXvYqxJm7ZaMQC0LxHVTeDxm2OmTv5t7mazVD3/hfXNtNXgUk7zXH7dRqN9yadYncwhdaX8Rn1jIg==
X-Received: by 2002:adf:f990:: with SMTP id f16mr70766538wrr.185.1577748483810;
        Mon, 30 Dec 2019 15:28:03 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o129sm877835wmb.1.2019.12.30.15.28.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 15:28:03 -0800 (PST)
Message-ID: <5e0a8803.1c69fb81.7766e.4be6@mx.google.com>
Date:   Mon, 30 Dec 2019 15:28:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.91-219-gbd997e91293d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 90 boots: 1 failed,
 77 passed with 12 offline (v4.19.91-219-gbd997e91293d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 90 boots: 1 failed, 77 passed with 12 offline =
(v4.19.91-219-gbd997e91293d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.91-219-gbd997e91293d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.91-219-gbd997e91293d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.91-219-gbd997e91293d
Git Commit: bd997e91293dfd45337c580be508331465c386a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 19 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.9=
1 - first fail: v4.19.91-220-g798b10a6009d)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.9=
1 - first fail: v4.19.91-220-g798b10a6009d)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.9=
1 - first fail: v4.19.91-220-g798b10a6009d)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.91-220-g798b10a60=
09d)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
