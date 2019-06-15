Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701D24725E
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 00:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFOWTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 18:19:20 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:53467 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfFOWTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 18:19:20 -0400
Received: by mail-wm1-f54.google.com with SMTP id x15so5680857wmj.3
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 15:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sQRhN1SBv2x0yHi4tZ+G9VwBdVToeKhnI3htMwLU3Jw=;
        b=FF99P6UoV6J+KX+uIECLtGfj8N+OLpVM/mWAps7BthJzGPO6VwaKi57eQiwOCeSdak
         X4LgyoNMNuFcYIS8KItZ85jmenH4xD8yyhh6q9f87vXMR9IDF/Lz9jBBtLrJWl5bQfn7
         WdHfkdEEIIX8iEGEVMPsdJ8CCBfeWFabeXVuzWWYG32mhcBTlIgBTRZoTbVzuZrSl0Se
         KNO9lO73ZlyOsdonUERL9/+Q6on6bpNWpThW9xuknVDyz+R+aLyLSyoGOfpXlL3vTuJy
         ywYfKvZHrB+O3dNV3OCIxWS+Jj+IAv3+mQJJoIZ8Nzbs3gS74HElty8uyDA2TJp/D0dQ
         86nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sQRhN1SBv2x0yHi4tZ+G9VwBdVToeKhnI3htMwLU3Jw=;
        b=JHEPxxiWUnr2nHY1WM+kBtRVPRxOJj9EB3XXocFdGHLEKawVAsxMmuazS9y2+MrvuR
         raFWZoRruNFT7MH0JBuSwVoVde1drqRsRQV6BjvEOtBB99FqhpXIrMKlfe2Kwcg1aX5x
         qY5YuD0egLpdqdfO5T2WjWE/ZE1iYag/Ugp+0vfqbjxBrSxDByMonNA0jctB4pLBuzNH
         vjT3565eVOi2lYnw1SuW+7xoB8IbfyRRXirvECETMIP5AuvkFueEBD0wF8VYOmq3sjLu
         qEUnGmrN1jrs+faDXqIrsY30eCLEqaUzC4iylVCBhNF9zkqfYGTow8O6ycNKC2vs2ix9
         CTcA==
X-Gm-Message-State: APjAAAXP0ylZMDFh18kiB0yuxezD91NWAqNdXpqj2DI/KSPLdypkPaM/
        nlJibvc+J/C6wlWUrpnibh7ZcN4HZwo6ZQ==
X-Google-Smtp-Source: APXvYqxfQBicaCOt5/HAQOQsIwwW+kBXT3Vv1IgognuXrWuhMO7XVUVhg95fS/DIl79mXXBhxOwmCQ==
X-Received: by 2002:a1c:a952:: with SMTP id s79mr13640822wme.28.1560637157886;
        Sat, 15 Jun 2019 15:19:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u18sm2843801wmd.19.2019.06.15.15.19.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 15:19:17 -0700 (PDT)
Message-ID: <5d056ee5.1c69fb81.1b485.ebf2@mx.google.com>
Date:   Sat, 15 Jun 2019 15:19:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.10-42-ge4ee75284c6d
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 118 boots: 1 failed,
 101 passed with 16 offline (v5.1.10-42-ge4ee75284c6d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 118 boots: 1 failed, 101 passed with 16 offline=
 (v5.1.10-42-ge4ee75284c6d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.10-42-ge4ee75284c6d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.10-42-ge4ee75284c6d/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.10-42-ge4ee75284c6d
Git Commit: e4ee75284c6d39435be3fcafa82cea9c656dc6bd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            mt7622-rfb1: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
