Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FB79FA8E
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 08:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfH1GdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 02:33:11 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:33310 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfH1GdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 02:33:10 -0400
Received: by mail-wr1-f45.google.com with SMTP id u16so1232704wrr.0
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 23:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X1yhKOlwZt3ckU1UTDVKv31wkwEm5zEQvv0sjz9IxvM=;
        b=IZg3r9WXhJEmb169z4W/87gXgX+Yp3CCkUAbcOcfioRMFzvEIWDmzPd+TdN3mR3SYQ
         5t2tOggDN3NfbAtIlmZyfHMBB7bCyjgC3jfvlEMt8Dpr3xloKeP6m2OleZG+OWE8qDjO
         +PIfcMejKWLLBQyrSEM/oxaTt74cN8sTJpUWF9TRc6aj7OXnz97PHr7aWMrwND/t4rsV
         AR7I4T3fD3ue4APmWlQhmN5EFVI8yX+IsoezAeNY2TbRzPU1gNXNtnIrcloa2/vM/WVr
         Tjfj8L2ntey14aNZ6ZyfR+cv4pIjZwseGT/l3kcS1mjaTo8N7c2v0mcbwGxvvZkGdxs8
         N0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X1yhKOlwZt3ckU1UTDVKv31wkwEm5zEQvv0sjz9IxvM=;
        b=I8LzkUoYYBDCaKkxdccQ0SJVRckGnKo+rP/XW7G8Ntrs8vvjSfMZoHFDhHKLkxtnbb
         Y4euwbrpqV022AvuLv78Aq7kPB3iMf2wr+PUqJP7skWgfdhL/A/MHmkZBEGw6ZUNUVV6
         2cMdlWOpZjow28vc8COQIpMNz7UTYKV764c5p5KUwl5YX/hGJEJDEG2M5Sb0+JmfTWE6
         WtjmwA+CvA0AnhJfgDKmwJxt1ABrLwfw5W/Pt4pW4egcgcHcO3MEV+WmIWafO304RDWr
         fA5VdDsWdlCeCw7PaxnJHzhKaGggIJCDFVb2yUFQuFyXPPsBW8LfoCu2lPnALL/77T6C
         N4+w==
X-Gm-Message-State: APjAAAVjZhFqfQTHe1zv8cD73/mx/lY4QEm8oEvJf4Fft0vxrFxdFF2L
        v6xj4wHqvGoFLLafI8jToZYa1+QTYp/5WA==
X-Google-Smtp-Source: APXvYqz7saLIy1uY/2fhdq1FG4FIzaDDFuXCri1AQb2Sopdtde6NlcP2HMvezJPKaydZcNhHpa8Aag==
X-Received: by 2002:adf:cd84:: with SMTP id q4mr2335053wrj.232.1566973988327;
        Tue, 27 Aug 2019 23:33:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n8sm2977963wma.7.2019.08.27.23.33.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 23:33:06 -0700 (PDT)
Message-ID: <5d662022.1c69fb81.84659.dc22@mx.google.com>
Date:   Tue, 27 Aug 2019 23:33:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.190-44-g7c5529b85097
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 109 boots: 2 failed,
 97 passed with 10 offline (v4.9.190-44-g7c5529b85097)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 109 boots: 2 failed, 97 passed with 10 offline =
(v4.9.190-44-g7c5529b85097)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.190-44-g7c5529b85097/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.190-44-g7c5529b85097/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.190-44-g7c5529b85097
Git Commit: 7c5529b85097ab741ffb2c03b344c4925e489336
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
