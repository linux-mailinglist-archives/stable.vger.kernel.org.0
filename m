Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA2357C26
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 08:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfF0G0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 02:26:10 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40775 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0G0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 02:26:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so1049938wre.7
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 23:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0joSN06A8D4yEg3XDS94rGDOP/3AQ3tj5MjbRsTSbSc=;
        b=xJlb3pXG0CFdpCF1UV/00Tq/THGMpqq0x6UlIvMQClbcRMP6VSx2Z5LwmjU6qTPU3x
         CiRtKU2FeuF0qVHl93tAf6otsJzHdeJW4qHazy0DoG0to7kXLE+4a9nOFNo/cDqcKD5z
         euh9WpwHWN/2WFSCafdaaZO4gWus1aGMPCulZl//AzJ5wzCHUSZtcNEqKh3akuE/jpYY
         1bSVAFrP6fyFMgSa3jR1iR9yLKbDLImBG//eyBvlJZY+yPJJyPvg/jEhDxpCfs9TBbZj
         zKu4GXRk1CWK592IyvryCjwDGWNtpdqkqzjUWFDG1j+NdMfGl3GRqKCMIL8fbtf77gFw
         b1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0joSN06A8D4yEg3XDS94rGDOP/3AQ3tj5MjbRsTSbSc=;
        b=ivmoJIM9pdEB4y65pXkTPy715PpW6sPp0Ki0OaYV1YCx+T1B0t1b4KbIykMH1wMsLP
         zFBPxOGxmK5raEXA6gOYppxBW1XwnzFF1sFXriP6VcoJDDW1t6VOALsvoorwzdnEU1dd
         0YYrGWF50CMKx/3qjVMlYKQzAiSaHSFg8pn+tGHxO6FWVHDoFlEX8MatwgfoHJfve+qB
         af88BbAZKSVeXy+lkTEQ7jeulPXnhC00ltCKRtXqSeOvs2nvZQgGsVLbPm1VGdQngBT3
         UkHq3mTFDmdameo9UmketIpb/MN/b3E+VpAwyKFPNQGA9sdnmEsRXKvuM6dkaVH1Ee0w
         +lBA==
X-Gm-Message-State: APjAAAXKI5nYzyCRVadLTv+jDuhIztm2Uu3DXSTXywZ1pA7N/GcmuxZ4
        N8EIRYOgb+nc5JmXjTS80H5snVCtJuzjXw==
X-Google-Smtp-Source: APXvYqzrny7jVxxpN209y+nNKgCCG5bf4iB1janMAuuhxzV3zqYEJk3xJ/qG9D2EpC40s9MonADimA==
X-Received: by 2002:a5d:4b12:: with SMTP id v18mr1614655wrq.123.1561616768215;
        Wed, 26 Jun 2019 23:26:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n14sm3177866wra.75.2019.06.26.23.26.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 23:26:07 -0700 (PDT)
Message-ID: <5d14617f.1c69fb81.d16d8.ecea@mx.google.com>
Date:   Wed, 26 Jun 2019 23:26:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.131
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 124 boots: 2 failed,
 112 passed with 10 offline (v4.14.131)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 124 boots: 2 failed, 112 passed with 10 offlin=
e (v4.14.131)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.131/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.131/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.131
Git Commit: f4cc0ed9b2c72687303b035379c5824a02224354
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 15 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
29-52-g57f3c9aebc30 - first fail: v4.14.130)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
29-52-g57f3c9aebc30 - first fail: v4.14.130)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

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
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
