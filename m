Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B10104862
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 03:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKUCAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 21:00:15 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39360 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfKUCAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 21:00:14 -0500
Received: by mail-wr1-f67.google.com with SMTP id l7so2336486wrp.6
        for <stable@vger.kernel.org>; Wed, 20 Nov 2019 18:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HzXCjY+iBf4WLN0ewKiOKVGmHyXy9JgHo1yQkbW8DYE=;
        b=lCRkxcuj3Y7NbVvDQCisiB96wF2iO7VsoD+eVk02YaPU8iiR3mzV8BHM+fa3MBiELw
         BdvkVAmW9pGgKwbej76dfDL/zohIlwbGWfHLEF/UwM0+oBMSiX5uKfJJ8cE1Dyb8j7YU
         gVvA5WJcR2gWDdmS09WBuvHrNzFgz5Z/J1TNMK7oqLiWseLRwdHEyw/cESyNrUuQ6rj7
         4rGK9TJEzFAQw13htWFwZc/QnJAMRGXZfvvjx9xPudI5Iaznr7uHNi3bIr18t60vnAku
         zBZ/DasdpX+0ElffQksq/oYaA1z82Mu/55yLHd27acb6xsmEChWxT+GGikmKu9vb0UIA
         jCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HzXCjY+iBf4WLN0ewKiOKVGmHyXy9JgHo1yQkbW8DYE=;
        b=kqxXUFvLvitULnpYQC6JnOsbLMKMzGR8Jb6IySPR8mGmZj69iAvIEgk4VmeaGHZ+Fr
         qIiuwv1eqsRU8G6UmKrOUOPB9BxTC+bvc5ZgH6sC7t4Kpf7rU0QRXw4e5ukehXGqFyF0
         lNQ4EcPkFAC5YXFj6K7qIugQX8DKzyh2+9G5+PujPlZ64R5PxXIjYOrDdJU4QVY7wHsH
         pvO3EmjAz8D3OfTiTtHmo7/74DF1v+mG+5oU1886sHuRIq1XwLoaXD8fPwFGWc0k/gL4
         ZE8gD60U1aEEk3V9L1UuWByvPFef58P5S2yIZw7NgFkcgcHhuJoVDPzt6P/0U23h8f5W
         viIA==
X-Gm-Message-State: APjAAAUdtS53xtAsyJGgc7p7XryFlN7GBTF8f/Qj2L+9bRfAhjgBVs96
        dJCApr9UvZGVjBiMkd2NEfCtdgwuTagwvw==
X-Google-Smtp-Source: APXvYqzse/X88wwJHgvoKzZhOaXa2Gvj738PCP6ZLRRCYM4slxzomEmCWYpC+LvgGqYoy3T9Ot8Dlw==
X-Received: by 2002:adf:82cc:: with SMTP id 70mr5516546wrc.231.1574301612619;
        Wed, 20 Nov 2019 18:00:12 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m1sm1460226wrv.37.2019.11.20.18.00.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 18:00:11 -0800 (PST)
Message-ID: <5dd5efab.1c69fb81.41033.7466@mx.google.com>
Date:   Wed, 20 Nov 2019 18:00:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.85
Subject: stable/linux-4.19.y boot: 78 boots: 4 failed, 74 passed (v4.19.85)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 78 boots: 4 failed, 74 passed (v4.19.85)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.85/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.85/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.85
Git Commit: c63ee2939dc1c6eee6c544af1b4ab441490bfe6e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 17 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.19.84)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.19.84)
              lab-collabora: new failure (last pass: v4.19.84)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.84)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

arm:
    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs

---
For more info write to <info@kernelci.org>
