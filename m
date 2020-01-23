Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958CF147300
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 22:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAWVPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 16:15:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36087 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbgAWVPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 16:15:09 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so4079944wma.1
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 13:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zguublrQU35lxdsJ5oWsTafmqjw9i1yrfO81D1GEv20=;
        b=kCxW06wOmoJO1HEqEhUIBkPCzAn9QiACmDTkCcxyrr/akkek3afuL/NrT/sHB4FGBG
         x9OMyiPrXgQD9yLVnucnRrBCngOtSVEL/7TfsE3GJlvJsfaHIKomabnFdIOj0+ugB/xO
         BjuldbI7GEDY/s1A5XkYVQWTaPA1pXchrjwnjYIZ8z8vheRM4H/T3WGRIHbgUTgpep+y
         S8JexhYns330HZnzc4K7kXQET9xW7WbCaBo8606OQ1vRPJgHUAMaPOTAsrIT8Y32J55+
         SYzOtfsUEeN4TawsGTuhGlAU6zcreKD02lfweQBCfFyWlWnNLd2HOH3EbTF5SAoL0/iL
         yiVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zguublrQU35lxdsJ5oWsTafmqjw9i1yrfO81D1GEv20=;
        b=jqNe2UNFdJOj7X7X7v6COJAtQGCGycWfKYLwj/N3ggBck/PuI5Kw83wgd2XZgoEJ63
         198thMDOJsY+dhAV6l8yb49/jNTRxpok2LC7w4KYlHNZqlBqEC3sQnTweuJ04gYhGICr
         3BPYvApNjAYf+v/VpEhEGq2Oyr6R9kUho8nMxAE4Vs3mJ/ufmbIoXIboOYGqTR8KBeB1
         /J1vEYt0Urylte8uu1xrembfS3AeqYHdsFt6ZI8C5Ogv4WJCgUVeVvZeu/0FQDonVrIV
         WGLP3Zejx6xCp7QAjOME2wcL9yKiASus6RxT1P2RTMqojHtnggbVUDlIuOo4dJA4quNI
         usag==
X-Gm-Message-State: APjAAAVb9oXtpg9/wdKKujx5p3BarYtY2jBY8BlU1tGPL3qrWvmGfbUT
        6fye6EqLJkEFSKmZB7JJprX5lBGXqq6jMg==
X-Google-Smtp-Source: APXvYqx5UlbHAUZ9Tt0h238Qz9vDsUcy2u1sTlenhGHGsax0zGCNHk+ypCaw6G839KsF+7niIrdcbw==
X-Received: by 2002:a1c:a796:: with SMTP id q144mr226246wme.6.1579814106984;
        Thu, 23 Jan 2020 13:15:06 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm4710678wru.38.2020.01.23.13.15.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 13:15:06 -0800 (PST)
Message-ID: <5e2a0cda.1c69fb81.eeb1d.4565@mx.google.com>
Date:   Thu, 23 Jan 2020 13:15:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.167
Subject: stable-rc/linux-4.14.y boot: 123 boots: 3 failed,
 113 passed with 5 offline, 2 untried/unknown (v4.14.167)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 3 failed, 113 passed with 5 offline=
, 2 untried/unknown (v4.14.167)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.167/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.167/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.167
Git Commit: 8bac50406cca10a219aa899243d49c57ddaf7c5b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 22 SoC families, 15 builds out of 191

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.166-66-gb=
b5af942ee10)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.166-66-gb=
b5af942ee10)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.14.166-66-gb=
b5af942ee10)
          sun8i-a83t-bananapi-m3:
              lab-clabbe: failing since 1 day (last pass: v4.14.166-56-g491=
53e6f7d26 - first fail: v4.14.166-66-gbb5af942ee10)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

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
