Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BF2112033
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfLCXWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:22:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45858 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfLCXWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 18:22:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so6092997wrj.12
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 15:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NpenWaUnhEmG0XfcQQWcUjpUKGMIJpUPSzZJnMUmC2A=;
        b=zNyi3JFy/YOWC/R5xMR5rYvtclnrFnQbHHYOH64b02+59ebd6RJtMVASpCJvD+FWYb
         OFCDzbSZBMUZFItsSC/MBRa1Cm6BIdnORGmHAOti7JiDUUuqUbB/mnlxM0WDSACrLBMm
         W9GwtIAi3jH4/tUVpyrAVEEMZGAU1dV3yA6KJG7hV4lXJIcOrK2F9tRoGNXt9Mt2iLnb
         tU0fP6qVTXiP7c7jB3NF2njpJlCditffIt0XVQJVlHPGxXSWq8TFFaSzuwmAtNQy4/zk
         5HwISooCqFx6qNKcSd+mXjTRsf890ep6HCVKrj1oMIT+OEpemxolRGy9wt/Y01uZ+VL/
         5Dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NpenWaUnhEmG0XfcQQWcUjpUKGMIJpUPSzZJnMUmC2A=;
        b=qVEMZJMaHBwKVyVXS/d1n9i5ANr+DowjImxWoW0CD49E33AyoeSiSSf8DGIMLFbNQN
         6wUR1A3KO3WdUZ4aJm6e6LpAeQvGyYjBFhGNtMuhi0leIr7ZaMkc74djz1NwH8QCq/SH
         4bfqTiimFcvPveJkdjWZpl2nVQh7U6iOmiAFB1N21uW5ekR3ibulxL+5MMZggvmPBi3D
         4joom6r9mGy3AhZXzlOLFZdP/3holXnDZVz+9veUg6TDktGaKtHx1RoSBqGqJI04QgUu
         l/RqJT9VhINjt2zf3CpNjqchzGwRlqOCzq1Lbo17vSqrv1jPYFWfqUc3VC/+tMObGN0l
         Woeg==
X-Gm-Message-State: APjAAAUGk8aHdVqJY2aWTBxd3rnB2S/ynMkApaqN0cfc16KgX8qpJU0p
        sgsTxGDO0TTYeImzV5mlCYTi+ZCoUZPfAA==
X-Google-Smtp-Source: APXvYqyvZETzjgMsCLTVXelLlOMtJIAgEYzAC4dJVQkHNQ6IZyeaxOZuazjKWFPU37rAyVBMOrB7ZQ==
X-Received: by 2002:a5d:6ac3:: with SMTP id u3mr589054wrw.25.1575415348175;
        Tue, 03 Dec 2019 15:22:28 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm5903300wru.38.2019.12.03.15.22.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 15:22:27 -0800 (PST)
Message-ID: <5de6ee33.1c69fb81.2d872.e361@mx.google.com>
Date:   Tue, 03 Dec 2019 15:22:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.14-133-g7c5eb6144103
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 154 boots: 3 failed,
 144 passed with 6 offline, 1 untried/unknown (v5.3.14-133-g7c5eb6144103)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 154 boots: 3 failed, 144 passed with 6 offline,=
 1 untried/unknown (v5.3.14-133-g7c5eb6144103)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.14-133-g7c5eb6144103/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.14-133-g7c5eb6144103/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.14-133-g7c5eb6144103
Git Commit: 7c5eb6144103f29dc9f28ef0b9b5f65ff075cece
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 90 unique boards, 25 SoC families, 19 builds out of 208

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
