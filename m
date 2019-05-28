Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F052C7A0
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfE1NRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 09:17:21 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:36816 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfE1NRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 09:17:20 -0400
Received: by mail-wm1-f50.google.com with SMTP id v22so2832418wml.1
        for <stable@vger.kernel.org>; Tue, 28 May 2019 06:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SB+pWO+jbnrZBCJoNl+6ckvaMTxlfy/Z9jYrdl6f2ew=;
        b=fXqFEGDs3/h4xrhY+jRbvAE74T8xyex/IPciQ5GFYPgjEiELkxMuJLNvSuW0qq6AOO
         cc2eYPQayy6Rm/ROVy5ShM4a/ejGHON6sop/HMbMJsbiMmzg670yLZgQGvl/gyGS5Q8r
         sXHAg5hnx9yYOxHg7EflbUW0MvK/cU/xe/JCMLjL0DlP4rBBWJFLuvSumD2BjV9wAVpz
         dze9OSBIO4Eg1bgjpYF9MO/tE02Ikw/VBDk/hr1Bsgk8VwoyowqdTmVuiwo3EsrKshAV
         0R7tpJI7rhfq93s/LQRKQvycBvIfCN2y9eXs8LLlCXyIdwB2s8WUPdaU2qovl6Qwlv+K
         lEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SB+pWO+jbnrZBCJoNl+6ckvaMTxlfy/Z9jYrdl6f2ew=;
        b=qf7DR0BdD/SLu02ZOCyBZ0QsK4vrky8ef5fWuWvk3QxvxUxtwYT1w2t2dF1jemohVU
         l4MdKY7jFVfjJFY6e7hEJC8Gf3iw4rPQBrkiTOEdeoerVNJCAdQv+MpJ6iEUfpwH2nFz
         UmZGb4J0TO1DgOEz02HiVQWL7rfKgt2HqRr4ZJLa7LPhQHXmOIZZdljgHNjVgpFpEGL6
         cBZsVgo/tQAxljLZp1jM/QYG8In9xsu4Ff1WKpD+DzgyaYgKfLxH+UWG7hHcglpfzVVY
         5uiWRTwhg07HIALRnRUQnz2Ft+gMQ66pKSdsAsUppvnxWL9woA/gir6zCVveSUrcyD/4
         Rupw==
X-Gm-Message-State: APjAAAXTws8fUNj69Tu2urzwLs8H/boGuqIa+S4EOym07z9+eeExFhtZ
        c9PzFRbbTplwmBZcyknsRCcqXhV6kIb1/A==
X-Google-Smtp-Source: APXvYqxdeMgU9f4tjl82acpH/Plg8Q9X/muQUyeIAy3xdIuy+C18Utbu1LETz5i8rIVmVwO6K1xEHA==
X-Received: by 2002:a1c:c8:: with SMTP id 191mr3292298wma.6.1559049438135;
        Tue, 28 May 2019 06:17:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d17sm19326176wrw.18.2019.05.28.06.17.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 06:17:17 -0700 (PDT)
Message-ID: <5ced34dd.1c69fb81.911d6.b5a6@mx.google.com>
Date:   Tue, 28 May 2019 06:17:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.180-86-g993d4176cdcf
Subject: stable-rc/linux-4.4.y boot: 94 boots: 1 failed,
 80 passed with 13 offline (v4.4.180-86-g993d4176cdcf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 1 failed, 80 passed with 13 offline (=
v4.4.180-86-g993d4176cdcf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180-86-g993d4176cdcf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180-86-g993d4176cdcf/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180-86-g993d4176cdcf
Git Commit: 993d4176cdcf5d9a8307c0a111a7b769e7dbfc0c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 21 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

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

---
For more info write to <info@kernelci.org>
