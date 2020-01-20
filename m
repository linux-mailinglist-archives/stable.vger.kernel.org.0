Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D4E142F20
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATQBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:01:07 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:43137 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgATQBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:01:07 -0500
Received: by mail-wr1-f48.google.com with SMTP id d16so30144849wre.10
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 08:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cYL1hIKHrGbsHEMJ4KFTMxqK/SzTuzaxCYqdGBpkiHc=;
        b=YNTnkgJ7q+nac77WTHE9oV6yqOJMAzN6JTU4Z2J2G7mmWHBfwYUYHA8Ro77/Xp9uon
         bFh7ImUkTU4324Pyo3AS6cJQlSoi5DeKHRnHUK7keJPafD/FW6s6tpAi3/hzK6Ch6wXp
         GhMec9eIq1V/MMjNDiVWgVqjggic7SFCEYLQAUIs9bArCmOiaaqBFIeOnL7a4dIkkFCe
         F2h0VA64mCgdGAImZrqyIUVZI55VW8VfyunKgqAEGaKZ2qLw8ogSpbt/qFY1UXgXaoV5
         Bzn8HAYRA4nv0M0dEyv8x2HnzHIAjhamkmTIVAns13Ci4BRxpZf5z/nBRipIIWYJNb4q
         75Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cYL1hIKHrGbsHEMJ4KFTMxqK/SzTuzaxCYqdGBpkiHc=;
        b=GTtyYyFtwj2fMuaY+0vyMiTknkEOTqBIowCGNe2Np1UG4ue+XdzFvYnXvZhBvR8G9W
         6c6G15BGJ/0c0RLKbsdgJeo8iAvEM/LVVbnvAqJH9xl/H3C68vk+sYZoGlpPXXX8be6E
         JUEwdOSJJCBA0JzDYSunsWHSLLy8m910QGz+YIxNTG06EUeOf84GViDVnWtfuUZr5m2l
         JBOmsHalLOm+3667jR2wxktMVPfqQxvBFjnrjcUYpGp74FZVdNM3/vhCvcFmdWUoFXJQ
         s92VbqACO4qmgNKglrOr908AHncYzgi6S8vb29BWgBtBjzu0HBCKBmh1kY2OoY6gmcM4
         0XWg==
X-Gm-Message-State: APjAAAXmV/Tvg1u0KDz+f4pu2zfHX4WRnOGwRAlvAFqwb1nlX0HeSrex
        185ek5scVLeJz3QoMG1CK3fWsYHuoBwJlw==
X-Google-Smtp-Source: APXvYqxeDsLPY/bu7xG53a26vwf26+YCbQW77QXFX4AHcJPwIzziZdoOW+7uM9ss4r+P6d1anKou6g==
X-Received: by 2002:adf:f2c1:: with SMTP id d1mr173501wrp.111.1579536065358;
        Mon, 20 Jan 2020 08:01:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b68sm24096495wme.6.2020.01.20.08.01.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:01:04 -0800 (PST)
Message-ID: <5e25cec0.1c69fb81.4ff34.afef@mx.google.com>
Date:   Mon, 20 Jan 2020 08:01:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.166-36-g73e56648bcf1
Subject: stable-rc/linux-4.14.y boot: 99 boots: 0 failed,
 88 passed with 9 offline, 2 untried/unknown (v4.14.166-36-g73e56648bcf1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 99 boots: 0 failed, 88 passed with 9 offline, =
2 untried/unknown (v4.14.166-36-g73e56648bcf1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.166-36-g73e56648bcf1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.166-36-g73e56648bcf1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.166-36-g73e56648bcf1
Git Commit: 73e56648bcf1a132796abc03945e07e030862757
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 20 SoC families, 14 builds out of 197

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
