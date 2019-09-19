Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B77B7DBD
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 17:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390955AbfISPKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 11:10:47 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:50767 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388416AbfISPKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 11:10:41 -0400
Received: by mail-wm1-f50.google.com with SMTP id 5so5041996wmg.0
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 08:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p7nnKHqYVdBAajceokUwM/1kYDq+KSGqKkQagfBEaEY=;
        b=IdhkwyH8BKdbnENVXnUx4ilqyeRmVxFkCkG3CVJTQ4aZQUF/6lRZEhMhAOsnjeVfHD
         5WsoWVinK9hRMWUxTVajJU6bqeikrIY7Pge2jwc+1ge/1PzXQ0c+uWIteuuyCBpIbWNt
         tdEgz4qPNCYV0qZOOwr7Zckm3QNtyYsiaXMNFSUUpuH3Gs6WGFy+ZhzTy11bN5a7NMpF
         JkQi2FY/fYU8AJps1cjRY7cvRdtCnMMhBme4njz0BD/Lbdy37c/eW7ut1yyn8wffPDwL
         87knKNVqwcu0h5RHqRoSXy0HOJIFITta7F6Yor6yC8n1arVrzys6+zRbDr5SH2e3MEiP
         MZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p7nnKHqYVdBAajceokUwM/1kYDq+KSGqKkQagfBEaEY=;
        b=ibJgXr1khATfk8hbCTqk0kHurTj8JK/1bhdom/D+jhRU7hSqfgodC6EO8K83qVv8BO
         E1QThg9ou/zX40UgUBg0JyRaCCLGea0wPN4Xn1R2NVNTA01vzs08mZRMPvLAAiWYqdPk
         Nq8t+ZOAfVgaEyv6DrrU91MGK0uj+iiIxWSFi7LOcVAXL9npZtTQdbrYrBpiSUvqnE/3
         hf52AHrxJ5g4gRxS5B203NBlQMOSRHtztcY17qqBgL5H/1DeLuUrThTJF7Lxs0EA6gsW
         aaCX1bRVqLuFp4qqcUW9E7Ys6o4AVxUjA6359ZYKBZ7YHS2gfa2Yxy0VeGXm0NLSsaEn
         T3vw==
X-Gm-Message-State: APjAAAV2vhZLF9BW6Pf+YItVotw4Nht1T3n8pCATTwRO2+KcPkz8O7zN
        UG+vMzqqtlMoC/sSP5zpqqaaFjWoCKvGdg==
X-Google-Smtp-Source: APXvYqyjJE2XpNuq9Q+NlsVrYF1lfRSGOL7EglCEgvdMgSOPmqFG3jJV3PxSWk1S2exPsd8o1afx6g==
X-Received: by 2002:a1c:2bc7:: with SMTP id r190mr3596035wmr.143.1568905839139;
        Thu, 19 Sep 2019 08:10:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c6sm11033825wrm.71.2019.09.19.08.10.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 08:10:38 -0700 (PDT)
Message-ID: <5d839a6e.1c69fb81.a781.4063@mx.google.com>
Date:   Thu, 19 Sep 2019 08:10:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.74
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 129 boots: 0 failed,
 114 passed with 14 offline, 1 untried/unknown (v4.19.74)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 129 boots: 0 failed, 114 passed with 14 offlin=
e, 1 untried/unknown (v4.19.74)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.74/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.74/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.74
Git Commit: dbc29aff8d04f134553326a0c533a442a1774041
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 24 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
