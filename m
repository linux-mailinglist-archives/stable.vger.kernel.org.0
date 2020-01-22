Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2F1458CC
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 16:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgAVPaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 10:30:18 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37079 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVPaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 10:30:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so7775343wru.4
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 07:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CgAFQSqwSjkV/DuXkxY5ZVWLWiOcGCKblH1ZrGP8iVY=;
        b=PMN5M6Hvj+QsIPwpX0Ll6kJFbfFMC9B9bJa8tqQzqAKnXvJ5YnM0mcbZDNZrjtdqdD
         +do++stmhmx+xxyWmzb5bcHGJ2A+3XF+nZ7Di7fsJWjTKnP1OuYTwKVUwGAC0oNmEO9e
         fsCTXebPZRTNb3Nmly5uSQdILX9QXvCBMYpH81IL+hYGShx8GujPrzarqbCSSbBzWcVB
         hdRiTww5Hd8A8HNVMKCqcgOj2xcv0kDU1FZRxpOmkhPWLRX66XBd5G8hoTnkJ8cApIzQ
         DhVEixQiYfjUkBUbXC+PwpzjDowygSh/k0/jJ3uHMRjqo5ffc/oiWZ+RZnVwqTnmynni
         evqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CgAFQSqwSjkV/DuXkxY5ZVWLWiOcGCKblH1ZrGP8iVY=;
        b=PYzmo+98ZQJfhsQvU3sfpzS12DCXw1mWv8oEI2g6f61N6YJb2Hi2gaXERBZzkVkz1v
         lvD0+gimpYL3atFUABl/bGrFewvS7HHc81bQNSzkN7dz4Hu4Pc63FQXwOYlEl7IYGmOS
         pRBST//NajBEtsPWCcWtHnFvKyqwizDMy1vlQlqK7GfotJXh4IIH3YhhoAxbucHOTyJ9
         FI9k4DmBzt3m2Cobn6zTPlYJ1ObGUz6tMV0edMSJf5KzJgP+Eh6s6i8r1RJ4bLsv/eX7
         r+0VfTgpnRMf3jHEO1uQftJr/QZ558aexax5MxfrhRqK9AZEBMp7OGVqHKl7CdWJGeMy
         qxDw==
X-Gm-Message-State: APjAAAUoVgH9TRnQ7Oo0gFHbji1RvKpFLuKDceG1KBsiKFq687J827TG
        3yR0oH8cCFxxwuYV72skoa2djRl/8sWJYA==
X-Google-Smtp-Source: APXvYqzH37plBv94TiQ31mXmiu3Edq0f+9kNm/hMfyeoN+2OiwTQwbclUnFinHsKOi5r981sF8/UYw==
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr12308290wrx.178.1579707015514;
        Wed, 22 Jan 2020 07:30:15 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i10sm58770254wru.16.2020.01.22.07.30.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:30:14 -0800 (PST)
Message-ID: <5e286a86.1c69fb81.48768.a1b6@mx.google.com>
Date:   Wed, 22 Jan 2020 07:30:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.97-104-g0ed30079b15d
Subject: stable-rc/linux-4.19.y boot: 125 boots: 2 failed,
 112 passed with 9 offline, 2 untried/unknown (v4.19.97-104-g0ed30079b15d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 125 boots: 2 failed, 112 passed with 9 offline=
, 2 untried/unknown (v4.19.97-104-g0ed30079b15d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.97-104-g0ed30079b15d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.97-104-g0ed30079b15d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.97-104-g0ed30079b15d
Git Commit: 0ed30079b15d245f5a148a4ff156dff23d9569df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 22 SoC families, 15 builds out of 192

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.9=
7-66-g6e319a78bc27 - first fail: v4.19.97-88-g854a2a8f9451)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.9=
7-66-g6e319a78bc27 - first fail: v4.19.97-88-g854a2a8f9451)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            meson-axg-s400: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
