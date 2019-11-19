Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4EF1024CA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfKSMpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:45:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53822 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfKSMpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 07:45:07 -0500
Received: by mail-wm1-f65.google.com with SMTP id u18so3046295wmc.3
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 04:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4M0D+S4UUP4O1UQg2uOZg6VCbM6B7GY8GuLVPZMPjxY=;
        b=k+8luDHV7NA7ng+r/DDTKPKC7DkUafcMNHSS8Sz7/4fXzARI6XaycFpbG8REiQlDl4
         hdxchD4klIVabqJkD2rA2JaGdpV+A/LQHO8n4nLrqO8vFjt5VKg0OCuwEwiIf0C8mxqe
         JCWdega9JamGSKm8GMyec4GWbRQzKLhz7svkWLbt5vX9fxijLN29q4tEENvQgEXtvk/J
         +vxjJE6TLM3ba3IjmKwPqy2eEBOoa+V866o6/UM6EPhRVAGyG3bzs7mJtxgG8biLyBTo
         qntux1FjEpvlD0+Jal8gnLDTLp7Rf2is9dM44Z8zgCMUM2EnmaHCOieiFE6IScmjKoDp
         6QEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4M0D+S4UUP4O1UQg2uOZg6VCbM6B7GY8GuLVPZMPjxY=;
        b=og5nmXbMEhj4v4wy0ZK9Ta+HEQpbv0q/wCbHMHkgN8qNAgt9kE2xIwDEUg7IS9K0uX
         ZuP3jX98lKNaaOYK8PODt9gtWB0GMRA6xLpVHKAcMeUdfiEmsDPbVz3k+8oe5LLILyff
         8IKpKWaWiRnoOpyHpvDdXgec3KVY0HwiozLTnbXmaUktK2hQPuI2ZnKnLRHIvEqqWkRn
         PaSmDPa8HQXjAaWzBCd9XINQh4FCuZwp/8z2Dxyj4mW9qRnFNNZ6BFKdVsqtsoz0fVA3
         adDGrPbCkn2B+Bw593NSwgBsbhXxmRtX/Zlt32TH227wjEkPr9W8dUPCK3KkxyvxXi+p
         f6Ww==
X-Gm-Message-State: APjAAAVEDDTQsKpDT8dOAuP2pYqlCqBEV8tjTEGR/KPFtlqwqMt2zPji
        jNg6DQSeGWxLVND2rQFc/HVkKtMtmtA8Iw==
X-Google-Smtp-Source: APXvYqw9NNNSRLTg9n5gA02pJZ9LOOFIiLlkf4tywDxRWzaRZkcXhzh6Np07NJ24YJfPZy/AtB9jDQ==
X-Received: by 2002:a05:600c:22c1:: with SMTP id 1mr5599245wmg.142.1574167504890;
        Tue, 19 Nov 2019 04:45:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n17sm26171649wrp.40.2019.11.19.04.45.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 04:45:03 -0800 (PST)
Message-ID: <5dd3e3cf.1c69fb81.9f190.d416@mx.google.com>
Date:   Tue, 19 Nov 2019 04:45:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.11-50-g6d539b8f097b
Subject: stable-rc/linux-5.3.y boot: 137 boots: 0 failed,
 123 passed with 14 offline (v5.3.11-50-g6d539b8f097b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 137 boots: 0 failed, 123 passed with 14 offline=
 (v5.3.11-50-g6d539b8f097b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.11-50-g6d539b8f097b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.11-50-g6d539b8f097b/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.11-50-g6d539b8f097b
Git Commit: 6d539b8f097b64486da01863c6ae6e21b1003af7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 26 SoC families, 17 builds out of 208

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.3.11=
 - first fail: v5.3.11-49-g0a89ac54e7d5)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4ek:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.3.11=
 - first fail: v5.3.11-49-g0a89ac54e7d5)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.3.11=
 - first fail: v5.3.11-49-g0a89ac54e7d5)

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

    sama5_defconfig:
        gcc-8
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
