Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB9386EE9
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 02:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404676AbfHIAnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 20:43:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39388 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfHIAnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 20:43:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so6493541wra.6
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 17:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B2aPCwYfw3FnQHeaxAnATXyCwwwNQTJA/ZXVopyLBaY=;
        b=UaMno/xtIVQ7FQxL9LKAPddo2kPt6a9FURqhLJw1AOeeQaJLZ4rZNW+hd/bKWNquvi
         TEBcWJQOBc4PsWCs7sVqO8a0i0nVlcx6oDWRbr8iqQgfCIJaSWXx0+tR8lsove6UriS7
         5fZx0SGML23Ghxw8+xZpdLvmr6mt7sXOrq3xBn/NlCAkDWihwRJ7237hmTIUNqHtRh52
         3meF+MOZz0M9ANAEgMTygOt93Kvou3Lcf9bDINppCMXKPz97iKl9sJUk1YLbe0R6E3fs
         nuRU+7SdeNkXjz1Hys5QTxgX9tIWfsqh9lzjUxc9720lTjJ2VNSq+lg+sTaoTrsRL40e
         ZVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B2aPCwYfw3FnQHeaxAnATXyCwwwNQTJA/ZXVopyLBaY=;
        b=aPsIXwh0kCO3FzPYkoXQ1N7gdUcOXozRho+bWe8ZuPNIQzhy1Q+FFgP3TqK0jHNyto
         Q7A+Awzmu9CYwq61xK2+31F0QkhX1GUEadGscjc/Jq4UJ4hIZLUagv/lMyYmGJ1my80g
         frmx0NS7wXjwTHwS4Zg9QSjpQ0Tl+jDXnWeLF7nDMD78479tRyGXz4tM5leeTyRv4GdY
         nmXxopa+9OVxByIsX2+gfRb24ic26WGs8ymQj+3iDvECfu6PFZdtwNEMi76kIDgGhcaq
         yiO1ij2NO9xVxBxyQM36MstOEp6ZVg4I7H3kwjhXRNm2400afPvX/D+4+5rjCg5j47Ye
         SRuw==
X-Gm-Message-State: APjAAAW/GQYYbhUeLw1WN5swVq3xahfOKJCiWhi2HbsWCZzwzdplpYNm
        ua1mLEjtKcR23dUZ/UWwYiNTYGcZVEPxRA==
X-Google-Smtp-Source: APXvYqy6myu87QsGtbgqaiuqcvids5Lygku9hWnwrAlijab5z0pETLyyI9ADnoIU4tMBp3FJ5jeN/g==
X-Received: by 2002:adf:9787:: with SMTP id s7mr20493999wrb.229.1565311396147;
        Thu, 08 Aug 2019 17:43:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l15sm9341021wrq.64.2019.08.08.17.43.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 17:43:15 -0700 (PDT)
Message-ID: <5d4cc1a3.1c69fb81.e52f4.f816@mx.google.com>
Date:   Thu, 08 Aug 2019 17:43:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.187-40-geae076a61a51
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 94 boots: 2 failed,
 82 passed with 9 offline, 1 conflict (v4.4.187-40-geae076a61a51)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 2 failed, 82 passed with 9 offline, 1=
 conflict (v4.4.187-40-geae076a61a51)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.187-40-geae076a61a51/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.187-40-geae076a61a51/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.187-40-geae076a61a51
Git Commit: eae076a61a513f87ceca92c1878c9de1f1d2db37
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.4.187-23-g46=
2a4b2bd3bf)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.4.187-23-g46=
2a4b2bd3bf)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: new failure (last pass: v4.4.187-23-g46=
2a4b2bd3bf)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
