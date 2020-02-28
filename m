Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B653E17403F
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 20:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgB1Tcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 14:32:48 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43698 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1Tcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 14:32:48 -0500
Received: by mail-pf1-f193.google.com with SMTP id s1so2205526pfh.10
        for <stable@vger.kernel.org>; Fri, 28 Feb 2020 11:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0zkEt49Z/79B3V1bDnAjyxWjqVrBxfdtHCgHKfEQkKo=;
        b=CeGfx/c4d3XF21MBkJrAsCKLhim2GM47XU3btbD+eW3s4LiUK/iry57LAdJ9W4VNok
         yn4SEICraqQGj42Gq6RrQ4g9HpHn0HaPMfd+cOB8DKZgkEeRJCfW4JbD4R6PKhdBI0kB
         wz/Hsme+c780UP5gwzauI+MmyXUIc7e4JuWfOoCkdf4CvL41vnDDCf+KaQmgYzvXr5W2
         Xf+nxAwBmjTzq/gx/k68oTC2ln/Ryj+6IawnpWcOQ/CaIGZ5ATNVvCw2p5yxBBuMKBNz
         /lbmuGKt8O7qJBDoIgQNMuEYeYO4JFYZe6etnOsmaRFHCEmh1q3LHJETaHeBgnDZPkOC
         PE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0zkEt49Z/79B3V1bDnAjyxWjqVrBxfdtHCgHKfEQkKo=;
        b=p+eZxrUSyvhm1FYxiTisszWsrNvlyK9F3a07rM+AEnZ2sXGwKwst79KOcv7saF9Ynx
         qXsOnJBm4UWmuqF+6UlpvkINEHVwBMvIXqm476AlkB3Rqlr/TxG72uKqOIbGvz0NsI/j
         SqhT3gNxSlt12W7eEPlC43/XmIKAwnN7wTC5IJUtk6ORCpc1RsvrWtjfEP/NfAe81AXq
         /Dlts9HWcNkDCZdA+6t7hWy4s4VxnRzWe9Tcxe/f9CAwodUNFYdhE9nMxUZvrU5wsd8o
         b4ErnUYTpMMVTkUgMfd1j9NMt5zwp7SVSzcV+Rh/VRwwEKFlzuGlIKpEHAWMtKpUjun6
         +TWw==
X-Gm-Message-State: APjAAAV0hAFXY2RsvEjmVu6z07bRBS2CAxyQ+lAhysNTpbZyVShpuIVm
        yEjiq9th1zcoglWT9q7T9erH8Wxrpt4=
X-Google-Smtp-Source: APXvYqyeZOrHP2haCTCb+MCIxH5vIYZMwH94bQMbu1a4h3mLCL1toORgWH9YFCJ0wQz6uUcSgA5OuA==
X-Received: by 2002:a63:e257:: with SMTP id y23mr6183504pgj.104.1582918365399;
        Fri, 28 Feb 2020 11:32:45 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r9sm12131396pfl.136.2020.02.28.11.32.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 11:32:44 -0800 (PST)
Message-ID: <5e596adc.1c69fb81.bd76c.fc80@mx.google.com>
Date:   Fri, 28 Feb 2020 11:32:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.171-235-g7184e90f61c3
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 52 boots: 2 failed,
 49 passed with 1 untried/unknown (v4.14.171-235-g7184e90f61c3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 52 boots: 2 failed, 49 passed with 1 untried/u=
nknown (v4.14.171-235-g7184e90f61c3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.171-235-g7184e90f61c3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.171-235-g7184e90f61c3/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.171-235-g7184e90f61c3
Git Commit: 7184e90f61c31071541613bb1c23e6303d85d298
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 13 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 8 days (last pass: v4.14.170-141-=
g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.171-238-g47e811c=
62a4a)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
