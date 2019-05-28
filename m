Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A3C2C707
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 14:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfE1MwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 08:52:03 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35476 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfE1MwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 08:52:01 -0400
Received: by mail-wm1-f54.google.com with SMTP id w9so2743645wmi.0
        for <stable@vger.kernel.org>; Tue, 28 May 2019 05:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DkEYVLfUjbW6CS+uz6TLN71PBhIdyVJe+XyUDqS94xY=;
        b=jK6uhv2mJcVwFCR8SUqIzU3zmPW6jsNYyWtHcSh8yZ4PwPhx8t3CH8JPKq9wvW1ADc
         9N/FjQ8+CNXIJbNKA88Qlai15rFdZ7Rv2kgvr3ZleZ6SGEw+KZdXvatXknecAkoksiu3
         5AlO/EgF/HRP/LMZNn93raJD5zKPVQVNMfr7JQDJ1F4PEq2zgPuxU3mFqUmY3lraR8p/
         WvHfcixiBqs0k7qyigNE3aYt+fD/7X8BbRML5ZU2SaYDfOFXyS21K9kTzQtSnDH5XkXU
         IQPCNrNs46JK6EuPh4bQVbB45XgXeCfhPNmVBXW2zliZpOmB7JzF5xc2z2R0T7Icxtvd
         R1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DkEYVLfUjbW6CS+uz6TLN71PBhIdyVJe+XyUDqS94xY=;
        b=BYMUwb7v5HJp7RRZ0P3hjV1vTKpyQRs4/kLBMA25LVjuLxgMELI3/v82bXtqFRaMaX
         ehNEkQjN+x+xavWW2phIoD74ihQYcuAQ4kv2/g00OqMfF24Gb/iNQ0WgwOGh4Ef90dl6
         ujBOWc++zv4I7SpEZ/gBUgEQHaVGQ30Y1BDb7KkA3O1yJDKfug6dhlgUcVUXOrMd1t7e
         jNUytxIGJDGraWJcbAYegljLelgXaYAIkl9tN+BUcjxqSeDqOZzyyuArQhnNKcCeCCp7
         +fM1L3DiAFDE/G6howC3jH9RGNnXjywgMliTE37P2bcUU+HxIfiuhBH3kA/xlt/H87uv
         oaHQ==
X-Gm-Message-State: APjAAAUKO1NazrFRdcodphxglc4abJ+LqUdMTXchIQo1AXR5prdOjDzV
        Js0p4YVmppoxdoej5BU86gMoHjgdAP+zmA==
X-Google-Smtp-Source: APXvYqz/voOTeY/SFqsXU/NIxoU3O/RLrSlbxT3nTR8o7lbUdq85RD/2oWd+dsC1cxkAGyDVJxkHpw==
X-Received: by 2002:a1c:4b09:: with SMTP id y9mr3193944wma.93.1559047919606;
        Tue, 28 May 2019 05:51:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t14sm4246915wrr.33.2019.05.28.05.51.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 05:51:58 -0700 (PDT)
Message-ID: <5ced2eee.1c69fb81.15678.68aa@mx.google.com>
Date:   Tue, 28 May 2019 05:51:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.5-31-g3cf575246410
Subject: stable-rc/linux-5.1.y boot: 129 boots: 1 failed,
 114 passed with 14 offline (v5.1.5-31-g3cf575246410)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 129 boots: 1 failed, 114 passed with 14 offline=
 (v5.1.5-31-g3cf575246410)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.5-31-g3cf575246410/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.5-31-g3cf575246410/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.5-31-g3cf575246410
Git Commit: 3cf5752464105c48cd67f0bc8c6ac881341a9bf6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 24 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
