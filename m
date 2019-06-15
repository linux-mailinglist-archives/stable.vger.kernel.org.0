Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A992F47263
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 00:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfFOWYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 18:24:21 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:43042 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfFOWYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 18:24:21 -0400
Received: by mail-wr1-f48.google.com with SMTP id p13so6009615wru.10
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 15:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XkFaLpyc6QaKUEQB2EsalcSQTJkNIoJ2yM/4SOFWmh0=;
        b=aG9eQeJHq0oJYyhEv1XXGGbypBbBgqh2nUc5h/9MvkUFDA8Zn9p7shCKAl1HNKyqiq
         IKd0aSYoZPqVSSfPqUgOTcICscaqv3hWaWiDdStmx4I9pICvAAAhPMkKrrnEDVrcpVe1
         gpGIru5GY8KmbAod4HIokF9X0SUHi5e+NEQOq7nRfxkKTd9uF/nwLBK1GE2oFgYqPay0
         bs3v7Q/U/3OjhLB/8c7P9SY0QMnt+d26nKvJxGDDtIJBDBl3U5IGn3xDkKpT0XSZTOA1
         /MGEF8FTRySFyKl2VxiqbFHw+RULu5l1V9x9R9e3vA/JdhuKsYlwIP+tZ9xHAd4t8qpB
         EznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XkFaLpyc6QaKUEQB2EsalcSQTJkNIoJ2yM/4SOFWmh0=;
        b=Sobk6rrjO+5EJNXWjziAsYQIJWjDMAcAwiR3d1xT/veWze/a7PrtRWVblYqAzLWRTW
         vZ9uzZ56xnTCZPUmz/3dm4tI0nSOyVdHKUYLqw6eSdljqhWpTi6HK1CjcWI5beL7r/I8
         AEUdKsM8WXcB3HTRSHut+bMxsBfvt9jJCWi0vfpoZjW7Zu0pnbGd8vB6nYVhI+IxCsQ3
         iJOagDKvM3bA8fTn13wB2RmV7AEhocJm+c9BYii6otCTnan99rrjCUlNwL2/tkClIcL+
         nKxKJjWgG8S65UOaKMKKFqHTx//hGxT5BI1sidA2ZX2rfkJeCYusnuHDMoK8pCm/tqcq
         WIVA==
X-Gm-Message-State: APjAAAVShHBAs1upKuIAovTTG+hRddbOQ4knSzaOoULxTqPEwoKqhRkM
        my7+A6CgXNyYAyNcMwqb7V6+OTiV9lT6ig==
X-Google-Smtp-Source: APXvYqxkT4xRR0op0HMhctPQXJONPmOtONJvVKu2rRlsIisUoFMoqOSC8g85fQJ6FJrKZwzAASXv0w==
X-Received: by 2002:adf:ed41:: with SMTP id u1mr23148359wro.162.1560637459007;
        Sat, 15 Jun 2019 15:24:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l16sm6345725wrw.42.2019.06.15.15.24.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 15:24:18 -0700 (PDT)
Message-ID: <5d057012.1c69fb81.d4082.0cb8@mx.google.com>
Date:   Sat, 15 Jun 2019 15:24:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.51-27-g30f09c85ce9e
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 110 boots: 0 failed,
 97 passed with 13 offline (v4.19.51-27-g30f09c85ce9e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 110 boots: 0 failed, 97 passed with 13 offline=
 (v4.19.51-27-g30f09c85ce9e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.51-27-g30f09c85ce9e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.51-27-g30f09c85ce9e/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.51-27-g30f09c85ce9e
Git Commit: 30f09c85ce9e3fa9714540d4e024efa0a23bd44a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 24 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-axg-s400: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            mt7622-rfb1: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
