Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10BD8F975
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 05:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfHPDbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 23:31:34 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:43795 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfHPDbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 23:31:34 -0400
Received: by mail-wr1-f43.google.com with SMTP id y8so171771wrn.10
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 20:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oZj3R6k6yNnrV3Ggmid/SWcBR8D89o/kFZ0MB+Dto8Y=;
        b=lsN7gKGOuMlIPexi+aeU8O2+pPtZTLPhStpHj24HsFeYWM2wGoqYIGosX/58wim4qv
         KoczDy/sL4Igtz0dsXR4MiLpI8wFgM6k76zk27f+LkPXoYGwqjoyhbCryfoyQa/XsSc2
         G21jfxL0ExL2svAs6MygXPu9Ecx/FlVj9wP87Ojgp5neTbiErV6TQbxj+xOlTPt+W5gM
         vUY8rkQM9VRAg+isdenAWy4EcVr+LYoKbqRKkWMq40NEYdNf+ACo8o9PimghHjcp17rc
         PlyKzuRIJU3GK9wL7361dxhugphv58wpgjOQU9hpYlXeCnIXOjBV4q1H0yX5w6YD81Nx
         ZrSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oZj3R6k6yNnrV3Ggmid/SWcBR8D89o/kFZ0MB+Dto8Y=;
        b=HDwRd8mEgCFGOyKwqinO624AVqpJFmHdydY0yLXe6h5gWaDvBtJvpY8QwYNXlJDz7U
         PW0AkL/SYX5ZzBM9FE0g7pcrzFDzIvTM3DXnw7dYDmVsQRD8JOl9jKvYy2v19EMs96Wh
         K2lthNQboelG/5es62N5yUsxrjIXI51bYdEhQiiM4/A/lMAYSRgC9NP7koLgeaiFhkAF
         PIc/5AZrStIhsyRqHKmYGO6Wychl6BGeFU27hqXtekkMkVStxEyLaHmlxEM/lIbiYNim
         mDzBG3fnwrojNYXsViLGdkLbUzzZLKbDkWO2hFtgfnD7x2kZfbZfLVLAUOjiRJgGHtTL
         uxGA==
X-Gm-Message-State: APjAAAWTCaSJKYi9km1rQxW9+bkbBwi5q1cdyxV4Ut+19xUqoTHYrj2z
        mVp5giFE84x9ZcTBPKHEbmANS6JQKZ8=
X-Google-Smtp-Source: APXvYqyV+t3DxQG+sofcxSjp5Gw2HPvmDZwLw2S7V+sNgvv6zs5HEb9PayEkm43StdFw0UOX9Xjp4A==
X-Received: by 2002:adf:ec8e:: with SMTP id z14mr8336399wrn.269.1565926291927;
        Thu, 15 Aug 2019 20:31:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r190sm4498034wmf.0.2019.08.15.20.31.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 20:31:30 -0700 (PDT)
Message-ID: <5d562392.1c69fb81.4c562.6da7@mx.google.com>
Date:   Thu, 15 Aug 2019 20:31:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-42-g9a2a343109e5
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 90 boots: 0 failed,
 82 passed with 8 offline (v4.9.189-42-g9a2a343109e5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 90 boots: 0 failed, 82 passed with 8 offline (v=
4.9.189-42-g9a2a343109e5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-42-g9a2a343109e5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-42-g9a2a343109e5/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-42-g9a2a343109e5
Git Commit: 9a2a343109e5f5850c69bbaf3a8f0171e6508698
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 22 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
