Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1214497233
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 08:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfHUGXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 02:23:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46454 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfHUGXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 02:23:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so800911wru.13
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 23:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bLgrraWuhbC0j0ObPeoLPdcGJZgNk2I2hEo6dl5EpJg=;
        b=NS55sq99PFUI6wqZqfijj821wktRC1Umq7ORsxRkUzS2icu1PaC4HJk6fkq4+nZrbe
         Ml2VmB+528FljigQ9m58tU9mmG/eQlvOXqvDZtnZDfXdRDU7tUNwbrZvUnEs0Ak7yKQ8
         HN0xCF/C867pIId56KW0VLr25rPWANF1m7vABhXHe9xthNpCbG0w4RXycUCOtTdWOhnp
         Og8tHx2eB1Mk+DY3MbQPtLz7olqj3/nHqYNq8s/np+uLLmrESnQ+ZAyILNnLTxh4Alsk
         pp4ladjqsSWFewzK3XQuo9al2w6LXB8qDqP529EPncYpMZTXc/4AChFsNvW4BM7gTBhA
         NwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bLgrraWuhbC0j0ObPeoLPdcGJZgNk2I2hEo6dl5EpJg=;
        b=ZENjqoVTOPY5c1lJkWc5ZvVOYg3OgotAoSpPepzDKX7hJg8S4+/hLKna9HqR4upztw
         XAHRL/xGn+WH/TRq9ufLfmTSdreOgjnYeSUZJF0vv+63yOpNOHLQjJH7RamlsYVZnjrb
         NF6VfSJM4PKjwsip3U6DgTBufCwBQ3vAnDkq40H2m7Q7APVsxtvMCoz16l6jUf5PMGL+
         bozVjYPYfeujBHzT9DXVewtE0WbyxkMWpq4RlOTOEo8wqLV1aFKuq/5tvFdwjWDCrTok
         bgudBpGbtr2BLPw8PpTl7Ns6TYBSpfMsAWX2Hvz7QLS25BhbY/4bytkjiSOsQCmU6VYx
         POdg==
X-Gm-Message-State: APjAAAVLaH7INeqPtr/RcaITvVXhbBZjxJEXovEzIQuYCwZ5qCLO5nJi
        LMbBU3OW6RfGNDVVdyRds4A4AY2BPQNp7Q==
X-Google-Smtp-Source: APXvYqzSc/Tr1pp5wEZLv8N2BDTS/bRSLWsKDjoe86JrGUaOPT7rLTknUvWEbXN4sr22/Hr3csGqMQ==
X-Received: by 2002:adf:91c2:: with SMTP id 60mr40671507wri.334.1566368592101;
        Tue, 20 Aug 2019 23:23:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm47402389wre.44.2019.08.20.23.23.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 23:23:11 -0700 (PDT)
Message-ID: <5d5ce34f.1c69fb81.8d877.2adf@mx.google.com>
Date:   Tue, 20 Aug 2019 23:23:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.67-74-g6c287a508569
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 125 boots: 0 failed,
 108 passed with 16 offline, 1 untried/unknown (v4.19.67-74-g6c287a508569)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 125 boots: 0 failed, 108 passed with 16 offlin=
e, 1 untried/unknown (v4.19.67-74-g6c287a508569)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.67-74-g6c287a508569/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.67-74-g6c287a508569/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.67-74-g6c287a508569
Git Commit: 6c287a50856975f25bba70b25cf8e9be5fb59d0d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
