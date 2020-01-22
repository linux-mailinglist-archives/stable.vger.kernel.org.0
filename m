Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED7414597B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 17:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgAVQJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 11:09:43 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34271 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgAVQJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 11:09:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id s144so1932797wme.1
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 08:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c5ICysMcXxRfhxqx+uMEYsRH5Rf3GHsRhALHbZ0FYWE=;
        b=r4SC6525jSMCD15pFmGxm9NxXRyAc+Jb0Yuj9mCKYet2ulJaVbUQl0ao9JLfCo6/6s
         oO1QxIaO7SOinmuXSTny9OkuKt1R5n30ZmT94yMi8wJKrJ3OL0wIzcj4K12Nf0YRn47w
         nzerNVrLBD8l8Tix8phCH6gunA1+a2H/kSuLrvp9kp6L6nQwbyJT1OJpsJpiEf9FPxeJ
         M0UVLoT5g+M0RjT3dowaAdC5k0T1DhyxmE211vUcBMlszI7sUQNaUFFovKniY1esVwoJ
         OrV7npGjS6GgYSPOv6t7vkEZiFZCT0rini6BYH0OogiqOxcAT0zdhAkH4dxGUDOf7DPe
         v90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c5ICysMcXxRfhxqx+uMEYsRH5Rf3GHsRhALHbZ0FYWE=;
        b=s1hb4Cjz0UHFdSFqPlOyXO8fWe9vz489S8GmhTfwWJNMggi4hcnL6kGcP7xj1MABtk
         V4ihUNGpJ17ki8Ah9CiUc7rO54T8UzhCVoyZ+SDDhzFxs3sgnFncUUXT1cidtXi4TrDM
         bl1HpE/tDV5fl1PRsSHkWQFkBxu3VfVdNkhAxWox5Hw++erQW/XHAcCv5BI6rfUqaYVd
         XubXe9NSu+Au63hQe6UfrurTOO+ryIpjEGKj2UcwiC5vFmOe9K852PhTLpMfemyFM22I
         tHOv5rFjitqDFfk1Q3imEpLEeOtSzmjw83+om1lZ56CewhdgtXb3Yj4arg3f3BblL+wU
         2abw==
X-Gm-Message-State: APjAAAWpZHdleKUYvsrUcqh5HDq5ysjegICbhGW//Lr6P0SoHcTy8V67
        aBCH2ae0cpiRPGx62l+ZeS0MhEUMDTuAbQ==
X-Google-Smtp-Source: APXvYqz32+MwNeNBUuyoZ80Y8luAA4ZQerPcVvq2ZyljJCMMZAD3+ti8JrUlH2EGp5HquQ4elICiUw==
X-Received: by 2002:a1c:f009:: with SMTP id a9mr3715538wmb.73.1579709381096;
        Wed, 22 Jan 2020 08:09:41 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z123sm4597920wme.18.2020.01.22.08.09.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:09:40 -0800 (PST)
Message-ID: <5e2873c4.1c69fb81.a61d2.2511@mx.google.com>
Date:   Wed, 22 Jan 2020 08:09:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.166-66-gbb5af942ee10
Subject: stable-rc/linux-4.14.y boot: 113 boots: 1 failed,
 101 passed with 9 offline, 2 untried/unknown (v4.14.166-66-gbb5af942ee10)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 113 boots: 1 failed, 101 passed with 9 offline=
, 2 untried/unknown (v4.14.166-66-gbb5af942ee10)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.166-66-gbb5af942ee10/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.166-66-gbb5af942ee10/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.166-66-gbb5af942ee10
Git Commit: bb5af942ee10d2c10d2fef949267311a54bae868
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 19 SoC families, 14 builds out of 196

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
