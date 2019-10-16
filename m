Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6077BD9985
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 20:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394417AbfJPSs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 14:48:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42327 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731889AbfJPSs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 14:48:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so29203738wrw.9
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 11:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tJaLF4M9eFIhCv8hzj+P+T3xmiCHnVziGzOsVE/6KSU=;
        b=M10zumeO3VAfSBx6/5HuI3PzM5tOqglqnUxjXUBFYZ+C1rsvl/zrGovFFsxL5yh2nl
         bMPyIa/C4tsgmCTblbHW6O5SNe/5Ugb+9pEVKDtxCJV7p7PSaFL5I1WfnV/A/G9/Zg35
         5HwJixKSISVWJiqJI00rEXHEvB4A1kvnTdIBku4QTlA1V6jII0hvzSyrndtyERQoTTOF
         HN4G3vCHb5zqR/wJ1qZepv7leedYllGrQEMgH19H124j1tz+ryoqzYTDWD6y2xHZ3dY7
         wd9dJmbCmBWVQHmJgBQ/BrCJRtPF6+Tx5lILbmiwpKLachEurmdp9wcPT/fY5tSMdb5m
         AC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tJaLF4M9eFIhCv8hzj+P+T3xmiCHnVziGzOsVE/6KSU=;
        b=lC++LKe+2Y/GaQ30L7ELXX1jWI/1gN4uclVZPY7oLEn1s9ZrLvfpr9Fwt4sVOF8Sgi
         kOC0DFbiVCK9RTjihCheubjAaoZBCL+Lomk35BwugxenFuXFWCv7gGlp+Kkl1zZ6vooo
         0/LfST1hOUlrAGzWY6I+C8F4UwS8/Cy03tnBB5WFjiKAdML+Tlt6p1cjWn2qojQGNvmw
         AkcI3thqsnP1RKsAxULRUr8QqzeSWmlRcaTz5g4IIQTn8Uubox+TTBHirTrx7+6+GOxS
         +ocd+nb7a+Mau4LYvAXFHdwgUaLVB8u/kgDDpR60O1Hz3EUc0UQ3HZySRLdV3d/731nX
         dZdA==
X-Gm-Message-State: APjAAAW15FwB2H4fWK+IY9uRL1qiQae7frBVUa4uH0MeZ8eml3f8+r9m
        4sba/sa+vveXVNyBaH9ERS4tYkfd6M8=
X-Google-Smtp-Source: APXvYqzmcrqWBtkK+cK3u/hGLzCJVjqfCsX7chr4ca8ggk9tLCfmKAs7NfY2WCFCLa1H52lEs32rew==
X-Received: by 2002:a5d:540d:: with SMTP id g13mr3794523wrv.8.1571251735256;
        Wed, 16 Oct 2019 11:48:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm58992700wre.91.2019.10.16.11.48.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 11:48:54 -0700 (PDT)
Message-ID: <5da76616.1c69fb81.9f348.473f@mx.google.com>
Date:   Wed, 16 Oct 2019 11:48:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.149-65-gb29fcefccab6
Subject: stable-rc/linux-4.14.y boot: 101 boots: 1 failed,
 94 passed with 6 offline (v4.14.149-65-gb29fcefccab6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 101 boots: 1 failed, 94 passed with 6 offline =
(v4.14.149-65-gb29fcefccab6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.149-65-gb29fcefccab6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.149-65-gb29fcefccab6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.149-65-gb29fcefccab6
Git Commit: b29fcefccab67589bcd5b49b74967d723e708013
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 21 SoC families, 13 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
