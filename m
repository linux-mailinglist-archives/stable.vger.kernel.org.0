Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B949105A6D
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 20:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUTgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 14:36:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36276 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUTgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 14:36:49 -0500
Received: by mail-wm1-f68.google.com with SMTP id n188so3151351wme.1
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 11:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=swBBKlwijdY3sNbX9rDD2ADbdrjsLCqKDO3vbVXfXII=;
        b=arcvkFTmhUcHTxUuDg6E3tbkxyda/44k+sIHfTseVpcS4pvXCTp05xwqNOILh0+/Ab
         CFEiXJU+fPILNI+MACJHooe4m+fU0KKX8rv2BUnii04yJasU//5OnZ0/zbnr5QhPoZ1X
         Ask+fnu3Ct2avW6LwbpezeMMDfxskElfwtnrD0nSl4v+Dp7fkNnKsSUqIrjtqVWSC2en
         fwZ737OXfTilI2JsPhUjN+0yfwcihuq7uB6QZRiUulPK51hjJftvn6j+8I4Y1iOJclnK
         aUsglHwgDloRGEt69j4d7zm/K98nHLAM2qIOV2NoCF6uAlYgbLYNBtT+9+d5euOJuLrD
         gIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=swBBKlwijdY3sNbX9rDD2ADbdrjsLCqKDO3vbVXfXII=;
        b=YPqZv3DpJxik0Tz8iXclirSoByQvyT+4Ozo/7EgG//FwjNWSgnQc8wRFCAWhKDHyTN
         lLZa1P8JmpEL+xy/yV6KRkDsg/TKPH1uy8grjkkoeTxaVw0QD3ooFzqThTOnr1SAyxqA
         GSQbXFQ/QbgrMTLp4oMqKtaVr9A1xNNhJD86Nv2k9DFcFDUle5gmdFKPfueLjwxmPgBc
         n9cybidgZRct3ilzRXbr4OgtfTbVq9af3YIefv4rhmCwL6dnE5ktVucccbiqzT2hqtSz
         6ILcyzt1T/AQWOiiWGi5Kd6nxj45cs+n+fuhe2eXD72rVzmdSwjFMkUlOvL3nAt1eWCk
         csvA==
X-Gm-Message-State: APjAAAUTFJH+njeH3seQNH37KWT9i+GXkqAkS1RvPy7xZV9E0lBGUUih
        2q/pU7Ej4mKGfHI9fOWDqICoWhIGick91w==
X-Google-Smtp-Source: APXvYqyZwKlh59J5nkaQqCjb4brXUYiFRFUR27rviy3LPtu2vjHcXMM8U+YhX0km/q0jMJ4g2atlNg==
X-Received: by 2002:a7b:c0da:: with SMTP id s26mr12065948wmh.6.1574365006503;
        Thu, 21 Nov 2019 11:36:46 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s9sm649553wmj.22.2019.11.21.11.36.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 11:36:45 -0800 (PST)
Message-ID: <5dd6e74d.1c69fb81.1b1f6.42a2@mx.google.com>
Date:   Thu, 21 Nov 2019 11:36:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.155
Subject: stable-rc/linux-4.14.y boot: 126 boots: 4 failed,
 117 passed with 5 offline (v4.14.155)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 4 failed, 117 passed with 5 offline=
 (v4.14.155)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.155/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.155/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.155
Git Commit: f56f3d0e65adb447b8b583c8ed4fbbe544c9bfde
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 22 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 2 days (last pass: v4.14.154 - f=
irst fail: v4.14.154-240-g8dd59dbecd7d)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 2 days (last pass: v4.14.154 - fi=
rst fail: v4.14.154-240-gab050cd3bb84)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
