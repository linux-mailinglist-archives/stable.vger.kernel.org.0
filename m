Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3394628CE3
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 00:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388445AbfEWWZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 18:25:06 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:35897 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387605AbfEWWZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 18:25:06 -0400
Received: by mail-wr1-f43.google.com with SMTP id s17so7929006wru.3
        for <stable@vger.kernel.org>; Thu, 23 May 2019 15:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VDdlpOqEKlu8RqVxfGQ7BI6Hx63FgfkinxI+fDEYdKs=;
        b=kxqL/8Rbm0tbS+JUo4jaVbZFL5izmDwF1frHHh2T6Yluv+GDUZ07PzcEvHuV0ONwY9
         LI13QvVe2Thz65+SXXhaqxRT0VvSAutAG98++fE8afBVFAvCvPed+yRZOCBq1bwotbFx
         2bbjqSQqbxuPW5QxYHhBXZ7EMstJ/wFM+h0iKPMkzWUDzD40qNn7R7BS3A+bYl1UuWoI
         9KN2ozvo5NFyOd7Gz40FWpT+8XRL6CLEi0+hO/bVgiscOJSuBYbKBmR5hjJAfur0aDgi
         cBjw0tXIZKkZMUNb0d51OUPFWMIEuSgFDB+ulRFRm8Kvlg2FOGbWQQvvLO9YI9Nl9hcW
         pIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VDdlpOqEKlu8RqVxfGQ7BI6Hx63FgfkinxI+fDEYdKs=;
        b=apKqTUUQjH6skTn+C/49x4n0tokuAWINvw1up+wMb9NXJuS/7kO8USEw3OQhb4WFAx
         2X6dMd8X49tjIOgxNT99aXeGBNMPggEgHuGzLCKByiipeGAjZN43wG5WHSPrS05yiDtk
         J13YkTO35NyMXMYE64TanY4j3JU+wqMSoxOo49cnduq7QBMT6+Spwafb7fZXVg6XzQen
         5cs6yO2jt4I72k0Uy4BWBHogQGpuUre/VsaVFE/dKBUywJ89nhTNPywGUjPNn820kLoD
         OuhIK1c9OLgyLLH/IT0v6/SCXQ26NcwObxLDKzCbr9DGpKo9OrYZ51/Ak3dGuXFnmjgF
         ichw==
X-Gm-Message-State: APjAAAWJ6lDg5iKI/KALCwbwzmJBjl0tnpdT7IZeKtNQLIVE/4GqTGqb
        E8FZeqXvq68GybZzR2J1UFjWHKexbsmRuQ==
X-Google-Smtp-Source: APXvYqyqAEZCaVcxoZyImrUFYZCzGey1JTwk/r7D5s/Pn2OofaZrqjoIiM0h7fgsbjDU+KagWGgI7A==
X-Received: by 2002:a5d:440a:: with SMTP id z10mr20551691wrq.157.1558650304364;
        Thu, 23 May 2019 15:25:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s17sm621093wmj.15.2019.05.23.15.25.03
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 15:25:03 -0700 (PDT)
Message-ID: <5ce71dbf.1c69fb81.a0937.3b2e@mx.google.com>
Date:   Thu, 23 May 2019 15:25:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.45
Subject: stable-rc/linux-4.19.y boot: 130 boots: 0 failed,
 116 passed with 13 offline, 1 untried/unknown (v4.19.45)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 130 boots: 0 failed, 116 passed with 13 offlin=
e, 1 untried/unknown (v4.19.45)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.45/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.45/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.45
Git Commit: c3a0725977484ea2d7f17746d7e168d2b19f99a2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 14 builds out of 206

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

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab

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
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
