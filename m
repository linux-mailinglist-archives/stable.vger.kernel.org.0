Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B0110C233
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 03:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfK1CQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 21:16:39 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42636 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbfK1CQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 21:16:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id a15so29138749wrf.9
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 18:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lsddHNyWEvvf6VA4THvpuvJtTCDSDkdKTlxN+dKNKaA=;
        b=fstYbyhh7sJVGSDze13pVxiYgx200J4C1MKdIGB8jNBtosRr0mzeCMEhu0MuK8BtMQ
         NtZ0CiFodzq2Ye2xptsT6+kpiVnWJPmSRozMhposKyQYMlTOYxzt0Wyfv9DA2jkaVB60
         lxRvkjUz5y/Q+rPqbwgoz+tjN1Ix5lzGT3zH4fDvah9uSjDPqD84nvlcRvFfCOSPNkhS
         G54vGGMbBpGBm9ewbajs82aNbvqy4/RDRugnnDyBjbiHZoJQi4sSaIlWtW6zlIgH2YD9
         dDiO3sZTpgprq9P/g1TQDjc2vnHm2phmQ3SLz2OEhooi7mwP6197vLQdltwVV88YRey3
         MjJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lsddHNyWEvvf6VA4THvpuvJtTCDSDkdKTlxN+dKNKaA=;
        b=lmemX6DdAFjQiKIum1x6YVwcvnFglmKCI/OjcvCw+voB92sOcJ5LrK5IMOfkOD2GX0
         FqEp03+7WTXf3/fZS2hN+1eLJKPFkkugsjFAWErQ4Hyi0ikrkvNQP5PXhsTv6sUfnqXA
         TEi2h0RD7UBo6r+ODkrKE4Bt8/IROrO21bIYMUdiWv7gDhyICnMrHikw4qaNnqER/eg0
         97Qt+Fwv3Mz1lsct4fMpYS1ZlBvxxYVChGn3AikpwwXNLctxwPp8Xrdbn0sRBgrpwM+W
         Mzfr8JamqjULf+Y+byFmGxtzdF32Ezr8TipO1v85p4aV/fCkG/jX9ClrwcRPwFZPLxi4
         yE+w==
X-Gm-Message-State: APjAAAVNmBtjtJ0S0M0sOfliPjBHw80POyNF9Y9Qzx25m+hu2F76rZoR
        05vkz46SRiUVf/C8YebPvTiuCZ70cg5I/w==
X-Google-Smtp-Source: APXvYqwrvwPd+vMFiPQR0BN4KJLLhxZr9WRlLd3uvtg6Z3UBi/2/0jTXf6EMeFSZHa7ooJn9Aho5TA==
X-Received: by 2002:a5d:6ca1:: with SMTP id a1mr27279944wra.36.1574907396907;
        Wed, 27 Nov 2019 18:16:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b3sm8633142wmj.44.2019.11.27.18.16.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 18:16:36 -0800 (PST)
Message-ID: <5ddf2e04.1c69fb81.38e59.bf2c@mx.google.com>
Date:   Wed, 27 Nov 2019 18:16:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.3.13-96-g7173a2d18fa6
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 117 boots: 5 failed,
 106 passed with 6 offline (v5.3.13-96-g7173a2d18fa6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 117 boots: 5 failed, 106 passed with 6 offline =
(v5.3.13-96-g7173a2d18fa6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.13-96-g7173a2d18fa6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.13-96-g7173a2d18fa6/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.13-96-g7173a2d18fa6
Git Commit: 7173a2d18fa66e782465f57b99d2ce8feea5a13b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 23 SoC families, 17 builds out of 208

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            am57xx-beagle-x15: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            am57xx-beagle-x15: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

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
