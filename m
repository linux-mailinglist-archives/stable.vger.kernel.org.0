Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485BD147188
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 20:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgAWTL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 14:11:58 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37898 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgAWTL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 14:11:58 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so4383052wrh.5
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 11:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e1dPmvgr1Tb/jD6ya7wQJqqrC+nq/1TZy4Ocpo9CQr0=;
        b=ILHZitYjmLSMfyxaWklISzTimyioLOrRM33Uyp97SaeC+0orJkvLparhQRcsmNpYdH
         wQ8p7FYLLFmqk0Tuz383HBYO6jiLfJxZuhxkzBklh5q1n06lG4JcgrckRknXt2vMGZ8h
         tVWClKDQpNtSIUwXPY8qxdjGf1sa0oEaeFvqaL063hfbgApwvSAF17CX5oxINmrNpy3f
         0vudcwIfQb6CAYtFNo5XLFOhpaKBE/sJU4KGqjM9MFUaTFxZCzTR5VbbH778vwwrfJET
         sQMnUqUi6qYtxNLq03YKqfzQ8HLFa5VEsuN4s/1vp6nVWzCPJp3jMDlNMnJf7lCDXDBV
         oeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e1dPmvgr1Tb/jD6ya7wQJqqrC+nq/1TZy4Ocpo9CQr0=;
        b=GlXx4Rv3IuaOmD49q/eATgqiYJJ5PSwp24D3TuJHb5iYJYPyG8v/0wcaMkXuGt5Fxj
         v7G7DxSP3vOPHUrksChGT50o13NcGK/33dQjYWPY++LIZ00jwvUtbmn4smNVY4iHwDwN
         CBFaJ6j79AYkwuRwdIqTw/4vb5jn7ix5KYOIQBvI/u+I5UD/nXFaY1BlwfcghkMJZnfn
         NAo158pIQ46L3XdEiBpCAeZxz5ThomDjQrgeEPjiqXjsI+Fmbi5BYzQ9KGu5avv2EmGD
         O35MEAOkFxh7RvsrwPxhzIBnWAUvDgxv/sDEGDBIvOgPqS+OO2tRHVbMFm2vUFWZVKZM
         Jr7g==
X-Gm-Message-State: APjAAAWIyJE2GOfFho1tx8Jv1eFdH91fQ7zWtChqr+L/AryveIkHWoTY
        oHfnuaDs/S3+U1pMxRN4BV6a+pngZ4iV3g==
X-Google-Smtp-Source: APXvYqwgSxqFODnnhXZU3GM9RwGBDY0r/DiIYXtVFWlGMlsaZE7dRfZ82JD9QDpVw2Y0aqt0tHCkbA==
X-Received: by 2002:adf:f70b:: with SMTP id r11mr17321896wrp.388.1579806715981;
        Thu, 23 Jan 2020 11:11:55 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b17sm4237917wrp.49.2020.01.23.11.11.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 11:11:55 -0800 (PST)
Message-ID: <5e29effb.1c69fb81.8e843.2321@mx.google.com>
Date:   Thu, 23 Jan 2020 11:11:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.98
Subject: stable-rc/linux-4.19.y boot: 128 boots: 1 failed,
 118 passed with 6 offline, 3 untried/unknown (v4.19.98)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 128 boots: 1 failed, 118 passed with 6 offline=
, 3 untried/unknown (v4.19.98)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.98/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.98/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.98
Git Commit: d183c8e2647a7d45202c14a33631f6c09020f8ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 24 SoC families, 16 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
