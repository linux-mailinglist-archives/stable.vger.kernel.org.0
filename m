Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF885EE760
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 19:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbfKDS1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 13:27:51 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:51303 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDS1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 13:27:50 -0500
Received: by mail-wm1-f45.google.com with SMTP id q70so17802394wme.1
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 10:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MrOlDfxhgdKSRKUgYFb9Fy5L5HVsLkB9rhBm7iOv9Tc=;
        b=Ypa/nkXrbzKhsXOgvyofdabJOQec5Kn0rABKXoDj3KwDfxti3wGlqo8emplH9TIy/k
         ZOmNWDMtr6qMJhAln6ZOMqBW1JP8byH2qQsNW72ZO+/k3lbWYenNHdqhzxumuf2G1OCH
         XyNe6+GzZ/FyylBH5YOigJ/ChHE71FkPNaJF3Gv4CwvT7m2u7FTsOgvSr2zW6ySD67N0
         3u1PHI+WirJqpk7aNnAMsZhTuksmv2j/Zt2YgTkQDrjLhi8+YKpT+2h4nkpyQgHQXc/9
         QSG6fl2fOewyCGkl34uAz+4Z0w0z9lQ2QPWXtgxeRkqHSBxyxESCWvZbsBhfivTO4SPV
         u0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MrOlDfxhgdKSRKUgYFb9Fy5L5HVsLkB9rhBm7iOv9Tc=;
        b=Ra9LP4J1vW7vYOuzsjKMMhaCRPXcR+x6/d2wQYB7Ri2GjqqCSniQlchMmw0O5dUBRb
         Y1l1DPotjdAhkznIYzuI1a4T1yC7zH9VKS+AeVdGAoTWE7YzzTlDWhjh4aZxQ+nQvMyl
         zevsbqt9/egPxANnqpIj7wiv7exb3w/Vwz9zAU3g39AUpZbSU8zd2y2T3HdKclkhbhQj
         mRx1fhve7GNy+NwVZ2u09cAop/EsfU5BYIdOqgL8UKgYDkXe8hVewP6IHB/LUXRCnFfl
         MsHuRj8VTz1KT0gCEEfqv1ehlRG3ar4kTuTsu9isBQMDDMFwtmFIHxaQaADczoahTVN4
         0QPg==
X-Gm-Message-State: APjAAAXDuOYRxPmdghX6bOiTFptD4XxSZbjLVuLXqQa4TlrqsyrbuA4G
        hjZquyFgIqFg6LFYYwOmRApdqvHhDy0R6Q==
X-Google-Smtp-Source: APXvYqz/5cOO00v41I18RBYf8g/QU8+ETYYUNRAkEaPsv34jg3Df/A0Tm3DwTmlG26PUsvvNAJbnww==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr450285wmj.84.1572892068322;
        Mon, 04 Nov 2019 10:27:48 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u1sm25554317wru.90.2019.11.04.10.27.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 10:27:47 -0800 (PST)
Message-ID: <5dc06da3.1c69fb81.68371.0569@mx.google.com>
Date:   Mon, 04 Nov 2019 10:27:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.198-47-g3849b8fee3c3
Subject: stable-rc/linux-4.4.y boot: 80 boots: 0 failed,
 72 passed with 7 offline, 1 conflict (v4.4.198-47-g3849b8fee3c3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 0 failed, 72 passed with 7 offline, 1=
 conflict (v4.4.198-47-g3849b8fee3c3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.198-47-g3849b8fee3c3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.198-47-g3849b8fee3c3/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.198-47-g3849b8fee3c3
Git Commit: 3849b8fee3c31ec2cfef806e0e369ccbd50d0f1e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
