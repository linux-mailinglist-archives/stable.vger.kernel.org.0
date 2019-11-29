Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B812A10D9E9
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 20:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfK2TGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 14:06:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36439 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbfK2TGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 14:06:03 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so36374988wru.3
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 11:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H6Sg8xS+UxHiEqpqTCt73gfO6aJ7ZY5a3MINlYi0RpQ=;
        b=GuACQLbQfK9hFDx2BM9mnLKbBeIZB1mSoTHNBxv3R3pfZqxKY4YX27GKjd5MwZg2aI
         +moHWJyVU0kufE7LTUTFu5663nQMaMvGeuEhv2NvGn/r+hRwJDPyFsfyToEE6NHRL4Zt
         8bJZ63OlMNvXOqCbPp65xInphZy+ms8fYHsAtI+LcO2F1aN7CG8ZKmL+z5fFxq1HBm1i
         OSI2U6wOTa5YOZamKhDH3oBxazS2nLJM806ZLG2N96w+ggFsRmNwTn3CyUaewK8SNqo3
         2psuETu0L/+3/w7ldI1R5+rDidGL9Zi4J5X8jJ1gxRh+scMT2JfyBTB2OtG7kDd+3C4T
         xb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H6Sg8xS+UxHiEqpqTCt73gfO6aJ7ZY5a3MINlYi0RpQ=;
        b=PnP86EdzlPaMzDhebN6VCG9fGUQJU8A1OUWBJiKnmKasDnUwZzUc/1id6Kt1fcxBCQ
         E8L/m0JvrJccG9fUldBEed8ZtX3LeV2y2RVqu3hyqU3vg3QAsYdQm1U/GU0G1sR07Bj9
         hjuhIW6IIibXfBKoARUXbLqi1OKGvuJGxeojU/+EvimGHnVMs/Wr/gI7vdtBb+6mE454
         kccPiJt/3Sghj9bmxUwS0unUnjX7nLeL0huOzMa0XmcyXAlzhKnQQJpS5W4CaZWEzat+
         RYh6BEidBX2As/ftrgoJJAL/0WUomXHJRIQyRjysB+DEIkzDrO8THIPm6pl8/fqlYC0D
         GsuQ==
X-Gm-Message-State: APjAAAXnkDxRuvo8fAYjW7qlAOXTLtLOmLn4QKF317Fx6Jvw75Orzfpe
        EGgitevrLksROyVy7L79alLL9A7TiJSXPg==
X-Google-Smtp-Source: APXvYqwqM62jzyEYsJZ6G0KIjPvscPJ5v7E4mUH9pNuM2EsDl8k4esi0tPz64lrNUTFLyaf565g+Xg==
X-Received: by 2002:adf:fa08:: with SMTP id m8mr59223609wrr.276.1575054359969;
        Fri, 29 Nov 2019 11:05:59 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a2sm29407776wrt.79.2019.11.29.11.05.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 11:05:59 -0800 (PST)
Message-ID: <5de16c17.1c69fb81.3d68b.857e@mx.google.com>
Date:   Fri, 29 Nov 2019 11:05:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.205
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 104 boots: 1 failed,
 96 passed with 6 offline, 1 conflict (v4.9.205)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 1 failed, 96 passed with 6 offline, =
1 conflict (v4.9.205)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.205/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.205/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.205
Git Commit: 6620daa748cbad3de5824143e107a9a545f3c1df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 20 SoC families, 14 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.203-152-g3=
bbfc6b1c25b)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.203-152-g3=
bbfc6b1c25b)

Boot Failure Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-olinuxino-lime2: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-collabora: PASS (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
