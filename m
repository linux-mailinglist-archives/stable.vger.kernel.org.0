Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A22122F41
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 15:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLQOuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 09:50:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46158 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfLQOuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 09:50:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so11563256wrl.13
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 06:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EIoQFh4g5jsa415JJS54OBA5xgcKMdDWa6nS96VuJ4M=;
        b=m5b/UwAGh4v3bM0FCNV399cLg51DqggHjIsreSjOfdSpjzhQ4/4kNG1Evb1dMkkKp+
         Ot2cSMRDpIR665UpZV4O8bKogj1K35n9SRgrde//nS7ai1I3Yra5xwJfjzOjD41gtp3P
         KSAP6g//mFVHrL/QRCbIIyfwKQXEYHWUL8CTOVY5HcyVEFlkURmfPSiWRABAzbP/Hijq
         Wxzna87TBs2OCyawNW15cZc2Phy+/WLy8VCJ+18tYJCASpB+iGtM/tG0xW6v36Cbw6Fp
         wClDKq54h8Ygeg6ZQjer1dTVCL82DbOKahD3Ahj117txyQD8wxeRQFc09JM61bZMTFwr
         vSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EIoQFh4g5jsa415JJS54OBA5xgcKMdDWa6nS96VuJ4M=;
        b=KOQrSi068WhmLBN1WKUYiQZ090SCvkOLlZ/GGo1L3fKlphsDzjKXUxjilepmOIDpyB
         YPFhbNIcvd4mnU0lTpYWLD7LiUeotPK51bzJRZ07PDqcxgqCuVPsnf5cQO3uO5fmJdIG
         KXmT+eL+5BpOS5HGx1XtIPTPII/Srl5IkE17MJQw3ruz9D/6q4iEwMwUKVCV+jomZNKL
         pOiLFswoMSUNedvE9yBkmb4BfNE25aa3oHuT+Ex+tp8fjTQ870HvGophTn7Dv9Q1qzwE
         O6eEKhpMBrPw091pgK9yhSM5HPXZuMSkuVup72Ivlvs5ONZVw8fUH/ase2hwRAqtqoZS
         d1Jg==
X-Gm-Message-State: APjAAAVAu40+WY5X9CH7Be6C6/ZF6Vq267v0AWGMb5sPJtyp5k9QWLN6
        OGOWvISaT1RW3cDYh9h+fCR4hJmFs7Zaaw==
X-Google-Smtp-Source: APXvYqzTK6lMn58xXryS7ySbS51MnzIRz6/681Q2C8GxPieNwMyP2+b1r88reVcgufl8JpOl9Ha31w==
X-Received: by 2002:a5d:534b:: with SMTP id t11mr38059738wrv.120.1576594215332;
        Tue, 17 Dec 2019 06:50:15 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z11sm26079714wrt.82.2019.12.17.06.50.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 06:50:14 -0800 (PST)
Message-ID: <5df8eb26.1c69fb81.988df.5d6c@mx.google.com>
Date:   Tue, 17 Dec 2019 06:50:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.158-268-g66745e000c83
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 96 boots: 1 failed,
 86 passed with 8 offline, 1 untried/unknown (v4.14.158-268-g66745e000c83)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 96 boots: 1 failed, 86 passed with 8 offline, =
1 untried/unknown (v4.14.158-268-g66745e000c83)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.158-268-g66745e000c83/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-268-g66745e000c83/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-268-g66745e000c83
Git Commit: 66745e000c837d52e736de131726a861c6ea1ebf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 21 SoC families, 15 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

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

    omap2plus_defconfig:
        gcc-8
            omap4-panda: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            omap4-panda: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-gxl-s905x-libretech-cc: 1 offline lab

---
For more info write to <info@kernelci.org>
