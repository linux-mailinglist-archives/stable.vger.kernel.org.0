Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEF0B314D
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 20:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfIOSF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 14:05:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44471 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfIOSF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Sep 2019 14:05:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id i18so5909653wru.11
        for <stable@vger.kernel.org>; Sun, 15 Sep 2019 11:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MsTipoRD/xf818l5LK1i8KmFRzrUU7esjpPthJohZ+w=;
        b=rcXEVWQXFN5xBeskqU/VfO69d8h0xCxLpWn/QQDpZu+rrEl4OOa/ghff0pT5+bXxRb
         wYx4U1DKoD62wCkE4w8ZPJmS9AW/mijoCFGHdPiUiPOMTDaUEJyn2O/qWeM5ZSlUXzFC
         f8MhMpG5vbeHhmauGeg4PCbpNma+zFBahcy6zEu3GuGj13SNJKr2j9HBnGeek7IFYoL7
         vNMFyIAKE1Lt6J/L6fsshL5GRsho8yGzOJ2TtgGuE8jLhW8T0vjR4EoO/Sg3up0FEV2w
         rcwUFaf97hfx4/I2XIEz4CM5zWsDMllB5oDg/06bfe2Sf2nu1BW1RULANjOUuhq7mWXm
         nSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MsTipoRD/xf818l5LK1i8KmFRzrUU7esjpPthJohZ+w=;
        b=h7tYa5bjjQh7hz+c08mr8J7fGMpb4avFDAkUOajPHPqBAbh4xiiEMHMGpI5Q58mCts
         8vN+mUy6XjG5SjnSWbtYvmLHEV5PPTroYkKot6XBfoQnQRtUkkqagz1IgvKib2NoJpjz
         DwT5FiqcGTCG8RYWOD95lKFfvQ74XX5Yvp5as/t4GLg+4vn36zYxJFFNq8Ihm5Yz9HfO
         pO8WhR5gxUv7+Z/8DEMmpW8TXxSXA52+nxqfkhu2kVLcfxqrReASkufxOLaU/OkOmpnE
         +crc2qaUMacV5WOHKNWjXAd2fwmIYjhbFRcExkgVKk8uBnMRPBDi9C0n+g+aYD75D4MQ
         ustg==
X-Gm-Message-State: APjAAAXHjDYyX9pBtlEm8dbatdMHDFyr7Z/4BFGjDmxwM3p9WCVFogmq
        fRdnv1FIrkJML50pi5gajVKNpRParww=
X-Google-Smtp-Source: APXvYqyI/qryPhfNA72hDx5l1tdz8uBJ6vCFbMoDiXG86sV6N8lDAP3DJ89KHpGBrdLrDEtG6A2bDQ==
X-Received: by 2002:a05:6000:2:: with SMTP id h2mr45254677wrx.309.1568570755521;
        Sun, 15 Sep 2019 11:05:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b62sm20346649wmc.13.2019.09.15.11.05.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 11:05:54 -0700 (PDT)
Message-ID: <5d7e7d82.1c69fb81.976e5.7c44@mx.google.com>
Date:   Sun, 15 Sep 2019 11:05:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.192-10-gb5258645a2cb
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 105 boots: 1 failed,
 94 passed with 9 offline, 1 conflict (v4.4.192-10-gb5258645a2cb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 105 boots: 1 failed, 94 passed with 9 offline, =
1 conflict (v4.4.192-10-gb5258645a2cb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.192-10-gb5258645a2cb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.192-10-gb5258645a2cb/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.192-10-gb5258645a2cb
Git Commit: b5258645a2cb65a0a4f8ca2b16d7afaeb611be6a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-linaro-lkft: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
