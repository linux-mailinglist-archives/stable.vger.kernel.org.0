Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEC6128A86
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 18:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLURB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 12:01:57 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:46802 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfLURB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Dec 2019 12:01:57 -0500
Received: by mail-wr1-f44.google.com with SMTP id z7so12325830wrl.13
        for <stable@vger.kernel.org>; Sat, 21 Dec 2019 09:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/pp/QuPfRkAl1T2iBL2m9LjHwnHs45kOblUPaLh0IiI=;
        b=Azmw4Vwg++zHdOv8sL7EEymF1OB8S12lD1QsbOT7Tb+luMEuDdFncQjaphpQZYYXgD
         0d2bm+3EWbw4LwVdcW/EgnezwBsc0Nf7XmF76/sN+9TGHqbd7TjU0ye/szqQKu89DLIO
         GILGx1xKP5g+OLTW8iVR/aGH58GlfwcEX/3Ecf7MR/MimkrElUez7edRmYgTHzHfCj9x
         Fgr9pyIKGhSD1zHEQlKsB+8F/bBN6DQZPBQvARZ98IeWfGY54scehpspWz5Ps8Xjf/X8
         UMsA+iziQkjLmz56CfKKnVCwsIfxfxNWkRDEheEG1hLOEzwr5UTPKJOWy/26YVH42C8f
         FZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/pp/QuPfRkAl1T2iBL2m9LjHwnHs45kOblUPaLh0IiI=;
        b=eX1iZt+Fhf1tB6Kc+8zcTPb0RR9I6LMbOeOe0u5jaGM4mnXxVq/U/zzkVO1/iuDJFv
         CtQB/2dNFFZ95+XF5BW+zSVVm0MgP71o3wBhPo7lmWvHaq9RVpJRvPSO6cOolgGD0/jZ
         MqMc1Au4eCPcQKtuNdNzgAyc9vHEH6xEwZ/VncRXPL8A6u+YjtLEEOavC7xvNU/9dA9g
         RLqBtAcsKM3vw+K2tnzwbbSFwqBWtU+K2eA2Nx59E8FLDmEF9++eSARpKKskl6MeGMlV
         CAKpfZQvOmUhtlTwLE/MGh4XrL+lXV26a72AO5ggEcbC4BsfzBLlH2poBu/L3c+4kffm
         iRVA==
X-Gm-Message-State: APjAAAVjElg5a+iHqAl8eAzQELBnAM8E0JbkTozyWgSXIbjDcoTa2Fsb
        GcANeEtZnC+/PX9zKgyESgT2Xomxfmd9xg==
X-Google-Smtp-Source: APXvYqw7ewzMSl/jnRkn4LI2vHt7enSawA1KUq2uLYst1nZDma2fcWbQinIZzKdfITH7tLqmhep8YQ==
X-Received: by 2002:a5d:51c1:: with SMTP id n1mr21162332wrv.335.1576947715138;
        Sat, 21 Dec 2019 09:01:55 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x16sm13976431wmk.35.2019.12.21.09.01.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 09:01:54 -0800 (PST)
Message-ID: <5dfe5002.1c69fb81.88a14.62ab@mx.google.com>
Date:   Sat, 21 Dec 2019 09:01:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.160
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 123 boots: 3 failed,
 113 passed with 6 offline, 1 untried/unknown (v4.14.160)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 3 failed, 113 passed with 6 offline=
, 1 untried/unknown (v4.14.160)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.160/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.160/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.160
Git Commit: e1f7d50ae3a3ec342e87a9b1ce6787bfb8b3c08b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 22 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.159-37-g8=
38b72b47f7e)

    multi_v7_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.14.159-37-g838b72b47f7=
e)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.158-275-g0ddb1a5=
05fdb)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun8i-a83t-bananapi-m3: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
