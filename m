Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C023188B2F
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 17:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCQQwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 12:52:22 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38434 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQQwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 12:52:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id z5so12276993pfn.5
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 09:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kzg8xEgSli8BBJRHRLw35GTHUmJYZjmqvZsvCa/jzlU=;
        b=FAxZFWq4aDQDLYVjvu6FRZhwbrj1RQmg15m7KlMVk0umUt7XzVfuC7vBrA+EivNmgS
         G6cwRCUUxEmM30xaYqm4MlsKXJw3Fajz8amjbDbMcW7j5XiEvR+vLB15JhMR6jaijuTK
         5EKzKESqLN+e+KpZvvA/ZEwD9RcEBxfw8/w+oPbfD13ejO//Losh5mH940dmwcJr1+G/
         qdPN9UWL8iMJZVy6ZMRLjbPb/vGA+vSR2+ZRB33AC7K0zTGDuJ7nuU8d/EyeeR04nCRC
         C8OttB0m1J90r4mMmUdHFqwQTNn0dSiGxaZayFMnbEdzVQnKhJjGFIX/Vat11ckvN9MR
         dCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kzg8xEgSli8BBJRHRLw35GTHUmJYZjmqvZsvCa/jzlU=;
        b=h8ueGhu/K0H1cOInKeJscRLA0Y10zghTuXzGkc9aFPR5FV28vrwzgzAPyPgk0fZePe
         DEIA8o3tsS5e9ZFo0t75Mjs8sTNGqF90h9f9mNAlkpPmS5lVtLNweeqBweDP9XmGWu14
         QCxy3xHoA0N1MirRGPvFAI3IBC/XmxrJijr/sKPyT/tU2+rRE3c1HlFNk1ZHJIXlNVq7
         VCB5dTCP5QC0n6immeev2X/lUwmf24t3QvCkY8eWZFXu4F1BhY45daOh5o8QY6iZLG36
         qRbTXOBCfhyd4bVHWr667fl/2qg8aYn1NkQ0TbNCdta0eP1HxCsAFHyvtGaQ0y9IFHtQ
         ttsw==
X-Gm-Message-State: ANhLgQ2c3opkzsF+fYyqgeixb1mDwzdjzSQmmEsXnthPq1K5vfmjGp73
        02Aob1Ln5MNz+rmDkdK0TH/RMefFwS4=
X-Google-Smtp-Source: ADFU+vsqDAex4Y1zaN7YJRuDfCblSCNfh00jxtmE9vM2mM4VsxkT5aVCJVfOj++9XqqiD6mTol5VNw==
X-Received: by 2002:aa7:8687:: with SMTP id d7mr6095176pfo.247.1584463940464;
        Tue, 17 Mar 2020 09:52:20 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s15sm3806779pfd.164.2020.03.17.09.52.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 09:52:19 -0700 (PDT)
Message-ID: <5e710043.1c69fb81.64166.d2c0@mx.google.com>
Date:   Tue, 17 Mar 2020 09:52:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.216-75-g6ee407f35904
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 113 boots: 1 failed,
 103 passed with 4 offline, 5 untried/unknown (v4.9.216-75-g6ee407f35904)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 113 boots: 1 failed, 103 passed with 4 offline,=
 5 untried/unknown (v4.9.216-75-g6ee407f35904)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.216-75-g6ee407f35904/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.216-75-g6ee407f35904/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.216-75-g6ee407f35904
Git Commit: 6ee407f359042f2ad4d7547201c00dc7aaade930
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 38 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
