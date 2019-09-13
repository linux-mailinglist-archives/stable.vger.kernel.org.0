Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F6B1BDE
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 12:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387980AbfIMK7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 06:59:41 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:42062 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387712AbfIMK7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 06:59:41 -0400
Received: by mail-wr1-f47.google.com with SMTP id q14so31603208wrm.9
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 03:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VwUHPPSTGiSQBKDwFBi8SG1k5Ek2C3s2B72gCgXWMVo=;
        b=hE7QV10NGVtnEGXvlCPUZyeatkGs/+KcuucZDZSBU95r7bOvR9sCksXOZKG2W0peNx
         R1C2B7M6kvD7XJH9qq2R3uVK6T11gh/1v1hPLgM82TRxRSf0iB+ThH6jlXQPZi2xNL81
         mH7lnCL5slHLtKgvamwpPidr7B/FLRhHcLeYGIk/5Rb5TyrAY41UNWMQ6hVesY622q9N
         0Zx9zu0oJI8jysUa3aMMGrDtaYTy2TYIXZN4z7iR5+RoFiXZx1sGVhIpqSNsAKEKqmFv
         kBGmeVQvZmMgpW/eJyDTpgZN4iMFMW8OfrqUB/RHjBSBon1MLXDsyanTji4CcTfoEpOk
         +c0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VwUHPPSTGiSQBKDwFBi8SG1k5Ek2C3s2B72gCgXWMVo=;
        b=SK8SU4diG4Xq9jv6M3Dx/GHvjV3gmGdLjUa2a2PvsxQG/+FyeiCv7JggZh7A/pOLRr
         E2uywtty4LIoF+9F3ZOBePO9Do4X2Lt0RmYhSwwg6XRdWKV44wiUyqw6nNkOk4b45u0W
         KlKGoDEG1KKgBi1cB08EFn4rYlKF/on31fOd1a17Rr+Z4wui4MBasKligK/YUitX97ui
         FVzIj9aFiMv7fE1TrwFbR8czCfk9114hK4uLbJ9ChuGs4yO1etVzfA1GrO8s7cMUP4l6
         vHk3SrFCtnLW7vMCaPPxcHK5dYEz4eno1cIw/PoT6gEmBoTzXdio2nBjeSGijJtpYrQg
         jMSQ==
X-Gm-Message-State: APjAAAXemJOMIqN1WjzVq//cM9rM2YPRqwuBbX/us2pp8i1sXK0RSlXm
        4vXpgnU4L6FMtPg6BEJel9zgC5i1uV8=
X-Google-Smtp-Source: APXvYqxreYrCWTL9hdTnWVEzwmkI1J4JwHou+G33IUQmzDQbXRFtXekMAYFZaLb95WK7vojFpNp9uw==
X-Received: by 2002:adf:e607:: with SMTP id p7mr3777134wrm.230.1568372377626;
        Fri, 13 Sep 2019 03:59:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q66sm2965996wme.39.2019.09.13.03.59.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:59:36 -0700 (PDT)
Message-ID: <5d7b7698.1c69fb81.e926.dec7@mx.google.com>
Date:   Fri, 13 Sep 2019 03:59:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.72-189-g464c8ea4cd98
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 134 boots: 0 failed,
 125 passed with 9 offline (v4.19.72-189-g464c8ea4cd98)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 134 boots: 0 failed, 125 passed with 9 offline=
 (v4.19.72-189-g464c8ea4cd98)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.72-189-g464c8ea4cd98/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.72-189-g464c8ea4cd98/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.72-189-g464c8ea4cd98
Git Commit: 464c8ea4cd98f1cec8eec0b1d3ea6ef923150c22
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

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

---
For more info write to <info@kernelci.org>
