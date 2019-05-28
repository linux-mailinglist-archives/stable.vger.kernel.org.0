Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3A92C5FC
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfE1L55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 07:57:57 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:50332 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfE1L54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 07:57:56 -0400
Received: by mail-wm1-f49.google.com with SMTP id f204so2608943wme.0
        for <stable@vger.kernel.org>; Tue, 28 May 2019 04:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OhA0VsTLH2It0jNOE/nb01dNbyql9i7Dp+A0wQl0W3I=;
        b=RthN3kwsBm3PAebrM2TUb2r6yOAYMj+CLvHJMYXuSYVZISwv0Zgs+R3jPbfLUM9ez1
         ShrhRJJhSp+648s56ztip2XF4jz7zLp+okDkV69V2nub4q2NOplRcUle5xhSDklgd0aL
         c7d1aLF9Fj9RCczEY4E4gMYNvfNZ+8g2hwEdj+O/lr/Wgl4XU86OS9tRE8p3OSGhU4QH
         VNKoMOp0r1IzhtvBp0Ck4AvFDvufE4SSQoLqqKRzJ2q3pGSQVzEdfExYrHHKlAKr7hEJ
         xeoQUMLfLK0VBmI7Iu7G8eRaK3njvGcF5yVVnYHKxDjVOSDnXuqwX9lOOUGRd0nDRQLm
         RBdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OhA0VsTLH2It0jNOE/nb01dNbyql9i7Dp+A0wQl0W3I=;
        b=QAW8TDruDTs6x6+eusVIHE4RPkz7q2hDTPtyfOaq471q05cjIMIJJjOWt99Bat5py7
         qEco0tCULaiTwqCxEhVsT0GSI/QczNvBvHB464dBJcjrjTJW/Wm+rkNrCS5r0AQw3ngv
         wps6pLmbeC3LWCo3+zk1Im3AfJsHSIY48TFqdTexFoqum1THKxq719L71MzREkKXzIfn
         4CBQZzCVPFHHYiVAP+hIXffX80WnzLLKjcZWmO/piblzJS4famnjAyvnwAKHH+NT0HvG
         SFVal4xKDzIXawNXESdH75KFVVaWlZX0WPmhxpDTXT0YMo42fYF5vNigNOcLuadJ9ajJ
         3IbA==
X-Gm-Message-State: APjAAAWleB2UOJgKhPjN1VbLY8MteuJLbcbyjh8ZrYCQG4k/XPvPs/F0
        cXL2RYscZYmTdp0yAedibtIONueNvuJ9HQ==
X-Google-Smtp-Source: APXvYqyMeQlaJ7wR23lEoCyHcxtcdHAhEI2NkikXQj8BklHHzRfnv8EuYPRiy1JSP7oNiUWA1fkM0A==
X-Received: by 2002:a1c:e386:: with SMTP id a128mr2810330wmh.69.1559044674759;
        Tue, 28 May 2019 04:57:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v13sm2270121wmj.46.2019.05.28.04.57.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 04:57:53 -0700 (PDT)
Message-ID: <5ced2241.1c69fb81.9888f.be52@mx.google.com>
Date:   Tue, 28 May 2019 04:57:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.46-30-g8b97ee9b1690
Subject: stable-rc/linux-4.19.y boot: 122 boots: 0 failed,
 107 passed with 13 offline, 2 untried/unknown (v4.19.46-30-g8b97ee9b1690)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 0 failed, 107 passed with 13 offlin=
e, 2 untried/unknown (v4.19.46-30-g8b97ee9b1690)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.46-30-g8b97ee9b1690/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.46-30-g8b97ee9b1690/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.46-30-g8b97ee9b1690
Git Commit: 8b97ee9b16909126f3e032928ce8d124a6680faf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 24 SoC families, 14 builds out of 206

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
