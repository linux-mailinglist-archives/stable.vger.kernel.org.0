Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1407D11BDD1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLKU0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:26:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45269 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfLKU0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 15:26:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so57703wrj.12
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 12:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T3G4wwqLhz14IErYUj1JZYR1SfKWFgtovCQeQtfkwFM=;
        b=t6lePDwICk2ydUuXwcmSEGU1lzRq8Qw1tKX61AecDN5fSKKPc5DDh12f2EiIWqMcyB
         8xlBbm9KchMEx1EebtG0iwFUav0PJT+daloM/Lva5ALiknJkNoaqUom/2kjccqQBHIvy
         xLV+wavpqNMvW+lY2GW0wp1MgyBDO5SO8kzQdLqqaKk137QeOxVq8JTtLaUfcvtKjLGz
         joepuRGtvqr9FD+ZhZJ7xpRqvQl7fiwuj5f4ftQySRwsLqwT1lTnCuhSbWsjVOR00lzw
         l2LVuBqqNcGUiRaDsqs5qaiXyvzFOZIUUloNmroHBSvTzfSffonodCklHz6VfnbMxp4x
         zn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T3G4wwqLhz14IErYUj1JZYR1SfKWFgtovCQeQtfkwFM=;
        b=jD0MubhiwBUJoY2No5m45TinQCflvyanxGfSf6Ov+WittZhoa08P58r3B9zEKaRq52
         iJi9UlfaznCaN1cp9XXo6pke4f+bF0YJPzl70n1bE2RMsH6jyLY1NQWVRSil3yNP7i3z
         V4ps9NiS0miOR1nJRANHxAPRfLM+TlU1Ob0dhDJyn1yG6dR/NAQ7YauBS3mBbPiAGY/X
         dSjcSPjrIg/36Kg6R/fTk4/nmjG5i45i67aZxRfnbb4DeKr7tsstr7G92g8M0QUlk+NJ
         6qJ779fDu9WY4b7uD895ugnaFCtDRepCjSUBGBlcrjwp1ZvUWfD4oL1iFFhJw77h+Byd
         DliQ==
X-Gm-Message-State: APjAAAXeYD4cW5c6AL/oHpwvJuOL7CqTXlDICb6CD0qDNN2SvBVCHYrd
        Shrjdwpy1TAi2sSnReSnwqI7eHPbXK/s2w==
X-Google-Smtp-Source: APXvYqyrNZDPq+whchaMsoSQjxpci7r9uMlAZq9DUCSQe1u0LEXfpUtknzGcvEeEMxsIT8R1StTbpw==
X-Received: by 2002:adf:ea05:: with SMTP id q5mr1876250wrm.48.1576095991929;
        Wed, 11 Dec 2019 12:26:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z83sm3774456wmg.2.2019.12.11.12.26.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 12:26:31 -0800 (PST)
Message-ID: <5df150f7.1c69fb81.e3e08.3842@mx.google.com>
Date:   Wed, 11 Dec 2019 12:26:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.15-100-g365e7b9094d3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 151 boots: 1 failed,
 142 passed with 6 offline, 1 untried/unknown,
 1 conflict (v5.3.15-100-g365e7b9094d3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 151 boots: 1 failed, 142 passed with 6 offline,=
 1 untried/unknown, 1 conflict (v5.3.15-100-g365e7b9094d3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.15-100-g365e7b9094d3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.15-100-g365e7b9094d3/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.15-100-g365e7b9094d3
Git Commit: 365e7b9094d353d3c85a1ef427b75774368af535
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 88 unique boards, 25 SoC families, 19 builds out of 208

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxm-q200:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
