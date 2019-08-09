Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF3586F35
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 03:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405371AbfHIBQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 21:16:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34329 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404985AbfHIBQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 21:16:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so96703970wrm.1
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 18:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nmKl6xZ9evBCsV+7pDQ1T5V8nwqe3l8B8kF5Dyi1RvM=;
        b=EiN93CvDuR+rD6OB0E9lMwB2xyLBqHQwE0b6FIKmv+97L+ZgO+8M6y88Xunj6sqLrX
         gjTL5p/cS4MPY7NLM65cbIRCB/L74dO4wiDV0FcwWviUX7XlZh2x90Egq5mg+3oWRNn+
         Wn6SdeOvL/aiIUiLgKrZQ8EbiqagJsizSuR/cqHpgGjucslsI3WtBEAysPGGZFnddp6G
         WgFdzE04lTWkn5Hk3hKw8aXFxcUYAOkU+34Sj9B5yoIepnAaBnubsZSlG1SUTWCxuh9S
         pPFBUNJi194s/QYO2ypxOwAWYTxHRq0KggskFt3jWxkeVvqP5RldTuEMx0x9fT/70d4P
         18gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nmKl6xZ9evBCsV+7pDQ1T5V8nwqe3l8B8kF5Dyi1RvM=;
        b=Irs5tjUVa/UypGiPrm2S5x5GkWad3YHpFu7nNnPoVtdvkd4FZjfHfFUu7FvcPFXvVx
         eEAVDjno0qHB2nXT1VsDtTu57sSiKN+JdE3SpP9Pa/PlYjh0jywu4QWZqxvMmq+aouOD
         XA6vZV4pJM0TQii6yMId5v+vUDp5NP9/SwtcTml4F0wyHYMhHTHsPcznQpTFFnD2j2mk
         stxeX9Cc08UXU7SWB3dDZ+ivPs+W6pZ7wYn6NzpWo/mfCNqn520/5g1HG5c/jpWe70v+
         4jXe3A1Sm66uD+vY4G2hXkboHmJ7xJGJ/Jvd48aKQh6WIV7kM+R3V+DB+KYxcujkFzRb
         zAQQ==
X-Gm-Message-State: APjAAAVTBYloPmnyVOZVCy5T6xAOzOLUYxpez7p9ESmeZGXWpVOHItf8
        Ogvz+eFYS80LEGLRHDM9szNebDzeyx18lw==
X-Google-Smtp-Source: APXvYqwOh1ON0iyVCsyUIGkWPkC/kBy00Gs/TuWaBp3fu1vWs3csTkhAKBbXUnkFrcjU6xyICxHrgg==
X-Received: by 2002:a5d:52c5:: with SMTP id r5mr19865156wrv.146.1565313388617;
        Thu, 08 Aug 2019 18:16:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k13sm12010245wro.97.2019.08.08.18.16.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 18:16:28 -0700 (PDT)
Message-ID: <5d4cc96c.1c69fb81.324d6.dbc1@mx.google.com>
Date:   Thu, 08 Aug 2019 18:16:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.136-94-g4ec3ef9505a3
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 101 boots: 2 failed,
 88 passed with 11 offline (v4.14.136-94-g4ec3ef9505a3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 101 boots: 2 failed, 88 passed with 11 offline=
 (v4.14.136-94-g4ec3ef9505a3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.136-94-g4ec3ef9505a3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.136-94-g4ec3ef9505a3/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.136-94-g4ec3ef9505a3
Git Commit: 4ec3ef9505a33da8c993347fc2e178b46356bb92
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.14.136-54-g2=
0d3ec30650b)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.14.136-54-g2=
0d3ec30650b)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
