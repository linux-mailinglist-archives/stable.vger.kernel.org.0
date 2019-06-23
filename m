Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C74A4FDE7
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFWUMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:12:18 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35979 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfFWUMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:12:18 -0400
Received: by mail-wm1-f50.google.com with SMTP id u8so11253533wmm.1
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 13:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jpnes+R7VSSUes9JCUmCTYHee5JzI9LWW/5qExVcKWk=;
        b=usK0pRkSELwrQnEnKZbFDBiaZsVQw1blmbDJh7pXYGOHkuBgrw3JwXFXtqSPcayHDZ
         R21K/1X0Q7p/RjZUvffvLw7ChsUOF4XifDtczTYBQYWdZHlwbEtXPxgwMmlPzzWDIA/0
         6cnMIhCY/NFjjI8sjf64+EEzBa1NyEJLaVoD4UKJ3EWIIp9LYuQ6eNFmke0nW6fcke87
         5msj1EoCTLt0qaz/PC3Dqzul6jfM4GYAmN49d7ZSKBtrCXnnNA4OYgw9X52wWU8bU02v
         tWuyO6ROHoIO4ZOLxl8NzeH0jgIZu68ZCVL8amZ2/eSIAJL/H8c3F51bkRH2qXCgovpG
         Zcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jpnes+R7VSSUes9JCUmCTYHee5JzI9LWW/5qExVcKWk=;
        b=KwRu2vfPUm8shl6z59mb54uyvmBhRaSVwPACWTgpQpTypjTB524i2+P8Ldo6YH+9UP
         IvubwmT+Y2nmoNgeqoKv4OQixhQKl8AIPRpilVpOspHKYGqZH4rkmsLQtVoDuRtQLY/U
         GekdniVB+CVG4dlbFMoafiJrCKT+spVXD3wT2LIjq6COabfPR2vRDzlQkN63KBCXr53t
         qIP7OTJVdXQM28DsJFTKozh7d30irjioOI1f0aG+Wcenusd6EzgJbG+9nBU5Mij0uwin
         DvqmSfM4mdgn4V51GS1VSmU84Amv2bp6uM0trJ/MhciK3+sv+00TM+8mu+qTqGQY0/0b
         zVEw==
X-Gm-Message-State: APjAAAXMoYcdTSG0157Aknvn1EoJhEgT3nOv225rAebo0vkXI6ITxyMK
        dvsnL+4IvngEd0fHMq+/MegSTOaF2t8=
X-Google-Smtp-Source: APXvYqzV4Kaw2VQ0qwOHuwq9ZJJTYZ9bMkmM9onQ4kgvs1szG6sxbc+nm5OWJESpEuIumTHDoDBrgA==
X-Received: by 2002:a7b:c398:: with SMTP id s24mr7825859wmj.53.1561320736493;
        Sun, 23 Jun 2019 13:12:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 203sm5515873wmc.30.2019.06.23.13.12.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 13:12:16 -0700 (PDT)
Message-ID: <5d0fdd20.1c69fb81.353c6.d35e@mx.google.com>
Date:   Sun, 23 Jun 2019 13:12:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.183-5-ge81a82970b3c
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 102 boots: 0 failed,
 95 passed with 7 offline (v4.9.183-5-ge81a82970b3c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 0 failed, 95 passed with 7 offline (=
v4.9.183-5-ge81a82970b3c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.183-5-ge81a82970b3c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.183-5-ge81a82970b3c/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.183-5-ge81a82970b3c
Git Commit: e81a82970b3c7990d68c64d5868772f0990e42e9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 21 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
