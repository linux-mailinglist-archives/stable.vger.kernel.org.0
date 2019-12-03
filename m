Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1115111B34
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfLCVz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 16:55:27 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39889 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfLCVz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 16:55:27 -0500
Received: by mail-wm1-f66.google.com with SMTP id s14so5459546wmh.4
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 13:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JFLMtPmdokFnzJ9D+u+BxcDkMEfr1WwbkBIVLXsc/6k=;
        b=U62ZG61ef9l49GuD86T4bb/ZT5yEdtzeQbU38MxPCm9NiTV1U/fyej19/PxoX/3j0/
         nJGfxe46VGetpAgkP96Q1maMvMBZJ1HjmB/2FoyjOrlaNzHBZ9SRPesFNIwpfsUh0S+a
         pq2ote1FFAdMCYS0YbJpBie6quRUbaniwKlecwRDFzvfmWG6sMCyPwWY4g+JaP4sQ7XR
         osRneB1v7DkkuUUNbSE9Oki0hM3VxEHnpkX0hNEs8Fsd2wyUQoOR93cdiWPOY02MjLQ2
         4kRUeMrOyyL3Nv4C8aBZhW9mamPAKC9G+IZab3r/Uv2ADLDqQxly4nXu6IRpEVu6yQZS
         5vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JFLMtPmdokFnzJ9D+u+BxcDkMEfr1WwbkBIVLXsc/6k=;
        b=p5CM8hJvu/2/K6BKccBUTE+Xw/PXDBtws/fjVmsAzvSrWFuOTpPDZ51oKnLfBPDAdg
         Sxcta7lNJvV6DUXneQk+DyggR7gRE+RXMtsH04ghuir3YkUVanzOTcvJ8d6blGM1jT43
         AK/voqF8lW3GNDDBwFVR/eokCHkmB6Mo+lN3PaOGyFdZTnWg8dTRp9rbU1D7S9pfyHZf
         vYC0IvtcK+4DF+q0Up4nxWlCscthn7y/yyv/1dF+Q9j1xIx5Ak+xjPg5UFrkO928cipH
         y7v6kmEVi9vDLRRjeO1kXPkDheb2DEOykYq4xFeI7z+4zI2VKtolzJ5m0ISqC9aGLuC6
         P7MQ==
X-Gm-Message-State: APjAAAXk/zd7uCf3wko/3wxIFIMYT1Mh11J5GIMRufl5ppMW+KaEXeah
        46uVYtqyfL5d9QS0+riq9nb/+dY5/YrONQ==
X-Google-Smtp-Source: APXvYqw0QhZ/P/RViRPCoAi70KRke9rqBQesgZt943Pr01Ar078wLKSLMUvVvgdVcMiP2qXfI5I6VQ==
X-Received: by 2002:a7b:cf21:: with SMTP id m1mr35865986wmg.170.1575410125120;
        Tue, 03 Dec 2019 13:55:25 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 60sm5801322wrn.86.2019.12.03.13.55.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 13:55:24 -0800 (PST)
Message-ID: <5de6d9cc.1c69fb81.b9d55.d991@mx.google.com>
Date:   Tue, 03 Dec 2019 13:55:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.205-90-g6daac5f96598
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 1 failed,
 88 passed with 5 offline, 2 conflicts (v4.4.205-90-g6daac5f96598)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 1 failed, 88 passed with 5 offline, 2=
 conflicts (v4.4.205-90-g6daac5f96598)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.205-90-g6daac5f96598/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.205-90-g6daac5f96598/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.205-90-g6daac5f96598
Git Commit: 6daac5f9659826db550502c7421161ac281698fd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 14 builds out of 190

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

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

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
