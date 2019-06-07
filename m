Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDF838449
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 08:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfFGG1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 02:27:12 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:53730 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfFGG1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 02:27:11 -0400
Received: by mail-wm1-f44.google.com with SMTP id x15so729554wmj.3
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 23:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ap2p4K3FsBhUMMLvzSSv6qGy6XWuBL+FfMivSOfqOJ8=;
        b=YsJiQKQXEO8URc/XFZiHaPJT0yV/1oKhdjfdKYDbdeOOd/hmSRlWg/DDIHBM1YYpD0
         nDer+8r1VBjiXkAj4lXuXgiZf/ExcrgugFDtmRl1uuTzgwUFjgrn3y9Mn8CjBxSedX5M
         K3/sTGgzVplaPLnGX0f9o1qvG4GQCW3Xk6eRuXtAQl+/YkKQTG8i0P25fT5igUYOMaem
         riNP7A6XgrbYxP7KAcO0tFZRNPHGDdft2wsa6mF8+2jIMAeZVQLerhaJ8o0EqBuL/9Sh
         3UlWtfv82q3UceblLs/tWQkHOhwPWYxvRrb6Z1Obai/DZoVTdENmoDR76oR5Kc1VnHM7
         kzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ap2p4K3FsBhUMMLvzSSv6qGy6XWuBL+FfMivSOfqOJ8=;
        b=PvpTKRJ1yW8nrja+HmEgc70NWert1m0lULI/bliVWC2GkDVm+nCdDgrog+lN7+7YuE
         ei1rXNbPkYlQsHtkEUvQQAtJMDOBKQui7UsgLbsIQ7kxRBApUcl0QRuuKQW3eONflNOb
         gE4yRy3leAYEtPtzkhMobLfkgua1MUWsvrPu6ADPntCDytKJfeVMHOcVFucWrohOC44s
         4mSZ08yMa0lbzDElUkwiOz5kEKjpNZ0M+phnFCWBI6WRUVGFAq9KOwr5LqFWn2Z8K6uj
         WZrR4WU9jYjIp2XmIK1A8XrmWA2wCQi3LARBl6vyK5lvLeVrsy2v8LMiH0esMBwBVT5O
         Re2w==
X-Gm-Message-State: APjAAAVwBcYztBZn5BApNLDeKTUJ1FI2VPe69pZmcgCLtX2f/e+ZTSKH
        oTi84NTQ0rv0hEl72/LM4n/3cTDNgKHrzA==
X-Google-Smtp-Source: APXvYqwlHSdGsIgkzmev+fFXG/hX5OSSma8R4YxR9HD7xXWLEBW8s4WSnqIfwZ4n1HBf5c68cXO6Ww==
X-Received: by 2002:a7b:ce01:: with SMTP id m1mr2309130wmc.1.1559888829721;
        Thu, 06 Jun 2019 23:27:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v184sm1065194wme.10.2019.06.06.23.27.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 23:27:08 -0700 (PDT)
Message-ID: <5cfa03bc.1c69fb81.3b820.5764@mx.google.com>
Date:   Thu, 06 Jun 2019 23:27:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.48-73-gbcc090cdcd34
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 123 boots: 0 failed,
 112 passed with 10 offline, 1 conflict (v4.19.48-73-gbcc090cdcd34)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 123 boots: 0 failed, 112 passed with 10 offlin=
e, 1 conflict (v4.19.48-73-gbcc090cdcd34)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.48-73-gbcc090cdcd34/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.48-73-gbcc090cdcd34/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.48-73-gbcc090cdcd34
Git Commit: bcc090cdcd3453e60d078bbce0f28dc4ebb8d79d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre-seattle: new failure (last pass: v4.19.48)

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxl-s905x-khadas-vim:
            lab-baylibre-seattle: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
