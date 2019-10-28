Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9A4E6AA7
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 03:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfJ1CH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 22:07:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36125 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbfJ1CHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 22:07:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id w18so8190953wrt.3
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 19:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i7hxXFjzlLlfZoUF0cIxBXjoGMu+HjgbjoJFWkOWFb8=;
        b=RByA3LyLHdPbeszryzosFxDrNt/a3P/kDwd1jTsbYh87b4aC1iTZhbeiniESMiE+ti
         umGgXoau0YiLmn3ujCq27myhJZZuCgvADNFOMLN4vIfguMJZJkwwqADXw8j3pUFqBYxm
         Pncfp7eRdf0cTZgLh1V12Z/xUhbf2lPcPQ7XnkYwAwgO4rvHIl0Z3ThGtLcry6IkqhTC
         Y+to2CwNq0Ud/rKEZaj6RXn7JM50iFVmvzl0ApDI24BIp/6+XCLFqB+yT2Pjl5rKGsJ5
         6mELuiSZeJr5yphSiK9jBlATGigtaPGlS6XhEDvQ47UbZF8ZfX/fyUB//VMmJ5yYqHp9
         W0Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i7hxXFjzlLlfZoUF0cIxBXjoGMu+HjgbjoJFWkOWFb8=;
        b=mzqDtbqdLh3dMSOFqR+SBV1spSNuHRg+H/jYQv8lclOv4LP6K+vAfnVMknjj0uWTR4
         bSB+JuatSKwWiFlRI/z65mSo9MWPLIp3wq4H8jAtnpIVxvuMh8xwx3KwPuB7bkgkzrTV
         RCKmZuo847jU2WfBSU1M8mQ+DCKkbWsEO5S9D66IZRGHlsjhrTOtCNlv7emm5bCER+CH
         HpbhmoKthSMn5oat7cTEiBpZo2tM25mnoInY8CkA/8c2nq0FhJxLKSjhIXs/8J8mQAgX
         UwoDuIuSbtFrltuNH2oMFZyO/uIY2XSTH3Ly7ZPt5Z1rCVvRFjIc2tlL4IQ4Q5jLcH8W
         fn/A==
X-Gm-Message-State: APjAAAXfzK9IXqtjq4Un5KbaJAKBCn5B5kWht3QLUdrtGJ/OO8RcLMzG
        X4nHi/GdeRbOY1gYYFAAgDniKrMGWYI=
X-Google-Smtp-Source: APXvYqy18YTMHTmsQtbPEoXoAUceg/dijB8njyNN8CyMsWTKA8WbywApC0tG0gzxSISQAikX1CPuCg==
X-Received: by 2002:a05:6000:92:: with SMTP id m18mr13475716wrx.105.1572228443657;
        Sun, 27 Oct 2019 19:07:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l26sm9675833wmg.3.2019.10.27.19.07.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 19:07:23 -0700 (PDT)
Message-ID: <5db64d5b.1c69fb81.6f966.23ca@mx.google.com>
Date:   Sun, 27 Oct 2019 19:07:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.3.7-198-g740177dc0d52
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 141 boots: 0 failed,
 134 passed with 7 offline (v5.3.7-198-g740177dc0d52)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 141 boots: 0 failed, 134 passed with 7 offline =
(v5.3.7-198-g740177dc0d52)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.7-198-g740177dc0d52/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.7-198-g740177dc0d52/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.7-198-g740177dc0d52
Git Commit: 740177dc0d52947b60a2566de1f76404c4466c6a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 25 SoC families, 17 builds out of 208

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
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
