Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02293CB1FC
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 00:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbfJCWnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 18:43:17 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52729 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730027AbfJCWnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 18:43:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so3673588wmh.2
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 15:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5XLyElFX3eltdjc+ovCaDsZywZC9OfTTs7UKklg4XX0=;
        b=XQk3IyBnZH8G6nc2OMPUCLZSKtsCagHLSDdjHxR2cADhM/Lk/CahVXuZC8NrSZJIQF
         /Fuo/xKOpmWhZUWDud/Fz/ZNAF+RkPFUDnIo1angnpFU3O5JXutux6m2G4d41U+L9Tcf
         3S61u3SOMthCvJ/uBa0H8PkSCXQLv03k7uxl9/doat4vduS3ION9+HEwVf7pIMtKyrbB
         zHDtSZF6hOfv3PP6yXpG9hxGEIA/T9uHW7tHjon//2cqXWHIi0NtmTAMU3TsGQ7i3wxw
         6leU94UNdPe2P6hauwyL8EQqLx5A820XnsLxHycTO7NMNl+3LqSU7QAOVI5dHWmrtxc2
         1uJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5XLyElFX3eltdjc+ovCaDsZywZC9OfTTs7UKklg4XX0=;
        b=SQWzO+J0/mOA/oWe6PRqRlUhLCptCdldkloYRV+0ankI2kzLCnwIzhD+R8kTvEMgvc
         fkDPZ0ydlPhLsy96xec4MBD38rA0NqBGSzblSuRxNbsgLqgPfAShqogAYzLOVz0OXOi9
         gZ3EDNs+BMtjVAqXgFdo41Dg+O7ozzexCfrpZ6l/lMU//SqRw8fXugu19AE1jpFNqU7S
         rJMBXYKnyKj7l5mSkmT/TFdawKeF8RM0m2IgptJedR4eo/xpXfgY3/3Awxn/eLO59Aq6
         jTn2yHEH+ywm8QiIUsda4Zas28dyESfJcjDLfkFNEU6btAcvB0l7ssRy3Q7bO1D4g59/
         Y0jg==
X-Gm-Message-State: APjAAAWVsuSOKqLNNxSeDSnEm7Zu128k8vkoOsNA46tCWfjm493tSXWx
        GR+9KWKvoSk8eM2Zvm2SIuWD84aFuWRVNQ==
X-Google-Smtp-Source: APXvYqwL/kZpJy+nXYHT8mBwKkXzT+IcWJ7EN+xR/yYIj9yGuZBShVVBDZ9QKPt5mdeDWuiunI/MtA==
X-Received: by 2002:a1c:4c12:: with SMTP id z18mr8337698wmf.45.1570142594880;
        Thu, 03 Oct 2019 15:43:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m18sm8813137wrg.97.2019.10.03.15.43.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 15:43:14 -0700 (PDT)
Message-ID: <5d967982.1c69fb81.be3e3.af46@mx.google.com>
Date:   Thu, 03 Oct 2019 15:43:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.18-314-g2c8369f13ff8
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.2.y boot: 136 boots: 1 failed,
 126 passed with 9 offline (v5.2.18-314-g2c8369f13ff8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 136 boots: 1 failed, 126 passed with 9 offline =
(v5.2.18-314-g2c8369f13ff8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.18-314-g2c8369f13ff8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.18-314-g2c8369f13ff8/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.18-314-g2c8369f13ff8
Git Commit: 2c8369f13ff8c1375690964c79ffdc0e41ab4f97
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 27 SoC families, 16 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

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
