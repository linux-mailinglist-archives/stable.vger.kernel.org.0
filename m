Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030CC12D528
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 01:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfLaAK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 19:10:29 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52118 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbfLaAK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 19:10:28 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so800117wmd.1
        for <stable@vger.kernel.org>; Mon, 30 Dec 2019 16:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cj3UIpUfuSQ/VSYqwZQJcIB1DnTFNG2nAd0K9RwFyI0=;
        b=oWRRZ6bwbG7O1BEfQTaD74E3U0GkPuo10HQ7/t4G4B+BAVAl3Gf8hY4IiPxQFM7O4C
         hX+eAqvmcqCMEi5xRWPfWcJvDcuySNLqdcAbsSqBIqbKfPswSBcNEq+mil69t7A/52us
         /vFTQsMtpd9ov4PiTq73qpovPSsdW7IYLq/Xx+2yEt/+6uDPkTonOzxaQQMBdebntRxY
         GFcDnIw6nRiJXEfAzuuEbf/vXRuWeY6Bpac3Iv6otHd7psYoU9phRCH8YPZHXKJDTMRn
         pUOIUuD71jmoDgGQPD56HCDppW5e+ud6evepq8OEC5i4HERPMUdJZF7Odrqwg7Q1GOTU
         TZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cj3UIpUfuSQ/VSYqwZQJcIB1DnTFNG2nAd0K9RwFyI0=;
        b=E5s0DgRJZuL3n9xfTkvY8+ShYlsZBd34W0rayOYyk9Xp6x4l+rNgGRqnKf8MKC0DGD
         Z7lN4CZ/iUO2O/qG6VZLG5S1MEaEdDw3IM8LZRm3seaXwn+NnS2WsX/EnEYCN7QtgctL
         VuMKNXYBuIwMWdD3xfZ0rg02n1OuLIcbC1zADVI9OR3/pfjHOLO0bTlfEouxqtWAWrWv
         6oeNeXDRkqZNhPm6YGUOXhVoNlYsiFnS/aSSFyc0o59MUH2goSkVdT5ed73C3dVC2Rk/
         bmfHGCV0VAQSa0UBWS81teGUaBR/7h+HZgGPeKPUfnwaamuZPGGyM6WVD8J3EGCtU71V
         YRww==
X-Gm-Message-State: APjAAAXxKrE3Lfy6Hefw9KKvnPSG2UVXB7KSeFq6pgB1t6VuWLjUHbym
        5LiMyNy+s+MK5GG3beAKw2F+lla8hKMXRA==
X-Google-Smtp-Source: APXvYqyGKJEu+eiCsoAwD+jBqOje4UZnUW42VG2wUwQF7fFVRhjOttplJTDdR2L8xuBpB/8FtcyX1g==
X-Received: by 2002:a1c:6406:: with SMTP id y6mr1277767wmb.144.1577751026201;
        Mon, 30 Dec 2019 16:10:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y7sm1275715wmd.1.2019.12.30.16.10.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 16:10:24 -0800 (PST)
Message-ID: <5e0a91f0.1c69fb81.7c59b.64cf@mx.google.com>
Date:   Mon, 30 Dec 2019 16:10:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.160-163-g17c9f57c99d1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 110 boots: 1 failed,
 97 passed with 11 offline, 1 untried/unknown (v4.14.160-163-g17c9f57c99d1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 110 boots: 1 failed, 97 passed with 11 offline=
, 1 untried/unknown (v4.14.160-163-g17c9f57c99d1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.160-163-g17c9f57c99d1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.160-163-g17c9f57c99d1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.160-163-g17c9f57c99d1
Git Commit: 17c9f57c99d16162bf84957723cc762996cc7d23
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 20 SoC families, 15 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
