Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0FF126FD9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 22:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfLSVnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 16:43:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33967 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfLSVnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 16:43:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so7491799wrr.1
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 13:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=50erQzUuSywg7S9CcZLuAKFKDiLhf3PZPBYchsPQNec=;
        b=AecPZZ+KcgQ8CgLgmfqlf+J1vTb6w9IqfpHUshfRA3MplhO9DspIw5Uvk2S5eZuxAK
         WyMF152gqreIGKyhBcpMQ8dhMfx52M56ezwkHeKgEvrFP074KkEGsESECVM5rAGJ2D6B
         YeOLyA0xC2frv+LK4KwMPKhPC0JbXc2jXrunWL+jUfRiHl9jj0PKaVaeBgBu2Vp4DdNs
         27MQ8gcjF1VGuNY3R470VA8ga4qpQDXAyE8HGc7lv5uCD5KLVOyACcBEof2GA5HUrvTh
         Axi2MsT9ib62VhlnNprvmWS3odhniqUUwmzwVK5ikZ4Y4dkU3AsiyW92HTlqbeq32Nue
         e+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=50erQzUuSywg7S9CcZLuAKFKDiLhf3PZPBYchsPQNec=;
        b=dvXAFsc0o3BmWXU3boUJ8LC7HELLOkvsmo3lfmzzoMocO63vIuJDAqTY35lFujXrNV
         gomZO/RkQrGz1CSQyWGuCIzCMvsCoMDaauB+rclOa2mBZtORr314mAAWNpeJ9eDiX9ld
         JYeqEo3givKvdxsWJU3VmHIRkxNxZ/zQFQjhpxVBo5RIYaKHhbUr/Zq7VZpndPYljwTO
         Rdu5X5YXo2y1ekd+J56W4nw9ZLi30KCfCIjMtYaIXU+uZxtrJBZSpHq5s7lqDgMtxJWH
         tv8e/vSIyyM2NOnjjpDeikhNSayLjUdumnOZBUQh5hW9FwSuu33Lj7Kvyoxwyh99yQoX
         n7qA==
X-Gm-Message-State: APjAAAW5EYIlMkKeFnrFjyiZHPX4l3ymkHeb2n2tkGoQbaup+7GEYyE2
        OM3d/UTrgRHzB47Xck/FLKLjQIqr0RDZhQ==
X-Google-Smtp-Source: APXvYqwLdqFenOM2bjQ5GHJ9fmCSNs+DbauGKb2HqEHuP0BYJF0XvMPE+gWQAYm6smEn5nwfkq+sfg==
X-Received: by 2002:adf:e591:: with SMTP id l17mr10712479wrm.139.1576791800053;
        Thu, 19 Dec 2019 13:43:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d12sm7565037wrp.62.2019.12.19.13.43.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 13:43:19 -0800 (PST)
Message-ID: <5dfbeef7.1c69fb81.26572.6d31@mx.google.com>
Date:   Thu, 19 Dec 2019 13:43:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-200-gf6146474466d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 93 boots: 1 failed,
 86 passed with 5 offline, 1 untried/unknown (v4.9.206-200-gf6146474466d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 1 failed, 86 passed with 5 offline, 1=
 untried/unknown (v4.9.206-200-gf6146474466d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-200-gf6146474466d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-200-gf6146474466d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-200-gf6146474466d
Git Commit: f6146474466d51a61e14c6b9e84fd024807211e5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 19 SoC families, 17 builds out of 197

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
