Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D50FFF8263
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 22:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKKVmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 16:42:45 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39077 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKKVmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 16:42:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id l7so4704336wrp.6
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 13:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AVqtbRNRRFsUi4329Ecr0hiHwWjdjJrf0HsRfYnWhnI=;
        b=nZH2wmd6e3Mj689W3h+rexa9WLRZRYZNW5twZff3V3O4H3260nEYHBXLLP8GoBV2AF
         fG7Wy88GZSThqYmcyI65VUw0ABk5iudkfXmVfNwzQByEq63TFNVen1/A9a72dM2UWptj
         QZA6jin/b+ZSyYcj+RPq2UTvPqTKhV/ohW+R2fiJBo1zN2egsbM5wBh7XJC0PwmAKO7A
         MOEa0JIeqPVNP9oVXCMNjVOBEJqi653Ss8zEAyYvNadKWOhZC/vgsi38N7E8Fjgu5Dii
         /R6GGOIbMFhxmHKEQPHezLl5bxkWYb8kGqGBepqnlZxsiI4vxtfPv2wyC0PQtpkR8D3g
         9EVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AVqtbRNRRFsUi4329Ecr0hiHwWjdjJrf0HsRfYnWhnI=;
        b=ZE6MVYCJXPpgWKR6xAeAqvZl6g2eWXaHzVlWnd3BYWysoSasz7PiIoOrRzoGPd6sQS
         lVzUDeuwbkS08lpqf6atW7Xaq1B5oTEM/VpubU5Y4UOAu89O1tzXcTpa+MHVd5dwnSqv
         CVlMmr7KJYGKgLbUNv5/W9d66aFYB3gdG3/gAgEih4UT8E/H0iLtT+pmLig+89Lp6a9D
         Pk8ahuaC3S3wAoz55EnXx53mA5NWItbV3xK0fvHe00XzxfOcAmxJFNMTspZKPsLoqZSM
         SNDIN8tnhFLFSKpovACR02x+/wRR7BV3Q/YbTS3R9xdz9WUMq0L/hJQ06wvMC9puFNpA
         pXfA==
X-Gm-Message-State: APjAAAU+95fJ6sF1PJhTvSXw6eZJY7ZVffA/Us3OEGMTnhBpoJyV6qph
        WwzYfNEMsl+sK3ky65zrwuRaP4uHfCRaqQ==
X-Google-Smtp-Source: APXvYqyn03T8MicdT9hBV0EcjbiMBhJbBbm+sdi0zDU5kClJ1T7mw9N9V3swBFHYCRAsD5wAhovctg==
X-Received: by 2002:adf:c402:: with SMTP id v2mr24317927wrf.323.1573508562124;
        Mon, 11 Nov 2019 13:42:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm7249824wrp.64.2019.11.11.13.42.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 13:42:41 -0800 (PST)
Message-ID: <5dc9d5d1.1c69fb81.f7c72.1ff6@mx.google.com>
Date:   Mon, 11 Nov 2019 13:42:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.200-42-gddead9ca7c1d
Subject: stable-rc/linux-4.4.y boot: 42 boots: 8 failed,
 32 passed with 2 conflicts (v4.4.200-42-gddead9ca7c1d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 42 boots: 8 failed, 32 passed with 2 conflicts =
(v4.4.200-42-gddead9ca7c1d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.200-42-gddead9ca7c1d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.200-42-gddead9ca7c1d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.200-42-gddead9ca7c1d
Git Commit: ddead9ca7c1dfc3eada549fa73f111d90d46563d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 9 SoC families, 8 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 1 failed lab
            rk3288-rock2-square: 1 failed lab
            rk3288-veyron-jaq: 1 failed lab
            tegra124-jetson-tk1: 1 failed lab
            tegra124-nyan-big: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
