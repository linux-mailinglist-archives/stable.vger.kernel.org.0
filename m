Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1B6ACA94
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 06:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfIHEOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 00:14:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55920 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfIHEOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 00:14:43 -0400
Received: by mail-wm1-f65.google.com with SMTP id g207so10180110wmg.5
        for <stable@vger.kernel.org>; Sat, 07 Sep 2019 21:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4TVDLj7hxQd8Nb4k1CVFMu+EXpLlShSjoHHiwaFQ96Y=;
        b=HvRNCEtE4YpLLREnlc5uemcP7olh7Og7Qk3hbyOCnHjGVIyaRFSCLEqV/oTNMFB4mi
         YchiaMPdVeQoNZ+upTi0+k3LBaTf99yrC4r7JWqsjK8QRrCwPUUGLwgLWaWm6w/dyqRW
         ClC3ASbKSgY53TntifygcmrLtmhZIK6G+JVYMZVwalZ4CacTioFqFjHc6Wl7tv5VWFrT
         9be/R00n3noTlJ1ILX+DQGNcb3qMjxQy2wkIpseu/IVKokjWdpk0eK7obIb9QJ0570hl
         gTHwzZDmpnpWicuFmbUJMfpDYdq1etYRimCg/i9cT1oUyZ+md2jAt+YJeoMbAhABgCoo
         8l6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4TVDLj7hxQd8Nb4k1CVFMu+EXpLlShSjoHHiwaFQ96Y=;
        b=JnKjf6UPYgvey43Mcf0uMBz5gk0NRiFe1QPyqwBN3/ZhgGsZJQsHpt8A367VphVzAn
         gBKW4uQHbl68vUeBs/1FINy1Yg5vXaxSUzbLLSNbbUzDj9+pqfZYsWItFxTgmHO3+nff
         m73xRb/tSLcN8rNroUPr6bii3wx17b3VXGALesUTmhHWa9ek5JOyLRaP5z4VDPwEBH1p
         8YVjEEdiB2VcgGe//8aABVtDKpqa8bRMOofAbqnxxUCkV6GY5+J7r9uuFQfQBxLpuJFm
         S9ySptjfdi8wt0Iv/cujIXaMU+LixwibLknXSc5MrRaOmrSmYJ8A0TI5Av65DHQbNff1
         iA7g==
X-Gm-Message-State: APjAAAW6kEgR56h6UhEOrC5K/0Bju7Ay2CNv5VwuDGNYjXHPFeEoWrH5
        d176z5hc4q25vpYmwE03wtpH8mPW9dw=
X-Google-Smtp-Source: APXvYqxks5uVhUoJlu6ijxYSiciNFvwCGkyuMK7795rRlkdk93JX9b82UFOGepDJYuXjXiPsRPSJ2g==
X-Received: by 2002:a1c:c00e:: with SMTP id q14mr14125551wmf.14.1567916081223;
        Sat, 07 Sep 2019 21:14:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q25sm9152437wmj.22.2019.09.07.21.14.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 21:14:40 -0700 (PDT)
Message-ID: <5d748030.1c69fb81.4354f.9734@mx.google.com>
Date:   Sat, 07 Sep 2019 21:14:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.70-51-g1c5dffb85612
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 138 boots: 1 failed,
 128 passed with 8 offline, 1 untried/unknown (v4.19.70-51-g1c5dffb85612)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 138 boots: 1 failed, 128 passed with 8 offline=
, 1 untried/unknown (v4.19.70-51-g1c5dffb85612)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.70-51-g1c5dffb85612/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.70-51-g1c5dffb85612/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.70-51-g1c5dffb85612
Git Commit: 1c5dffb856121de7114a4fdadbc28aa19bb74838
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 15 builds out of 206

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-cubietruck: 1 failed lab

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
