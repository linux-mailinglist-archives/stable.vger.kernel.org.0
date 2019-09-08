Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B49ACF2D
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 16:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfIHONE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 10:13:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36366 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbfIHOND (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 10:13:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so11073510wrd.3
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 07:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WAT5nzo2sbljAaxnIs8hrnfPH51jRjlQQjK0v4gW/KQ=;
        b=cRXky6yDY3u0PE8eg0mnUiHSzEw1sO+dKZtPIQKCoSyZ5kbyuTYGPLrGUjWG3OWP9l
         40gn7WmeEEmKYQkK7+fatKfyN4R8HCVD0iSdbUPz5044dzCMXCbSblETwbdWC0rQu/ie
         PYP2FzpUMOsqJquo+B66Rcv+jwy0mHiyw6ngxGnrzcw/sIC49kkbibg8Jd4+nx/eZoeS
         87du4GKF3QkoggBNM9foVIsITsHmGBcsagn8OhFkhBDoy0lRJyAonlJSBsdreVr1UpII
         h5taHtyAAaxtnGuEAGjd8aVVj7dGaBxav5LUADXkRzoYruuZxaDbk+t7FjI7wjT4qkwh
         RtkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WAT5nzo2sbljAaxnIs8hrnfPH51jRjlQQjK0v4gW/KQ=;
        b=G2gNPBqw/24L/eyIJH+HWAX+773x5oP09zQMVamMaBjT1Az4AHhKuxHtkHlz8aHwHQ
         3NarWBHekW5uP3mdWzO4Aj9uplTz5e0aYp0gVEIbVUba5ZAKjQXRhZxXEj4qdCqu1aUa
         hG/L2sRnx9Ov9pPwwQFBS4znqxFqSdhvoTSnV6sntuJ1HyORj9KdqwTHmjS/R20Zfkns
         lZxfR8uMqpeDLt6T9SJF8K4+wOlmmGpoy/hSXeY1Z/3GIW/mPB29VmTkPKvQp6dtTXU9
         Ji6zARcPHCDScy7E3aTQtiAr0aUjei6NeM3G2baLpUdl3uhZ4pi9Nmn/NguuNsPbjYMb
         qAhQ==
X-Gm-Message-State: APjAAAWAlzgG+fDwolrbU34G4Zd1ARWzGPITgcG0QeuAbhAz7r9WfthX
        7gWuUsHew08ue8FEm2XpcOEWwGotv/s=
X-Google-Smtp-Source: APXvYqyGbOt5bZqXWq2I2HG1QWB0EHZNJ85HTxomFwQXv2oNzaUdIqWbKvmz1UHt5wATTYGu4iuUXQ==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr14990681wrx.192.1567951980215;
        Sun, 08 Sep 2019 07:13:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m62sm20640461wmm.35.2019.09.08.07.12.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 07:12:59 -0700 (PDT)
Message-ID: <5d750c6b.1c69fb81.50335.02e3@mx.google.com>
Date:   Sun, 08 Sep 2019 07:12:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.12-95-gcff8df27bac0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 149 boots: 1 failed,
 140 passed with 8 offline (v5.2.12-95-gcff8df27bac0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 149 boots: 1 failed, 140 passed with 8 offline =
(v5.2.12-95-gcff8df27bac0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.12-95-gcff8df27bac0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.12-95-gcff8df27bac0/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.12-95-gcff8df27bac0
Git Commit: cff8df27bac050b06d415b74f337405867736755
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
