Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87E910C2DA
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 04:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfK1Dai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 22:30:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34143 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfK1Dai (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 22:30:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id j18so6327986wmk.1
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 19:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sRWpx+2KhywnjcfYDmsszgQd/Y4Wp8s/3XqlYY5bzD0=;
        b=U5AkVg8vpWPu6fRETIzvpT1MgMpxKG9SExSL62+YMtCitW+ETmh24KYAKLVTZ+Chw2
         glFzA/3OmC9hm+dQt4c0V3eQLa2R7VILF2Mv/CyTVrseapqZm9r3kHcGd0yovKbRlipB
         21IOcJxnHl5TuUs3Uk6++NMpSH/I72EV0kzB6Af8R8FKCDlol+9HsFxySapqCAnw2rqC
         SEcH2R1Ffl68xGXCWAlEngMfiqS0KQXnFDRTuMgild/JE1giYLVpMqNIxk6KY91fW1iN
         n8jLpTsodSt/Y9bU0kwlaxymkm//yVgD5vT5NfbWYeGrBDC3zOHRO2XEo93RwBlAZdtw
         rvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sRWpx+2KhywnjcfYDmsszgQd/Y4Wp8s/3XqlYY5bzD0=;
        b=aP9OQTHMgX7vk1e4d7kAIJFyeOxjZzAEq5rr4OlVhVe1kgnkdZjFNZofwIPUGORYRW
         IRokwujiUeP/rXuO7Lf8ZYsJyrCg3EcxiBmbe0lOQNiacFa0fAuD7eHCtDRwEiZaUyKq
         GSrWi0nfmf90XzKUhlyIS2HMfoq/wrfKkUmp9Y73Kh/OmXkYCRVfRrlKhu2i63ykDV9W
         VgVsWyH/Lhk/II1zKW7V5MhzmbDweCMOril1vx9CJIjjJd1g3MFkuECFFhH987Qh6+3N
         nTv7fJYAa5GnSUKMZ0YZ2uKFg6niq+7rTloWxrhtdW3giLFNjOpN0SuJrCocxwKWemi3
         9O+Q==
X-Gm-Message-State: APjAAAXP+IM/e07Lhkb0Znu6uo7Yjda4Qe9mWjlRu5C05a9s0NcU4L5W
        mII9D3iANrh2AVXqkFxCNBf84l8HpQuI9w==
X-Google-Smtp-Source: APXvYqw7AlcQfWHpLDJ34SsnBGKzPspmuR1fSN7hPfQBwQRXgEitu6k/RmPjwSZpK16WUW1T4qGKEg==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr7360803wmo.147.1574911835840;
        Wed, 27 Nov 2019 19:30:35 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k16sm9013533wru.0.2019.11.27.19.30.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 19:30:35 -0800 (PST)
Message-ID: <5ddf3f5b.1c69fb81.b6eb6.e2ae@mx.google.com>
Date:   Wed, 27 Nov 2019 19:30:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.156-212-g3ecb26dddb12
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 120 boots: 3 failed,
 110 passed with 6 offline, 1 untried/unknown (v4.14.156-212-g3ecb26dddb12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 120 boots: 3 failed, 110 passed with 6 offline=
, 1 untried/unknown (v4.14.156-212-g3ecb26dddb12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.156-212-g3ecb26dddb12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.156-212-g3ecb26dddb12/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.156-212-g3ecb26dddb12
Git Commit: 3ecb26dddb12a0368baea19c0778c267e215edff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 21 SoC families, 12 builds out of 201

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
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
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
