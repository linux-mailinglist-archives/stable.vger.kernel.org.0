Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6554C4BB
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 03:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbfFTBEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 21:04:08 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:36130 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbfFTBEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 21:04:08 -0400
Received: by mail-wm1-f43.google.com with SMTP id u8so1347442wmm.1
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 18:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xMUoAG9mM5Xwl2Y5R1HxzYqDWazixDCY7IIMdml02x4=;
        b=H+qDjQArRsXuJHYALzG8xpy88REA1DOZnmNWZ7J+rLJId+jP36cShDV879EaQ6kiNr
         1UtGVEO91KuCbZ3/a2G9pqmTSbWyQO6xprSyofZKivD74w14NHpUwMntXRupdyEL4eyo
         E3Y+dlJa3FEwoZQ4J9WtNvy4ANO/GR2R0b1mcRDfdc/nk31GoBdwo+lCMcEVhm5lySzH
         /DnaWw4s5FjNmrOg6aKvRwh9UyiPNDqcQlr0796Xeu2CLLQ8Ueyy3OvXMTrajdiesXli
         wOkPepmkz8znMFlfoTgwdIIdzmJn+IbKqUZ2EGnSH2XUIIgRgNSJXLJ4n5pKwWqo/3LQ
         kz3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xMUoAG9mM5Xwl2Y5R1HxzYqDWazixDCY7IIMdml02x4=;
        b=jSmJTD06DqB84g2rVY50KWDdgedPVttRvNmQChuirLv2PMH/BExpjBQ4zYMMUY8jJp
         uzGOSlmP2SxIJ8NG4oZz1NM6SQUvsCx9ZoZlW3eG5IEDGMtCPse9NvtLPgen5C6ATTZu
         jSHb1BQIg3M5O8MLermi+kCvVKaLZ4u2mUggN4KxL4yTrDEctvwxZbmLwtB2cwbj6qZZ
         9KN2NfK3jHZXepMV/zhC+rIFnoM1ijHHavKP6CvMKkbK/leiYQBM/6UulcG09NNkH9h3
         VsSemzDNIT8/Zqoh3FHV7gSEGL4JIzJF8dB6hh20Z6P40rllELR1aJVyRE5PFeiloUH+
         6SDQ==
X-Gm-Message-State: APjAAAWsJEQML1n94TVNHSt60VaWgQ90YsfrHyj0WW5jzTtHr9Z+knGp
        woyg5tnXnZuwvUyipzN35UrEsDczqOZ2tQ==
X-Google-Smtp-Source: APXvYqzl+n0ubbN2ihrlRUToNypq8YMuoYbOxUPdMMP+0N77hoIumUsnqhiiZEW0Gpz4oBVfjeNXOQ==
X-Received: by 2002:a1c:8049:: with SMTP id b70mr57477wmd.33.1560992645732;
        Wed, 19 Jun 2019 18:04:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u23sm1792790wmj.33.2019.06.19.18.04.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 18:04:05 -0700 (PDT)
Message-ID: <5d0adb85.1c69fb81.be084.9d36@mx.google.com>
Date:   Wed, 19 Jun 2019 18:04:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.182
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 92 boots: 0 failed,
 78 passed with 14 offline (v4.9.182)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 92 boots: 0 failed, 78 passed with 14 offline (=
v4.9.182)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.182/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.182/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.182
Git Commit: f4e2dd989e87a5982ae52bf5dc150287da8d729b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-ifc6410: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra30-beaver: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
