Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAC411C03F
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLKXDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:03:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44994 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLKXDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 18:03:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so469816wrm.11
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 15:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MSgszJssCJATLN8LywwxEi1kVqClfvjNbHCO+OmX0Yc=;
        b=uhlnfGZ02E+nUBW74bYWhkyhw8M1Mc+sjQ3UmXIplM77DZkAmTb5EO9e+kxVCTiEjL
         Ry4p0RVDQ3MeaGhtv4C//DiNRTsxowyO2d9nXEAUG3nBSUHCp4FsddDZtfgvCdQxq0GY
         i+N/1nk0TQECtd405oGd4pOInYv/V8EDQqM/uL/0hmixiYkve7dE75gwTMjxQs1JV7eG
         8zIR63Uw48UTt49RY65bETjR5sKLKwjrQ5+/1yyz3wcnq+89gwHeY1J0OsXyRqVttpMw
         O6zPzeFOJv1J4+f+yDY/O3zFSzjZ/LbD3Z5xFetWkr07U+EqnkiR7W0lHAn2CMQz4msL
         /S+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MSgszJssCJATLN8LywwxEi1kVqClfvjNbHCO+OmX0Yc=;
        b=XLr3u9ePzwMP2sdEHqJARJjnGQ1a56T7j4ybVetvuRG3cKbqMBXEqC2y8SOquDGFLX
         gS/AMR2lzxBeXuDeL1wuydkqWIZr74VKy3Ov6AAjN4uB/tPc138mDSjd0iFF3FzGyAb0
         w4pwmHJ3g17goesI+1nHLdPTKHkPS6MBtTAEHsiD37ErUBNpQ/zvYnRK3kLLNHGEKhrI
         cabiWCr8eoB0dy8sN2GvhWTDL0Dko/xqwO56sD4uPDQa5gW1hC1EnIvGALNuboz0mjRZ
         KDUrA3QTYCJrjy6UJpiyHeYN/3zLbuJ88i7Ybk7FMTIPsvbAicxVa5R3Dv0+gHdsCQBq
         ffRg==
X-Gm-Message-State: APjAAAVlVd885+C0xIm2NIA2nhyIcFPQwJb0oQg4d1UAyUOGEo5a6zEW
        taGVDG5W2oQ+2jpKYcGduWUJBTX4ODeDTQ==
X-Google-Smtp-Source: APXvYqyUH/9OufeWfmlwKEakdev+Crgwqt2Bo+n88WqiVDyoATYCJLwhlgZqxv8AlUCGHvhUqNDE2A==
X-Received: by 2002:adf:db84:: with SMTP id u4mr2466085wri.317.1576105422571;
        Wed, 11 Dec 2019 15:03:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a84sm4019618wme.44.2019.12.11.15.03.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 15:03:41 -0800 (PST)
Message-ID: <5df175cd.1c69fb81.27c3e.4ac6@mx.google.com>
Date:   Wed, 11 Dec 2019 15:03:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.15-106-g0b6bd9e91738
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 144 boots: 1 failed,
 134 passed with 5 offline, 3 untried/unknown,
 1 conflict (v5.3.15-106-g0b6bd9e91738)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 144 boots: 1 failed, 134 passed with 5 offline,=
 3 untried/unknown, 1 conflict (v5.3.15-106-g0b6bd9e91738)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.15-106-g0b6bd9e91738/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.15-106-g0b6bd9e91738/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.15-106-g0b6bd9e91738
Git Commit: 0b6bd9e917380a84aa7cc28de11f897e121cd092
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 25 SoC families, 19 builds out of 208

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12a-sei510: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxm-q200:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
