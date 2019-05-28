Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31E42C648
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 14:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfE1MRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 08:17:32 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:33188 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfE1MRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 08:17:31 -0400
Received: by mail-wm1-f44.google.com with SMTP id v19so2173307wmh.0
        for <stable@vger.kernel.org>; Tue, 28 May 2019 05:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X8hh2DQHLWOglIB2p/h4hFAe/1cQHXsC+hZ4e44XPY8=;
        b=qqUmQblwnPyWSkMgEoGmZfX4PGdBQb73xyYAy4ad3d8wu3hiG5KgOsk+bchsqY9rxy
         7r/CY2LYOOJtdX4ceDCRZnxh2gitL+IB50LhJ69kcJ/rR/IkaIHcIR6C+38Cv/Cohy1t
         kCpywj16ktZHgOshYcfFWyLoCt6yR5qdSj6nBU3Up6M0mKElqB9RITX0YSiyr1xQLVZL
         HMLmrRUTo+7c+E7O2QC5K0Pt0qIFnFwUS2iqhLAPhb92l7/chRlVuDYqfcZWJS0S5AT8
         BoKCsvUBT5FS+Chzs2rqYHl0DC6tqTnZTOdlwlx0oRbGqmXOrduEPpsIPNMV5NxHUnEo
         XGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X8hh2DQHLWOglIB2p/h4hFAe/1cQHXsC+hZ4e44XPY8=;
        b=kcENw5xtKEzjHVzqhnpJNIKE/jma4O4aRNXpnRzX+btnV27EqITcmWkZqJZDEtw430
         lqVkKHO+52fPPsfJQs2bLWJFMFGxN3JEMCxIm4vE4SajCb1dsRGK/OwTiSJUUX84jile
         +E0z90/JxqveryckaOHH8yDI/IGuc8jqRQBIHMKR7PYu/E6mK/MvJsvRWAExpkqHAdzM
         YYV3ear0E5tXKd1riPn6Q2knDslxg4sucCS1hU/6GwxHH10+ptycoZpqVoTFsc5VyUH4
         BPYHXqf2kS75upNx1foP+ZZT4CeV0g3XH+6uDtlJl7l8VvmBk8dKu5bX8S748hcpmiJa
         ewgg==
X-Gm-Message-State: APjAAAXae8fXx/V+d5BHoPu2hyYLF5nr67vIK7eA//6otf3euYNSG4Um
        yuXwlNFOsqMBwtcEtKY633esmInAcw/u3g==
X-Google-Smtp-Source: APXvYqxRF4ji80RzE9+dGDDmssaJ6haOzIZ+oeTC+Sgv2+ToGwhzGB0Wl2DRpjGD58uXccyaZbdoWg==
X-Received: by 2002:a05:600c:40f:: with SMTP id q15mr2874001wmb.157.1559045849479;
        Tue, 28 May 2019 05:17:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 91sm21578883wrs.43.2019.05.28.05.17.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 05:17:28 -0700 (PDT)
Message-ID: <5ced26d8.1c69fb81.fc650.6a60@mx.google.com>
Date:   Tue, 28 May 2019 05:17:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.179-15-g6ead2a5eb114
Subject: stable-rc/linux-4.9.y boot: 105 boots: 0 failed,
 90 passed with 15 offline (v4.9.179-15-g6ead2a5eb114)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 105 boots: 0 failed, 90 passed with 15 offline =
(v4.9.179-15-g6ead2a5eb114)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.179-15-g6ead2a5eb114/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.179-15-g6ead2a5eb114/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.179-15-g6ead2a5eb114
Git Commit: 6ead2a5eb114800cdc160a2f2ab6457c01ff3d16
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
