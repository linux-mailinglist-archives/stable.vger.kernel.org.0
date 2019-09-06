Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E720BABA2F
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 16:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388868AbfIFOFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 10:05:11 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:51762 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388178AbfIFOFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 10:05:11 -0400
Received: by mail-wm1-f45.google.com with SMTP id k1so6680632wmi.1
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 07:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hiBQuDg6e0z0CnYl2YnsP3MiBvgWfsZn8g0kJ7ANm+Q=;
        b=n/+Is3eFStTPWdCeMuBWI8sC5L28Kx4fPl8+nMiDPDrGIsN9Qcg8IpNlanXaEUe35/
         4ByU8Bfs1g7ot45oc/6rzPiipDgvsU5lk53DmARR5eRmmeASjiOYyrEpQg6kj84mCTDX
         Mkiqg1X4tC4dOlX1ZcUG/4xaU4EzUGmJAH6vV7gOy73tLO4zZB26Lv9rj7aF1V4fLW1a
         pBKR2zjCyXsUaMYr6BGB++NbQlPNnl7aK4EOhGw43dthNJHvdCTFlXKlNHNi/BEalSxt
         6rPGfo83jHXRDQWm+clsXOb0QCP+WZecl2/ZtNmRzKX8tY/bI85tr1zLjG+enYUB5V9x
         FfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hiBQuDg6e0z0CnYl2YnsP3MiBvgWfsZn8g0kJ7ANm+Q=;
        b=tlB5MSfia1/9yg03Wu17jO8dcaxc8k6WIxDr10y0JOX1JdzBF5jKEITBq0zn9WWWuE
         sK30XchtklIqHRS2YG7KcBXue/9fUa95mUu9jzqZxb/zmJpalix6oEahJVKh3FB54Ilh
         ctRxa3CovtG2GuGdMOmXYxvqgXCZCdDGsg8BEGMWcehWnZ6lq6YVrsbDELAU/x2fhmwg
         Ar3MYtcXv1rQM2bkL09iR9Ond+em8slBCWwCwyF9ey7MKEPRVM27Q0JzLI+8SsQ4IiDV
         vW4tMHltov+yUpXlhlgGQrO8VR6Q9MvicUhGtCkDy+LsrTV4XdFLLhs/XVrDxZKMwsdJ
         v3yQ==
X-Gm-Message-State: APjAAAV66LvJ4MvB6B/2ICX3hZcUmeXbjDvA27xGPK3N7S/Ph9a6pzyN
        ZRPwEbGC85VVy09DNNqnH51pB8Wh0ySFzA==
X-Google-Smtp-Source: APXvYqyhaLMkZ6QcVBhH3CECrUccJrcVyMV7+WYY9xq1BIbbLHok0boSchDZs683ZRgdd0RnvhWTDA==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr7299032wmk.13.1567778708949;
        Fri, 06 Sep 2019 07:05:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f15sm5840225wml.8.2019.09.06.07.05.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:05:08 -0700 (PDT)
Message-ID: <5d726794.1c69fb81.eee03.cbde@mx.google.com>
Date:   Fri, 06 Sep 2019 07:05:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.12
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 105 boots: 5 failed, 100 passed (v5.2.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 105 boots: 5 failed, 100 passed (v5.2.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.12/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.12/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.12
Git Commit: 140839fe4e71d4db6a7b342d54cd7165490fd1cc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 54 unique boards, 18 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v5.2.11)

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

---
For more info write to <info@kernelci.org>
